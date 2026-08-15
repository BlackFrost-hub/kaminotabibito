/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getServerTime: (this: void) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { 临时调整攻速, 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻速: (this: void, unit: any, value: number) => void;
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  延后一帧执行伤害派生效果: (this: void, callback: (this: void) => void) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetUnitID = japi.DzSetUnitID as (this: void, unit: any, unitTypeId: number) => void;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const 配置 = 鹿目圆单位技能配置;

interface 圆神状态 {
  英雄: any;
  到期毫秒: number;
  版本: number;
}

interface 圆环强化状态 {
  英雄: any;
  层数: number;
  到期毫秒: number;
  二次可用毫秒: number;
  版本: number;
  W立即满蓄: boolean;
}

interface 因果层状态 {
  来源: any;
  目标: any;
  到期毫秒列表: number[];
  满层下次触发毫秒: number;
}

interface 圆神普攻派生记录 {
  来源: any;
  目标: any;
  伤害: number;
  ranged: boolean;
}

const 圆神状态表: Record<number, 圆神状态 | undefined> = {};
const 圆环强化状态表: Record<number, 圆环强化状态 | undefined> = {};
const 因果层状态表: Record<string, 因果层状态 | undefined> = {};
const 圆神普攻派生队列: 圆神普攻派生记录[] = [];

let 圆神状态版本 = 0;
let 圆环强化版本 = 0;
let 被动层数驱动已注册 = false;
let 共享状态已注册 = false;

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit);
}

function 因果层状态键(this: void, source: any, target: any): string {
  return String(取单位ID(source)) + "#" + String(取单位ID(target));
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 是鹿目圆(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const typeId = GetUnitTypeId(unit);
  return typeId === 配置.单位.普通类型ID || typeId === 配置.单位.圆神类型ID;
}

export function 是鹿目圆圆神(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const state = 圆神状态表[取单位ID(unit)];
  return state != null && state.英雄 === unit && GetUnitTypeId(unit) === 配置.单位.圆神类型ID;
}

export function 鹿目圆伤害无视魔抗(this: void, unit: any): boolean {
  return 是鹿目圆圆神(unit);
}

export function 获取圆神剩余秒(this: void, unit: any): number {
  const state = 圆神状态表[取单位ID(unit)];
  if (state == null || state.英雄 !== unit) return 0;
  const remaining = state.到期毫秒 - getServerTime();
  return remaining > 0 ? remaining / 1000 : 0;
}

function 确保鹿目圆形态技能(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  const 技能 = 配置.技能;
  UnitAddAbility(hero, 技能.Q.类型ID);
  UnitAddAbility(hero, 技能.W蓄力.类型ID);
  UnitAddAbility(hero, 技能.W发射.类型ID);
  UnitAddAbility(hero, 技能.E.类型ID);
  UnitAddAbility(hero, 技能.D.类型ID);
  UnitAddAbility(hero, 技能.圆神入口.类型ID);
  UnitAddAbility(hero, 技能.圆神返回.类型ID);
  UnitAddAbility(hero, 技能.R.类型ID);
}

function 同步圆神技能可用性(this: void, hero: any, 圆神中: boolean): void {
  if (hero == null || hero === 0) return;
  const owner = GetOwningPlayer(hero);
  const 技能 = 配置.技能;
  SetPlayerAbilityAvailable(owner, 技能.圆神入口.类型ID, !圆神中);
  SetPlayerAbilityAvailable(owner, 技能.旧圆神入口.类型ID, !圆神中);
  SetPlayerAbilityAvailable(owner, 技能.圆神返回.类型ID, 圆神中);
  SetPlayerAbilityAvailable(owner, 技能.R.类型ID, 圆神中);
  SetPlayerAbilityAvailable(owner, 技能.W蓄力.类型ID, true);
  SetPlayerAbilityAvailable(owner, 技能.W发射.类型ID, false);
}

function 播放圆神降临表现(this: void, hero: any): void {
  const 特效列表 = 配置.圆神.降临特效;
  for (let i = 0; i < 特效列表.length; i++) {
    createTimedUnitEffect(hero, "origin", 特效列表[i], 配置.圆神.降临特效持续秒);
  }
}

function 圆神状态到期(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const state = 圆神状态表[取单位ID(data.hero)];
  if (state == null || state.版本 !== data.version) return;
  结束鹿目圆圆神(data.hero, "自然到期");
}

export function 进入鹿目圆圆神(this: void, hero: any): boolean {
  if (!单位存活(hero) || GetUnitTypeId(hero) !== 配置.单位.普通类型ID) return false;
  if (是鹿目圆圆神(hero)) return false;

  确保鹿目圆形态技能(hero);
  DzSetUnitID(hero, 配置.单位.圆神类型ID);
  确保鹿目圆形态技能(hero);
  调整玩家属性(hero, "魔法伤害", 配置.圆神.魔法伤害加成);
  移除单位负面Buff(hero, true);
  registerManualBuff(hero, 鹿目圆BuffID.圆神之力, 配置.圆神.持续秒, 配置.圆神.魔法伤害加成, {
    sourceUnit: hero,
    stack: 1,
  });
  同步圆神技能可用性(hero, true);
  播放圆神降临表现(hero);

  const state: 圆神状态 = {
    英雄: hero,
    到期毫秒: getServerTime() + 配置.圆神.持续秒 * 1000,
    版本: ++圆神状态版本,
  };
  圆神状态表[取单位ID(hero)] = state;
  addDelayedCallback(配置.圆神.持续秒 * 1000, 圆神状态到期, { hero, version: state.版本 });
  return true;
}

export function 结束鹿目圆圆神(this: void, hero: any, _原因: string = "结束"): void {
  if (hero == null || hero === 0) return;
  const id = 取单位ID(hero);
  const state = 圆神状态表[id];
  if (state == null && GetUnitTypeId(hero) !== 配置.单位.圆神类型ID) return;

  移除单位指定Buff(hero, 鹿目圆BuffID.圆神之力);
  if (state != null) {
    调整玩家属性(hero, "魔法伤害", -配置.圆神.魔法伤害加成);
    delete 圆神状态表[id];
  }
  if (GetUnitTypeId(hero) === 配置.单位.圆神类型ID) {
    DzSetUnitID(hero, 配置.单位.普通类型ID);
  }
  确保鹿目圆形态技能(hero);
  同步圆神技能可用性(hero, false);
}

function 获取圆神入口上下文(this: void, hero: any): { 英雄: any } | undefined {
  return GetUnitTypeId(hero) === 配置.单位.普通类型ID ? { 英雄: hero } : undefined;
}

function 释放圆神入口(this: void, _context: { 英雄: any }, hero: any): void {
  if (!进入鹿目圆圆神(hero)) return;
  SetUnitAnimation(hero, "spell");
}

function 获取圆神返回上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆圆神(hero) ? { 英雄: hero } : undefined;
}

function 释放圆神返回(this: void, _context: { 英雄: any }, hero: any): void {
  结束鹿目圆圆神(hero, "主动返回");
}

function 刷新圆环强化Buff(this: void, state: 圆环强化状态): void {
  const hero = state.英雄;
  const now = getServerTime();
  const remaining = (state.到期毫秒 - now) / 1000;
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力一次强化);
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力二次强化);
  if (state.层数 <= 0 || !(remaining > 0)) return;
  const buffId = state.层数 >= 2 ? 鹿目圆BuffID.圆环之力二次强化 : 鹿目圆BuffID.圆环之力一次强化;
  registerManualBuff(hero, buffId, remaining, state.层数, {
    sourceUnit: hero,
    stack: state.层数,
  });
}

function 圆环强化到期(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const state = 圆环强化状态表[取单位ID(data.hero)];
  if (state == null || state.版本 !== data.version) return;
  清除鹿目圆圆环强化(data.hero);
}

export function 激活鹿目圆圆环强化(this: void, hero: any): number {
  if (!单位存活(hero) || !是鹿目圆(hero)) return 0;
  const now = getServerTime();
  const id = 取单位ID(hero);
  let state = 圆环强化状态表[id];
  if (state == null || state.到期毫秒 <= now) {
    state = {
      英雄: hero,
      层数: 1,
      到期毫秒: now + 配置.D.持续秒 * 1000,
      二次可用毫秒: now + 配置.D.二次使用等待秒 * 1000,
      版本: ++圆环强化版本,
      W立即满蓄: 是鹿目圆圆神(hero),
    };
    圆环强化状态表[id] = state;
  } else if (state.层数 === 1 && now >= state.二次可用毫秒) {
    state.层数 = 2;
    state.到期毫秒 = now + 配置.D.持续秒 * 1000;
    state.版本 = ++圆环强化版本;
    if (是鹿目圆圆神(hero)) state.W立即满蓄 = true;
  } else {
    return 0;
  }
  刷新圆环强化Buff(state);
  addDelayedCallback(Math.max(1, state.到期毫秒 - now), 圆环强化到期, { hero, version: state.版本 });
  return state.层数;
}

export function 获取鹿目圆圆环强化层数(this: void, hero: any): number {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime()) return 0;
  return state.层数;
}

export function 消耗鹿目圆圆环强化(this: void, hero: any): number {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime()) return 0;
  const layers = state.层数;
  清除鹿目圆圆环强化(hero);
  return layers;
}

export function 消耗鹿目圆W立即满蓄标记(this: void, hero: any): boolean {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime() || state.W立即满蓄 !== true) return false;
  state.W立即满蓄 = false;
  return true;
}

export function 清除鹿目圆圆环强化(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  delete 圆环强化状态表[取单位ID(hero)];
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力一次强化);
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力二次强化);
}

function 刷新因果层Buff(this: void, state: 因果层状态): void {
  const count = state.到期毫秒列表.length;
  if (count <= 0) {
    移除单位指定Buff(state.目标, 鹿目圆BuffID.因果之力);
    return;
  }
  const now = getServerTime();
  let maxExpiry = now;
  for (let i = 0; i < state.到期毫秒列表.length; i++) {
    if (state.到期毫秒列表[i] > maxExpiry) maxExpiry = state.到期毫秒列表[i];
  }
  registerManualBuff(state.目标, 鹿目圆BuffID.因果之力, Math.max(0.1, (maxExpiry - now) / 1000), 配置.被动.每层攻速, {
    sourceUnit: state.来源,
    stack: count,
  });
}

function 触发因果满层(this: void, state: 因果层状态): void {
  const now = getServerTime();
  if (state.到期毫秒列表.length < 配置.被动.最大层数 || now < state.满层下次触发毫秒) return;
  state.满层下次触发毫秒 = now + 配置.被动.满层触发内置冷却秒 * 1000;
  移除单位负面Buff(state.目标, false);
  const maxLife = GetUnitStateJapi(state.目标, UNIT_STATE_MAX_LIFE);
  if (maxLife > 0) {
    doHeal({
      HealSource: state.来源,
      HealTarget: state.目标,
      HealAmount: maxLife * 配置.被动.满层治疗最大生命比例,
      ItemHeal: false,
      HealEffect: true,
      HealShowText: true,
    });
  }
}

export function 鹿目圆治疗友军(this: void, source: any, target: any, life: number, mana: number = 0, 叠加因果: boolean = true): number {
  if (!单位存活(source) || !单位存活(target)) return 0;
  const actual = doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: life,
    HealManaAmount: mana,
    ItemHeal: false,
    HealEffect: life > 0,
    HealShowText: life > 0,
    ManaEffect: mana > 0,
    ManaShowText: mana > 0,
  });
  if (actual > 0 && 叠加因果 && 是鹿目圆(source) && IsUnitAlly(target, GetOwningPlayer(source)) === true) {
    添加鹿目圆因果层(source, target);
  }
  return actual;
}

export function 添加鹿目圆因果层(this: void, source: any, target: any): void {
  if (!单位存活(source) || !单位存活(target)) return;
  const key = 因果层状态键(source, target);
  let state = 因果层状态表[key];
  if (state == null) {
    state = {
      来源: source,
      目标: target,
      到期毫秒列表: [],
      满层下次触发毫秒: 0,
    };
    因果层状态表[key] = state;
  }
  if (state.到期毫秒列表.length < 配置.被动.最大层数) {
    state.到期毫秒列表.push(getServerTime() + 配置.被动.单层持续秒 * 1000);
    临时调整攻速(target, 配置.被动.每层攻速);
  }
  刷新因果层Buff(state);
  触发因果满层(state);
}

function 清理因果层状态(this: void, key: string, state: 因果层状态): void {
  const count = state.到期毫秒列表.length;
  if (count > 0 && state.目标 != null && state.目标 !== 0) {
    临时调整攻速(state.目标, -配置.被动.每层攻速 * count);
  }
  移除单位指定Buff(state.目标, 鹿目圆BuffID.因果之力);
  delete 因果层状态表[key];
}

function 推进鹿目圆因果层(this: void): void {
  const now = getServerTime();
  for (const key in 因果层状态表) {
    const state = 因果层状态表[key];
    if (state == null) continue;
    if (!单位存活(state.来源) || !单位存活(state.目标)) {
      清理因果层状态(key, state);
      continue;
    }
    let removed = 0;
    const kept: number[] = [];
    for (let i = 0; i < state.到期毫秒列表.length; i++) {
      if (state.到期毫秒列表[i] <= now) removed += 1;
      else kept.push(state.到期毫秒列表[i]);
    }
    if (removed > 0) {
      state.到期毫秒列表 = kept;
      临时调整攻速(state.目标, -配置.被动.每层攻速 * removed);
      if (kept.length <= 0) {
        清理因果层状态(key, state);
        continue;
      }
      刷新因果层Buff(state);
    }
  }
}

function 结算圆神普攻派生队列(this: void): void {
  while (圆神普攻派生队列.length > 0) {
    const record = 圆神普攻派生队列.shift();
    if (record == null || !单位存活(record.来源) || !单位存活(record.目标)) continue;
    造成单体技能伤害({
      来源: record.来源,
      目标: record.目标,
      伤害: record.伤害,
      伤害类型: DAMAGE_TYPE_MAGIC,
      attack: true,
      ranged: record.ranged,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "普攻强化",
      技能ID: 配置.技能.圆神入口.类型ID,
      标签: "鹿目圆-圆神魔法普攻",
      参与技能伤害加成: false,
      忽略魔法抗性: true,
    });
  }
}

function 圆神普攻伤害修正(this: void, context: any): number {
  const attacker = context?.attacker;
  if (!是鹿目圆圆神(attacker)) return context?.currentDamage ?? 0;
  if (context?.isNormalAttack !== true || context?.isPhysicalDamage !== true) return context.currentDamage;
  if (context?.isWrappedSkillDamage === true) return context.currentDamage;
  const target = context.target;
  const amount = context.baseDamage;
  if (target == null || target === 0 || !(amount > 0)) return 0;
  圆神普攻派生队列.push({
    来源: attacker,
    目标: target,
    伤害: amount,
    ranged: context.isRangedAttack === true,
  });
  延后一帧执行伤害派生效果(结算圆神普攻派生队列);
  return 0;
}

function 鹿目圆死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!是鹿目圆(dyingUnit)) return;
  结束鹿目圆圆神(dyingUnit, "死亡");
  清除鹿目圆圆环强化(dyingUnit);
  for (const key in 因果层状态表) {
    const state = 因果层状态表[key];
    if (state == null) continue;
    if (state.来源 === dyingUnit || state.目标 === dyingUnit) 清理因果层状态(key, state);
  }
}

export function 注册鹿目圆状态与被动(this: void): void {
  if (共享状态已注册) return;
  共享状态已注册 = true;
  const 技能 = 配置.技能;
  注册单位技能壳监听({
    名称: "鹿目圆-进入圆神",
    单位类型ID: 配置.单位.普通类型ID,
    技能ID: 技能.圆神入口.类型ID,
    获取或创建上下文: 获取圆神入口上下文,
    释放技能: 释放圆神入口,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "鹿目圆-进入圆神（旧入口）",
    单位类型ID: 配置.单位.普通类型ID,
    技能ID: 技能.旧圆神入口.类型ID,
    获取或创建上下文: 获取圆神入口上下文,
    释放技能: 释放圆神入口,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "鹿目圆-结束圆神",
    单位类型ID: 配置.单位.圆神类型ID,
    技能ID: 技能.圆神返回.类型ID,
    获取或创建上下文: 获取圆神返回上下文,
    释放技能: 释放圆神返回,
    创建独立技能实例: false,
  });
  registerDamageModifier(圆神普攻伤害修正, 100);
  registerDeathListener(鹿目圆死亡清理);
  if (!被动层数驱动已注册) {
    被动层数驱动已注册 = true;
    addPeriodicCallback(100, 推进鹿目圆因果层);
  }
}

注册鹿目圆状态与被动();

export {};
