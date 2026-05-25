/**
 * 单位初始化创建 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．玩家英雄/02．英雄升级系统/index";

// ========== 初始化 ==========
const 英雄升级系统 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.index") as { init?: () => void };
if (typeof 英雄升级系统.init === "function") 英雄升级系统.init();

/**
 * 初始化单位创建
 */
export function init(): void {
}
