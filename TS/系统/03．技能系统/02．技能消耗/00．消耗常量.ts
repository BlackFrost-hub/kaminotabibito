/**
 * 技能消耗常量配置
 */

//=============================================================================
// 一、魔法消耗相关
//=============================================================================

/** 百分比消耗阈值（超过此值视为非通魔面板技能） */
export const PERCENT_COST_THRESHOLD = 0.90;

//=============================================================================
// 二、特殊单位消耗相关
//=============================================================================

export type SpecialCostType = "health_instead_mana";

export interface SpecialUnitCostConfig {
  type: SpecialCostType;
  description?: string;
}

/**
 * 爱德华配置键。
 * 当前逻辑仍使用前半段显示名作为 YDUserData 缓存键，后半段用于统一格式预留。
 */
export const EDWARD_UNIT_CONFIG_KEY = "爱德华|H00Q";

/**
 * 特殊单位消耗处理配置表
 * key: 游戏中显示名|内部单位ID
 */
export const SPECIAL_UNIT_COST_CONFIG: Record<string, SpecialUnitCostConfig> = {
  // "爱德华|H00Q": { type: "health_instead_mana", description: "被动技能扣血代替扣蓝" },
};
