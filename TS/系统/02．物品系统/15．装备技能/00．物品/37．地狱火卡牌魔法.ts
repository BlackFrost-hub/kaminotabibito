/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 取最大魔法, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

export function 处理地狱火卡牌魔法造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.地狱火卡牌魔法)) return;
  if (ctx.applied < 200 || ctx.applied < 取最大生命(ctx.target) * 0.01) return;
  const 冷却键 = 取装备冷却键(ctx.attacker, "地狱火卡牌魔法", "伤害事件装备");
  if (装备冷却中(冷却键)) return;
  进入装备冷却(冷却键, 1);
  造成伤害事件伤害(ctx.attacker, ctx.target, 取最大魔法(ctx.attacker) * 0.1, 伤害事件伤害类型.火焰);
}

export {};

