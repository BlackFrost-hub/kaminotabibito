/** @noSelfInFile */
/**
 * Star扩展库 - 方位判断函数
 *
 * 提供全方位的单位方位判断功能，支持自定义角度阈值。
 * 所有函数均基于单位面朝方向与目标位置的夹角计算。
 */

const jass = require("jass.common") as any;
const { BJ_DEGTORAD } = require("lib.扩展函数.BJ函数.00．BJ全局兜底") as {
  BJ_DEGTORAD: number;
};
const { CosBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
};

import { SUC_IsValidUnit } from "./08．单位判定与筛选函数";

/** 内部工具：计算两点间角度（度） */
function 计算两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD;
}

// ============================================================================
// 方位枚举常量
// ============================================================================

/** 方位：正前方（0° ± 30°） */
export const 方位_正前方 = 1 as const;
/** 方位：正后方（180° ± 30°） */
export const 方位_正后方 = 2 as const;
/** 方位：侧面（非前后方） */
export const 方位_侧面 = 3 as const;
/** 方位：左前方（45° ± 45°） */
export const 方位_左前方 = 4 as const;
/** 方位：左后方（135° ± 45°） */
export const 方位_左后方 = 5 as const;

// ============================================================================
// 核心判断函数
// ============================================================================

/**
 * 判断目标是否在单位的指定角度范围内
 * @param unit 单位A
 * @param target 目标单位B
 * @param angleRange 角度范围（0-180），如45表示前后各45°范围内
 * @returns 是否在指定角度范围内
 */
export function 是否在指定角度范围内(this: void, unit: any, target: any, angleRange: number): boolean {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return false;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  return CosBJ(angle) >= CosBJ(angleRange);
}

/**
 * 判断目标是否在单位的前方指定角度范围内
 * @param unit 单位A
 * @param target 目标单位B
 * @param angleRange 前方角度范围（0-90），如45表示前方左右各45°
 * @returns 是否在前方指定角度范围内
 */
export function 是否在前方角度内(this: void, unit: any, target: any, angleRange: number = 45): boolean {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return false;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  const cosVal = CosBJ(angle);

  // 前方：余弦值为正，且角度在指定范围内
  return cosVal >= CosBJ(angleRange);
}

/**
 * 判断目标是否在单位的后方指定角度范围内
 * @param unit 单位A
 * @param target 目标单位B
 * @param angleRange 后方角度范围（0-90），如45表示后方左右各45°
 * @returns 是否在后方指定角度范围内
 */
export function 是否在后方角度内(this: void, unit: any, target: any, angleRange: number = 45): boolean {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return false;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  const cosVal = CosBJ(angle);

  // 后方：余弦值为负，且角度在指定范围内
  return cosVal <= -CosBJ(angleRange);
}

// ============================================================================
// 常用便捷函数
// ============================================================================

/**
 * 判断目标是否在单位正前方（0° ± 30°）
 */
export function 是否在正前方(this: void, unit: any, target: any): boolean {
  return 是否在前方角度内(unit, target, 30);
}

/**
 * 判断目标是否在单位正后方（180° ± 30°）
 */
export function 是否在正后方(this: void, unit: any, target: any): boolean {
  return 是否在后方角度内(unit, target, 30);
}

/**
 * 判断目标是否在单位左侧（0° - 90°）
 */
export function 是否在左侧(this: void, unit: any, target: any): boolean {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return false;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  return angle > 0 && angle < 180;
}

/**
 * 判断目标是否在单位右侧（0° - -180°）
 */
export function 是否在右侧(this: void, unit: any, target: any): boolean {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return false;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  return angle < 0 || angle > 180;
}

/**
 * 判断目标是否在单位前方（余弦 > 0，即 ±90° 范围内）
 */
export function 是否在前方(this: void, unit: any, target: any): boolean {
  return 是否在前方角度内(unit, target, 90);
}

/**
 * 判断目标是否在单位后方（余弦 < 0，即 >90° 范围内）
 */
export function 是否在后方(this: void, unit: any, target: any): boolean {
  return 是否在后方角度内(unit, target, 90);
}

// ============================================================================
// 方位区间判断
// ============================================================================

/**
 * 获取目标相对单位的方位区间
 * @returns 1=正前方, 2=正后方, 3=侧面, 4=左前方, 5=左后方
 */
export function 获取方位区间(this: void, unit: any, target: any): number {
  if (!SUC_IsValidUnit(unit) || !SUC_IsValidUnit(target)) return 3;

  const x1 = jass.GetUnitX(unit);
  const y1 = jass.GetUnitY(unit);
  const x2 = jass.GetUnitX(target);
  const y2 = jass.GetUnitY(target);
  const facing = jass.GetUnitFacing(unit);

  const angle = 计算两点角度(x1, y1, x2, y2) - facing;
  const c = CosBJ(angle);

  if (c >= 0.866025) return 方位_正前方;  // cos(30°)
  if (c >= 0.707106) return 方位_左前方;  // cos(45°)
  if (c <= -0.866025) return 方位_正后方;  // cos(150°)
  if (c <= -0.707106) return 方位_左后方;  // cos(135°)
  return 方位_侧面;
}

// ============================================================================
// 旧函数兼容导出（别名）
// ============================================================================

/** @deprecated 使用 是否在正后方() 代替 */
export const SU_DotBehindUnit = (fac: number, x: number, y: number, a: number, b: number): boolean => {
  const angle = 计算两点角度(x, y, a, b) - fac;
  return CosBJ(angle) <= -0.707106;
};

/** @deprecated 使用 获取方位区间() 代替 */
export const SU_GetUnitOfUnit = (u: any, tu: any): number => 获取方位区间(u, tu);

/** @deprecated 使用 是否在前方() 代替 */
export const SU_IsUnitInfrontUnit2 = (u: any, tu: any): boolean => 是否在前方(u, tu);

/** @deprecated 使用 是否在正前方() 代替 */
export const SU_IsUnitInfrontUnit = (u: any, tu: any): boolean => 是否在正前方(u, tu);

/** @deprecated 使用 是否在正后方() 代替 */
export const SU_IsUnitBehindUnit = (u: any, tu: any): boolean => 是否在正后方(u, tu);

export {};
