/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置, 树魔首领音效配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (unit: any, order: string, x: number, y: number) => boolean;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (unit: any, speed: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能最近敌对英雄Ex } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getGameDifficulty: (this: void) => number;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领") as {
  树魔首领BuffID: { 治疗枯竭: string; 静止陷阱眩晕: string };
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, 来源单位: any, 目标单位: any, 控制ID: number, 持续时间: number) => void;
};
const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerHealCallback: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

type 图腾分支 = 1 | 2 | 3;

const 快速控制_击晕 = 0;
const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 树魔图腾技能ID = stringToFourCC(树魔首领数值与表现配置.树魔图腾.技能槽位);
const 猎头者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.猎头者);
const 巫医单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.巫医);
const 投掷者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.投掷者);
let 树魔图腾已注册 = false;
let 树魔图腾治疗回调已注册 = false;

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

function 取难度(this: void): number {
  const n = getGameDifficulty();
  return n > 0 ? n : 1;
}

function 取图腾中心(this: void, boss: any): { x: number; y: number } {
  return { x: GetUnitX(boss), y: GetUnitY(boss) };
}

function 选择图腾分支(this: void, context: 树魔首领运行时上下文): 图腾分支 {
  const candidates: 图腾分支[] = [];
  const list = context.随从组.取单位列表();
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    if (!单位有效(unit)) continue;
    const typeId = GetUnitTypeId(unit);
    if (typeId === 巫医单位类型ID) candidates.push(1);
    else if (typeId === 猎头者单位类型ID) candidates.push(2);
    else if (typeId === 投掷者单位类型ID) candidates.push(3);
  }
  if (candidates.length <= 0) return GetRandomInt(1, 3) as 图腾分支;
  return candidates[GetRandomInt(0, candidates.length - 1)];
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

function 创建图腾单位(this: void, context: 树魔首领运行时上下文, 名称: string, 模型路径: string, 最大生命: number, 持续秒: number, on死亡?: (this: void, unit: any, killer: any) => void): any {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const center = 取图腾中心(boss);
  创建技能提示圈({
    类型: "渐变圆形",
    X: center.x,
    Y: center.y,
    半径: cfg.图腾落点提示半径,
    持续时间: 0.6,
    来源单位: boss,
  });
  const totem = 创建可攻击机制单位({
    清理: context.清理,
    名称,
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    模型路径,
    X: center.x,
    Y: center.y,
    最大生命,
    生命值受小怪倍率: false,
    飞行高度: cfg.图腾飞行高度,
    缩放: cfg.图腾缩放,
    持续时间: 持续秒,
    on死亡,
  });
  if (totem != null) {
    播放Boss坐标音效(树魔首领音效配置.树魔图腾.生成, center.x, center.y, 树魔首领音效配置.默认裁断距离);
  }
  return totem;
}

function 对所有玩家施加静止眩晕(this: void, boss: any): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    施加快速控制Buff(boss, hero, 快速控制_击晕, cfg.静止陷阱眩晕秒);
    registerManualBuff(hero, 树魔首领BuffID.静止陷阱眩晕, cfg.静止陷阱眩晕秒, 0, {
      sourceName: "树魔首领-静止陷阱",
    });
  }
}

function 创建静止陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const duration = cfg.静止陷阱基础持续秒 + cfg.静止陷阱每难度追加秒 * 取难度();
  const trap = 创建图腾单位(
    context,
    "树魔首领-静止陷阱",
    cfg.静止陷阱模型路径,
    GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.静止陷阱生命Boss最大生命比例,
    duration,
  );
  if (trap == null) return;
  SetUnitMoveSpeed(trap.单位, cfg.静止陷阱移动速度);

  let 提示累计毫秒: number = cfg.静止陷阱范围提示间隔毫秒;
  const tickID = addPeriodicCallback(cfg.静止陷阱Tick毫秒, function 树魔首领静止陷阱Tick(this: void): void {
    if (!单位有效(boss) || !trap.是否存活()) {
      removePeriodicCallback(tickID);
      return;
    }
    提示累计毫秒 += cfg.静止陷阱Tick毫秒;
    if (提示累计毫秒 >= cfg.静止陷阱范围提示间隔毫秒) {
      提示累计毫秒 = 0;
      创建技能提示圈({
        类型: "圆形",
        锚点单位: trap.单位,
        半径: cfg.静止陷阱触发半径,
        持续时间: cfg.静止陷阱范围提示间隔毫秒 / 1000 + 0.1,
      });
    }

    const nearest = 获取Boss技能最近敌对英雄Ex(boss, trap.单位);
    if (单位有效(nearest)) {
      const distance2 = 距离平方XY(GetUnitX(trap.单位), GetUnitY(trap.单位), GetUnitX(nearest), GetUnitY(nearest));
      SetUnitMoveSpeed(trap.单位, distance2 >= cfg.静止陷阱远距加速阈值 * cfg.静止陷阱远距加速阈值
        ? cfg.静止陷阱远距移动速度
        : cfg.静止陷阱移动速度);
      IssuePointOrder(trap.单位, "move", GetUnitX(nearest), GetUnitY(nearest));
    }

    const heroes = 获取Boss技能敌对英雄列表(boss);
    const radius2 = cfg.静止陷阱触发半径 * cfg.静止陷阱触发半径;
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (!单位有效(hero)) continue;
      if (距离平方XY(GetUnitX(trap.单位), GetUnitY(trap.单位), GetUnitX(hero), GetUnitY(hero)) > radius2) continue;
      播放Boss坐标音效(树魔首领音效配置.树魔图腾.陷阱触发, GetUnitX(trap.单位), GetUnitY(trap.单位), 树魔首领音效配置.默认裁断距离);
      SetUnitAnimationByIndex(trap.单位, 3);
      对所有玩家施加静止眩晕(boss);
      trap.销毁();
      removePeriodicCallback(tickID);
      return;
    }
  });
  context.清理.登记周期回调("树魔首领-静止陷阱Tick", tickID);
}

function 创建生命陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const trap = 创建图腾单位(
    context,
    "树魔首领-生命陷阱",
    cfg.生命陷阱模型路径,
    GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.生命陷阱生命Boss最大生命比例,
    cfg.生命陷阱持续秒,
  );
  if (trap == null) return;
  const healReduce = cfg.生命陷阱治疗降低基础比例 + cfg.生命陷阱治疗降低每难度追加比例 * 取难度();
  创建技能提示圈({
    类型: "渐变圆形",
    锚点单位: trap.单位,
    半径: cfg.生命陷阱影响半径,
    持续时间: cfg.生命陷阱持续秒,
    来源单位: boss,
  });
  const tickID = addPeriodicCallback(cfg.生命陷阱Tick秒 * 1000, function 树魔首领生命陷阱Tick(this: void): void {
    if (!单位有效(boss) || !trap.是否存活()) {
      removePeriodicCallback(tickID);
      return;
    }
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (!单位有效(hero)) continue;
      造成AOE技能伤害({
        技能ID: 树魔图腾技能ID,
        来源: boss,
        目标: hero,
        伤害: GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.生命陷阱伤害目标最大生命比例,
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_ENHANCED,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
      });
      registerManualBuff(hero, 树魔首领BuffID.治疗枯竭, cfg.生命陷阱Tick秒 + 0.4, healReduce, {
        sourceName: "树魔首领-生命陷阱",
      });
    }
  });
  context.清理.登记周期回调("树魔首领-生命陷阱Tick", tickID);
}

function 爆炸陷阱造成伤害(this: void, boss: any, x: number, y: number): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  播放Boss坐标音效(树魔首领音效配置.树魔图腾.陷阱触发, x, y, 树魔首领音效配置.默认裁断距离);
  createTimedEffect(cfg.爆炸陷阱爆炸特效路径, x, y, 0, cfg.爆炸陷阱爆炸特效持续秒);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const damage = GetUnitState(hero, UNIT_STATE_LIFE) * cfg.爆炸陷阱当前生命伤害比例
      + cfg.爆炸陷阱每难度固定伤害 * 取难度();
    造成AOE技能伤害({
      技能ID: 树魔图腾技能ID,
      来源: boss,
      目标: hero,
      伤害: damage,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
    });
  }
}

function 调度爆炸陷阱爆炸(this: void, context: 树魔首领运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  创建技能提示圈({
    类型: "渐变圆形",
    X: x,
    Y: y,
    半径: cfg.爆炸陷阱爆炸提示半径,
    持续时间: cfg.爆炸陷阱被摧毁爆炸延迟秒,
    来源单位: boss,
  });
  const delayedID = addDelayedCallback(cfg.爆炸陷阱被摧毁爆炸延迟秒 * 1000, function 树魔首领爆炸陷阱爆炸(this: void): void {
    if (!单位有效(boss)) return;
    爆炸陷阱造成伤害(boss, x, y);
  });
  context.清理.登记延迟回调("树魔首领-爆炸陷阱爆炸", delayedID);
}

function 创建爆炸陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  let naturalEnd = false;
  let exploded = false;
  const trap = 创建图腾单位(
    context,
    "树魔首领-爆炸陷阱",
    cfg.爆炸陷阱模型路径,
    GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.爆炸陷阱生命Boss最大生命比例,
    cfg.爆炸陷阱持续秒,
    function 树魔首领爆炸陷阱死亡(this: void, unit: any): void {
      if (naturalEnd || exploded) return;
      exploded = true;
      调度爆炸陷阱爆炸(context, GetUnitX(unit), GetUnitY(unit));
    },
  );
  if (trap == null) return;

  const naturalEndID = addDelayedCallback(cfg.爆炸陷阱持续秒 * 1000, function 树魔首领爆炸陷阱自然结束(this: void): void {
    naturalEnd = true;
    if (trap.是否存活()) trap.销毁();
  });
  context.清理.登记延迟回调("树魔首领-爆炸陷阱自然结束", naturalEndID);

  const interval = Math.max(1.2, cfg.爆炸陷阱传送基础间隔秒 - cfg.爆炸陷阱传送每难度减少秒 * 取难度());
  const teleportID = addPeriodicCallback(interval * 1000, function 树魔首领爆炸陷阱传送Tick(this: void): void {
    if (!单位有效(boss) || !trap.是否存活() || naturalEnd) {
      removePeriodicCallback(teleportID);
      return;
    }
    const angle = GetRandomReal(0, 360);
    const distance = GetRandomReal(cfg.爆炸陷阱传送最近距离, cfg.爆炸陷阱传送最远距离);
    const x = GetUnitX(boss) + CosBJ(angle) * distance;
    const y = GetUnitY(boss) + SinBJ(angle) * distance;
    SetUnitPosition(trap.单位, x, y);
    创建技能提示圈({
      类型: "圆形",
      X: x,
      Y: y,
      半径: cfg.图腾落点提示半径,
      持续时间: 0.8,
      来源单位: boss,
    });
  });
  context.清理.登记周期回调("树魔首领-爆炸陷阱传送", teleportID);
}

function 创建树魔图腾分支(this: void, context: 树魔首领运行时上下文): void {
  const branch = 选择图腾分支(context);
  if (branch === 1) 创建静止陷阱(context);
  else if (branch === 2) 创建生命陷阱(context);
  else 创建爆炸陷阱(context);
}

export function 释放树魔首领树魔图腾(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  尝试播放树魔首领关键怪叫(boss);
  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss),
    目标Y: GetUnitY(boss),
    硬直秒: cfg.施法硬直秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.施法硬直秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 树魔首领树魔图腾台词(this: void): void {
      播放树魔首领台词(boss, "树魔图腾");
    },
    on生效: function 树魔首领树魔图腾生效(this: void): void {
      创建树魔图腾分支(context);
    },
  });
}

function 治疗枯竭治疗修正(this: void, _source: any, target: any, amount: number, _isItemHeal: boolean): number {
  const runtime = getBuffRuntime(target, 树魔首领BuffID.治疗枯竭);
  if (runtime == null) return amount;
  const reduce = runtime.effect > 0 ? runtime.effect : 0;
  return amount * (1 - reduce);
}

export function 注册树魔首领树魔图腾(this: void): void {
  if (!树魔图腾治疗回调已注册) {
    树魔图腾治疗回调已注册 = true;
    registerHealCallback(治疗枯竭治疗修正);
  }
  if (树魔图腾已注册) return;
  树魔图腾已注册 = true;
  注册单位技能壳监听({
    名称: "树魔首领-树魔图腾",
    单位类型ID: 树魔首领单位类型ID,
    技能ID: 树魔图腾技能ID,
    获取或创建上下文: 获取或创建树魔首领上下文,
    释放技能: function 树魔首领树魔图腾监听释放(this: void, _context: 树魔首领运行时上下文, boss: any): void {
      on树魔首领树魔图腾生效(boss, 树魔图腾技能ID);
    },
  });
}

function on树魔首领树魔图腾生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 树魔图腾技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 树魔首领单位类型ID) return;
  const context = 获取或创建树魔首领上下文(castingUnit);
  if (context == null) return;
  释放树魔首领树魔图腾(context);
}
