/**
 * 核心系统 - 统一导出和初始化入口
 *
 * 说明：
 * - 封装函数已迁移到 lib/扩展函数/封装函数/
 * - 这里仅保留 UI函数 和 颜色常量
 */

// ========== 从封装函数重新导出 ==========
export * from "../../lib/扩展函数/封装函数/index";

// ========== 核心模块导出 ==========
export * from "./01．UI函数";
export * from "./02．颜色常量";

// ========== 初始化 ==========
// 封装函数由 lib/扩展函数/index.ts 统一加载
// 这里仅加载核心系统特有的模块
require("系统.00．核心系统.01．UI函数");
require("系统.00．核心系统.02．颜色常量");

/**
 * 初始化核心系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[核心系统] 初始化完成");
  }
}
