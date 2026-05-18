/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const R2I = jass.R2I as (value: number) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const CreateTimer = jass.CreateTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 咆哮之心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 咆哮之心配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

interface 咆哮之心上下文 {
  施法单位: any;
  目标单位: any;
  附加攻击: number;
  次数: number;
}

const 咆哮之心表: Record<number, 咆哮之心上下文 | undefined> = {};

function 是否为咆哮之心(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 咆哮之心物品ID;
}

function on咆哮之心周期(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 上下文 = 咆哮之心表[timerID];
  if (上下文 == null) {
    DestroyTimer(timer);
    return;
  }
  if (上下文.次数 >= 咆哮之心配置.次数) {
    SGSS_SetState(上下文.目标单位, 1, -上下文.附加攻击);
    delete 咆哮之心表[timerID];
    DestroyTimer(timer);
    return;
  }
  上下文.次数 += 1;
  createTimedEffect(咆哮之心配置.特效路径, GetUnitX(上下文.目标单位), GetUnitY(上下文.目标单位), 0, 咆哮之心配置.特效持续时间);
  UnitDamageTarget(上下文.施法单位, 上下文.目标单位, 咆哮之心配置.每跳伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
}

export function 处理咆哮之心使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("25．咆哮之心", "进入", "处理咆哮之心使用");

  if (!是否为咆哮之心(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 附加攻击 = R2I(GetUnitState(目标单位, ConvertUnitState(0x15))) / 咆哮之心配置.力量转攻击除数;
  SGSS_SetState(目标单位, 1, 附加攻击);
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  咆哮之心表[GetHandleId(timer)] = { 施法单位, 目标单位, 附加攻击, 次数: 0 };
  TimerStart(timer, 咆哮之心配置.周期, true, on咆哮之心周期);
}

export {};
