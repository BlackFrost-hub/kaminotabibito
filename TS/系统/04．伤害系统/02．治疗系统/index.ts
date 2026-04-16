/**
 * 治疗系统 - 统一导出和初始化入口
 */

// 导出常量
export * from "./00．常量定义";

// 导出核心功能
export * from "./01．核心功能";

// 导出治疗事件（旧版兼容）
export * from "./02．治疗事件_旧版";

// 导出持续治疗效果
export * from "./03．持续治疗效果";

// 导出物品治疗效果
export * from "./04．物品治疗效果";

// 导出魔法恢复
export * from "./05．魔法恢复";

/**
 * 初始化治疗系统
 */
export function init(): void {
  // 初始化治疗事件系统（旧版）
  const healEventOld = require("系统.04．伤害系统.02．治疗系统.02．治疗事件_旧版") as {
    initHealEventOld?: () => void;
  };
  if (typeof healEventOld.initHealEventOld === "function") healEventOld.initHealEventOld();

  // 初始化持续治疗效果系统
  const hotSystem = require("系统.04．伤害系统.02．治疗系统.03．持续治疗效果") as {
    initHotSystem?: () => void;
  };
  if (typeof hotSystem.initHotSystem === "function") hotSystem.initHotSystem();
}
