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

export type 同目标普攻计数冷却作用域 = "攻击者目标" | "攻击者";

export interface 同目标普攻计数事件 {
  source: any;
  target: any;
  applied: number;
  snapshot: any;
  当前次数: number;
  窗口秒: number;
  次数阈值: number;
}

export interface 同目标普攻计数触发参数 {
  名称?: string;
  攻击者?: any;
  目标?: any;
  窗口秒: number;
  次数阈值: number;
  内置CD秒?: number;
  冷却作用域?: 同目标普攻计数冷却作用域;
  仅纯普攻?: boolean;
  允许技能普攻?: boolean;
  过滤?: (this: void, event: 同目标普攻计数事件) => boolean;
  on触发: (this: void, event: 同目标普攻计数事件) => void;
}

export interface 同目标普攻计数触发控制器 {
  readonly 名称: string;
  读取次数(攻击者: any, 目标: any): number;
  清空(攻击者?: any, 目标?: any): void;
  停止(): void;
}

interface 窗口事件计数器控制器 {
  readonly 名称: string;
  增加(key: string, 窗口秒: number, 触发后清空?: boolean, 触发阈值?: number): number;
  读取(key: string, 窗口秒?: number): number;
  清空(key?: string): void;
}

interface 普攻计数状态 {
  source: any;
  target: any;
}

const 同目标普攻计数控制器表: Record<number, 同目标普攻计数触发实现> = {};
let 同目标普攻计数控制器计数 = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

function 取配对键(this: void, source: any, target: any): string {
  const sourceID = 取单位ID(source);
  const targetID = 取单位ID(target);
  if (sourceID <= 0 || targetID <= 0) return "";
  return `${sourceID}:${targetID}`;
}

function 是纯普攻快照(this: void, snapshot: any): boolean {
  return snapshot != null
    && snapshot.isNormalAttack === true
    && snapshot.isSkillAttack !== true
    && snapshot.isSkillDamage !== true;
}

function 是允许的普攻快照(this: void, snapshot: any, 参数: 同目标普攻计数触发参数): boolean {
  if (snapshot == null || snapshot.isNormalAttack !== true) return false;
  const 只允许纯普攻 = 参数.允许技能普攻 !== true && 参数.仅纯普攻 !== false;
  if (!只允许纯普攻) return true;
  return 是纯普攻快照(snapshot);
}

class 同目标普攻计数触发实现 implements 同目标普攻计数触发控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 同目标普攻计数触发参数;
  private 状态表: Record<string, 普攻计数状态 | undefined> = {};
  private 计数器: 窗口事件计数器控制器;
  private 冷却表: Record<string, number | undefined> = {};
  private 已停止 = false;

  constructor(名称: string, 参数: 同目标普攻计数触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.计数器 = 创建窗口事件计数器(名称);
    this.控制器ID = ++同目标普攻计数控制器计数;
    同目标普攻计数控制器表[this.控制器ID] = this;
  }

  处理伤害(target: any, attacker: any, applied: number, snapshot: any): void {
    if (this.已停止 || !(applied > 0)) return;
    if (!单位有效(attacker) || !单位有效(target)) return;
    if (this.参数.攻击者 != null && 取单位ID(this.参数.攻击者) !== 取单位ID(attacker)) return;
    if (this.参数.目标 != null && 取单位ID(this.参数.目标) !== 取单位ID(target)) return;
    if (!是允许的普攻快照(snapshot, this.参数)) return;

    const key = 取配对键(attacker, target);
    if (key === "") return;

    const now = getServerTime();
    if (this.是否冷却中(attacker, target, now)) return;

    this.取或建状态(key, attacker, target);

    const 当前次数 = this.计数器.增加(key, this.参数.窗口秒);
    const 阈值 = this.参数.次数阈值;
    if (!(阈值 > 0) || 当前次数 < 阈值) return;

    const event: 同目标普攻计数事件 = {
      source: attacker,
      target,
      applied,
      snapshot,
      当前次数,
      窗口秒: this.参数.窗口秒,
      次数阈值: 阈值,
    };
    if (this.参数.过滤 != null && !this.参数.过滤(event)) return;

    this.参数.on触发(event);
    this.计数器.清空(key);
    this.进入冷却(attacker, target, now);
  }

  读取次数(攻击者: any, 目标: any): number {
    const key = 取配对键(攻击者, 目标);
    if (key === "") return 0;
    return this.计数器.读取(key, this.参数.窗口秒);
  }

  清空(攻击者?: any, 目标?: any): void {
    if (攻击者 == null && 目标 == null) {
      this.状态表 = {};
      this.冷却表 = {};
      this.计数器.清空();
      return;
    }
    if (攻击者 != null && 目标 != null) {
      const key = 取配对键(攻击者, 目标);
      if (key !== "") {
        delete this.状态表[key];
        delete this.冷却表[key];
        this.计数器.清空(key);
      }
      return;
    }
    const 攻击者ID = 攻击者 != null ? 取单位ID(攻击者) : 0;
    const 目标ID = 目标 != null ? 取单位ID(目标) : 0;
    for (const key in this.状态表) {
      const 状态 = this.状态表[key];
      if (状态 == null) continue;
      if (攻击者ID > 0 && 取单位ID(状态.source) !== 攻击者ID) continue;
      if (目标ID > 0 && 取单位ID(状态.target) !== 目标ID) continue;
      delete this.状态表[key];
      delete this.冷却表[key];
      this.计数器.清空(key);
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.状态表 = {};
    this.冷却表 = {};
    this.计数器.清空();
    delete 同目标普攻计数控制器表[this.控制器ID];
  }

  private 取或建状态(key: string, source: any, target: any): 普攻计数状态 {
    let 状态 = this.状态表[key];
    if (状态 == null) {
      状态 = { source, target };
      this.状态表[key] = 状态;
    }
    return 状态;
  }

  private 取冷却键(source: any, target: any): string {
    const sourceID = 取单位ID(source);
    if (sourceID <= 0) return "";
    if ((this.参数.冷却作用域 ?? "攻击者目标") === "攻击者") return `${sourceID}`;
    return 取配对键(source, target);
  }

  private 是否冷却中(source: any, target: any, now: number): boolean {
    const cd = this.参数.内置CD秒 ?? 0;
    if (cd <= 0) return false;
    const key = this.取冷却键(source, target);
    if (key === "") return false;
    const 下次允许 = this.冷却表[key];
    return 下次允许 != null && now < 下次允许;
  }

  private 进入冷却(source: any, target: any, now: number): void {
    const cd = this.参数.内置CD秒 ?? 0;
    if (cd <= 0) return;
    const key = this.取冷却键(source, target);
    if (key === "") return;
    this.冷却表[key] = now + cd * 1000;
  }
}

export function 创建同目标普攻计数触发器(this: void, 参数: 同目标普攻计数触发参数): 同目标普攻计数触发控制器 {
  return new 同目标普攻计数触发实现(参数.名称 ?? "同目标普攻计数触发", 参数);
}

export function 伤害快照是纯普攻(this: void, snapshot: any): boolean {
  return 是纯普攻快照(snapshot);
}

function on同目标普攻计数最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 同目标普攻计数控制器表) {
    const 控制器 = 同目标普攻计数控制器表[key];
    if (控制器 != null) 控制器.处理伤害(target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on同目标普攻计数最终伤害);

export {};
