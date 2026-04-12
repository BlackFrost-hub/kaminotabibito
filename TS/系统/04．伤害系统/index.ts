/**
 * 伤害系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./02．DOT定义/index";

// ========== 核心模块导出 ==========
export * from "./01．伤害事件";
export * from "./02．dot伤害";
export * from "./03．伤害测试";

// ========== 初始化 ==========
require("系统.04．伤害系统.01．伤害事件");
require("系统.04．伤害系统.02．dot伤害");
// DOT定义通过index自动加载
require("系统.04．伤害系统.02．DOT定义.index");
require("系统.04．伤害系统.03．伤害测试");

/**
 * 初始化伤害系统
 */
export function init(): void {
}

// 自动初始化（可选）
// init();
