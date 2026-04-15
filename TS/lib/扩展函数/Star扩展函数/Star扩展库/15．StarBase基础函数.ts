/**
 * Star扩展库 - StarBase基础函数
 *
 * 来源于 StarBase.j，提供基础工具函数。
 *
 * 公开接口：
 *   getStarBaseHT()              - 获取统一回调哈希表
 *   Star_CoordinateX(x)          - 修正X坐标到地图边界内
 *   Star_CoordinateY(y)          - 修正Y坐标到地图边界内
 *   Star_GetLocZ(x, y)           - 获取坐标Z轴高度
 *   GetRectByHandle(i)           - 整数地址转矩形
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

// 临时位置点（用于获取Z轴高度）
let Star_Location: any = null;

// 临时哈希表（用于句柄转换）
let tempHT: any = null;

/**
 * 获取StarBaseHT（统一回调哈希表）
 */
export function getStarBaseHT(): any {
  return jglobals && jglobals.StarBaseHT ? jglobals.StarBaseHT : null;
}

/**
 * 修正X坐标到地图边界内
 * @param x X坐标
 * @returns 修正后的X坐标
 */
export function Star_CoordinateX(x: number): number {
  let minX = -10000;
  let maxX = 10000;

  if (typeof jass.GetWorldBounds === "function") {
    const mapRect = jass.GetWorldBounds();
    if (mapRect) {
      if (typeof jass.GetRectMinX === "function") minX = jass.GetRectMinX(mapRect);
      if (typeof jass.GetRectMaxX === "function") maxX = jass.GetRectMaxX(mapRect);
    }
  }

  if (x < minX) return minX;
  if (x > maxX) return maxX;
  return x;
}

/**
 * 修正Y坐标到地图边界内
 * @param y Y坐标
 * @returns 修正后的Y坐标
 */
export function Star_CoordinateY(y: number): number {
  let minY = -10000;
  let maxY = 10000;

  if (typeof jass.GetWorldBounds === "function") {
    const mapRect = jass.GetWorldBounds();
    if (mapRect) {
      if (typeof jass.GetRectMinY === "function") minY = jass.GetRectMinY(mapRect);
      if (typeof jass.GetRectMaxY === "function") maxY = jass.GetRectMaxY(mapRect);
    }
  }

  if (y < minY) return minY;
  if (y > maxY) return maxY;
  return y;
}

/**
 * 获取坐标Z轴高度
 * @param x X坐标
 * @param y Y坐标
 * @returns Z轴高度
 */
export function Star_GetLocZ(x: number, y: number): number {
  if (Star_Location == null) {
    Star_Location = typeof jass.Location === "function" ? jass.Location(0, 0) : null;
  }
  if (Star_Location == null) return 0;

  if (typeof jass.MoveLocation === "function") {
    jass.MoveLocation(Star_Location, x, y);
  }

  return typeof jass.GetLocationZ === "function" ? jass.GetLocationZ(Star_Location) : 0;
}

/**
 * 整数地址转矩形
 * @param i 整数地址
 * @returns 矩形句柄
 */
export function GetRectByHandle(i: number): any {
  const StarBaseHT = getStarBaseHT();
  if (StarBaseHT == null) return null;

  if (tempHT == null) {
    tempHT = StarBaseHT;
  }

  if (typeof jass.FlushChildHashtable === "function") {
    jass.FlushChildHashtable(tempHT, 2);
  }

  if (typeof jass.SaveFogStateHandle === "function" && typeof jass.ConvertFogState === "function") {
    jass.SaveFogStateHandle(tempHT, 2, 1, jass.ConvertFogState(i));
  }

  if (typeof jass.LoadRectHandle === "function") {
    return jass.LoadRectHandle(tempHT, 2, 1);
  }

  return null;
}

export {};
