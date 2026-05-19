/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 造成精神自伤 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 伤害事件伤害类型, 造成伤害事件伤害, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
const { 是否普通敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index") as { 是否普通敌人: (this: void, unit: any) => boolean };

export function 处理嗜狱恶剑使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.嗜狱恶剑)) return;
  造成精神自伤(ctx.施法单位, 物品使用数值配置.嗜狱恶剑.自伤);
}

export function 处理嗜狱恶剑伤害修正(this: void, context: any): number {
  const target = context.target;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.嗜狱恶剑)) return context.currentDamage;
  const attacker = context.attacker;
  if (attacker == null || attacker === 0) return context.currentDamage;
  if (!是否普通敌人(attacker)) return context.currentDamage;
  return context.currentDamage * 0.9;
}

export function 处理嗜狱恶剑造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.嗜狱恶剑)) return;
  const target = ctx.target;
  if (target == null || target === 0) return;
  if (!是否普通敌人(target)) return;
  const 额外伤害 = ctx.applied * 0.2;
  造成伤害事件伤害(ctx.attacker, target, 额外伤害, 伤害事件伤害类型.普通);
}

export {};
