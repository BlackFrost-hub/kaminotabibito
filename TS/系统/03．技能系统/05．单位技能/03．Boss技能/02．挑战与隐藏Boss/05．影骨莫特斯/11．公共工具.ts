/** @noSelfInFile */

import {
  stringToFourCC,
  取单位ID,
  单位有效,
  距离XY,
  两点角度,
  极坐标X as 公共极坐标X,
  极坐标Y as 公共极坐标Y,
  角度差绝对值,
  目标正面朝向来源,
} from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

export { stringToFourCC, 取单位ID, 单位有效, 两点角度, 角度差绝对值, 目标正面朝向来源 };
export const 两点距离 = 距离XY;

export function 极坐标X(this: void, x: number, distance: number, angleDeg: number): number {
  return 公共极坐标X(x, angleDeg, distance);
}

export function 极坐标Y(this: void, y: number, distance: number, angleDeg: number): number {
  return 公共极坐标Y(y, angleDeg, distance);
}

export {};
