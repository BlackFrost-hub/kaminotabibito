/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 取单位默认脱战时间秒, 取单位默认脱战主体类型, 脱战伤害阈值比例 } = require("系统.00．核心系统.03．脱战系统.00．脱战规则") as {
  取单位默认脱战时间秒: (this: void, unit: any, 指定主体类型?: "玩家英雄" | "Boss" | "普通单位") => number;
  取单位默认脱战主体类型: (this: void, unit: any) => "玩家英雄" | "Boss" | "普通单位";
  脱战伤害阈值比例: number;
};

export interface 战斗状态事件 {
  单位: any;
  对方单位?: any;
  已战斗毫秒: number;
  距离上次战斗毫秒: number;
}

export interface 战斗状态触发参数 {
  名称?: string;
  单位: any;
  主体类型?: "玩家英雄" | "Boss" | "普通单位";
  战斗保持秒?: number;
  检查间隔毫秒?: number;
  周期触发秒?: number;
  持续战斗秒?: number;
  过滤战斗事件?: (this: void, target: any, attacker: any, applied: number, snapshot: any) => boolean;
  on进入战斗?: (this: void, event: 战斗状态事件) => void;
  on脱离战斗?: (this: void, event: 战斗状态事件) => void;
  on周期触发?: (this: void, event: 战斗状态事件) => void;
  on持续战斗满足?: (this: void, event: 战斗状态事件) => void;
}

export interface 战斗状态触发控制器 {
  readonly 名称: string;
  是否战斗中(): boolean;
  刷新战斗(对方单位?: any): void;
  停止(): void;
}

const 战斗状态控制器表: Record<number, 战斗状态触发实现> = {};
let 战斗状态控制器计数 = 0;
let 战斗状态TickID = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

function 取战斗状态主体类型(this: void, 单位: any, 指定主体类型?: "玩家英雄" | "Boss" | "普通单位"): "玩家英雄" | "Boss" | "普通单位" {
  return 指定主体类型 ?? 取单位默认脱战主体类型(单位);
}

function 受伤达到进入战斗阈值(this: void, 单位: any, 主体类型: "玩家英雄" | "Boss" | "普通单位", applied: number): boolean {
  if (主体类型 !== "玩家英雄") return true;
  const 最大生命 = GetUnitState(单位, UNIT_STATE_MAX_LIFE);
  if (!(最大生命 > 0)) return applied > 0;
  return applied >= 最大生命 * 脱战伤害阈值比例;
}

function 确保战斗状态Tick(this: void, interval: number): void {
  if (战斗状态TickID !== 0) return;
  战斗状态TickID = addPeriodicCallback(interval, on战斗状态Tick);
}

function 尝试停止战斗状态Tick(this: void): void {
  for (const key in 战斗状态控制器表) {
    if (战斗状态控制器表[key] != null) return;
  }
  if (战斗状态TickID !== 0) {
    removePeriodicCallback(战斗状态TickID);
    战斗状态TickID = 0;
  }
}

class 战斗状态触发实现 implements 战斗状态触发控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 战斗状态触发参数;
  private 已停止 = false;
  private 战斗中 = false;
  private 战斗开始毫秒 = 0;
  private 上次战斗毫秒 = 0;
  private 下次周期毫秒 = 0;
  private 已触发持续满足 = false;
  private 最近对方单位: any = null;

  constructor(名称: string, 参数: 战斗状态触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++战斗状态控制器计数;
    战斗状态控制器表[this.控制器ID] = this;
    const interval = 参数.检查间隔毫秒 ?? 200;
    确保战斗状态Tick(interval);
  }

  是否战斗中(): boolean {
    return this.战斗中;
  }

  刷新战斗(对方单位?: any): void {
    if (this.已停止 || !单位有效(this.参数.单位)) return;
    const now = getServerTime();
    this.最近对方单位 = 对方单位;
    this.上次战斗毫秒 = now;
    if (!this.战斗中) {
      this.战斗中 = true;
      this.战斗开始毫秒 = now;
      this.下次周期毫秒 = this.取周期触发毫秒(now);
      this.已触发持续满足 = false;
      if (this.参数.on进入战斗 != null) this.参数.on进入战斗(this.创建事件(now));
    }
  }

  处理伤害(target: any, attacker: any, applied: number, snapshot: any): void {
    if (this.已停止 || applied <= 0) return;
    const 单位ID = 取单位ID(this.参数.单位);
    if (单位ID === 0) return;
    const 目标匹配 = 取单位ID(target) === 单位ID;
    const 攻击者匹配 = 取单位ID(attacker) === 单位ID;
    if (!目标匹配 && !攻击者匹配) return;
    if (this.参数.过滤战斗事件 != null && !this.参数.过滤战斗事件(target, attacker, applied, snapshot)) return;
    if (攻击者匹配) {
      this.刷新战斗(target);
      return;
    }
    const 主体类型 = 取战斗状态主体类型(this.参数.单位, this.参数.主体类型);
    if (!受伤达到进入战斗阈值(this.参数.单位, 主体类型, applied)) return;
    this.刷新战斗(attacker);
  }

  Tick(): void {
    if (this.已停止) return;
    if (!单位有效(this.参数.单位)) {
      this.停止();
      return;
    }
    if (!this.战斗中) return;
    const now = getServerTime();
    const 保持秒 = this.参数.战斗保持秒 ?? 取单位默认脱战时间秒(this.参数.单位, this.参数.主体类型);
    const 保持毫秒 = 保持秒 * 1000;
    if (now - this.上次战斗毫秒 > 保持毫秒) {
      const event = this.创建事件(now);
      this.战斗中 = false;
      this.战斗开始毫秒 = 0;
      this.上次战斗毫秒 = 0;
      this.下次周期毫秒 = 0;
      this.已触发持续满足 = false;
      if (this.参数.on脱离战斗 != null) this.参数.on脱离战斗(event);
      return;
    }
    const 持续战斗秒 = this.参数.持续战斗秒 ?? 0;
    if (!this.已触发持续满足 && 持续战斗秒 > 0 && now - this.战斗开始毫秒 >= 持续战斗秒 * 1000) {
      this.已触发持续满足 = true;
      if (this.参数.on持续战斗满足 != null) this.参数.on持续战斗满足(this.创建事件(now));
    }
    if (this.参数.周期触发秒 != null && this.参数.周期触发秒 > 0 && now >= this.下次周期毫秒) {
      if (this.参数.on周期触发 != null) this.参数.on周期触发(this.创建事件(now));
      this.下次周期毫秒 = this.取周期触发毫秒(now);
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 战斗状态控制器表[this.控制器ID];
    尝试停止战斗状态Tick();
  }

  private 创建事件(now: number): 战斗状态事件 {
    return {
      单位: this.参数.单位,
      对方单位: this.最近对方单位,
      已战斗毫秒: this.战斗开始毫秒 > 0 ? now - this.战斗开始毫秒 : 0,
      距离上次战斗毫秒: this.上次战斗毫秒 > 0 ? now - this.上次战斗毫秒 : 0,
    };
  }

  private 取周期触发毫秒(now: number): number {
    const sec = this.参数.周期触发秒 ?? 0;
    return sec > 0 ? now + sec * 1000 : 0;
  }
}

export function 创建战斗状态触发器(this: void, 参数: 战斗状态触发参数): 战斗状态触发控制器 {
  return new 战斗状态触发实现(参数.名称 ?? "战斗状态触发器", 参数);
}

function on战斗状态Tick(this: void): void {
  for (const key in 战斗状态控制器表) {
    const 控制器 = 战斗状态控制器表[key];
    if (控制器 != null) 控制器.Tick();
  }
}

function on战斗状态伤害事件(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 战斗状态控制器表) {
    const 控制器 = 战斗状态控制器表[key];
    if (控制器 != null) 控制器.处理伤害(target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on战斗状态伤害事件);
