/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取当前生命 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位时限数值 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/16．单位时限数值";
import { registerManualBuff, 移除单位指定Buff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";
const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, 最低保留生命?: number) => number;
};
const { 开始持续伤害 } = require("系统.04．伤害系统.07．持续伤害系统") as {
  开始持续伤害: (this: void, 参数: any) => number;
};
const jass = require("jass.common") as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;

const 恶斯胸甲窗口 = 创建单位时限数值("恶斯胸甲窗口");

export function 处理恶斯胸甲使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.恶斯胸甲)) return;
  const unit = ctx.施法单位;
  const currentLife = 取当前生命(unit);
  let cost = currentLife * 物品使用数值配置.恶斯胸甲.当前生命消耗比例;
  if (cost < 物品使用数值配置.恶斯胸甲.最低消耗) cost = 物品使用数值配置.恶斯胸甲.最低消耗;
  if (cost > currentLife - 1) cost = currentLife - 1;
  const paidLife = cost > 0 ? -减少生命值(unit, cost, true, false, undefined, 1) : 0;
  if (!(paidLife > 0)) return;
  恶斯胸甲窗口.写入(unit, paidLife, 物品使用数值配置.恶斯胸甲.持续毫秒 / 1000);
  registerManualBuff(unit, 常规BuffID.恶斯胸甲_祭血攻击, 物品使用数值配置.恶斯胸甲.持续毫秒 / 1000, 物品使用数值配置.恶斯胸甲.触发伤害阈值, {
    sourceName: "恶斯胸甲",
    effectValue2: paidLife * 物品使用数值配置.恶斯胸甲.后续伤害倍率,
  });
}

export function 处理恶斯胸甲伤害修正(this: void, context: any): number {
  const attacker = context.attacker;
  const cost = 恶斯胸甲窗口.读取(attacker);
  if (cost == null) return context.currentDamage;
  if (!(context.currentDamage > 物品使用数值配置.恶斯胸甲.触发伤害阈值)) return context.currentDamage;
  恶斯胸甲窗口.清空(attacker);
  移除单位指定Buff(attacker, 常规BuffID.恶斯胸甲_祭血攻击);
  const target = context.target;
  const damage = cost * 物品使用数值配置.恶斯胸甲.后续伤害倍率;
  registerManualBuff(target, 常规BuffID.恶斯胸甲_祭血灼烧, 物品使用数值配置.恶斯胸甲.持续毫秒 / 1000, damage, {
    sourceName: "恶斯胸甲",
  });
  开始持续伤害({
    来源: attacker,
    目标: target,
    总伤害: damage,
    持续秒数: 物品使用数值配置.恶斯胸甲.持续毫秒 / 1000,
    间隔秒数: 1,
    伤害类型: DAMAGE_TYPE_FIRE,
    ranged: true,
    选项: {
      来源类型: "装备持续伤害",
      装备技能类型: "装备持续伤害",
      伤害形态: "单体",
      标签: "恶斯胸甲",
    },
  });
  return context.currentDamage * 物品使用数值配置.恶斯胸甲.伤害提升倍率;
}

export {};
