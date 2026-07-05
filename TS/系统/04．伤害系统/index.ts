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
  require("系统.04．伤害系统.07．持续伤害系统");
  require("系统.04．伤害系统.02．dot伤害");
  require("系统.04．伤害系统.01．DOT定义.index");
  const 模型伤害数字 = require("系统.09．表现系统.09．伤害数字模型.index") as {
    initDamageNumberModelDisplay?: (this: void) => void;
  };
  const Boss战伤害统计 = require("系统.04．伤害系统.00．伤害计算.07．Boss战伤害统计") as {
    initBossBattleDamageStats?: (this: void) => void;
  };
  if (typeof 模型伤害数字.initDamageNumberModelDisplay === "function") {
    模型伤害数字.initDamageNumberModelDisplay();
  }
  if (typeof Boss战伤害统计.initBossBattleDamageStats === "function") {
    Boss战伤害统计.initBossBattleDamageStats();
  }
  require("系统.04．伤害系统.00．伤害计算.05．事件注册");
  require("系统.04．伤害系统.04．命中系统.index");
  require("系统.04．伤害系统.05．闪避系统.index");
  require("系统.04．伤害系统.06．暴击系统.index");

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
