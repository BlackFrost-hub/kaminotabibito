/**
 * 伤害系统常量定义
 *
 * 属性上限说明：
 * - 以下上限仅对玩家生效，敌对单位不受限制
 * - 玩家只有一个英雄，所以玩家属性 = 英雄属性
 * - 敌对有多个单位，每个单位独立计算属性
 */
//=============================================================================
// 一、属性上限常量
//=============================================================================
/**
 * 玩家属性上下限（仅对玩家生效）
 * 格式：{ max: 上限, min: 下限 }
 * 默认值：max = 1（无上限），min = -1（无下限）
 */
export const STAT_LIMITS = {
    "魔抗": { max: 0.50, min: -1 },
    "物理抗性": { max: 0.30, min: -1 },
    "技能抗性": { max: 0.80, min: -1 },
    "普攻抗性": { max: 0.80, min: -1 },
    "伤害减少%": { max: 0.80, min: -1 },
    "金属性抗性": { max: 0.80, min: -1 },
    "木属性抗性": { max: 0.80, min: -1 },
    "水属性抗性": { max: 0.80, min: -1 },
    "火属性抗性": { max: 0.80, min: -1 },
    "雷属性抗性": { max: 0.80, min: -1 },
    "光属性抗性": { max: 0.80, min: -1 },
    "暗属性抗性": { max: 0.80, min: -1 },
    "召唤物抗性": { max: 0.80, min: -1 },
    "最终伤害%": { max: 0.80, min: -1 },
    "伤害吸血": { max: 0.05, min: -1 },
    "魔法伤害吸血": { max: 0.15, min: -1 },
    "普攻伤害吸血": { max: 0.25, min: -1 },
    "伤害吸魔": { max: 0.05, min: -1 },
};
/**
 * 敌对单位属性上下限（仅对非玩家单位生效）
 * 格式：{ max: 上限, min: 下限 }
 * 默认值：max = 1（无上限），min = -1（无下限）
 */
export const ENEMY_STAT_LIMITS = {
    "魔抗": { max: 1, min: -1 },
    "物理抗性": { max: 1, min: -1 },
    "技能抗性": { max: 1, min: -1 },
    "普攻抗性": { max: 1, min: -1 },
    "伤害减少%": { max: 1, min: -1 },
    "金属性抗性": { max: 1, min: -1 },
    "木属性抗性": { max: 1, min: -1 },
    "水属性抗性": { max: 1, min: -1 },
    "火属性抗性": { max: 1, min: -1 },
    "雷属性抗性": { max: 1, min: -1 },
    "光属性抗性": { max: 1, min: -1 },
    "暗属性抗性": { max: 1, min: -1 },
    "召唤物抗性": { max: 1, min: -1 },
    "最终伤害%": { max: 1, min: -1 },
    "伤害吸血": { max: 1, min: -1 },
    "魔法伤害吸血": { max: 1, min: -1 },
    "普攻伤害吸血": { max: 1, min: -1 },
    "伤害吸魔": { max: 1, min: -1 },
};
/**
 * 可突破上限的属性配置
 * key: 属性名
 * value: 突破上限所需的特殊属性名
 */
export const BREAKABLE_LIMITS = {
    "伤害吸血": "伤害吸血上限",
    "伤害吸魔": "伤害吸魔突破",
};
//=============================================================================
// 二、属性叠加机制
//=============================================================================
/**
 * 叠加类型枚举
 */
export const STACK_TYPE = {
    /** 加法叠加：多个同类属性值相加，最终伤害 = 基础 × (1 + A + B + C) */
    ADDITIVE: "additive",
    /** 乘法叠加：独立乘区相乘，最终伤害 = 基础 × (1 + A) × (1 + B) × (1 + C) */
    MULTIPLICATIVE: "multiplicative",
    /** 取最高值：只取最大的那个值 */
    MAX: "max",
};
/**
 * 属性叠加方式配置
 *
 * 设计原则：
 * 1. 伤害加成类 → 加法叠加（避免收益递减过快）
 * 2. 抗性减伤类 → 乘法叠加（独立乘区，防止叠加过强）
 * 3. 移动速度 → 取最高值（防止无限加速）
 */
export const STAT_STACK_CONFIG = {
    //=========== 加法叠加（伤害加成类）===========
    // 格式：最终伤害 = 基础伤害 × (1 + 增加伤害总和)
    "伤害%": STACK_TYPE.ADDITIVE,
    "物理伤害": STACK_TYPE.ADDITIVE,
    "魔法伤害": STACK_TYPE.ADDITIVE,
    "强化伤害": STACK_TYPE.ADDITIVE,
    "技能伤害": STACK_TYPE.ADDITIVE,
    "普攻伤害": STACK_TYPE.ADDITIVE,
    "魔法普攻伤害": STACK_TYPE.ADDITIVE,
    "金属性伤害": STACK_TYPE.ADDITIVE,
    "木属性伤害": STACK_TYPE.ADDITIVE,
    "水属性伤害": STACK_TYPE.ADDITIVE,
    "火属性伤害": STACK_TYPE.ADDITIVE,
    "雷属性伤害": STACK_TYPE.ADDITIVE,
    "光属性伤害": STACK_TYPE.ADDITIVE,
    "暗属性伤害": STACK_TYPE.ADDITIVE,
    "召唤物伤害": STACK_TYPE.ADDITIVE,
    "蝼蚁专精": STACK_TYPE.ADDITIVE,
    "Boss专精": STACK_TYPE.ADDITIVE,
    //=========== 乘法叠加（抗性减伤类）===========
    // 格式：最终伤害 = 基础伤害 × (1 - 魔抗) × (1 - 物抗) × ...
    // 负数时：最终伤害 = 基础伤害 × (1 - (-0.2)) = 基础伤害 × 1.2（增加20%伤害）
    "魔抗": STACK_TYPE.MULTIPLICATIVE,
    "物理抗性": STACK_TYPE.MULTIPLICATIVE,
    "技能抗性": STACK_TYPE.MULTIPLICATIVE,
    "普攻抗性": STACK_TYPE.MULTIPLICATIVE,
    "伤害减少%": STACK_TYPE.MULTIPLICATIVE,
    "金属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "木属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "水属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "火属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "雷属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "光属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "暗属性抗性": STACK_TYPE.MULTIPLICATIVE,
    "召唤物抗性": STACK_TYPE.MULTIPLICATIVE,
    "最终伤害%": STACK_TYPE.MULTIPLICATIVE,
    //=========== 取最高值 ============
    "移动速度": STACK_TYPE.MAX,
};
//=============================================================================
// 三、伤害计算公式
//=============================================================================
/**
 * 伤害计算公式说明
 *
 * 最终伤害 = 初始伤害
 *          × (1 + 增加伤害总和)      // 加法叠加区
 *          × (1 - 魔抗)              // 独立乘区
 *          × (1 - 物理抗性)          // 独立乘区
 *          × (1 - 伤害减少%)         // 独立乘区
 *          × (1 - 技能抗性)          // 独立乘区
 *          × (1 - 普攻抗性)          // 独立乘区
 *          × (1 - 各属性抗性)        // 独立乘区
 *          × (1 + 最终伤害%)         // 独立乘区
 *
 * 示例：
 *   初始伤害 = 100
 *   物理伤害 = 0.2 (20%)
 *   技能伤害 = 0.1 (10%)
 *   魔抗 = 0.3 (30%)
 *   物抗 = 0.2 (20%)
 *
 *   增加伤害总和 = 0.2 + 0.1 = 0.3
 *   最终伤害 = 100 × (1 + 0.3) × (1 - 0.3) × (1 - 0.2)
 *            = 100 × 1.3 × 0.7 × 0.8
 *            = 72.8
 */
/**
 * 负数抗性处理规则
 *
 * 当抗性为负数时，表示受到额外伤害
 * 使用乘法叠加（独立乘区），避免加法叠加导致的极端数值
 *
 * 示例：
 *   魔抗 = -0.2 (负20%魔抗)
 *   最终伤害 = 基础伤害 × (1 - (-0.2)) = 基础伤害 × 1.2
 *   即：受到的魔法伤害增加20%
 *
 * 多个负抗性叠加：
 *   魔抗 = -0.2, 物抗 = -0.1
 *   最终伤害 = 基础伤害 × 1.2 × 1.1 = 基础伤害 × 1.32
 *   即：受到的伤害增加32%（而非加法的30%）
 *
 * 这样设计的好处：
 * 1. 防止负抗性叠加过强（乘法收益递减）
 * 2. 与正抗性计算方式一致，逻辑统一
 * 3. 符合魔兽争霸3的伤害计算习惯
 */
//=============================================================================
// 四、JASS错误属性名修正
//=============================================================================
/**
 * JASS代码中的错误属性名 → 正确属性名映射
 * 用于修正JASS代码中的属性名错误
 */
export const JASS_ATTR_NAME_FIX = {
    "受到的治疗加成": "受到的治疗率", // JASS写错了
    "最终伤害": "最终伤害%", // JASS漏了百分号
};
//=============================================================================
// 五、伤害类型常量
//=============================================================================
/**
 * 伤害类型对应的属性名映射
 * 用于根据伤害类型获取对应的伤害/抗性属性名
 */
export const DAMAGE_TYPE_ATTRS = {
    // 物理伤害
    DAMAGE_TYPE_NORMAL: { damage: "物理伤害", resist: "物理抗性" },
    // 强化伤害
    DAMAGE_TYPE_ENHANCED: { damage: "强化伤害", resist: "" },
    // 属性伤害
    DAMAGE_TYPE_SLOW_POISON: { damage: "金属性伤害", resist: "金属性抗性" },
    DAMAGE_TYPE_POISON: { damage: "金属性伤害", resist: "金属性抗性" },
    DAMAGE_TYPE_ACID: { damage: "金属性伤害", resist: "金属性抗性" },
    DAMAGE_TYPE_DISEASE: { damage: "金属性伤害", resist: "金属性抗性" },
    DAMAGE_TYPE_PLANT: { damage: "木属性伤害", resist: "木属性抗性" },
    DAMAGE_TYPE_COLD: { damage: "水属性伤害", resist: "水属性抗性" },
    DAMAGE_TYPE_FIRE: { damage: "火属性伤害", resist: "火属性抗性" },
    DAMAGE_TYPE_LIGHTNING: { damage: "雷属性伤害", resist: "雷属性抗性" },
    DAMAGE_TYPE_DIVINE: { damage: "光属性伤害", resist: "光属性抗性" },
    DAMAGE_TYPE_MAGIC: { damage: "魔法伤害", resist: "魔抗" },
    DAMAGE_TYPE_SHADOW_STRIKE: { damage: "暗属性伤害", resist: "暗属性抗性" },
    DAMAGE_TYPE_SONIC: { damage: "音属性伤害", resist: "音属性抗性" },
    DAMAGE_TYPE_UNIVERSAL: { damage: "最终伤害", resist: "" },
};
//=============================================================================
// 六、护甲公式常量
//=============================================================================
/**
 * 护甲减伤公式常量
 * 减伤比例 = 护甲 / (护甲 + ARMOR_FACTOR)
 */
export const ARMOR_FACTOR = 50;
//=============================================================================
// 七、辅助函数
//=============================================================================
/**
 * 获取属性值（应用上下限）
 * @param attrName 属性名
 * @param value 原始值
 * @param isPlayer 是否为玩家单位
 */
export function applyStatLimit(attrName, value, isPlayer) {
    const limit = isPlayer ? STAT_LIMITS[attrName] : ENEMY_STAT_LIMITS[attrName];
    if (limit === undefined)
        return value;
    if (value > limit.max)
        value = limit.max;
    if (value < limit.min)
        value = limit.min;
    return value;
}
/**
 * 修正JASS属性名
 * @param attrName JASS中的属性名
 * @returns 正确的属性名
 */
export function fixJassAttrName(attrName) {
    return JASS_ATTR_NAME_FIX[attrName] ?? attrName;
}
/**
 * 获取属性的叠加方式
 * @param attrName 属性名
 * @returns 叠加方式，默认为加法叠加
 */
export function getStackType(attrName) {
    return STAT_STACK_CONFIG[attrName] ?? STACK_TYPE.ADDITIVE;
}
