/** @noSelfInFile */
/**
 * 治疗系统 - 统一导出和初始化入口
 */

// 导出常量
export * from "./00．常量定义";

// 导出核心功能
export * from "./01．核心功能";

// 导出治疗事件（旧版兼容）
export * from "./02．原生治疗入口";

// 导出持续治疗效果
export * from "./03．治疗事件入口";

// 导出物品治疗效果
export * from "./04．持续治疗效果";

// 导出魔法恢复
export * from "./05．物品治疗效果";

// 导出施法治疗事件（STES）
export * from "./06．魔法恢复";

// 导出生命减少
export * from "./07．减少生命值";

/**
 * 初始化治疗系统
 */
export function init(): void {
  // 初始化治疗事件系统（旧版）
  const nativeHealEntry = require("系统.04．伤害系统.02．治疗系统.02．原生治疗入口") as {
    initNativeHealEntry?: () => void;
  };
  if (typeof nativeHealEntry.initNativeHealEntry === "function") nativeHealEntry.initNativeHealEntry();

  // 初始化持续治疗效果系统
  const hotSystem = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果") as {
    initHotSystem?: () => void;
  };
  if (typeof hotSystem.initHotSystem === "function") hotSystem.initHotSystem();

  // 初始化施法治疗事件（STES）
  const healRequestEntry = require("系统.04．伤害系统.02．治疗系统.03．治疗事件入口") as {
    initHealRequestEntry?: () => void;
  };
  if (typeof healRequestEntry.initHealRequestEntry === "function") healRequestEntry.initHealRequestEntry();
}

