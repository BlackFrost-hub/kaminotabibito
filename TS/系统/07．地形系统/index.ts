/**
 * 地形系统 - 统一导出和初始化入口
 */

// 导出核心模块
export * from "./02．区域传送配置";
export * from "./03．区域传送";
export * from "./04．激活传送点配置";
export * from "./05．激活传送点";
export * from "./06．可破坏物数据";
export * from "./07．区域背景音乐";

// 加载所有子模块
require("系统.07．地形系统.02．区域传送配置");

const 区域传送 = require("系统.07．地形系统.03．区域传送") as { init区域传送: () => void };
区域传送.init区域传送();

require("系统.07．地形系统.04．激活传送点配置");

const 激活传送点 = require("系统.07．地形系统.05．激活传送点") as { init激活传送点: () => void };
激活传送点.init激活传送点();

require("系统.07．地形系统.07．区域背景音乐.01．区域背景音乐配置表");

const 区域背景音乐 = require("系统.07．地形系统.07．区域背景音乐.02．区域背景音乐") as {
  init区域背景音乐: () => void;
};
区域背景音乐.init区域背景音乐();

/**
 * 初始化地形系统
 */
export function init(): void {
}

// 自动初始化（可选）
// init();
