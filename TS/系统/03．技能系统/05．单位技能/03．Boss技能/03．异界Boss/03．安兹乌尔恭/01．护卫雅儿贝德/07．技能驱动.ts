/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 释放雅儿贝德黑翼横扫 } from './02．黑翼横扫';
import { 释放雅儿贝德守护者之职责 } from './03．守护者之职责';
import { 释放雅儿贝德守护回归 } from './08．守护回归';
import { 释放雅儿贝德护卫反击 } from './09．护卫反击';
import { 播放雅儿贝德台词 } from './10．台词播放';
import { 开始雅儿贝德冲锋 } from './00．冲锋表现';
import { 播放限时单位动画 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';

const { 获取Boss技能最近敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { Boss自动施法是否开启 } = require('系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关') as {
  Boss自动施法是否开启: (this: void) => boolean;
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const RAD_TO_DEG = 57.29577951308232;

function 取雅儿贝德时间停止冲锋路径(this: void, albedo: any, targetX: number, targetY: number): { X: number; Y: number; 距离: number; 朝向: number } | undefined {
  const startX = GetUnitX(albedo);
  const startY = GetUnitY(albedo);
  const dx = targetX - startX;
  const dy = targetY - startY;
  const distance = SquareRoot(dx * dx + dy * dy);
  if (distance <= 1) return undefined;
  return { X: startX, Y: startY, 距离: distance, 朝向: Atan2(dy, dx) * RAD_TO_DEG };
}

export function 创建雅儿贝德时间停止冲锋预警(this: void, context: 安兹运行时上下文, targetX: number, targetY: number, durationSeconds: number): void {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return;
  const path = 取雅儿贝德时间停止冲锋路径(albedo, targetX, targetY);
  if (path == null) return;
  创建技能提示圈({
    类型: '方向直线',
    X: path.X,
    Y: path.Y,
    宽度: 安兹乌尔恭数值与表现配置.阶段技能.时间停止雅儿贝德冲锋路径宽度,
    长度: path.距离,
    朝向: path.朝向,
    持续时间: durationSeconds,
    来源单位: albedo,
  });
}

export function 启动雅儿贝德时间停止冲锋(this: void, context: 安兹运行时上下文, targetX: number, targetY: number): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || context.挑战已结束 || context.当前大型技能 !== '时间停止') return false;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return false;
  const path = 取雅儿贝德时间停止冲锋路径(albedo, targetX, targetY);
  if (path == null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  播放限时单位动画({
    单位: albedo,
    动画编号: 安兹乌尔恭数值与表现配置.守护者模式.守护回归动画编号,
    持续秒: cfg.时间停止雅儿贝德冲锋秒,
    恢复动画编号: 1,
  });
  const chargeId = 开始雅儿贝德冲锋(albedo, {
    目标X: targetX,
    目标Y: targetY,
    距离: path.距离,
    持续时间: cfg.时间停止雅儿贝德冲锋秒,
    检查地形: true,
    暂停单位: true,
    禁用碰撞: true,
  });
  return chargeId !== 0;
}

export function 推进雅儿贝德技能驱动(this: void, context: 安兹运行时上下文): void {
  if (!Boss自动施法是否开启()) return;
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || context.挑战已结束 || context.当前大型技能 != null) return;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return;
  const active = state.独占状态?.取当前();
  if (active != null && active.key !== '雅儿贝德-守护者之职责') return;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const guardDx = GetUnitX(albedo) - GetUnitX(context.安兹单位);
  const guardDy = GetUnitY(albedo) - GetUnitY(context.安兹单位);
  if (guardDx * guardDx + guardDy * guardDy > cfg.守护回归触发距离 * cfg.守护回归触发距离) {
    if (释放雅儿贝德守护回归(context)) {
      播放雅儿贝德台词(albedo, '守护回归');
      return;
    }
  }
  const cooldown = cfg.黑翼横扫冷却秒
    * (state.阶段状态 === '狂怒护卫' ? cfg.黑翼横扫狂怒冷却倍率 : 1)
    * 1000;
  const now = getServerTime();
  if (now < state.上次普通技能Ms + cooldown) {
    if (active == null && 释放雅儿贝德护卫反击(context)) 播放雅儿贝德台词(albedo, '护卫反击');
    else if (active == null && 释放雅儿贝德守护者之职责(context)) 播放雅儿贝德台词(albedo, '守护者之职责');
    return;
  }
  const target = 获取Boss技能最近敌对英雄(context.安兹单位);
  if (!单位有效(target)) {
    if (active == null) 释放雅儿贝德守护者之职责(context);
    return;
  }
  const dx = GetUnitX(target) - GetUnitX(albedo);
  const dy = GetUnitY(target) - GetUnitY(albedo);
  if (dx * dx + dy * dy <= cfg.黑翼横扫半径 * cfg.黑翼横扫半径) {
    if (释放雅儿贝德黑翼横扫(context, target)) 播放雅儿贝德台词(albedo, '黑翼横扫');
  } else if (active == null) {
    if (释放雅儿贝德守护者之职责(context)) 播放雅儿贝德台词(albedo, '守护者之职责');
  }
}

export const 雅儿贝德技能驱动状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '根据安兹阶段、雅儿贝德生命、双方距离和共享大型技能锁选择护卫动作。',
} as const;
