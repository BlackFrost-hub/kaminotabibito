/**
 * 动态技能说明系统 - 常量定义
 *
 * 后续接手者：修改开关请在此文件
 */

// ==========================================================================================
// 系统开关
// ==========================================================================================

/** 系统启用开关，true启用，false禁用 */
export const DYNAMIC_SKILL_TIP_ENABLED = true;

// ==========================================================================================
// JASS事件ID常量（当jass常量不可用时的备用值）
// ==========================================================================================

/** 英雄升级事件ID */
export const EVENT_ID_HERO_LEVEL = 46;

/** 单位死亡事件ID */
export const EVENT_ID_UNIT_DEATH = 52;

/** 中立敌对玩家ID */
export const PLAYER_NEUTRAL_AGGRESSIVE = 12;

/** 中立被动玩家ID */
export const PLAYER_NEUTRAL_PASSIVE = 15;

/** 玩家数量 */
export const PLAYER_COUNT = 16;

// ==========================================================================================
// 单位状态常量（原生JASS未暴露的）
// ==========================================================================================

/** 攻击1基础伤害 */
export const UNIT_STATE_ATTACK1_BASE = 0x12;

/** 攻击1加成（绿字攻击） */
export const UNIT_STATE_ATTACK1_BONUS = 0x10;

/** 护甲 */
export const UNIT_STATE_ARMOR = 0x20;

// ==========================================================================================
// 运算符常量
// ==========================================================================================

/** 中文乘号 */
export const OPERATOR_MULTIPLY_CN = "×";

/** 中文除号 */
export const OPERATOR_DIVIDE_CN = "÷";

/** 英文乘号 */
export const OPERATOR_MULTIPLY_EN = "*";

/** 英文除号 */
export const OPERATOR_DIVIDE_EN = "/";

// ==========================================================================================
// 括号常量
// ==========================================================================================

/** 英文左括号 */
export const BRACKET_LEFT_EN = "[";

/** 英文右括号 */
export const BRACKET_RIGHT_EN = "]";

/** 中文左括号 */
export const BRACKET_LEFT_CN = "（";

/** 中文右括号 */
export const BRACKET_RIGHT_CN = "）";

// ==========================================================================================
// 属性变量名常量
// ==========================================================================================

/** 技能等级变量名 */
export const ATTR_SKILL_LEVEL = "技能等级";

/** 力量（含绿字） */
export const ATTR_STR = "力量";

/** 敏捷（含绿字） */
export const ATTR_AGI = "敏捷";

/** 智力（含绿字） */
export const ATTR_INT = "智力";

/** 力量白字 */
export const ATTR_STR_WHITE = "基础力量";

/** 敏捷白字 */
export const ATTR_AGI_WHITE = "基础敏捷";

/** 智力白字 */
export const ATTR_INT_WHITE = "基础智力";

/** 当前生命 */
export const ATTR_HP = "生命";

/** 最大生命 */
export const ATTR_HP_MAX = "最大生命";

/** 当前魔法 */
export const ATTR_MP = "魔法";

/** 最大魔法 */
export const ATTR_MP_MAX = "最大魔法";

/** 攻击力 */
export const ATTR_ATTACK = "攻击力";

/** 护甲 */
export const ATTR_ARMOR = "护甲";

/** 移动速度 */
export const ATTR_MOVE_SPEED = "移动速度";

/** 英雄等级 */
export const ATTR_LEVEL = "等级";

/** 英雄等级（别名） */
export const ATTR_HERO_LEVEL = "英雄等级";

/** 经验值 */
export const ATTR_XP = "经验";

// ==========================================================================================
// 格式化常量
// ==========================================================================================

/** 小数精度（位数） */
export const DECIMAL_PRECISION = 2;

/** 小数精度乘数 */
export const DECIMAL_MULTIPLIER = 100;
