/** @noSelfInFile */

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 释放雅儿贝德黑翼横扫 } from './02．黑翼横扫';
import { 释放雅儿贝德守护者之职责 } from './03．守护者之职责';
import { 释放雅儿贝德守护回归 } from './08．守护回归';
import { 释放雅儿贝德护卫反击 } from './09．护卫反击';

const { 获取Boss技能最近敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

export function 推进雅儿贝德技能驱动(this: void, context: 安兹运行时上下文): void {
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
    if (释放雅儿贝德守护回归(context)) return;
  }
  const cooldown = cfg.黑翼横扫冷却秒
    * (state.阶段状态 === '狂怒护卫' ? cfg.黑翼横扫狂怒冷却倍率 : 1)
    * 1000;
  const now = getServerTime();
  if (now < state.上次普通技能Ms + cooldown) {
    if (active == null && !释放雅儿贝德护卫反击(context)) 释放雅儿贝德守护者之职责(context);
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
    释放雅儿贝德黑翼横扫(context, target);
  } else if (active == null) {
    释放雅儿贝德守护者之职责(context);
  }
}

export const 雅儿贝德技能驱动状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '根据安兹阶段、雅儿贝德生命、双方距离和共享大型技能锁选择护卫动作。',
} as const;
