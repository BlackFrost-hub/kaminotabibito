/** @noSelfInFile */

import { 注册卡瑟拉运行时 } from "./01．运行时上下文";
import { 注册卡瑟拉技能结构 } from "./12．技能入口";

let 卡瑟拉被动已注册 = false;

export function 注册卡瑟拉被动效果(this: void): void {
  if (卡瑟拉被动已注册) return;
  卡瑟拉被动已注册 = true;
  注册卡瑟拉运行时();
  注册卡瑟拉技能结构();
}

注册卡瑟拉被动效果();
