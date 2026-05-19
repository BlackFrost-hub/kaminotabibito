/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetHeroLevel = jass.GetHeroLevel as (u: any) => number;

export function 处理龙虾硬甲受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.龙虾硬甲)) return;
  const 冷却键 = "龙虾硬甲:" + String(GetHandleId(ctx.target));
  if (单位冷却中(冷却键)) return;
  设置单位冷却(冷却键, 0.2);
  执行物品治疗(ctx.target, ctx.target, 取最大生命(ctx.target) * 0.01 + GetHeroLevel(ctx.target), undefined);
}

export {};

