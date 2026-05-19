/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

export function 处理瑞冥戒指造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.瑞冥戒指)) return;
  const 冷却键 = "瑞冥戒指:" + String(GetHandleId(ctx.attacker));
  if (单位冷却中(冷却键)) return;
  设置单位冷却(冷却键, 6);
  造成伤害事件伤害(ctx.attacker, ctx.target, 2000, 伤害事件伤害类型.火焰);
}

export {};

