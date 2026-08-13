/** @noSelfInFile */

import { 杀戮食人魔单位技能配置 } from './00．配置';
import { 获取或创建杀戮食人魔上下文, type 杀戮食人魔运行时上下文 } from './01．运行时上下文';
import { 杀戮食人魔技能配置, 杀戮食人魔音效配置 } from './02．数值与表现配置';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 提交预计算Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerHealCallback } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  registerHealCallback: (this: void, callback: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};
const { registerManualBuff, getBuffRuntime } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
};
const { 单位是否免疫负面效果BuffID } = require('系统.05．Buff系统.06．负面效果免疫状态') as {
  单位是否免疫负面效果BuffID: (this: void, unit: any, buffID: string) => boolean;
};
const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: (this: void, hero: any) => boolean) => any;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any;
};
const { getGameDifficulty, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getGameDifficulty: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 通用物品技能槽位配置表 } = require('系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置') as {
  通用物品技能槽位配置表: Array<{ 技能ID: string }>;
};
const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 杀戮食人魔单位类型ID = stringToFourCCSafe(杀戮食人魔单位技能配置.单位ID);
const 深渊魔咒技能ID = stringToFourCCSafe(杀戮食人魔单位技能配置.技能ID.深渊魔咒);
const 深渊魔咒来源表: Record<number, any | undefined> = {};
let 深渊魔咒已注册 = false;
let 深渊魔咒全局监听已注册 = false;

interface 深渊魔咒施加数据 {
  Boss单位: any;
  目标单位: any;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 取深渊魔咒目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位存活(spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss);
}

function 深渊魔咒动作结束(this: void): void {
}

function on施加深渊魔咒(this: void, variable?: any): void {
  const data = variable as 深渊魔咒施加数据 | undefined;
  if (data == null) return;
  if (!单位存活(data.Boss单位) || !单位存活(data.目标单位)) return;
  const cfg = 杀戮食人魔技能配置.深渊魔咒;
  const playerCount = 取当前有效玩家人数();
  const duration = (playerCount <= 1 ? cfg.单人基础持续秒 : cfg.多人基础持续秒) + playerCount * cfg.每名玩家增加秒;
  const targetImmune = 单位是否免疫负面效果BuffID(data.目标单位, 食人魔BuffID.深渊魔咒);
  深渊魔咒来源表[GetHandleId(data.目标单位)] = data.Boss单位;
  registerManualBuff(data.目标单位, 食人魔BuffID.深渊魔咒, duration, 1, {
    sourceUnit: data.Boss单位,
    sourceName: '杀戮食人魔-深渊魔咒',
  });
  const runtime = getBuffRuntime(data.目标单位, 食人魔BuffID.深渊魔咒);
  播放Boss坐标音效(杀戮食人魔音效配置.深渊魔咒.生效, GetUnitX(data.目标单位), GetUnitY(data.目标单位), 杀戮食人魔音效配置.默认裁断距离);
  debugLogForce('杀戮食人魔-深渊魔咒', '诅咒Buff施加诊断', 'bossHid=', GetHandleId(data.Boss单位), 'targetHid=', GetHandleId(data.目标单位), 'targetTypeId=', GetUnitTypeId(data.目标单位), 'targetImmune=', targetImmune, 'runtimeExists=', runtime != null, 'remaining=', runtime?.remaining ?? 0);
}

function 取随机转移目标(this: void, boss: any, cursedHero: any): any {
  if (取当前有效玩家人数() <= 1) return cursedHero;
  const receiver = 获取Boss技能随机敌对英雄(boss, undefined, undefined, [cursedHero], 允许诅咒转移目标);
  return receiver ?? cursedHero;
}

function 允许诅咒转移目标(this: void, hero: any): boolean {
  return 单位存活(hero) && getRegisteredPlayerHero(GetOwningPlayer(hero)) === hero;
}

function 是物品技能(this: void, 技能ID: number): boolean {
  for (let i = 0; i < 通用物品技能槽位配置表.length; i++) {
    if (stringToFourCCSafe(通用物品技能槽位配置表[i].技能ID) === 技能ID) return true;
  }
  return false;
}

function on深渊魔咒目标施法(this: void, castingUnit: any, _spellAbilityId: number): void {
  if (!单位存活(castingUnit)) return;
  if (是物品技能(_spellAbilityId)) return;
  const castingHid = GetHandleId(castingUnit);
  const boss = 深渊魔咒来源表[castingHid];
  if (boss == null) return;
  const runtime = getBuffRuntime(castingUnit, 食人魔BuffID.深渊魔咒);
  debugLogForce('杀戮食人魔-深渊魔咒', '诅咒目标技能生效诊断', 'castingHid=', castingHid, 'castingTypeId=', GetUnitTypeId(castingUnit), 'abilityId=', _spellAbilityId, 'runtimeExists=', runtime != null, 'bossHid=', GetHandleId(boss));
  if (runtime == null) return;
  if (!单位存活(boss) || GetUnitTypeId(boss) !== 杀戮食人魔单位类型ID) {
    debugLogForce('杀戮食人魔-深渊魔咒', '施法反噬跳过：Boss来源无效', 'bossAlive=', 单位存活(boss), 'bossTypeId=', 单位存活(boss) ? GetUnitTypeId(boss) : 0);
    return;
  }
  const cfg = 杀戮食人魔技能配置.深渊魔咒;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const damage = GetUnitStateJapi(castingUnit, UNIT_STATE_MAX_LIFE) * (cfg.最大生命基础比例 + cfg.最大生命每层难度比例 * difficulty)
    + 读取单位攻击力(castingUnit) * (cfg.攻击力基础比例 + cfg.攻击力每层难度比例 * difficulty);
  const receiver = 取随机转移目标(boss, castingUnit);
  if (!单位存活(receiver)) return;
  EC_CreateEffect(cfg.反噬特效, GetUnitX(receiver), GetUnitY(receiver), 0, 270, 3, 1, 1);
  提交预计算Boss单体技能伤害({
    来源: boss,
    目标: receiver,
    伤害: damage,
    技能ID: 深渊魔咒技能ID,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '杀戮食人魔·深渊魔咒施法反噬',
  });
}

function 深渊魔咒治疗修正(this: void, _source: any, target: any, amount: number, isItemHeal: boolean): number {
  if (!(amount > 0) || isItemHeal || !单位存活(target) || getBuffRuntime(target, 食人魔BuffID.深渊魔咒) == null) return amount;
  const boss = 深渊魔咒来源表[GetHandleId(target)];
  if (!单位存活(boss) || GetUnitTypeId(boss) !== 杀戮食人魔单位类型ID) return amount;
  const cfg = 杀戮食人魔技能配置.深渊魔咒;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const damage = amount * (cfg.治疗反噬基础比例 + cfg.治疗反噬每层难度比例 * difficulty);
  EC_CreateEffect(cfg.反噬特效, GetUnitX(target), GetUnitY(target), 0, 270, 3, 1, 1);
  提交预计算Boss单体技能伤害({
    来源: boss,
    目标: target,
    伤害: damage,
    技能ID: 深渊魔咒技能ID,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '杀戮食人魔·深渊魔咒治疗反噬',
  });
  return 0;
}

export function 释放杀戮食人魔深渊魔咒(this: void, context: 杀戮食人魔运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位存活(boss)) return false;
  const target = 取深渊魔咒目标(boss);
  if (!单位存活(target)) return false;
  EC_CreateEffect(杀戮食人魔技能配置.深渊魔咒.生效特效, GetUnitX(target), GetUnitY(target), 0, 270, 2, 1, 1.5);
  启动基础施法时间线({
    名称: '杀戮食人魔-深渊魔咒动作',
    施法者: boss,
    目标单位: target,
    硬直秒: 0.7,
    动画编号: 5,
    恢复动画编号: 1,
    吟唱条: {
      通道: '常规技能',
      总时长: 0.7,
      颜色ID: 1,
      标题文本: '深渊魔咒',
      提示文本: '治疗与施法将遭到反噬',
    },
    on生效: 深渊魔咒动作结束,
  });
  addDelayedCallback(杀戮食人魔技能配置.深渊魔咒.生效延迟秒 * 1000, on施加深渊魔咒, {
    Boss单位: boss,
    目标单位: target,
  } as 深渊魔咒施加数据);
  return true;
}

function on深渊魔咒技能壳释放(this: void, context: 杀戮食人魔运行时上下文): void {
  释放杀戮食人魔深渊魔咒(context);
}

export function 注册杀戮食人魔深渊魔咒(this: void): void {
  if (!深渊魔咒全局监听已注册) {
    深渊魔咒全局监听已注册 = true;
    registerSpellEffectListener(on深渊魔咒目标施法);
    registerHealCallback(深渊魔咒治疗修正);
  }
  if (深渊魔咒已注册) {
    return;
  }
  深渊魔咒已注册 = true;
  注册单位技能壳监听({
    名称: '杀戮食人魔-深渊魔咒',
    单位类型ID: 杀戮食人魔单位类型ID,
    技能ID: 深渊魔咒技能ID,
    获取或创建上下文: 获取或创建杀戮食人魔上下文,
    释放技能: on深渊魔咒技能壳释放,
    技能实例持续时间秒: 10,
  });
}
