/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 装备冷却中, 进入装备公共冷却并显示, 注册装备冷却显示持有者追踪 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const 巨魔战剑全局冷却键 = "伤害事件装备:巨魔战剑全局";

注册装备冷却显示持有者追踪("巨魔战剑");

export function 处理巨魔战剑强化触发(this: void, ctx: 伤害事件上下文): void {
  if (ctx.snapshot == null || ctx.snapshot.isEnhancedDamage !== true) return;
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.巨魔战剑)) return;
  if (装备冷却中(巨魔战剑全局冷却键)) return;
  进入装备公共冷却并显示(巨魔战剑全局冷却键, 3, "巨魔战剑");
  造成伤害事件伤害(ctx.attacker, ctx.target, 取最大生命(ctx.target) * 0.07, 伤害事件伤害类型.强化);
}

export {};

