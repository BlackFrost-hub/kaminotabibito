/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围友军, 取单位X, 取单位Y } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

export function 处理精灵号角使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.精灵号角)) return;
  const cfg = 物品使用数值配置.号角;
  const unit = ctx.施法单位;
  const count = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), cfg.半径).length;
  if (count <= 0) return;
  const attack = cfg.精灵号角每单位攻击 * count;
  施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "攻击", 数值: attack }]);
}

export {};
