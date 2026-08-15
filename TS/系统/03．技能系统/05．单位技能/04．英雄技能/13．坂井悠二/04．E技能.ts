/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位最大生命, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff, 移除单位指定Buff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (this: void, unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    intervalSeconds?: number,
  ) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { createTimedEffect, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, height: number, durationSec: number) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => boolean;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;

const 配置 = 坂井悠二技能配置.E;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const E技能ID字符串 = 配置.技能ID;
const E抵挡BuffID = 坂井悠二BuffID.E抵挡;

interface E上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  延迟回调ID: number;
  推进周期回调ID: number;
  推进次数: number;
  推进方向: number;
  推进目标X: number;
  推进目标Y: number;
  推进辅助马甲: any;
}

const 上下文表: Record<number, E上下文 | undefined> = {};
let 死亡监听已注册 = false;
let 伤害回调已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取E上下文(this: void, unit: any): E上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建E上下文(this: void, unit: any): E上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: E上下文 = {
    施法者: unit,
    已启动: false,
    延迟回调ID: 0,
    推进周期回调ID: 0,
    推进次数: 0,
    推进方向: 0,
    推进目标X: 0,
    推进目标Y: 0,
    推进辅助马甲: null,
  };
  上下文表[id] = created;
  return created;
}

function 清理E上下文(this: void, context: E上下文): void {
  if (context.延迟回调ID !== 0) {
    removeDelayedCallback(context.延迟回调ID);
    context.延迟回调ID = 0;
  }
  if (context.推进周期回调ID !== 0) {
    removePeriodicCallback(context.推进周期回调ID);
    context.推进周期回调ID = 0;
  }
  context.已启动 = false;
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 执行E敌人分支(this: void, context: E上下文): void {
  const caster = context.施法者;
  const target = context.推进辅助马甲; // 暂存目标
  if (caster == null || caster === 0 || !单位存活(caster)) return;
  if (target == null || target === 0 || !单位存活(target)) return;

  const 敌人X = GetUnitX(target);
  const 敌人Y = GetUnitY(target);
  const 朝向 = 两点角度(敌人X, 敌人Y, GetUnitX(caster), GetUnitY(caster));

  // 瞬移到敌人面前
  SetUnitX(caster, 敌人X);
  SetUnitY(caster, 敌人Y);
  SetUnitFacing(caster, 朝向);

  // 眩晕
  施加眩晕(caster, target, 配置.敌人分支.眩晕秒, 坂井悠二BuffID.E语法眩晕, "技能");

  // 传送特效
  createTimedUnitEffect(caster, "origin", 配置.敌人分支.传送特效.模型路径, 配置.敌人分支.传送特效.持续秒);
  createTimedUnitEffect(target, "origin", 配置.敌人分支.传送特效.模型路径, 配置.敌人分支.传送特效.持续秒);
}

function 执行E自施法分支(this: void, context: E上下文): void {
  const caster = context.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) return;

  // 注册 75% 减伤 Buff
  registerManualBuff(caster, E抵挡BuffID, 配置.自施法分支.持续秒, 配置.自施法分支.减伤比例, {
    来源: caster,
    来源类型: "技能",
    标签: "坂井悠二-E-语法抵挡",
  });
}

function 推进E目标点(this: void, context?: any): void {
  const ctx = context as E上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理E上下文(ctx);
    return;
  }

  const 步长 = 配置.目标点分支.推进步长;
  const 弧度 = ctx.推进方向 * (3.14159265358979 / 180);
  const 新X = GetUnitX(caster) + 步长 * Math.cos(弧度);
  const 新Y = GetUnitY(caster) + 步长 * Math.sin(弧度);
  SetUnitX(caster, 新X);
  SetUnitY(caster, 新Y);
  ctx.推进次数 = ctx.推进次数 + 1;

  if (ctx.推进次数 >= 配置.目标点分支.最大推进次数) {
    // 传送特效
    createTimedUnitEffect(caster, "origin", 配置.目标点分支.传送特效.模型路径, 配置.目标点分支.传送特效.持续秒);
    清理E上下文(ctx);
  }
}

function 延迟启动E(this: void, context?: any): void {
  const ctx = context as E上下文 | undefined;
  if (ctx == null) return;
  ctx.延迟回调ID = 0;

  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理E上下文(ctx);
    return;
  }

  // 判断分支
  const 目标单位 = GetSpellTargetUnit();
  if (目标单位 != null && 目标单位 !== 0 && 目标单位 !== caster && 单位存活(目标单位)) {
    // 敌方目标分支
    ctx.推进辅助马甲 = 目标单位;
    执行E敌人分支(ctx);
    清理E上下文(ctx);
    return;
  }

  if (目标单位 === caster) {
    // 自施法分支
    执行E自施法分支(ctx);
    清理E上下文(ctx);
    return;
  }

  // 目标点分支
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 起始X = GetUnitX(caster);
  const 起始Y = GetUnitY(caster);
  const 方向 = 两点角度(起始X, 起始Y, 目标X, 目标Y);
  ctx.推进方向 = 方向;
  ctx.推进目标X = 目标X;
  ctx.推进目标Y = 目标Y;
  ctx.推进次数 = 0;

  createTimedUnitEffect(caster, "origin", 配置.目标点分支.传送特效.模型路径, 配置.目标点分支.传送特效.持续秒);

  ctx.推进周期回调ID = addPeriodicCallback(
    配置.目标点分支.推进周期秒 * 1000,
    推进E目标点 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 释放E技能(this: void, context: E上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.延迟回调ID = addDelayedCallback(
    配置.启动延迟秒 * 1000,
    延迟启动E as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function E可释放(this: void, context: E上下文): boolean {
  return !context.已启动 && context.延迟回调ID === 0;
}

function 处理E抵挡受到伤害(
  this: void,
  target: any,
  damage: number,
  _damageType: number,
  _fromDotTickBatch?: boolean,
  _source?: any,
  _isNormalAttack?: boolean,
): void {
  if (target == null || target === 0) return;
  if (!单位存活(target)) return;
  if (GetUnitTypeIdLocal(target) !== 英雄单位类型ID) return;

  const runtime = getBuffRuntime(target, E抵挡BuffID);
  if (runtime == null) return;

  const 当前生命 = GetUnitState(target, UNIT_STATE_LIFE);
  const 最大生命 = 读取单位最大生命(target);
  const 阈值 = 最大生命 * 配置.自施法分支.单次伤害阈值最大生命比例;

  // 阈值触发或致死
  if (damage >= 阈值 || damage >= 当前生命) {
    // 播放破除特效
    createTimedUnitEffect(target, "origin", 配置.自施法分支.破除特效.模型路径, 配置.自施法分支.破除特效.持续秒);
    // 音效
    Sound3DII_UnitPlayReuse(配置.自施法分支.音效.路径, target, 配置.自施法分支.音效.裁断距离);
    移除单位指定Buff(target, E抵挡BuffID);
  }
}

function GetUnitTypeIdLocal(unit: any): number {
  return (jass.GetUnitTypeId as (this: void, u: any) => number)(unit);
}

function E单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取E上下文(dyingUnit);
  if (context != null) 清理E上下文(context);
  if (GetUnitTypeIdLocal(dyingUnit) === 英雄单位类型ID) {
    移除单位指定Buff(dyingUnit, E抵挡BuffID);
  }
}

function 确保E伤害监听(this: void): void {
  if (伤害回调已注册) return;
  伤害回调已注册 = true;
  registerDamageCallback(处理E抵挡受到伤害);
}

export function 注册坂井悠二E(this: void): void {
  确保E伤害监听();
  注册单位技能壳监听({
    名称: "坂井悠二-Grammatica「语法」（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: E技能ID字符串,
    获取或创建上下文: 获取或创建E上下文,
    可释放: E可释放,
    释放技能: 释放E技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(E单位死亡);
  }
}

注册坂井悠二E();

export const 坂井悠二E技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "无直接伤害（控制/位移/抵挡）",
  分支: "敌方目标瞬移+0.5秒眩晕 / 自施法抵挡1.5秒+75%减伤 / 目标点推进",
} as const;
