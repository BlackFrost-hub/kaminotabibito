/** @noSelfInFile */
/**
 * 便捷短函数 - 快速治疗
 *
 * 只做技能侧短名转发，不改底层参数顺序：
 * 来源单位 -> 目标单位 -> 治疗量
 */
const { spellHeal, itemHeal, regenHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
/** 快速技能治疗。参数顺序：来源单位 -> 目标单位 -> 治疗量 -> 是否显示特效 -> 特效路径 */
export const 快速治疗 = spellHeal;
/** 快速物品治疗。参数顺序：来源单位 -> 目标单位 -> 治疗量 -> 是否显示特效 -> 特效路径 */
export const 快速物品治疗 = itemHeal;
/** 快速生命恢复。参数顺序：目标单位 -> 治疗量 */
export const 快速恢复 = regenHeal;
