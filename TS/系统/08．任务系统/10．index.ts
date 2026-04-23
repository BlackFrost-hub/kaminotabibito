/**
 * 任务系统 - 统一导出和初始化入口
 */

// ========== 子系统导出（只加载，不重复导出类型） ==========
// 配置表子系统 - 通过require加载，避免与核心模块类型冲突
require("系统.08．任务系统.00．配置表.index");

// 任务UI拆分子系统
export * from "./04．任务UI拆分/index";

// ========== 核心模块导出 ==========
export * from "./01．任务数据";
export * from "./02．任务管理器/index";
export * from "./03．任务UI";
export * from "./05．任务STES配置表";
export * from "./06．任务STES桥接";
export * from "./07．任务事件桥接";
export * from "./08．任务目标更新";
export * from "./09．主线配置驱动";

// ========== 初始化 ==========
// 任务数据
require("系统.08．任务系统.01．任务数据");

// 任务管理器
const 任务管理器 = require("系统.08．任务系统.02．任务管理器.index") as { init?: () => void };
if (typeof 任务管理器.init === "function") 任务管理器.init();
const { questDB, QuestType, QuestStatus } = require("系统.08．任务系统.01．任务数据") as any;
const { questManager } = require("系统.08．任务系统.02．任务管理器.index") as any;

// 任务UI
const 任务UI = require("系统.08．任务系统.03．任务UI") as { init?: () => void; registerHotkey?: () => void };
if (typeof 任务UI.init === "function") 任务UI.init();
if (typeof 任务UI.registerHotkey === "function") 任务UI.registerHotkey();

// 任务UI拆分（通过index自动加载）
 require("系统.08．任务系统.04．任务UI拆分.index");

// STES桥接
require("系统.08．任务系统.05．任务STES配置表");
require("系统.08．任务系统.06．任务STES桥接");

// 事件桥接
require("系统.08．任务系统.07．任务事件桥接");

// 目标更新
require("系统.08．任务系统.08．任务目标更新");

// 主线配置驱动
require("系统.08．任务系统.09．主线配置驱动");

const ENABLE_TASK_UI_SCROLL_STRESS_TEST = false;
const TASK_UI_SCROLL_STRESS_COUNT = 20;

/**
 * 初始化任务系统
 */
export function init(): void {
}
