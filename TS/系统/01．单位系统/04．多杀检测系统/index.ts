/**
 * 多杀检测系统 - 统一导出入口
 */

export * from "./00．常量定义";
export * from "./01．核心功能";
export * from "./02．STES事件触发";
export * from "./03．事件处理";

// 自动初始化
const eventMod = require("系统.01．单位系统.04．多杀检测系统.03．事件处理") as { initMultiKillSystem?: () => void };
if (typeof eventMod.initMultiKillSystem === "function") eventMod.initMultiKillSystem();
