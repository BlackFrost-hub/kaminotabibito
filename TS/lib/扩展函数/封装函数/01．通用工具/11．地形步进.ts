/** @noSelfInFile */
/**
 * 地形步进工具
 *
 * 从指定起点沿固定角度做离散步进。
 * 每次先检查“下一步坐标”是否可通行：
 * 1. 可通行：推进到下一步坐标
 * 2. 不可通行：立即停止在当前坐标
 *
 * 不做最近可走点矫正，不做吸附修正。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;
const { X_IsTerrainWalkable } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (this: void, self: null, x: number, y: number) => boolean;
};
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const GetRectMinX = jass.GetRectMinX as (r: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (r: any) => number;
const GetRectMinY = jass.GetRectMinY as (r: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (r: any) => number;
const DzUnitCanPlaceAround = japi["DzUnitCanPlaceAround"] as ((unit: any, x: number, y: number) => boolean) | undefined;
const 默认检测细分距离 = 6.0;

export interface 地形步进参数 {
  起点X: number;
  起点Y: number;
  角度度: number;
  单步距离: number;
  步数: number;
  检测单位?: any;
  检测细分距离?: number;
}

export interface 地形步进结果 {
  最终X: number;
  最终Y: number;
  实际步数: number;
  是否提前停止: boolean;
}

function 在可玩区域内(this: void, x: number, y: number): boolean {
  const playable = jglobals.bj_mapInitialPlayableArea;
  return x >= GetRectMinX(playable)
    && y >= GetRectMinY(playable)
    && x <= GetRectMaxX(playable)
    && y <= GetRectMaxY(playable);
}

function 下一步可通行(this: void, 参数: 地形步进参数, x: number, y: number): boolean {
  // DzUnitCanPlaceAround 会出现跨地形放置，先保留注释，当前统一回退到纯地形判定。
  // if (参数.检测单位 != null && 参数.检测单位 !== 0 && DzUnitCanPlaceAround != null) {
  //   return DzUnitCanPlaceAround(参数.检测单位, x, y);
  // }
  return X_IsTerrainWalkable(null, x, y);
}

export function 沿角度步进直到地形阻挡(this: void, 参数: 地形步进参数): 地形步进结果 {
  const 弧度 = 参数.角度度 * 0.01745329252;
  const 实际单步距离 = 参数.单步距离;
  const 检测细分距离 = 参数.检测细分距离 != null && 参数.检测细分距离 > 0
    ? 参数.检测细分距离
    : 默认检测细分距离;
  let 当前X = 参数.起点X;
  let 当前Y = 参数.起点Y;
  let 实际步数 = 0;

  for (let i = 0; i < 参数.步数; i++) {
    let 当前步已移动 = 0.0;
    while (当前步已移动 < 实际单步距离) {
      let 本次检测距离 = 实际单步距离 - 当前步已移动;
      if (本次检测距离 > 检测细分距离) {
        本次检测距离 = 检测细分距离;
      }
      const 下一步X = 当前X + 本次检测距离 * Cos(弧度);
      const 下一步Y = 当前Y + 本次检测距离 * Sin(弧度);
      if (!下一步可通行(参数, 下一步X, 下一步Y)) {
        return {
          最终X: 当前X,
          最终Y: 当前Y,
          实际步数,
          是否提前停止: true,
        };
      }
      if (!在可玩区域内(下一步X, 下一步Y)) {
        return {
          最终X: 当前X,
          最终Y: 当前Y,
          实际步数,
          是否提前停止: true,
        };
      }
      当前X = 下一步X;
      当前Y = 下一步Y;
      当前步已移动 = 当前步已移动 + 本次检测距离;
    }
    实际步数 = 实际步数 + 1;
  }

  return {
    最终X: 当前X,
    最终Y: 当前Y,
    实际步数,
    是否提前停止: false,
  };
}

export {};
