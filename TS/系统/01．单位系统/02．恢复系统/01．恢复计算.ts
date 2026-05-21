/**
 * 恢复计算模块
 *
 * 功能：计算单位的基础恢复、百分比恢复、总恢复
 */

const jass = require("jass.common") as any;
const GetHeroStr = jass.GetHeroStr as (this: void, unit: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (this: void, unit: any, includeBonuses: boolean) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const {
  STRENGTH_TO_LIFE_REGEN,
  INTELLIGENCE_TO_MANA_REGEN,
  LIFE_REGEN_PERCENT_CAP,
  MANA_REGEN_PERCENT_CAP,
} = require("系统.01．单位系统.02．恢复系统.00．恢复常量") as {
  STRENGTH_TO_LIFE_REGEN: number;
  INTELLIGENCE_TO_MANA_REGEN: number;
  LIFE_REGEN_PERCENT_CAP: number;
  MANA_REGEN_PERCENT_CAP: number;
};

//=============================================================================
// 一、基础恢复计算
//=============================================================================

/**
 * 计算基础生命恢复（力量 × 0.32）
 */
export function calcBaseLifeRegen(this: void, unit: any): number {
  const strength = GetHeroStr(unit, true);
  return strength * STRENGTH_TO_LIFE_REGEN;
}

/**
 * 计算基础魔法恢复（智力 × 0.15）
 */
export function calcBaseManaRegen(this: void, unit: any): number {
  const intelligence = GetHeroInt(unit, true);
  return intelligence * INTELLIGENCE_TO_MANA_REGEN;
}

//=============================================================================
// 二、属性读取
//=============================================================================

/**
 * 读取单位/玩家属性
 */
function getAttr(this: void, unit: any, attrName: string): number {
  // 先读取单位属性
  const unitValue = YDUserDataGet("unit", unit, attrName, "real");
  if (unitValue !== 0) return unitValue;

  // 再读取玩家属性
  const player = GetOwningPlayer(unit);
  if (player != null) {
    return YDUserDataGet("player", player, attrName, "real");
  }

  return 0;
}

/**
 * 读取玩家属性
 */
function getPlayerAttr(this: void, unit: any, attrName: string): number {
  const player = GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, attrName, "real");
}

//=============================================================================
// 三、百分比恢复计算
//=============================================================================

/**
 * 获取百分比生命恢复（应用上限）
 */
export function getPercentLifeRegen(this: void, unit: any): number {
  let value = getPlayerAttr(unit, "百分比生命回复");
  return value < LIFE_REGEN_PERCENT_CAP ? value : LIFE_REGEN_PERCENT_CAP;
}

/**
 * 获取百分比魔法恢复（应用上限）
 */
export function getPercentManaRegen(this: void, unit: any): number {
  let value = getPlayerAttr(unit, "百分比魔法回复");
  return value < MANA_REGEN_PERCENT_CAP ? value : MANA_REGEN_PERCENT_CAP;
}

//=============================================================================
// 四、总恢复计算
//=============================================================================

/**
 * 计算总生命恢复
 *
 * 公式：(1 + 增幅) × (百分比恢复 + 固定恢复 + 基础恢复 + 装备加成 + 单位特性)
 */
export function calcTotalLifeRegen(
  this: void,
  unit: any,
  baseRegen: number,
  itemBonus: number,
  unitMultiplier: number
): number {
  // 固定生命恢复属性
  const fixedRegen = getAttr(unit, "生命恢复");

  // 百分比生命恢复
  const percentRegen = getPercentLifeRegen(unit);
  const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  const percentRegenValue = maxLife * percentRegen;

  // 生命恢复属性增幅
  const amplify = getPlayerAttr(unit, "生命恢复属性增幅");

  // 总恢复 = (1 + 增幅) × (基础恢复 + 装备加成) × 单位倍率 + 固定恢复 + 百分比恢复
  const totalBase = (baseRegen + itemBonus) * unitMultiplier + fixedRegen;
  const total = (1 + amplify) * (totalBase + percentRegenValue);

  return total;
}

/**
 * 计算总魔法恢复
 *
 * 公式：百分比恢复 + 固定恢复 + 基础恢复
 */
export function calcTotalManaRegen(this: void, unit: any, baseRegen: number): number {
  // 固定魔法恢复属性
  const fixedRegen = getAttr(unit, "魔法恢复");

  // 百分比魔法恢复
  const percentRegen = getPercentManaRegen(unit);
  const maxMana = GetUnitState(unit, UNIT_STATE_MAX_MANA);
  const percentRegenValue = maxMana * percentRegen;

  return baseRegen + fixedRegen + percentRegenValue;
}

//=============================================================================
// 五、Boss恢复计算（简化版）
//=============================================================================

/**
 * 计算Boss总生命恢复（无百分比恢复）
 */
export function calcBossTotalLifeRegen(this: void, unit: any): number {
  const fixedRegen = getAttr(unit, "生命恢复");
  const amplify = getAttr(unit, "生命恢复属性增幅");

  return (1 + amplify) * fixedRegen;
}

export {};
