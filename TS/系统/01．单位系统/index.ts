/**
 * 单位系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./00．单位初始化创建/index";

// ========== 核心模块导出 ==========
export * from "./单位狂暴";

// ========== 初始化 ==========
// 单位初始化创建子系统（通过index自动加载）
require("系统.01．单位系统.00．单位初始化创建.index");

// 单位狂暴
require("系统.01．单位系统.单位狂暴");

/**
 * 初始化单位系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[单位系统] 初始化完成");
  }
}

// 自动初始化（可选）
// init();
