/** @noSelfInFile */
/**
 * 精英单位判断便捷函数
 *
 * 功能：判断单位是否是精英单位
 * 精英单位定义：恶魔种族 或 英雄类型
 */

const jass = require("jass.common") as any;

const IsUnitRace = jass.IsUnitRace as (unit: any, race: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const RACE_DEMON = jass.RACE_DEMON as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

/**
 * 判断是否是精英单位
 * 精英单位：恶魔种族 或 英雄类型
 */
export function 是否精英单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitRace(unit, RACE_DEMON) === true || IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

/**
 * 判断是否是恶魔单位
 */
export function 是否恶魔单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitRace(unit, RACE_DEMON) === true;
}

/**
 * 判断是否是英雄单位
 */
export function 是否英雄单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

/**
 * 判断是否是普通敌人（杂鱼/蝼蚁/普通敌人/野怪）
 * 条件：恶魔种族 或 野兽种族
 * RACE_DEMON = 恶魔种族
 * ConvertRace(8) = 野兽种族
 */
export function 是否普通敌人(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const RACE_BEAST = jass.ConvertRace(8);
  return IsUnitRace(unit, RACE_DEMON) === true || IsUnitRace(unit, RACE_BEAST) === true;
}

/**
 * 判断是否是蝼蚁敌人（普通敌人 + 非恶魔 + 非英雄）
 */
export function 是否蝼蚁敌人(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitRace(unit, RACE_DEMON) === true) return false;
  if (IsUnitType(unit, UNIT_TYPE_HERO) === true) return false;
  const RACE_BEAST = jass.ConvertRace(8);
  return IsUnitRace(unit, RACE_BEAST) === true;
}

export {};
