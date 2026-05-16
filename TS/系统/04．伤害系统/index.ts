/** @noSelfInFile */
/**
 * 伤害系统 - 初始化入口
 *
 * main 只需要 init，不在这里做 export * 聚合，避免把 DOT / 治疗 / 重伤 / 测试
 * 在加载期卷成一条导出链，触发 critical dependency。
 */

let 伤害系统已初始化 = false;

export function init(this: void): void {
  if (伤害系统已初始化) return;
  伤害系统已初始化 = true;

  require("系统.04．伤害系统.01．伤害事件");
  require("系统.04．伤害系统.02．dot伤害");
  require("系统.04．伤害系统.01．DOT定义.index");
  require("系统.04．伤害系统.03．伤害测试");
  require("系统.04．伤害系统.00．伤害计算.05．事件注册");

  const { init: initHealSystem } = require("系统.04．伤害系统.02．治疗系统.index") as {
    init?: (this: void) => void;
  };
  const { init: initWoundSystem } = require("系统.04．伤害系统.03．重伤系统.index") as {
    init?: (this: void) => void;
  };

  if (typeof initHealSystem === "function") {
    initHealSystem();
  }

  if (typeof initWoundSystem === "function") {
    initWoundSystem();
  }
}

export {};
