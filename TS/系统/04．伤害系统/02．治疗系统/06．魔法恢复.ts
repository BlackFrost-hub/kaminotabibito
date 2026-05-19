/** @noSelfInFile */
/**
 * 魔法恢复系统
 *
 * 功能：执行魔法恢复/减少、显示数值
 *
 * 后续接手者注意：
 * 1. 优先通过 doHeal({ HealManaAmount, ManaEffect }) 或本模块 doManaRegen
 * 2. 实际逻辑统一在 01．核心功能.restoreMana
 */

const jass = require("jass.common") as any;

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

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (eff: any) => void;

/** 系统开关 */
const MANA_REGEN_SYSTEM_ENABLED = true;

/** 魔法恢复特效路径 */
const DEFAULT_MANA_HEAL_EFFECT_PATH = "Abilities\\Spells\\Items\\AIta\\AItaTarget.mdl";

/** 魔法减少特效路径 */
const DEFAULT_MANA_DRAIN_EFFECT_PATH = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl";

/**
 * 魔法增加/减少专用函数
 *
 * @param target 目标单位
 * @param amount 增加量（正数为增加，负数为减少）
 * @param showText 是否显示魔法漂浮字（默认 true）
 * @param showManaEffect 是否播放特效（默认 true）
 * @returns 实际变化量
 */
export function 魔法增减(this: void, target: any, amount: number, showText: boolean = true, showManaEffect: boolean = true): number {
  if (!MANA_REGEN_SYSTEM_ENABLED) return 0;
  if (target == null || target === 0) return 0;
  if (IsUnitType(target, jass.UNIT_TYPE_DEAD)) return 0;
  if (amount === 0) return 0;

  const curMana = GetUnitState(target, UNIT_STATE_MANA);

  if (amount > 0) {
    // 增加魔法
    const maxMana = GetUnitState(target, jass.UNIT_STATE_MAX_MANA);
    const missingMana = maxMana - curMana;
    const actualMana = amount < missingMana ? amount : missingMana;
    if (actualMana <= 0) return 0;

    SetUnitState(target, UNIT_STATE_MANA, curMana + actualMana);

    if (showManaEffect) {
      const eff = AddSpecialEffectTarget(DEFAULT_MANA_HEAL_EFFECT_PATH, target, "origin");
      if (eff != null) DestroyEffect(eff);
    }

    if (showText) {
      显示单位数值漂浮文字(target, actualMana, {
        红: 0, 绿: 100, 蓝: 255,
      });
    }

    return actualMana;
  } else {
    // 减少魔法
    const decreaseAmount = -amount;
    const actualDecrease = decreaseAmount < curMana ? decreaseAmount : curMana;
    if (actualDecrease <= 0) return 0;

    SetUnitState(target, UNIT_STATE_MANA, curMana - actualDecrease);

    if (showManaEffect) {
      const eff = AddSpecialEffectTarget(DEFAULT_MANA_DRAIN_EFFECT_PATH, target, "origin");
      if (eff != null) DestroyEffect(eff);
    }

    if (showText) {
      显示单位数值漂浮文字(target, -actualDecrease, {
        红: 150, 绿: 50, 蓝: 255,
      });
    }

    return -actualDecrease;
  }
}

/**
 * 显示单位数值漂浮字
 */
function 显示单位数值漂浮文字(target: any, amount: number, color: { 红: number; 绿: number; 蓝: number }): void {
  if (target == null || amount === 0) return;

  const x = jass.GetUnitX(target);
  const y = jass.GetUnitY(target);
  const z = jass.GetUnitFlyHeight(target) + 100;

  const text = tostring(jass.R2I(amount + 0.5));
  const eff = jass.CreateTextTag();
  if (eff == null) return;

  jass.SetTextTagText(eff, text, 0.024);
  jass.SetTextTagPos(eff, x, y, z);
  jass.SetTextTagColor(eff, color.红, color.绿, color.蓝, 255);
  jass.SetTextTagVelocity(eff, 0, 0.035);
  jass.SetTextTagFadepoint(eff, 1.0);
  jass.SetTextTagDuration(eff, 1.0);
  jass.ShowTextTag(eff, true);

  const g = globalThis as any;
  if (g.__textTagCount == null) g.__textTagCount = 0;
  g.__textTagCount++;
  const count = g.__textTagCount;

  const timer = jass.CreateTimer();
  jass.TimerStart(timer, 1.0, false, function () {
    jass.DestroyTextTag(eff);
    jass.DestroyTimer(timer);
  });
}

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
