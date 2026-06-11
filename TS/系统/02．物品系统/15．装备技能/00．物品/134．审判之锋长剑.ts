/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

export function 处理审判之锋长剑伤害触发(this: void, ctx: 伤害事件上下文): void {
  if (ctx.snapshot == null || ctx.snapshot.isPhysicalDamage !== true || ctx.snapshot.isNormalAttack !== true) return;
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.审判之锋长剑)) return;
  const maxHp = 取最大生命(ctx.target);
  if (!(maxHp > 0)) return;
  if (取当前生命(ctx.target) <= maxHp * 0.7) return;
  造成伤害事件伤害(ctx.attacker, ctx.target, ctx.applied * 0.2, 伤害事件伤害类型.普通);
}

export {};
