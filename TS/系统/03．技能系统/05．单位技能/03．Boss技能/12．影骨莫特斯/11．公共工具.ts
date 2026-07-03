/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { stringToFourCC: 转四字码 } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};

const 弧度转角度 = 57.29577951308232;
const 角度转弧度 = 0.017453292519943295;

export function stringToFourCC(this: void, id: string): number {
  return 转四字码(id);
}

export function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 单位有效(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, UNIT_TYPE_DEAD) === true) return false;
  return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

export function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  let angle = Atan2(y2 - y1, x2 - x1) * 弧度转角度;
  if (angle < 0) angle += 360;
  return angle;
}

export function 极坐标X(this: void, x: number, distance: number, angleDeg: number): number {
  return x + distance * Cos(angleDeg * 角度转弧度);
}

export function 极坐标Y(this: void, y: number, distance: number, angleDeg: number): number {
  return y + distance * Sin(angleDeg * 角度转弧度);
}

export function 角度差绝对值(this: void, a: number, b: number): number {
  let diff = a - b;
  while (diff > 180) diff -= 360;
  while (diff < -180) diff += 360;
  return diff >= 0 ? diff : -diff;
}

export function 目标正面朝向来源(this: void, source: any, target: any, frontAngle: number): boolean {
  if (!单位有效(source) || !单位有效(target)) return false;
  const targetFacing = GetUnitFacing(target);
  const targetToSource = 两点角度(GetUnitX(target), GetUnitY(target), GetUnitX(source), GetUnitY(source));
  return 角度差绝对值(targetFacing, targetToSource) <= frontAngle * 0.5;
}

export {};
