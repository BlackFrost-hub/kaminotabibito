/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

export function 处理瑞冥戒指造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.瑞冥戒指)) return;
  const 冷却键 = 取装备冷却键(ctx.attacker, "瑞冥戒指", "伤害事件装备");
  if (装备冷却中(冷却键)) return;
  进入装备冷却并显示(冷却键, 6, ctx.attacker, "瑞冥戒指");
  造成伤害事件伤害(ctx.attacker, ctx.target, 2000, 伤害事件伤害类型.火焰);
}

export {};

