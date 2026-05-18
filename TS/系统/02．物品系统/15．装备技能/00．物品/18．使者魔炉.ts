/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const CreateTimer = jass.CreateTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者魔炉物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔炉配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

const 命中率字段 = "命中率";

interface 使者魔炉特效上下文 {
  特效: any;
  次数: number;
}

interface 使者魔炉恢复上下文 {
  特效: any;
  目标列表: any[];
}

const 特效放大表: Record<number, 使者魔炉特效上下文 | undefined> = {};
const 命中恢复表: Record<number, 使者魔炉恢复上下文 | undefined> = {};

function 是否为使者魔炉(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 使者魔炉物品ID;
}

function 调整命中率(this: void, 单位: any, 变化值: number): void {
  if (单位 == null || 单位 === 0) return;
  const 已存值 = YDUserDataGet("unit", 单位, 命中率字段, "real");
  const 当前值 = 已存值 == null ? 0 : 已存值 as number;
  YDUserDataSet("unit", 单位, 命中率字段, "real", 当前值 + 变化值);
}

function on使者魔炉特效放大(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 上下文 = 特效放大表[timerID];
  if (上下文 == null) {
    DestroyTimer(timer);
    return;
  }
  上下文.次数 += 1;
  if (上下文.次数 >= 使者魔炉配置.特效放大次数) {
    delete 特效放大表[timerID];
    DestroyTimer(timer);
    return;
  }
  EXSetEffectSize(上下文.特效, 使者魔炉配置.特效放大基值 + 上下文.次数);
}

function on使者魔炉命中恢复(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 上下文 = 命中恢复表[timerID];
  delete 命中恢复表[timerID];
  if (上下文 != null) {
    for (let i = 0; i < 上下文.目标列表.length; i++) {
      调整命中率(上下文.目标列表[i], 使者魔炉配置.命中率削减);
    }
    if (上下文.特效 != null && 上下文.特效 !== 0) {
      DestroyEffect(上下文.特效);
    }
  }
  DestroyTimer(timer);
}

function 启动特效放大(this: void, 特效: any): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  特效放大表[GetHandleId(timer)] = { 特效, 次数: 0 };
  TimerStart(timer, 使者魔炉配置.特效放大周期, true, on使者魔炉特效放大);
}

function 启动命中恢复(this: void, 特效: any, 目标列表: any[]): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  命中恢复表[GetHandleId(timer)] = { 特效, 目标列表 };
  TimerStart(timer, 使者魔炉配置.恢复延迟, false, on使者魔炉命中恢复);
}

export function 处理使者魔炉使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使者魔炉(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 特效 = AddSpecialEffectTarget(使者魔炉配置.特效路径, 目标单位, 使者魔炉配置.特效挂点);
  if (特效 != null && 特效 !== 0) {
    启动特效放大(特效);
  }

  const 命中目标列表: any[] = [];
  const 敌人列表 = 获取坐标范围敌人(施法单位, GetUnitX(目标单位), GetUnitY(目标单位), 使者魔炉配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 施法单位)) continue;
    调整命中率(敌人, -使者魔炉配置.命中率削减);
    命中目标列表.push(敌人);
  }
  启动命中恢复(特效, 命中目标列表);
}

export {};
