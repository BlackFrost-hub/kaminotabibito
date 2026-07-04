/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const R2I = jass.R2I as (value: number) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 咆哮之心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 咆哮之心配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 施加临时属性效果, type 临时属性效果实例 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

interface 咆哮之心上下文 {
  施法单位: any;
  目标单位: any;
  属性效果: 临时属性效果实例;
  次数: number;
  timerID: number;
}

function 是否为咆哮之心(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 咆哮之心物品ID;
}

function on咆哮之心周期(this: void, 上下文: 咆哮之心上下文): void {
  if (上下文.次数 >= 咆哮之心配置.次数) {
    上下文.属性效果.清除();
    removePeriodicCallback(上下文.timerID);
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
  const 属性效果 = 施加临时属性效果(目标单位, (咆哮之心配置.次数 + 1) * 咆哮之心配置.周期 * 1000, [{ 类型: "攻击", 数值: 附加攻击 }]);
  const 周期上下文: 咆哮之心上下文 = { 施法单位, 目标单位, 属性效果, 次数: 0, timerID: 0 };
  周期上下文.timerID = addPeriodicCallback(咆哮之心配置.周期 * 1000, () => on咆哮之心周期(周期上下文));
}

export {};
