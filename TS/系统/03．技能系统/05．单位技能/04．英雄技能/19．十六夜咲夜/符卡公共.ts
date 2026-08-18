/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { getCooldownReduction } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  getCooldownReduction: (this: void, unit: any) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { ForceUICancelBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  ForceUICancelBJ: (this: void, player: any) => void;
};

function 延迟取消十六夜咲夜符卡界面(this: void, variable?: any): void {
  ForceUICancelBJ(variable);
}

/** 对齐源JASS：符卡入口立即取消一次，并在0.20秒后再取消一次。 */
export function 取消十六夜咲夜符卡界面(this: void, caster: any): void {
  if (caster == null || caster === 0) return;
  const player = jass.GetOwningPlayer(caster);
  if (player == null || player === 0) return;
  ForceUICancelBJ(player);
  addDelayedCallback(200, 延迟取消十六夜咲夜符卡界面, player);
}

/** 符卡按钮本体有物编冷却；这里统一设置共享的 A00Y 符卡书冷却。 */
export function 设置十六夜咲夜符卡书冷却(this: void, caster: any, baseCooldown: number, 取消界面: boolean = true): boolean {
  if (caster == null || caster === 0 || baseCooldown <= 0) return false;
  if (取消界面) 取消十六夜咲夜符卡界面(caster);
  let reduction = getCooldownReduction(caster) || 0;
  if (reduction < 0) reduction = 0;
  if (reduction > 0.35) reduction = 0.35;
  const cooldown = baseCooldown * (1 - reduction);
  return 技能_设置技能冷却时间(caster, 配置.技能.R魔法书.类型ID, cooldown, baseCooldown);
}

export {};
