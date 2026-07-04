/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 播放点特效, 取单位X, 取单位Y, 造成强化伤害 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 延迟执行单位动作 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

function 执行狂暴树枝自伤(this: void, unit: any): void {
  造成强化伤害(unit, unit, 物品使用数值配置.狂暴树枝.自伤);
}

export function 处理狂暴树枝使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.狂暴树枝)) return;
  const unit = ctx.施法单位;
  播放点特效("Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl", 取单位X(unit), 取单位Y(unit));
  延迟执行单位动作(unit, 物品使用数值配置.狂暴树枝.延迟毫秒, 执行狂暴树枝自伤);
}

export {};
