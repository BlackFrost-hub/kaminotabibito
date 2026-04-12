/**
 * 表现系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．UI工具/index";
export * from "./02．对话框系统/index";

// ========== 核心模块导出 ==========
export * from "./00．初始化UI";
export * from "./01．UI工具/index";
export * from "./03．垂直滚动条轨道";

// ========== 初始化 ==========
const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI?: () => void };
if (typeof 原生UI.initNativeUI === "function") 原生UI.initNativeUI();

// UI工具子系统（通过index自动加载）
require("系统.09．表现系统.01．UI工具.index");

require("系统.09．表现系统.03．垂直滚动条轨道");

// 对话框系统（含 NPC 头顶/气泡 + 状态池）
require("系统.09．表现系统.02．对话框系统.index");

/**
 * 初始化表现系统
 */
export function init(): void {
}
