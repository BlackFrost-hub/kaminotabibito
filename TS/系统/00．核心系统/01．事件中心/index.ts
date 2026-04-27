/** @noSelfInFile */
// Unified event-center package entry.

export * from "./01．玩家单位事件";
export * from "./02．区域事件中心";
export * from "./03．单位特定事件中心";
export * from "./04．物品事件中心";
export * from "./05．玩家选中单位事件中心";
export * from "./06．英雄升级事件中心";

require("系统.00．核心系统.01．事件中心.01．玩家单位事件");
require("系统.00．核心系统.01．事件中心.02．区域事件中心");
require("系统.00．核心系统.01．事件中心.03．单位特定事件中心");
require("系统.00．核心系统.01．事件中心.04．物品事件中心");
require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心");
require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心");

export {};
