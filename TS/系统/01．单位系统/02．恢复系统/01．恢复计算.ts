/**
 * 恢复计算模块
 *
 * 功能：计算单位的基础恢复、百分比恢复、总恢复
 */

const jass = require("jass.common") as any;
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
export function calcBaseLifeRegen(unit: any): number {
  const strength = jass.GetHeroStr(unit, true);
  return strength * STRENGTH_TO_LIFE_REGEN;
}

/**
 * 计算基础魔法恢复（智力 × 0.15）
 */
export function calcBaseManaRegen(unit: any): number {
  const intelligence = jass.GetHeroInt(unit, true);
  return intelligence * INTELLIGENCE_TO_MANA_REGEN;
}

//=============================================================================
// 二、属性读取
//=============================================================================

/**
 * 读取单位/玩家属性
 */
function getAttr(unit: any, attrName: string): number {
  // 先读取单位属性
  const unitValue = YDUserDataGet("unit", unit, attrName, "real");
  if (unitValue !== 0) return unitValue;

  // 再读取玩家属性
  const player = jass.GetOwningPlayer(unit);
  if (player != null) {
    return YDUserDataGet("player", player, attrName, "real");
  }

  return 0;
}

/**
 * 读取玩家属性
 */
function getPlayerAttr(unit: any, attrName: string): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, attrName, "real");
}

//=============================================================================
// 三、百分比恢复计算
//=============================================================================

/**
 * 获取百分比生命恢复（应用上限）
 */
export function getPercentLifeRegen(unit: any): number {
  let value = getPlayerAttr(unit, "百分比生命回复");
  return value < LIFE_REGEN_PERCENT_CAP ? value : LIFE_REGEN_PERCENT_CAP;
}

/**
 * 获取百分比魔法恢复（应用上限）
 */
export function getPercentManaRegen(unit: any): number {
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
  unit: any,
  baseRegen: number,
  itemBonus: number,
  unitMultiplier: number
): number {
  // 固定生命恢复属性
  const fixedRegen = getAttr(unit, "生命恢复");

  // 百分比生命恢复
  const percentRegen = getPercentLifeRegen(unit);
  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);
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
export function calcTotalManaRegen(unit: any, baseRegen: number): number {
  // 固定魔法恢复属性
  const fixedRegen = getAttr(unit, "魔法恢复");

  // 百分比魔法恢复
  const percentRegen = getPercentManaRegen(unit);
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);
  const percentRegenValue = maxMana * percentRegen;

  return baseRegen + fixedRegen + percentRegenValue;
}

//=============================================================================
// 五、Boss恢复计算（简化版）
//=============================================================================

/**
 * 计算Boss总生命恢复（无百分比恢复）
 */
export function calcBossTotalLifeRegen(unit: any): number {
  const fixedRegen = getAttr(unit, "生命恢复");
  const amplify = getAttr(unit, "生命恢复属性增幅");

  return (1 + amplify) * fixedRegen;
}

export {};
