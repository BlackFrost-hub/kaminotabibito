/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 汭冥血杖强化物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 执行汭冥血杖献祭 } from "./19．汭冥血杖";

function 是否为汭冥血杖强化(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 汭冥血杖强化物品ID;
}

export function 处理汭冥血杖强化使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为汭冥血杖强化(上下文.物品)) return;
  执行汭冥血杖献祭(上下文, true);
}

export {};
