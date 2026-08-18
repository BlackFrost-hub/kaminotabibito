/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import {
  是鹿目圆圆神,
  获取圆神剩余秒,
  结束鹿目圆圆神,
} from "./01．状态与被动";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始硬直, 施加单位控制负面效果免疫 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加单位控制负面效果免疫: (this: void, unit: any, duration: number, syncNative?: boolean) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 消耗单位全部当前魔法 } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  消耗单位全部当前魔法: (this: void, unit: any) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { 读取单位攻击力, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
// GetRandomDirectionDeg 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const GetRandomReal = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const bj_DEGTORAD = (jass.bj_DEGTORAD ?? 0.017453292519943295) as number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const 配置 = 鹿目圆单位技能配置;

interface R入口上下文 {
  施法者: any;
  目标X: number;
  目标Y: number;
  方向: number;
  距离: number;
  剩余圆神秒: number;
  攻击力快照: number;
}

interface R运行上下文 extends R入口上下文 {
  所有者: any;
  技能实例ID?: number;
  主箭: any;
  副箭: any;
  已移动距离: number;
  已结算Tick: number;
  周期ID: number;
  已结束: boolean;
}

function 移除单位壳(this: void, unit: any): void {
  if (unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0) RemoveUnit(unit);
}

function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 获取R入口(this: void, caster: any): R入口上下文 | undefined {
  if (!是鹿目圆圆神(caster)) return undefined;
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const distance = 两点距离(startX, startY, targetX, targetY);
  if (distance < 配置.R.最低施法距离) return undefined;
  return {
    施法者: caster,
    目标X: targetX,
    目标Y: targetY,
    方向: 两点角度(startX, startY, targetX, targetY),
    距离: distance,
    剩余圆神秒: 获取圆神剩余秒(caster),
    攻击力快照: 读取单位攻击力(caster),
  };
}

function 清理R(this: void, context: R运行上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) {
    removePeriodicCallback(context.周期ID);
    context.周期ID = 0;
  }
  移除单位壳(context.主箭);
  移除单位壳(context.副箭);
  context.主箭 = null;
  context.副箭 = null;
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.圆环之理);
  结束独立技能伤害实例(context.技能实例ID);
}

function 清理R脉冲箭(this: void, variable?: any): void {
  const data = variable as { unit: any } | undefined;
  if (data != null) 移除单位壳(data.unit);
}

function 创建R脉冲箭(this: void, context: R运行上下文): void {
  const angle = GetRandomDirectionDeg();
  const radius = GetRandomReal(50, 650);
  const radians = angle * bj_DEGTORAD;
  const x = context.目标X + radius * Cos(radians);
  const y = context.目标Y + radius * Sin(radians);
  const arrow = 创建单位并登记排泄安全(
    context.所有者,
    配置.单位壳.W发射箭,
    x,
    y,
    angle,
  );
  if (arrow == null || arrow === 0) return;
  SetUnitAnimationByIndex(arrow, 3);
  addDelayedCallback(1500, 清理R脉冲箭, { unit: arrow });
}

function 是R有效目标(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && GetUnitTypeId(unit) !== 0
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 结算R单次脉冲(this: void, context: R运行上下文): void {
  创建R脉冲箭(context);
  const units = getUnitsInRange(context.目标X, context.目标Y, 配置.R.范围);
  const enemies: any[] = [];
  const allies: any[] = [];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (!是R有效目标(unit)) continue;
    if (IsUnitEnemy(unit, context.所有者) === true) enemies.push(unit);
    else if (IsUnitAlly(unit, context.所有者) === true) allies.push(unit);
  }

  const multiplier = 1 + context.剩余圆神秒 / 20;
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: enemies,
    伤害: 0,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.R.类型ID,
    技能实例ID: context.技能实例ID,
    标签: "鹿目圆-R-圆环之理",
    参与技能伤害加成: true,
    每目标处理器: R敌方每目标处理,
    变量: { context, multiplier },
  });

  for (let i = 0; i < allies.length; i++) {
    const ally = allies[i];
    doHeal({
      HealSource: context.施法者,
      HealTarget: ally,
      HealAmount: GetUnitStateJapi(ally, UNIT_STATE_MAX_LIFE),
      HealManaAmount: GetUnitStateJapi(ally, UNIT_STATE_MAX_MANA),
      ItemHeal: false,
      HealEffect: false,
      HealShowText: false,
      ManaEffect: false,
      ManaShowText: false,
    });
  }
}

function R敌方每目标处理(this: void, target: any, _index: number, variable?: any): any {
  const data = variable as { context: R运行上下文; multiplier: number } | undefined;
  if (data == null || !是R有效目标(target)) return undefined;
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(target, UNIT_STATE_LIFE);
  const missingLife = maxLife > life ? maxLife - life : 0;
  const totalDamage = (
    data.context.攻击力快照 * 配置.R.攻击力比例
    + missingLife * 配置.R.已损失生命比例
  ) * data.multiplier;
  return { 伤害: totalDamage / 配置.R.Tick次数 };
}

function R结算Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.已结算Tick >= 配置.R.Tick次数) {
    清理R(context);
    return;
  }
  context.已结算Tick += 1;
  结算R单次脉冲(context);
  if (context.已结算Tick >= 配置.R.Tick次数) 清理R(context);
}

function R弹道Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.已移动距离 >= context.距离) {
    removePeriodicCallback(context.周期ID);
    context.周期ID = 0;
    移除单位壳(context.主箭);
    移除单位壳(context.副箭);
    context.主箭 = null;
    context.副箭 = null;
    创建点特效({
      模型路径: 配置.R.命中特效,
      X: context.目标X,
      Y: context.目标Y,
      Z: 0,
      面向角度: 270,
      缩放: 配置.R.命中特效缩放,
      持续秒: 6,
    });
    context.周期ID = addPeriodicCallback(配置.R.Tick间隔毫秒, R结算Tick, context);
    return;
  }

  const move = context.距离 - context.已移动距离 < 配置.R.箭步长
    ? context.距离 - context.已移动距离
    : 配置.R.箭步长;
  context.已移动距离 += move;
  const radians = context.方向 * bj_DEGTORAD;
  const x = GetUnitX(context.主箭) + move * Cos(radians);
  const y = GetUnitY(context.主箭) + move * Sin(radians);
  SetUnitX(context.主箭, x);
  SetUnitY(context.主箭, y);
  SetUnitX(context.副箭, x);
  SetUnitY(context.副箭, y);
}

function 释放R(this: void, entry: R入口上下文, caster: any, 技能实例ID?: number): void {
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const owner = GetOwningPlayer(caster);

  消耗单位全部当前魔法(caster);
  结束鹿目圆圆神(caster, "施放圆环之理");
  开始硬直(caster, 配置.R.起手硬直秒);
  SetUnitAnimation(caster, "spell");
  施加单位控制负面效果免疫(caster, 配置.R.施法控制免疫秒, true);
  registerManualBuff(caster, 鹿目圆BuffID.圆环之理, 配置.R.持续秒, 0, {
    sourceUnit: caster,
    stack: 1,
  });

  const mainArrow = 创建单位并登记排泄安全(owner, 配置.单位壳.R主箭, startX, startY, entry.方向);
  const subArrow = 创建单位并登记排泄安全(owner, 配置.单位壳.R副箭, startX, startY, entry.方向);
  if (mainArrow == null || mainArrow === 0 || subArrow == null || subArrow === 0) {
    移除单位壳(mainArrow);
    移除单位壳(subArrow);
    移除单位指定Buff(caster, 鹿目圆BuffID.圆环之理);
    结束独立技能伤害实例(技能实例ID);
    return;
  }

  SetUnitFacing(mainArrow, entry.方向);
  SetUnitFlyHeight(mainArrow, 配置.R.主箭高度, 0);
  SetUnitScale(mainArrow, 配置.R.主箭缩放, 配置.R.主箭缩放, 配置.R.主箭缩放);
  SetUnitFacing(subArrow, entry.方向);
  SetUnitFlyHeight(subArrow, 配置.R.副箭高度, 0);
  SetUnitScale(subArrow, 配置.R.副箭缩放, 配置.R.副箭缩放, 配置.R.副箭缩放);

  const context: R运行上下文 = {
    ...entry,
    所有者: owner,
    技能实例ID,
    主箭: mainArrow,
    副箭: subArrow,
    已移动距离: 0,
    已结算Tick: 0,
    周期ID: 0,
    已结束: false,
  };
  context.周期ID = addPeriodicCallback(配置.R.箭间隔毫秒, R弹道Tick, context);
}

注册单位技能壳监听({
  名称: "鹿目圆-圆环之理",
  单位类型ID: 配置.单位.圆神类型ID,
  技能ID: 配置.技能.R.类型ID,
  获取或创建上下文: 获取R入口,
  释放技能: 释放R,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 12,
});

export {};
