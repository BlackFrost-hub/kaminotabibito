/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位持有物品, 增加物品次数, 获取物品次数, 设置物品次数 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

export function 处理斯尔能量之心击杀(this: void, _dyingUnit: any, killingUnit: any): void {
  if (!单位持有物品(killingUnit, 物品使用装备ID.斯尔能量之心)) return;
  const cfg = 物品使用数值配置.斯尔能量之心;
  增加物品次数(killingUnit, 物品使用装备ID.斯尔能量之心, cfg.击杀层数, cfg.触发层数);
}

export function 处理斯尔能量之心使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.斯尔能量之心)) return;
  const unit = ctx.施法单位;
  const cfg = 物品使用数值配置.斯尔能量之心;
  if (获取物品次数(unit, 物品使用装备ID.斯尔能量之心) < cfg.触发层数) return;
  设置物品次数(unit, 物品使用装备ID.斯尔能量之心, 0);
  施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "玩家属性", 属性名: "伤害%", 数值: cfg.伤害提升 }]);
}

export {};
