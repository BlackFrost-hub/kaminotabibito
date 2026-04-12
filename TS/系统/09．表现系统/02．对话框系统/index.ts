/**
 * 对话框系统 - 统一导出和初始化入口
 */

// ========== 子模块导出 ==========
export * from "./00．对话框UI入口";
export * from "./01．对话框渲染核心";
export * from "./02．打字机效果";
export * from "./03．对话框立绘系统";
export * from "./04．任务对话框";
export * from "./05．对话框业务逻辑";
export * from "./06．常量与工具";
export * from "./07．任务状态";
export * from "./08．配置查询";
export * from "./09．对话构建";
export * from "./10．选择触发入口";
export * from "./11．任务奖励解析";
export * from "./12．任务提交流程";
export * from "./13．任务奖励执行";
export * from "./14．任务展示文案";
export * from "./15．NPC头顶与气泡特效";
export * from "./16．对话框同步状态";

// ========== 初始化 ==========
// 注意：NPC生成器已在 00．配置表\index.ts 中初始化，不要重复调用
require("系统.09．表现系统.02．对话框系统.15．NPC头顶与气泡特效");
require("系统.09．表现系统.02．对话框系统.16．对话框同步状态");

// 初始化对话框系统
const 对话框UI = require("系统.09．表现系统.02．对话框系统.00．对话框UI入口") as { initDialogSystem?: () => void };
if (typeof 对话框UI.initDialogSystem === "function") 对话框UI.initDialogSystem();

// 初始化选择触发
const { initDialogEntrySelectionTrigger } = require("系统.09．表现系统.02．对话框系统.10．选择触发入口");
if (typeof initDialogEntrySelectionTrigger === "function") initDialogEntrySelectionTrigger();

/**
 * 初始化对话框系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[对话框系统] 初始化完成");
  }
}
