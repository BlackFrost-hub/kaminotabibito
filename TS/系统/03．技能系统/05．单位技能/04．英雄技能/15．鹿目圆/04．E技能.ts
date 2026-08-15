/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import { 是鹿目圆, 鹿目圆伤害无视魔抗, 鹿目圆治疗友军 } from "./01．状态与被动";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, target: any, onlyPurgable?: boolean) => number;
};
const { 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const GetRandomDirectionDeg = jass.GetRandomDirectionDeg as (this: void) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = (jass.bj_DEGTORAD ?? 0.017453292519943295) as number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const 配置 = 鹿目圆单位技能配置;

interface E上下文 {
  施法者: any;
  技能实例ID: number;
  暂停来源: string;
  目标X: number;
  目标Y: number;
  区域X: number;
  区域Y: number;
  每次结算值: number;
  雨单位: any[];
  周期ID: number;
  Tick: number;
  区域已启动: boolean;
  区域已结算: boolean;
  已结束: boolean;
}

const E上下文表: Record<number, E上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit);
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是E合法单位(this: void, unit: any): boolean {
  return 单位存活(unit)
    && IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true;
}

function 清理E雨单位(this: void, context: E上下文): void {
  for (let i = 0; i < context.雨单位.length; i++) {
    const unit = context.雨单位[i];
    if (unit != null && unit !== 0) RemoveUnit(unit);
  }
  context.雨单位 = [];
}

function 结束E(this: void, context: E上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) {
    removePeriodicCallback(context.周期ID);
    context.周期ID = 0;
  }
  移除单位暂停(context.施法者, context.暂停来源);
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.虹之雨);
  清理E雨单位(context);
  结束独立技能伤害实例(context.技能实例ID);
  const id = 取单位ID(context.施法者);
  if (id !== 0 && E上下文表[id] === context) delete E上下文表[id];
}

function 创建E雨壳(this: void, context: E上下文): void {
  const distance = GetRandomReal(20, 配置.E.范围);
  const angle = GetRandomDirectionDeg();
  const radians = angle * bj_DEGTORAD;
  const x = context.区域X + Cos(radians) * distance;
  const y = context.区域Y + Sin(radians) * distance;
  const rain = 创建单位并登记排泄安全(GetOwningPlayer(context.施法者), 配置.单位壳.虹之雨, x, y, angle);
  if (rain == null || rain === 0) return;
  SetUnitFlyHeight(rain, 配置.E.雨单位高度, 0);
  SetUnitScale(rain, 配置.E.雨单位缩放, 配置.E.雨单位缩放, 配置.E.雨单位缩放);
  context.雨单位.push(rain);
}

function 推进E雨壳(this: void, context: E上下文): void {
  const kept: any[] = [];
  for (let i = 0; i < context.雨单位.length; i++) {
    const unit = context.雨单位[i];
    if (!单位存活(unit)) continue;
    const nextHeight = GetUnitFlyHeight(unit) - 配置.E.雨单位下降步长;
    if (nextHeight <= 配置.E.雨单位清理高度) {
      RemoveUnit(unit);
      continue;
    }
    SetUnitFlyHeight(unit, nextHeight, 0);
    kept.push(unit);
  }
  context.雨单位 = kept;
}

function E区域脉冲(this: void, context: E上下文): void {
  createTimedEffect(配置.E.脉冲特效, context.区域X, context.区域Y, 0, 1.5);
  const owner = GetOwningPlayer(context.施法者);
  const units = getUnitsInRange(context.区域X, context.区域Y, 配置.E.范围);
  const enemies: any[] = [];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (!是E合法单位(unit)) continue;
    if (IsUnitEnemy(unit, owner) === true) enemies.push(unit);
    else if (IsUnitAlly(unit, owner) === true) 鹿目圆治疗友军(context.施法者, unit, context.每次结算值, 0);
  }
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: enemies,
    伤害: context.每次结算值,
    伤害类型: DAMAGE_TYPE_PLANT,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.E.类型ID,
    技能实例ID: context.技能实例ID,
    标签: "鹿目圆-E-虹之雨",
    参与技能伤害加成: true,
    忽略魔法抗性: 鹿目圆伤害无视魔抗(context.施法者),
  });
}

function E区域结束驱散(this: void, context: E上下文): void {
  const owner = GetOwningPlayer(context.施法者);
  const units = getUnitsInRange(context.区域X, context.区域Y, 配置.E.范围);
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (是E合法单位(unit) && IsUnitAlly(unit, owner) === true) 移除单位负面Buff(unit, false);
  }
  context.区域已结算 = true;
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.虹之雨);
}

function E区域Tick(this: void, variable?: any): void {
  const context = variable as E上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!单位存活(context.施法者)) {
    结束E(context);
    return;
  }

  context.Tick += 1;
  if (context.Tick <= 100) 创建E雨壳(context);
  推进E雨壳(context);
  if (context.Tick === 20 || context.Tick === 40 || context.Tick === 60 || context.Tick === 80 || context.Tick === 100) {
    E区域脉冲(context);
  }
  if (context.Tick >= 100 && !context.区域已结算) E区域结束驱散(context);
  if (context.Tick >= 100 && context.雨单位.length <= 0) 结束E(context);
}

function 开始E区域(this: void, context: E上下文): void {
  if (context.已结束 || !单位存活(context.施法者)) {
    结束E(context);
    return;
  }
  context.区域已启动 = true;
  context.区域X = GetUnitX(context.施法者);
  context.区域Y = GetUnitY(context.施法者);
  context.Tick = 0;
  registerManualBuff(context.施法者, 鹿目圆BuffID.虹之雨, 配置.E.持续秒, context.每次结算值, {
    sourceUnit: context.施法者,
    effectSourceName: "虹之雨",
    effectSourceType: "技能",
  });
  context.周期ID = addPeriodicCallback(配置.E.雨单位生成间隔毫秒, E区域Tick, context);
}

function E冲锋结束(this: void, unit: any, reason: string): void {
  const context = E上下文表[取单位ID(unit)];
  if (context == null || context.已结束 || context.区域已启动) return;
  if (reason === "死亡" || reason === "主单位死亡" || reason === "中断") {
    结束E(context);
    return;
  }
  开始E区域(context);
}

function 开始E移动(this: void, variable?: any): void {
  const context = variable as E上下文 | undefined;
  if (context == null || context.已结束) return;
  移除单位暂停(context.施法者, context.暂停来源);
  if (!单位存活(context.施法者)) {
    结束E(context);
    return;
  }
  const startX = GetUnitX(context.施法者);
  const startY = GetUnitY(context.施法者);
  const dx = context.目标X - startX;
  const dy = context.目标Y - startY;
  const distance = SquareRoot(dx * dx + dy * dy);
  const moveDistance = distance > 配置.E.移动距离 ? 配置.E.移动距离 : distance;
  if (!(moveDistance > 1)) {
    开始E区域(context);
    return;
  }
  const moveId = 开始冲锋(context.施法者, {
    距离: moveDistance,
    持续时间: 配置.E.移动持续秒,
    目标X: context.目标X,
    目标Y: context.目标Y,
    检查地形: true,
    暂停单位: true,
    禁用碰撞: true,
    位移特效: "",
    动画名: "spell",
    结束回调: E冲锋结束,
  });
  if (moveId === 0) 开始E区域(context);
}

function 获取E入口(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放E(this: void, _entry: { 英雄: any }, caster: any, 技能实例ID?: number): void {
  if (!单位存活(caster) || 技能实例ID == null) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  const id = 取单位ID(caster);
  const old = E上下文表[id];
  if (old != null) 结束E(old);
  const maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA);
  const total = maxMana * (配置.E.最大魔法基础比例 + GetHeroLevel(caster) * 配置.E.每英雄等级额外比例);
  const context: E上下文 = {
    施法者: caster,
    技能实例ID,
    暂停来源: "鹿目圆-E-" + String(技能实例ID),
    目标X: GetSpellTargetX(),
    目标Y: GetSpellTargetY(),
    区域X: 0,
    区域Y: 0,
    每次结算值: total / 配置.E.脉冲次数,
    雨单位: [],
    周期ID: 0,
    Tick: 0,
    区域已启动: false,
    区域已结算: false,
    已结束: false,
  };
  E上下文表[id] = context;
  const facing = 两点角度(GetUnitX(caster), GetUnitY(caster), context.目标X, context.目标Y);
  SetUnitFacing(caster, facing);
  添加单位暂停(caster, context.暂停来源);
  SetUnitAnimation(caster, "spell");
  createTimedEffect(配置.E.起手特效, context.目标X, context.目标Y, -300, 配置.E.起手特效持续秒);
  addDelayedCallback(配置.E.起手硬直秒 * 1000, 开始E移动, context);
}

function 注册E单位类型(this: void, unitTypeId: number): void {
  注册单位技能壳监听({
    名称: "鹿目圆-虹之雨",
    单位类型ID: unitTypeId,
    技能ID: 配置.技能.E.类型ID,
    获取或创建上下文: 获取E入口,
    释放技能: 释放E,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 7,
  });
}

注册E单位类型(配置.单位.普通类型ID);
注册E单位类型(配置.单位.圆神类型ID);

export {};
