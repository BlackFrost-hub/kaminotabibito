/** @noSelfInFile */
/**
 * 伤害函数 - 伤害事件数据获取与设置
 */
const japi = require("jass.japi");
import { EVENT_DAMAGE_DATA_IS_PHYSICAL, EVENT_DAMAGE_DATA_IS_ATTACK, EVENT_DAMAGE_DATA_IS_RANGED, EVENT_DAMAGE_DATA_DAMAGE_TYPE, EVENT_DAMAGE_DATA_WEAPON_TYPE, EVENT_DAMAGE_DATA_ATTACK_TYPE, EVENT_DAMAGE_DATA_DAMAGE_AMOUNT, } from "./01．伤害事件常量";
export function EXGetEventDamageData(edd_type) {
    return japi.EXGetEventDamageData(edd_type);
}
export function EXSetEventDamage(amount) {
    return japi.EXSetEventDamage(amount);
}
export function YDWEIsEventPhysicalDamage() {
    return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL);
}
export function YDWEIsEventAttackDamage() {
    return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK);
}
export function YDWEIsEventRangedDamage() {
    return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED);
}
const jass = require("jass.common");
export function YDWEIsEventDamageType(damageType) {
    return damageType === jass.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE));
}
export function YDWEIsEventWeaponType(weaponType) {
    return weaponType === jass.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE));
}
export function YDWEIsEventAttackType(attackType) {
    return attackType === jass.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE));
}
export function YDWESetEventDamage(amount) {
    return japi.EXSetEventDamage(amount);
}
function isFiniteNumber(n) {
    return typeof n === "number" && !Number.isNaN(n);
}
/**
 * 在 `EVENT_UNIT_DAMAGED` 同步回调内、`EXSetEventDamage` 之后读取「当前事件伤害」。
 * 1.27：`japi.GetEventDamage`（若存在）→ `EXGetEventDamageData(DAMAGE_AMOUNT)` → `jass.GetEventDamage`（常为改写前）。
 */
export function readEventDamageAfterModify() {
    let fromJapiFn;
    pcall(() => {
        fromJapiFn = japi.GetEventDamage();
    });
    if (fromJapiFn !== undefined && isFiniteNumber(fromJapiFn)) {
        return fromJapiFn;
    }
    let fromExData;
    pcall(() => {
        fromExData = japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_AMOUNT);
    });
    if (fromExData !== undefined && isFiniteNumber(fromExData)) {
        return fromExData;
    }
    return jass.GetEventDamage();
}
