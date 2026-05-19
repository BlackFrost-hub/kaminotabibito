/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const 灵石累计: Record<number, number | undefined> = {};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

export function 处理灵石受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.灵石)) return;
  const id = GetHandleId(ctx.target);
  const 冷却键 = "灵石:" + String(id);
  if (单位冷却中(冷却键)) return;
  const 当前 = (灵石累计[id] ?? 0) + ctx.applied;
  if (当前 < 300) {
    灵石累计[id] = 当前;
    return;
  }
  灵石累计[id] = 0;
  设置单位冷却(冷却键, 3);
  执行物品治疗(ctx.target, ctx.target, 300, "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl");
}

export {};

