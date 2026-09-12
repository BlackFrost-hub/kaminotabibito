/** @noSelfInFile */

import { 初始化主线剧情入口 } from "./01．主线剧情入口/02．主线剧情入口初始化";
import { 初始化主线剧情物品事件 } from "./01．主线剧情入口/03．主线剧情物品事件初始化";
import { 初始化主线剧情特殊事件 } from "./01．主线剧情入口/04．主线剧情特殊事件初始化";
import { 初始化剧情步骤播放器 } from "./02．剧情步骤/02．剧情步骤播放器";
import { 初始化主线引导UI } from "./03．主线引导UI";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const MAINLINE_UI_INIT_LOG_MODULE = "主线任务/UI初始化";
const MAINLINE_UI_INIT_DELAY_MS = 8000;

function 延迟初始化主线引导UI(this: void): void {
  debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "开始延迟初始化", "delayMs=", MAINLINE_UI_INIT_DELAY_MS);
  初始化主线引导UI();
  debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "延迟初始化完成");
}

export function init(this: void): void {
  初始化剧情步骤播放器();
  初始化主线剧情入口();
  初始化主线剧情物品事件();
  初始化主线剧情特殊事件();
  // 2026-09-13：恢复主线引导 UI（此前双开 JAPI Frame 崩溃问题已完成隔离与分析，重新启用）
  debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "开始延迟初始化", "delayMs=", MAINLINE_UI_INIT_DELAY_MS);
  addDelayedCallback(MAINLINE_UI_INIT_DELAY_MS, 延迟初始化主线引导UI);
}
