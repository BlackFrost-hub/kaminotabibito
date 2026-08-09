/** @noSelfInFile */

import { 沙漠食人魔单位技能配置 } from './00．配置';
import { 沙漠食人魔技能配置 } from './02．数值与表现配置';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 提交预计算Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerManualBuff, getBuffRuntime } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
};
const { 单位是否免疫负面效果BuffID } = require('系统.05．Buff系统.06．负面效果免疫状态') as {
  单位是否免疫负面效果BuffID: (this: void, unit: any, buffID: string) => boolean;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
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
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 沙漠食人魔单位类型ID = stringToFourCCSafe(沙漠食人魔单位技能配置.单位ID);
const 食人魔咒技能ID = stringToFourCCSafe(沙漠食人魔单位技能配置.技能ID.食人魔咒);
const 食人魔咒来源表: Record<number, any | undefined> = {};
let 食人魔咒已注册 = false;
let 食人魔咒施法监听已注册 = false;

interface 食人魔咒施加数据 {
  Boss单位: any;
  目标单位: any;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 获取沙漠食人魔技能上下文(this: void, boss: any): any | undefined {
  return 单位存活(boss) ? boss : undefined;
}

function 取食人魔咒目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位存活(spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss);
}

function 食人魔咒动作结束(this: void): void {}

function on施加食人魔咒(this: void, variable?: any): void {
  const data = variable as 食人魔咒施加数据 | undefined;
  if (data == null) {
    debugLogForce('沙漠食人魔-食人魔咒', '延迟生效跳过', 'reason=data为空');
    return;
  }
  if (!单位存活(data.Boss单位) || !单位存活(data.目标单位)) {
    debugLogForce('沙漠食人魔-食人魔咒', '延迟生效跳过', 'bossAlive=', 单位存活(data.Boss单位), 'targetAlive=', 单位存活(data.目标单位), 'bossHid=', data.Boss单位 != null ? GetHandleId(data.Boss单位) : 0, 'targetHid=', data.目标单位 != null ? GetHandleId(data.目标单位) : 0);
    return;
  }
  const cfg = 沙漠食人魔技能配置.食人魔咒;
  const playerCount = 取当前有效玩家人数();
  const duration = (playerCount <= 1 ? cfg.单人基础持续秒 : cfg.多人基础持续秒) + playerCount * cfg.每名玩家增加秒;
  const targetImmune = 单位是否免疫负面效果BuffID(data.目标单位, 食人魔BuffID.食人魔咒);
  食人魔咒来源表[GetHandleId(data.目标单位)] = data.Boss单位;
  registerManualBuff(data.目标单位, 食人魔BuffID.食人魔咒, duration, 1, {
    sourceUnit: data.Boss单位,
    sourceName: '沙漠食人魔-食人魔咒',
  });
  const runtime = getBuffRuntime(data.目标单位, 食人魔BuffID.食人魔咒);
  debugLogForce('沙漠食人魔-食人魔咒', '诅咒Buff施加诊断', 'bossHid=', GetHandleId(data.Boss单位), 'targetHid=', GetHandleId(data.目标单位), 'targetTypeId=', GetUnitTypeId(data.目标单位), 'targetImmune=', targetImmune, 'runtimeExists=', runtime != null, 'remaining=', runtime?.remaining ?? 0);
  debugLogForce('沙漠食人魔-食人魔咒', '诅咒已施加', 'bossHid=', GetHandleId(data.Boss单位), 'targetHid=', GetHandleId(data.目标单位), 'playerCount=', playerCount, 'duration=', duration);
}

function 取随机转移目标(this: void, boss: any, cursedHero: any): any {
  if (取当前有效玩家人数() <= 1) return cursedHero;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const candidates: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (hero !== cursedHero && 单位存活(hero) && getRegisteredPlayerHero(GetOwningPlayer(hero)) === hero) candidates.push(hero);
  }
  if (candidates.length === 0) return cursedHero;
  return candidates[GetRandomInt(0, candidates.length - 1)];
}

function 是物品技能(this: void, 技能ID: number): boolean {
  for (let i = 0; i < 通用物品技能槽位配置表.length; i++) {
    if (stringToFourCCSafe(通用物品技能槽位配置表[i].技能ID) === 技能ID) return true;
  }
  return false;
}

function on食人魔咒目标施法(this: void, castingUnit: any, _spellAbilityId: number): void {
  if (!单位存活(castingUnit)) return;
  if (是物品技能(_spellAbilityId)) return;
  const castingHid = GetHandleId(castingUnit);
  const boss = 食人魔咒来源表[castingHid];
  if (boss == null) return;
  const runtime = getBuffRuntime(castingUnit, 食人魔BuffID.食人魔咒);
  debugLogForce('沙漠食人魔-食人魔咒', '诅咒目标技能生效诊断', 'castingHid=', castingHid, 'castingTypeId=', GetUnitTypeId(castingUnit), 'abilityId=', _spellAbilityId, 'runtimeExists=', runtime != null, 'bossHid=', GetHandleId(boss));
  if (runtime == null) return;
  if (!单位存活(boss) || GetUnitTypeId(boss) !== 沙漠食人魔单位类型ID) {
    debugLogForce('沙漠食人魔-食人魔咒', '施法反噬跳过：Boss来源无效', 'bossAlive=', 单位存活(boss), 'bossTypeId=', 单位存活(boss) ? GetUnitTypeId(boss) : 0);
    return;
  }
  const cfg = 沙漠食人魔技能配置.食人魔咒;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const damage = GetUnitStateJapi(castingUnit, UNIT_STATE_MAX_LIFE) * (cfg.最大生命基础比例 + cfg.最大生命每层难度比例 * difficulty)
    + 读取单位攻击力(castingUnit) * (cfg.攻击力基础比例 + cfg.攻击力每层难度比例 * difficulty);
  const receiver = 取随机转移目标(boss, castingUnit);
  if (!单位存活(receiver)) {
    debugLogForce('沙漠食人魔-食人魔咒', '施法反噬跳过：转移目标无效', 'cursedHid=', GetHandleId(castingUnit));
    return;
  }
  EC_CreateEffect(cfg.生效特效, GetUnitX(receiver), GetUnitY(receiver), 0, 270, 2, 1, 1.5);
  提交预计算Boss单体技能伤害({
    来源: boss,
    目标: receiver,
    伤害: damage,
    技能ID: 食人魔咒技能ID,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: '沙漠食人魔·食人魔咒反噬',
  });
  debugLogForce('沙漠食人魔-食人魔咒', '技能反噬结算', 'cursedHid=', GetHandleId(castingUnit), 'receiverHid=', GetHandleId(receiver), 'damage=', damage, 'difficulty=', difficulty);
}

export function 释放沙漠食人魔咒(this: void, boss: any): boolean {
  if (!单位存活(boss)) {
    debugLogForce('沙漠食人魔-食人魔咒', '释放拒绝：Boss无效');
    return false;
  }
  const target = 取食人魔咒目标(boss);
  if (!单位存活(target)) {
    debugLogForce('沙漠食人魔-食人魔咒', '释放拒绝：目标无效', 'bossHid=', GetHandleId(boss));
    return false;
  }
  EC_CreateEffect(沙漠食人魔技能配置.食人魔咒.生效特效, GetUnitX(target), GetUnitY(target), 0, 270, 2, 1, 1.5);
  debugLogForce('沙漠食人魔-食人魔咒', '起手目标特效已播放', 'bossHid=', GetHandleId(boss), 'targetHid=', GetHandleId(target));
  debugLogForce('沙漠食人魔-食人魔咒', '施法开始', 'bossHid=', GetHandleId(boss), 'targetHid=', GetHandleId(target), 'applyDelay=', 沙漠食人魔技能配置.食人魔咒.生效延迟秒);
  启动基础施法时间线({
    名称: '沙漠食人魔-食人魔咒动作',
    施法者: boss,
    目标单位: target,
    硬直秒: 0.7,
    动画编号: 5,
    恢复动画编号: 1,
    吟唱条: {
      通道: '常规技能',
      总时长: 0.7,
      颜色ID: 2,
      标题文本: '食人魔咒',
      提示文本: '诅咒即将降临',
    },
    on生效: 食人魔咒动作结束,
  });
  const 延迟回调ID = addDelayedCallback(沙漠食人魔技能配置.食人魔咒.生效延迟秒 * 1000, on施加食人魔咒, {
    Boss单位: boss,
    目标单位: target,
  } as 食人魔咒施加数据);
  debugLogForce('沙漠食人魔-食人魔咒', '延迟生效已登记', 'timerId=', 延迟回调ID, 'delay=', 沙漠食人魔技能配置.食人魔咒.生效延迟秒);
  return true;
}

function on食人魔咒技能壳释放(this: void, _context: any, boss: any): void {
  释放沙漠食人魔咒(boss);
}

export function 注册沙漠食人魔咒(this: void): void {
  if (!食人魔咒施法监听已注册) {
    食人魔咒施法监听已注册 = true;
    registerSpellEffectListener(on食人魔咒目标施法);
  }
  if (食人魔咒已注册) return;
  食人魔咒已注册 = true;
  注册单位技能壳监听({
    名称: '沙漠食人魔-食人魔咒',
    单位类型ID: 沙漠食人魔单位类型ID,
    技能ID: 食人魔咒技能ID,
    获取或创建上下文: 获取沙漠食人魔技能上下文,
    释放技能: on食人魔咒技能壳释放,
    技能实例持续时间秒: 10,
  });
  debugLogForce('沙漠食人魔-食人魔咒', '技能监听注册完成', 'skillId=', 食人魔咒技能ID);
}
