/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { stringToFourCC: 转四字码 } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};

const 弧度转角度 = 57.29577951308232;
const 角度转弧度 = 0.017453292519943295;

export function stringToFourCC(this: void, id: string | undefined | null): number {
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

export function 距离平方XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

export function 距离XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return SquareRoot(距离平方XY(x1, y1, x2, y2));
}

export function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  let angle = Atan2(y2 - y1, x2 - x1) * 弧度转角度;
  if (angle < 0) angle += 360;
  return angle;
}

export function 单位间角度(this: void, source: any, target: any): number {
  return 两点角度(GetUnitX(source), GetUnitY(source), GetUnitX(target), GetUnitY(target));
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

export function 极坐标X(this: void, x: number, angleDeg: number, distance: number): number {
  return x + Cos(angleDeg * 角度转弧度) * distance;
}

export function 极坐标Y(this: void, y: number, angleDeg: number, distance: number): number {
  return y + Sin(angleDeg * 角度转弧度) * distance;
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

export function 播放点特效(this: void, model: string | undefined | null, x: number, y: number): void {
  if (model == null || model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export function 播放单位特效(this: void, model: string | undefined | null, unit: any, attachPointName: string = "origin"): void {
  if (model == null || model === "" || !单位有效(unit)) return;
  const effect = AddSpecialEffectTarget(model, unit, attachPointName);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export {};
