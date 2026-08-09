/** @noSelfInFile */

import { 极坐标X, 极坐标Y, 两点角度 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 沙漠食人魔技能配置 } from '../01．沙漠食人魔/02．数值与表现配置';
import { 杀戮食人魔技能配置 } from '../10．杀戮食人魔/02．数值与表现配置';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 播放食人魔公共台词 } from './03．台词播放';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const globals = require('jass.globals') as { [key: string]: any };

const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 获取Boss技能敌对英雄列表, 是否已登记Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  是否已登记Boss技能测试目标: (this: void, unit: any) => boolean;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { getGameDifficulty, getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getGameDifficulty: (this: void) => number;
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any | null;
};
const { 提交预计算BossAOE技能伤害 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器') as {
  提交预计算BossAOE技能伤害: (this: void, 参数: any) => any;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const StartSound = jass.StartSound as (this: void, soundHandle: any) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 食人魔心脏掌握配置 {
  基础斩杀线比例: number;
  每层难度斩杀线比例: number;
  单人斩杀线倍率: number;
  冷却秒: number;
  预警秒: number;
  第二段预警秒: number;
  当前生命伤害比例: number;
  分摊范围: number;
  瞬移距离: number;
  动作重播间隔秒: number;
  动作编号: number;
  吟唱条颜色ID: number;
  吟唱条标题文本: string;
  吟唱条提示文本: string;
  第一段预警特效: string;
  第二段预警特效: string;
  结算特效: string;
  音效全局变量名: string;
}

interface 食人魔心脏掌握状态 {
  Boss单位: any;
  冷却结束毫秒: number;
  施法中: boolean;
}

interface 心脏掌握数据 {
  Boss单位: any;
  目标单位: any;
  状态: 食人魔心脏掌握状态;
  配置: 食人魔心脏掌握配置;
  形态名: string;
}

const 普通食人魔单位类型ID = stringToFourCCSafe('N05J');
const 杀戮食人魔单位类型ID = stringToFourCCSafe('N05K');
const 心脏掌握状态表: Record<number, 食人魔心脏掌握状态 | undefined> = {};
let 食人魔心脏掌握已注册 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? GetHandleId(handle) : 0;
}

function 取心脏掌握配置(this: void, boss: any): { 配置: 食人魔心脏掌握配置; 形态名: string } | undefined {
  const unitTypeId = GetUnitTypeId(boss);
  if (unitTypeId === 普通食人魔单位类型ID) {
    return { 配置: 沙漠食人魔技能配置.心脏掌握 as 食人魔心脏掌握配置, 形态名: '普通' };
  }
  if (unitTypeId === 杀戮食人魔单位类型ID) {
    return { 配置: 杀戮食人魔技能配置.心脏掌握 as 食人魔心脏掌握配置, 形态名: '杀戮' };
  }
  return undefined;
}

function 获取心脏掌握状态(this: void, boss: any): 食人魔心脏掌握状态 | undefined {
  const bossHid = 取句柄ID(boss);
  if (bossHid === 0) return undefined;
  let state = 心脏掌握状态表[bossHid];
  if (state == null || state.Boss单位 !== boss) {
    state = { Boss单位: boss, 冷却结束毫秒: 0, 施法中: false };
    心脏掌握状态表[bossHid] = state;
  }
  return state;
}

function 是注册玩家英雄(this: void, unit: any): boolean {
  if (!单位存活(unit)) return false;
  const owner = GetOwningPlayer(unit);
  return (owner != null && owner !== 0 && getRegisteredPlayerHero(owner) === unit)
    || 是否已登记Boss技能测试目标(unit);
}

function 创建每秒动作重播时点(this: void, 持续秒: number, 间隔秒: number): number[] {
  const result: number[] = [];
  if (!(间隔秒 > 0)) return result;
  for (let 秒数 = 间隔秒; 秒数 < 持续秒; 秒数 += 间隔秒) result.push(秒数);
  return result;
}

function 瞬移到目标背后(this: void, boss: any, target: any, cfg: 食人魔心脏掌握配置): boolean {
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const behindAngle = GetUnitFacing(target) + 180;
  const behindX = 极坐标X(targetX, behindAngle, cfg.瞬移距离);
  const behindY = 极坐标Y(targetY, behindAngle, cfg.瞬移距离);
  const teleported = 执行战斗自身传送到坐标(boss, behindX, behindY);
  if (teleported) 立即设置单位朝向(boss, 两点角度(behindX, behindY, targetX, targetY));
  return teleported;
}

function 列表包含单位(this: void, list: any[], unit: any): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === unit) return true;
  }
  return false;
}

function on心脏掌握第二段预警(this: void, variable?: any): void {
  const data = variable as 心脏掌握数据 | undefined;
  if (data == null || !单位存活(data.目标单位)) return;
  EC_CreateEffect(data.配置.第二段预警特效, GetUnitX(data.目标单位), GetUnitY(data.目标单位), 0, 270, 1.5, 1, 1);
  debugLogForce('食人魔-心脏掌握', '第二段预警特效', '形态=', data.形态名, 'targetHid=', 取句柄ID(data.目标单位));
}

function on心脏掌握结算(this: void, variable?: any): void {
  const data = variable as 心脏掌握数据 | undefined;
  if (data == null) return;
  关闭吟唱条('大招');
  data.状态.施法中 = false;
  if (!单位存活(data.目标单位)) {
    debugLogForce('食人魔-心脏掌握', '斩杀结算跳过：目标已失效', '形态=', data.形态名, 'bossHid=', 取句柄ID(data.Boss单位), 'targetHid=', 取句柄ID(data.目标单位));
    return;
  }
  if (!单位存活(data.Boss单位)) {
    移除单位指定Buff(data.目标单位, 食人魔BuffID.心脏掌握);
    debugLogForce('食人魔-心脏掌握', '斩杀结算跳过：Boss已失效', '形态=', data.形态名, 'bossHid=', 取句柄ID(data.Boss单位), 'targetHid=', 取句柄ID(data.目标单位));
    return;
  }
  const boss = data.Boss单位;
  const target = data.目标单位;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const participants: any[] = [target];
  const radiusSquared = data.配置.分摊范围 * data.配置.分摊范围;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位存活(hero) || 列表包含单位(participants, hero)) continue;
    const dx = GetUnitX(hero) - targetX;
    const dy = GetUnitY(hero) - targetY;
    if (dx * dx + dy * dy <= radiusSquared) participants.push(hero);
  }
  const currentLife = GetUnitState(target, UNIT_STATE_LIFE);
  const totalDamage = currentLife * data.配置.当前生命伤害比例;
  const sharedDamage = totalDamage / participants.length;
  EC_CreateEffect(data.配置.结算特效, targetX, targetY, 0, 270, 2, 1, 1.5);
  移除单位指定Buff(target, 食人魔BuffID.心脏掌握);
  for (let i = 0; i < participants.length; i++) {
    提交预计算BossAOE技能伤害({
      来源: boss,
      目标: participants[i],
      伤害: sharedDamage,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: data.形态名 + '食人魔·心脏掌握',
    });
  }
  if (!单位存活(target)) {
    播放食人魔公共台词(boss, '心脏掌握斩杀', GetUnitName(target));
  }
  debugLogForce('食人魔-心脏掌握', '斩杀结算完成', '形态=', data.形态名, 'bossHid=', 取句柄ID(boss), 'targetHid=', 取句柄ID(target), 'participantCount=', participants.length, 'currentLifeBefore=', currentLife, 'totalDamage=', totalDamage, 'sharedDamage=', sharedDamage);
}

function 尝试触发心脏掌握(this: void, boss: any, target: any): void {
  if (!是注册玩家英雄(target)) return;
  const info = 取心脏掌握配置(boss);
  const state = 获取心脏掌握状态(boss);
  if (info == null || state == null) return;
  const now = getServerTime();
  if (state.施法中 || now < state.冷却结束毫秒) return;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  let threshold = info.配置.基础斩杀线比例 + info.配置.每层难度斩杀线比例 * difficulty;
  if (取当前有效玩家人数() <= 1) threshold *= info.配置.单人斩杀线倍率;
  const currentLife = GetUnitState(target, UNIT_STATE_LIFE);
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0) || currentLife > maxLife * threshold) return;

  state.冷却结束毫秒 = now + info.配置.冷却秒 * 1000;
  state.施法中 = true;
  const teleportSuccess = 瞬移到目标背后(boss, target, info.配置);
  开始硬直(target, info.配置.预警秒);
  开始硬直(boss, info.配置.预警秒);
  registerManualBuff(target, 食人魔BuffID.心脏掌握, info.配置.预警秒, 1, { sourceUnit: boss, sourceName: info.形态名 + '食人魔-心脏掌握' });
  EC_CreateEffect(info.配置.第一段预警特效, GetUnitX(target), GetUnitY(target), 0, 270, 1.5, 1, 2);
  播放限时单位动画({
    单位: boss,
    动画编号: info.配置.动作编号,
    持续秒: info.配置.预警秒,
    重播时点秒列表: 创建每秒动作重播时点(info.配置.预警秒, info.配置.动作重播间隔秒),
    恢复动画编号: 0,
  });
  显示大招吟唱条({
    通道: '大招',
    总时长: info.配置.预警秒,
    颜色ID: info.配置.吟唱条颜色ID,
    标题文本: info.配置.吟唱条标题文本,
    提示文本: info.形态名 + '食人魔' + info.配置.吟唱条提示文本,
  });
  const 音效句柄 = globals[info.配置.音效全局变量名];
  if (音效句柄 != null && 音效句柄 !== 0) StartSound(音效句柄);
  播放食人魔公共台词(boss, '心脏掌握', GetUnitName(target));
  const data: 心脏掌握数据 = { Boss单位: boss, 目标单位: target, 状态: state, 配置: info.配置, 形态名: info.形态名 };
  const secondWarningCallbackId = addDelayedCallback(info.配置.第二段预警秒 * 1000, on心脏掌握第二段预警, data);
  const resolveCallbackId = addDelayedCallback(info.配置.预警秒 * 1000, on心脏掌握结算, data);
  debugLogForce('食人魔-心脏掌握', '触发预警表现', '形态=', info.形态名, 'bossHid=', 取句柄ID(boss), 'targetHid=', 取句柄ID(target), 'difficulty=', difficulty, 'threshold=', threshold, 'currentLife=', currentLife, 'maxLife=', maxLife, 'teleportSuccess=', teleportSuccess, 'targetHardStunSeconds=', info.配置.预警秒, 'bossHardStunSeconds=', info.配置.预警秒, 'animationIndex=', info.配置.动作编号, 'actionReplayIntervalSeconds=', info.配置.动作重播间隔秒, 'secondWarningCallbackId=', secondWarningCallbackId, 'resolveCallbackId=', resolveCallbackId);
}

function on食人魔造成最终伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (!(applied > 0) || !单位存活(attacker)) return;
  尝试触发心脏掌握(attacker, target);
}

export function 注册食人魔心脏掌握(this: void): void {
  if (食人魔心脏掌握已注册) return;
  食人魔心脏掌握已注册 = true;
  registerAppliedFinalDamageListener(on食人魔造成最终伤害);
}
