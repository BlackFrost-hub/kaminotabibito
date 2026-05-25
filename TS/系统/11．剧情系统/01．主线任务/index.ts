/** @noSelfInFile */

export * from "./00．主线任务配置表";
export * from "./01．主线配置驱动";
export * from "./02．剧情步骤";

import { init主线剧情配置驱动 } from "./01．主线配置驱动";
import { 初始化剧情步骤播放器 } from "./02．剧情步骤";

export function init(this: void): void {
  初始化剧情步骤播放器();
  init主线剧情配置驱动();
}
