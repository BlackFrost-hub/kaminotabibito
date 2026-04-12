/**
 * 主线NPC - 统一导出和初始化入口
 */

// ========== 子模块导出 ==========
export * from "./01．主线NPC";

// ========== 初始化 ==========
const { initMainStoryNPCsWithDelay } = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.01．主线NPC") as { initMainStoryNPCsWithDelay?: (delay: number) => void };

/**
 * 初始化主线NPC
 */
export function init(): void {
  if (typeof initMainStoryNPCsWithDelay === "function") {
    initMainStoryNPCsWithDelay(1.0);
  }
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[主线NPC] 初始化完成");
  }
}

// 兼容旧入口
export function initMainStoryNpcEntry(): void {
  init();
}
