/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建窗口事件计数器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.15．单位窗口累计值") as {
  创建窗口事件计数器: (this: void, 名称: string) => 窗口事件计数器控制器;
};

export interface 窗口承伤次数事件 {
  单位: any;
  攻击者: any;
  本次伤害: number;
  当前次数: number;
  窗口秒: number;
  次数阈值: number;
  伤害快照: any;
}

export interface 窗口承伤次数触发参数 {
  名称?: string;
  单位?: any;
  窗口秒?: number;
  次数阈值: number;
  触发后清空?: boolean;
  内置CD秒?: number;
  过滤伤害?: (this: void, event: 窗口承伤次数事件) => boolean;
  on触发: (this: void, event: 窗口承伤次数事件) => void;
}

export interface 窗口承伤次数触发控制器 {
  readonly 名称: string;
  读取次数(单位: any): number;
  清空(单位?: any): void;
  停止(): void;
}

interface 窗口事件计数器控制器 {
  readonly 名称: string;
  增加(key: string, 窗口秒: number, 触发后清空?: boolean, 触发阈值?: number): number;
  读取(key: string, 窗口秒?: number): number;
  撤销最近一次(key: string): number;
  清空(key?: string): void;
}

interface 单位承伤次数状态 {
  单位: any;
  下次允许毫秒: number;
}

const 窗口承伤次数控制器表: Record<number, 窗口承伤次数触发实现> = {};
let 窗口承伤次数控制器计数 = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

class 窗口承伤次数触发实现 implements 窗口承伤次数触发控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 窗口承伤次数触发参数;
  private 状态表: Record<number, 单位承伤次数状态 | undefined> = {};
  private 计数器: 窗口事件计数器控制器;
  private 已停止 = false;
  private 触发回调中 = false;

  constructor(名称: string, 参数: 窗口承伤次数触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.计数器 = 创建窗口事件计数器(名称);
    this.控制器ID = ++窗口承伤次数控制器计数;
    窗口承伤次数控制器表[this.控制器ID] = this;
  }

  处理伤害(target: any, attacker: any, applied: number, snapshot: any): void {
    if (this.已停止 || this.触发回调中 || !(applied > 0)) return;
    if (this.参数.单位 != null && 取单位ID(this.参数.单位) !== 取单位ID(target)) return;
    const id = 取单位ID(target);
    if (id === 0) return;

    const now = getServerTime();
    const 状态 = this.取或建状态(target);
    if (now < 状态.下次允许毫秒) return;
    const key = String(id);

    const 当前次数 = this.计数器.增加(key, this.参数.窗口秒 ?? 0);
    const 阈值 = this.参数.次数阈值;
    const event: 窗口承伤次数事件 = {
      单位: target,
      攻击者: attacker,
      本次伤害: applied,
      当前次数,
      窗口秒: this.参数.窗口秒 ?? 0,
      次数阈值: 阈值,
      伤害快照: snapshot,
    };
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(event)) {
      this.计数器.撤销最近一次(key);
      return;
    }
    if (!(阈值 > 0) || 当前次数 < 阈值) return;

    if (this.参数.触发后清空 !== false) this.计数器.清空(key);
    const cd = this.参数.内置CD秒 ?? 0;
    if (cd > 0) 状态.下次允许毫秒 = now + cd * 1000;
    this.触发回调中 = true;
    this.参数.on触发(event);
    this.触发回调中 = false;
  }

  读取次数(单位: any): number {
    const id = 取单位ID(单位);
    if (id === 0) return 0;
    return this.计数器.读取(String(id), this.参数.窗口秒 ?? 0);
  }

  清空(单位?: any): void {
    if (单位 == null) {
      this.状态表 = {};
      this.计数器.清空();
      return;
    }
    const id = 取单位ID(单位);
    delete this.状态表[id];
    this.计数器.清空(String(id));
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.状态表 = {};
    this.计数器.清空();
    delete 窗口承伤次数控制器表[this.控制器ID];
  }

  private 取或建状态(单位: any): 单位承伤次数状态 {
    const id = 取单位ID(单位);
    let 状态 = this.状态表[id];
    if (状态 == null) {
      状态 = { 单位, 下次允许毫秒: 0 };
      this.状态表[id] = 状态;
    }
    return 状态;
  }
}

export function 创建窗口承伤次数触发器(this: void, 参数: 窗口承伤次数触发参数): 窗口承伤次数触发控制器 {
  return new 窗口承伤次数触发实现(参数.名称 ?? "窗口承伤次数触发", 参数);
}

function on窗口承伤次数最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 窗口承伤次数控制器表) {
    const 控制器 = 窗口承伤次数控制器表[key];
    if (控制器 != null) 控制器.处理伤害(target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on窗口承伤次数最终伤害);

export {};
