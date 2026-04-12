/**
 * 任务系统配置表 - 统一导出和初始化入口
 */

// ========== 配置表导出 ==========
export * from "./01．对话配置表";
export * from "./02．任务配置表";
export * from "./03．NPC配置表";
export * from "./04．NPC生成器";
export * from "./05．NPC初始化动作";
export * from "./06．主线任务配置表";

// ========== 初始化 ==========
require("系统.08．任务系统.00．配置表.01．对话配置表");
require("系统.08．任务系统.00．配置表.02．任务配置表");
require("系统.08．任务系统.00．配置表.03．NPC配置表");

const NPC生成器 = require("系统.08．任务系统.00．配置表.04．NPC生成器") as { init?: () => void };
if (typeof NPC生成器.init === "function") NPC生成器.init();

// 05．NPC初始化动作.ts 没有初始化函数，只有工具函数 runNpcInitAction
require("系统.08．任务系统.00．配置表.05．NPC初始化动作");

require("系统.08．任务系统.00．配置表.06．主线任务配置表");

/**
 * 初始化任务系统配置表
 */
export function init(): void {
}
