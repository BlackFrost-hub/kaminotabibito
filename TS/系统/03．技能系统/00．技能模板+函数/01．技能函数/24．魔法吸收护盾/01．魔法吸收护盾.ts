/** @noSelfInFile */

const jass = require("jass.common") as any;
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: {
    target: any;
    attacker: any;
    baseDamage: number;
    currentDamage: number;
    isPhysicalDamage: boolean;
    isMagicDamage: boolean;
    isEnhancedDamage: boolean;
    isTrueDamage: boolean;
    isMetalDamage?: boolean;
    isWoodDamage?: boolean;
    isWaterDamage?: boolean;
    isFireDamage?: boolean;
    isThunderDamage?: boolean;
    isLightDamage?: boolean;
    isDarkDamage?: boolean;
    isNormalAttack: boolean;
    isSkillAttack: boolean;
    isSkillDamage: boolean;
  }) => number, priority?: number) => number;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (
    this: void,
    target: any,
    amount: number,
    showText?: boolean,
    showEffect?: boolean,
    effectPath?: string,
  ) => number;
};
const { AddSpecialEffectTarget } = jass as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

export interface 魔法吸收护盾参数 {
  单位: any;
  持续时间?: number;
  伤害吸收比例?: number;
  每点魔法吸收伤害: number;
  最低魔法百分比?: number;
  最低魔法固定值?: number;
  仅非物理伤害?: boolean;
  是否有特效?: boolean;
  特效路径?: string;
  特效挂点?: string;
  显示文本?: boolean;
  标签?: string;
}

type 魔法吸收护盾实例 = 魔法吸收护盾参数 & {
  id: number;
  单位ID: number;
  剩余时间: number;
  特效: any;
};

const 魔法吸收护盾表: Record<number, 魔法吸收护盾实例 | undefined> = {};
const 魔法吸收护盾ID列表: number[] = [];
const 魔法吸收护盾标签表: Record<string, number | undefined> = {};
let 已注册魔法吸收护盾伤害监听 = false;
let 已注册魔法吸收护盾中心计时器 = false;
let 下一个魔法吸收护盾ID = 1;

const 默认魔法吸收特效路径 = "war3mapImported\\Energy Shield.mdl";
const 默认魔法吸收特效挂点 = "origin";

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取最小值(this: void, a: number, b: number): number {
  return a < b ? a : b;
}

function 生成标签键(this: void, unitId: number, label: string): string {
  return String(unitId) + ":" + label;
}

function 从列表移除(this: void, id: number): void {
  for (let i = 魔法吸收护盾ID列表.length - 1; i >= 0; i--) {
    if (魔法吸收护盾ID列表[i] === id) {
      魔法吸收护盾ID列表.splice(i, 1);
      return;
    }
  }
}

function 尝试关闭中心计时器(this: void): void {
  if (!已注册魔法吸收护盾中心计时器) return;
  if (魔法吸收护盾ID列表.length > 0) return;
  已注册魔法吸收护盾中心计时器 = false;
}

function 清理标签(this: void, 实例: 魔法吸收护盾实例): void {
  if (实例.标签 == null || 实例.标签 === "") return;
  const key = 生成标签键(实例.单位ID, 实例.标签);
  if (魔法吸收护盾标签表[key] === 实例.id) {
    delete 魔法吸收护盾标签表[key];
  }
}

function 销毁魔法吸收护盾(this: void, id: number): void {
  const 实例 = 魔法吸收护盾表[id];
  if (实例 == null) return;
  delete 魔法吸收护盾表[id];
  从列表移除(id);
  清理标签(实例);
  if (实例.特效 != null && 实例.特效 !== 0) DestroyEffect(实例.特效);
  尝试关闭中心计时器();
}

function 确保中心计时器(this: void): void {
  if (已注册魔法吸收护盾中心计时器) return;
  已注册魔法吸收护盾中心计时器 = true;
  addPeriodicCallback(100, on魔法吸收护盾中心计时器Tick);
}

function on魔法吸收护盾中心计时器Tick(this: void): void {
  for (let i = 魔法吸收护盾ID列表.length - 1; i >= 0; i--) {
    const id = 魔法吸收护盾ID列表[i];
    const 实例 = 魔法吸收护盾表[id];
    if (实例 == null || 实例.单位 == null || 实例.单位 === 0) {
      销毁魔法吸收护盾(id);
      continue;
    }
    if (!(实例.剩余时间 > 0)) continue;
    实例.剩余时间 = 实例.剩余时间 - 0.1;
    if (实例.剩余时间 <= 0) 销毁魔法吸收护盾(id);
  }
  尝试关闭中心计时器();
}

function 确保伤害监听(this: void): void {
  if (已注册魔法吸收护盾伤害监听) return;
  已注册魔法吸收护盾伤害监听 = true;
  registerDamageModifier(on魔法吸收护盾伤害修正, 90);
}

function 是否满足魔法门槛(this: void, 当前魔法: number, 最大魔法: number, 最低魔法百分比: number, 最低魔法固定值: number): boolean {
  const 触发门槛 = 最大魔法 * 最低魔法百分比 + 最低魔法固定值;
  return 当前魔法 > 触发门槛;
}

function 是否可吸收(this: void, 实例: 魔法吸收护盾实例, 受击单位: any, context: {
  isPhysicalDamage: boolean;
  currentDamage: number;
}): boolean {
  if (实例 == null) return false;
  if (受击单位 == null || 受击单位 === 0) return false;
  if (实例.单位 !== 受击单位) return false;
  if (实例.仅非物理伤害 !== false && context.isPhysicalDamage) return false;
  if (!(实例.每点魔法吸收伤害 > 0)) return false;
  const 当前魔法 = GetUnitState(受击单位, UNIT_STATE_MANA);
  if (!(当前魔法 > 0)) return false;
  const 最大魔法 = GetUnitState(受击单位, UNIT_STATE_MAX_MANA);
  if (!(最大魔法 > 0)) return false;
  if (!是否满足魔法门槛(当前魔法, 最大魔法, 实例.最低魔法百分比 ?? 0, 实例.最低魔法固定值 ?? 0)) return false;
  return context.currentDamage > 0;
}

function 创建特效(this: void, 实例: 魔法吸收护盾实例): void {
  if (实例.是否有特效 === false) return;
  const path = 实例.特效路径 && 实例.特效路径 !== "" ? 实例.特效路径 : 默认魔法吸收特效路径;
  const attach = 实例.特效挂点 && 实例.特效挂点 !== "" ? 实例.特效挂点 : 默认魔法吸收特效挂点;
  const effect = AddSpecialEffectTarget(path, 实例.单位, attach);
  if (effect != null && effect !== 0) {
    实例.特效 = effect;
  }
}

function 计算吸收伤害(this: void, 实例: 魔法吸收护盾实例, 受击单位: any, 伤害值: number): number {
  if (!(伤害值 > 0)) return 0;
  const 比例上限 = 实例.伤害吸收比例 == null || 实例.伤害吸收比例 <= 0 ? 伤害值 : 伤害值 * 实例.伤害吸收比例;
  const 当前魔法 = GetUnitState(受击单位, UNIT_STATE_MANA);
  const 魔法上限 = 当前魔法 * 实例.每点魔法吸收伤害;
  return 取最小值(伤害值, 取最小值(比例上限, 魔法上限));
}

function 吸收魔法护盾伤害(this: void, 实例: 魔法吸收护盾实例, 受击单位: any, 伤害值: number): number {
  const 吸收量 = 计算吸收伤害(实例, 受击单位, 伤害值);
  if (!(吸收量 > 0)) return 0;
  const 需要魔法 = 吸收量 / 实例.每点魔法吸收伤害;
  减少魔法值(受击单位, 需要魔法, 实例.显示文本 === true, 实例.是否有特效 !== false, 实例.特效路径);
  return 吸收量;
}

function on魔法吸收护盾伤害修正(
  this: void,
  context: {
    target: any;
    attacker: any;
    baseDamage: number;
    currentDamage: number;
    isPhysicalDamage: boolean;
    isMagicDamage: boolean;
    isEnhancedDamage: boolean;
    isTrueDamage: boolean;
    isMetalDamage?: boolean;
    isWoodDamage?: boolean;
    isWaterDamage?: boolean;
    isFireDamage?: boolean;
    isThunderDamage?: boolean;
    isLightDamage?: boolean;
    isDarkDamage?: boolean;
    isNormalAttack: boolean;
    isSkillAttack: boolean;
    isSkillDamage: boolean;
  }
): number {
  const 受击单位 = context.target;
  if (受击单位 == null || 受击单位 === 0 || !(context.currentDamage > 0)) return context.currentDamage;

  for (let i = 魔法吸收护盾ID列表.length - 1; i >= 0; i--) {
    const id = 魔法吸收护盾ID列表[i];
    const 实例 = 魔法吸收护盾表[id];
    if (实例 == null || 实例.单位 == null || 实例.单位 === 0) {
      销毁魔法吸收护盾(id);
      continue;
    }
    if (!是否可吸收(实例, 受击单位, context)) continue;

    const 吸收量 = 吸收魔法护盾伤害(实例, 受击单位, context.currentDamage);
    if (!(吸收量 > 0)) continue;
    context.currentDamage = context.currentDamage - 吸收量;
    if (!(context.currentDamage > 0)) return 0;
  }

  return context.currentDamage;
}

export function 开始魔法吸收护盾(this: void, 参数: 魔法吸收护盾参数): number {
  const 单位 = 参数.单位;
  const 单位ID = 取单位ID(单位);
  if (单位ID === 0) return 0;
  if (!(参数.每点魔法吸收伤害 > 0)) return 0;

  if (参数.标签 != null && 参数.标签 !== "") {
    const key = 生成标签键(单位ID, 参数.标签);
    const 已有ID = 魔法吸收护盾标签表[key];
    if (已有ID != null && 已有ID > 0) {
      销毁魔法吸收护盾(已有ID);
    }
  }

  const id = 下一个魔法吸收护盾ID++;
  const 实例: 魔法吸收护盾实例 = {
    ...参数,
    id,
    单位,
    单位ID,
    剩余时间: 参数.持续时间 ?? 0,
    特效: 0,
  };
  魔法吸收护盾表[id] = 实例;
  魔法吸收护盾ID列表.push(id);
  if (参数.标签 != null && 参数.标签 !== "") {
    魔法吸收护盾标签表[生成标签键(单位ID, 参数.标签)] = id;
  }
  创建特效(实例);
  确保伤害监听();
  确保中心计时器();
  return id;
}

export function 移除魔法吸收护盾(this: void, id: number): void {
  if (!(id > 0)) return;
  销毁魔法吸收护盾(id);
}

export function 移除单位魔法吸收护盾(this: void, 单位: any, 标签: string): void {
  const 单位ID = 取单位ID(单位);
  if (单位ID === 0 || 标签 === "") return;
  const key = 生成标签键(单位ID, 标签);
  const id = 魔法吸收护盾标签表[key];
  if (id == null || !(id > 0)) return;
  销毁魔法吸收护盾(id);
}

export {};
