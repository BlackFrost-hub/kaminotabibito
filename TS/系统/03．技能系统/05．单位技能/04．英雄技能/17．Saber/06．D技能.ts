/** @noSelfInFile */
// Saber D：遥远的理想乡 / 阿瓦隆（A0DH）。
// 源 JASS 真源：主要技能.j 2445-2487/2108-2167。
// 伤害修正走公共伤害修正回调层（伤害写回前），不复制源的私有原生触发器：
// - 说明最终口径「免疫一切魔法伤害」→ 魔法伤害归零；
// - 源对非魔法伤害的「受伤后等量回复」→ 伤害写回后用统一治疗入口等量恢复。
// 立即满血与周期回蓝都走统一治疗系统；粒子表现保留源时点。

import { Saber技能配置 } from "./00．配置";
import { SaberBuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/08．Saber";
import { Saber设置阿瓦隆, Saber是否阿瓦隆 } from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";


const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, addDelayedCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { createUnitEffect, destroyUnitEffect, 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  创建点特效: (this: void, params: any) => any;
};
// 源 PlaySoundBJ(gg_snd_Saber_Alter_D_Avalon)：全局播放（不挂单位），照源用 jglobals 全局音效句柄 + BJ 封装
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const DzPlayEffectAnimation = japi.DzPlayEffectAnimation as (this: void, effect: any, animName: string, extra: string) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = Saber技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const D类型ID = stringToFourCC(配置.D.技能ID);
const D头顶特效键 = "Saber-D-头顶";
const D原点特效键 = "Saber-D-原点";

// ---------------------------------------------------------------------------
// D 运行时
// ---------------------------------------------------------------------------

interface D运行时 {
  caster: any;
  回蓝回调ID: number;
  Tick数: number;
  已启动: boolean;
}

const D运行时表: Record<number, D运行时> = {};

function 结束阿瓦隆(this: void, caster: any): void {
  if (caster == null || caster === 0) return;
  const runtime = D运行时表[GetHandleId(caster)];
  Saber设置阿瓦隆(caster, false);
  移除单位指定Buff(caster, SaberBuffID.阿瓦隆);
  destroyUnitEffect(caster, D头顶特效键);
  destroyUnitEffect(caster, D原点特效键);
  if (runtime == null) return;
  if (runtime.回蓝回调ID !== 0) removePeriodicCallback(runtime.回蓝回调ID);
  runtime.回蓝回调ID = 0;
  runtime.已启动 = false;
  delete D运行时表[GetHandleId(caster)];
}

function 推进D回蓝与粒子(this: void, variable?: any): void {
  const runtime = variable as D运行时 | undefined;
  if (runtime == null) return;
  const caster = runtime.caster;

  if (caster == null || caster === 0 || !单位存活(caster) || !Saber是否阿瓦隆(caster) || runtime.Tick数 >= 配置.D.回蓝.最大Tick数) {
    结束阿瓦隆(caster);
    return;
  }

  runtime.Tick数 += 1;

  // 粒子表现（源：每 0.1 秒一个，播放 Death 动画）
  const 粒子 = 创建点特效({
    模型路径: 配置.D.粒子特效.模型路径,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z: 配置.D.粒子特效.高度,
    缩放: 配置.D.粒子特效.缩放,
    持续秒: 配置.D.粒子特效.持续秒,
  });
  if (粒子 != null && 粒子 !== 0) {
    DzPlayEffectAnimation(粒子, 配置.D.粒子特效.动画名, "");
  }

  // 恢复已损失魔法的 2%（统一治疗入口，不享受加成由治疗系统结算）
  const 已损失魔法 = GetUnitState(caster, UNIT_STATE_MAX_MANA) - GetUnitState(caster, UNIT_STATE_MANA);
  if (已损失魔法 > 0) {
    doHeal({
      HealSource: caster,
      HealTarget: caster,
      HealAmount: 0,
      HealManaAmount: 已损失魔法 * 配置.D.回蓝.已损失魔法比例,
      ItemHeal: false,
      HealEffect: false,
      ManaEffect: false,
      HealShowText: false,
      ManaShowText: false,
    });
  }
}

// ---------------------------------------------------------------------------
// 公共伤害修正：阿瓦隆期间魔法伤害归零，其余伤害写回后等量恢复
// ---------------------------------------------------------------------------

function 阿瓦隆伤害修正(this: void, context: any): number {
  const target = context.target;
  if (target == null || target === 0) return context.currentDamage;
  if (GetUnitTypeId(target) !== 英雄单位类型ID) return context.currentDamage;
  if (!Saber是否阿瓦隆(target)) return context.currentDamage;
  const damage = context.currentDamage;
  if (damage <= 0) return damage;

  if (context.isMagicDamage === true) {
    // 说明口径：免疫一切魔法伤害（源对窄条件置零，扩展为全部魔法伤害）
    return 0;
  }

  // 源口径：非魔法伤害实际扣血后等量恢复；延后一帧避免在当前伤害链内嵌套结算
  addDelayedCallback(0, 阿瓦隆等量恢复 as unknown as (this: void, variable?: any) => void, {
    target,
    damage,
  });
  return damage;
}

function 阿瓦隆等量恢复(this: void, variable?: any): void {
  const ctx = variable as { target: any; damage: number } | undefined;
  if (ctx == null) return;
  const target = ctx.target;
  if (target == null || target === 0 || !单位存活(target)) return;
  if (!Saber是否阿瓦隆(target)) return;
  doHeal({
    HealSource: target,
    HealTarget: target,
    HealAmount: ctx.damage,
    ItemHeal: false,
    HealEffect: false,
    HealShowText: false,
  });
}

// ---------------------------------------------------------------------------
// 施法入口
// ---------------------------------------------------------------------------

interface D上下文 {
  施法者: any;
}

const D上下文表: Record<number, D上下文> = {};

function 获取或创建D上下文(this: void, caster: any): D上下文 {
  const id = GetHandleId(caster);
  let record = D上下文表[id];
  if (record == null) {
    record = { 施法者: caster };
    D上下文表[id] = record;
  }
  return record;
}

function 释放D技能(this: void, _context: D上下文, caster: any, _技能实例ID?: number): void {
  if (!单位存活(caster)) return;

  // 重复释放：先结束旧的阿瓦隆
  if (Saber是否阿瓦隆(caster)) {
    结束阿瓦隆(caster);
  }

  const d音效句柄 = (jglobals as any)[配置.D.音效.全局音效键];
    if (d音效句柄 != null) PlaySoundBJ(d音效句柄);
  createUnitEffect(caster, 配置.D.头顶特效.挂点, 配置.D.头顶特效.模型路径, undefined, D头顶特效键);
  createUnitEffect(caster, 配置.D.原点特效.挂点, 配置.D.原点特效.模型路径, undefined, D原点特效键);

  // 立即恢复全部生命（统一治疗入口）
  const 缺失生命 = GetUnitState(caster, UNIT_STATE_MAX_LIFE) - GetUnitState(caster, UNIT_STATE_LIFE);
  if (缺失生命 > 0) {
    doHeal({
      HealSource: caster,
      HealTarget: caster,
      HealAmount: 缺失生命,
      ItemHeal: false,
      HealEffect: true,
      HealShowText: true,
    });
  }

  Saber设置阿瓦隆(caster, true);
  registerManualBuff(caster, SaberBuffID.阿瓦隆, 配置.D.持续秒, 0, { 来源: caster, 标签: "Saber-D-阿瓦隆" });

  const runtime: D运行时 = {
    caster,
    回蓝回调ID: 0,
    Tick数: 0,
    已启动: true,
  };
  D运行时表[GetHandleId(caster)] = runtime;
  runtime.回蓝回调ID = addPeriodicCallback(
    秒转毫秒(配置.D.回蓝.间隔秒),
    推进D回蓝与粒子 as unknown as (this: void, variable?: any) => void,
    runtime,
  );
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let D监听已注册 = false;

function D单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  if (Saber是否阿瓦隆(dyingUnit) || D运行时表[GetHandleId(dyingUnit)] != null) {
    结束阿瓦隆(dyingUnit);
  }
}

export function 注册SaberD(this: void): void {
  注册单位技能壳监听({
    名称: "Saber-遥远的理想乡（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.D.技能ID,
    获取或创建上下文: 获取或创建D上下文,
    释放技能: 释放D技能,
    创建独立技能实例: false,
  });
  if (!D监听已注册) {
    D监听已注册 = true;
    // 伤害写回前统一修正：阿瓦隆状态判定在回调内部，只注册一次
    registerDamageModifier(阿瓦隆伤害修正, 30);
    registerDeathListener(D单位死亡清理);
  }
}

注册SaberD();

void D类型ID;

export {};
