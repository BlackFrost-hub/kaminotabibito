/**
 * 单位初始化创建 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./00．主线NPC/index";

// ========== 初始化 ==========
const 主线NPC = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.index") as { init?: () => void };
if (typeof 主线NPC.init === "function") 主线NPC.init();

/**
 * 初始化单位创建
 */
export function init(): void {
}
