/** @noSelfInFile */

import * as xLib from "./06．X库函数";

const jass = require("jass.common") as any;

const GetUnitDefaultPropWindow = jass.GetUnitDefaultPropWindow as (unit: any) => number;
const SetUnitPropWindow = jass.SetUnitPropWindow as (unit: any, window: number) => void;

const X_IsTerrainWalkableRaw: any = xLib.X_IsTerrainWalkable;
const X_IsUnitTerrainWalkableRaw: any = xLib.X_IsUnitTerrainWalkable;
const X_GetAbleXRaw: any = xLib.X_GetAbleX;
const X_GetAbleYRaw: any = xLib.X_GetAbleY;
const X_IsTerrainDeepWaterRaw: any = xLib.X_IsTerrainDeepWater;
const X_IsTerrainShallowWaterRaw: any = xLib.X_IsTerrainShallowWater;
const X_IsTerrainLandRaw: any = xLib.X_IsTerrainLand;
const X_IsTerrainPlatformRaw: any = xLib.X_IsTerrainPlatform;
const X_GDBCRaw: any = xLib.X_GDBC;
const X_GAFCRaw: any = xLib.X_GAFC;
const X_R2I2Raw: any = xLib.X_R2I2;

function 取数字(value: any, fallback: number = 0): number {
  if (value == null || value === false || value === "") return fallback;
  return value as number;
}

function 归位双坐标参数(thisArg: any, xOrY: any, yMaybe: any): { x: number; y: number } {
  let x = xOrY;
  let y = yMaybe;
  if (y == null && typeof thisArg === "number" && typeof xOrY === "number") {
    x = thisArg;
    y = xOrY;
  }
  return { x: 取数字(x), y: 取数字(y) };
}

function 归位单位三参数(thisArg: any, unitOrX: any, xOrY: any, yMaybe: any): { unit: any; x: number; y: number } {
  let unit = unitOrX;
  let x = xOrY;
  let y = yMaybe;
  if (y == null && unitOrX != null && typeof xOrY === "number") {
    unit = thisArg;
    x = unitOrX;
    y = xOrY;
  }
  return { unit, x: 取数字(x), y: 取数字(y) };
}

function 归位四坐标参数(thisArg: any, x1OrY1: any, y1OrX2: any, x2OrY2: any, y2Maybe: any): { x1: number; y1: number; x2: number; y2: number } {
  let x1 = x1OrY1;
  let y1 = y1OrX2;
  let x2 = x2OrY2;
  let y2 = y2Maybe;
  if (y2 == null && typeof thisArg === "number" && typeof x1OrY1 === "number" && typeof y1OrX2 === "number" && typeof x2OrY2 === "number") {
    x1 = thisArg;
    y1 = x1OrY1;
    x2 = y1OrX2;
    y2 = x2OrY2;
  }
  return { x1: 取数字(x1), y1: 取数字(y1), x2: 取数字(x2), y2: 取数字(y2) };
}

export function X_IsTerrainWalkableSafe(this: void, thisOrX: any, xOrY?: any, yMaybe?: any): boolean {
  const { x, y } = 归位双坐标参数(thisOrX, xOrY, yMaybe);
  return X_IsTerrainWalkableRaw(x, y);
}

export function X_IsUnitTerrainWalkableSafe(this: void, thisOrUnit: any, unitOrX?: any, xOrY?: any, yMaybe?: any): boolean {
  const { unit, x, y } = 归位单位三参数(thisOrUnit, unitOrX, xOrY, yMaybe);
  return X_IsUnitTerrainWalkableRaw(unit, x, y);
}

export function X_GetAbleXSafe(this: void): number {
  return X_GetAbleXRaw();
}

export function X_GetAbleYSafe(this: void): number {
  return X_GetAbleYRaw();
}

export function X_IsTerrainDeepWaterSafe(this: void, thisOrX: any, xOrY?: any, yMaybe?: any): boolean {
  const { x, y } = 归位双坐标参数(thisOrX, xOrY, yMaybe);
  return X_IsTerrainDeepWaterRaw(x, y);
}

export function X_IsTerrainShallowWaterSafe(this: void, thisOrX: any, xOrY?: any, yMaybe?: any): boolean {
  const { x, y } = 归位双坐标参数(thisOrX, xOrY, yMaybe);
  return X_IsTerrainShallowWaterRaw(x, y);
}

export function X_IsTerrainLandSafe(this: void, thisOrX: any, xOrY?: any, yMaybe?: any): boolean {
  const { x, y } = 归位双坐标参数(thisOrX, xOrY, yMaybe);
  return X_IsTerrainLandRaw(x, y);
}

export function X_IsTerrainPlatformSafe(this: void, thisOrX: any, xOrY?: any, yMaybe?: any): boolean {
  const { x, y } = 归位双坐标参数(thisOrX, xOrY, yMaybe);
  return X_IsTerrainPlatformRaw(x, y);
}

/**
 * 设置单位是否可以移动。
 * 站桩语义使用 PropWindow 锁定，不要用 SetUnitMoveSpeed(0)，避免污染移速系统和属性判断。
 */
export function X_SetUnitMovableSafe(this: void, unit: any, movable: boolean): void {
  if (unit == null || unit === 0) return;
  if (movable) {
    SetUnitPropWindow(unit, GetUnitDefaultPropWindow(unit));
  } else {
    SetUnitPropWindow(unit, 0);
  }
}

export function X_FixUnitStandingSafe(this: void, unit: any): void {
  X_SetUnitMovableSafe(unit, false);
}

export function X_RestoreUnitStandingSafe(this: void, unit: any): void {
  X_SetUnitMovableSafe(unit, true);
}

export function X_GDBCSafe(this: void, thisOrX1: any, x1OrY1?: any, y1OrX2?: any, x2OrY2?: any, y2Maybe?: any): number {
  const { x1, y1, x2, y2 } = 归位四坐标参数(thisOrX1, x1OrY1, y1OrX2, x2OrY2, y2Maybe);
  return X_GDBCRaw(x1, y1, x2, y2);
}

export function X_GAFCSafe(this: void, thisOrX1: any, x1OrY1?: any, y1OrX2?: any, x2OrY2?: any, y2Maybe?: any): number {
  const { x1, y1, x2, y2 } = 归位四坐标参数(thisOrX1, x1OrY1, y1OrX2, x2OrY2, y2Maybe);
  return X_GAFCRaw(x1, y1, x2, y2);
}

export function X_R2I2Safe(this: void, thisOrR: any, rMaybe?: any): number {
  const value = rMaybe != null ? rMaybe : thisOrR;
  return X_R2I2Raw(取数字(value));
}
