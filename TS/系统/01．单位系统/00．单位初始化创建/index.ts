/**
 * 单位初始化创建 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．玩家英雄/02．英雄升级系统/index";
export * from "./02．世界地图单位初始化/index";

// ========== 初始化 ==========
const 英雄升级系统 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.index") as { init?: () => void };
if (typeof 英雄升级系统.init === "function") 英雄升级系统.init();
const {
  启用世界地图单位TS初始化,
  启动世界地图全部单位缓步创建,
  延迟初始化世界地图Boss初始注册,
} = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.index") as {
  启用世界地图单位TS初始化?: boolean;
  启动世界地图全部单位缓步创建?: (this: void) => void;
  延迟初始化世界地图Boss初始注册?: (this: void) => void;
};

/**
 * 初始化单位创建
 */
export function init(): void {
  if (启用世界地图单位TS初始化 !== true) return;
  if (typeof 启动世界地图全部单位缓步创建 === "function") {
    启动世界地图全部单位缓步创建();
  }
  if (typeof 延迟初始化世界地图Boss初始注册 === "function") {
    延迟初始化世界地图Boss初始注册();
  }
}
