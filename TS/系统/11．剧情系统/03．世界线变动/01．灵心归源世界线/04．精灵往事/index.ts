/** @noSelfInFile */

import { init祖地双灵卫试炼 } from "./03．祖地双灵卫试炼";
import { init祖地双灵卫入口与对话 } from "./04．祖地双灵卫入口与对话";
import { init祖地双灵卫传送与闸门 } from "./05．祖地双灵卫传送与闸门";
import { init祖地双灵卫Boss场景 } from "./06．祖地双灵卫Boss场景";
import { init祖地双灵卫奖励提交 } from "./07．祖地双灵卫奖励提交";

export function init(this: void): void {
  init祖地双灵卫试炼();
  init祖地双灵卫入口与对话();
  init祖地双灵卫传送与闸门();
  init祖地双灵卫Boss场景();
  init祖地双灵卫奖励提交();
}

export * from "./01．祖地双灵卫副本配置";
export * from "./02．祖地双灵卫副本状态";
export * from "./03．祖地双灵卫试炼";
export * from "./04．祖地双灵卫入口与对话";
export * from "./05．祖地双灵卫传送与闸门";
export * from "./06．祖地双灵卫Boss场景";
export * from "./07．祖地双灵卫奖励提交";
