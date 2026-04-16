/**
 * 单位死亡事件系统 - 统一导出入口
 */

export * from "./01．核心功能";

const deathMod = require("系统.01．单位系统.03．单位死亡事件.01．核心功能") as { init?: () => void };
if (typeof deathMod.init === "function") deathMod.init();
