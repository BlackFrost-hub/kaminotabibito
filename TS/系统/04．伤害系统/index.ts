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

// ========== 预加载 ==========
require("系统.04．伤害系统.01．伤害事件");
require("系统.04．伤害系统.02．dot伤害");
require("系统.04．伤害系统.01．DOT定义.index");
require("系统.04．伤害系统.03．伤害测试");
require("系统.04．伤害系统.00．伤害计算.05．事件注册");
require("系统.04．伤害系统.02．治疗系统.index");
require("系统.04．伤害系统.03．重伤系统.index");

/**
 * 初始化伤害系统
 */
export function init(): void {
  const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
    debugLogForce: (this: void, module: string, ...args: any[]) => void;
  };
  const { init: initHealSystem } = require("系统.04．伤害系统.02．治疗系统.index") as {
    init?: () => void;
  };
  const { init: initWoundSystem } = require("系统.04．伤害系统.03．重伤系统.index") as {
    init?: () => void;
  };

  debugLogForce("伤害系统", "伤害系统init开始");

  if (typeof initHealSystem === "function") {
    debugLogForce("伤害系统", "调用治疗系统.init");
    initHealSystem();
  }

  if (typeof initWoundSystem === "function") {
    debugLogForce("伤害系统", "调用重伤系统.init");
    initWoundSystem();
  }

  debugLogForce("伤害系统", "伤害系统init完成");
}
