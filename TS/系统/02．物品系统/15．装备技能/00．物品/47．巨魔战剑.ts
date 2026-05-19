/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

export function 处理巨魔战剑强化触发(this: void, ctx: 伤害事件上下文): void {
  if (ctx.snapshot == null || ctx.snapshot.isEnhancedDamage !== true) return;
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.巨魔战剑)) return;
  if (单位冷却中("巨魔战剑全局")) return;
  设置单位冷却("巨魔战剑全局", 3);
  造成伤害事件伤害(ctx.attacker, ctx.target, 取最大生命(ctx.target) * 0.07, 伤害事件伤害类型.强化);
}

export {};

