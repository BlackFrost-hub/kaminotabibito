/**
 * YDWE JAPI 单元操作函数封装
 *
 * YDWE 插件原生函数（存在于 japi，不在 jass.common）：
 * - EXSetUnitFacing         : 设置单位面向角度
 * - EXPauseUnit            : 暂停/恢复单位
 * - EXSetUnitCollisionType : 设置单位碰撞类型
 * - EXSetUnitMoveType      : 设置单位移动类型
 */

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

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
export const ABILITY_DATA_HOTKEY = 200;
/** @deprecated 拼写错误保留别名，请用 ABILITY_DATA_HOTKEY */
export const ABILITY_DATA_HOTKET = ABILITY_DATA_HOTKEY;
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

export function EXGetUnitAbility(u: any, abilcode: number): any {
  return japi.EXGetUnitAbility(u, abilcode);
}

export function EXGetUnitAbilityByIndex(u: any, index: number): any {
  return japi.EXGetUnitAbilityByIndex(u, index);
}

export function EXGetAbilityId(abil: any): number {
  return japi.EXGetAbilityId(abil);
}

export function EXGetAbilityState(abil: any, state_type: number): number {
  return japi.EXGetAbilityState(abil, state_type);
}

export function EXSetAbilityState(abil: any, state_type: number, value: number): boolean {
  return japi.EXSetAbilityState(abil, state_type, value);
}

export function EXGetAbilityDataReal(abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataReal(abil, level, data_type);
}

export function EXSetAbilityDataReal(abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataReal(abil, level, data_type, value);
}

export function EXGetAbilityDataInteger(abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataInteger(abil, level, data_type);
}

export function EXSetAbilityDataInteger(abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataInteger(abil, level, data_type, value);
}

export function EXGetAbilityDataString(abil: any, level: number, data_type: number): string {
  return japi.EXGetAbilityDataString(abil, level, data_type);
}

export function EXSetAbilityDataString(abil: any, level: number, data_type: number, value: string): boolean {
  return japi.EXSetAbilityDataString(abil, level, data_type, value);
}

export function YDWEGetUnitAbilityState(u: any, abilcode: number, state_type: number): number {
  return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type);
}

export function YDWEGetUnitAbilityDataInteger(u: any, abilcode: number, level: number, data_type: number): number {
  return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWEGetUnitAbilityDataReal(u: any, abilcode: number, level: number, data_type: number): number {
  return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWEGetUnitAbilityDataString(u: any, abilcode: number, level: number, data_type: number): string {
  return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWESetUnitAbilityState(u: any, abilcode: number, state_type: number, value: number): boolean {
  return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value);
}

export function YDWESetUnitAbilityDataInteger(u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function YDWESetUnitAbilityDataReal(u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function YDWESetUnitAbilityDataString(u: any, abilcode: number, level: number, data_type: number, value: string): boolean {
  return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function EXSetAbilityAEmeDataA(abil: any, unitid: number): boolean {
  return japi.EXSetAbilityAEmeDataA(abil, unitid);
}

export function YDWEUnitTransform(u: any, abilcode: number, targetid: number): void {
  jass.UnitAddAbility(u, abilcode);
  EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, ABILITY_DATA_UNITID, jass.GetUnitTypeId(u));
  EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), jass.GetUnitTypeId(u));
  jass.UnitRemoveAbility(u, abilcode);
  jass.UnitAddAbility(u, abilcode);
  EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid);
  jass.UnitRemoveAbility(u, abilcode);
}

export function EXGetItemDataString(itemcode: number, data_type: number): string {
  return japi.EXGetItemDataString(itemcode, data_type);
}

export function EXSetItemDataString(itemcode: number, data_type: number, value: string): boolean {
  return japi.EXSetItemDataString(itemcode, data_type, value);
}

export function YDWEGetItemDataString(itemcode: number, data_type: number): string {
  return EXGetItemDataString(itemcode, data_type);
}

export function YDWESetItemDataString(itemcode: number, data_type: number, value: string): boolean {
  return EXSetItemDataString(itemcode, data_type, value);
}

// 设置单位面向（弧度）
export function EXSetUnitFacing(u: any, angle: number): void {
  japi.EXSetUnitFacing(u, angle);
}

// 暂停/恢复单位（flag=true暂停，false恢复）
export function EXPauseUnit(u: any, flag: boolean): void {
  japi.EXPauseUnit(u, flag);
}

// 设置单位碰撞类型（enable=true启用，false禁用，t=碰撞类型）
export function EXSetUnitCollisionType(enable: boolean, u: any, t: number): void {
  japi.EXSetUnitCollisionType(enable, u, t);
}

// 设置单位移动类型（t=移动类型）
export function EXSetUnitMoveType(u: any, t: number): void {
  japi.EXSetUnitMoveType(u, t);
}

// 眩晕单位
export function YDWEUnitAddStun(u: any): void {
  EXPauseUnit(u, true);
}

// 解除眩晕
export function YDWEUnitRemoveStun(u: any): void {
  EXPauseUnit(u, false);
}

// 批量眩晕
export function YDWEUnitAddStunBatch(units: any[]): void {
  for (const u of units) {
    YDWEUnitAddStun(u);
  }
}

// 批量解除眩晕
export function YDWEUnitRemoveStunBatch(units: any[]): void {
  for (const u of units) {
    YDWEUnitRemoveStun(u);
  }
}

// 禁用单位碰撞（可穿越）
export function EXDisableUnitCollision(u: any, t: number = 0): void {
  EXSetUnitCollisionType(false, u, t);
}

// 启用单位碰撞
export function EXEnableUnitCollision(u: any, t: number = 0): void {
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
} as const;

const typeNames = ["ability", "buff", "unit", "item", "upgrade", "doodad", "destructable"];

/**
 * 读取物体编辑器数据（SLK）
 * @param objectType 物体类型（0-6），使用 ObjectType 常量
 * @param objectId 物体ID，传字符串四字码（如 'Hamg'）或 FourCC 整数
 * @param property 属性名（如 "Name", "Primary"）
 */
export function getObjectProperty(objectType: number, objectId: number | string, property: string): string {
  if (typeof objectId === "number") {
    const script = "(require'jass.slk')." + typeNames[objectType] + "[" + objectId.toString() + "]." + property;
    return japi.EXExecuteScript(script) || "";
  }

  const script = "(function() local _t=(require'jass.slk')." +
    typeNames[objectType] +
    "; local _u=_t and _t['" +
    objectId +
    "']; if _u then return _u." +
    property +
    " else return '' end end)()";
  return japi.EXExecuteScript(script) || "";
}

// 读取物体编辑器属性（整数）
export function getObjectPropertyInteger(objectType: number, objectId: number | string, property: string): number {
  const str = getObjectProperty(objectType, objectId, property);
  return parseInt(str) || 0;
}

// 读取物体编辑器属性（实数）
export function getObjectPropertyReal(objectType: number, objectId: number | string, property: string): number {
  const str = getObjectProperty(objectType, objectId, property);
  return parseFloat(str) || 0;
}

// ============================================
// 便捷函数
// ============================================

// 获取技能名称
export function getAbilityName(abilityId: number | string): string {
  return getObjectProperty(ObjectType.ABILITY, abilityId, "Name");
}

// 获取单位名称
export function getUnitName(unitId: number | string): string {
  return getObjectProperty(ObjectType.UNIT, unitId, "Name");
}

// 获取物品名称
export function getItemName(itemId: number | string): string {
  return getObjectProperty(ObjectType.ITEM, itemId, "Name");
}

// 获取技能Data值（field="A"/"B"/"C"/"D"...）
export function getAbilityData(abilityId: number | string, field: string, level: number): number {
  return getObjectPropertyInteger(ObjectType.ABILITY, abilityId, `Data${field}${level}`);
}

// 获取技能DataA值（快捷）
export function getAbilityDataA(abilityId: number | string, level: number): number {
  return getAbilityData(abilityId, "A", level);
}

export function EXExecuteScript(script: string): string {
  return japi.EXExecuteScript(script);
}

export function YDWEDistanceBetweenUnits(a: any, b: any): number {
  const dx = jass.GetUnitX(a) - jass.GetUnitX(b);
  const dy = jass.GetUnitY(a) - jass.GetUnitY(b);
  return jass.SquareRoot(dx * dx + dy * dy);
}

export function YDWEAngleBetweenUnits(fromUnit: any, toUnit: any): number {
  return jglobals.bj_RADTODEG * jass.Atan2(
    jass.GetUnitY(toUnit) - jass.GetUnitY(fromUnit),
    jass.GetUnitX(toUnit) - jass.GetUnitX(fromUnit)
  );
}

export {};
