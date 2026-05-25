/** @noSelfInFile */

export * from "./00．主线任务配置表";
export * from "./00．剧情系统核心工具";
export * from "./01．主线剧情入口";
export * from "./01．主线配置驱动";
export * from "./02．剧情步骤";

import { init主线剧情配置驱动 } from "./01．主线配置驱动";
import { 初始化主线剧情入口 } from "./01．主线剧情入口";
import { 初始化剧情步骤播放器 } from "./02．剧情步骤";

export function init(this: void): void {
  初始化剧情步骤播放器();
  初始化主线剧情入口();
  init主线剧情配置驱动();
}
