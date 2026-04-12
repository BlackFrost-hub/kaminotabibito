/**
 * 对话框系统入口 - 统一导出和初始化入口
 */

// ========== 子模块导出 ==========
export * from "./01．常量与工具";
export * from "./02．任务状态";
export * from "./03．配置查询";
export * from "./04．对话构建";
export * from "./05．选择触发入口";
export * from "./06．任务奖励解析";
export * from "./07．任务提交流程";
export * from "./08．任务奖励执行";
export * from "./09．任务展示文案";

// ========== 初始化 ==========
// 加载NPC生成器
const NPC生成器 = require("系统.08．任务系统.00．配置表.04．NPC生成器") as { init?: () => void };
if (typeof NPC生成器.init === "function") NPC生成器.init();

// 加载NPC对话状态池
require("系统.09．表现系统.04．NPC对话状态池");

// 初始化对话框系统
const 对话框UI = require("系统.09．表现系统.03．对话框系统.00．对话框UI入口") as { initDialogSystem?: () => void };
if (typeof 对话框UI.initDialogSystem === "function") 对话框UI.initDialogSystem();

// 初始化选择触发
const { initDialogEntrySelectionTrigger } = require("系统.09．表现系统.02．对话框系统入口.05．选择触发入口");
if (typeof initDialogEntrySelectionTrigger === "function") initDialogEntrySelectionTrigger();

/**
 * 初始化对话框系统入口
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[对话框系统入口] 初始化完成");
  }
}
