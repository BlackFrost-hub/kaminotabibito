/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 蕾米莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/03．蕾米莉亚";

const jass = require("jass.common") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 单位存活, 读取单位攻击力, 两点角度, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angle: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angle: number, distance: number) => number;
};
const { 造成批量AOE技能伤害, 创建独立技能伤害实例, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  创建独立技能伤害实例: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { createTimedUnitEffect, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
  读取玩家属性: (this: void, unit: any, attributeName: string) => number;
};
const { getBuffRuntime, registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const A0KR配置 = 蕾米莉亚单位技能配置.额外D;
const A0KR技能ID = stringToFourCCSafe(A0KR配置.技能ID);
const 单位类型ID = 蕾米莉亚单位技能配置.单位类型ID;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

interface 蕾米莉亚A0KR上下文 {
  施法者: any;
  技能实例ID?: number;
  方向角: number;
  伤害: number;
  周期回调ID: number;
  收尾回调ID: number;
  周期次数: number;
  已命中: Record<number, true>;
  已启动: boolean;
}

interface A0KR吸血到期记录 {
  施法者: any;
  数值: number;
}

const 上下文表: Record<number, 蕾米莉亚A0KR上下文 | undefined> = {};
const 吸血层数表: Record<number, number | undefined> = {};

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 获取或创建A0KR上下文(this: void, unit: any): 蕾米莉亚A0KR上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const old = 上下文表[unitId];
  if (old != null) return old;
  const created: 蕾米莉亚A0KR上下文 = {
    施法者: unit,
    方向角: 0,
    伤害: 0,
    周期回调ID: 0,
    收尾回调ID: 0,
    周期次数: 0,
    已命中: {},
    已启动: false,
  };
  上下文表[unitId] = created;
  return created;
}

function A0KR目标允许(this: void, caster: any, target: any, context: 蕾米莉亚A0KR上下文): boolean {
  const targetId = 取单位句柄ID(target);
  return targetId !== 0
    && context.已命中[targetId] !== true
    && 单位存活(target)
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE)
    && jass.IsUnitEnemy(target, GetOwningPlayer(caster)) === true;
}

function A0KR准备目标(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 蕾米莉亚A0KR上下文 | undefined;
  if (context == null || !A0KR目标允许(context.施法者, target, context)) return undefined;
  const targetId = 取单位句柄ID(target);
  context.已命中[targetId] = true;
  createTimedUnitEffect(target, A0KR配置.命中特效.挂点, A0KR配置.命中特效.模型路径, A0KR配置.命中特效持续秒);
  return {
    伤害: context.伤害,
    伤害类型: DAMAGE_TYPE_NORMAL,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
  };
}

function A0KR吸血到期(this: void, variable?: any): void {
  const record = variable as A0KR吸血到期记录 | undefined;
  if (record == null || record.施法者 == null || record.施法者 === 0) return;
  const unitId = 取单位句柄ID(record.施法者);
  const current = 吸血层数表[unitId] ?? 0;
  if (current <= 0) return;
  调整玩家属性(record.施法者, "伤害吸血", -record.数值);
  const next = current - 1;
  吸血层数表[unitId] = next;
  if (next <= 0) {
    delete 吸血层数表[unitId];
    移除单位指定Buff(record.施法者, 蕾米莉亚BuffID.恶魔突袭吸血);
    return;
  }
  const runtime = getBuffRuntime(record.施法者, 蕾米莉亚BuffID.恶魔突袭吸血);
  if (runtime != null) {
    runtime.stack = next;
    runtime.effect = next;
  }
}

function A0KR目标结算后(this: void, target: any, _index: number, success: boolean, variable?: any): void {
  const context = variable as 蕾米莉亚A0KR上下文 | undefined;
  if (context == null || !success) return;
  const value = IsUnitType(target, UNIT_TYPE_HERO) ? A0KR配置.英雄吸血 : A0KR配置.普通单位吸血;
  const unitId = 取单位句柄ID(context.施法者);
  const next = (吸血层数表[unitId] ?? 0) + 1;
  吸血层数表[unitId] = next;
  调整玩家属性(context.施法者, "伤害吸血", value);
  registerManualBuff(context.施法者, 蕾米莉亚BuffID.恶魔突袭吸血, A0KR配置.吸血持续秒, next, {
    sourceName: "蕾米莉亚-恶魔突袭",
    stack: next,
  });
  addDelayedCallback(A0KR配置.吸血持续秒 * 1000, A0KR吸血到期, { 施法者: context.施法者, 数值: value } as A0KR吸血到期记录);
}

function A0KR收尾(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚A0KR上下文 | undefined;
  if (context == null) return;
  context.收尾回调ID = 0;
  if (context.技能实例ID != null) {
    结束独立技能伤害实例(context.技能实例ID);
    context.技能实例ID = undefined;
  }
  for (let i = 0; i < A0KR配置.表现.length; i++) {
    销毁单位坐标跟随特效(context.施法者, A0KR配置.表现[i].特效键);
  }
  context.已启动 = false;
  const casterId = 取单位句柄ID(context.施法者);
  if (casterId !== 0 && 上下文表[casterId] === context) delete 上下文表[casterId];
}

function 清理A0KR上下文(this: void, context: 蕾米莉亚A0KR上下文): void {
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.收尾回调ID !== 0) {
    removeDelayedCallback(context.收尾回调ID);
    context.收尾回调ID = 0;
  }
  if (context.技能实例ID != null) {
    结束独立技能伤害实例(context.技能实例ID);
    context.技能实例ID = undefined;
  }
  for (let i = 0; i < A0KR配置.表现.length; i++) {
    销毁单位坐标跟随特效(context.施法者, A0KR配置.表现[i].特效键);
  }
  context.已启动 = false;
  const casterId = 取单位句柄ID(context.施法者);
  if (casterId !== 0 && 上下文表[casterId] === context) delete 上下文表[casterId];
}

function A0KR周期Tick(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚A0KR上下文 | undefined;
  if (context == null || !context.已启动) return;
  if (!单位存活(context.施法者)) {
    清理A0KR上下文(context);
    return;
  }
  if (context.周期次数 >= A0KR配置.持续次数) {
    if (context.周期回调ID !== 0) {
      removePeriodicCallback(context.周期回调ID);
      context.周期回调ID = 0;
    }
    context.收尾回调ID = addDelayedCallback(150, A0KR收尾, context);
    return;
  }
  context.周期次数 += 1;
  const nextX = 极坐标X(GetUnitX(context.施法者), context.方向角, A0KR配置.速度);
  const nextY = 极坐标Y(GetUnitY(context.施法者), context.方向角, A0KR配置.速度);
  执行战斗自身传送到坐标(context.施法者, nextX, nextY);
  const targets = 获取范围敌军(context.施法者, GetUnitX(context.施法者), GetUnitY(context.施法者), A0KR配置.命中范围);
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    来源类型: "单位技能",
    技能ID: A0KR技能ID,
    技能实例ID: context.技能实例ID,
    伤害形态: "AOE",
    每目标处理器: A0KR准备目标,
    每目标结算后处理器: A0KR目标结算后,
    变量: context,
  });
}

function 释放蕾米莉亚A0KR(this: void, caster: any): void {
  const existing = 上下文表[取单位句柄ID(caster)];
  if (existing != null && existing.已启动) 清理A0KR上下文(existing);
  const context = 获取或创建A0KR上下文(caster);
  if (context == null) return;
  context.方向角 = 两点角度(GetUnitX(caster), GetUnitY(caster), GetSpellTargetX(), GetSpellTargetY());
  context.伤害 = 读取单位攻击力(caster) * A0KR配置.攻击力倍率;
  context.技能实例ID = 创建独立技能伤害实例({ 技能ID: A0KR技能ID, 来源类型: "单位技能", 标签: "蕾米莉亚-恶魔突袭", 持续时间秒: 1 });
  context.周期次数 = 0;
  context.已命中 = {};
  context.已启动 = true;
  for (let i = 0; i < A0KR配置.表现.length; i++) {
    const effect = A0KR配置.表现[i];
    创建单位坐标跟随特效(caster, effect.模型路径, effect.特效键, effect.缩放, A0KR配置.初始高度);
  }
  context.周期回调ID = addPeriodicCallback(A0KR配置.周期间隔毫秒, A0KR周期Tick, context);
}

function 处理蕾米莉亚A0KR(this: void, caster: any, abilityId: number): void {
  if (abilityId !== A0KR技能ID || GetUnitTypeId(caster) !== 单位类型ID || !单位存活(caster)) return;
  释放蕾米莉亚A0KR(caster);
}

function 蕾米莉亚A0KR单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 上下文表[取单位句柄ID(dyingUnit)];
  if (context != null) 清理A0KR上下文(context);
}

registerSpellEffectListener(处理蕾米莉亚A0KR);
registerDeathListener(蕾米莉亚A0KR单位死亡);

export {};
