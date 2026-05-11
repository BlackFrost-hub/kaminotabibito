/** @noSelfInFile */
/**
 * TS 原生弹幕 - 二阶 / 三阶贝塞尔轨迹
 */

import type { 原生弹幕轨迹采样器, 原生弹幕轨迹采样结果 } from "../00．类型";
import { GetUnitFlyHeight, GetUnitX, GetUnitY, 计算距离 } from "../01．共享";
import { 取采样方向, 取弹幕轨迹进度, 线性插值 } from "./00．轨迹工具";

interface 贝塞尔加速度状态 {
  进度: number;
  速度: number;
  已飞行距离: number;
}

const 加速度状态表: Record<number, 贝塞尔加速度状态 | undefined> = {};

function 二阶贝塞尔值(this: void, t: number, 起点: number, 控制: number, 终点: number): number {
  const a = 线性插值(起点, 控制, t);
  const b = 线性插值(控制, 终点, t);
  return 线性插值(a, b, t);
}

function 三阶贝塞尔值(this: void, t: number, 起点: number, 控制1: number, 控制2: number, 终点: number): number {
  const a = 线性插值(起点, 控制1, t);
  const b = 线性插值(控制1, 控制2, t);
  const c = 线性插值(控制2, 终点, t);
  return 线性插值(线性插值(a, b, t), 线性插值(b, c, t), t);
}

function 取二阶贝塞尔近似长度(
  this: void,
  起点X: number,
  起点Y: number,
  控制X: number,
  控制Y: number,
  终点X: number,
  终点Y: number,
): number {
  let length = 0;
  let lastX = 起点X;
  let lastY = 起点Y;
  for (let i = 1; i <= 16; i++) {
    const t = i / 16;
    const x = 二阶贝塞尔值(t, 起点X, 控制X, 终点X);
    const y = 二阶贝塞尔值(t, 起点Y, 控制Y, 终点Y);
    length += 计算距离(lastX, lastY, x, y);
    lastX = x;
    lastY = y;
  }
  return length > 1 ? length : 1;
}

function 取加速度进度(
  this: void,
  弹幕ID: number,
  delta: number,
  路径长度: number,
  初始速度: number,
  加速度: number,
  加速度开始距离: number,
): number {
  let 状态 = 加速度状态表[弹幕ID];
  if (状态 == null) {
    状态 = { 进度: 0, 速度: 初始速度, 已飞行距离: 0 };
    加速度状态表[弹幕ID] = 状态;
  }
  if (状态.已飞行距离 >= 加速度开始距离) {
    状态.速度 += 加速度 * delta;
  }
  if (状态.速度 < 0) 状态.速度 = 0;
  const 本帧距离 = 状态.速度 * delta;
  状态.已飞行距离 += 本帧距离;
  状态.进度 += 本帧距离 / 路径长度;
  if (状态.进度 >= 1) {
    delete 加速度状态表[弹幕ID];
    return 1;
  }
  return 状态.进度;
}

export function 创建二阶贝塞尔轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  控制X: number,
  控制Y: number,
  终点X: number,
  终点Y: number,
): 原生弹幕轨迹采样器 {
  return function 二阶贝塞尔采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const x01 = 线性插值(起点X, 控制X, t);
    const y01 = 线性插值(起点Y, 控制Y, t);
    const x12 = 线性插值(控制X, 终点X, t);
    const y12 = 线性插值(控制Y, 终点Y, t);
    const x = 线性插值(x01, x12, t);
    const y = 线性插值(y01, y12, t);
    return {
      X: x,
      Y: y,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建二阶贝塞尔XYZ轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  控制Z: number,
  终点X: number,
  终点Y: number,
  终点Z: number,
): 原生弹幕轨迹采样器 {
  return function 二阶贝塞尔XYZ采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const x = 二阶贝塞尔值(t, 起点X, 控制X, 终点X);
    const y = 二阶贝塞尔值(t, 起点Y, 控制Y, 终点Y);
    const z = 二阶贝塞尔值(t, 起点Z, 控制Z, 终点Z);
    return {
      X: x,
      Y: y,
      Z: z,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建二阶贝塞尔抛物线轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  终点X: number,
  终点Y: number,
  终点Z: number,
  最大抬高: number,
): 原生弹幕轨迹采样器 {
  const 控制Z = 起点Z > 终点Z ? 起点Z + 最大抬高 : 终点Z + 最大抬高;
  return 创建二阶贝塞尔XYZ轨迹(
    起点X, 起点Y, 起点Z,
    控制X, 控制Y, 控制Z,
    终点X, 终点Y, 终点Z,
  );
}

export function 创建二阶贝塞尔加速度XYZ轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  控制Z: number,
  终点X: number,
  终点Y: number,
  终点Z: number,
  初始速度: number,
  加速度: number = 0,
  加速度开始距离: number = 0,
): 原生弹幕轨迹采样器 {
  const 路径长度 = 取二阶贝塞尔近似长度(起点X, 起点Y, 控制X, 控制Y, 终点X, 终点Y);
  return function 二阶贝塞尔加速度XYZ采样(this: void, 实例, delta): 原生弹幕轨迹采样结果 {
    const t = 取加速度进度(实例.id, delta, 路径长度, 初始速度, 加速度, 加速度开始距离);
    const x = 二阶贝塞尔值(t, 起点X, 控制X, 终点X);
    const y = 二阶贝塞尔值(t, 起点Y, 控制Y, 终点Y);
    const z = 二阶贝塞尔值(t, 起点Z, 控制Z, 终点Z);
    return {
      X: x,
      Y: y,
      Z: z,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建二阶贝塞尔加速度抛物线轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  终点X: number,
  终点Y: number,
  终点Z: number,
  最大抬高: number,
  初始速度: number,
  加速度: number = 0,
  加速度开始距离: number = 0,
): 原生弹幕轨迹采样器 {
  const 控制Z = 起点Z > 终点Z ? 起点Z + 最大抬高 : 终点Z + 最大抬高;
  return 创建二阶贝塞尔加速度XYZ轨迹(
    起点X, 起点Y, 起点Z,
    控制X, 控制Y, 控制Z,
    终点X, 终点Y, 终点Z,
    初始速度, 加速度, 加速度开始距离,
  );
}

export function 创建锁定单位二阶贝塞尔XYZ轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  控制Z: number,
  目标单位: any,
  目标Z偏移: number = 0,
): 原生弹幕轨迹采样器 {
  return function 锁定单位二阶贝塞尔XYZ采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const endX = 目标单位 != null && 目标单位 !== 0 ? GetUnitX(目标单位) : 实例.当前X;
    const endY = 目标单位 != null && 目标单位 !== 0 ? GetUnitY(目标单位) : 实例.当前Y;
    const endZ = 目标单位 != null && 目标单位 !== 0 ? GetUnitFlyHeight(目标单位) + 目标Z偏移 : 起点Z;
    const x = 二阶贝塞尔值(t, 起点X, 控制X, endX);
    const y = 二阶贝塞尔值(t, 起点Y, 控制Y, endY);
    const z = 二阶贝塞尔值(t, 起点Z, 控制Z, endZ);
    return {
      X: x,
      Y: y,
      Z: z,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建锁定单位二阶贝塞尔加速度XYZ轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制X: number,
  控制Y: number,
  控制Z: number,
  目标单位: any,
  目标Z偏移: number,
  初始速度: number,
  加速度: number = 0,
  加速度开始距离: number = 0,
): 原生弹幕轨迹采样器 {
  return function 锁定单位二阶贝塞尔加速度XYZ采样(this: void, 实例, delta): 原生弹幕轨迹采样结果 {
    const endX = 目标单位 != null && 目标单位 !== 0 ? GetUnitX(目标单位) : 实例.当前X;
    const endY = 目标单位 != null && 目标单位 !== 0 ? GetUnitY(目标单位) : 实例.当前Y;
    const endZ = 目标单位 != null && 目标单位 !== 0 ? GetUnitFlyHeight(目标单位) + 目标Z偏移 : 起点Z;
    const 路径长度 = 取二阶贝塞尔近似长度(起点X, 起点Y, 控制X, 控制Y, endX, endY);
    const t = 取加速度进度(实例.id, delta, 路径长度, 初始速度, 加速度, 加速度开始距离);
    const x = 二阶贝塞尔值(t, 起点X, 控制X, endX);
    const y = 二阶贝塞尔值(t, 起点Y, 控制Y, endY);
    const z = 二阶贝塞尔值(t, 起点Z, 控制Z, endZ);
    return {
      X: x,
      Y: y,
      Z: z,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建三阶贝塞尔轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  控制1X: number,
  控制1Y: number,
  控制2X: number,
  控制2Y: number,
  终点X: number,
  终点Y: number,
): 原生弹幕轨迹采样器 {
  return function 三阶贝塞尔采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const x01 = 线性插值(起点X, 控制1X, t);
    const y01 = 线性插值(起点Y, 控制1Y, t);
    const x12 = 线性插值(控制1X, 控制2X, t);
    const y12 = 线性插值(控制1Y, 控制2Y, t);
    const x23 = 线性插值(控制2X, 终点X, t);
    const y23 = 线性插值(控制2Y, 终点Y, t);
    const x012 = 线性插值(x01, x12, t);
    const y012 = 线性插值(y01, y12, t);
    const x123 = 线性插值(x12, x23, t);
    const y123 = 线性插值(y12, y23, t);
    const x = 线性插值(x012, x123, t);
    const y = 线性插值(y012, y123, t);
    return {
      X: x,
      Y: y,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}

export function 创建三阶贝塞尔XYZ轨迹(
  this: void,
  起点X: number,
  起点Y: number,
  起点Z: number,
  控制1X: number,
  控制1Y: number,
  控制1Z: number,
  控制2X: number,
  控制2Y: number,
  控制2Z: number,
  终点X: number,
  终点Y: number,
  终点Z: number,
): 原生弹幕轨迹采样器 {
  return function 三阶贝塞尔XYZ采样(this: void, 实例, _delta): 原生弹幕轨迹采样结果 {
    const t = 取弹幕轨迹进度(实例);
    const x = 三阶贝塞尔值(t, 起点X, 控制1X, 控制2X, 终点X);
    const y = 三阶贝塞尔值(t, 起点Y, 控制1Y, 控制2Y, 终点Y);
    const z = 三阶贝塞尔值(t, 起点Z, 控制1Z, 控制2Z, 终点Z);
    return {
      X: x,
      Y: y,
      Z: z,
      方向角: 取采样方向(实例.当前X, 实例.当前Y, x, y, 实例.当前方向角),
      完成: t >= 1,
    };
  };
}
