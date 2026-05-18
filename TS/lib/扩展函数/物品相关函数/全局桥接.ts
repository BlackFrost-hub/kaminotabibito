/** @noSelfInFile */
 /* 物品相关函数 - 全局桥接
 * - 把物品相关函数挂到 globalThis
 * - 供其他模块直接使用
 */

import { 物品是否存在 } from "./物品判断函数";

function init(): void {
  const g = globalThis as any;
  if (typeof 物品是否存在 === "function" && typeof g.物品是否存在 !== "function") {
    g.物品是否存在 = 物品是否存在;
  }
}

init();

export {};
