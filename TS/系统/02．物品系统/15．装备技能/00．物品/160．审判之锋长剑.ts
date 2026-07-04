/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取最大生命 } from "../04．伤害事件/00．公共/01．伤害事件工具";

export function 处理审判之锋长剑伤害修正(this: void, context: any): number {
  const damage = context.currentDamage;
  if (!(damage > 0)) return damage;
  if (context.isPhysicalDamage !== true || context.isNormalAttack !== true) return damage;
  if (!单位持有伤害事件装备(context.attacker, 伤害事件装备ID.审判之锋长剑)) return damage;
  const maxHp = 取最大生命(context.target);
  if (!(maxHp > 0)) return damage;
  if (取当前生命(context.target) <= maxHp * 0.7) return damage;
  return damage + damage * 0.2;
}

export {};
