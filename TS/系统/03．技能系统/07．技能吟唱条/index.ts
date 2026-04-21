/**
 * 技能吟唱条系统 - 统一导出入口
 */

export * from "./00．常量定义";
export * from "./01．核心功能";
export * from "./02．渲染";
export * from "./03．输入";

// 初始化（入口仍走 01．核心功能，其内部再调用 03．输入）
const castBarMod = require("系统.03．技能系统.07．技能吟唱条.01．核心功能") as { init: () => void };
castBarMod.init();
