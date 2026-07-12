/** @noSelfInFile */

import { 注册米亚运行时 } from "./03．运行时上下文";
import { 注册米亚技能结构 } from "./16．技能入口";

export function 注册米亚被动效果(this: void): void {
  注册米亚运行时();
  注册米亚技能结构();
}

注册米亚被动效果();
