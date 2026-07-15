/** @noSelfInFile */

import { 注册影骨莫特斯运行时 } from "./01．运行时上下文";
import { 注册影骨莫特斯技能结构 } from "./09．技能入口";

let 影骨莫特斯被动已注册 = false;

export function 注册影骨莫特斯被动效果(this: void): void {
  if (影骨莫特斯被动已注册) return;
  影骨莫特斯被动已注册 = true;
  注册影骨莫特斯运行时();
  注册影骨莫特斯技能结构();
}

注册影骨莫特斯被动效果();
