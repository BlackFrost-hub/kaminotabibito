/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 两点方向角, 单位是否在来源正面扇区, 单位是否在来源背后扇区 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/08．方位判定工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, value: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, attachPoint: string) => any;
const AddLightning = jass.AddLightning as (codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const DestroyLightning = jass.DestroyLightning as (whichLightning: any) => boolean;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 创建线段危险区 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区") as {
  创建线段危险区: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { createTimedEffect, 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  创建点特效: (this: void, 参数: any) => any;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

interface 消耗反击状态 {
  Boss: any;
  上下文: 树魔首领运行时上下文;
  到期Ms: number;
  动画回调ID: number;
  结束回调ID: number;
  特效回调ID: number;
}

const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 消耗反击技能ID = stringToFourCC(树魔首领数值与表现配置.消耗反击.技能槽位);
const 消耗反击状态表: Record<number, 消耗反击状态 | undefined> = {};
let 消耗反击已注册 = false;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取方向角(this: void, from: any, to: any): number {
  return 两点方向角(GetUnitX(from), GetUnitY(from), GetUnitX(to), GetUnitY(to));
}

function 是背后破招角度(this: void, boss: any, attacker: any): boolean {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  return 单位是否在来源背后扇区(boss, attacker, cfg.背后判定角度);
}

function 是正面反击角度(this: void, boss: any, attacker: any): boolean {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  return 单位是否在来源正面扇区(boss, attacker, cfg.正面判定角度);
}

function 设置魔法值下限(this: void, unit: any, value: number): void {
  SetUnitState(unit, UNIT_STATE_MANA, value > 0 ? value : 0);
}

function 清除消耗反击状态(this: void, boss: any): void {
  const hid = GetHandleId(boss) || 0;
  const state = 消耗反击状态表[hid];
  if (state == null) return;
  if (state.动画回调ID !== 0) removePeriodicCallback(state.动画回调ID);
  if (state.特效回调ID !== 0) removePeriodicCallback(state.特效回调ID);
  if (state.结束回调ID !== 0) removeDelayedCallback(state.结束回调ID);
  delete 消耗反击状态表[hid];
  if (单位有效(boss)) SetUnitTimeScale(boss, 1);
}

function 播放防御姿态特效(this: void, boss: any): void {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  createTimedEffect(cfg.防御特效路径, GetUnitX(boss), GetUnitY(boss), 0, cfg.防御特效持续秒);
}

function 播放抽魔特效(this: void, target: any): void {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  const effect = AddSpecialEffectTarget(cfg.抽魔特效路径, target, "origin");
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1, effect);
}

function 播放反击连线(this: void, boss: any, target: any): void {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  const lightning = AddLightning(cfg.抽魔连线代码, false, GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target));
  if (lightning == null || lightning === 0) return;
  addDelayedCallback(600, function 树魔首领消耗反击销毁连线(this: void): void {
    DestroyLightning(lightning);
  });
}

function 创建反击弹道表现(this: void, boss: any, angle: number): void {
  const cfg = 树魔首领数值与表现配置.消耗反击;
  const x = GetUnitX(boss) + CosBJ(angle) * 160;
  const y = GetUnitY(boss) + SinBJ(angle) * 160;
  创建点特效({
    模型路径: cfg.反击弹道特效路径,
    X: x,
    Y: y,
    Z: 0,
    持续秒: cfg.反击弹道特效持续秒,
  });
}

function 执行反击(this: void, state: 消耗反击状态, attacker: any, 触发伤害: number): void {
  const boss = state.Boss;
  if (!单位有效(boss) || !单位有效(attacker)) return;
  const cfg = 树魔首领数值与表现配置.消耗反击;
  const angle = 取方向角(boss, attacker);
  SetUnitFacing(boss, angle);
  SetUnitAnimationByIndex(boss, 4);
  创建反击弹道表现(boss, angle);
  播放抽魔特效(attacker);
  播放反击连线(boss, attacker);
  设置魔法值下限(attacker, GetUnitState(attacker, UNIT_STATE_MANA) - 触发伤害 * cfg.抽魔伤害比例);

  创建线段危险区({
    清理: state.上下文.清理,
    名称: "树魔首领-消耗反击冲击波",
    起点X: GetUnitX(boss),
    起点Y: GetUnitY(boss),
    方向角: angle,
    长度: cfg.反击射程,
    宽度: cfg.反击宽度,
    持续秒: cfg.反击持续秒,
    Tick间隔毫秒: cfg.反击Tick毫秒,
    单位列表: function 取消耗反击候选单位(this: void): any[] {
      return 获取Boss技能敌对英雄列表(boss);
    },
    提示圈: false,
    on进入: function 树魔首领消耗反击命中(this: void, unit: any): void {
      if (!单位有效(unit)) return;
      const damage = 读取单位攻击力(boss) * cfg.反击Boss攻击力比例;
      UnitDamageTarget(boss, unit, damage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_METAL_HEAVY_SLICE);
    },
  });
}

export function 释放树魔首领消耗反击(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.消耗反击;
  const hid = GetHandleId(boss) || 0;
  if (hid === 0) return;
  清除消耗反击状态(boss);

  播放树魔首领台词(boss, "消耗反击");
  开始硬直(boss, cfg.持续秒);
  SetUnitTimeScale(boss, cfg.动画速度);
  SetUnitAnimationByIndex(boss, cfg.动画编号);
  播放防御姿态特效(boss);

  const state: 消耗反击状态 = {
    Boss: boss,
    上下文: context,
    到期Ms: getServerTime() + cfg.持续秒 * 1000,
    动画回调ID: 0,
    结束回调ID: 0,
    特效回调ID: 0,
  };
  state.动画回调ID = addPeriodicCallback(cfg.动画重播间隔毫秒, function 树魔首领消耗反击动作Tick(this: void): void {
    if (!单位有效(boss) || getServerTime() >= state.到期Ms) return;
    SetUnitAnimationByIndex(boss, cfg.动画编号);
  });
  state.特效回调ID = addPeriodicCallback(cfg.防御特效刷新毫秒, function 树魔首领消耗反击防御特效Tick(this: void): void {
    if (!单位有效(boss) || getServerTime() >= state.到期Ms) return;
    播放防御姿态特效(boss);
  });
  state.结束回调ID = addDelayedCallback(cfg.持续秒 * 1000, function 树魔首领消耗反击自然结束(this: void): void {
    清除消耗反击状态(boss);
  });
  消耗反击状态表[hid] = state;
}

function 树魔首领消耗反击伤害修正(this: void, damageContext: any): number {
  const target = damageContext.target;
  const attacker = damageContext.attacker;
  if (!单位有效(target) || !单位有效(attacker)) return damageContext.currentDamage;
  if (GetUnitTypeId(target) !== 树魔首领单位类型ID) return damageContext.currentDamage;
  const state = 消耗反击状态表[GetHandleId(target) || 0];
  if (state == null) return damageContext.currentDamage;
  if (getServerTime() >= state.到期Ms) {
    清除消耗反击状态(target);
    return damageContext.currentDamage;
  }

  const cfg = 树魔首领数值与表现配置.消耗反击;
  if (是背后破招角度(target, attacker)) {
    清除消耗反击状态(target);
    开始硬直(target, cfg.硬直秒);
    return damageContext.currentDamage * (1 + cfg.背后增伤比例);
  }

  if (!是正面反击角度(target, attacker)) return damageContext.currentDamage;

  清除消耗反击状态(target);
  执行反击(state, attacker, damageContext.currentDamage);
  return damageContext.currentDamage * (1 - cfg.正面减伤比例);
}

export function 注册树魔首领消耗反击(this: void): void {
  if (消耗反击已注册) return;
  消耗反击已注册 = true;
  注册Boss技能壳监听({
    名称: "树魔首领-消耗反击",
    Boss单位类型ID: 树魔首领单位类型ID,
    技能ID: 消耗反击技能ID,
    获取或创建上下文: 获取或创建树魔首领上下文,
    释放技能: function 树魔首领消耗反击监听释放(this: void, _context: 树魔首领运行时上下文, boss: any): void {
      on树魔首领消耗反击生效(boss, 消耗反击技能ID);
    },
  });
  registerDamageModifier(树魔首领消耗反击伤害修正, 65);
}

function on树魔首领消耗反击生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 消耗反击技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 树魔首领单位类型ID) return;
  const context = 获取或创建树魔首领上下文(castingUnit);
  if (context == null) return;
  释放树魔首领消耗反击(context);
}
