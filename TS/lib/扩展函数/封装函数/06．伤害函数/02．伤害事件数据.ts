/** @noSelfInFile */

/**
 * 伤害函数 - 伤害事件数据获取与设置
 */

const japi = require("jass.japi") as any;
import {
  EVENT_DAMAGE_DATA_VAILD,
  EVENT_DAMAGE_DATA_IS_PHYSICAL,
  EVENT_DAMAGE_DATA_IS_ATTACK,
  EVENT_DAMAGE_DATA_IS_RANGED,
  EVENT_DAMAGE_DATA_DAMAGE_TYPE,
  EVENT_DAMAGE_DATA_WEAPON_TYPE,
  EVENT_DAMAGE_DATA_ATTACK_TYPE,
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
