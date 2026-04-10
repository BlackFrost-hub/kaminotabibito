/**
 * YDWE JAPI 单元操作函数封装
 *
 * YDWE 插件原生函数（存在于 japi，不在 jass.common）：
 * - EXSetUnitFacing         : 设置单位面向角度
 * - EXPauseUnit            : 暂停/恢复单位
 * - EXSetUnitCollisionType : 设置单位碰撞类型
 * - EXSetUnitMoveType      : 设置单位移动类型
 */
const japi = require("jass.japi");
const jass = require("jass.common");
const jglobals = require("jass.globals");
// ==========================================================================================
// YDWEAbilityState 对齐封装（与 JASS 版本命名一致）
// ==========================================================================================
export const ABILITY_STATE_COOLDOWN = 1;
export const ABILITY_DATA_TARGS = 100;
export const ABILITY_DATA_CAST = 101;
export const ABILITY_DATA_DUR = 102;
export const ABILITY_DATA_HERODUR = 103;
export const ABILITY_DATA_COST = 104;
export const ABILITY_DATA_COOL = 105;
export const ABILITY_DATA_AREA = 106;
export const ABILITY_DATA_RNG = 107;
export const ABILITY_DATA_DATA_A = 108;
export const ABILITY_DATA_DATA_B = 109;
export const ABILITY_DATA_DATA_C = 110;
export const ABILITY_DATA_DATA_D = 111;
export const ABILITY_DATA_DATA_E = 112;
export const ABILITY_DATA_DATA_F = 113;
export const ABILITY_DATA_DATA_G = 114;
export const ABILITY_DATA_DATA_H = 115;
export const ABILITY_DATA_DATA_I = 116;
export const ABILITY_DATA_UNITID = 117;
export const ABILITY_DATA_HOTKET = 200;
export const ABILITY_DATA_UNHOTKET = 201;
export const ABILITY_DATA_RESEARCH_HOTKEY = 202;
export const ABILITY_DATA_NAME = 203;
export const ABILITY_DATA_ART = 204;
export const ABILITY_DATA_TARGET_ART = 205;
export const ABILITY_DATA_CASTER_ART = 206;
export const ABILITY_DATA_EFFECT_ART = 207;
export const ABILITY_DATA_AREAEFFECT_ART = 208;
export const ABILITY_DATA_MISSILE_ART = 209;
export const ABILITY_DATA_SPECIAL_ART = 210;
export const ABILITY_DATA_LIGHTNING_EFFECT = 211;
export const ABILITY_DATA_BUFF_TIP = 212;
export const ABILITY_DATA_BUFF_UBERTIP = 213;
export const ABILITY_DATA_RESEARCH_TIP = 214;
export const ABILITY_DATA_TIP = 215;
export const ABILITY_DATA_UNTIP = 216;
export const ABILITY_DATA_RESEARCH_UBERTIP = 217;
export const ABILITY_DATA_UBERTIP = 218;
export const ABILITY_DATA_UNUBERTIP = 219;
export const ABILITY_DATA_UNART = 220;
export function EXGetUnitAbility(u, abilcode) {
    return japi.EXGetUnitAbility(u, abilcode);
}
export function EXGetUnitAbilityByIndex(u, index) {
    return japi.EXGetUnitAbilityByIndex(u, index);
}
export function EXGetAbilityId(abil) {
    return japi.EXGetAbilityId(abil);
}
export function EXGetAbilityState(abil, state_type) {
    return japi.EXGetAbilityState(abil, state_type);
}
export function EXSetAbilityState(abil, state_type, value) {
    return japi.EXSetAbilityState(abil, state_type, value);
}
export function EXGetAbilityDataReal(abil, level, data_type) {
    return japi.EXGetAbilityDataReal(abil, level, data_type);
}
export function EXSetAbilityDataReal(abil, level, data_type, value) {
    return japi.EXSetAbilityDataReal(abil, level, data_type, value);
}
export function EXGetAbilityDataInteger(abil, level, data_type) {
    return japi.EXGetAbilityDataInteger(abil, level, data_type);
}
export function EXSetAbilityDataInteger(abil, level, data_type, value) {
    return japi.EXSetAbilityDataInteger(abil, level, data_type, value);
}
export function EXGetAbilityDataString(abil, level, data_type) {
    return japi.EXGetAbilityDataString(abil, level, data_type);
}
export function EXSetAbilityDataString(abil, level, data_type, value) {
    return japi.EXSetAbilityDataString(abil, level, data_type, value);
}
export function YDWEGetUnitAbilityState(u, abilcode, state_type) {
    return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type);
}
export function YDWEGetUnitAbilityDataInteger(u, abilcode, level, data_type) {
    return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type);
}
export function YDWEGetUnitAbilityDataReal(u, abilcode, level, data_type) {
    return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type);
}
export function YDWEGetUnitAbilityDataString(u, abilcode, level, data_type) {
    return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type);
}
export function YDWESetUnitAbilityState(u, abilcode, state_type, value) {
    return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value);
}
export function YDWESetUnitAbilityDataInteger(u, abilcode, level, data_type, value) {
    return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value);
}
export function YDWESetUnitAbilityDataReal(u, abilcode, level, data_type, value) {
    return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value);
}
export function YDWESetUnitAbilityDataString(u, abilcode, level, data_type, value) {
    return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value);
}
export function EXSetAbilityAEmeDataA(abil, unitid) {
    return japi.EXSetAbilityAEmeDataA(abil, unitid);
}
export function YDWEUnitTransform(u, abilcode, targetid) {
    jass.UnitAddAbility(u, abilcode);
    EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, ABILITY_DATA_UNITID, jass.GetUnitTypeId(u));
    EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), jass.GetUnitTypeId(u));
    jass.UnitRemoveAbility(u, abilcode);
    jass.UnitAddAbility(u, abilcode);
    EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid);
    jass.UnitRemoveAbility(u, abilcode);
}
export function EXGetItemDataString(itemcode, data_type) {
    return japi.EXGetItemDataString(itemcode, data_type);
}
export function EXSetItemDataString(itemcode, data_type, value) {
    return japi.EXSetItemDataString(itemcode, data_type, value);
}
export function YDWEGetItemDataString(itemcode, data_type) {
    return EXGetItemDataString(itemcode, data_type);
}
export function YDWESetItemDataString(itemcode, data_type, value) {
    return EXSetItemDataString(itemcode, data_type, value);
}
// 设置单位面向（弧度）
export function EXSetUnitFacing(u, angle) {
    japi.EXSetUnitFacing(u, angle);
}
// 暂停/恢复单位（flag=true暂停，false恢复）
export function EXPauseUnit(u, flag) {
    japi.EXPauseUnit(u, flag);
}
// 设置单位碰撞类型（enable=true启用，false禁用，t=碰撞类型）
export function EXSetUnitCollisionType(enable, u, t) {
    japi.EXSetUnitCollisionType(enable, u, t);
}
// 设置单位移动类型（t=移动类型）
export function EXSetUnitMoveType(u, t) {
    japi.EXSetUnitMoveType(u, t);
}
// 眩晕单位
export function YDWEUnitAddStun(u) {
    EXPauseUnit(u, true);
}
// 解除眩晕
export function YDWEUnitRemoveStun(u) {
    EXPauseUnit(u, false);
}
// 批量眩晕
export function YDWEUnitAddStunBatch(units) {
    for (const u of units) {
        YDWEUnitAddStun(u);
    }
}
// 批量解除眩晕
export function YDWEUnitRemoveStunBatch(units) {
    for (const u of units) {
        YDWEUnitRemoveStun(u);
    }
}
// 禁用单位碰撞（可穿越）
export function EXDisableUnitCollision(u, t = 0) {
    EXSetUnitCollisionType(false, u, t);
}
// 启用单位碰撞
export function EXEnableUnitCollision(u, t = 0) {
    EXSetUnitCollisionType(true, u, t);
}
//==========================================================================================
// SLK读取
export const ObjectType = {
    ABILITY: 0,
    BUFF: 1,
    UNIT: 2,
    ITEM: 3,
    UPGRADE: 4,
    DOODAD: 5,
    DESTRUCTABLE: 6,
};
const typeNames = ["ability", "buff", "unit", "item", "upgrade", "doodad", "destructable"];
/**
 * 读取物体编辑器数据（SLK）
 * @param objectType 物体类型（0-6），使用 ObjectType 常量
 * @param objectId 物体ID，传字符串四字码（如 'Hamg'）或 FourCC 整数
 * @param property 属性名（如 "Name", "Primary"）
 */
export function getObjectProperty(objectType, objectId, property) {
    const script = "(function() local _t=(require'jass.slk')." + typeNames[objectType] + "; local _u=_t and _t['" + objectId + "']; if _u then return _u." + property + " else return '' end end)()";
    const result = japi.EXExecuteScript(script);
    return result || "";
}
// 读取物体编辑器属性（整数）
export function getObjectPropertyInteger(objectType, objectId, property) {
    const str = getObjectProperty(objectType, objectId, property);
    return parseInt(str) || 0;
}
// 读取物体编辑器属性（实数）
export function getObjectPropertyReal(objectType, objectId, property) {
    const str = getObjectProperty(objectType, objectId, property);
    return parseFloat(str) || 0;
}
// ============================================
// 便捷函数
// ============================================
// 获取技能名称
export function getAbilityName(abilityId) {
    return getObjectProperty(ObjectType.ABILITY, abilityId, "Name");
}
// 获取单位名称
export function getUnitName(unitId) {
    return getObjectProperty(ObjectType.UNIT, unitId, "Name");
}
// 获取物品名称
export function getItemName(itemId) {
    return getObjectProperty(ObjectType.ITEM, itemId, "Name");
}
// 获取技能Data值（field="A"/"B"/"C"/"D"...）
export function getAbilityData(abilityId, field, level) {
    return getObjectPropertyInteger(ObjectType.ABILITY, abilityId, `Data${field}${level}`);
}
// 获取技能DataA值（快捷）
export function getAbilityDataA(abilityId, level) {
    return getAbilityData(abilityId, "A", level);
}
export function EXExecuteScript(script) {
    return japi.EXExecuteScript(script);
}
export function YDWEDistanceBetweenUnits(a, b) {
    const dx = jass.GetUnitX(a) - jass.GetUnitX(b);
    const dy = jass.GetUnitY(a) - jass.GetUnitY(b);
    return jass.SquareRoot(dx * dx + dy * dy);
}
export function YDWEAngleBetweenUnits(fromUnit, toUnit) {
    return jglobals.bj_RADTODEG * jass.Atan2(jass.GetUnitY(toUnit) - jass.GetUnitY(fromUnit), jass.GetUnitX(toUnit) - jass.GetUnitX(fromUnit));
}
