/** @noSelfInFile */
/**
 * 宝箱系统 - 统一入口
 *
 * 功能：
 * - 玩家右键点击宝箱，自动移动并开启
 * - 显示进度条和提示文字
 * - 开启成功触发STES事件并执行掉落
 *
 * 配置方式（在 00.常量定义.ts 的 CHEST_TYPES 中添加）：
 * ```typescript
 * // 基础配置
 * { destructableType: "B00Z", openTime: 3.0, name: "普通宝箱", picks: 1, dropMode: { type: "score", range: { min: 100, max: 500 } } }
 *
 * // 带必掉物品（always字段的物品必定掉落，不参与随机）
 * { destructableType: "B012", openTime: 4.0, name: "特殊宝箱", picks: 2, dropMode: { type: "pool", items: "I01K:1.5;I06X:1", always: "I00V;I00W" } }
 * ```
 *
 * 掉落模式：
 * - score: { type: "score", range: { min: 100, max: 500 } } - 按分数范围随机
 * - pool: { type: "pool", items: "I01K:1.5;I06X:1", always?: "I00V" } - 指定物品池（带权重），always为必掉
 * - mixed: { type: "mixed", range: { min: 500, max: 1500 }, items: "I01K:2;I06X:1", always?: "I00V;I00W" } - 分数筛选+物品池，always为必掉
 *
 * STES事件（JASS端可监听）：
 * - "玩家准备开启宝箱": 参数 YDLocal5Set("unit", "预开启者", ...) / ("destructable", "被预开启的宝箱", ...)
 * - "宝箱被开启": 参数 YDLocal5Set("unit", "开启者", ...) / ("destructable", "被开启的宝箱", ...)
 */

// 核心配置与常量
export {
  // 类型定义
  ScoreRange,
  DropMode,
  ChestTypeConfig,
  // 配置表
  CHEST_TYPES,
  // 基础配置
  DEFAULT_OPEN_TIME,
  INTERACT_RANGE,
  UPDATE_INTERVAL,
  PROGRESS_BAR_SCALE,
  PROGRESS_BAR_HEIGHT_OFFSET,
  // 事件名
  EVENT_PLAYER_PREPARE_OPEN_CHEST,
  EVENT_CHEST_OPENED,
  // YDLocal变量名
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  // 提示文字
  TEXT_OPENING,
  TEXT_SUCCESS,
  TEXT_INTERRUPTED,
  // 查询函数
  isChestType,
  getChestConfig,
  getChestConfigByString,
} from "./00．常量定义";

// 核心功能（交互检测、进度条）
export {
  onUnitTargetInteractable,
  onUnitTargetChest,
  isUnitOpening,
  isUnitOpeningChest,
  interruptOpening,
  interruptChestOpening,
  STES_EVENT_PREPARE,
  STES_EVENT_OPENED,
  isInteractable,
  getOpenTime,
} from "./03．宝箱核心";

// 事件注册
export {
  registerChestSystemHero,
  initChestSystem,
  STES_EVENT_UNIT_TARGET_ORDER,
} from "./02．事件注册";

// 掉落执行
export {
  executeChestDrop,
  createDropItem,
  dropItemsFromChest,
  dropItemsByDestructable,
} from "./01．宝箱掉落配置";
