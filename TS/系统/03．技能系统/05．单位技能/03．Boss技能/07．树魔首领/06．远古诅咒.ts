/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.05．树魔首领") as {
  树魔首领BuffID: { 远古诅咒: string };
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};
const { createTimedEffect, 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  创建点特效: (this: void, 参数: any) => any;
};

const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 远古诅咒技能ID = stringToFourCC(树魔首领数值与表现配置.远古诅咒.技能槽位);
let 远古诅咒已注册 = false;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 距离平方XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

function 取有效玩家人数(this: void): number {
  const count = 取当前有效玩家人数();
  return count > 0 ? count : 1;
}

function 取诅咒目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  const highest = 获取Boss技能最高仇恨目标(boss);
  if (highest != null && 单位有效(highest.targetRef)) return highest.targetRef;
  return 获取Boss技能随机敌对英雄(boss);
}

function 启动跟随分摊提示圈(this: void, context: 树魔首领运行时上下文, target: any): void {
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  let elapsed = 0;
  创建技能提示圈({
    类型: "圆形",
    锚点单位: target,
    半径: cfg.分摊半径,
    持续时间: cfg.跟随提示圈刷新毫秒 / 1000 + 0.05,
  });
  const id = addPeriodicCallback(cfg.跟随提示圈刷新毫秒, function 树魔首领远古诅咒分摊圈Tick(this: void): void {
    elapsed += cfg.跟随提示圈刷新毫秒;
    if (!单位有效(target) || elapsed > cfg.延迟秒 * 1000) {
      removePeriodicCallback(id);
      return;
    }
    创建技能提示圈({
      类型: "圆形",
      锚点单位: target,
      半径: cfg.分摊半径,
      持续时间: cfg.跟随提示圈刷新毫秒 / 1000 + 0.05,
    });
  });
  context.清理.登记周期回调("树魔首领-远古诅咒分摊提示", id);
}

function 播放点名特效(this: void, target: any): void {
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  createTimedEffect(cfg.点名特效路径, GetUnitX(target), GetUnitY(target), 0, cfg.点名特效持续秒);
  createTimedEffect(cfg.点名叠加特效路径, GetUnitX(target), GetUnitY(target), 0, cfg.点名特效持续秒);
}

function 收集分摊目标(this: void, boss: any, target: any): any[] {
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  const result: any[] = [];
  const radius2 = cfg.分摊半径 * cfg.分摊半径;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (距离平方XY(targetX, targetY, GetUnitX(hero), GetUnitY(hero)) <= radius2) result.push(hero);
  }
  return result;
}

function 治疗全部玩家(this: void, boss: any, amount: number): void {
  if (!(amount > 0)) return;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    doHeal({
      HealSource: boss,
      HealTarget: hero,
      HealAmount: amount,
      ItemHeal: false,
      HealEffect: true,
    });
  }
}

function 取玩家中心(this: void, boss: any): { x: number; y: number; count: number } {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let sx = 0;
  let sy = 0;
  let count = 0;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    sx += GetUnitX(hero);
    sy += GetUnitY(hero);
    count += 1;
  }
  if (count <= 0) return { x: GetUnitX(boss), y: GetUnitY(boss), count: 0 };
  return { x: sx / count, y: sy / count, count };
}

function 执行远古诅咒后续爆发(this: void, context: 树魔首领运行时上下文, centerX: number, centerY: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  createTimedEffect(cfg.后续爆发特效路径, centerX, centerY, 0, cfg.后续爆发特效持续秒);
  const radius2 = cfg.后续爆发半径 * cfg.后续爆发半径;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (距离平方XY(centerX, centerY, GetUnitX(hero), GetUnitY(hero)) > radius2) continue;
    const damage = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.后续爆发目标最大生命比例
      + 读取单位攻击力(boss) * cfg.后续爆发Boss攻击力比例;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
  }
}

function 调度远古诅咒后续爆发(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || 取有效玩家人数() <= 1) return;
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  const center = 取玩家中心(boss);
  if (center.count <= 1) return;
  创建技能提示圈({
    类型: "渐变圆形",
    X: center.x,
    Y: center.y,
    半径: cfg.后续爆发半径,
    持续时间: cfg.后续爆发延迟秒,
    来源单位: boss,
  });
  const delayedID = addDelayedCallback(cfg.后续爆发延迟秒 * 1000, function 树魔首领远古诅咒二段爆发(this: void): void {
    执行远古诅咒后续爆发(context, center.x, center.y);
  });
  context.清理.登记延迟回调("树魔首领-远古诅咒二段", delayedID);
}

function 执行远古诅咒第一段(this: void, context: 树魔首领运行时上下文, target: any): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 树魔首领数值与表现配置.远古诅咒;
  const playerCount = 取有效玩家人数();
  const baseDamage = GetUnitState(target, UNIT_STATE_LIFE)
    * (cfg.当前生命基础比例 + cfg.每名玩家当前生命追加比例 * playerCount);
  const splitTargets = 收集分摊目标(boss, target);
  const count = splitTargets.length >= 2 ? splitTargets.length : 1;
  const damagePerTarget = baseDamage / count;
  if (splitTargets.length >= 2) {
    for (let i = 0; i < splitTargets.length; i++) {
      UnitDamageTarget(boss, splitTargets[i], damagePerTarget, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
    }
  } else {
    UnitDamageTarget(boss, target, baseDamage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
  }
  治疗全部玩家(boss, baseDamage);
  调度远古诅咒后续爆发(context);
}

export function 释放树魔首领远古诅咒(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取诅咒目标(boss);
  if (!单位有效(target)) return;
  const cfg = 树魔首领数值与表现配置.远古诅咒;

  registerManualBuff(target, 树魔首领BuffID.远古诅咒, cfg.延迟秒, 0, {
    sourceName: "树魔首领-远古诅咒",
  });
  播放点名特效(target);
  启动跟随分摊提示圈(context, target);

  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.延迟秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.延迟秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 树魔首领远古诅咒台词(this: void): void {
      播放树魔首领台词(boss, "远古诅咒");
    },
    on生效: function 树魔首领远古诅咒生效(this: void): void {
      执行远古诅咒第一段(context, target);
    },
  });
}

export function 注册树魔首领远古诅咒(this: void): void {
  if (远古诅咒已注册) return;
  远古诅咒已注册 = true;
  registerSpellEffectListener(on树魔首领远古诅咒生效);
}

function on树魔首领远古诅咒生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 远古诅咒技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 树魔首领单位类型ID) return;
  const context = 获取或创建树魔首领上下文(castingUnit);
  if (context == null) return;
  释放树魔首领远古诅咒(context);
}
