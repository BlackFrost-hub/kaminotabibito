/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取单位X, 取单位Y, 限制目标点距离, 创建火把单位 } from "../05．物品使用/00．公共/02．物品使用工具";

export function 处理火把使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.火把)) return;
  const unit = ctx.施法单位;
  const cfg = 物品使用数值配置.火把;
  const sx = 取单位X(unit);
  const sy = 取单位Y(unit);
  const point = 限制目标点距离(sx, sy, ctx.目标X, ctx.目标Y, cfg.最大距离);
  创建火把单位(unit, point.x, point.y, point.angle, cfg.模型, cfg.持续时间);
}

export {};
