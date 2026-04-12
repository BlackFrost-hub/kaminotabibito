/**
 * 表现系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．UI工具/index";
export * from "./02．对话框系统入口/index";

// ========== 核心模块导出 ==========
export * from "./00．初始化UI";
export * from "./01．UI工具";
export * from "./02．垂直滚动条轨道";
export * from "./03．对话框UI";
export * from "./04．NPC对话状态池";

// ========== 初始化 ==========
const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI?: () => void };
if (typeof 原生UI.initNativeUI === "function") 原生UI.initNativeUI();

// UI工具子系统（通过index自动加载）
require("系统.09．表现系统.01．UI工具.index");

require("系统.09．表现系统.02．垂直滚动条轨道");

// 对话框系统入口子系统（通过index自动加载）
require("系统.09．表现系统.02．对话框系统入口.index");

require("系统.09．表现系统.03．对话框UI");
require("系统.09．表现系统.04．NPC对话状态池");

/**
 * 初始化表现系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[表现系统] 初始化完成");
  }
}
