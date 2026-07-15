/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
import {
  stringToFourCC,
  单位有效,
  限制数值,
  距离平方XY,
  距离XY,
  两点角度,
  单位间角度,
  极坐标X,
  极坐标Y,
  点到线段距离平方,
} from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { getGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
  getGameDifficulty: (this: void) => number;
};

export { stringToFourCC, 单位有效, 限制数值, 距离平方XY, 距离XY, 极坐标X, 极坐标Y, 点到线段距离平方 };
export const 取单位间角度 = 单位间角度;
export const 取坐标角度 = 两点角度;

export function 取难度(this: void): number {
  const n = getGameDifficulty();
  return n > 0 ? n : 1;
}

export function 单位到线段距离平方(this: void, unit: any, ax: number, ay: number, bx: number, by: number): number {
  return 点到线段距离平方(GetUnitX(unit), GetUnitY(unit), ax, ay, bx, by);
}
