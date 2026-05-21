/**
 * 控制重施放模块
 *
 * 功能：移除原控制，用马甲重新施放缩短时长的控制技能
 */
const jass = require("jass.common");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { YDWESetUnitAbilityDataReal } = require("lib.扩展函数.YDWE函数.index");
//=============================================================================
// 一、马甲配置
//=============================================================================
/** 控制马甲技能ID */
const CONTROL_ABILITY_ID = 0x41303531; // A051
/**
 * 获取辅助马甲单位类型
 */
export function getControlHelperUnitType() {
    return stringToFourCC("e02A");
}
//=============================================================================
// 二、控制重施放
//=============================================================================
/**
 * 移除原控制技能
 */
export function removeOriginalControl(unit, abilityId) {
    jass.UnitRemoveAbility(unit, abilityId);
    jass.IssueImmediateOrder(unit, "stop");
}
/**
 * 创建辅助马甲
 */
export function createControlHelper(caster, target) {
    const targetLoc = jass.GetUnitLoc(target);
    const helperType = getControlHelperUnitType();
    const helper = jass.CreateUnitAtLoc(jass.GetOwningPlayer(caster), helperType, targetLoc, 0);
    jass.RemoveLocation(targetLoc);
    return helper;
}
/**
 * 设置马甲控制技能持续时间
 */
export function setHelperAbilityDuration(helper, duration) {
    // 添加控制技能
    jass.UnitAddAbility(helper, CONTROL_ABILITY_ID);
    // 设置持续时间（字段102和103）
    YDWESetUnitAbilityDataReal(helper, CONTROL_ABILITY_ID, 1, 102, duration);
    YDWESetUnitAbilityDataReal(helper, CONTROL_ABILITY_ID, 1, 103, duration);
}
/**
 * 马甲施放控制技能
 */
export function helperCastControl(helper, target) {
    jass.IssueTargetOrder(helper, "thunderbolt", target);
}
/**
 * 执行控制重施放
 *
 * @param caster 原施法者
 * @param target 目标单位
 * @param abilityId 原技能ID
 * @param duration 控制时间
 */
export function recastControlAbility(caster, target, abilityId, duration) {
    // 1. 移除原控制
    removeOriginalControl(target, abilityId);
    // 2. 创建马甲
    const helper = createControlHelper(caster, target);
    // 3. 设置技能持续时间
    setHelperAbilityDuration(helper, duration);
    // 4. 施放控制
    helperCastControl(helper, target);
    // 注意：马甲单位会在技能施放后自动消失（根据地图配置）
}
