/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 执行治疗, 读取玩家属性 } from "../05．物品使用/00．公共/02．物品使用工具";

export function 处理熔灵宝石之戒使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.熔灵宝石之戒)) return;
  const unit = ctx.施法单位;
  const heal = 物品使用数值配置.熔灵宝石之戒.基础治疗 * (1 + 读取玩家属性(unit, "魔法伤害"));
  执行治疗(unit, unit, heal, 0);
}

export {};
