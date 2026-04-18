/** @noSelfInFile */
/**
 * 伤害显示系统 - 统一入口
 *
 * 文件结构：
 * - 00．常量定义.ts    # 配置常量、颜色配置
 * - 02．核心功能.ts    # 伤害数字显示核心逻辑
 * - 03．Boss战统计.ts  # Boss战伤害统计
 * - 04．事件注册.ts    # 伤害事件注册与分发
 */

export * from "./00．常量定义";
export { showDamageNumber, updateAllDamageDigits, hasActiveDigits } from "./02．核心功能";
export {
  updateBossDamageStats,
  isInBossBattle,
  getBossUnit,
  getPlayerDamageToBoss,
  getPlayerDamageFromBoss,
} from "./03．Boss战统计";
export { initDamageDisplay } from "./04．事件注册";
