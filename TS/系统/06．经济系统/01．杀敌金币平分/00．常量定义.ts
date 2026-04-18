/** @noSelfInFile */
/**
 * 杀敌金币平分系统 - 常量定义
 */

// ==========================================================================================
// 基础配置
// ==========================================================================================

/** 平分范围（单位与死亡单位的距离） */
export const SHARE_RANGE = 1000.0;

/** 平分比例（基础赏金的百分比） */
export const SHARE_RATIO = 0.4; // 40%

/** 金币获取率阈值 */
export const GOLD_RATE_THRESHOLD = 0.01;

// ==========================================================================================
// STES事件常量
// ==========================================================================================

/** 数值显示事件名称 */
export const EVENT_VALUE_DISPLAY = "数值显示";

/** YDLocal变量名 */
export const YDLOCAL_VAR_UNIT = "ValueDisplayUnit";
export const YDLOCAL_VAR_REAL = "ValueDisplayReal";
export const YDLOCAL_VAR_BLUE = "ValueDisplayBlue";
export const YDLOCAL_VAR_SIZE = "ValueDisplaySize";
export const YDLOCAL_VAR_STRING = "ValueDisplayString";

/** 默认颜色（蓝色） */
export const DEFAULT_BLUE = 0.0;

/** 默认文字大小 */
export const DEFAULT_TEXT_SIZE = 10.0;

/** 金币字符串索引（udg_String[48]） */
export const GOLD_STRING_INDEX = 48;
