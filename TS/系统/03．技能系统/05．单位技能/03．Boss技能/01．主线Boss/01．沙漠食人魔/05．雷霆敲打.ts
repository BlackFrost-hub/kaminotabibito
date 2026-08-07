/** @noSelfInFile */

import { 沙漠食人魔单位技能配置 } from './00．配置';
import { 沙漠食人魔技能配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 创建原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 施加快速减速Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 雷霆敲打无敌来源 = '沙漠食人魔-雷霆敲打';

const 沙漠食人魔单位类型ID = stringToFourCCSafe(沙漠食人魔单位技能配置.单位ID);
const 雷霆敲打技能ID = stringToFourCCSafe(沙漠食人魔单位技能配置.技能ID.雷霆敲打);
const 雷霆敲打方向数 = 4;
let 雷霆敲打已注册 = false;

interface 雷霆敲打施法数据 {
  Boss单位: any;
  技能实例ID?: number;
  已执行轮数: number;
  周期ID: number;
}

interface 雷霆敲打轮次数据 {
  施法数据: 雷霆敲打施法数据;
  面向角度: number;
  方向角度列表: number[];
}

interface 雷霆冲击波数据 {
  Boss单位: any;
  技能实例ID?: number;
  特效累计秒: number;
}

const 雷霆冲击波数据表: Record<number, 雷霆冲击波数据 | undefined> = {};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 获取沙漠食人魔技能上下文(this: void, boss: any): any | undefined {
  return 单位存活(boss) ? boss : undefined;
}

function 创建雷霆敲打方向角度列表(this: void, 面向角度: number): number[] {
  const 方向角度列表: number[] = [];
  for (let i = 1; i <= 雷霆敲打方向数; i++) {
    方向角度列表[i - 1] = 面向角度 + 90 * i;
  }
  return 方向角度列表;
}

function 目标是Boss敌对英雄(this: void, boss: any, target: any): boolean {
  if (!单位存活(target)) return false;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    if (heroes[i] === target) return true;
  }
  return false;
}

function on雷霆冲击波目标筛选(this: void, target: any, barrageId: number): boolean {
  if (barrageId == null) return false;
  const data = 雷霆冲击波数据表[barrageId];
  return data != null && 目标是Boss敌对英雄(data.Boss单位, target);
}

function on雷霆冲击波命中(this: void, target: any, barrageId: number): void {
  if (barrageId == null) return;
  const data = 雷霆冲击波数据表[barrageId];
  if (data == null || !单位存活(data.Boss单位) || !单位存活(target)) return;
  const cfg = 沙漠食人魔技能配置.雷霆敲打;
  执行BossAOE技能伤害({
    来源: data.Boss单位,
    目标: target,
    技能ID: 雷霆敲打技能ID,
    技能实例ID: data.技能实例ID,
    伤害公式: { 来源攻击力比例: cfg.攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_PLANT,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '沙漠食人魔·雷霆敲打',
  });
  施加快速减速Buff(data.Boss单位, target, 0, cfg.减速比例, cfg.减速秒, '沙漠食人魔-雷霆敲打', '技能');
}

function on雷霆冲击波Tick(this: void, instance: any, delta: number): void {
  if (instance == null || instance.id == null) return;
  const data = 雷霆冲击波数据表[instance.id];
  if (data == null) return;
  data.特效累计秒 += delta;
  if (data.特效累计秒 < 0.2) return;
  data.特效累计秒 = 0;
  EC_CreateEffect(沙漠食人魔技能配置.雷霆敲打.弹幕模型, instance.当前X, instance.当前Y, 0, 0, 1, 1, 1);
}

function on雷霆冲击波结束(this: void, reason: any, barrageId: number): void {
  if (barrageId == null) return;
  delete 雷霆冲击波数据表[barrageId];
}

function on雷霆敲打发射(this: void, variable?: any): void {
  const round = variable as 雷霆敲打轮次数据 | undefined;
  if (round == null || !单位存活(round.施法数据.Boss单位)) return;
  const cfg = 沙漠食人魔技能配置.雷霆敲打;
  if (round.方向角度列表.length !== 雷霆敲打方向数) return;
  for (let i = 0; i < round.方向角度列表.length; i++) {
    const angle = round.方向角度列表[i];
    const projectile = 创建原生弹幕({
      所有者: round.施法数据.Boss单位,
      载体模式: '特效',
      X: GetUnitX(round.施法数据.Boss单位),
      Y: GetUnitY(round.施法数据.Boss单位),
      方向角: angle,
      速度: cfg.弹幕速度,
      生命周期: cfg.弹幕持续秒,
      最大距离: cfg.弹幕速度 * cfg.弹幕持续秒,
      命中半径: cfg.命中半径,
      影响目标: '敌方',
      碰撞消失: false,
      每单位最大命中次数: 1,
      目标筛选: on雷霆冲击波目标筛选,
      on命中: on雷霆冲击波命中,
      onTick: on雷霆冲击波Tick,
      on结束: on雷霆冲击波结束,
    });
    const 弹幕ID = projectile != null ? projectile.弹幕ID : undefined;
    if (弹幕ID == null) continue;
    雷霆冲击波数据表[弹幕ID] = {
      Boss单位: round.施法数据.Boss单位,
      技能实例ID: round.施法数据.技能实例ID,
      特效累计秒: 0.2,
    };
  }
}

function on雷霆敲打转向(this: void, variable?: any): void {
  const round = variable as 雷霆敲打轮次数据 | undefined;
  if (round == null || !单位存活(round.施法数据.Boss单位)) return;
  SetUnitFacing(round.施法数据.Boss单位, round.面向角度 + 沙漠食人魔技能配置.雷霆敲打.每轮转向角度);
}

function on雷霆敲打轮次(this: void, variable?: any): void {
  const data = variable as 雷霆敲打施法数据 | undefined;
  if (data == null || !单位存活(data.Boss单位)) {
    if (data != null && data.周期ID > 0) removePeriodicCallback(data.周期ID);
    return;
  }
  const cfg = 沙漠食人魔技能配置.雷霆敲打;
  data.已执行轮数++;
  SetUnitAnimationByIndex(data.Boss单位, cfg.动画编号);
  const facing = GetUnitFacing(data.Boss单位);
  const round: 雷霆敲打轮次数据 = { 施法数据: data, 面向角度: facing, 方向角度列表: 创建雷霆敲打方向角度列表(facing) };
  for (let i = 0; i < round.方向角度列表.length; i++) {
    EC_CreateEffect(cfg.预警特效, GetUnitX(data.Boss单位), GetUnitY(data.Boss单位), 0, round.方向角度列表[i], 2.8, 1, 1);
  }
  addDelayedCallback(cfg.预警秒 * 1000, on雷霆敲打发射, round);
  if (data.已执行轮数 < cfg.轮数) addDelayedCallback(850, on雷霆敲打转向, round);
  if (data.已执行轮数 >= cfg.轮数 && data.周期ID > 0) {
    removePeriodicCallback(data.周期ID);
    data.周期ID = 0;
  }
}

function on雷霆敲打结束(this: void, variable?: any): void {
  const data = variable as 雷霆敲打施法数据 | undefined;
  if (data == null) return;
  if (data.周期ID > 0) removePeriodicCallback(data.周期ID);
  data.周期ID = 0;
  解除暂停并取消无敌安全(data.Boss单位, 雷霆敲打无敌来源);
  关闭吟唱条('常规技能');
}

export function 释放沙漠食人魔雷霆敲打(this: void, boss: any, skillInstanceId?: number): boolean {
  if (!单位存活(boss)) return false;
  const cfg = 沙漠食人魔技能配置.雷霆敲打;
  const data: 雷霆敲打施法数据 = { Boss单位: boss, 技能实例ID: skillInstanceId, 已执行轮数: 0, 周期ID: 0 };
  const 最后一轮发射秒 = cfg.轮次间隔秒 * cfg.轮数 + cfg.预警秒;
  const 总持续秒 = 最后一轮发射秒 + 0.1;
  暂停并设置无敌安全(boss, 雷霆敲打无敌来源);
  显示常规技能吟唱条({
    通道: '常规技能',
    总时长: 总持续秒,
    颜色ID: 3,
    标题文本: '雷霆敲打',
    提示文本: '连续四轮雷霆冲击',
  });
  data.周期ID = addPeriodicCallback(cfg.轮次间隔秒 * 1000, on雷霆敲打轮次, data);
  addDelayedCallback(总持续秒 * 1000, on雷霆敲打结束, data);
  return true;
}

function on雷霆敲打技能壳释放(this: void, _context: any, boss: any, skillInstanceId?: number): void {
  释放沙漠食人魔雷霆敲打(boss, skillInstanceId);
}

export function 注册沙漠食人魔雷霆敲打(this: void): void {
  if (雷霆敲打已注册) return;
  雷霆敲打已注册 = true;
  注册单位技能壳监听({
    名称: '沙漠食人魔-雷霆敲打',
    单位类型ID: 沙漠食人魔单位类型ID,
    技能ID: 雷霆敲打技能ID,
    获取或创建上下文: 获取沙漠食人魔技能上下文,
    释放技能: on雷霆敲打技能壳释放,
    技能实例持续时间秒: 8,
  });
}
