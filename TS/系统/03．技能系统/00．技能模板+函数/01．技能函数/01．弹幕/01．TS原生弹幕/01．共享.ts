/** @noSelfInFile */
/**
 * TS 原生弹幕 - 共享常量与 JASS/JAPI 别名
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关") as {
  创建单位并登记排泄: (self: any, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const unitCleanup = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const 创建单位并登记排泄: any = unitRelated.创建单位并登记排泄;

export const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
export const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
export const GetHandleId = jass.GetHandleId as (h: any) => number;
export const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
export const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
export const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
export const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
export const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
export const GetUnitX = jass.GetUnitX as (unit: any) => number;
export const GetUnitY = jass.GetUnitY as (unit: any) => number;
export const IsTerrainPathable = jass.IsTerrainPathable as (x: number, y: number, pathingType: any) => boolean;
export const IsUnitPaused = jass.IsUnitPaused as (unit: any) => boolean;
export const KillUnit = jass.KillUnit as (unit: any) => void;
export const Player = jass.Player as (playerId: number) => any;
export const SetUnitFacing = jass.SetUnitFacing as (unit: any, face: number) => void;
export const SetUnitFlyHeight = jass.SetUnitFlyHeight as (unit: any, height: number, rate: number) => void;
export const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
export const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
export const SetUnitScale = jass.SetUnitScale as (unit: any, x: number, y: number, z: number) => void;
export const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
export const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
export const SquareRoot = jass.SquareRoot as (value: number) => number;
export const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
export const UnitRemoveAbility = jass.UnitRemoveAbility as (unit: any, abilityId: number) => boolean;
export const UnitAddType = jass.UnitAddType as (unit: any, unitType: any) => boolean;
export const UnitRemoveType = jass.UnitRemoveType as (unit: any, unitType: any) => boolean;
export const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;

export const Atan2 = jass.Atan2 as (y: number, x: number) => number;
export const CosBJ = (require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
}).CosBJ;
export const SinBJ = (require("lib.扩展函数.BJ函数.12．数学函数") as {
  SinBJ: (this: void, degrees: number) => number;
}).SinBJ;

export const EXSetUnitFacing = japi.EXSetUnitFacing as ((unit: any, angle: number) => void) | undefined;
export const DzSetUnitModel = japi.DzSetUnitModel as ((unit: any, model: string) => void) | undefined;

export const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
export const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
export const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
export const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
export const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
export const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
export const UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN;
export const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY;
export const bj_RADTODEG = jass.bj_RADTODEG ?? 57.29577951308232;

export const 蝗虫技能ID = 0x416c6f63; // 'Aloc'
export const 默认弹幕单位类型 = 1700880737; // 'eaaa'，objediting/units.lua 中的 TS 原生弹幕马甲
export const 弹幕Tick间隔 = 0.01;

const 空Self = undefined as any;

export function CreateUnit(this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number): any {
  return 创建单位并登记排泄(空Self, owner, unitTypeId, x, y, facing);
}

export function RemoveUnit(this: void, unit: any): void {
  unitCleanup.立即移除单位并取消排泄登记(unit);
}

export function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? (GetHandleId(handle) || 0) : 0;
}

export function 标准化角度(this: void, 角度: number): number {
  let 结果 = 角度;
  while (结果 < 0) 结果 += 360;
  while (结果 >= 360) 结果 -= 360;
  return 结果;
}

export function 取坐标朝向角(this: void, fromX: number, fromY: number, toX: number, toY: number): number {
  return (Atan2(toY - fromY, toX - fromX) as number) * bj_RADTODEG;
}

export function 角度差(this: void, from: number, to: number): number {
  let diff = 标准化角度(to - from);
  if (diff > 180) diff -= 360;
  return diff;
}

export function 限制范围(this: void, value: number, min: number, max: number): number {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

export function 计算距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}
