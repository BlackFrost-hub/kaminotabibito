/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位临时属性效果托管器 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 焰混能量体效果托管器 = 创建单位临时属性效果托管器();

function 清除焰混能量体(this: void, unit: any): void {
  焰混能量体效果托管器.清除(unit);
}

export function 处理焰混能量体使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.焰混能量体)) return;
  const unit = ctx.施法单位;
  清除焰混能量体(unit);
  const cfg = 物品使用数值配置.焰混能量体;
  焰混能量体效果托管器.施加(unit, cfg.持续毫秒, [{ 类型: "攻速", 数值: cfg.攻速 }], {
    次数: cfg.普攻次数,
  });
}

export function 处理焰混能量体伤害(this: void, _target: any, attacker: any, _applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  焰混能量体效果托管器.消耗次数(attacker, 1);
}

export {};
