/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { getGameTime, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const DzSetUnitMissileModel = japi.DzSetUnitMissileModel as ((unit: any, model: string) => void) | undefined;
const DzSetUnitMissileArc = japi.DzSetUnitMissileArc as ((unit: any, arc: number) => void) | undefined;
const DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed as ((unit: any, speed: number) => void) | undefined;
const DzSetUnitMissileHoming = japi.DzSetUnitMissileHoming as ((unit: any, homing: boolean) => void) | undefined;

export type 强化普攻结束原因 = "次数耗尽" | "超时" | "单位死亡" | "刷新覆盖" | "手动清除";

export interface 强化普攻弹道配置 {
  模型?: string;
  速度?: number;
  弧度?: number;
  自导?: boolean;
}

export interface 强化普攻命中上下文 {
  单位: any;
  目标: any;
  原伤害: number;
  当前伤害: number;
  修正后伤害: number;
  剩余次数: number;
  状态名称: string;
  伤害上下文: any;
}

export interface 强化普攻结束上下文 {
  单位: any;
  状态名称: string;
  剩余次数: number;
  原因: 强化普攻结束原因;
}

export interface 强化普攻参数 {
  单位: any;
  名称?: string;
  持续时间?: number;
  持续毫秒?: number;
  次数?: number;
  最多强化次数?: number;
  伤害倍率?: number;
  额外伤害?: number;
  仅远程?: boolean;
  仅近战?: boolean;
  弹道?: 强化普攻弹道配置;
  恢复弹道?: 强化普攻弹道配置;
  on命中?: (this: void, 上下文: 强化普攻命中上下文) => void;
  on结束?: (this: void, 上下文: 强化普攻结束上下文) => void;
}

export interface 强化普攻状态快照 {
  单位: any;
  名称: string;
  剩余次数: number;
  过期时间: number;
  伤害倍率: number;
  额外伤害: number;
}

interface 强化普攻状态 extends 强化普攻状态快照 {
  仅远程: boolean;
  仅近战: boolean;
  恢复弹道?: 强化普攻弹道配置;
  on命中?: (this: void, 上下文: 强化普攻命中上下文) => void;
  on结束?: (this: void, 上下文: 强化普攻结束上下文) => void;
}

const 默认强化普攻名称 = "默认强化普攻";
const 强化普攻状态表: Record<string, 强化普攻状态 | undefined> = {};
let 已注册强化普攻伤害修正 = false;
let 强化普攻清理计时器ID = 0;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取状态名称(this: void, 名称?: string): string {
  return 名称 != null && 名称 !== "" ? 名称 : 默认强化普攻名称;
}

function 取状态键(this: void, unit: any, 名称?: string): string {
  const id = 取单位句柄ID(unit);
  if (id <= 0) return "";
  return `${id}:${取状态名称(名称)}`;
}

function 应用弹道配置(this: void, unit: any, 配置?: 强化普攻弹道配置): void {
  if (!单位有效(unit) || 配置 == null) return;
  if (配置.模型 != null && DzSetUnitMissileModel != null) DzSetUnitMissileModel(unit, 配置.模型);
  if (配置.弧度 != null && DzSetUnitMissileArc != null) DzSetUnitMissileArc(unit, 配置.弧度);
  if (配置.速度 != null && DzSetUnitMissileSpeed != null) DzSetUnitMissileSpeed(unit, 配置.速度);
  if (配置.自导 != null && DzSetUnitMissileHoming != null) DzSetUnitMissileHoming(unit, 配置.自导);
}

function 是否有强化普攻状态(this: void): boolean {
  for (const key in 强化普攻状态表) {
    if (强化普攻状态表[key] != null) return true;
  }
  return false;
}

function 停止强化普攻清理(this: void): void {
  if (强化普攻清理计时器ID === 0) return;
  if (是否有强化普攻状态()) return;
  removePeriodicCallback(强化普攻清理计时器ID);
  强化普攻清理计时器ID = 0;
}

function 结束强化普攻状态(this: void, key: string, 原因: 强化普攻结束原因): void {
  const 状态 = 强化普攻状态表[key];
  if (状态 == null) return;
  delete 强化普攻状态表[key];
  应用弹道配置(状态.单位, 状态.恢复弹道);
  if (状态.on结束 != null) {
    状态.on结束({
      单位: 状态.单位,
      状态名称: 状态.名称,
      剩余次数: 状态.剩余次数,
      原因,
    });
  }
  停止强化普攻清理();
}

function 清理过期强化普攻(this: void): void {
  const now = getGameTime();
  for (const key in 强化普攻状态表) {
    const 状态 = 强化普攻状态表[key];
    if (状态 == null) continue;
    if (!单位有效(状态.单位)) {
      结束强化普攻状态(key, "单位死亡");
    } else if (状态.过期时间 > 0 && now >= 状态.过期时间) {
      结束强化普攻状态(key, "超时");
    }
  }
  停止强化普攻清理();
}

function 确保强化普攻清理(this: void): void {
  if (强化普攻清理计时器ID !== 0) return;
  强化普攻清理计时器ID = addPeriodicCallback(250, 清理过期强化普攻);
}

function 强化普攻条件通过(this: void, 状态: 强化普攻状态, context: any): boolean {
  if (context == null || context.isNormalAttack !== true) return false;
  if (context.attacker !== 状态.单位) return false;
  if (!单位有效(状态.单位) || !单位有效(context.target)) return false;
  if (状态.仅远程 && context.isRangedAttack !== true) return false;
  if (状态.仅近战 && context.isRangedAttack === true) return false;
  if (!(状态.剩余次数 > 0)) return false;
  const now = getGameTime();
  if (状态.过期时间 > 0 && now >= 状态.过期时间) return false;
  return true;
}

function on强化普攻伤害修正(this: void, context: any): number {
  let 当前伤害 = context.currentDamage;
  for (const key in 强化普攻状态表) {
    const 状态 = 强化普攻状态表[key];
    if (状态 == null) continue;
    if (!强化普攻条件通过(状态, context)) continue;

    const 原伤害 = 当前伤害;
    当前伤害 = 当前伤害 * 状态.伤害倍率 + 状态.额外伤害;
    状态.剩余次数 = 状态.剩余次数 - 1;

    if (状态.on命中 != null) {
      状态.on命中({
        单位: 状态.单位,
        目标: context.target,
        原伤害,
        当前伤害: context.currentDamage,
        修正后伤害: 当前伤害,
        剩余次数: 状态.剩余次数,
        状态名称: 状态.名称,
        伤害上下文: context,
      });
    }

    if (状态.剩余次数 <= 0) {
      结束强化普攻状态(key, "次数耗尽");
    }
  }
  return 当前伤害;
}

function 确保强化普攻伤害修正(this: void): void {
  if (已注册强化普攻伤害修正) return;
  已注册强化普攻伤害修正 = true;
  registerDamageModifier(on强化普攻伤害修正, 45);
}

export function 添加强化普攻(this: void, 参数: 强化普攻参数): boolean {
  if (参数 == null || !单位有效(参数.单位)) return false;
  const 次数 = 参数.次数 ?? 参数.最多强化次数 ?? 1;
  if (!(次数 > 0)) return false;

  const 名称 = 取状态名称(参数.名称);
  const key = 取状态键(参数.单位, 名称);
  if (key === "") return false;

  if (强化普攻状态表[key] != null) {
    结束强化普攻状态(key, "刷新覆盖");
  }

  const 持续毫秒 = 参数.持续毫秒 ?? ((参数.持续时间 ?? 0) * 1000);
  const now = getGameTime();
  强化普攻状态表[key] = {
    单位: 参数.单位,
    名称,
    剩余次数: 次数,
    过期时间: 持续毫秒 > 0 ? now + 持续毫秒 : 0,
    伤害倍率: 参数.伤害倍率 != null && 参数.伤害倍率 > 0 ? 参数.伤害倍率 : 1,
    额外伤害: 参数.额外伤害 ?? 0,
    仅远程: 参数.仅远程 === true,
    仅近战: 参数.仅近战 === true,
    恢复弹道: 参数.恢复弹道,
    on命中: 参数.on命中,
    on结束: 参数.on结束,
  };

  应用弹道配置(参数.单位, 参数.弹道);
  确保强化普攻伤害修正();
  确保强化普攻清理();
  return true;
}

export function 清除强化普攻(this: void, 单位: any, 名称?: string): void {
  const key = 取状态键(单位, 名称);
  if (key === "") return;
  结束强化普攻状态(key, "手动清除");
}

export function 获取强化普攻状态(this: void, 单位: any, 名称?: string): 强化普攻状态快照 | null {
  const key = 取状态键(单位, 名称);
  if (key === "") return null;
  const 状态 = 强化普攻状态表[key];
  if (状态 == null) return null;
  return {
    单位: 状态.单位,
    名称: 状态.名称,
    剩余次数: 状态.剩余次数,
    过期时间: 状态.过期时间,
    伤害倍率: 状态.伤害倍率,
    额外伤害: 状态.额外伤害,
  };
}

export function 单位拥有强化普攻(this: void, 单位: any, 名称?: string): boolean {
  return 获取强化普攻状态(单位, 名称) != null;
}

export {};
