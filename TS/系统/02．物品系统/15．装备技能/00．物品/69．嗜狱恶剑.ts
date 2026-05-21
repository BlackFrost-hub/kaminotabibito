/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 造成精神自伤 } from "../05．物品使用/00．公共/02．物品使用工具";

export function 处理嗜狱恶剑使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.嗜狱恶剑)) return;
  造成精神自伤(ctx.施法单位, 物品使用数值配置.嗜狱恶剑.自伤);
}

export {};
