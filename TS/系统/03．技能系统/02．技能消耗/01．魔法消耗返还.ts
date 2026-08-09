/** @noSelfInFile */
/**
 * 魔法消耗计算模块
 *
 * 功能：读取物编原始消耗，并计算写入单个单位技能实例的最终魔法消耗
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const {
  YDUserDataGetSafe,
  YDWEGetUnitAbilityDataIntegerSafe,
  YDWEGetUnitAbilityDataRealSafe,
} = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEGetUnitAbilityDataIntegerSafe: (this: void, u: any, abilcode: number, level: number, data_type: number) => number;
  YDWEGetUnitAbilityDataRealSafe: (this: void, u: any, abilcode: number, level: number, data_type: number) => number;
};
const { PERCENT_COST_THRESHOLD } = require("系统.03．技能系统.02．技能消耗.00．消耗常量") as {
  PERCENT_COST_THRESHOLD: number;
};

//=============================================================================
// 一、技能消耗计算
//=============================================================================

/**
 * 获取技能固定消耗
 */
export function getAbilityManaCost(this: void, unit: any, abilityId: number, level: number): number {
  return YDWEGetUnitAbilityDataIntegerSafe(unit, abilityId, level, 104);
}

/**
 * 获取技能百分比消耗
 */
export function getAbilityPercentCost(this: void, unit: any, abilityId: number, level: number): number {
  return YDWEGetUnitAbilityDataRealSafe(unit, abilityId, level, 102);
}

/**
 * 计算技能总消耗
 */
export function calcTotalManaCost(
  this: void,
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

  const maxMana = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
  return fixedCost + maxMana * percentCost;
}

//=============================================================================
// 二、魔法返还
//=============================================================================

/**
 * 获取魔法消耗属性
 */
export function getManaCostReduction(this: void, unit: any): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGetSafe("player", player, "魔法消耗", "real");
}

/**
 * 计算写入原生技能实例的最终魔法消耗。
 * 固定蓝耗读取物编原值；百分比蓝耗按当前最大魔法计算；最后套用技能消耗减少。
 */
export function 计算最终魔法消耗(this: void, unit: any, abilityId: number, level: number): number {
  const totalCost = calcTotalManaCost(unit, abilityId, level);
  const baseCost = totalCost > 0 ? totalCost : getAbilityManaCost(unit, abilityId, level);
  if (!(baseCost > 0)) return -1;

  const reduction = getManaCostReduction(unit);
  const reductionRatio = reduction < 0 ? -reduction : reduction;
  if (reductionRatio >= 1) return 0;

  const finalCost = baseCost * (1 - reductionRatio);
  return finalCost > 0 ? finalCost : 0;
}

export {};
