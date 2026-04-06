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
  const script = "(require'jass.slk')." + typeNames[objectType] + "['" + objectId + "']." + property;
  const result = japi.EXExecuteScript(script);
  return result || "";
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

export {};
