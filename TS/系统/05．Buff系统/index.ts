/**
 * Buff系统 - 统一导出和初始化入口
 */

// 导出核心模块
export * from "./00．Buff系统";
export * from "./01．Buff表";
export * from "./02．BuffUI";
export * from "./03．BuffJASS桥接";
export * from "./01．控制抗性/index";

// 加载所有子模块
const buffPoolCore = require("系统.05．Buff系统.00．Buff系统") as { initBuffSystem?: () => void };
if (typeof buffPoolCore.initBuffSystem === "function") buffPoolCore.initBuffSystem();
require("系统.05．Buff系统.01．Buff表");
const buffUIMod = require("系统.05．Buff系统.02．BuffUI") as { init?: () => void };
if (typeof buffUIMod.init === "function") buffUIMod.init();
require("系统.05．Buff系统.03．BuffJASS桥接");

// 初始化控制抗性系统
const controlResistMod = require("系统.05．Buff系统.01．控制抗性.index") as { initControlResist?: () => void };
if (typeof controlResistMod.initControlResist === "function") controlResistMod.initControlResist();

/**
 * 初始化Buff系统
 */
export function init(): void {
}

// 自动初始化（可选）
// init();
