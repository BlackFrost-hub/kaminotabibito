/**
 * 技能吟唱条系统 - 统一导出入口
 */

export * from "./00．常量定义";
export * from "./01．核心功能";

// 初始化
const castBarMod = require("系统.03．技能系统.07．技能吟唱条.01．核心功能") as { init?: () => void };
if (typeof castBarMod.init === "function") castBarMod.init();
