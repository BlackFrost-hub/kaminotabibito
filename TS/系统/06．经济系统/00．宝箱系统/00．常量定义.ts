/** @noSelfInFile */
/**
 * 宝箱系统 - 常量定义
 */

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (s: string) => number;
};

// ==========================================================================================
// 可交互目标类型配置（可扩展）
// ==========================================================================================

/** 可交互目标配置 */
export interface InteractableConfig {
  /** 可破坏物类型ID（字符串形式，如 'B00Z'） */
  destructableType: string;
  /** 开启时间（秒） */
  openTime: number;
  /** 名称（用于日志） */
  name: string;
}

/** 可交互目标类型列表（可扩展） */
export const INTERACTABLE_TYPES: InteractableConfig[] = [
  { destructableType: "B00Z", openTime: 3.0, name: "宝箱" },
  // 可在此添加更多类型：
  // { destructableType: "B010", openTime: 5.0, name: "大宝箱" },
  // { destructableType: "B011", openTime: 2.0, name: "小宝箱" },
];

/** 可交互目标类型ID集合（运行时生成，用于快速判断） */
const _interactableTypeIds = new Set<number>();
for (const config of INTERACTABLE_TYPES) {
  _interactableTypeIds.add(stringToFourCC(config.destructableType));
}

/** 可交互目标开启时间映射（类型ID -> 开启时间） */
const _openTimeMap = new Map<number, number>();
for (const config of INTERACTABLE_TYPES) {
  _openTimeMap.set(stringToFourCC(config.destructableType), config.openTime);
}

/** 可交互目标名称映射（类型ID -> 名称） */
const _nameMap = new Map<number, string>();
for (const config of INTERACTABLE_TYPES) {
  _nameMap.set(stringToFourCC(config.destructableType), config.name);
}

/**
 * 检查可破坏物类型ID是否为可交互目标
 */
export function isInteractableType(destructableTypeId: number): boolean {
  return _interactableTypeIds.has(destructableTypeId);
}

/**
 * 获取可交互目标的开启时间
 */
export function getInteractableOpenTime(destructableTypeId: number): number {
  return _openTimeMap.get(destructableTypeId) ?? DEFAULT_OPEN_TIME;
}

/**
 * 获取可交互目标的名称
 */
export function getInteractableName(destructableTypeId: number): string {
  return _nameMap.get(destructableTypeId) ?? "未知";
}

// ==========================================================================================
// 基础配置
// ==========================================================================================

/** 默认开启时间（秒） */
export const DEFAULT_OPEN_TIME = 3.0;

/** 检测范围（单位与目标的距离） */
export const INTERACT_RANGE = 150.0;

/** 计时器检测间隔（秒） */
export const UPDATE_INTERVAL = 0.05;

/** 进度条单位缩放 */
export const PROGRESS_BAR_SCALE = 3.0;

/** 进度条飞行高度偏移 */
export const PROGRESS_BAR_HEIGHT_OFFSET = 233.0;

// ==========================================================================================
// STES事件名
// ==========================================================================================

/** STES事件名：玩家准备开启宝箱 */
export const EVENT_PLAYER_PREPARE_OPEN_CHEST = "玩家准备开启宝箱";

/** STES事件名：宝箱被开启 */
export const EVENT_CHEST_OPENED = "宝箱被开启";

// ==========================================================================================
// YDLocal变量名
// ==========================================================================================

/** YDLocal变量名 - 开启者 */
export const YDLOCAL_VAR_OPENER = "开启者";

/** YDLocal变量名 - 被开启的宝箱 */
export const YDLOCAL_VAR_CHEST = "被开启的宝箱";

/** YDLocal变量名 - 预开启者 */
export const YDLOCAL_VAR_PRE_OPENER = "预开启者";

/** YDLocal变量名 - 被预开启的宝箱 */
export const YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱";

// ==========================================================================================
// 文本提示
// ==========================================================================================

/** 文本提示 */
export const TEXT_OPENING = "开启宝箱中...";
export const TEXT_SUCCESS = "宝箱被打开了！";
export const TEXT_INTERRUPTED = "宝箱开启失败！";
