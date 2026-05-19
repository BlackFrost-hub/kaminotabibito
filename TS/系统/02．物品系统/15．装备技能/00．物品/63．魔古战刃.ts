/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位持有物品, 获取范围敌人, 取单位X, 取单位Y, 取单位攻击, 读取玩家属性, 造成普通伤害, 拉向来源, 命令攻击来源, 施加减速 } from "../05．物品使用/00．公共/02．物品使用工具";

export function 处理魔古战刃使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.魔古战刃)) return;
  const cfg = 物品使用数值配置.魔古战刃;
  const unit = ctx.施法单位;
  const enemies = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.主动半径);
  const critDmg = 读取玩家属性(unit, "暴击伤害");
  const damage = 取单位攻击(unit) * (1 + critDmg);
  for (const enemy of enemies) {
    造成普通伤害(unit, enemy, damage);
    命令攻击来源(enemy, unit);
    施加减速(unit, enemy, 0.30, 2);
    拉向来源(unit, enemy, cfg.拉拢距离, cfg.拉拢时间);
  }
}

export function 处理魔古战刃伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  if (!单位持有物品(attacker, 物品使用装备ID.魔古战刃)) return;
  const cfg = 物品使用数值配置.魔古战刃;
  const enemies = 获取范围敌人(attacker, 取单位X(target), 取单位Y(target), cfg.扩散半径);
  for (const enemy of enemies) {
    if (enemy === target) continue;
    造成普通伤害(attacker, enemy, applied * cfg.扩散比例);
  }
}

export {};
