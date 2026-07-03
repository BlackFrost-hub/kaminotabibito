/** @noSelfInFile */

import { 注册树魔首领运行时 } from "./01．运行时上下文";
import { 注册树魔首领技能结构 } from "./09．技能入口";

let 树魔首领被动已注册 = false;

export function 注册树魔首领被动效果(this: void): void {
  if (树魔首领被动已注册) return;
  树魔首领被动已注册 = true;
  注册树魔首领运行时();
  注册树魔首领技能结构();
}

注册树魔首领被动效果();
