/**
 * 对话框系统 - 统一导出和初始化入口
 */

// ========== 子模块导出 ==========
export * from "./00．对话框渲染核心";
export * from "./01．任务对话框";
export * from "./02．对话框业务逻辑";
export * from "./03．任务状态";
export * from "./04．对话构建";
export * from "./05．选择触发入口";
export * from "./06．任务奖励解析";
export * from "./07．任务提交流程";
export * from "./08．任务奖励执行";
export * from "./09．NPC头顶与气泡特效";
export * from "./10．对话框渲染-Dz与状态";
export * from "./11．对话框渲染-创建帧";
export * from "./12．对话框渲染-播放与状态管理";
export * from "./13．对话框渲染-任务回调与命中";

// ========== 初始化 ==========
// 注意：NPC生成器已在 00．配置表\index.ts 中初始化，不要重复调用
require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效");

// 初始化对话框系统
const 对话框UI = require("系统.09．表现系统.02．对话框系统.00．对话框渲染核心") as { initDialogSystem: () => void };
对话框UI.initDialogSystem();

// 初始化选择触发
const { initDialogEntrySelectionTrigger } = require("系统.09．表现系统.02．对话框系统.05．选择触发入口");
initDialogEntrySelectionTrigger();

/**
 * 初始化对话框系统
 */
export function init(): void {
}
