/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const CreateTimer = jass.CreateTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 熔岩恶魔之灵眼物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 熔岩恶魔之灵眼配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

const 命中率字段 = "命中率";
const 灵眼恢复表: Record<number, any | undefined> = {};

function 是否为熔岩恶魔之灵眼(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 熔岩恶魔之灵眼物品ID;
}

function 调整命中率(this: void, 单位: any, 变化值: number): void {
  if (单位 == null || 单位 === 0) return;
  const 已存值 = YDUserDataGet("unit", 单位, 命中率字段, "real");
  const 当前值 = 已存值 == null ? 0 : 已存值 as number;
  YDUserDataSet("unit", 单位, 命中率字段, "real", 当前值 + 变化值);
}

function on灵眼命中率恢复(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 目标单位 = 灵眼恢复表[timerID];
  delete 灵眼恢复表[timerID];
  if (目标单位 != null && 目标单位 !== 0) {
    调整命中率(目标单位, 熔岩恶魔之灵眼配置.命中率削减);
  }
  DestroyTimer(timer);
}

function 延迟恢复命中率(this: void, 目标单位: any): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  灵眼恢复表[GetHandleId(timer)] = 目标单位;
  TimerStart(timer, 熔岩恶魔之灵眼配置.命中率恢复延迟, false, on灵眼命中率恢复);
}

export function 处理熔岩恶魔之灵眼使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("16．熔岩恶魔之灵眼", "进入", "处理熔岩恶魔之灵眼使用");

  if (!是否为熔岩恶魔之灵眼(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.魔力之焰闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
  创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.死亡之指闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
  SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MANA) - GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.魔法消耗比例);
  createUnitEffect(目标单位, 熔岩恶魔之灵眼配置.特效挂点, 熔岩恶魔之灵眼配置.特效路径, 熔岩恶魔之灵眼配置.特效持续时间, "熔岩恶魔之灵眼");
  调整命中率(目标单位, -熔岩恶魔之灵眼配置.命中率削减);
  UnitDamageTarget(施法单位, 目标单位, GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.伤害魔法系数, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
  延迟恢复命中率(目标单位);
}

export {};
