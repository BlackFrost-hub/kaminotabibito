/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;

export function 标准化角度(this: void, 角度: number): number {
  let result = 角度 % 360;
  if (result < 0) result += 360;
  return result;
}

export function 两点方向角(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return 标准化角度((Atan2(y2 - y1, x2 - x1) as number) * bj_RADTODEG);
}

export function 角度差绝对值(this: void, a: number, b: number): number {
  let diff = 标准化角度(a) - 标准化角度(b);
  if (diff < -180) diff += 360;
  if (diff > 180) diff -= 360;
  return diff < 0 ? -diff : diff;
}

export function 单位是否在来源正面扇区(this: void, 来源: any, 目标: any, 扇区角度: number): boolean {
  if (来源 == null || 来源 === 0 || 目标 == null || 目标 === 0) return false;
  const toward = 两点方向角(GetUnitX(来源), GetUnitY(来源), GetUnitX(目标), GetUnitY(目标));
  return 角度差绝对值(GetUnitFacing(来源), toward) <= 扇区角度 / 2;
}

export function 单位是否在来源背后扇区(this: void, 来源: any, 目标: any, 扇区角度: number): boolean {
  if (来源 == null || 来源 === 0 || 目标 == null || 目标 === 0) return false;
  const back = 标准化角度(GetUnitFacing(来源) + 180);
  const toward = 两点方向角(GetUnitX(来源), GetUnitY(来源), GetUnitX(目标), GetUnitY(目标));
  return 角度差绝对值(back, toward) <= 扇区角度 / 2;
}

export function 目标是否面向来源(this: void, 来源: any, 目标: any, 扇区角度: number): boolean {
  if (来源 == null || 来源 === 0 || 目标 == null || 目标 === 0) return false;
  const towardSource = 两点方向角(GetUnitX(目标), GetUnitY(目标), GetUnitX(来源), GetUnitY(来源));
  return 角度差绝对值(GetUnitFacing(目标), towardSource) <= 扇区角度 / 2;
}

