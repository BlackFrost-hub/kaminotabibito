/**
 * 核心系统 - 统一导出和初始化入口
 *
 * 加载顺序说明：
 * - 泄露审计先加载（被音效/漂浮文字依赖）
 * - 封装函数次之（被大量模块依赖）
 * - 其余按依赖顺序加载
 */

// ========== 核心模块导出 ==========
export * from "./01．封装函数";
export * from "./02．音效函数";
export * from "./03．漂浮文字函数";
export * from "./04．硬件函数";
export * from "./05．泄露审计";
export * from "./06．UI函数";
export * from "./13．镜头函数";
export * from "./14．颜色常量";

// ========== 初始化 ==========
// 按依赖顺序加载
require("系统.00．核心系统.05．泄露审计");
require("系统.00．核心系统.01．封装函数");
require("系统.00．核心系统.02．音效函数");
require("系统.00．核心系统.03．漂浮文字函数");
require("系统.00．核心系统.04．硬件函数");
require("系统.00．核心系统.13．镜头函数");
require("系统.00．核心系统.14．颜色常量");

/**
 * 初始化核心系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[核心系统] 初始化完成");
  }
}
