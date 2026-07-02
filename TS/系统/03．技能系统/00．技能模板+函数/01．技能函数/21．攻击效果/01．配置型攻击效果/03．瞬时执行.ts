/** @noSelfInFile */

import type { 配置型攻击效果配置, 配置型攻击效果上下文 } from "./00．类型定义";
import { 计算配置型攻击效果伤害 } from "./02．伤害计算";
import {
  配置型攻击效果造成伤害,
  配置型攻击效果减少生命魔法,
  配置型攻击效果治疗生命魔法,
  配置型单位是精英目标,
  配置型取当前生命,
  配置型取最大生命,
  配置型取最大魔法,
  配置型获取敌方范围单位,
  配置型施加击飞,
  配置型施加眩晕,
} from "./01．基础工具";

function 取伤害概率(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): number {
  if (配置.伤害概率计算 != null) return 配置.伤害概率计算(ctx);
  if (配置.伤害概率 != null) return 配置.伤害概率;
  return 1;
}

function 取治疗概率(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): number {
  if (配置.治疗概率计算 != null) return 配置.治疗概率计算(ctx);
  if (配置.治疗概率 != null) return 配置.治疗概率;
  return 取伤害概率(配置, ctx);
}

export interface 配置型概率函数 {
  (this: void, chance: number, source?: any): boolean;
}

export function 执行配置型单体伤害(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const amount = 计算配置型攻击效果伤害(配置, ctx);
  配置型攻击效果造成伤害(ctx.source, ctx.target, amount, 配置.伤害类型);
}

export function 执行配置型额外伤害(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文, 概率通过: 配置型概率函数): void {
  const damageChance = 取伤害概率(配置, ctx);
  const healChance = 取治疗概率(配置, ctx);
  const 资源偷取同时造成伤害 = 配置.固定伤害 != null || 配置.攻击系数 != null || 配置.力量系数 != null || 配置.生命系数 != null || 配置.生命系数计算 != null;
  if ((配置.效果类型 !== "资源偷取" || 资源偷取同时造成伤害) && damageChance > 0) {
    const amount = 计算配置型攻击效果伤害(配置, ctx);
    if (amount > 0 && 概率通过(damageChance, ctx.source)) {
      配置型攻击效果造成伤害(ctx.source, ctx.target, amount, 配置.伤害类型);
    }
  }
  if (((配置.治疗生命 ?? 0) > 0 || (配置.恢复魔法 ?? 0) > 0) && healChance > 0) {
    if (概率通过(healChance, ctx.source)) {
      配置型攻击效果治疗生命魔法(ctx.source, ctx.source, 配置.治疗生命 ?? 0, 配置.恢复魔法 ?? 0);
    }
  }
  if ((配置.抽取生命比例 ?? 0) > 0 || (配置.抽取魔法比例 ?? 0) > 0) {
    const life = 配置型取最大生命(ctx.target) * (配置.抽取生命比例 ?? 0);
    const mana = 配置型取最大魔法(ctx.target) * (配置.抽取魔法比例 ?? 0);
    配置型攻击效果减少生命魔法(ctx.target, life, mana);
    配置型攻击效果治疗生命魔法(ctx.source, ctx.source, life, mana);
  }
  if (配置.效果类型 === "资源偷取" && (配置.伤害倍率 ?? 0) > 0) {
    const steal = ctx.applied * (配置.伤害倍率 ?? 0);
    配置型攻击效果减少生命魔法(ctx.target, 0, steal);
    配置型攻击效果治疗生命魔法(ctx.source, ctx.source, steal, 0);
  }
}

export function 执行配置型范围伤害(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const radius = 配置.范围 ?? 0;
  if (!(radius > 0)) return;
  const list = 配置型获取敌方范围单位(ctx.source, ctx.target, radius, 配置.范围包含主目标 === true);
  const amount = 计算配置型攻击效果伤害(配置, ctx);
  let spreadCount = 0;
  for (let i = 0; i < list.length; i++) {
    配置型攻击效果造成伤害(ctx.source, list[i], amount, 配置.伤害类型);
    spreadCount++;
  }
  if (spreadCount > 0 && (配置.扩散成功主目标伤害倍率 ?? 0) > 0) {
    配置型攻击效果造成伤害(ctx.source, ctx.target, ctx.applied * (配置.扩散成功主目标伤害倍率 ?? 0), 配置.伤害类型);
  }
}

export function 执行配置型低血斩杀(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const maxLife = 配置型取最大生命(ctx.target);
  if (!(maxLife > 0)) return;
  const line = 配置型单位是精英目标(ctx.target) ? (配置.精英斩杀线 ?? 配置.普通斩杀线 ?? 0) : (配置.普通斩杀线 ?? 0);
  if (!(line > 0)) return;
  if (配置型取当前生命(ctx.target) / maxLife > line) return;
  配置型攻击效果造成伤害(ctx.source, ctx.target, maxLife, 配置.伤害类型);
}

export function 执行配置型范围击飞(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const radius = 配置.范围 ?? 0;
  const list = 配置型获取敌方范围单位(ctx.source, ctx.target, radius, true);
  const amount = 计算配置型攻击效果伤害(配置, ctx);
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    配置型攻击效果造成伤害(ctx.source, unit, amount, 配置.伤害类型);
    配置型施加击飞(ctx.source, unit, 配置.持续时间 ?? 1.5);
    配置型施加眩晕(ctx.source, unit, 配置.持续时间 ?? 1.5);
  }
}

export {};
