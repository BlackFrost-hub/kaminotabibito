/**
 * 控制重施放模块
 *
 * 功能：移除原控制，用马甲重新施放缩短时长的控制技能
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

//=============================================================================
// 一、马甲配置
//=============================================================================

/** 控制马甲技能ID */
const CONTROL_ABILITY_ID = 0x41303531; // A051

/**
 * 获取辅助马甲单位类型
 */
export function getControlHelperUnitType(): number {
  return YDUserDataGet("string", "辅助马甲（减控用）", "单位类型", "unitcode");
}

//=============================================================================
// 二、控制重施放
//=============================================================================

/**
 * 移除原控制技能
 */
export function removeOriginalControl(unit: any, abilityId: number): void {
  jass.UnitRemoveAbility(unit, abilityId);
  jass.IssueImmediateOrder(unit, "stop");
}

/**
 * 创建辅助马甲
 */
export function createControlHelper(caster: any, target: any): any {
  const targetLoc = jass.GetUnitLoc(target);
  const helperType = getControlHelperUnitType();

  const helper = jass.CreateUnitAtLoc(
    jass.GetOwningPlayer(caster),
    helperType,
    targetLoc,
    0
  );

  jass.RemoveLocation(targetLoc);
  return helper;
}

/**
 * 设置马甲控制技能持续时间
 */
export function setHelperAbilityDuration(
  helper: any,
  duration: number
): void {
  // 添加控制技能
  jass.UnitAddAbility(helper, CONTROL_ABILITY_ID);

  // 设置持续时间（字段102和103）
  japi.YDWESetUnitAbilityDataReal(helper, CONTROL_ABILITY_ID, 1, 102, duration);
  japi.YDWESetUnitAbilityDataReal(helper, CONTROL_ABILITY_ID, 1, 103, duration);
}

/**
 * 马甲施放控制技能
 */
export function helperCastControl(helper: any, target: any): void {
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
export function recastControlAbility(
  caster: any,
  target: any,
  abilityId: number,
  duration: number
): void {
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

export {};
