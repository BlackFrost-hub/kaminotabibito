/** @noSelfInFile */

import { 注册瑟兰迪尔运行时 } from "./03．运行时上下文";
import { 注册瑟兰迪尔技能结构 } from "./13．技能入口";

export function 注册瑟兰迪尔被动效果(this: void): void {
  注册瑟兰迪尔运行时();
  注册瑟兰迪尔技能结构();
}

注册瑟兰迪尔被动效果();
