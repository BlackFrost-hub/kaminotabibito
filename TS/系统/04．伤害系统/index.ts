/**
 * 伤害系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．DOT定义/index";
export * from "./02．治疗系统/index";

// ========== 核心模块导出 ==========
export * from "./01．伤害事件";
export * from "./02．dot伤害";
export * from "./03．伤害测试";

// ========== 伤害计算模块导出 ==========
export * from "./00．伤害计算/index";

// ========== 模块预加载 ==========
require("系统.04．伤害系统.01．伤害事件");
require("系统.04．伤害系统.02．dot伤害");
require("系统.04．伤害系统.01．DOT定义.index");
require("系统.04．伤害系统.03．伤害测试");
require("系统.04．伤害系统.00．伤害计算.05．事件注册");
require("系统.04．伤害系统.02．治疗系统.index");

/**
 * 初始化伤害系统
 */
export function init(): void {
  // 治疗系统需要显式执行 init，单纯 require 模块不会自动注册 STES / 技能监听。
  const healSystem = require("系统.04．伤害系统.02．治疗系统.index") as {
    init?: () => void;
  };
  if (typeof healSystem.init === "function") {
    healSystem.init();
  }
}

// 自动初始化（可选）
// init();
