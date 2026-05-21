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
const ydweCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容");
const ydweBase = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const YDUserDataGetUnsafe = ydweCompat.YDUserDataGet;
const YDUserDataSetUnsafe = ydweCompat.YDUserDataSet;
const YDUserDataClearUnsafe = ydweCompat.YDUserDataClear;
const getObjectPropertyUnsafe = ydweBase.getObjectProperty;
const getObjectPropertyRealUnsafe = ydweBase.getObjectPropertyReal;
const getObjectPropertyIntegerUnsafe = ydweBase.getObjectPropertyInteger;
const YDWEGetUnitAbilityDataStringUnsafe = ydweBase.YDWEGetUnitAbilityDataString;
const YDWEGetUnitAbilityDataIntegerUnsafe = ydweBase.YDWEGetUnitAbilityDataInteger;
const YDWEGetUnitAbilityDataRealUnsafe = ydweBase.YDWEGetUnitAbilityDataReal;
const YDWESetUnitAbilityStateUnsafe = ydweBase.YDWESetUnitAbilityState;
const YDWESetUnitAbilityDataRealUnsafe = ydweBase.YDWESetUnitAbilityDataReal;
const YDWETimerDestroyEffectUnsafe = ydweBase.YDWETimerDestroyEffect;
export function YDUserDataGetSafe(tableType, tableKey, attr, valueType) {
    return YDUserDataGetUnsafe(undefined, tableType, tableKey, attr, valueType);
}
export function YDUserDataSetSafe(tableType, tableKey, attr, valueType, value) {
    YDUserDataSetUnsafe(undefined, tableType, tableKey, attr, valueType, value);
}
export function YDUserDataClearSafe(tableType, tableKey, attr, valueType) {
    YDUserDataClearUnsafe(undefined, tableType, tableKey, attr, valueType);
}
export function getObjectPropertySafe(objectType, objectId, property) {
    return getObjectPropertyUnsafe(undefined, objectType, objectId, property);
}
export function getObjectPropertyRealSafe(objectType, objectId, property) {
    return getObjectPropertyRealUnsafe(undefined, objectType, objectId, property);
}
export function getObjectPropertyIntegerSafe(objectType, objectId, property) {
    return getObjectPropertyIntegerUnsafe(undefined, objectType, objectId, property);
}
export function YDWEGetUnitAbilityDataStringSafe(unit, abilityId, level, dataType) {
    return YDWEGetUnitAbilityDataStringUnsafe(undefined, unit, abilityId, level, dataType);
}
export function YDWEGetUnitAbilityDataIntegerSafe(unit, abilityId, level, dataType) {
    return YDWEGetUnitAbilityDataIntegerUnsafe(undefined, unit, abilityId, level, dataType);
}
export function YDWEGetUnitAbilityDataRealSafe(unit, abilityId, level, dataType) {
    return YDWEGetUnitAbilityDataRealUnsafe(undefined, unit, abilityId, level, dataType);
}
export function YDWESetUnitAbilityStateSafe(unit, abilityId, stateType, value) {
    return YDWESetUnitAbilityStateUnsafe(undefined, unit, abilityId, stateType, value);
}
export function YDWESetUnitAbilityDataRealSafe(unit, abilityId, level, dataType, value) {
    return YDWESetUnitAbilityDataRealUnsafe(undefined, unit, abilityId, level, dataType, value);
}
export function YDWETimerDestroyEffectSafe(duration, effect) {
    YDWETimerDestroyEffectUnsafe(undefined, duration, effect);
}
export const 安全YDUserDataGet = YDUserDataGetSafe;
export const 安全YDUserDataSet = YDUserDataSetSafe;
export const 安全YDUserDataClear = YDUserDataClearSafe;
export const 安全读取对象属性 = getObjectPropertySafe;
export const 安全读取对象实数属性 = getObjectPropertyRealSafe;
export const 安全读取对象整数属性 = getObjectPropertyIntegerSafe;
export const 安全读取单位技能字符串 = YDWEGetUnitAbilityDataStringSafe;
export const 安全读取单位技能整数 = YDWEGetUnitAbilityDataIntegerSafe;
export const 安全读取单位技能实数 = YDWEGetUnitAbilityDataRealSafe;
export const 安全设置单位技能状态 = YDWESetUnitAbilityStateSafe;
export const 安全设置单位技能实数数据 = YDWESetUnitAbilityDataRealSafe;
export const 安全延时销毁特效 = YDWETimerDestroyEffectSafe;
