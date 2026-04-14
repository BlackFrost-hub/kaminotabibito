/**
 * 魔法消耗返还模块
 *
 * 功能：暗夜精灵族技能施放后返还部分魔法
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { PERCENT_COST_THRESHOLD } = require("系统.03．技能系统.02．技能消耗.00．消耗常量") as {
  PERCENT_COST_THRESHOLD: number;
};

//=============================================================================
// 一、技能种族检测
//=============================================================================

/**
 * 检查技能是否为暗夜精灵族
 */
export function isNightElfAbility(abilityId: number): boolean {
  const race = japi.YDWEGetObjectPropertyString(
    japi.YDWE_OBJECT_TYPE_ABILITY,
    abilityId,
    "race"
  );
  return race === "nightelf";
}

//=============================================================================
// 二、技能消耗计算
//=============================================================================

/**
 * 获取技能固定消耗
 */
export function getAbilityManaCost(unit: any, abilityId: number, level: number): number {
  return japi.YDWEGetUnitAbilityDataInteger(unit, abilityId, level, 104);
}

/**
 * 获取技能百分比消耗
 */
export function getAbilityPercentCost(unit: any, abilityId: number, level: number): number {
  return japi.YDWEGetUnitAbilityDataReal(unit, abilityId, level, 102);
}

/**
 * 计算技能总消耗
 */
export function calcTotalManaCost(
  unit: any,
  abilityId: number,
  level: number
): number {
  const fixedCost = getAbilityManaCost(unit, abilityId, level);
  const percentCost = getAbilityPercentCost(unit, abilityId, level);

  // 百分比消耗超过90%视为非通魔面板技能，不处理
  if (percentCost >= PERCENT_COST_THRESHOLD) {
    return -1;
  }

  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);
  return fixedCost + maxMana * percentCost;
}

//=============================================================================
// 三、魔法返还
//=============================================================================

/**
 * 获取魔法消耗减少属性
 */
export function getManaCostReduction(unit: any): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, "魔法消耗减少", "real");
}

/**
 * 执行魔法返还
 */
export function applyManaRefund(unit: any, manaCost: number): void {
  const reduction = getManaCostReduction(unit);
  if (reduction < 0.01) return;

  const refund = manaCost * reduction;
  const currentMana = jass.GetUnitState(unit, jass.UNIT_STATE_MANA);
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);

  // 不超过最大魔法
  const actualRefund = Math.min(refund, maxMana - currentMana);
  if (actualRefund <= 0) return;

  jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRefund);
}

//=============================================================================
// 四、统一处理入口
//=============================================================================

/**
 * 处理暗夜精灵族技能消耗返还
 *
 * @param unit 施法单位
 * @param abilityId 技能ID
 * @returns 是否执行了返还
 */
export function handleManaRefund(unit: any, abilityId: number): boolean {
  // 检查是否为暗夜精灵族技能
  if (!isNightElfAbility(abilityId)) {
    return false;
  }

  const level = jass.GetUnitAbilityLevel(unit, abilityId);
  const manaCost = calcTotalManaCost(unit, abilityId, level);

  // 非通魔面板技能
  if (manaCost < 0) {
    return false;
  }

  // 执行返还
  applyManaRefund(unit, manaCost);
  return true;
}

export {};
