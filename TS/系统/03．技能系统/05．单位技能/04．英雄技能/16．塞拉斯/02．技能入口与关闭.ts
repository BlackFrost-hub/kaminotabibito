/** @noSelfInFile */
// 塞拉斯 Q 入口（A0JT）/ 关闭入口（A0JV）/ 元素施法后自动关闭。
// 源 JASS：开启与关闭都在 0.15 秒后同步切换技能可用性和等级；元素技能施放后同样 0.15 秒自动关闭。

import { 塞拉斯技能配置 } from "./00．配置";
import {
  获取或创建塞拉斯魔法状态,
  清理塞拉斯魔法状态,
} from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, flag: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const SetUnitAbilityLevel = jass.SetUnitAbilityLevel as (this: void, unit: any, abilityId: number, level: number) => void;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;

const 配置 = 塞拉斯技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const Q入口类型ID = 配置.Q入口.技能类型ID;
const 关闭入口类型ID = 配置.关闭入口.技能类型ID;
const 火焰类型ID = 配置.元素魔法.火焰技能类型ID;
const 冰冻类型ID = 配置.元素魔法.冰冻技能类型ID;
const 雷击类型ID = 配置.元素魔法.雷击技能类型ID;
const W类型ID = 配置.W.技能类型ID;
const E类型ID = 配置.E.技能类型ID;
const R类型ID = 配置.R.技能类型ID;

let 死亡监听已注册 = false;

function 确保塞拉斯元素技能存在(this: void, caster: any): void {
  // 防御性补挂：物编 heroAbilList 不含 A0JQ/A0JR/A0JS/A0JV，开启时确保单位拥有这些技能
  UnitAddAbility(caster, 关闭入口类型ID);
  UnitAddAbility(caster, 火焰类型ID);
  UnitAddAbility(caster, 冰冻类型ID);
  UnitAddAbility(caster, 雷击类型ID);
}

function 执行开启切换(this: void, variable?: any): void {
  const caster = variable as any;
  if (caster == null || caster === 0) return;
  const state = 获取或创建塞拉斯魔法状态(caster);
  if (state != null) state.开启回调ID = 0;

  const player = GetOwningPlayer(caster);
  if (player == null || player === 0) return;

  确保塞拉斯元素技能存在(caster);

  // 同步等级：元素技能等级 = A0JT 等级
  const 入口等级 = GetUnitAbilityLevel(caster, Q入口类型ID);
  if (入口等级 > 0) {
    SetUnitAbilityLevel(caster, 火焰类型ID, 入口等级);
    SetUnitAbilityLevel(caster, 冰冻类型ID, 入口等级);
    SetUnitAbilityLevel(caster, 雷击类型ID, 入口等级);
  }

  // 同步可用性切换
  SetPlayerAbilityAvailable(player, 火焰类型ID, true);
  SetPlayerAbilityAvailable(player, 冰冻类型ID, true);
  SetPlayerAbilityAvailable(player, 雷击类型ID, true);
  SetPlayerAbilityAvailable(player, Q入口类型ID, false);
  SetPlayerAbilityAvailable(player, W类型ID, false);
  SetPlayerAbilityAvailable(player, E类型ID, false);
  SetPlayerAbilityAvailable(player, R类型ID, false);

  if (state != null) {
    state.普通魔法已开启 = true;
    state.普通魔法技能等级 = 入口等级;
  }
}

function 执行关闭切换(this: void, variable?: any): void {
  const caster = variable as any;
  if (caster == null || caster === 0) return;
  const state = 获取或创建塞拉斯魔法状态(caster);
  if (state != null) state.关闭回调ID = 0;

  const player = GetOwningPlayer(caster);
  if (player == null || player === 0) return;

  UnitRemoveAbility(caster, 关闭入口类型ID);

  SetPlayerAbilityAvailable(player, 火焰类型ID, false);
  SetPlayerAbilityAvailable(player, 冰冻类型ID, false);
  SetPlayerAbilityAvailable(player, 雷击类型ID, false);
  SetPlayerAbilityAvailable(player, Q入口类型ID, true);
  SetPlayerAbilityAvailable(player, W类型ID, true);
  SetPlayerAbilityAvailable(player, E类型ID, true);
  SetPlayerAbilityAvailable(player, R类型ID, true);

  if (state != null) {
    state.普通魔法已开启 = false;
    state.当前元素 = "";
  }
}

function 请求开启普通魔法(this: void, caster: any): void {
  const state = 获取或创建塞拉斯魔法状态(caster);
  if (state == null) return;
  // 重复开启：先清理旧回调再建立新状态
  if (state.开启回调ID !== 0) removeDelayedCallback(state.开启回调ID);
  if (state.关闭回调ID !== 0) {
    removeDelayedCallback(state.关闭回调ID);
    state.关闭回调ID = 0;
  }
  state.开启回调ID = addDelayedCallback(配置.Q入口.切换延迟秒 * 1000, 执行开启切换, caster);
}

function 请求关闭普通魔法(this: void, caster: any, 重置Q冷却: boolean): void {
  const state = 获取或创建塞拉斯魔法状态(caster);
  if (state == null) return;
  if (state.关闭回调ID !== 0) removeDelayedCallback(state.关闭回调ID);
  if (state.开启回调ID !== 0) {
    removeDelayedCallback(state.开启回调ID);
    state.开启回调ID = 0;
  }
  if (重置Q冷却) {
    // 源 JASS：A0JV 施放时 A0JT 冷却归零（审计保留）
    技能_设置技能冷却时间(caster, Q入口类型ID, 0, 配置.Q入口.技能类型ID > 0 ? 0.01 : 0.01);
  }
  state.关闭回调ID = addDelayedCallback(配置.关闭入口.切换延迟秒 * 1000, 执行关闭切换, caster);
}

/** 元素魔法施放后调用：0.15 秒后自动关闭面板（源 JASS 行为，大魔法二连击在同一次施法内结算，不受影响） */
export function 塞拉斯元素施法后自动关闭(this: void, caster: any): void {
  请求关闭普通魔法(caster, false);
}

function Q入口上下文(this: void, unit: any): { 施法者: any } | undefined {
  if (unit == null || unit === 0) return undefined;
  return { 施法者: unit };
}

function 释放Q入口(this: void, context: { 施法者: any }, caster: any): void {
  请求开启普通魔法(caster);
}

function 释放关闭入口(this: void, context: { 施法者: any }, caster: any): void {
  请求关闭普通魔法(caster, 配置.关闭入口.重置Q入口冷却);
}

function 塞拉斯入口单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  清理塞拉斯魔法状态(dyingUnit);
}

export function 注册塞拉斯技能入口(this: void): void {
  注册单位技能壳监听({
    名称: "塞拉斯-魔法知识（Q入口）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q入口.技能ID,
    获取或创建上下文: Q入口上下文,
    释放技能: 释放Q入口,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "塞拉斯-魔法知识关闭（A0JV）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.关闭入口.技能ID,
    获取或创建上下文: Q入口上下文,
    释放技能: 释放关闭入口,
    创建独立技能实例: false,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(塞拉斯入口单位死亡);
  }
}

注册塞拉斯技能入口();
