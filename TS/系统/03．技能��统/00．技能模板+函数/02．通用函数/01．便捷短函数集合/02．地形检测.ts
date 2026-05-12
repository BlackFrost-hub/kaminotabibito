/** @noSelfInFile */
/**
 * 便捷短函数 - 地形检测
 *
 * 封装冲锋和跳跃系统通用的"坐标点是否可通行"检测逻辑：
 * 1. 地图边界检测（在可玩区域内）
 * 2. 地形通行检测（X_IsTerrainWalkable + X_GetAbleX/Y）
 * 3. 容错矫正（WALKABLE_TOLERANCE）
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const {
  X_IsTerrainWalkable,
  X_GetAbleX,
  X_GetAbleY,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (this: void, x: number, y: number) => boolean;
  X_GetAbleX: (this: void) => number;
  X_GetAbleY: (this: void) => number;
};

const GetRectMinX = jass.GetRectMinX as (r: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (r: any) => number;
const GetRectMinY = jass.GetRectMinY as (r: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (r: any) => number;
const SquareRoot = jass.SquareRoot as (v: number) => number;

const WALKABLE_TOLERANCE = 8.0;

export interface 地形检测结果 {
  可通行: boolean;
  矫正X: number;
  矫正Y: number;
}

/**
 * 检测坐标点是否可通行（边界 + 地形 + 容错矫正）
 * @returns { 可通行, 矫正X, 矫正Y } — 可通行=false时矫正坐标是最近可通行点
 */
export function 检测坐标是否可通行(this: void, x: number, y: number): 地形检测结果 {
  // 1. 边界检测
  if (!在可玩区域内(x, y)) {
    return { 可通行: false, 矫正X: x, 矫正Y: y };
  }

  // 2. 地形通行检测
  if (!X_IsTerrainWalkable(x, y)) {
    const 可通行X = X_GetAbleX();
    const 可通行Y = X_GetAbleY();
    const dist = SquareRoot(
      (可通行X - x) * (可通行X - x) + (可通行Y - y) * (可通行Y - y)
    );
    if (dist > WALKABLE_TOLERANCE) {
      return { 可通行: false, 矫正X: 可通行X, 矫正Y: 可通行Y };
    }
  }

  return { 可通行: true, 矫正X: x, 矫正Y: y };
}

/**
 * 判断坐标是否在地图可玩区域内
 */
export function 在可玩区域内(this: void, x: number, y: number): boolean {
  const playable = jglobals.bj_mapInitialPlayableArea;
  return x >= GetRectMinX(playable)
    && y >= GetRectMinY(playable)
    && x <= GetRectMaxX(playable)
    && y <= GetRectMaxY(playable);
}

export {};
