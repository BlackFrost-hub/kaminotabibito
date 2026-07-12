/** @noSelfInFile */

import { 注册菲利斯运行时 } from "./01．运行时上下文";
import { 注册菲利斯技能结构 } from "./09．技能入口";

let 菲利斯被动已注册 = false;

export function 注册菲利斯被动效果(this: void): void {
  if (菲利斯被动已注册) return;
  菲利斯被动已注册 = true;
  注册菲利斯运行时();
  注册菲利斯技能结构();
}

注册菲利斯被动效果();
