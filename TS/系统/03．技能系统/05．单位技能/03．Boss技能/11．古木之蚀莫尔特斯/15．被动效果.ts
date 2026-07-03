/** @noSelfInFile */

import { 注册莫尔特斯运行时 } from "./01．运行时上下文";
import { 注册莫尔特斯技能结构 } from "./14．技能入口";

let 莫尔特斯被动已注册 = false;

export function 注册莫尔特斯被动效果(this: void): void {
  if (莫尔特斯被动已注册) return;
  莫尔特斯被动已注册 = true;
  注册莫尔特斯运行时();
  注册莫尔特斯技能结构();
}

注册莫尔特斯被动效果();
