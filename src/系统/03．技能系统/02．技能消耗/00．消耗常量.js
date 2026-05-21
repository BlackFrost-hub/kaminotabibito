/** @noSelfInFile */
/**
 * 技能消耗常量配置
 */
//=============================================================================
// 一、魔法消耗相关
//=============================================================================
/** 百分比消耗阈值（超过此值视为非通魔面板技能） */
export const PERCENT_COST_THRESHOLD = 0.90;
/** 爱德华玩家英雄 rawcode。 */
export const EDWARD_HERO_ID = "H00Q";
/**
 * 特殊单位消耗处理配置表
 * key: 游戏中显示名|内部单位ID
 */
export const SPECIAL_UNIT_COST_CONFIG = {
// "爱德华|H00Q": { type: "health_instead_mana", description: "被动技能扣血代替扣蓝" },
};
