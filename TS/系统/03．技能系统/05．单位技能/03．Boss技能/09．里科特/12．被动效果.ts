/** @noSelfInFile */

import { 注册里科特运行时 } from "./01．运行时上下文";
import { 注册里科特技能结构 } from "./11．技能入口";

let 里科特被动已注册 = false;

export function 注册里科特被动效果(this: void): void {
  if (里科特被动已注册) return;
  里科特被动已注册 = true;
  注册里科特运行时();
  注册里科特技能结构();
}

注册里科特被动效果();
