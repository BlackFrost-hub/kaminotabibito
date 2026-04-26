/**
 * 表现系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．UI工具/index";
//export * from "./02．对话框系统/index";
export * from "./03．UI属性系统/index";

// ========== 核心模块导出 ==========
export * from "./00．初始化UI";

// ========== 初始化 ==========
const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI: () => void };
原生UI.initNativeUI();

const UI属性系统 = require("系统.09．表现系统.03．UI属性系统.index") as { init?: () => void };

/**
 * 初始化表现系统
 */
export function init(): void {
  if (typeof UI属性系统.init === "function") {
    UI属性系统.init();
  }
}
