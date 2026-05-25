/** @noSelfInFile */
/**
 * YDUserData 安全封装
 *
 * 用途：
 * - 专门给 `@noSelfInFile` 文件使用
 * - 避免直接调用 `YDWE` 相关导出时，因为 TSTL / Lua 的 self 形态导致参数错位
 *
 * 规则：
 * - 在普通文件里，仍可直接用原版导出
 * - 在 `@noSelfInFile` 文件里，优先用这里的安全版
 *
 * AI 使用指引：
 * - 只要你在 `@noSelfInFile` 文件里需要调 `00．YDWE函数` / `01．YDUserData兼容`
 *   里的导出，优先先来本文件找是否已有安全版。
 * - 尤其优先使用这里的安全版来替代：
 *   - `YDUserDataGet / YDUserDataSet`
 *   - `getObjectProperty / getObjectPropertyReal`
 *   - `YDWEGetUnitAbilityDataString / Integer / Real`
 *   - `YDWESetUnitAbilityState / YDWESetUnitAbilityDataReal`
 * - 如果这里还没有对应安全包装，再新增到本文件，不要在业务文件里到处手写 `unsafe(undefined, ...)`。
 */

const ydweCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClear: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDUserDataHas: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => boolean;
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const ydweBase = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  getObjectProperty: (this: void, objectType: number, objectId: number | string, property: string) => string;
  getObjectPropertyReal: (this: void, objectType: number, objectId: number | string, property: string) => number;
  getObjectPropertyInteger: (this: void, objectType: number, objectId: number | string, property: string) => number;
  YDWEGetUnitAbilityDataString: (this: void, unit: any, abilityId: number, level: number, dataType: number) => string;
  YDWEGetUnitAbilityDataInteger: (this: void, unit: any, abilityId: number, level: number, dataType: number) => number;
  YDWEGetUnitAbilityDataReal: (this: void, unit: any, abilityId: number, level: number, dataType: number) => number;
  YDWESetUnitAbilityState: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
  YDWESetUnitAbilityDataReal: (this: void, unit: any, abilityId: number, level: number, dataType: number, value: number) => boolean;
  YDWETimerDestroyEffect: (this: void, duration: number, effect: any) => void;
  YDWEAngleBetweenUnits: (this: void, fromUnit: any, toUnit: any) => number;
};

const YDUserDataGetUnsafe = ydweCompat.YDUserDataGet as any;
const YDUserDataSetUnsafe = ydweCompat.YDUserDataSet as any;
const YDUserDataClearUnsafe = ydweCompat.YDUserDataClear as any;
const YDUserDataHasUnsafe = ydweCompat.YDUserDataHas as any;
const YDUserDataClearTableUnsafe = ydweCompat.YDUserDataClearTable as any;
const getObjectPropertyUnsafe = ydweBase.getObjectProperty as any;
const getObjectPropertyRealUnsafe = ydweBase.getObjectPropertyReal as any;
const getObjectPropertyIntegerUnsafe = ydweBase.getObjectPropertyInteger as any;
const YDWEGetUnitAbilityDataStringUnsafe = ydweBase.YDWEGetUnitAbilityDataString as any;
const YDWEGetUnitAbilityDataIntegerUnsafe = ydweBase.YDWEGetUnitAbilityDataInteger as any;
const YDWEGetUnitAbilityDataRealUnsafe = ydweBase.YDWEGetUnitAbilityDataReal as any;
const YDWESetUnitAbilityStateUnsafe = ydweBase.YDWESetUnitAbilityState as any;
const YDWESetUnitAbilityDataRealUnsafe = ydweBase.YDWESetUnitAbilityDataReal as any;
const YDWETimerDestroyEffectUnsafe = ydweBase.YDWETimerDestroyEffect as any;
const YDWEAngleBetweenUnitsUnsafe = ydweBase.YDWEAngleBetweenUnits as any;

export function YDUserDataGetSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string): any {
  return YDUserDataGetUnsafe(undefined, tableType, tableKey, attr, valueType);
}

export function YDUserDataSetSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any): void {
  YDUserDataSetUnsafe(undefined, tableType, tableKey, attr, valueType, value);
}

export function YDUserDataClearSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string): void {
  YDUserDataClearUnsafe(undefined, tableType, tableKey, attr, valueType);
}

export function YDUserDataHasSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string): boolean {
  return YDUserDataHasUnsafe(undefined, tableType, tableKey, attr, valueType) === true;
}

export function YDUserDataClearTableSafe(this: void, tableTypeName: string, tableKey: any): void {
  YDUserDataClearTableUnsafe(undefined, tableTypeName, tableKey);
}

export function getObjectPropertySafe(this: void, objectType: number, objectId: number | string, property: string): string {
  return getObjectPropertyUnsafe(undefined, objectType, objectId, property);
}

export function getObjectPropertyRealSafe(this: void, objectType: number, objectId: number | string, property: string): number {
  return getObjectPropertyRealUnsafe(undefined, objectType, objectId, property);
}

export function getObjectPropertyIntegerSafe(this: void, objectType: number, objectId: number | string, property: string): number {
  return getObjectPropertyIntegerUnsafe(undefined, objectType, objectId, property);
}

export function YDWEGetUnitAbilityDataStringSafe(this: void, unit: any, abilityId: number, level: number, dataType: number): string {
  return YDWEGetUnitAbilityDataStringUnsafe(undefined, unit, abilityId, level, dataType);
}

export function YDWEGetUnitAbilityDataIntegerSafe(this: void, unit: any, abilityId: number, level: number, dataType: number): number {
  return YDWEGetUnitAbilityDataIntegerUnsafe(undefined, unit, abilityId, level, dataType);
}

export function YDWEGetUnitAbilityDataRealSafe(this: void, unit: any, abilityId: number, level: number, dataType: number): number {
  return YDWEGetUnitAbilityDataRealUnsafe(undefined, unit, abilityId, level, dataType);
}

export function YDWESetUnitAbilityStateSafe(this: void, unit: any, abilityId: number, stateType: number, value: number): boolean {
  return YDWESetUnitAbilityStateUnsafe(undefined, unit, abilityId, stateType, value);
}

export function YDWESetUnitAbilityDataRealSafe(this: void, unit: any, abilityId: number, level: number, dataType: number, value: number): boolean {
  return YDWESetUnitAbilityDataRealUnsafe(undefined, unit, abilityId, level, dataType, value);
}

export function YDWETimerDestroyEffectSafe(this: void, duration: number, effect: any): void {
  YDWETimerDestroyEffectUnsafe(undefined, duration, effect);
}

export function YDWEAngleBetweenUnitsSafe(this: void, fromUnit: any, toUnit: any): number {
  return YDWEAngleBetweenUnitsUnsafe(undefined, fromUnit, toUnit);
}

export const 安全YDUserDataGet = YDUserDataGetSafe;
export const 安全YDUserDataSet = YDUserDataSetSafe;
export const 安全YDUserDataClear = YDUserDataClearSafe;
export const 安全YDUserDataHas = YDUserDataHasSafe;
export const 安全YDUserDataClearTable = YDUserDataClearTableSafe;
export const 安全读取对象属性 = getObjectPropertySafe;
export const 安全读取对象实数属性 = getObjectPropertyRealSafe;
export const 安全读取对象整数属性 = getObjectPropertyIntegerSafe;
export const 安全读取单位技能字符串 = YDWEGetUnitAbilityDataStringSafe;
export const 安全读取单位技能整数 = YDWEGetUnitAbilityDataIntegerSafe;
export const 安全读取单位技能实数 = YDWEGetUnitAbilityDataRealSafe;
export const 安全设置单位技能状态 = YDWESetUnitAbilityStateSafe;
export const 安全设置单位技能实数数据 = YDWESetUnitAbilityDataRealSafe;
export const 安全延时销毁特效 = YDWETimerDestroyEffectSafe;
export const 安全取两单位角度 = YDWEAngleBetweenUnitsSafe;
