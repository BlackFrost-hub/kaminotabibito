/**
 * 冷却缩减计算模块
 *
 * 功能：计算技能冷却缩减，应用上限
 */

const jass = require("jass.common") as any;
const {
  YDUserDataGet,
  YDWESetUnitAbilityDataReal,
  getObjectPropertyReal,
  ObjectType,
} = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWESetUnitAbilityDataReal: (u: any, abilcode: number, level: number, data_type: number, value: number) => boolean;
  getObjectPropertyReal: (objectType: number, objectId: number | string, property: string) => number;
  ObjectType: { ABILITY: number };
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const {
  COOLDOWN_REDUCTION_CAP,
  SKILL_COOLDOWN_CAPS,
  COOLDOWN_BLACKLIST,
} = require("系统.03．技能系统.01．技能冷却.00．冷却常量") as {
  COOLDOWN_REDUCTION_CAP: number;
  SKILL_COOLDOWN_CAPS: Record<string, number>;
  COOLDOWN_BLACKLIST: string[];
};

//=============================================================================
// 一、技能黑名单检测
//=============================================================================

/**
 * 检查技能是否在黑名单中
 */
export function isBlacklistedSkill(abilityId: number): boolean {
  return COOLDOWN_BLACKLIST.some(id => stringToFourCC(id) === abilityId);
}

/**
 * 检查单位是否为特殊单位（E001不参与冷却缩减）
 */
export function isExcludedUnit(unit: any): boolean {
  const unitTypeId = jass.GetUnitTypeId(unit);
  return unitTypeId === stringToFourCC('E001');
}

//=============================================================================
// 二、冷却缩减属性读取
//=============================================================================

/**
 * 获取冷却缩减属性
 */
export function getCooldownReduction(unit: any): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, "冷却缩减", "real");
}

/**
 * 获取冷却缩减加成属性（突破上限）
 */
export function getCooldownReductionBonus(unit: any): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, "冷却缩减加成", "real");
}

//=============================================================================
// 三、冷却上限计算
//=============================================================================

/**
 * 获取技能冷却上限
 *
 * @param abilityId 技能ID
 * @param hasBonus 是否有突破上限属性
 * @returns 冷却上限
 */
export function getCooldownCap(abilityId: number, hasBonus: boolean): number {
  // 检查技能独立上限
  for (const [idStr, cap] of Object.entries(SKILL_COOLDOWN_CAPS)) {
    if (stringToFourCC(idStr) === abilityId) {
      return cap;
    }
  }

  // 通用上限 + 突破加成
  if (hasBonus) {
    const bonus = 0; // 需要从单位读取
    return COOLDOWN_REDUCTION_CAP + bonus;
  }

  return COOLDOWN_REDUCTION_CAP;
}

/**
 * 应用冷却缩减上限
 */
export function applyCooldownCap(
  reduction: number,
  abilityId: number,
  bonus: number
): number {
  // 检查技能独立上限
  for (const [idStr, cap] of Object.entries(SKILL_COOLDOWN_CAPS)) {
    if (stringToFourCC(idStr) === abilityId) {
      return Math.min(reduction, cap);
    }
  }

  // 通用上限 + 突破加成
  const cap = COOLDOWN_REDUCTION_CAP + bonus;
  return Math.min(reduction, cap);
}

//=============================================================================
// 四、冷却时间计算
//=============================================================================

/**
 * 获取技能原始冷却时间
 */
export function getBaseCooldown(abilityId: number, level: number): number {
  // 使用YDWE函数读取技能冷却
  const coolKey = "Cool" + level;
  return getObjectPropertyReal(ObjectType.ABILITY, abilityId, coolKey);
}

/**
 * 计算实际冷却时间
 *
 * @param baseCooldown 原始冷却
 * @param reduction 冷却缩减比例
 * @returns 实际冷却时间
 */
export function calcActualCooldown(baseCooldown: number, reduction: number): number {
  if (reduction <= 0) return baseCooldown;
  return baseCooldown * (1 - reduction);
}

//=============================================================================
// 五、冷却设置
//=============================================================================

/**
 * 设置技能冷却时间
 */
export function setAbilityCooldown(
  unit: any,
  abilityId: number,
  level: number,
  cooldown: number
): void {
  // YDWESetUnitAbilityDataReal 参数105为冷却时间
  YDWESetUnitAbilityDataReal(unit, abilityId, level, 105, cooldown);
}

export {};
