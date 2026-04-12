/**
 * 地形系统 - 统一导出和初始化入口
 */

// 导出核心模块
export * from "./01．镜头系统";
export * from "./02．区域传送配置";
export * from "./03．区域传送";
export * from "./04．激活传送点配置";
export * from "./05．激活传送点";

// 加载所有子模块
require("系统.07．地形系统.01．镜头系统");
require("系统.07．地形系统.02．区域传送配置");

const 区域传送 = require("系统.07．地形系统.03．区域传送") as { init区域传送?: () => void };
if (typeof 区域传送.init区域传送 === "function") 区域传送.init区域传送();

require("系统.07．地形系统.04．激活传送点配置");

const 激活传送点 = require("系统.07．地形系统.05．激活传送点") as { init激活传送点?: () => void };
if (typeof 激活传送点.init激活传送点 === "function") 激活传送点.init激活传送点();

/**
 * 初始化地形系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[地形系统] 初始化完成");
  }
}

// 自动初始化（可选）
// init();
