/**
 * 技能吟唱条系统 - 常量定义
 *
 * 后续接手者：修改开关、模型路径、颜色配置请在此文件
 */

// ==========================================================================================
// 系统开关
// ==========================================================================================

/** 系统启用开关，true启用，false禁用 */
export const CAST_BAR_ENABLED = false;

// ==========================================================================================
// 计时器配置
// ==========================================================================================

/** 吟唱条更新间隔（秒） */
export const UPDATE_INTERVAL = 0.02;

// ==========================================================================================
// UI位置配置
// ==========================================================================================

/** 吟唱条X坐标（屏幕比例 0-1） */
export const BAR_POS_X = 0.549;

/** 吟唱条Y坐标（屏幕比例 0-1） */
export const BAR_POS_Y = 0.2;

/** 文本偏移X */
export const TEXT_OFFSET_X = -0.148;

/** 文本偏移Y */
export const TEXT_OFFSET_Y = 0.02;

/** 进度文本偏移X */
export const PROGRESS_OFFSET_X = -0.162;

/** 进度文本偏移Y */
export const PROGRESS_OFFSET_Y = 0.005;

/** 中间符号偏移X */
export const SYMBOL_OFFSET_X = -0.15;

/** 倒计时偏移X */
export const COUNTDOWN_OFFSET_X = -0.138;

/** 提示文本偏移X */
export const TIP_OFFSET_X = -0.12;

// ==========================================================================================
// 颜色ID配置
// ==========================================================================================

/** 颜色ID枚举 */
export const COLOR_ID = {
  /** 绿色（生命值样式） */
  GREEN: 1,
  /** 蓝色 */
  BLUE: 2,
  /** 橙色 */
  ORANGE: 3,
  /** 红色 */
  RED: 4,
  /** 紫色 */
  PURPLE: 5,
  /** 金色 */
  GOLD: 6,
  /** 棕色 */
  BROWN: 7,
} as const;

/** 默认颜色ID */
export const DEFAULT_COLOR_ID = COLOR_ID.GREEN;

// ==========================================================================================
// 模型路径配置
// ==========================================================================================

/** 前景模型路径映射 */
export const FOREGROUND_MODELS: Record<number, string> = {
  [COLOR_ID.GREEN]: "war3mapImported\\UI_shengmingzhi_gb2.mdx",
  [COLOR_ID.BLUE]: "war3mapImported\\UI_shengmingzhi_t1.mdx",
  [COLOR_ID.ORANGE]: "war3mapImported\\UI_shengmingzhi_o2.mdx",
  [COLOR_ID.RED]: "war3mapImported\\UI_shengmingzhi_r2.mdx",
  [COLOR_ID.PURPLE]: "war3mapImported\\UI_shengmingzhi_p2.mdx",
  [COLOR_ID.GOLD]: "war3mapImported\\UI_shengmingzhi_g2.mdx",
  [COLOR_ID.BROWN]: "war3mapImported\\UI_shengmingzhi_b2.mdx",
};

/** 背景模型路径映射 */
export const BACKGROUND_MODELS: Record<number, string> = {
  [COLOR_ID.GREEN]: "war3mapImported\\UI_shengmingzhi-beijing_gb2.mdx",
  [COLOR_ID.BLUE]: "war3mapImported\\UI_shengmingzhi-beijing_t1.mdx",
  [COLOR_ID.ORANGE]: "war3mapImported\\UI_shengmingzhi-beijing_o2.mdx",
  [COLOR_ID.RED]: "war3mapImported\\UI_shengmingzhi-beijing_r2.mdx",
  [COLOR_ID.PURPLE]: "war3mapImported\\UI_shengmingzhi-beijing_p2.mdx",
  [COLOR_ID.GOLD]: "war3mapImported\\UI_shengmingzhi-beijing_g2.mdx",
  [COLOR_ID.BROWN]: "war3mapImported\\UI_shengmingzhi-beijing_b2.mdx",
};

// ==========================================================================================
// 默认文本配置
// ==========================================================================================

/** 默认吟唱文本 */
export const DEFAULT_CAST_TEXT = "吟唱中";

/** 默认提示文本 */
export const DEFAULT_TIP_TEXT = "场地技能：";

// ==========================================================================================
// STES事件名
// ==========================================================================================

/** 注册吟唱条事件名 */
export const EVENT_NAME_CAST_BAR = "注册吟唱条";

// ==========================================================================================
// YDLocal变量名
// ==========================================================================================

/** YDLocal变量名常量 */
export const YDLOCAL_KEYS = {
  /** 颜色ID */
  COLOR_ID: "颜色ID",
  /** 总时间 */
  TOTAL_TIME: "sj",
  /** 已过时间 */
  ELAPSED_TIME: "s",
  /** 进度比例 */
  PROGRESS: "ss",
  /** 自定义字符串 */
  CUSTOM_STRING: "string",
  /** 前景帧 */
  FRAME_FOREGROUND: "前景",
  /** 背景帧 */
  FRAME_BACKGROUND: "背景",
  /** 显示文本帧 */
  FRAME_TEXT: "显示文本",
  /** 进度帧 */
  FRAME_PROGRESS: "进度",
  /** 中间符号帧 */
  FRAME_SYMBOL: "中间符号",
  /** 倒计时帧 */
  FRAME_COUNTDOWN: "倒计时",
  /** 文本提示帧 */
  FRAME_TIP: "文本提示",
} as const;

export {};
