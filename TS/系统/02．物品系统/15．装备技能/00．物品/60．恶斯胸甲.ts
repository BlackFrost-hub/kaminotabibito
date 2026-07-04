/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取当前生命, 设置生命, 造成火焰伤害 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位时限数值 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/16．单位时限数值";
import { 延迟执行 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 恶斯胸甲窗口 = 创建单位时限数值("恶斯胸甲窗口");

function 执行恶斯胸甲后续伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  造成火焰伤害(来源, 目标, 伤害);
}

export function 处理恶斯胸甲使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.恶斯胸甲)) return;
  const unit = ctx.施法单位;
  const currentLife = 取当前生命(unit);
  let cost = currentLife * 物品使用数值配置.恶斯胸甲.当前生命消耗比例;
  if (cost < 物品使用数值配置.恶斯胸甲.最低消耗) cost = 物品使用数值配置.恶斯胸甲.最低消耗;
  if (cost > currentLife - 1) cost = currentLife - 1;
  if (cost > 0) 设置生命(unit, currentLife - cost);
  恶斯胸甲窗口.写入(unit, cost, 物品使用数值配置.恶斯胸甲.持续毫秒 / 1000);
}

export function 处理恶斯胸甲伤害修正(this: void, context: any): number {
  const attacker = context.attacker;
  const cost = 恶斯胸甲窗口.读取(attacker);
  if (cost == null) return context.currentDamage;
  if (!(context.currentDamage > 物品使用数值配置.恶斯胸甲.触发伤害阈值)) return context.currentDamage;
  恶斯胸甲窗口.清空(attacker);
  const target = context.target;
  const damage = cost * 物品使用数值配置.恶斯胸甲.后续伤害倍率;
  延迟执行(0, function on恶斯胸甲后续伤害(this: void): void {
    执行恶斯胸甲后续伤害(attacker, target, damage);
  });
  return context.currentDamage * 物品使用数值配置.恶斯胸甲.伤害提升倍率;
}

export {};
