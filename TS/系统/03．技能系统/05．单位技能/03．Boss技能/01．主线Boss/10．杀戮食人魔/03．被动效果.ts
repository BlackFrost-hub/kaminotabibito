/** @noSelfInFile */

import { 创建条件伤害修正 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正';
import { 提交预计算BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 杀戮食人魔单位技能配置 } from './00．配置';
import { 获取全部杀戮食人魔上下文, 获取或创建杀戮食人魔上下文, type 杀戮食人魔运行时上下文 } from './01．运行时上下文';
import { 杀戮食人魔技能配置, 杀戮食人魔音效配置 } from './02．数值与表现配置';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 极坐标X, 极坐标Y } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

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
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any | null;
};
const { 清除单位控制类负面Buff, 清除单位控制Buff合集 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  清除单位控制类负面Buff: (this: void, unit: any, onlyPurgeable?: boolean) => number;
  清除单位控制Buff合集: (this: void, unit: any) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 播放限时单位动画 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待') as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const { 执行战斗自身传送到坐标 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制') as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { getGameDifficulty, getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getGameDifficulty: (this: void) => number;
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 技能_设置技能冷却时间 } = require('平台扩展API动作') as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能最大冷却时间 } = require('平台扩展API取值') as {
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
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
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, animationIndex: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 杀戮食人魔单位类型ID = stringToFourCCSafe(杀戮食人魔单位技能配置.单位ID);
const 普通食人魔单位类型ID = stringToFourCCSafe('N05J');
const 血海绞杀技能ID = stringToFourCCSafe(杀戮食人魔单位技能配置.技能ID.血海绞杀);
let 杀戮食人魔被动已注册 = false;
let 食人魔心脏掌握已注册 = false;

interface 增伤层到期数据 {
  上下文: 杀戮食人魔运行时上下文;
  层ID: number;
}

interface 心脏掌握数据 {
  上下文: 杀戮食人魔运行时上下文;
  目标单位: any;
  已结束: boolean;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? GetHandleId(handle) : 0;
}

function 更新疼痛复仇Buff(this: void, context: 杀戮食人魔运行时上下文): void {
  const count = context.增伤层列表.length;
  if (count <= 0) {
    移除单位指定Buff(context.Boss单位, 食人魔BuffID.疼痛复仇);
    return;
  }
  let latest = 0;
  for (let i = 0; i < context.增伤层列表.length; i++) {
    const expire = context.增伤层列表[i].到期毫秒;
    if (expire > latest) latest = expire;
  }
  const remaining = (latest - getServerTime()) / 1000;
  registerManualBuff(context.Boss单位, 食人魔BuffID.疼痛复仇, remaining > 0 ? remaining : 0.1, count * 杀戮食人魔技能配置.疼痛复仇.增伤比例, {
    stack: count,
    sourceUnit: context.Boss单位,
    sourceName: '杀戮食人魔-疼痛复仇',
  });
}

function on疼痛复仇增伤层到期(this: void, variable?: any): void {
  const data = variable as 增伤层到期数据 | undefined;
  if (data == null) return;
  const list = data.上下文.增伤层列表;
  for (let i = 0; i < list.length; i++) {
    if (list[i].ID !== data.层ID) continue;
    list.splice(i, 1);
    break;
  }
  更新疼痛复仇Buff(data.上下文);
}

function 添加疼痛复仇增伤层(this: void, context: 杀戮食人魔运行时上下文): void {
  const cfg = 杀戮食人魔技能配置.疼痛复仇;
  const id = context.下一增伤层ID++;
  context.增伤层列表.push({ ID: id, 到期毫秒: getServerTime() + cfg.增伤持续秒 * 1000 });
  更新疼痛复仇Buff(context);
  addDelayedCallback(cfg.增伤持续秒 * 1000, on疼痛复仇增伤层到期, { 上下文: context, 层ID: id } as 增伤层到期数据);
}

function 触发疼痛复仇解控(this: void, context: 杀戮食人魔运行时上下文): void {
  const boss = context.Boss单位;
  清除单位控制类负面Buff(boss, false);
  清除单位控制Buff合集(boss);
  const configuredMaxCooldown = 杀戮食人魔技能配置.血海绞杀.冷却秒;
  const currentMaxCooldown = 技能_获取技能最大冷却时间(boss, 血海绞杀技能ID) || configuredMaxCooldown;
  技能_设置技能冷却时间(boss, 血海绞杀技能ID, 0, currentMaxCooldown);
  EC_CreateEffect(杀戮食人魔技能配置.疼痛复仇.解控特效, GetUnitX(boss), GetUnitY(boss), 0, 270, 2.5, 1, 1);
  播放Boss坐标音效(杀戮食人魔音效配置.疼痛复仇.解控, GetUnitX(boss), GetUnitY(boss), 杀戮食人魔音效配置.默认裁断距离);
}

function on杀戮食人魔受到最终伤害(this: void, target: any, _attacker: any, applied: number, _snapshot: any): void {
  if (!(applied > 0) || !单位存活(target) || GetUnitTypeId(target) !== 杀戮食人魔单位类型ID) return;
  const context = 获取或创建杀戮食人魔上下文(target);
  if (context == null) return;
  const cfg = 杀戮食人魔技能配置.疼痛复仇;
  context.增伤累计伤害 += applied;
  while (context.增伤累计伤害 >= cfg.增伤触发伤害) {
    context.增伤累计伤害 -= cfg.增伤触发伤害;
    添加疼痛复仇增伤层(context);
  }
  context.解控累计伤害 += applied;
  while (context.解控累计伤害 >= cfg.解控触发伤害) {
    context.解控累计伤害 -= cfg.解控触发伤害;
    触发疼痛复仇解控(context);
  }
}

function 疼痛复仇伤害条件(this: void, damageContext: any): boolean {
  return damageContext != null && 单位存活(damageContext.attacker) && GetUnitTypeId(damageContext.attacker) === 杀戮食人魔单位类型ID;
}

function 疼痛复仇伤害修正(this: void, damageContext: any): number {
  const list = 获取全部杀戮食人魔上下文();
  for (let i = 0; i < list.length; i++) {
    const context = list[i];
    if (context.Boss单位 !== damageContext.attacker) continue;
    const 修正后伤害 = damageContext.currentDamage * (1 + context.增伤层列表.length * 杀戮食人魔技能配置.疼痛复仇.增伤比例);
    return 修正后伤害;
  }
  return damageContext.currentDamage;
}

function 是注册玩家英雄(this: void, unit: any): boolean {
  if (!单位存活(unit)) return false;
  const owner = GetOwningPlayer(unit);
  return (owner != null && owner !== 0 && getRegisteredPlayerHero(owner) === unit)
    || 是否已登记Boss技能测试目标(unit);
}

function 取心脏掌握动作编号(this: void, boss: any): number {
  const cfg = 杀戮食人魔技能配置.心脏掌握;
  return GetUnitTypeId(boss) === 普通食人魔单位类型ID ? cfg.普通状态动作编号 : cfg.动作编号;
}

function 生成心脏掌握动作重播时点(this: void, 持续秒: number, 间隔秒: number): number[] {
  const result: number[] = [];
  if (!(间隔秒 > 0)) return result;
  for (let 时点秒 = 间隔秒; 时点秒 < 持续秒; 时点秒 += 间隔秒) {
    result.push(时点秒);
  }
  return result;
}

function 清理心脏掌握表现(this: void, data: 心脏掌握数据): void {
  if (data.已结束) return;
  data.已结束 = true;
  移除单位指定Buff(data.目标单位, 食人魔BuffID.心脏掌握);
  关闭吟唱条('常规技能');
  if (单位存活(data.上下文.Boss单位)) SetUnitAnimationByIndex(data.上下文.Boss单位, 1);
}

function on心脏掌握上下文清理(this: void, variable?: any): void {
  const data = variable as 心脏掌握数据 | undefined;
  if (data == null) return;
  清理心脏掌握表现(data);
}

function on心脏掌握第二段预警(this: void, variable?: any): void {
  const data = variable as 心脏掌握数据 | undefined;
  if (data == null || data.已结束) return;
  if (!单位存活(data.上下文.Boss单位) || !单位存活(data.目标单位)) {
    清理心脏掌握表现(data);
    debugLogForce('杀戮食人魔-心脏掌握', '第二段预警跳过：Boss或目标已失效', 'bossHid=', 取句柄ID(data.上下文.Boss单位), 'targetHid=', 取句柄ID(data.目标单位));
    return;
  }
  const cfg = 杀戮食人魔技能配置.心脏掌握;
  EC_CreateEffect(cfg.第二段预警特效, GetUnitX(data.目标单位), GetUnitY(data.目标单位), 0, 270, 1.5, 1, 1);
  debugLogForce('杀戮食人魔-心脏掌握', '第二段预警特效', 'targetHid=', 取句柄ID(data.目标单位));
}

function on心脏掌握结算(this: void, variable?: any): void {
  const data = variable as 心脏掌握数据 | undefined;
  if (data == null || data.已结束) return;
  if (!单位存活(data.上下文.Boss单位) || !单位存活(data.目标单位)) {
    清理心脏掌握表现(data);
    debugLogForce('杀戮食人魔-心脏掌握', '斩杀结算跳过：Boss或目标已失效', 'bossHid=', 取句柄ID(data.上下文.Boss单位), 'targetHid=', 取句柄ID(data.目标单位));
    return;
  }

  const boss = data.上下文.Boss单位;
  const target = data.目标单位;
  const cfg = 杀戮食人魔技能配置.心脏掌握;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const participants: any[] = [];
  const radiusSquared = cfg.分摊范围 * cfg.分摊范围;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位存活(hero)) continue;
    const dx = GetUnitX(hero) - GetUnitX(target);
    const dy = GetUnitY(hero) - GetUnitY(target);
    if (dx * dx + dy * dy <= radiusSquared) participants.push(hero);
  }
  if (participants.length === 0) participants.push(target);

  const totalDamage = GetUnitState(target, UNIT_STATE_LIFE) * cfg.当前生命伤害比例;
  const sharedDamage = totalDamage / participants.length;
  EC_CreateEffect(cfg.结算特效, GetUnitX(target), GetUnitY(target), 0, 270, 2, 1, 1.5);
  清理心脏掌握表现(data);
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
      标签: '杀戮食人魔·心脏掌握',
    });
  }
  debugLogForce('杀戮食人魔-心脏掌握', '斩杀结算完成', 'bossHid=', 取句柄ID(boss), 'targetHid=', 取句柄ID(target), 'participantCount=', participants.length, 'currentLifeBefore=', totalDamage / cfg.当前生命伤害比例, 'totalDamage=', totalDamage, 'sharedDamage=', sharedDamage);
}

function 尝试触发心脏掌握(this: void, boss: any, target: any): void {
  if (!是注册玩家英雄(target)) return;
  const context = 获取或创建杀戮食人魔上下文(boss);
  if (context == null) return;
  const 当前毫秒 = getServerTime();
  if (当前毫秒 < context.心脏掌握冷却结束毫秒) return;

  const cfg = 杀戮食人魔技能配置.心脏掌握;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  let threshold = cfg.基础斩杀线比例 + cfg.每层难度斩杀线比例 * difficulty;
  if (取当前有效玩家人数() <= 1) threshold *= cfg.单人斩杀线倍率;
  const 当前生命 = GetUnitState(target, UNIT_STATE_LIFE);
  const 最大生命 = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (当前生命 > 最大生命 * threshold) return;

  context.心脏掌握冷却结束毫秒 = 当前毫秒 + cfg.冷却秒 * 1000;
  const data: 心脏掌握数据 = { 上下文: context, 目标单位: target, 已结束: false };
  const 目标背后角度 = GetUnitFacing(target) + 180;
  const teleportSuccess = 执行战斗自身传送到坐标(
    boss,
    极坐标X(GetUnitX(target), 目标背后角度, cfg.瞬移距离),
    极坐标Y(GetUnitY(target), 目标背后角度, cfg.瞬移距离),
  );

  registerManualBuff(target, 食人魔BuffID.心脏掌握, cfg.预警秒, 1, { sourceUnit: boss, sourceName: '杀戮食人魔-心脏掌握' });
  EC_CreateEffect(cfg.第一段预警特效, GetUnitX(target), GetUnitY(target), 0, 270, 1.5, 1, 2);
  开始硬直(target, cfg.预警秒);
  开始硬直(boss, cfg.预警秒);
  显示常规技能吟唱条({
    通道: '常规技能',
    总时长: cfg.预警秒,
    颜色ID: cfg.吟唱条颜色ID,
    标题文本: cfg.吟唱条标题文本,
    提示文本: cfg.吟唱条提示文本,
  });
  播放限时单位动画({
    单位: boss,
    动画编号: 取心脏掌握动作编号(boss),
    持续秒: cfg.预警秒,
    重播时点秒列表: 生成心脏掌握动作重播时点(cfg.预警秒, cfg.动作重播间隔秒),
    恢复动画编号: 1,
  });

  const 第二段回调ID = addDelayedCallback(cfg.第二段预警秒 * 1000, on心脏掌握第二段预警, data);
  const 结算回调ID = addDelayedCallback(cfg.预警秒 * 1000, on心脏掌握结算, data);
  context.清理.登记清理('杀戮食人魔-心脏掌握表现', on心脏掌握上下文清理, data);
  context.清理.登记延迟回调('杀戮食人魔-心脏掌握第二段预警', 第二段回调ID);
  context.清理.登记延迟回调('杀戮食人魔-心脏掌握结算', 结算回调ID);
  debugLogForce('杀戮食人魔-心脏掌握', '触发预警表现', 'bossHid=', 取句柄ID(boss), 'targetHid=', 取句柄ID(target), 'difficulty=', difficulty, 'threshold=', threshold, 'currentLife=', 当前生命, 'maxLife=', 最大生命, 'teleportSuccess=', teleportSuccess, 'targetHardStunSeconds=', cfg.预警秒, 'bossHardStunSeconds=', cfg.预警秒, 'animationIndex=', 取心脏掌握动作编号(boss), 'actionReplayIntervalSeconds=', cfg.动作重播间隔秒, 'secondWarningCallbackId=', 第二段回调ID, 'resolveCallbackId=', 结算回调ID);
}

function on食人魔造成最终伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (!(applied > 0) || !单位存活(attacker)) return;
  const attackerTypeId = GetUnitTypeId(attacker);
  if (attackerTypeId !== 杀戮食人魔单位类型ID && attackerTypeId !== 普通食人魔单位类型ID) return;
  尝试触发心脏掌握(attacker, target);
}

export function 注册食人魔心脏掌握(this: void): void {
  if (食人魔心脏掌握已注册) return;
  食人魔心脏掌握已注册 = true;
  registerAppliedFinalDamageListener(on食人魔造成最终伤害);
}

export function 注册杀戮食人魔被动效果(this: void): void {
  if (杀戮食人魔被动已注册) {
    debugLogForce('杀戮食人魔-被动', '重复注册请求已忽略');
    return;
  }
  杀戮食人魔被动已注册 = true;
  registerAppliedFinalDamageListener(on杀戮食人魔受到最终伤害);
  创建条件伤害修正({
    名称: '杀戮食人魔-疼痛复仇增伤',
    优先级: 60,
    条件: 疼痛复仇伤害条件,
    修正: 疼痛复仇伤害修正,
  });
}
