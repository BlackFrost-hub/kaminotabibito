/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取物品次数, 设置物品次数, 读取单位属性 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果, 延迟执行, 播放单位特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const 斯尔能量之心临时伤害属性名 = "wp55斯尔能量之心伤害加成";

export function 处理斯尔能量之心使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.斯尔能量之心)) return;
  const unit = ctx.施法单位;
  const cfg = 物品使用数值配置.斯尔能量之心;
  const 使用后层数 = 获取物品次数(unit, 物品使用装备ID.斯尔能量之心);
  if (使用后层数 < cfg.触发层数) {
    延迟执行(0, function on斯尔能量之心层数不足返还(this: void): void {
      设置物品次数(unit, 物品使用装备ID.斯尔能量之心, 使用后层数 + 1);
    });
    return;
  }
  延迟执行(0, function on斯尔能量之心消耗满层(this: void): void {
    设置物品次数(unit, 物品使用装备ID.斯尔能量之心, 1);
  });
  播放单位特效("war3mapImported\\ArcaneBurstOnlyPurple.mdx", unit, "origin", 1);
  施加临时属性效果(unit, cfg.持续毫秒, [
    { 类型: "单位属性", 属性名: 斯尔能量之心临时伤害属性名, 数值: cfg.伤害提升 },
  ]);
  registerManualBuff(unit, 常规BuffID.斯尔能量之心_能量爆发, cfg.持续毫秒 / 1000, cfg.伤害提升 * 100, {
    sourceName: "斯尔能量之心",
  });
}

export function 处理斯尔能量之心伤害修正(this: void, context: any): number {
  const bonus = 读取单位属性(context.attacker, 斯尔能量之心临时伤害属性名);
  if (!(bonus > 0)) return context.currentDamage;
  return context.currentDamage * (1 + bonus);
}

export {};
