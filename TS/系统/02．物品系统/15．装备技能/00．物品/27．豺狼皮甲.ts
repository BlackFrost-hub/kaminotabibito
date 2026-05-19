/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取最大生命, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

export function 处理豺狼皮甲受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.豺狼皮甲)) return;
  if (取当前生命(ctx.target) >= 取最大生命(ctx.target) * 0.7) return;
  执行物品治疗(ctx.target, ctx.target, ctx.applied * 0.1, undefined);
}

export {};

