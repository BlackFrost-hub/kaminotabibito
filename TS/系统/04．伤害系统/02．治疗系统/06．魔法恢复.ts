/** @noSelfInFile */
/**
 * 魔法恢复系统
 *
 * 功能：执行魔法恢复、显示数值
 *
 * 后续接手者注意：
 * 1. 优先通过 doHeal({ HealManaAmount, ManaEffect }) 或本模块 doManaRegen
 * 2. 实际逻辑统一在 01．核心功能.restoreMana
 */

const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};

const { restoreMana } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  restoreMana: (
    this: void,
    target: any,
    amount: number,
    manaEffect?: boolean,
    manaEffectPath?: string,
    manaShowText?: boolean
  ) => number;
};

/** 系统开关 */
const MANA_REGEN_SYSTEM_ENABLED = true;

/**
 * 执行魔法恢复
 *
 * @param target 目标单位
 * @param amount 恢复量
 * @param showText 是否显示魔法漂浮字（默认 true）
 * @param showManaEffect 是否播放魔法恢复特效（默认 false）
 * @returns 实际恢复量
 */
export function doManaRegen(
  target: any,
  amount: number,
  showText: boolean = true,
  showManaEffect: boolean = false
): number {
  if (!MANA_REGEN_SYSTEM_ENABLED) return 0;
  return restoreMana(target, amount, showManaEffect, undefined, showText);
}

/**
 * 触发 STES "恢复魔法事件"
 * 供Lua/JASS端调用，JASS端监听器会执行实际恢复
 */
export function fireManaRegenEvent(target: any, amount: number, source: any = null): void {
  STES_FireWithParams("恢复魔法事件", [
    { type: "real", name: "HealAmount", value: amount },
    { type: "unit", name: "HealTarget", value: target },
    { type: "unit", name: "HealSource", value: source },
  ]);
}

export {};
