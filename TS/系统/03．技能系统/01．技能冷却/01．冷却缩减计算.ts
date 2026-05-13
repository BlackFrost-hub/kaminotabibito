/** @noSelfInFile */
/**
 * 冷却缩减计算模块
 *
 * 功能：计算技能冷却缩减，应用上限
 */

const jass = require("jass.common") as any;
const YD安全模块 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (
    this: void,
    tableType: string,
    tableKey: any,
    attr: string,
    valueType: string
  ) => any;
  getObjectPropertyRealSafe: (
    this: void,
    objectType: number,
    objectId: number | string,
    property: string
  ) => number;
  YDWESetUnitAbilityDataRealSafe: (
    this: void,
    unit: any,
    abilityId: number,
    level: number,
    dataType: number,
    value: number
  ) => boolean;
};
const 通用工具模块 = require("lib.扩展函数.封装函数.01．通用工具.index") as any;
const YD读取用户数据 = YD安全模块.YDUserDataGetSafe as (
  this: void,
  tableType: string,
  tableKey: any,
  attr: string,
  valueType: string
) => any;
const YD设置技能冷却数据 = YD安全模块.YDWESetUnitAbilityDataRealSafe as (
  this: void,
  unit: any,
  abilityId: number,
  level: number,
  dataType: number,
  value: number
) => boolean;
const YD读取对象实数属性 = YD安全模块.getObjectPropertyRealSafe as (
  this: void,
  objectType: number,
  objectId: number | string,
  property: string
) => number;
const 转四字节 = 通用工具模块.stringToFourCC as (this: void, raw: string) => number;
const 技能对象类型 = 0;
const {
  COOLDOWN_REDUCTION_CAP,
  SKILL_COOLDOWN_CAPS,
  COOLDOWN_BLACKLIST,
  EXCLUDED_COOLDOWN_UNIT,
} = require("系统.03．技能系统.01．技能冷却.00．冷却常量") as {
  COOLDOWN_REDUCTION_CAP: number;
  SKILL_COOLDOWN_CAPS: Record<string, number>;
  COOLDOWN_BLACKLIST: string[];
  EXCLUDED_COOLDOWN_UNIT: string;
};

function 提取内部ID(配置键名: string): string {
  if (!配置键名) return "";
  const 片段列表 = 配置键名.split("|");
  return 片段列表[片段列表.length - 1] ?? "";
}

//=============================================================================
// 一、技能黑名单检测
//=============================================================================

/**
 * 检查技能是否在黑名单中
 */
export function isBlacklistedSkill(abilityId: number): boolean {
  return COOLDOWN_BLACKLIST.some(配置键名 => 转四字节(提取内部ID(配置键名)) === abilityId);
}

/**
 * 检查单位是否为特殊单位（E001不参与冷却缩减）
 */
export function isExcludedUnit(unit: any): boolean {
  const unitTypeId = jass.GetUnitTypeId(unit);
  return unitTypeId === 转四字节(提取内部ID(EXCLUDED_COOLDOWN_UNIT));
}

//=============================================================================
// 二、冷却缩减属性读取
//=============================================================================

/**
 * 冷却属性读取规则：
 * 1. 先看单位属性。若单位值大于 0.01，优先使用，通常代表这是单独配置过属性的敌对单位。
 * 2. 否则回退到玩家属性。玩家侧默认只有一个英雄，因此玩家属性可视为该英雄的冷却属性来源。
 */
function getCooldownAttrValue(unit: any, attrName: string): number {
  if (unit == null) return 0;

  const unitValue = YD读取用户数据("unit", unit, attrName, "real");
  if (unitValue > 0.01) return unitValue;

  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YD读取用户数据("player", player, attrName, "real");
}

/**
 * 获取冷却缩减属性
 */
export function getCooldownReduction(unit: any): number {
  return getCooldownAttrValue(unit, "冷却缩减");
}

/**
 * 获取冷却缩减加成属性（突破上限）
 */
export function getCooldownReductionBonus(unit: any): number {
  return getCooldownAttrValue(unit, "冷却缩减加成");
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
  for (const [配置键名, cap] of Object.entries(SKILL_COOLDOWN_CAPS)) {
    if (转四字节(提取内部ID(配置键名)) === abilityId) {
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
  for (const [配置键名, cap] of Object.entries(SKILL_COOLDOWN_CAPS)) {
    if (转四字节(提取内部ID(配置键名)) === abilityId) {
      return reduction < cap ? reduction : cap;
    }
  }

  // 通用上限 + 突破加成
  const cap = COOLDOWN_REDUCTION_CAP + bonus;
  return reduction < cap ? reduction : cap;
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
  return YD读取对象实数属性(技能对象类型, abilityId, coolKey);
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
  YD设置技能冷却数据(unit, abilityId, level, 105, cooldown);
}

export {};
