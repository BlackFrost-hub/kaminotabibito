/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取单位护甲, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

export function 处理锋利巨魔爪物理触发(this: void, ctx: 伤害事件上下文): void {
  if (ctx.snapshot == null || ctx.snapshot.isPhysicalDamage !== true) return;
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.锋利巨魔爪)) return;
  造成伤害事件伤害(ctx.attacker, ctx.target, 取单位护甲(ctx.target) * 3, 伤害事件伤害类型.强化);
}

export {};

