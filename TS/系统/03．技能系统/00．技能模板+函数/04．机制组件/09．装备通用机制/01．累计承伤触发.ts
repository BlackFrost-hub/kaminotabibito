/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export interface 累计承伤事件 {
  单位: any;
  攻击者: any;
  本次伤害: number;
  累计伤害: number;
  阈值: number;
  伤害快照: any;
}

export interface 累计承伤触发参数 {
  名称?: string;
  单位?: any;
  窗口秒: number;
  固定阈值?: number;
  最大生命比例阈值?: number;
  触发后清空?: boolean;
  内置CD秒?: number;
  过滤伤害?: (this: void, event: 累计承伤事件) => boolean;
  on触发: (this: void, event: 累计承伤事件) => void;
}

export interface 累计承伤触发控制器 {
  readonly 名称: string;
  读取累计伤害(单位: any): number;
  清空(单位?: any): void;
  停止(): void;
}

interface 承伤记录 {
  时间毫秒: number;
  伤害: number;
}

interface 单位承伤状态 {
  单位: any;
  记录: 承伤记录[];
  下次允许毫秒: number;
}

const 累计承伤控制器表: Record<number, 累计承伤触发实现> = {};
let 累计承伤控制器计数 = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

class 累计承伤触发实现 implements 累计承伤触发控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 累计承伤触发参数;
  private 状态表: Record<number, 单位承伤状态> = {};
  private 已停止 = false;

  constructor(名称: string, 参数: 累计承伤触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++累计承伤控制器计数;
    累计承伤控制器表[this.控制器ID] = this;
  }

  处理伤害(target: any, attacker: any, applied: number, snapshot: any): void {
    if (this.已停止 || applied <= 0) return;
    if (this.参数.单位 != null && 取单位ID(this.参数.单位) !== 取单位ID(target)) return;
    const id = 取单位ID(target);
    if (id === 0) return;
    const now = getServerTime();
    const 状态 = this.取或建状态(target);
    if (now < 状态.下次允许毫秒) return;

    状态.记录.push({ 时间毫秒: now, 伤害: applied });
    this.清理过期记录(状态, now);
    const 累计伤害 = this.计算累计(状态);
    const 阈值 = this.计算阈值(target);
    if (阈值 <= 0 || 累计伤害 < 阈值) return;

    const event: 累计承伤事件 = { 单位: target, 攻击者: attacker, 本次伤害: applied, 累计伤害, 阈值, 伤害快照: snapshot };
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(event)) return;
    this.参数.on触发(event);
    if (this.参数.触发后清空 !== false) 状态.记录 = [];
    const cd = this.参数.内置CD秒 ?? 0;
    if (cd > 0) 状态.下次允许毫秒 = now + cd * 1000;
  }

  读取累计伤害(单位: any): number {
    const 状态 = this.状态表[取单位ID(单位)];
    if (状态 == null) return 0;
    this.清理过期记录(状态, getServerTime());
    return this.计算累计(状态);
  }

  清空(单位?: any): void {
    if (单位 == null) {
      this.状态表 = {};
      return;
    }
    delete this.状态表[取单位ID(单位)];
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.状态表 = {};
    delete 累计承伤控制器表[this.控制器ID];
  }

  private 取或建状态(单位: any): 单位承伤状态 {
    const id = 取单位ID(单位);
    let 状态 = this.状态表[id];
    if (状态 == null) {
      状态 = { 单位, 记录: [], 下次允许毫秒: 0 };
      this.状态表[id] = 状态;
    }
    return 状态;
  }

  private 清理过期记录(状态: 单位承伤状态, now: number): void {
    const 最早毫秒 = now - this.参数.窗口秒 * 1000;
    for (let i = 状态.记录.length - 1; i >= 0; i--) {
      if (状态.记录[i].时间毫秒 >= 最早毫秒) continue;
      状态.记录.splice(i, 1);
    }
  }

  private 计算累计(状态: 单位承伤状态): number {
    let total = 0;
    for (let i = 0; i < 状态.记录.length; i++) total += 状态.记录[i].伤害;
    return total;
  }

  private 计算阈值(单位: any): number {
    let 阈值 = this.参数.固定阈值 ?? 0;
    if (this.参数.最大生命比例阈值 != null && this.参数.最大生命比例阈值 > 0) {
      const hpValue = GetUnitStateJapi(单位, UNIT_STATE_MAX_LIFE) * this.参数.最大生命比例阈值;
      if (阈值 <= 0 || hpValue < 阈值) 阈值 = hpValue;
    }
    return 阈值;
  }
}

export function 创建累计承伤触发器(this: void, 参数: 累计承伤触发参数): 累计承伤触发控制器 {
  return new 累计承伤触发实现(参数.名称 ?? "累计承伤触发", 参数);
}

function on累计承伤最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 累计承伤控制器表) {
    const 控制器 = 累计承伤控制器表[key];
    if (控制器 != null) 控制器.处理伤害(target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on累计承伤最终伤害);
