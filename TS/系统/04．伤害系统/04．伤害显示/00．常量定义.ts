/** @noSelfInFile */
/**
 * 伤害显示系统 - 常量定义
 */

/** 最小伤害阈值（低于此值不显示） */
export const MIN_DAMAGE_THRESHOLD = 1.10;

/** 数字图片路径模板（0-9） */
export const DIGIT_IMAGE_PATH_TEMPLATE = "war3mapImported\\z{digit}-6.blp";

/** 数字图片基础大小 */
export const DIGIT_BASE_SIZE = 75.0;

/** 数字间距 */
export const DIGIT_SPACING = 25.0;

/** 初始偏移量基数 */
export const INITIAL_OFFSET_BASE = 27.5;

/** 显示持续时间（tick数，每tick=0.04秒） */
export const DISPLAY_DURATION_TICKS = 30;

/** 更新间隔（秒） */
export const UPDATE_INTERVAL = 0.04;

/** 上升速度（每tick上升的高度） */
export const RISE_SPEED = 20.0;

/** 基础高度 */
export const BASE_HEIGHT = 300.0;

/** 颜色配置接口 */
export interface ColorConfig {
  red: number;
  green: number;
  blue: number;
}

/** 伤害类型颜色配置 */
export const DAMAGE_TYPE_COLORS: Record<string, ColorConfig> = {
  /** 心灵（白色） */
  MIND: { red: 255, green: 255, blue: 255 },
  /** 普通（橙色） */
  NORMAL: { red: 160, green: 82, blue: 45 },
  /** 增强（橙色） */
  ENHANCED: { red: 255, green: 140, blue: 0 },
  /** 火焰（红色） */
  FIRE: { red: 255, green: 0, blue: 0 },
  /** 冰冻（蓝色） */
  COLD: { red: 0, green: 191, blue: 255 },
  /** 毒素（金色） */
  POISON: { red: 255, green: 215, blue: 0 },
  /** 植物（绿色） */
  PLANT: { red: 124, green: 252, blue: 0 },
  /** 暗影（紫色） */
  SHADOW: { red: 128, green: 0, blue: 128 },
  /** 魔法（蓝色） */
  MAGIC: { red: 0, green: 0, blue: 255 },
  /** 闪电（青色） */
  LIGHTNING: { red: 220, green: 255, blue: 255 },
  /** 神圣（金色） */
  DIVINE: { red: 255, green: 215, blue: 0 },
  /** 拆迁（棕色） */
  DEMOLITION: { red: 210, green: 105, blue: 30 },
};

/** 默认颜色（白色） */
export const DEFAULT_COLOR: ColorConfig = { red: 255, green: 255, blue: 255 };
