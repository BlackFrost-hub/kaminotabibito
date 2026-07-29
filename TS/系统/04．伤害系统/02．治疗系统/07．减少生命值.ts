/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitStateJass = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitStateJass = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { HEAL_SYSTEM_ENABLED } = require("系统.04．伤害系统.02．治疗系统.00．常量定义") as {
  HEAL_SYSTEM_ENABLED: boolean;
};
const { fireShowDamageEvent } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  fireShowDamageEvent: (this: void, target: any, amount: number, red?: number, green?: number, blue?: number) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
export type 资源类型 = "life" | "mana";

export interface 资源增减选项 {
  showText?: boolean;
  showEffect?: boolean;
  effectPath?: string;
  lowestValue?: number;
  textColor?: {
    red: number;
    green: number;
    blue: number;
  };
}

const 默认生命减少特效路径 = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl";
const 默认魔法恢复特效路径 = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl";
const 默认魔法减少特效路径 = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl";

function 取绝对值(this: void, value: number): number {
  return value < 0 ? -value : value;
}

function 读取魔法消耗减少(this: void, target: any): number {
  const owner = GetOwningPlayer(target);
  if (owner == null || owner === 0) return 0;
  const hero = YDUserDataGetSafe("player", owner, "英雄", "unit");
  if (hero == null || hero === 0) return 0;
  if (hero !== target && GetHandleId(hero) !== GetHandleId(target)) return 0;

  const value = YDUserDataGetSafe("player", owner, "魔法消耗", "real");
  if (typeof value !== "number") return 0;
  return value < 0 ? -value : value;
}

function 应用魔法消耗减少(this: void, target: any, amount: number, resourceType: 资源类型): number {
  if (resourceType !== "mana" || amount >= 0) return amount;

  const reduction = 读取魔法消耗减少(target);
  if (reduction <= 0) return amount;
  if (reduction >= 1) return 0;

  return amount * (1 - reduction);
}

function 获取当前值(this: void, target: any, resourceType: 资源类型): number {
  if (resourceType === "life") {
    return GetUnitStateJass(target, UNIT_STATE_LIFE);
  }
  return GetUnitStateJass(target, UNIT_STATE_MANA);
}

function 获取最大值(this: void, target: any, resourceType: 资源类型): number {
  if (resourceType === "life") {
    return GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  }
  return GetUnitStateJapi(target, UNIT_STATE_MAX_MANA);
}

function 设置当前值(this: void, target: any, resourceType: 资源类型, value: number): void {
  if (resourceType === "life") {
    SetUnitStateJass(target, UNIT_STATE_LIFE, value);
    return;
  }
  SetUnitStateJass(target, UNIT_STATE_MANA, value);
}

function 播放特效(this: void, target: any, resourceType: 资源类型, amount: number, effectPath?: string, showEffect: boolean = false): void {
  if (!showEffect || target == null || target === 0) {
    return;
  }
  const path =
    effectPath != null && effectPath !== ""
      ? effectPath
      : resourceType === "mana"
        ? amount >= 0
          ? 默认魔法恢复特效路径
          : 默认魔法减少特效路径
        : amount < 0
          ? 默认生命减少特效路径
          : "";
  if (path == null || path === "") {
    return;
  }
  const effect = AddSpecialEffectTarget(path, target, "origin");
  if (effect != null && effect !== 0) {
    DestroyEffect(effect);
  }
}

function 显示数值(this: void, target: any, amount: number, resourceType: 资源类型, showText: boolean = true): void {
  if (!showText || target == null || target === 0 || amount === 0) {
    return;
  }
  if (resourceType === "life") {
    if (amount >= 0) {
      fireShowDamageEvent(target, amount, 0, 255, 0);
      return;
    }
    fireShowDamageEvent(target, amount, 255, 0, 0);
    return;
  }
  if (amount >= 0) {
    fireShowDamageEvent(target, amount, 0, 100, 255);
    return;
  }
  fireShowDamageEvent(target, amount, 150, 50, 255);
}

export function 变更资源值(
  this: void,
  target: any,
  amount: number,
  resourceType: 资源类型,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
  lowestValue: number = 0,
): number {
  if (!HEAL_SYSTEM_ENABLED) return 0;
  if (target == null || target === 0) return 0;
  if (amount === 0) return 0;
  if (IsUnitType(target, UNIT_TYPE_DEAD) === true) return 0;

  amount = 应用魔法消耗减少(target, amount, resourceType);
  if (amount === 0) return 0;

  const currentValue = 获取当前值(target, resourceType);
  const maxValue = 获取最大值(target, resourceType);
  const safeMinValue = lowestValue > 0 ? lowestValue : 0;

  let actualDelta = 0;
  if (amount > 0) {
    const missingValue = maxValue - currentValue;
    actualDelta = amount < missingValue ? amount : missingValue;
  } else {
    const maxReduce = currentValue - safeMinValue;
    const reduceAmount = -amount;
    const actualReduce = reduceAmount < maxReduce ? reduceAmount : maxReduce;
    actualDelta = -actualReduce;
  }

  if (actualDelta === 0) {
    return 0;
  }

  设置当前值(target, resourceType, currentValue + actualDelta);
  播放特效(target, resourceType, actualDelta, effectPath, showEffect);
  显示数值(target, actualDelta, resourceType, showText);
  return actualDelta;
}

export function 减少生命值(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
  最低保留生命: number = 1,
): number {
  return 变更资源值(target, -取绝对值(amount), "life", showText, showEffect, effectPath, 最低保留生命);
}

export function 减少魔法值(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
): number {
  return 变更资源值(target, -取绝对值(amount), "mana", showText, showEffect, effectPath, 0);
}

export function 增加生命值(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
): number {
  return 变更资源值(target, 取绝对值(amount), "life", showText, showEffect, effectPath, 0);
}

export function 增加魔法值(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
): number {
  return 变更资源值(target, 取绝对值(amount), "mana", showText, showEffect, effectPath, 0);
}

export {};
