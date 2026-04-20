/**
 * 技能事件系统 - 统一导出入口
 */

export * from "./01．核心功能";

const spellEventMod = require("系统.03．技能系统.00．技能事件.01．核心功能") as { init: () => void };
spellEventMod.init();
