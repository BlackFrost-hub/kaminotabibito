/** @noSelfInFile */
/**
 * TS 原生弹幕 - 移动处理
 */

import type { 原生弹幕内部实例, 原生弹幕附加特效参数 } from "../00．类型";
import {
  Atan2,
  CosBJ,
  DzSetEffectPos,
  EXEffectMatReset,
  EXEffectMatRotateY,
  EXEffectMatRotateZ,
  EXSetEffectSize,
  GetUnitFlyHeight,
  GetUnitFacing,
  GetUnitState,
  GetUnitX,
  GetUnitY,
  IsTerrainPathable,
  IsUnitPaused,
  PATHING_TYPE_WALKABILITY,
  SetUnitFlyHeight,
  SetUnitX,
  SetUnitY,
  SinBJ,
  UNIT_STATE_LIFE,
  bj_RADTODEG,
  标准化角度,
  角度差,
  计算距离,
  取坐标朝向角,
  限制范围,
  GetRandomReal,
} from "../01．共享";

const { 立即设置单位朝向 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  立即设置单位朝向: (this: void, 单位: any, 朝向角度: number) => void;
};

const UNIT_ALIVE_LIFE = 0.405;

export function 弹幕单位存活(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && GetUnitState(单位, UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 计算轨迹俯仰角(this: void, oldX: number, oldY: number, oldZ: number, x: number, y: number, z: number): number {
  const dz = z - oldZ;
  const horizontalDistance = 计算距离(oldX, oldY, x, y);
  if (horizontalDistance <= 0.001 && dz === 0) return 0;
  return Atan2(dz, horizontalDistance) * bj_RADTODEG;
}

function 解析附加特效缩放(this: void, 实例: 原生弹幕内部实例, 特效参数: 原生弹幕附加特效参数): number {
  return 特效参数.缩放 ?? (特效参数.跟随主弹幕参数 === true ? (实例.参数.缩放 ?? 1) : 1);
}

function 同步单个弹幕附加特效(
  this: void,
  实例: 原生弹幕内部实例,
  effect: any,
  特效参数: 原生弹幕附加特效参数 | undefined,
  x: number,
  y: number,
  z: number,
  新方向角: number,
  旋转角度差: number,
  轨迹俯仰角: number,
): void {
  if (effect == null || effect === 0) return;
  if (特效参数?.跟随轨迹俯仰 === true) {
    EXEffectMatReset(effect);
    EXSetEffectSize(effect, 解析附加特效缩放(实例, 特效参数));
    if (轨迹俯仰角 !== 0) EXEffectMatRotateY(effect, -轨迹俯仰角);
    if (新方向角 !== 0) EXEffectMatRotateZ(effect, 新方向角);
    DzSetEffectPos(effect, x, y, z);
    return;
  }
  DzSetEffectPos(effect, x, y, z);
  if (旋转角度差 !== 0) EXEffectMatRotateZ(effect, 旋转角度差);
}

function 同步弹幕附加特效(
  this: void,
  实例: 原生弹幕内部实例,
  oldX: number,
  oldY: number,
  oldZ: number,
  x: number,
  y: number,
  z: number,
  旧方向角: number,
  新方向角: number,
): void {
  const 旋转角度差 = 角度差(旧方向角, 新方向角);
  const 轨迹俯仰角 = 计算轨迹俯仰角(oldX, oldY, oldZ, x, y, z);
  同步单个弹幕附加特效(实例, 实例.附加特效1, 实例.参数.附加特效1, x, y, z, 新方向角, 旋转角度差, 轨迹俯仰角);
  同步单个弹幕附加特效(实例, 实例.附加特效2, 实例.参数.附加特效2, x, y, z, 新方向角, 旋转角度差, 轨迹俯仰角);
}

function 更新弹幕单位坐标(this: void, 实例: 原生弹幕内部实例, x: number, y: number, face: number, 旧方向角: number, z?: number): void {
  const 新方向角 = 标准化角度(face);
  const oldX = 实例.当前X;
  const oldY = 实例.当前Y;
  const oldZ = GetUnitFlyHeight(实例.弹幕单位);
  const newZ = z ?? oldZ;
  SetUnitX(实例.弹幕单位, x);
  SetUnitY(实例.弹幕单位, y);
  立即设置单位朝向(实例.弹幕单位, 新方向角);
  if (z != null) SetUnitFlyHeight(实例.弹幕单位, z, 0);
  实例.当前X = x;
  实例.当前Y = y;
  实例.当前方向角 = 新方向角;
  同步弹幕附加特效(实例, oldX, oldY, oldZ, x, y, newZ, 旧方向角, 新方向角);
}

function 更新追踪方向(this: void, 实例: 原生弹幕内部实例, delta: number): void {
  const 目标 = 实例.参数.指定目标;
  if (目标 == null || 目标 === 0 || !弹幕单位存活(目标)) return;

  const 目标角 = 取坐标朝向角(实例.当前X, 实例.当前Y, GetUnitX(目标), GetUnitY(目标));
  const 转向速度 = 实例.参数.追踪转向速度 ?? 0;
  if (转向速度 <= 0) {
    实例.当前方向角 = 标准化角度(目标角);
    return;
  }

  const 最大转向 = 转向速度 * delta;
  const diff = 角度差(实例.当前方向角, 目标角);
  实例.当前方向角 = 标准化角度(实例.当前方向角 + 限制范围(diff, -最大转向, 最大转向));
}

function 尝试弹射(this: void, 实例: 原生弹幕内部实例, 同步前方向角: number): boolean {
  if (实例.参数.弹射 !== true) return false;
  const 上限 = 实例.参数.弹射次数上限 ?? 0;
  if (上限 > 0 && 实例.弹射次数 >= 上限) return false;

  实例.弹射次数 += 1;
  if (实例.参数.随机弹射 === true) {
    实例.当前方向角 = 标准化角度(实例.当前方向角 + GetRandomReal(120, 240));
  } else {
    实例.当前方向角 = 标准化角度(实例.当前方向角 + (实例.参数.弹射角度 ?? 180));
  }
  立即设置单位朝向(实例.弹幕单位, 实例.当前方向角);
  const z = GetUnitFlyHeight(实例.弹幕单位);
  同步弹幕附加特效(实例, 实例.当前X, 实例.当前Y, z, 实例.当前X, 实例.当前Y, z, 同步前方向角, 实例.当前方向角);

  const 衰减 = 实例.参数.弹射衰减 ?? 0;
  if (衰减 > 0) {
    const 系数 = 限制范围(1 - 衰减, 0, 1);
    实例.当前速度 = 实例.当前速度 * 系数;
    实例.当前伤害值 = 实例.当前伤害值 * 系数;
  }
  return true;
}

export function 推进弹幕移动(this: void, 实例: 原生弹幕内部实例, delta: number): boolean {
  if (IsUnitPaused(实例.弹幕单位)) return false;

  const 延迟 = 实例.参数.延迟发射 ?? 0;
  if (延迟 > 0 && 实例.已运行时间 < 延迟) return false;
  const 移动前方向角 = 实例.当前方向角;

  const 采样器 = 实例.参数.轨迹采样器;
  if (采样器 != null) {
    const oldX = 实例.当前X;
    const oldY = 实例.当前Y;
    const 结果 = 采样器(实例, delta);
    实例.已飞行距离 += 计算距离(oldX, oldY, 结果.X, 结果.Y);
    更新弹幕单位坐标(实例, 结果.X, 结果.Y, 结果.方向角 ?? 实例.当前方向角, 移动前方向角, 结果.Z);
    return 结果.完成 === true;
  }

  if (实例.参数.轨迹类型 === "追踪") {
    更新追踪方向(实例, delta);
  } else {
    if (实例.参数.显式改向后锁定方向 !== true) {
      实例.当前方向角 = 标准化角度(GetUnitFacing(实例.弹幕单位));
    }
  }

  const 距离 = 实例.当前速度 * delta;
  const nextX = 实例.当前X + CosBJ(实例.当前方向角) * 距离;
  const nextY = 实例.当前Y + SinBJ(实例.当前方向角) * 距离;
  if (IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY)) {
    return !尝试弹射(实例, 移动前方向角);
  }

  实例.已飞行距离 += 距离;
  更新弹幕单位坐标(实例, nextX, nextY, 实例.当前方向角, 移动前方向角);
  return false;
}
