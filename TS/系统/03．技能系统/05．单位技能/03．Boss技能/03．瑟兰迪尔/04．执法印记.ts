/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { 获取Boss技能应攻击目标, 获取Boss技能最近敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能应攻击目标: (this: void, boss: any) => { targetRef: any } | null;
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
};
const { setThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  setThreat: (this: void, 敌人: any, 仇恨目标: any, 数值: number) => void;
};
const { 设置强制攻击目标, 设置当前目标 } = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  设置强制攻击目标: (this: void, 敌人: any, 目标: any, 持续毫秒: number) => void;
  设置当前目标: (this: void, 敌人ID: number, 目标ID: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};

const jass = require("jass.common") as any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (unit: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;

const 瑟兰迪尔单位ID = stringToFourCC("N057");
let 伤害修正已注册 = false;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 获取本次印记增伤(this: void): number {
  const config = 瑟兰迪尔数值与表现配置.执法印记;
  return 取当前有效玩家人数() <= 1 ? config.单人额外伤害加成 : config.Boss对标记目标伤害加成;
}

function on执法印记伤害修正(this: void, context: any): number {
  const config = 瑟兰迪尔数值与表现配置.执法印记;
  if (!单位有效(context.attacker) || !单位有效(context.target)) return context.currentDamage;
  if (GetUnitTypeId(context.attacker) !== 瑟兰迪尔单位ID) return context.currentDamage;
  const buffRuntime = getBuffRuntime(context.target, config.BuffID);
  if (buffRuntime == null || buffRuntime.effect <= 0) return context.currentDamage;
  return context.currentDamage * (1 + buffRuntime.effect);
}

function 确保执法印记伤害修正(this: void): void {
  if (伤害修正已注册) return;
  伤害修正已注册 = true;
  registerDamageModifier(on执法印记伤害修正, 35);
}

export function 尝试触发瑟兰迪尔执法印记(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.执法印记;
  const now = getServerTime();
  if (context.上次执法印记Ms > 0 && now - context.上次执法印记Ms < config.周期秒 * 1000) return;
  context.上次执法印记Ms = now;

  const threatTarget = 获取Boss技能应攻击目标(context.Boss单位);
  const target = threatTarget?.targetRef ?? 获取Boss技能最近敌对英雄(context.Boss单位);
  if (!单位有效(target)) return;

  释放瑟兰迪尔执法印记(context, target);
}

export function 释放瑟兰迪尔执法印记(this: void, context: 瑟兰迪尔运行时上下文, target: any): void {
  const config = 瑟兰迪尔数值与表现配置.执法印记;
  if (!单位有效(context.Boss单位) || !单位有效(target)) return;
  const bonus = 获取本次印记增伤();
  const durationMs = config.持续秒 * 1000;
  setThreat(context.Boss单位, target, 1000);
  设置强制攻击目标(context.Boss单位, target, durationMs);
  IssueTargetOrder(context.Boss单位, "attack", target);
  设置当前目标(GetHandleId(context.Boss单位), GetHandleId(target));
  registerManualBuff(target, config.BuffID, config.持续秒, bonus, {
    sourceName: GetUnitName(context.Boss单位),
    iconOverride: "BuffIcon\\Boss\\Thranduil\\zhifayinji.blp",
    effectModelOverride: config.特效,
  });
}

export function 注册瑟兰迪尔执法印记(this: void): void {
  确保执法印记伤害修正();
}
