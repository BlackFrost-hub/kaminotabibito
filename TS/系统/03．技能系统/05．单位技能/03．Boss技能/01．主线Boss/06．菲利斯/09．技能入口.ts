/** @noSelfInFile */

import { 注册菲利斯领袖光环 } from "./03．领袖光环";
import { 注册菲利斯剑魂杀 } from "./04．剑魂杀";
import { 注册菲利斯剑气灵斩 } from "./05．剑气灵斩";
import { 注册菲利斯全力封印斩 } from "./06．全力封印斩";
import { 注册菲利斯异形化 } from "./07．异形化";

export function 注册菲利斯技能结构(this: void): void {
  注册菲利斯领袖光环();
  注册菲利斯剑魂杀();
  注册菲利斯剑气灵斩();
  注册菲利斯全力封印斩();
  注册菲利斯异形化();
}
