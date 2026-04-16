/**
 * Star扩展库 - 单位方位函数
 *
 * 来源于 StarUnit.j，提供单位间方位判断功能。
 *
 * 公开接口：
 *   SU_DotBehindUnit(fac, x, y, a, b)  - 判断点是否在单位背面
 *   SU_GetUnitOfUnit(u, tu)            - 获取单位间方位关系
 *   SU_IsUnitInfrontUnit2(u, tu)       - 判断单位是否在正前方（宽松）
 *   SU_IsUnitInfrontUnit(u, tu)        - 判断单位是否在正前方（严格）
 *   SU_IsUnitBehindUnit(u, tu)         - 判断单位是否在正后方
 */

const jass = require("jass.common") as any;
const { CosBJ, BJ_DEGTORAD } = require("lib.扩展函数.BJ函数.00．BJ全局兜底");

/**
 * 计算两点间角度（度数）
 * 对应 JASS: Math.GAFC / X_GAFC
 */
function GAFC(x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD;
}

/**
 * 判断点是否在单位背面
 * @param fac 单位朝向（度数）
 * @param x 单位X坐标
 * @param y 单位Y坐标
 * @param a 目标点X坐标
 * @param b 目标点Y坐标
 * @returns 是否在背面
 */
export function SU_DotBehindUnit(fac: number, x: number, y: number, a: number, b: number): boolean {
  const angle = GAFC(x, y, a, b) - fac;
  return CosBJ(angle) <= -0.707106; // 135°-225° 范围
}

/**
 * 获取单位间方位关系
 * @param u 参考单位
 * @param tu 目标单位
 * @returns 方位关系：1=正面(±30°), 2=背面(±30°), 3=侧面, 4=正面(±45°), 5=背面(±45°)
 */
export function SU_GetUnitOfUnit(u: any, tu: any): number {
  if (u == null || u === 0 || tu == null || tu === 0) return 3;

  const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(u) : 0;
  const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(u) : 0;
  const a = typeof jass.GetUnitX === "function" ? jass.GetUnitX(tu) : 0;
  const b = typeof jass.GetUnitY === "function" ? jass.GetUnitY(tu) : 0;
  const facing = typeof jass.GetUnitFacing === "function" ? jass.GetUnitFacing(u) : 0;

  const angle = GAFC(x, y, a, b) - facing;
  const c = CosBJ(angle);

  if (c >= 0.866025) return 1; // 正面 ±30°
  if (c >= 0.707106) return 4; // 正面 ±45°
  if (c <= -0.866025) return 2; // 背面 ±30°
  if (c <= -0.707106) return 5; // 背面 ±45°
  return 3; // 侧面
}

/**
 * 判断单位是否在另一单位正前方（宽松判断，cos>0即前方）
 * @param u 参考单位
 * @param tu 目标单位
 * @returns 是否在前方
 */
export function SU_IsUnitInfrontUnit2(u: any, tu: any): boolean {
  if (u == null || u === 0 || tu == null || tu === 0) return false;

  const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(u) : 0;
  const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(u) : 0;
  const a = typeof jass.GetUnitX === "function" ? jass.GetUnitX(tu) : 0;
  const b = typeof jass.GetUnitY === "function" ? jass.GetUnitY(tu) : 0;
  const facing = typeof jass.GetUnitFacing === "function" ? jass.GetUnitFacing(u) : 0;

  const angle = GAFC(x, y, a, b) - facing;
  const c = CosBJ(angle);

  return c > 0;
}

/**
 * 判断单位是否在另一单位正前方（严格判断，±30°）
 * @param u 参考单位
 * @param tu 目标单位
 * @returns 是否在正前方
 */
export function SU_IsUnitInfrontUnit(u: any, tu: any): boolean {
  return SU_GetUnitOfUnit(u, tu) === 1;
}

/**
 * 判断单位是否在另一单位正后方（严格判断，±30°）
 * @param u 参考单位
 * @param tu 目标单位
 * @returns 是否在正后方
 */
export function SU_IsUnitBehindUnit(u: any, tu: any): boolean {
  return SU_GetUnitOfUnit(u, tu) === 2;
}

export {};
