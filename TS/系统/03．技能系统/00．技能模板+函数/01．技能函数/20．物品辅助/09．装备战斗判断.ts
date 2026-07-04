/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

export function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 是技能伤害(this: void, snapshot: any): boolean {
  return snapshot != null && (snapshot.isSkillDamage === true || snapshot.isSkillAttack === true);
}

export function 是纯普攻(this: void, snapshot: any): boolean {
  return snapshot != null && snapshot.isNormalAttack === true && snapshot.isSkillDamage !== true && snapshot.isSkillAttack !== true;
}

export function 是元素伤害(this: void, snapshot: any, damageType: any): boolean {
  return snapshot != null && snapshot.rawDamageType === damageType;
}

export function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 取当前生命(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_LIFE);
}

export function 取最大生命(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) || GetUnitState(unit, UNIT_STATE_MAX_LIFE) || 0;
}

export function 是敌对单位(this: void, source: any, target: any): boolean {
  return source != null && source !== 0 && target != null && target !== 0 && IsUnitEnemy(target, GetOwningPlayer(source)) === true;
}

export function 取单位X(this: void, unit: any): number {
  return GetUnitX(unit);
}

export function 取单位Y(this: void, unit: any): number {
  return GetUnitY(unit);
}

export {};
