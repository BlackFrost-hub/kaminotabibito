/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params?: any) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const CreateTimer = jass.CreateTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 史诗远古魔刃物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 史诗远古魔刃配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

interface 魔刃扫掠上下文 {
  施法单位: any;
  x: number;
  y: number;
  角度: number;
  次数: number;
  已命中: Record<number, boolean | undefined>;
}

const 扫掠表: Record<number, 魔刃扫掠上下文 | undefined> = {};

function 是否为史诗远古魔刃(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 史诗远古魔刃物品ID;
}

function on史诗远古魔刃扫掠(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 上下文 = 扫掠表[timerID];
  if (上下文 == null) {
    DestroyTimer(timer);
    return;
  }
  if (上下文.次数 >= 史诗远古魔刃配置.最大次数) {
    delete 扫掠表[timerID];
    DestroyTimer(timer);
    return;
  }

  上下文.次数 += 1;
  上下文.x += Cos(上下文.角度) * 史诗远古魔刃配置.每次距离;
  上下文.y += Sin(上下文.角度) * 史诗远古魔刃配置.每次距离;
  createTimedEffect(史诗远古魔刃配置.特效路径, 上下文.x, 上下文.y, 0, 史诗远古魔刃配置.特效持续时间);

  const 伤害值 = GetUnitState(上下文.施法单位, ConvertUnitState(0x15)) * 史诗远古魔刃配置.力量系数;
  const 敌人列表 = 获取坐标范围敌人(上下文.施法单位, 上下文.x, 上下文.y, 史诗远古魔刃配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 上下文.施法单位)) continue;
    const 敌人ID = GetHandleId(敌人);
    if (上下文.已命中[敌人ID]) continue;
    上下文.已命中[敌人ID] = true;
    UnitDamageTarget(上下文.施法单位, 敌人, 伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    施加扩展控制(上下文.施法单位, 敌人, "stun", { 持续时间: 史诗远古魔刃配置.眩晕时间 });
  }
}

export function 处理史诗远古魔刃使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("22．史诗远古魔刃", "进入", "处理史诗远古魔刃使用");

  if (!是否为史诗远古魔刃(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 起点X = GetUnitX(施法单位);
  const 起点Y = GetUnitY(施法单位);
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  扫掠表[GetHandleId(timer)] = {
    施法单位,
    x: 起点X,
    y: 起点Y,
    角度: Atan2(上下文.目标Y - 起点Y, 上下文.目标X - 起点X),
    次数: 0,
    已命中: {},
  };
  TimerStart(timer, 史诗远古魔刃配置.周期, true, on史诗远古魔刃扫掠);
}

export {};
