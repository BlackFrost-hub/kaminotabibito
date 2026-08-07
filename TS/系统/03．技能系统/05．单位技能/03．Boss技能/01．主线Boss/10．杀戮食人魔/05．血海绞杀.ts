/** @noSelfInFile */

import { 杀戮食人魔单位技能配置 } from './00．配置';
import { 获取或创建杀戮食人魔上下文, type 杀戮食人魔运行时上下文 } from './01．运行时上下文';
import { 杀戮食人魔技能配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 创建原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 开始硬直, 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
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
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 杀戮食人魔单位类型ID = stringToFourCCSafe(杀戮食人魔单位技能配置.单位ID);
const 血海绞杀技能ID = stringToFourCCSafe(杀戮食人魔单位技能配置.技能ID.血海绞杀);
const 血海绞杀无敌来源 = '杀戮食人魔-血海绞杀';
let 血海绞杀已注册 = false;

interface 血海绞杀施法数据 {
  上下文: 杀戮食人魔运行时上下文;
  技能实例ID?: number;
  方向角度列表: number[];
}

interface 血海弹幕数据 {
  Boss单位: any;
  技能实例ID?: number;
  特效累计秒: number;
}

const 血海弹幕数据表: Record<number, 血海弹幕数据 | undefined> = {};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 创建血海绞杀方向角度列表(this: void, 面向角度: number, 方向数: number): number[] {
  const 方向角度列表: number[] = [];
  for (let i = 1; i <= 方向数; i++) {
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

function on血海目标筛选(this: void, target: any, barrageId: number): boolean {
  if (barrageId == null) return false;
  const data = 血海弹幕数据表[barrageId];
  return data != null && 目标是Boss敌对英雄(data.Boss单位, target);
}

function on血海命中(this: void, target: any, barrageId: number): void {
  if (barrageId == null) return;
  const data = 血海弹幕数据表[barrageId];
  if (data == null || !单位存活(data.Boss单位) || !单位存活(target)) return;
  const cfg = 杀戮食人魔技能配置.血海绞杀;
  执行BossAOE技能伤害({
    来源: data.Boss单位,
    目标: target,
    技能ID: 血海绞杀技能ID,
    技能实例ID: data.技能实例ID,
    伤害公式: { 来源攻击力比例: cfg.攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '杀戮食人魔·血海绞杀',
  });
  施加快速控制Buff(data.Boss单位, target, 0, cfg.眩晕秒, '杀戮食人魔-血海绞杀', '技能');
}

function on血海Tick(this: void, instance: any, delta: number): void {
  if (instance == null || instance.id == null) return;
  const data = 血海弹幕数据表[instance.id];
  if (data == null) return;
  data.特效累计秒 += delta;
  if (data.特效累计秒 < 0.2) return;
  data.特效累计秒 = 0;
  const cfg = 杀戮食人魔技能配置.血海绞杀;
  EC_CreateEffect(cfg.弹幕模型, instance.当前X, instance.当前Y, 0, 0, 1, 1, 1);
  EC_CreateEffect(cfg.命中特效, instance.当前X, instance.当前Y, 0, 0, 1, 1, 1);
}

function on血海结束(this: void, _reason: any, barrageId: number): void {
  if (barrageId == null) return;
  delete 血海弹幕数据表[barrageId];
}

function on血海绞杀发射(this: void, variable?: any): void {
  const data = variable as 血海绞杀施法数据 | undefined;
  if (data == null) return;
  if (!单位存活(data.上下文.Boss单位)) return;
  const boss = data.上下文.Boss单位;
  const cfg = 杀戮食人魔技能配置.血海绞杀;
  解除暂停并取消无敌安全(boss, 血海绞杀无敌来源);
  if (data.方向角度列表.length !== cfg.方向数) return;
  for (let i = 0; i < data.方向角度列表.length; i++) {
    const angle = data.方向角度列表[i];
    const projectile = 创建原生弹幕({
      所有者: boss,
      载体模式: '特效',
      X: GetUnitX(boss),
      Y: GetUnitY(boss),
      方向角: angle,
      速度: cfg.弹幕速度,
      生命周期: cfg.弹幕持续秒,
      最大距离: cfg.弹幕速度 * cfg.弹幕持续秒,
      命中半径: cfg.命中半径,
      影响目标: '敌方',
      碰撞消失: false,
      每单位最大命中次数: 1,
      目标筛选: on血海目标筛选,
      on命中: on血海命中,
      onTick: on血海Tick,
      on结束: on血海结束,
    });
    const 弹幕ID = projectile != null ? projectile.弹幕ID : undefined;
    if (弹幕ID == null) continue;
    血海弹幕数据表[弹幕ID] = { Boss单位: boss, 技能实例ID: data.技能实例ID, 特效累计秒: 0.2 };
  }
}

function on血海绞杀硬直结束(this: void, variable?: any): void {
  const data = variable as 血海绞杀施法数据 | undefined;
  if (data == null) return;
  if (单位存活(data.上下文.Boss单位)) {
    解除暂停并取消无敌安全(data.上下文.Boss单位, 血海绞杀无敌来源);
  }
  关闭吟唱条('常规技能');
}

function on血海绞杀开始(this: void, variable?: any): void {
  const data = variable as 血海绞杀施法数据 | undefined;
  if (data == null) return;
  if (!单位存活(data.上下文.Boss单位)) return;
  const boss = data.上下文.Boss单位;
  const cfg = 杀戮食人魔技能配置.血海绞杀;
  const currentLife = GetUnitState(boss, UNIT_STATE_LIFE);
  const cost = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.最大生命消耗比例;
  const 扣血后生命 = currentLife - cost > 1 ? currentLife - cost : 1;
  SetUnitState(boss, UNIT_STATE_LIFE, 扣血后生命);
  开始硬直(boss, cfg.施法硬直秒);
  暂停并设置无敌安全(boss, 血海绞杀无敌来源);
  SetUnitAnimationByIndex(boss, cfg.动画编号);
  显示常规技能吟唱条({
    通道: '常规技能',
    总时长: cfg.施法硬直秒,
    颜色ID: 1,
    标题文本: '血海绞杀',
    提示文本: '四方向血海即将涌出',
  });
  const facing = GetUnitFacing(boss);
  data.方向角度列表 = 创建血海绞杀方向角度列表(facing, cfg.方向数);
  for (let i = 0; i < data.方向角度列表.length; i++) {
    EC_CreateEffect('war3mapImported\\bossjinggaoh.mdl', GetUnitX(boss), GetUnitY(boss), 0, data.方向角度列表[i], 2.8, 1, 1);
  }
  addDelayedCallback(cfg.生效延迟秒 * 1000, on血海绞杀发射, data);
  addDelayedCallback(cfg.施法硬直秒 * 1000, on血海绞杀硬直结束, data);
}

export function 释放杀戮食人魔血海绞杀(this: void, context: 杀戮食人魔运行时上下文, skillInstanceId?: number): boolean {
  if (!单位存活(context.Boss单位)) return false;
  addDelayedCallback(30, on血海绞杀开始, { 上下文: context, 技能实例ID: skillInstanceId, 方向角度列表: [] } as 血海绞杀施法数据);
  return true;
}

function on血海绞杀技能壳释放(this: void, context: 杀戮食人魔运行时上下文, _boss: any, skillInstanceId?: number): void {
  释放杀戮食人魔血海绞杀(context, skillInstanceId);
}

export function 注册杀戮食人魔血海绞杀(this: void): void {
  if (血海绞杀已注册) return;
  血海绞杀已注册 = true;
  注册单位技能壳监听({
    名称: '杀戮食人魔-血海绞杀',
    单位类型ID: 杀戮食人魔单位类型ID,
    技能ID: 血海绞杀技能ID,
    获取或创建上下文: 获取或创建杀戮食人魔上下文,
    释放技能: on血海绞杀技能壳释放,
    技能实例持续时间秒: 4,
  });
}
