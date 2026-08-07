/** @noSelfInFile */

import { 杀戮食人魔单位技能配置 } from './00．配置';
import { 获取杀戮食人魔上下文, 获取或创建杀戮食人魔上下文, type 杀戮食人魔运行时上下文 } from './01．运行时上下文';
import { 杀戮食人魔技能配置 } from './02．数值与表现配置';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 提交预计算Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as { 启动基础施法时间线: (this: void, 参数: any) => any };
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as { registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void };
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能随机敌对英雄: (this: void, boss: any) => any };
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as { EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any };
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as { stringToFourCCSafe: (this: void, text: string) => number };
const jass = require('jass.common') as any;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddLightning = jass.AddLightning as (codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const MoveLightningEx = jass.MoveLightningEx as (lightning: any, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => boolean;
const DestroyLightning = jass.DestroyLightning as (lightning: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 杀戮食人魔单位类型ID = stringToFourCCSafe(杀戮食人魔单位技能配置.单位ID);
const 痛之束缚技能ID = stringToFourCCSafe(杀戮食人魔单位技能配置.技能ID.痛之束缚);
let 痛之束缚已注册 = false;
let 痛之束缚伤害监听已注册 = false;

interface 痛之束缚待发数据 { 上下文: 杀戮食人魔运行时上下文; 目标单位: any; 技能实例ID?: number; }
const 痛之束缚待发队列: 痛之束缚待发数据[] = [];

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 清除痛之束缚(this: void, context: 杀戮食人魔运行时上下文): void {
  const 旧周期ID = context.束缚周期ID;
  const 旧目标 = context.束缚目标;
  const 旧闪电 = context.束缚闪电;
  if (旧周期ID > 0) removePeriodicCallback(旧周期ID);
  context.束缚周期ID = 0;
  if (旧闪电 != null && 旧闪电 !== 0) DestroyLightning(旧闪电);
  if (旧目标 != null && 旧目标 !== 0) 移除单位指定Buff(旧目标, 食人魔BuffID.痛之束缚);
  context.束缚闪电 = null;
  context.束缚目标 = null;
  context.束缚反伤中 = false;
}

function on痛之束缚上下文清理(this: void, variable?: any): void {
  const context = variable as 杀戮食人魔运行时上下文 | undefined;
  if (context != null) {
    清除痛之束缚(context);
  }
}

function on痛之束缚周期(this: void, variable?: any): void {
  const context = variable as 杀戮食人魔运行时上下文 | undefined;
  if (context == null || !单位存活(context.Boss单位) || !单位存活(context.束缚目标)) {
    if (context != null) {
      清除痛之束缚(context);
    }
    return;
  }
  if (getBuffRuntime(context.束缚目标, 食人魔BuffID.痛之束缚) == null) {
    清除痛之束缚(context);
    return;
  }
  const dx = GetUnitX(context.束缚目标) - GetUnitX(context.Boss单位);
  const dy = GetUnitY(context.束缚目标) - GetUnitY(context.Boss单位);
  const maxDistance = 杀戮食人魔技能配置.痛之束缚.断裂距离;
  if (dx * dx + dy * dy > maxDistance * maxDistance) {
    清除痛之束缚(context);
    return;
  }
  MoveLightningEx(context.束缚闪电, false, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 80, GetUnitX(context.束缚目标), GetUnitY(context.束缚目标), 80);
}

function 建立痛之束缚(this: void, data: 痛之束缚待发数据): void {
  const context = data.上下文;
  const boss = context.Boss单位;
  const target = data.目标单位;
  if (!单位存活(boss) || !单位存活(target)) return;
  清除痛之束缚(context);
  context.束缚目标 = target;
  context.束缚闪电 = AddLightning(杀戮食人魔技能配置.痛之束缚.闪电代码, false, GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target));
  registerManualBuff(target, 食人魔BuffID.痛之束缚, 杀戮食人魔技能配置.痛之束缚.持续秒, 杀戮食人魔技能配置.痛之束缚.伤害转移比例, { sourceUnit: boss, sourceName: '杀戮食人魔-痛之束缚' });
  context.束缚周期ID = addPeriodicCallback(100, on痛之束缚周期, context);
  if (!context.束缚清理已登记) {
    context.束缚清理已登记 = true;
    context.清理.登记清理('杀戮食人魔-痛之束缚', on痛之束缚上下文清理, context);
  }
}

function on痛之束缚生效(this: void): void {
  while (痛之束缚待发队列.length > 0) {
    const data = 痛之束缚待发队列[0];
    痛之束缚待发队列.splice(0, 1);
    if (data == null || !单位存活(data.上下文.Boss单位) || !单位存活(data.目标单位)) {
      continue;
    }
    建立痛之束缚(data);
    return;
  }
}

function on痛之束缚反伤(this: void, target: any, _attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !单位存活(target) || GetUnitTypeId(target) !== 杀戮食人魔单位类型ID) return;
  const context = 获取杀戮食人魔上下文(target);
  if (context == null || context.束缚反伤中 || !单位存活(context.束缚目标)) return;
  if (snapshot != null && snapshot.isDamageTransfer === true) return;
  const dx = GetUnitX(context.束缚目标) - GetUnitX(target);
  const dy = GetUnitY(context.束缚目标) - GetUnitY(target);
  const cfg = 杀戮食人魔技能配置.痛之束缚;
  if (dx * dx + dy * dy > cfg.断裂距离 * cfg.断裂距离) {
    清除痛之束缚(context);
    return;
  }
  context.束缚反伤中 = true;
  EC_CreateEffect(cfg.命中特效, GetUnitX(context.束缚目标), GetUnitY(context.束缚目标), 0, 0, 1.25, 1.5, 0.5);
  const 转移伤害 = applied * cfg.伤害转移比例;
  提交预计算Boss单体技能伤害({
    来源: target,
    目标: context.束缚目标,
    伤害: 转移伤害,
    技能ID: 痛之束缚技能ID,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '杀戮食人魔·痛之束缚',
    isDamageTransfer: true,
  });
  context.束缚反伤中 = false;
}

function 取痛之束缚目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位存活(spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss);
}

export function 释放杀戮食人魔痛之束缚(this: void, context: 杀戮食人魔运行时上下文, skillInstanceId?: number): boolean {
  const boss = context.Boss单位;
  if (!单位存活(boss)) return false;
  const target = 取痛之束缚目标(boss);
  if (!单位存活(target)) return false;
  痛之束缚待发队列.push({ 上下文: context, 目标单位: target, 技能实例ID: skillInstanceId });
  启动基础施法时间线({
    名称: '杀戮食人魔-痛之束缚',
    施法者: boss,
    目标单位: target,
    硬直秒: 0.7,
    动画编号: 5,
    恢复动画编号: 1,
    吟唱条: { 通道: '常规技能', 总时长: 0.7, 颜色ID: 1, 标题文本: '痛之束缚', 提示文本: '远离食人魔可挣脱链接' },
    on生效: on痛之束缚生效,
  });
  return true;
}

function on痛之束缚技能壳释放(this: void, context: 杀戮食人魔运行时上下文, _boss: any, skillInstanceId?: number): void {
  释放杀戮食人魔痛之束缚(context, skillInstanceId);
}

export function 注册杀戮食人魔痛之束缚(this: void): void {
  if (!痛之束缚伤害监听已注册) {
    痛之束缚伤害监听已注册 = true;
    registerAppliedFinalDamageListener(on痛之束缚反伤);
  }
  if (痛之束缚已注册) {
    return;
  }
  痛之束缚已注册 = true;
  注册单位技能壳监听({
    名称: '杀戮食人魔-痛之束缚',
    单位类型ID: 杀戮食人魔单位类型ID,
    技能ID: 痛之束缚技能ID,
    获取或创建上下文: 获取或创建杀戮食人魔上下文,
    释放技能: on痛之束缚技能壳释放,
    技能实例持续时间秒: 10,
  });
}
