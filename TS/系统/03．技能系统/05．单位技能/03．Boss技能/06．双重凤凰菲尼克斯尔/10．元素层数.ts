/** @noSelfInFile */

import type { 菲尼克斯尔元素类型 } from "./03．运行时上下文";
import { 添加元素层数, 减少元素层数, 取元素层数, 取最高元素 } from "./19．公共工具";

export function 注册菲尼克斯尔元素层数(this: void): void {
  // 元素层数由 Buff 池承载；具体叠层、衰减和爆发在各技能里调用公共工具。
}

export const 添加菲尼克斯尔元素层数 = 添加元素层数;
export const 减少菲尼克斯尔元素层数 = 减少元素层数;
export const 取菲尼克斯尔元素层数 = 取元素层数;
export const 取菲尼克斯尔最高元素 = 取最高元素;
export type 菲尼克斯尔元素 = 菲尼克斯尔元素类型;
