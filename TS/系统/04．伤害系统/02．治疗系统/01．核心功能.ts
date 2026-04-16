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

import {
  HEAL_SYSTEM_ENABLED,
  HEAL_EVENTS,
  DEFAULT_HEAL_EFFECT_PATH,
  HEAL_TEXT_COLOR,
  ATTR_HEAL_RATE,
  ATTR_RECEIVED_HEAL_RATE,
} from "./00．常量定义";

const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, value: any) => void;
};

const { STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Fire: (self: any, name: string) => void;
};

const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 治疗回调（可修改治疗量） */
type HealCallback = (source: any, target: any, amount: number, isItemHeal: boolean) => number;

/** 治疗事件监听（只读） */
type HealEventListener = (source: any, target: any, amount: number, isItemHeal: boolean) => void;

/** 治疗参数（与JASS端参数名一致） */
export interface HealParams {
  HealSource: any;       // 治疗来源（可为null）
  HealTarget: any;       // 治疗目标
  HealAmount: number;    // 基础治疗量
  ItemHeal: boolean;     // 是否物品治疗
  HealEffect: boolean;   // 是否播放特效
  HealEffectPath?: string; // 特效路径（可选）
}

// ==========================================================================================
// 全局存储
// ==========================================================================================

const healCallbacks: HealCallback[] = [];
const healEventListeners: HealEventListener[] = [];
const totalHealStats: Map<number, number> = new Map();

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
  const v = YDUserDataGet("unit", unit, ATTR_HEAL_RATE, "real");
  return typeof v === "number" ? v : 0;
}

/** 设置单位受到治疗率（被治疗时生效） */
export function setReceivedHealRate(unit: any, rate: number): void {
  if (unit == null) return;
  YDUserDataSet("unit", unit, ATTR_RECEIVED_HEAL_RATE, rate);
}

/** 获取单位受到治疗率 */
export function getReceivedHealRate(unit: any): number {
  if (unit == null) return 0;
  const v = YDUserDataGet("unit", unit, ATTR_RECEIVED_HEAL_RATE, "real");
  return typeof v === "number" ? v : 0;
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
  const maxLife = jass.GetUnitState(target, jass.UNIT_STATE_MAX_LIFE);
  const curLife = jass.GetUnitState(target, jass.UNIT_STATE_LIFE);
  return Math.max(0, maxLife - curLife);
}

/** 播放治疗特效 */
function playHealEffect(target: any, effectPath?: string): void {
  if (target == null) return;
  const path = (effectPath != null && effectPath !== "") ? effectPath : DEFAULT_HEAL_EFFECT_PATH;
  const x = jass.GetUnitX(target);
  const y = jass.GetUnitY(target);
  const eff = jass.AddSpecialEffect(path, x, y);
  if (eff != null) jass.DestroyEffect(eff);
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
  YDLocal5Set("real", "伤害值", amount);
  YDLocal5Set("unit", "目标单位", target);
  YDLocal5Set("integer", "红色", red ?? HEAL_TEXT_COLOR.red);
  YDLocal5Set("integer", "绿色", green ?? HEAL_TEXT_COLOR.green);
  YDLocal5Set("integer", "蓝色", blue ?? HEAL_TEXT_COLOR.blue);
  STES_Fire(null, HEAL_EVENTS.SHOW_DAMAGE);
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
  YDLocal5Set("real", "HealAmount", amount);
  YDLocal5Set("unit", "HealUnit", target);
  YDLocal5Set("unit", "HealSource", source);
  STES_Fire(null, HEAL_EVENTS.HEAL);
}

/** 累计治疗统计 */
function addHealStats(target: any, amount: number): void {
  if (target == null || amount <= 0) return;
  const hid = jass.GetHandleId(target);
  if (hid == null || hid === 0) return;
  totalHealStats.set(hid, (totalHealStats.get(hid) || 0) + amount);
}

// ==========================================================================================
// 核心治疗函数
// ==========================================================================================

/**
 * 执行治疗
 * 流程：校验 -> 计算加成 -> 回调修改 -> 限制溢出 -> 设置生命 -> 特效 -> 事件 -> 统计
 * @returns 实际治疗量（系统关闭或无效返回0）
 */
export function doHeal(params: HealParams): number {
  if (!HEAL_SYSTEM_ENABLED) return 0;

  const { HealSource, HealTarget, HealAmount, ItemHeal, HealEffect, HealEffectPath } = params;

  // 参数校验
  if (HealTarget == null || HealAmount <= 0) return 0;
  if (jass.IsUnitType(HealTarget, jass.UNIT_TYPE_DEAD)) return 0;

  // 计算治疗量
  let amount = calcHealAmount(HealSource, HealTarget, HealAmount);

  // 执行回调
  for (const cb of healCallbacks) {
    try { amount = cb(HealSource, HealTarget, amount, ItemHeal); } catch (_e) {}
  }
  if (amount <= 0) return 0;

  // 限制不超过已损失生命
  const actualHeal = Math.min(amount, getMissingLife(HealTarget));
  if (actualHeal <= 0) return 0;

  // 设置生命值
  const curLife = jass.GetUnitState(HealTarget, jass.UNIT_STATE_LIFE);
  jass.SetUnitState(HealTarget, jass.UNIT_STATE_LIFE, curLife + actualHeal);

  // 播放特效
  if (HealEffect) playHealEffect(HealTarget, HealEffectPath);

  // 触发事件
  fireShowDamageEvent(HealTarget, actualHeal);
  fireHealEvent(HealSource, HealTarget, actualHeal);

  // 统计
  addHealStats(HealTarget, actualHeal);

  // 通知监听器
  for (const listener of healEventListeners) {
    try { listener(HealSource, HealTarget, actualHeal, ItemHeal); } catch (_e) {}
  }

  return actualHeal;
}

// ==========================================================================================
// 便捷函数
// ==========================================================================================

/** 技能治疗 */
export function spellHeal(
  source: any, target: any, amount: number, showEffect: boolean = true, effectPath?: string
): number {
  return doHeal({ HealSource: source, HealTarget: target, HealAmount: amount, ItemHeal: false, HealEffect: showEffect, HealEffectPath: effectPath });
}

/** 物品治疗 */
export function itemHeal(
  source: any, target: any, amount: number, showEffect: boolean = true, effectPath?: string
): number {
  return doHeal({ HealSource: source, HealTarget: target, HealAmount: amount, ItemHeal: true, HealEffect: showEffect, HealEffectPath: effectPath });
}

/** 生命恢复（无特效无来源） */
export function regenHeal(target: any, amount: number): number {
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
