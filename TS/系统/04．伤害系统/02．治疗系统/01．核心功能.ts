/** @noSelfInFile */
/**
 * 治疗系统 - 核心功能
 *
 * 功能：执行治疗、触发事件、回调系统、治疗率存储
 * 公式：治疗量 = 基础量 × (1 + 来源治疗率 + 目标受到治疗率)
 * 限制：不超过已损失生命值
 *
 * 后续接手者注意：
 * 1. 开关 HEAL_SYSTEM_ENABLED 在常量文件
 * 2. STES事件参数通过 YDLocal5Set 传递，变量名须与JASS一致
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

/** 当前生命/魔法：jass；最大生命/魔法及扩展属性：japi（与 SGSS / 物编面板一致） */
const GetUnitStateJass = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitStateJass = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

import {
  HEAL_SYSTEM_ENABLED,
  HEAL_EVENTS,
  HEAL_RESULT_KEYS,
  HEAL_STATS_KEYS,
  DEFAULT_HEAL_EFFECT_PATH,
  DEFAULT_MANA_HEAL_EFFECT_PATH,
  HEAL_TEXT_COLOR,
  MANA_TEXT_COLOR,
  ATTR_HEAL_RATE,
  ATTR_RECEIVED_HEAL_RATE,
} from "./00．常量定义";

const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, value: any) => void;
};

const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};

const { 显示单位数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字") as {
  显示单位数值漂浮文字: (this: void, unit: any, value: number, options?: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 治疗回调（可修改治疗量） */
type HealCallback = (source: any, target: any, amount: number, isItemHeal: boolean) => number;

/** 治疗事件监听（只读） */
type HealEventListener = (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void;

/** 治疗参数（与JASS端参数名一致） */
export interface HealParams {
  HealSource: any;         // 治疗来源（可为null）
  HealTarget: any;         // 治疗目标
  HealAmount: number;      // 基础治疗量（可为0，仅回魔时）
  HealManaAmount?: number; // 基础魔法恢复量（可选，默认0）
  ItemHeal: boolean;       // 是否物品治疗
  HealEffect: boolean;     // 是否播放生命治疗特效
  HealEffectPath?: string; // 生命治疗特效路径（可选）
  UseDefaultHealEffect?: boolean; // 无自定义路径时是否强制播放默认治疗特效
  HealShowText?: boolean;  // 是否显示生命治疗漂浮字（默认true）
  ManaEffect?: boolean;    // 是否播放魔法恢复特效
  ManaEffectPath?: string; // 魔法恢复特效路径（可选）
  UseDefaultManaEffect?: boolean; // 无自定义路径时是否强制播放默认回蓝特效
  ManaShowText?: boolean;  // 是否显示魔法恢复漂浮字（默认true）
  DelayOneTick?: boolean;  // 是否延后一帧执行（默认false）
}

// ==========================================================================================
// 全局存储
// ==========================================================================================

const healCallbacks: HealCallback[] = [];
const beforeAppliedFinalHealListeners: HealEventListener[] = [];
const healEventListeners: HealEventListener[] = [];
const totalHealStats: Map<number, number> = new Map();
const delayedHealQueue: HealParams[] = [];
let delayedHealScheduled = false;
type 待销毁特效记录 = {
  句柄: any;
  到期时间: number;
};
const 待销毁治疗特效列表: 待销毁特效记录[] = [];
let 已注册治疗特效驱动 = false;

function 处理待销毁治疗特效(): void {
  const 当前时间 = getServerTime();
  for (let i = 待销毁治疗特效列表.length - 1; i >= 0; i--) {
    const 记录 = 待销毁治疗特效列表[i];
    if (当前时间 < 记录.到期时间) continue;
    jass.DestroyEffect(记录.句柄);
    待销毁治疗特效列表.splice(i, 1);
  }
}

function 安排治疗特效销毁(effect: any, 持续秒: number = 1): void {
  if (effect == null || effect === 0) return;
  if (!已注册治疗特效驱动) {
    已注册治疗特效驱动 = true;
    addPeriodicCallback(100, 处理待销毁治疗特效);
  }
  待销毁治疗特效列表.push({
    句柄: effect,
    到期时间: getServerTime() + 持续秒 * 1000,
  });
}

function cloneHealParams(params: HealParams): HealParams {
  return {
    HealSource: params.HealSource,
    HealTarget: params.HealTarget,
    HealAmount: params.HealAmount,
    HealManaAmount: params.HealManaAmount,
    ItemHeal: params.ItemHeal,
    HealEffect: params.HealEffect,
    HealEffectPath: params.HealEffectPath,
    UseDefaultHealEffect: params.UseDefaultHealEffect,
    HealShowText: params.HealShowText,
    ManaEffect: params.ManaEffect,
    ManaEffectPath: params.ManaEffectPath,
    UseDefaultManaEffect: params.UseDefaultManaEffect,
    ManaShowText: params.ManaShowText,
    DelayOneTick: false,
  };
}

function 执行延迟治疗队列(): void {
  delayedHealScheduled = false;
  while (delayedHealQueue.length > 0) {
    const params = delayedHealQueue.shift();
    if (params == null) continue;
    doHeal(params);
  }
}

// ==========================================================================================
// 治疗率存储API
// ==========================================================================================

/** 设置单位治疗率（治疗别人时生效） */
export function setHealRate(unit: any, rate: number): void {
  if (unit == null) return;
  YDUserDataSet("unit", unit, ATTR_HEAL_RATE, rate);
}

/** 获取单位治疗率 */
export function getHealRate(unit: any): number {
  if (unit == null) return 0;
  const unitValue = YDUserDataGet("unit", unit, ATTR_HEAL_RATE, "real");
  const player = GetOwningPlayer(unit);
  const playerValue = player != null ? YDUserDataGet("player", player, ATTR_HEAL_RATE, "real") : 0;
  const unitRate = typeof unitValue === "number" ? unitValue : 0;
  const playerRate = typeof playerValue === "number" ? playerValue : 0;
  return unitRate + playerRate;
}

/** 设置单位受到治疗率（被治疗时生效） */
export function setReceivedHealRate(unit: any, rate: number): void {
  if (unit == null) return;
  YDUserDataSet("unit", unit, ATTR_RECEIVED_HEAL_RATE, rate);
}

/** 获取单位受到治疗率 */
export function getReceivedHealRate(unit: any): number {
  if (unit == null) return 0;
  const unitValue = YDUserDataGet("unit", unit, ATTR_RECEIVED_HEAL_RATE, "real");
  const player = GetOwningPlayer(unit);
  const playerValue = player != null ? YDUserDataGet("player", player, ATTR_RECEIVED_HEAL_RATE, "real") : 0;
  const unitRate = typeof unitValue === "number" ? unitValue : 0;
  const playerRate = typeof playerValue === "number" ? playerValue : 0;
  return unitRate + playerRate;
}

// ==========================================================================================
// 回调系统API
// ==========================================================================================

/**
 * 注册治疗回调（可修改治疗量）
 * 用途：治疗加成Buff、护盾转换、治疗暴击
 */
export function registerHealCallback(cb: HealCallback): void {
  if (typeof cb === "function") healCallbacks.push(cb);
}

/**
 * 注册治疗事件监听（只读）
 * 用途：任务统计、成就、统计面板
 */
export function registerHealEvent(cb: HealEventListener): void {
  if (typeof cb === "function") healEventListeners.push(cb);
}

/** 注册治疗开始监听：最终实际治疗量确定后、生命值写入前触发，业务侧只读使用。 */
export function registerBeforeAppliedFinalHealListener(this: void, cb: HealEventListener): void {
  if (typeof cb === "function") beforeAppliedFinalHealListeners.push(cb);
}

/** 注册最终治疗监听：实际加血完成后触发，业务侧只读使用。 */
export function registerAppliedFinalHealListener(this: void, cb: HealEventListener): void {
  registerHealEvent(cb);
}

// ==========================================================================================
// 内部函数
// ==========================================================================================

/** 计算治疗量：基础量 × (1 + 来源治疗率 + 目标受到治疗率) */
function calcHealAmount(source: any, target: any, baseAmount: number): number {
  if (baseAmount <= 0) return 0;
  const sourceRate = source != null ? getHealRate(source) : 0;
  const targetRate = getReceivedHealRate(target);
  return baseAmount * (1 + sourceRate + targetRate);
}

/** 获取已损失生命值 */
function getMissingLife(target: any): number {
  if (target == null) return 0;
  const maxLife = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_LIFE);
  const curLife = GetUnitStateJass(target, jass.UNIT_STATE_LIFE);
  const missing = maxLife - curLife;
  return missing > 0 ? missing : 0;
}

/** 播放治疗特效 */
function playHealEffect(target: any, effectPath?: string): void {
  if (target == null) return;
  const path = (effectPath != null && effectPath !== "") ? effectPath : DEFAULT_HEAL_EFFECT_PATH;
  const x = jass.GetUnitX(target);
  const y = jass.GetUnitY(target);
  const eff = jass.AddSpecialEffect(path, x, y);
  安排治疗特效销毁(eff, 1);
}

/** 获取已损失魔法值 */
function getMissingMana(target: any): number {
  if (target == null) return 0;
  const maxMana = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_MANA);
  const curMana = GetUnitStateJass(target, jass.UNIT_STATE_MANA);
  const missing = maxMana - curMana;
  return missing > 0 ? missing : 0;
}

/** 播放魔法恢复特效 */
function playManaEffect(target: any, effectPath?: string): void {
  if (target == null) return;
  const path = (effectPath != null && effectPath !== "") ? effectPath : DEFAULT_MANA_HEAL_EFFECT_PATH;
  const eff = jass.AddSpecialEffectTarget(path, target, "origin");
  安排治疗特效销毁(eff, 1);
}

/** 显示魔法恢复漂浮字 */
function fireManaShowEvent(target: any, amount: number): void {
  显示单位数值漂浮文字(target, amount, {
    红: MANA_TEXT_COLOR.red,
    绿: MANA_TEXT_COLOR.green,
    蓝: MANA_TEXT_COLOR.blue,
    大小: 15,
  });
}

/** 执行魔法恢复（不超过已损失魔法） */
function applyManaRestore(target: any, baseAmount: number): number {
  if (target == null || baseAmount <= 0) return 0;

  const missingMana = getMissingMana(target);
  const actualMana = baseAmount < missingMana ? baseAmount : missingMana;
  if (actualMana <= 0) return 0;

  const curMana = GetUnitStateJass(target, jass.UNIT_STATE_MANA);
  SetUnitStateJass(target, jass.UNIT_STATE_MANA, curMana + actualMana);
  return actualMana;
}

/** 仅执行魔法恢复（供 doManaRegen 等便捷入口） */
export function restoreMana(
  target: any,
  amount: number,
  manaEffect: boolean = false,
  manaEffectPath?: string,
  manaShowText: boolean = true
): number {
  if (!HEAL_SYSTEM_ENABLED) return 0;
  if (target == null || amount <= 0) return 0;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_DEAD)) return 0;

  const actualMana = applyManaRestore(target, amount);
  if (actualMana <= 0) return 0;

  if (manaEffect) playManaEffect(target, manaEffectPath);
  if (manaShowText) fireManaShowEvent(target, actualMana);
  return actualMana;
}

/**
 * 触发数值显示事件
 * 供Lua端/JASS端调用，显示治疗/伤害数值
 *
 * @param target 目标单位
 * @param amount 数值
 * @param red 红色分量（可选，默认治疗颜色）
 * @param green 绿色分量（可选）
 * @param blue 蓝色分量（可选）
 */
export function fireShowDamageEvent(
  target: any,
  amount: number,
  red?: number,
  green?: number,
  blue?: number
): void {
  显示单位数值漂浮文字(target, amount, {
    红: red ?? HEAL_TEXT_COLOR.red,
    绿: green ?? HEAL_TEXT_COLOR.green,
    蓝: blue ?? HEAL_TEXT_COLOR.blue,
    大小: 15,
  });
}

/**
 * 触发"任意单位被治疗"事件
 * 供Lua端/JASS端调用
 *
 * @param source 治疗来源
 * @param target 治疗目标
 * @param amount 治疗量
 */
export function fireHealEvent(source: any, target: any, amount: number): void {
  STES_FireWithParams(HEAL_EVENTS.HEAL, [
    { type: "real", name: HEAL_RESULT_KEYS.AMOUNT, value: amount },
    { type: "unit", name: HEAL_RESULT_KEYS.TARGET, value: target },
    { type: "unit", name: HEAL_RESULT_KEYS.SOURCE, value: source },
  ]);
}

/** 累计治疗统计 */
function addHealStats(target: any, amount: number): void {
  if (target == null || amount <= 0) return;
  const hid = jass.GetHandleId(target);
  if (hid == null || hid === 0) return;
  totalHealStats.set(hid, (totalHealStats.get(hid) || 0) + amount);
}

/** 与旧 JASS 对齐：只在 Boss战 激活、目标属于玩家组且来源对目标友方时累计玩家治疗量 */
function shouldRecordPlayerHeal(target: any, sourcePlayer: any): boolean {
  if (target == null || sourcePlayer == null) return false;

  const bossBattleUnit = YDUserDataGet(
    "string",
    HEAL_STATS_KEYS.BOSS_BATTLE_TABLE,
    HEAL_STATS_KEYS.BOSS_BATTLE_UNIT,
    "unit"
  );
  if (bossBattleUnit == null) return false;

  const playerForce = YDUserDataGet(
    "string",
    HEAL_STATS_KEYS.PLAYER_GROUP_TABLE,
    HEAL_STATS_KEYS.PLAYER_GROUP_FORCE,
    "force"
  );
  if (playerForce == null) return false;

  const targetPlayer = jass.GetOwningPlayer(target);
  if (!jass.IsPlayerInForce(targetPlayer, playerForce)) return false;

  return jass.IsUnitAlly(target, sourcePlayer) || sourcePlayer === targetPlayer;
}

/** 与旧 JASS「治疗事件.j」对齐：直接按 HealSource 的所属玩家累计「治疗量」 */
function addPlayerHealStats(target: any, source: any, amount: number): void {
  if (source == null || amount <= 0) return;

  const sourcePlayer = jass.GetOwningPlayer(source);
  if (!shouldRecordPlayerHeal(target, sourcePlayer)) return;

  const current = YDUserDataGet("player", sourcePlayer, HEAL_STATS_KEYS.PLAYER_TOTAL_HEAL, "real");
  const base = typeof current === "number" ? current : 0;
  YDUserDataSet("player", sourcePlayer, HEAL_STATS_KEYS.PLAYER_TOTAL_HEAL, base + amount);
}

// ==========================================================================================
// 核心治疗函数
// ==========================================================================================

/**
 * 执行治疗
 * 流程：校验 -> 计算加成 -> 回调修改 -> 限制溢出 -> 设置生命 -> 特效 -> 事件 -> 统计
 * @returns 实际治疗量（系统关闭或无效返回0）
 */
export function doHeal(this: void, params: HealParams): number {
  if (!HEAL_SYSTEM_ENABLED) return 0;

  if (params.DelayOneTick === true) {
    delayedHealQueue.push(cloneHealParams(params));
    if (!delayedHealScheduled) {
      delayedHealScheduled = true;
      addDelayedCallback(10, 执行延迟治疗队列);
    }
    return 0;
  }

  const manaEffectEnabled = params.ManaEffect ?? ((params.HealManaAmount ?? 0) > 0);

  const {
    HealSource,
    HealTarget,
    HealAmount,
    HealManaAmount = 0,
    ItemHeal,
    HealEffect,
    HealEffectPath,
    UseDefaultHealEffect = false,
    HealShowText = true,
    ManaEffectPath,
    UseDefaultManaEffect = false,
    ManaShowText = true,
  } = params;

  // 参数校验
  if (HealTarget == null) return 0;
  if (jass.IsUnitType(HealTarget, jass.UNIT_TYPE_DEAD)) return 0;
  if (HealAmount <= 0 && HealManaAmount <= 0) return 0;

  let actualHeal = 0;

  if (HealAmount > 0) {
    // 计算治疗量
    let amount = calcHealAmount(HealSource, HealTarget, HealAmount);

    // 执行回调
    for (const cb of healCallbacks) {
      try { amount = cb(HealSource, HealTarget, amount, ItemHeal); } catch (_e) {}
    }

    if (amount > 0) {
      // 限制不超过已损失生命
      const missingLife = getMissingLife(HealTarget);
      actualHeal = amount < missingLife ? amount : missingLife;

      if (actualHeal > 0) {
        for (const listener of beforeAppliedFinalHealListeners) {
          try { listener(HealSource, HealTarget, actualHeal, ItemHeal); } catch (_e) {}
        }

        const curLife = GetUnitStateJass(HealTarget, jass.UNIT_STATE_LIFE);
        SetUnitStateJass(HealTarget, jass.UNIT_STATE_LIFE, curLife + actualHeal);

        if (HealEffect || UseDefaultHealEffect) playHealEffect(HealTarget, HealEffectPath);

        if (HealShowText) fireShowDamageEvent(HealTarget, actualHeal);
        fireHealEvent(HealSource, HealTarget, actualHeal);

        addHealStats(HealTarget, actualHeal);
        addPlayerHealStats(HealTarget, HealSource, actualHeal);

        for (const listener of healEventListeners) {
          try { listener(HealSource, HealTarget, actualHeal, ItemHeal); } catch (_e) {}
        }
      }
    }
  }

  if (HealManaAmount > 0) {
    // 底层调用魔法增减函数
    const { 魔法增减 } = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复") as {
      魔法增减: (this: void, target: any, amount: number, showText?: boolean, showManaEffect?: boolean) => number;
    };
    魔法增减(HealTarget, HealManaAmount, ManaShowText, manaEffectEnabled || UseDefaultManaEffect);
  }

  return actualHeal;
}

// ==========================================================================================
// 便捷函数
// ==========================================================================================

/** 技能治疗 */
export function spellHeal(
  this: void,
  source: any,
  target: any,
  amount: number,
  showEffect: boolean = true,
  effectPath?: string,
  manaAmount: number = 0,
  showManaEffect: boolean = false,
  manaEffectPath?: string
): number {
  return doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: amount,
    HealManaAmount: manaAmount,
    ItemHeal: false,
    HealEffect: showEffect,
    HealEffectPath: effectPath,
    ManaEffect: showManaEffect,
    ManaEffectPath: manaEffectPath,
  });
}

/** 物品治疗 */
export function itemHeal(
  this: void,
  source: any,
  target: any,
  amount: number,
  showEffect: boolean = false,
  effectPath?: string,
  manaAmount: number = 0,
  showManaEffect: boolean = false,
  manaEffectPath?: string
): number {
  return doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: amount,
    HealManaAmount: manaAmount,
    ItemHeal: true,
    HealEffect: showEffect,
    HealEffectPath: effectPath,
    ManaEffect: showManaEffect,
    ManaEffectPath: manaEffectPath,
  });
}

/** 生命恢复（无特效无来源） */
export function regenHeal(this: void, target: any, amount: number): number {
  return doHeal({ HealSource: null, HealTarget: target, HealAmount: amount, ItemHeal: false, HealEffect: false });
}

/** 获取累计被治疗量 */
export function getTotalHealed(unit: any): number {
  if (unit == null) return 0;
  const hid = jass.GetHandleId(unit);
  if (hid == null || hid === 0) return 0;
  return totalHealStats.get(hid) || 0;
}

/** 检查系统是否启用 */
export function isHealSystemEnabled(): boolean {
  return HEAL_SYSTEM_ENABLED;
}

export {};
