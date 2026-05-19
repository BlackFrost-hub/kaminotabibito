/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围友军, 取单位X, 取单位Y, 清除负面Buff, 执行治疗 } from "../05．物品使用/00．公共/02．物品使用工具";

export function 处理守卫大剑使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.守卫大剑)) return;
  const cfg = 物品使用数值配置.守卫大剑;
  const unit = ctx.施法单位;
  const allies = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  let removed = 0;
  for (const ally of allies) {
    removed += 清除负面Buff(ally);
  }
  if (removed <= 0) {
    执行治疗(unit, unit, cfg.兜底治疗);
  }
}

export {};
