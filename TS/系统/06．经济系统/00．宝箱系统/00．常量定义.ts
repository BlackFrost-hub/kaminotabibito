/** @noSelfInFile */
/**
 * 宝箱系统 - 常量定义
 *
 * 配置说明：
 * - 一个宝箱类型包含：可破坏物ID、开启时间、名称、掉落模式
 * - 掉落模式支持：分数范围、指定物品池、混合模式、必掉物品
 */

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (s: string) => number;
};

// ==========================================================================================
// 掉落模式类型
// ==========================================================================================

/** 分数范围 */
export interface ScoreRange { min: number; max: number; }

/** 掉落模式类型 */
export type DropMode =
  | { type: "score"; range: ScoreRange; always?: string }           // 按分数范围随机，always为必掉物品
  | { type: "pool"; items: string; always?: string } // 指定物品池（带权重或不带），always为必掉物品
  | { type: "mixed"; range: ScoreRange; items: string; always?: string }; // 分数筛选+物品池权重，always为必掉物品

// ==========================================================================================
// 宝箱类型配置（核心配置，一个宝箱类型包含所有信息）
// ==========================================================================================

/** 宝箱类型配置 */
export interface ChestTypeConfig {
  /** 可破坏物类型ID（如 'B00Z'） */
  destructableType: string;
  /** 开启时间（秒） */
  openTime: number;
  /** 名称（用于日志和提示） */
  name: string;
  /** 掉落数量 */
  picks: number;
  /** 掉落模式 */
  dropMode: DropMode;
}

/** 宝箱类型配置表（在此添加所有宝箱类型） */
export const CHEST_TYPES: ChestTypeConfig[] = [
  // 普通宝箱 - 低分掉落
  { destructableType: "B00Z", openTime: 3.0, name: "普通宝箱", picks: 1, dropMode: { type: "score", range: { min: 100, max: 500 } } },

  // 另一个普通宝箱 - 同样配置
  { destructableType: "B003", openTime: 3.0, name: "普通宝箱", picks: 1, dropMode: { type: "score", range: { min: 100, max: 500 } } },

  // 中级宝箱 - 中分掉落
  // { destructableType: "B010", openTime: 5.0, name: "中级宝箱", picks: 2, dropMode: { type: "score", range: { min: 500, max: 1000 } } },

  // 高级宝箱 - 高分掉落
  // { destructableType: "B011", openTime: 5.0, name: "高级宝箱", picks: 2, dropMode: { type: "score", range: { min: 1000, max: 2000 } } },

  // 特殊宝箱 - 指定物品池（带权重）+ 必掉物品
  // { destructableType: "B012", openTime: 4.0, name: "特殊宝箱", picks: 2, dropMode: { type: "pool", items: "I01K:1.5;I06X:1;I06Y:2", always: "I00V" } },

  // 混合宝箱 - 分数筛选+物品池 + 必掉物品
  // { destructableType: "B013", openTime: 4.0, name: "混合宝箱", picks: 2, dropMode: { type: "mixed", range: { min: 500, max: 1500 }, items: "I01K:2;I06X:1", always: "I00V;I00W" } },
];

// ==========================================================================================
// 运行时生成的快速查找映射
// ==========================================================================================

/** 可破坏物类型ID集合（用于快速判断） */
const _chestTypeIds = new Set<number>();
for (const config of CHEST_TYPES) {
  _chestTypeIds.add(stringToFourCC(config.destructableType));
}

/** 可破坏物类型ID到配置的映射 */
const _chestConfigMap = new Map<number, ChestTypeConfig>();
for (const config of CHEST_TYPES) {
  _chestConfigMap.set(stringToFourCC(config.destructableType), config);
}

/**
 * 检查可破坏物类型ID是否为宝箱
 */
export function isChestType(destructableTypeId: number): boolean {
  return _chestTypeIds.has(destructableTypeId);
}

/**
 * 通过可破坏物类型ID获取宝箱配置
 */
export function getChestConfig(destructableTypeId: number): ChestTypeConfig | undefined {
  return _chestConfigMap.get(destructableTypeId);
}

/**
 * 通过可破坏物类型字符串获取宝箱配置
 */
export function getChestConfigByString(destructableType: string): ChestTypeConfig | undefined {
  return _chestConfigMap.get(stringToFourCC(destructableType));
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
// YDLocal变量名（用于STES事件传参）
// ==========================================================================================

/** YDLocal变量名：开启者 */
export const YDLOCAL_VAR_OPENER = "开启者";

/** YDLocal变量名：被开启的宝箱 */
export const YDLOCAL_VAR_CHEST = "被开启的宝箱";

/** YDLocal变量名：预开启者 */
export const YDLOCAL_VAR_PRE_OPENER = "预开启者";

/** YDLocal变量名：被预开启的宝箱 */
export const YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱";

// ==========================================================================================
// 提示文字
// ==========================================================================================

/** 提示文字：正在开启 */
export const TEXT_OPENING = (name: string) => `正在开启${name}...`;

/** 提示文字：开启成功 */
export const TEXT_SUCCESS = (name: string) => `${name}已开启！`;

/** 提示文字：开启中断 */
export const TEXT_INTERRUPTED = (name: string) => `${name}开启中断`;
