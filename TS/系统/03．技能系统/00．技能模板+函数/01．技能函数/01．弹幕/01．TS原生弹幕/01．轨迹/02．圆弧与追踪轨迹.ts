/** @noSelfInFile */
/**
 * TS 原生弹幕 - 圆弧 / 追踪插值轨迹
 */

import type { 原生弹幕轨迹采样器, 原生弹幕轨迹采样结果 } from "../00．类型";
import { CosBJ, GetUnitX, GetUnitY, SinBJ, 取坐标朝向角, 计算距离 } from "../01．共享";
import { 取采样方向, 取弹幕轨迹进度, 线性插值 } from "./00．轨迹工具";

export function 创建圆弧轨迹(
  this: void,
  圆心X: number,
  圆心Y: number,
  半径: number,
  起始角度: number,
  结束角度: number,
): 原生弹幕轨迹采样器 {
  return function 圆弧轨迹采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const 角度 = 线性插值(起始角度, 结束角度, t);
    const x = 圆心X + CosBJ(角度) * 半径;
    const y = 圆心Y + SinBJ(角度) * 半径;
    return {
      X: x,
      Y: y,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建追踪插值轨迹(this: void, 目标单位: any, 到达距离: number = 32): 原生弹幕轨迹采样器 {
  return function 追踪插值采样(this: void, 实例, delta): 原生弹幕轨迹采样结果 {
    if (目标单位 == null || 目标单位 === 0) {
      return { X: 实例.当前X, Y: 实例.当前Y, 方向角: 实例.当前方向角, 完成: true };
    }

    const tx = GetUnitX(目标单位);
    const ty = GetUnitY(目标单位);
    const 距离 = 计算距离(实例.当前X, 实例.当前Y, tx, ty);
    if (距离 <= 到达距离) {
      return { X: tx, Y: ty, 方向角: 取坐标朝向角(实例.当前X, 实例.当前Y, tx, ty), 完成: true };
    }

    const 步长 = 实例.当前速度 * delta;
    const 进度 = 距离 > 0 ? (步长 / 距离) : 1;
    const 安全进度 = 进度 > 1 ? 1 : 进度;
    const x = 线性插值(实例.当前X, tx, 安全进度);
    const y = 线性插值(实例.当前Y, ty, 安全进度);
    return {
      X: x,
      Y: y,
      方向角: 取坐标朝向角(实例.当前X, 实例.当前Y, x, y),
      完成: 安全进度 >= 1,
    };
  };
}
