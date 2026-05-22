/** @noSelfInFile */

export * from "./00．主线任务配置表";
export * from "./01．主线配置驱动";

import { init主线剧情配置驱动 } from "./01．主线配置驱动";

export function init(this: void): void {
  init主线剧情配置驱动();
}
