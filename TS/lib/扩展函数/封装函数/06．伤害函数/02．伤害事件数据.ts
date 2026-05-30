/** @noSelfInFile */

/**
 * 伤害函数 - 伤害事件数据获取与设置
 */

const japi = require("jass.japi") as any;
import {
  EVENT_DAMAGE_DATA_IS_PHYSICAL,
  EVENT_DAMAGE_DATA_IS_ATTACK,
  EVENT_DAMAGE_DATA_IS_RANGED,
  EVENT_DAMAGE_DATA_DAMAGE_TYPE,
  EVENT_DAMAGE_DATA_WEAPON_TYPE,
  EVENT_DAMAGE_DATA_ATTACK_TYPE,
  EVENT_DAMAGE_DATA_DAMAGE_AMOUNT,
} from "./01．伤害事件常量";

export function EXGetEventDamageData(edd_type: number): number {
  return japi.EXGetEventDamageData(edd_type);
}

export function EXSetEventDamage(amount: number): boolean {
  return japi.EXSetEventDamage(amount);
}

export function YDWEIsEventPhysicalDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL);
}

export function YDWEIsEventAttackDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK);
}

export function YDWEIsEventRangedDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED);
}

const jass = require("jass.common") as any;

export function YDWEIsEventDamageType(damageType: any): boolean {
  return damageType === jass.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE));
}

export function YDWEIsEventWeaponType(weaponType: any): boolean {
  return weaponType === jass.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE));
}

export function YDWEIsEventAttackType(attackType: any): boolean {
  return attackType === jass.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE));
}

export function YDWESetEventDamage(amount: number): boolean {
  return japi.EXSetEventDamage(amount);
}

function isFiniteNumber(n: number): boolean {
  return typeof n === "number" && !Number.isNaN(n);
}

let __pcall读取伤害值 = 0;
let __pcall读取伤害值有效 = false;

function __pcall读取Japi事件伤害(this: any): void {
  const value = (japi as any).GetEventDamage();
  if (isFiniteNumber(value)) {
    __pcall读取伤害值 = value;
    __pcall读取伤害值有效 = true;
  }
}

function __pcall读取Ex事件伤害(this: any): void {
  const value = (japi as any).EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_AMOUNT);
  if (isFiniteNumber(value)) {
    __pcall读取伤害值 = value;
    __pcall读取伤害值有效 = true;
  }
}

/**
 * 在 `EVENT_UNIT_DAMAGED` 同步回调内、`EXSetEventDamage` 之后读取「当前事件伤害」。
 * 1.27：`japi.GetEventDamage`（若存在）→ `EXGetEventDamageData(DAMAGE_AMOUNT)` → `jass.GetEventDamage`（常为改写前）。
 */
export function readEventDamageAfterModify(): number {
  __pcall读取伤害值 = 0;
  __pcall读取伤害值有效 = false;
  pcall(__pcall读取Japi事件伤害);
  if (__pcall读取伤害值有效) {
    return __pcall读取伤害值;
  }

  __pcall读取伤害值 = 0;
  __pcall读取伤害值有效 = false;
  pcall(__pcall读取Ex事件伤害);
  if (__pcall读取伤害值有效) {
    return __pcall读取伤害值;
  }

  return (jass as any).GetEventDamage();
}
