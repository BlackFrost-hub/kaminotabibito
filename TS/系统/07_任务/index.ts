/**
 * 任务系统 - 统一导出和初始化入口
 */

// 导出数据结构
export * from "./任务数据";

// 导出任务管理器
export * from "./任务管理器";

// 导出任务UI
export * from "./任务UI";

// 初始化函数
export function init(): void {
  // 任务管理器会在首次使用时自动初始化
  // 这里可以添加额外的初始化逻辑
  const { questManager } = require("./任务管理器") as { questManager: any };
  questManager.initialize();
}

// 自动初始化（可选，也可以在main.ts中手动调用）
// init();