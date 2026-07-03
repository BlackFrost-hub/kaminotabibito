/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { getGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
  getGameDifficulty: (this: void) => number;
};

const BJ_RADTODEG = 57.29577951308232;

export function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

export function 单位有效(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && IsUnitType(unit, UNIT_TYPE_DEAD) !== true
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 取难度(this: void): number {
  const n = getGameDifficulty();
  return n > 0 ? n : 1;
}

export function 限制数值(this: void, value: number, min: number, max: number): number {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

export function 距离平方XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

export function 距离XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return SquareRoot(距离平方XY(x1, y1, x2, y2));
}

export function 取单位间角度(this: void, source: any, target: any): number {
  return 取坐标角度(GetUnitX(source), GetUnitY(source), GetUnitX(target), GetUnitY(target));
}

export function 取坐标角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG;
}

export function 极坐标X(this: void, x: number, angle: number, distance: number): number {
  return x + Math.cos(angle * Math.PI / 180) * distance;
}

export function 极坐标Y(this: void, y: number, angle: number, distance: number): number {
  return y + Math.sin(angle * Math.PI / 180) * distance;
}

export function 点到线段距离平方(this: void, px: number, py: number, ax: number, ay: number, bx: number, by: number): number {
  const dx = bx - ax;
  const dy = by - ay;
  const len2 = dx * dx + dy * dy;
  if (len2 <= 0.001) return 距离平方XY(px, py, ax, ay);
  let t = ((px - ax) * dx + (py - ay) * dy) / len2;
  if (t < 0) t = 0;
  if (t > 1) t = 1;
  const cx = ax + dx * t;
  const cy = ay + dy * t;
  return 距离平方XY(px, py, cx, cy);
}

export function 单位到线段距离平方(this: void, unit: any, ax: number, ay: number, bx: number, by: number): number {
  return 点到线段距离平方(GetUnitX(unit), GetUnitY(unit), ax, ay, bx, by);
}

