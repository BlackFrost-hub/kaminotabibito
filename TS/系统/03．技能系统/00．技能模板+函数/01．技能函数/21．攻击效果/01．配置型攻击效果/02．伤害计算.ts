/** @noSelfInFile */

import type { 配置型攻击效果配置, 配置型攻击效果上下文 } from "./00．类型定义";
import { 配置型取攻击力, 配置型取力量, 配置型取最大生命 } from "./01．基础工具";

export function 计算配置型攻击效果伤害(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): number {
  const fixedDamage =
    ctx.snapshot != null && ctx.snapshot.isSkillAttack === true && 配置.攻击效果固定伤害 != null
      ? 配置.攻击效果固定伤害
      : ctx.snapshot != null && ctx.snapshot.isNormalAttack === true && 配置.普攻固定伤害 != null
        ? 配置.普攻固定伤害
        : 配置.固定伤害 ?? 0;
  let amount = fixedDamage;
  if (配置.攻击系数 != null) amount += 配置型取攻击力(ctx.source) * 配置.攻击系数;
  if (配置.力量系数 != null) amount += 配置型取力量(ctx.source) * 配置.力量系数;
  const lifeFactor = 配置.生命系数计算 != null ? 配置.生命系数计算(ctx) : 配置.生命系数;
  if (lifeFactor != null) amount += 配置型取最大生命(ctx.target) * lifeFactor;
  if (配置.伤害倍率 != null) amount += ctx.applied * 配置.伤害倍率;
  return amount;
}

export {};
