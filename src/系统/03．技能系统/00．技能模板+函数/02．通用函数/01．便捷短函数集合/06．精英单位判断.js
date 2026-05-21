/** @noSelfInFile */
/**
 * 精英单位判断便捷函数
 *
 * 功能：判断单位是否是精英单位
 * 精英单位定义：恶魔种族 或 英雄类型
 */
const jass = require("jass.common");
const IsUnitRace = jass.IsUnitRace;
const IsUnitType = jass.IsUnitType;
const RACE_DEMON = jass.RACE_DEMON;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
/**
 * 判断是否是精英单位
 * 精英单位：恶魔种族 或 英雄类型
 */
export function 是否精英单位(unit) {
    if (unit == null || unit === 0)
        return false;
    return IsUnitRace(unit, RACE_DEMON) === true || IsUnitType(unit, UNIT_TYPE_HERO) === true;
}
/**
 * 判断是否是恶魔单位
 */
export function 是否恶魔单位(unit) {
    if (unit == null || unit === 0)
        return false;
    return IsUnitRace(unit, RACE_DEMON) === true;
}
/**
 * 判断是否是英雄单位
 */
export function 是否英雄单位(unit) {
    if (unit == null || unit === 0)
        return false;
    return IsUnitType(unit, UNIT_TYPE_HERO) === true;
}
/**
 * 判断是否是普通敌人（杂鱼/蝼蚁/普通敌人/野怪）
 * 条件：恶魔种族 或 野兽种族
 * RACE_DEMON = 恶魔种族
 * ConvertRace(8) = 野兽种族
 */
export function 是否普通敌人(unit) {
    if (unit == null || unit === 0)
        return false;
    const RACE_BEAST = jass.ConvertRace(8);
    return IsUnitRace(unit, RACE_DEMON) === true || IsUnitRace(unit, RACE_BEAST) === true;
}
