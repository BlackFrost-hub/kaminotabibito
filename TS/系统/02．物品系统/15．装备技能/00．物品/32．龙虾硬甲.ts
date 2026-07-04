/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const jass = require("jass.common") as any;
const GetHeroLevel = jass.GetHeroLevel as (u: any) => number;

export function 处理龙虾硬甲受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.龙虾硬甲)) return;
  const 冷却键 = 取装备冷却键(ctx.target, "龙虾硬甲", "伤害事件装备");
  if (装备冷却中(冷却键)) return;
  进入装备冷却并显示(冷却键, 0.2, ctx.target, "龙虾硬甲");
  执行物品治疗(ctx.target, ctx.target, 取最大生命(ctx.target) * 0.01 + GetHeroLevel(ctx.target), undefined);
}

export {};

