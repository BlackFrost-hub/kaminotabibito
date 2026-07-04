/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取单位攻击 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

export function 处理地狱火卡牌攻击使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.地狱火卡牌攻击)) return;
  const unit = ctx.目标单位 != null && ctx.目标单位 !== 0 ? ctx.目标单位 : ctx.施法单位;
  const cfg = 物品使用数值配置.地狱火卡牌攻击;
  const attack = 取单位攻击(unit) * cfg.攻击比例;
  施加临时属性效果(unit, cfg.持续毫秒, [
    { 类型: "攻击", 数值: attack },
    { 类型: "攻速", 数值: cfg.攻速 },
  ]);
}

export {};
