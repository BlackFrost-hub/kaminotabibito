/**
 * 单位恢复特性配置
 *
 * 配置哪些单位有特殊的恢复倍率
 */

//=============================================================================
// 单位恢复特性配置表
//=============================================================================

/**
 * 单位恢复特性配置
 */
export interface UnitRegenTrait {
  /** 生命恢复倍率 */
  lifeMultiplier: number;
  /** 魔法恢复倍率 */
  manaMultiplier: number;
}

/**
 * 单位恢复特性配置表
 *
 * key: 单位类型ID（字符串形式，如 'H00R'）
 * value: 恢复特性配置
 */
export const UNIT_REGEN_TRAITS: Record<string, UnitRegenTrait> = {
  /**
   * H00R: 生命恢复 × 1.6
   */
  'H00R': {
    lifeMultiplier: 1.6,
    manaMultiplier: 1.0,
  },
  // 可扩展更多单位...
};

//=============================================================================
// 单位特性获取函数
//=============================================================================

const jass = require("jass.common") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};

/**
 * 获取单位生命恢复倍率
 *
 * @param unit 目标单位
 * @returns 生命恢复倍率（默认1.0）
 */
export function getUnitLifeRegenMultiplier(unit: any): number {
  const unitTypeId = jass.GetUnitTypeId(unit);

  // 遍历配置，将字符串ID转换为FourCC后比较
  for (const [idStr, trait] of Object.entries(UNIT_REGEN_TRAITS)) {
    if (stringToFourCC(idStr) === unitTypeId) {
      return trait.lifeMultiplier;
    }
  }

  return 1.0;
}

/**
 * 获取单位魔法恢复倍率
 *
 * @param unit 目标单位
 * @returns 魔法恢复倍率（默认1.0）
 */
export function getUnitManaRegenMultiplier(unit: any): number {
  const unitTypeId = jass.GetUnitTypeId(unit);

  // 遍历配置，将字符串ID转换为FourCC后比较
  for (const [idStr, trait] of Object.entries(UNIT_REGEN_TRAITS)) {
    if (stringToFourCC(idStr) === unitTypeId) {
      return trait.manaMultiplier;
    }
  }

  return 1.0;
}

export {};
