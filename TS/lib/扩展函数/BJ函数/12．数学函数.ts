/** @noSelfInFile */
const jass = require("jass.common") as any;

const DEFAULT_BJ_PI = 3.141592653589793;
const DEFAULT_BJ_RADTODEG = 180 / DEFAULT_BJ_PI;
const DEFAULT_BJ_DEGTORAD = DEFAULT_BJ_PI / 180;

// ===========================================================================
// 数学常量（本地使用，不从 00．BJ全局兜底.ts 导入以避免循环依赖）
// ===========================================================================

/** 与 Blizzard.j `bj_PI` 对齐的工程常量 */
const BJ_PI = DEFAULT_BJ_PI;

/** 弧度 → 角度乘数（Blizzard.j `bj_RADTODEG` = 180/bj_PI） */
const BJ_RADTODEG = DEFAULT_BJ_RADTODEG;

/** 角度 → 弧度乘数（Blizzard.j `bj_DEGTORAD` = bj_PI/180） */
const BJ_DEGTORAD = DEFAULT_BJ_DEGTORAD;

// ===========================================================================
// 三角函数（角度版本）
// 对应 Blizzard.j: CosBJ, SinBJ, TanBJ
// ===========================================================================

/** 余弦（角度） */
export function CosBJ(this: void, degrees: number): number {
  return jass.Cos(degrees * BJ_DEGTORAD);
}

/** 正弦（角度） */
export function SinBJ(this: void, degrees: number): number {
  return jass.Sin(degrees * BJ_DEGTORAD);
}

/** 正切（角度） */
export function TanBJ(this: void, degrees: number): number {
  const rad = degrees * BJ_DEGTORAD;
  return jass.Sin(rad) / jass.Cos(rad);
}

/** 反余弦（返回角度） */
export function AcosBJ(this: void, value: number): number {
  return jass.Acos(value) * BJ_RADTODEG;
}

/** 反正弦（返回角度） */
export function AsinBJ(this: void, value: number): number {
  return jass.Asin(value) * BJ_RADTODEG;
}

/** 反正切（返回角度） */
export function AtanBJ(this: void, value: number): number {
  return jass.Atan(value) * BJ_RADTODEG;
}

/** 反正切2（返回角度） */
export function Atan2BJ(this: void, y: number, x: number): number {
  return jass.Atan2(y, x) * BJ_RADTODEG;
}

// ===========================================================================
// 绝对值/符号函数
// ===========================================================================

/** 实数绝对值 - RAbsBJ */
export function RAbsBJ(this: void, a: number): number {
  return a < 0 ? -a : a;
}

/** 实数符号 - RSignBJ（返回 ±1） */
export function RSignBJ(this: void, a: number): number {
  return a < 0 ? -1 : (a > 0 ? 1 : 0);
}

/** 整数绝对值 - IAbsBJ */
export function IAbsBJ(this: void, a: number): number {
  const ia = jass.R2I(a);
  return ia < 0 ? -ia : ia;
}

/** 整数符号 - ISignBJ（返回 ±1） */
export function ISignBJ(this: void, a: number): number {
  const ia = jass.R2I(a);
  return ia < 0 ? -1 : (ia > 0 ? 1 : 0);
}

// ===========================================================================
// 随机函数
// ===========================================================================

/** 随机百分比 (0-100) - GetRandomPercentageBJ */
export function GetRandomPercentageBJ(this: void): number {
  return jass.GetRandomReal(0, 100);
}

// ===========================================================================
// 取模函数
// ===========================================================================

/** 整数取模 - ModuloInteger */
export function ModuloInteger(this: void, dividend: number, divisor: number): number {
  const d = jass.R2I(divisor);
  if (d === 0) return 0;
  return jass.R2I(dividend) % d;
}

/** 实数取模 - ModuloReal */
export function ModuloReal(this: void, dividend: number, divisor: number): number {
  if (divisor === 0) return 0;
  return dividend % divisor;
}

// ===========================================================================
// 点/坐标函数
// ===========================================================================

/**
 * 两点之间角度 - AngleBetweenPoints（返回角度）
 * 对应 Blizzard.j: AngleBetweenPoints
 */
export function AngleBetweenPoints(this: void, locA: any, locB: any): number {
  if (locA == null || locB == null) return 0;
  const dx = jass.GetLocationX(locB) - jass.GetLocationX(locA);
  const dy = jass.GetLocationY(locB) - jass.GetLocationY(locA);
  return jass.Atan2(dy, dx) * BJ_RADTODEG;
}

/**
 * 两点之间距离 - DistanceBetweenPoints
 * 对应 Blizzard.j: DistanceBetweenPoints
 */
export function DistanceBetweenPoints(this: void, locA: any, locB: any): number {
  if (locA == null || locB == null) return 0;
  const dx = jass.GetLocationX(locB) - jass.GetLocationX(locA);
  const dy = jass.GetLocationY(locB) - jass.GetLocationY(locA);
  return jass.SquareRoot(dx * dx + dy * dy);
}

// ===========================================================================
// 最大值/最小值函数
// ===========================================================================

/** 整数最大值 - IMaxBJ */
export function IMaxBJ(this: void, a: number, b: number): number {
  return a >= b ? a : b;
}

/** 整数最小值 - IMinBJ */
export function IMinBJ(this: void, a: number, b: number): number {
  return a <= b ? a : b;
}

/** 实数最大值 - RMaxBJ */
export function RMaxBJ(this: void, a: number, b: number): number {
  return a < b ? b : a;
}

/** 实数最小值 - RMinBJ */
export function RMinBJ(this: void, a: number, b: number): number {
  return a < b ? a : b;
}

// ===========================================================================
// 百分比转换函数
// ===========================================================================

/** 百分比转整数 - PercentToInt */
export function PercentToInt(this: void, percentage: number, max: number): number {
  return jass.R2I(percentage * 0.01 * max);
}

/** 百分比转255 - PercentTo255 */
export function PercentTo255(this: void, percentage: number): number {
  return PercentToInt(percentage, 255);
}

export {};
