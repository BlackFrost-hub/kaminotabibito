/** @noSelfInFile */

import { 一方通行单位技能配置 } from "./00．配置";
import { 一方通行BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/07．一方通行";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const {
  registerPointOrderListener,
  registerTargetOrderListener,
  registerImmediateOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, target: any, item: any, destructable: any) => void) => void;
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进") as {
  沿角度步进直到地形阻挡: (this: void, params: any) => { 最终X: number; 最终Y: number; 实际步数: number; 是否提前停止: boolean };
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const 单位类型ID = stringToFourCCSafe(一方通行单位技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(一方通行单位技能配置.Q技能ID);
const Q关闭技能ID = stringToFourCCSafe(一方通行单位技能配置.Q关闭技能ID);
const Q状态技能ID = stringToFourCCSafe(一方通行单位技能配置.Q状态技能ID);
const 配置 = 一方通行单位技能配置.Q;
const Q运行时表: Record<number, Q运行时 | undefined> = {};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const ResetUnitAnimation = jass.ResetUnitAnimation as (this: void, unit: any) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY as any;
const EXSetUnitMoveType = japi.EXSetUnitMoveType as (this: void, unit: any, moveType: number) => void;

interface Q运行时 {
  unit: any;
  active: boolean;
  targetX: number;
  targetY: number;
  tickId: number;
}

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0
    && !jass.IsUnitType(unit, UNIT_TYPE_DEAD)
    && GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0.405;
}

function 获取Q运行时(this: void, unit: any): Q运行时 | undefined {
  return Q运行时表[取单位ID(unit)];
}

function 停止矢量移动(this: void, unit: any): void {
  const id = 取单位ID(unit);
  const runtime = Q运行时表[id];
  if (runtime == null || !runtime.active) return;
  runtime.active = false;
  if (runtime.tickId !== 0) {
    removePeriodicCallback(runtime.tickId);
    runtime.tickId = 0;
  }
  移除单位指定Buff(unit, 一方通行BuffID.矢量移动);
  UnitRemoveAbility(unit, Q关闭技能ID);
  UnitRemoveAbility(unit, Q状态技能ID);
  SetPlayerAbilityAvailable(GetOwningPlayer(unit), Q技能ID, true);
  ResetUnitAnimation(unit);
  EXSetUnitMoveType(unit, 0x02);
  delete Q运行时表[id];
}

function 矢量移动Tick(this: void, variable?: any): void {
  const runtime = variable as Q运行时 | undefined;
  if (runtime == null || !runtime.active || !单位存活(runtime.unit)) {
    if (runtime != null) 停止矢量移动(runtime.unit);
    return;
  }

  const caster = runtime.unit;
  const maxMana = GetUnitState(caster, UNIT_STATE_MAX_MANA) || 0;
  const currentMana = GetUnitState(caster, UNIT_STATE_MANA) || 0;
  if (maxMana <= 0 || currentMana / maxMana < 配置.强制关闭魔法比例) {
    停止矢量移动(caster);
    return;
  }

  const currentX = GetUnitX(caster);
  const currentY = GetUnitY(caster);
  const dx = runtime.targetX - currentX;
  const dy = runtime.targetY - currentY;
  const distance = Math.sqrt(dx * dx + dy * dy);
  if (distance <= 配置.到达距离) {
    停止矢量移动(caster);
    return;
  }

  const angle = Math.atan2(dy, dx) * 180 / Math.PI;
  const speedPerTick = ((GetUnitMoveSpeed(caster) || 0) + 配置.额外移动速度) * 配置.移动周期毫秒 / 1000;
  const step = Math.min(distance, speedPerTick);
  const next = 沿角度步进直到地形阻挡({
    起点X: currentX,
    起点Y: currentY,
    角度度: angle,
    单步距离: step,
    步数: 1,
  });

  const manaCost = (配置.持续固定魔耗每秒 + maxMana * 配置.持续魔耗比例每秒) * 配置.移动周期毫秒 / 1000;
  减少魔法值(caster, manaCost, false, false);
  const trailModel = IsTerrainPathable(currentX, currentY, PATHING_TYPE_FLOATABILITY) === false
    ? 配置.浮空尾迹模型
    : 配置.地面尾迹模型;
  创建点特效({
    模型路径: trailModel,
    X: currentX,
    Y: currentY,
    Z: GetUnitFlyHeight(caster),
    持续秒: 配置.尾迹持续秒,
  });

  if (next.实际步数 <= 0) {
    停止矢量移动(caster);
    return;
  }
  SetUnitX(caster, next.最终X);
  SetUnitY(caster, next.最终Y);
  SetUnitFacing(caster, angle);
  SetUnitAnimationByIndex(caster, 9);
}

function 开始向目标移动(this: void, unit: any, x: number, y: number): void {
  const runtime = 获取Q运行时(unit);
  if (runtime == null || !runtime.active) return;
  runtime.targetX = x;
  runtime.targetY = y;
  Sound3DII_UnitPlayReuse(配置.施法音效路径, unit, 配置.施法音效裁断距离);
  if (runtime.tickId === 0) {
    EXSetUnitMoveType(unit, 0x01);
    runtime.tickId = addPeriodicCallback(配置.移动周期毫秒, 矢量移动Tick, runtime);
  }
}

function on一方通行Q点指令(this: void, unit: any, _orderId: number, x: number, y: number): void {
  if (GetUnitTypeId(unit) !== 单位类型ID) return;
  开始向目标移动(unit, x, y);
}

function on一方通行Q目标指令(this: void, unit: any, _orderId: number, target: any): void {
  if (GetUnitTypeId(unit) !== 单位类型ID || target == null || target === 0) return;
  开始向目标移动(unit, GetUnitX(target), GetUnitY(target));
}

function on一方通行Q立即指令(this: void, unit: any, _orderId: number): void {
  if (GetUnitTypeId(unit) !== 单位类型ID) return;
  const runtime = 获取Q运行时(unit);
  if (runtime != null && runtime.active) 停止矢量移动(unit);
}

function 释放矢量移动(this: void, _context: any, caster: any): void {
  if (GetUnitTypeId(caster) !== 单位类型ID || !单位存活(caster)) return;
  if (获取Q运行时(caster)?.active === true) return;
  const maxMana = GetUnitState(caster, UNIT_STATE_MAX_MANA) || 0;
  const cost = maxMana * 配置.启动魔耗比例;
  if (maxMana <= 0 || (GetUnitState(caster, UNIT_STATE_MANA) || 0) < cost) return;

  减少魔法值(caster, cost, false, false);
  const runtime: Q运行时 = { unit: caster, active: true, targetX: GetUnitX(caster), targetY: GetUnitY(caster), tickId: 0 };
  Q运行时表[取单位ID(caster)] = runtime;
  UnitAddAbility(caster, Q关闭技能ID);
  UnitAddAbility(caster, Q状态技能ID);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q技能ID, false);
  registerManualBuff(caster, 一方通行BuffID.矢量移动, 3600, 配置.额外移动速度, {
    sourceUnit: caster,
    effectSourceName: "一方通行-矢量移动",
    effectSourceType: "技能",
  });
  Sound3DII_UnitPlayReuse(配置.施法音效路径, caster, 配置.施法音效裁断距离);
}

function 释放关闭矢量移动(this: void, _context: any, caster: any): void {
  if (GetUnitTypeId(caster) === 单位类型ID) 停止矢量移动(caster);
}

function 获取Q监听上下文(this: void, unit: any): { unit: any } {
  return { unit };
}

注册单位技能壳监听({
  名称: "一方通行-矢量移动",
  单位类型ID: 一方通行单位技能配置.单位类型ID,
  技能ID: 一方通行单位技能配置.Q技能ID,
  获取或创建上下文: 获取Q监听上下文,
  释放技能: 释放矢量移动,
  创建独立技能实例: false,
});
注册单位技能壳监听({
  名称: "一方通行-关闭矢量移动",
  单位类型ID: 一方通行单位技能配置.单位类型ID,
  技能ID: 一方通行单位技能配置.Q关闭技能ID,
  获取或创建上下文: 获取Q监听上下文,
  释放技能: 释放关闭矢量移动,
  创建独立技能实例: false,
});
registerPointOrderListener(on一方通行Q点指令);
registerTargetOrderListener(on一方通行Q目标指令);
registerImmediateOrderListener(on一方通行Q立即指令);

export {};
