/** @noSelfInFile */

const jass = require("jass.common") as any;
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (
    this: void,
    target: any,
    attacker: any,
    applied: number,
    snapshot: any
  ) => void) => void;
};
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  offTick10ms: (this: void, callback: (this: void) => void) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const IsUnitAlly = jass.IsUnitAlly as (whichUnit: any, whichPlayer: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (whichUnit: any, whichPlayer: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const SetUnitState = jass.SetUnitState as (whichUnit: any, whichUnitState: any, newVal: number) => void;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者魔轮物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔轮配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

type 使者魔轮魔盾实例 = {
  id: number;
  施法单位: any;
  施法玩家: any;
  特效: any;
  x: number;
  y: number;
  剩余时间: number;
  作用半径: number;
  护盾值: number;
};

const 使者魔轮魔盾表: Record<number, 使者魔轮魔盾实例 | undefined> = {};
const 使者魔轮魔盾ID列表: number[] = [];
let 已注册使者魔轮伤害监听 = false;
let 已注册使者魔轮中心计时器 = false;

function 是否为使者魔轮(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  if (使者魔轮物品ID <= 0) return false;
  return GetItemTypeId(物品) === 使者魔轮物品ID;
}

function 从列表移除魔盾ID(this: void, id: number): void {
  for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
    if (使者魔轮魔盾ID列表[i] === id) {
      使者魔轮魔盾ID列表.splice(i, 1);
      return;
    }
  }
}

function 尝试关闭使者魔轮中心计时器(this: void): void {
  if (!已注册使者魔轮中心计时器) return;
  if (使者魔轮魔盾ID列表.length > 0) return;
  已注册使者魔轮中心计时器 = false;
  offTick10ms(on使者魔轮中心计时器Tick);
}

function 移除使者魔轮魔盾(this: void, id: number): void {
  const 实例 = 使者魔轮魔盾表[id];
  if (实例 == null) return;
  delete 使者魔轮魔盾表[id];
  从列表移除魔盾ID(id);
  if (实例.特效 != null && 实例.特效 !== 0) DestroyEffect(实例.特效);
  尝试关闭使者魔轮中心计时器();
}

function 确保使者魔轮中心计时器(this: void): void {
  if (已注册使者魔轮中心计时器) return;
  已注册使者魔轮中心计时器 = true;
  onTick10ms(on使者魔轮中心计时器Tick);
}

function on使者魔轮中心计时器Tick(this: void): void {
  for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
    const id = 使者魔轮魔盾ID列表[i];
    const 实例 = 使者魔轮魔盾表[id];
    if (实例 == null || 实例.护盾值 <= 0) {
      移除使者魔轮魔盾(id);
      continue;
    }

    实例.剩余时间 = 实例.剩余时间 - 0.01;
    if (实例.剩余时间 <= 0) 移除使者魔轮魔盾(id);
  }
  尝试关闭使者魔轮中心计时器();
}

function 确保使者魔轮伤害监听(this: void): void {
  if (已注册使者魔轮伤害监听) return;
  已注册使者魔轮伤害监听 = true;
  registerAppliedFinalDamageListener(on使者魔轮伤害事件);
}

function 受伤单位在魔盾内(this: void, 实例: 使者魔轮魔盾实例, 受伤单位: any): boolean {
  if (受伤单位 == null || 受伤单位 === 0) return false;
  const dx = GetUnitX(受伤单位) - 实例.x;
  const dy = GetUnitY(受伤单位) - 实例.y;
  if (dx * dx + dy * dy > 实例.作用半径 * 实例.作用半径) return false;
  if (IsUnitAlly(受伤单位, 实例.施法玩家)) return true;
  return IsUnitOwnedByPlayer(受伤单位, 实例.施法玩家);
}

function 吸收使者魔轮伤害(this: void, 实例: 使者魔轮魔盾实例, 受伤单位: any, 伤害值: number): void {
  SetUnitState(受伤单位, UNIT_STATE_LIFE, GetUnitState(受伤单位, UNIT_STATE_LIFE) + 伤害值);
  实例.护盾值 = 实例.护盾值 - 伤害值;
}

function on使者魔轮伤害事件(
  this: void,
  受伤单位: any,
  _攻击者: any,
  伤害值: number,
  _snapshot?: any
): void {
  if (受伤单位 == null || 受伤单位 === 0 || !(伤害值 > 0)) return;

  for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
    const id = 使者魔轮魔盾ID列表[i];
    const 实例 = 使者魔轮魔盾表[id];
    if (实例 == null || 实例.护盾值 <= 0) {
      移除使者魔轮魔盾(id);
      continue;
    }
    if (!受伤单位在魔盾内(实例, 受伤单位)) continue;

    吸收使者魔轮伤害(实例, 受伤单位, 伤害值);
    if (实例.护盾值 <= 0) 移除使者魔轮魔盾(id);
  }
}

function 注册使者魔轮魔盾(this: void, 施法单位: any, x: number, y: number, 护盾值: number): void {
  const 特效 = EC_CreateEffect(使者魔轮配置.特效路径, x, y, 0, 0, 使者魔轮配置.特效尺寸, 1, -1);
  if (特效 == null || 特效 === 0) return;

  const id = GetHandleId(特效);
  if (id <= 0) {
    DestroyEffect(特效);
    return;
  }

  使者魔轮魔盾表[id] = {
    id,
    施法单位,
    施法玩家: GetOwningPlayer(施法单位),
    特效,
    x,
    y,
    剩余时间: 使者魔轮配置.持续时间,
    作用半径: 使者魔轮配置.作用半径,
    护盾值,
  };
  使者魔轮魔盾ID列表.push(id);
  确保使者魔轮伤害监听();
  确保使者魔轮中心计时器();
}

export function 处理使者魔轮使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使者魔轮(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 最大魔法 = GetUnitState(施法单位, UNIT_STATE_MAX_MANA);
  const 消耗魔法 = 最大魔法 * 使者魔轮配置.消耗魔法比例;
  if (!(消耗魔法 > 0)) return;

  SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MANA) - 消耗魔法);
  注册使者魔轮魔盾(施法单位, 上下文.目标X, 上下文.目标Y, 消耗魔法);
}

export {};
