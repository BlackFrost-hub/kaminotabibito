/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置, 树魔首领音效配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
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
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.05．树魔首领") as {
  树魔首领BuffID: { 古树衰弱: string };
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 扩散冲击波技能ID = stringToFourCC(树魔首领数值与表现配置.扩散冲击波.技能槽位);
let 扩散冲击波已注册 = false;

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

function 播放扩散冲击波蓄力特效(this: void, boss: any): void {
  const cfg = 树魔首领数值与表现配置.扩散冲击波;
  创建点特效({
    模型路径: cfg.蓄力特效路径,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 0,
    缩放: cfg.蓄力特效缩放,
    持续秒: cfg.蓄力特效持续秒,
  });
}

function 播放扩散冲击波命中特效(this: void, boss: any): void {
  const cfg = 树魔首领数值与表现配置.扩散冲击波;
  创建点特效({
    模型路径: cfg.扩散命中特效路径,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 0,
    缩放: cfg.扩散命中特效缩放,
    持续秒: cfg.扩散命中特效持续秒,
  });
}

function 施加古树衰弱(this: void, target: any): void {
  const cfg = 树魔首领数值与表现配置.扩散冲击波;
  registerManualBuff(target, 树魔首领BuffID.古树衰弱, cfg.攻击降低持续秒, cfg.攻击降低比例, {
    sourceName: "树魔首领-扩散冲击波",
  });
}

function 尝试播放树魔首领关键怪叫(this: void, boss: any): void {
  const soundCfg = 树魔首领音效配置;
  尝试播放Boss拟声池({
    标识: soundCfg.怪物拟声.标识,
    音效路径列表: soundCfg.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: soundCfg.默认裁断距离,
    冷却Ms: soundCfg.怪物拟声.冷却Ms,
    触发概率百分比: soundCfg.怪物拟声.关键机制触发概率百分比,
  });
}

function 执行扩散冲击波(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.扩散冲击波;
  const hit: Record<number, true | undefined> = {};
  let step = 0;

  尝试播放树魔首领关键怪叫(boss);
  播放Boss坐标音效(树魔首领音效配置.扩散冲击波.生效, GetUnitX(boss), GetUnitY(boss), 树魔首领音效配置.默认裁断距离);
  播放扩散冲击波命中特效(boss);
  let callbackID = 0;
  callbackID = addPeriodicCallback(cfg.Tick间隔毫秒, function 树魔首领扩散冲击波Tick(this: void): void {
    if (!单位有效(boss) || context.清理.已清理()) {
      removePeriodicCallback(callbackID);
      return;
    }

    step += 1;
    const radius = cfg.初始半径 + cfg.每跳扩张半径 * step;
    const radius2 = radius * radius;
    const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
    const bossX = GetUnitX(boss);
    const bossY = GetUnitY(boss);
    const targets = 获取Boss技能敌对英雄列表(boss);

    for (let i = 0; i < targets.length; i++) {
      const target = targets[i];
      if (!单位有效(target)) continue;
      const hid = GetHandleId(target) || 0;
      if (hid === 0 || hit[hid] === true) continue;
      if (距离平方XY(bossX, bossY, GetUnitX(target), GetUnitY(target)) > radius2) continue;
      hit[hid] = true;
      造成AOE技能伤害({
        技能ID: 扩散冲击波技能ID,
        来源: boss,
        目标: target,
        伤害: damage,
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_PLANT,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
      });
      施加古树衰弱(target);
    }

    if (step >= cfg.最大扩张跳数) {
      removePeriodicCallback(callbackID);
    }
  });
  context.清理.登记周期回调("树魔首领-扩散冲击波", callbackID);
}

export function 释放树魔首领扩散冲击波(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.扩散冲击波;
  创建技能提示圈({
    类型: "渐变圆形",
    锚点单位: boss,
    半径: cfg.预警半径,
    持续时间: cfg.前摇秒,
  });
  播放扩散冲击波蓄力特效(boss);
  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss),
    目标Y: GetUnitY(boss),
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 树魔首领扩散冲击波台词(this: void): void {
      播放树魔首领台词(boss, "扩散冲击波");
    },
    on生效: function 树魔首领扩散冲击波生效(this: void): void {
      执行扩散冲击波(context);
    },
  });
}

function 古树衰弱伤害修正(this: void, damageContext: any): number {
  if (damageContext == null || damageContext.isNormalAttack !== true) return damageContext.currentDamage;
  const runtime = getBuffRuntime(damageContext.attacker, 树魔首领BuffID.古树衰弱);
  if (runtime == null) return damageContext.currentDamage;
  const reduce = runtime.effect > 0 ? runtime.effect : 树魔首领数值与表现配置.扩散冲击波.攻击降低比例;
  return damageContext.currentDamage * (1 - reduce);
}

export function 注册树魔首领扩散冲击波(this: void): void {
  if (扩散冲击波已注册) return;
  扩散冲击波已注册 = true;
  注册单位技能壳监听({
    名称: "树魔首领-扩散冲击波",
    单位类型ID: 树魔首领单位类型ID,
    技能ID: 扩散冲击波技能ID,
    获取或创建上下文: 获取或创建树魔首领上下文,
    释放技能: function 树魔首领扩散冲击波监听释放(this: void, _context: 树魔首领运行时上下文, boss: any): void {
      on树魔首领扩散冲击波生效(boss, 扩散冲击波技能ID);
    },
  });
  registerDamageModifier(古树衰弱伤害修正, 35);
}

function on树魔首领扩散冲击波生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 扩散冲击波技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 树魔首领单位类型ID) return;
  const context = 获取或创建树魔首领上下文(castingUnit);
  if (context == null) return;
  释放树魔首领扩散冲击波(context);
}
