/** @noSelfInFile */

export * from "./00．剧情系统核心工具";
export * from "./01．主线剧情入口";
export * from "./02．剧情步骤";

import { 初始化主线剧情入口, 初始化主线剧情物品事件 } from "./01．主线剧情入口";
import { 初始化剧情步骤播放器 } from "./02．剧情步骤";

export function init(this: void): void {
  初始化剧情步骤播放器();
  初始化主线剧情入口();
  初始化主线剧情物品事件();
}
