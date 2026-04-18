/** @noSelfInFile */
/**
 * 宝箱系统 - 统一入口
 *
 * 功能：
 * - 玩家右键点击可交互目标，自动移动并开启
 * - 显示进度条和提示文字
 * - 开启成功触发STES事件
 *
 * 支持任意可交互目标类型（通过INTERACTABLE_TYPES配置）
 *
 * STES事件（JASS端可监听）：
 * - "玩家准备开启宝箱": 参数 YDLocal5Set("unit", "预开启者", ...) / ("destructable", "被预开启的宝箱", ...)
 * - "宝箱被开启": 参数 YDLocal5Set("unit", "开启者", ...) / ("destructable", "被开启的宝箱", ...)
 */

export * from "./00．常量定义";
export {
  onUnitTargetInteractable,
  onUnitTargetChest,
  isUnitOpening,
  isUnitOpeningChest,
  interruptOpening,
  interruptChestOpening,
  STES_EVENT_PREPARE,
  STES_EVENT_OPENED,
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  isInteractable,
  getOpenTime,
} from "./01．宝箱核心";
export {
  registerChestSystemHero,
  initChestSystem,
  STES_EVENT_UNIT_TARGET_ORDER,
} from "./02．事件注册";
