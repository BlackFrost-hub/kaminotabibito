/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};

const BJ_RADTODEG = 57.29577951308232;
const BJ_DEGTORAD = 0.017453292519943295;

export function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

export function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 单位有效(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && IsUnitType(unit, UNIT_TYPE_DEAD) !== true
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 播放莫尔特斯限时动作(
  this: void,
  unit: any,
  动画编号: number,
  动画速度: number,
  持续秒: number,
): any {
  return 播放限时单位动画({
    单位: unit,
    动画编号,
    动画速度,
    持续秒,
    恢复动画编号: 0,
    恢复动画速度: 1,
  });
}

export function 距离平方XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

export function 距离XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return SquareRoot(距离平方XY(x1, y1, x2, y2));
}

export function 取坐标角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG;
}

export function 取单位间角度(this: void, source: any, target: any): number {
  return 取坐标角度(GetUnitX(source), GetUnitY(source), GetUnitX(target), GetUnitY(target));
}

export function 极坐标X(this: void, x: number, angle: number, distance: number): number {
  return x + Cos(angle * BJ_DEGTORAD) * distance;
}

export function 极坐标Y(this: void, y: number, angle: number, distance: number): number {
  return y + Sin(angle * BJ_DEGTORAD) * distance;
}

export function 限制数值(this: void, value: number, min: number, max: number): number {
  if (value < min) return min;
  if (value > max) return max;
  return value;
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
