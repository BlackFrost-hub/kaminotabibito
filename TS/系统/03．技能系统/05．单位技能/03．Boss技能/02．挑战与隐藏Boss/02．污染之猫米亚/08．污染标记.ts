/** @noSelfInFile */

import {
  单位间距离平方 as 距离平方,
  取单位ID,
  单位句柄存在 as 单位存在,
  单位未标记死亡 as 单位存活,
  单位已标记死亡 as 单位已死亡,
} from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能仇恨目标列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能仇恨目标列表: (this: void, boss: any) => Array<{ targetHid: number; targetRef: any; threat: number }>;
};
const { setThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  setThreat: (this: void, enemy: any, target: any, value: number) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

function 取单位仇恨(this: void, entries: Array<{ targetHid: number; threat: number }>, unit: any): number {
  const hid = 取单位ID(unit);
  for (let i = 0; i < entries.length; i++) {
    if (entries[i].targetHid === hid) return entries[i].threat;
  }
  return 0;
}

function 取目标腐化层数(this: void, context: 米亚运行时上下文, target: any): number {
  return context.腐化层数控制器.取层数(target);
}

function 恢复Boss生命(this: void, boss: any, ratio: number): void {
  if (!单位存活(boss) || ratio <= 0) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio, ItemHeal: false, HealEffect: false });
}

function 处理旧标记死亡(this: void, context: 米亚运行时上下文): void {
  const target = context.污染标记目标;
  if (!单位已死亡(target)) return;
  恢复Boss生命(context.Boss单位, 米亚技能数值配置.污染标记.标记目标死亡恢复生命比例);
  播放米亚台词(context.Boss单位, "污染标记", 2);
  context.污染标记目标 = null;
}

function 选择污染标记目标(this: void, context: 米亚运行时上下文): any {
  const boss = context.Boss单位;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let highestStack = 0;

  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位存活(hero)) continue;
    const stack = 取目标腐化层数(context, hero);
    if (stack > highestStack) highestStack = stack;
  }
  if (highestStack <= 0) return null;

  const current = context.污染标记目标;
  if (单位存活(current) && 取目标腐化层数(context, current) === highestStack) return current;

  const threatEntries = 获取Boss技能仇恨目标列表(boss);
  let best: any = null;
  let bestThreat = -1;
  let bestDistance = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位存活(hero) || 取目标腐化层数(context, hero) !== highestStack) continue;
    const threat = 取单位仇恨(threatEntries, hero);
    const dist = 距离平方(boss, hero);
    if (best == null || threat > bestThreat || (threat === bestThreat && dist < bestDistance)) {
      best = hero;
      bestThreat = threat;
      bestDistance = dist;
    }
  }
  return best;
}

function 刷新标记Buff(this: void, context: 米亚运行时上下文, target: any): void {
  const config = 米亚技能数值配置.污染标记;
  registerManualBuff(target, 米亚单位技能配置.BuffID.污染标记, config.Buff持续秒, config.对标记目标伤害提高 * 100, {
    sourceName: GetUnitName(context.Boss单位),
    iconOverride: "BuffIcon\\Boss\\Mia\\pollution_mark.blp",
    effectModelOverride: "war3mapImported\\Acid Ex.mdx",
  });
}

function 强制攻击污染标记目标(this: void, context: 米亚运行时上下文, target: any): void {
  if (!单位存活(context.Boss单位) || !单位存活(target)) return;
  setThreat(context.Boss单位, target, 1000);
  IssueTargetOrder(context.Boss单位, "attack", target);
}


export function 取米亚污染标记伤害倍率(this: void, context: 米亚运行时上下文, target: any): number {
  if (context.阶段 !== 1) return 1;
  if (!单位存活(target) || target !== context.污染标记目标) return 1;
  return 1 + 米亚技能数值配置.污染标记.对标记目标伤害提高;
}

export function 刷新米亚污染标记(this: void, context: 米亚运行时上下文, nowMs: number): void {
  处理旧标记死亡(context);
  if (context.阶段 !== 1) {
    context.污染标记目标 = null;
    return;
  }
  const config = 米亚技能数值配置.污染标记;
  if (nowMs - context.上次污染标记Ms < config.检测间隔Ms) return;
  context.上次污染标记Ms = nowMs;

  const target = 选择污染标记目标(context);
  if (!单位存活(target)) {
    context.污染标记目标 = null;
    return;
  }

  const changed = context.污染标记目标 !== target;
  context.污染标记目标 = target;
  刷新标记Buff(context, target);
  强制攻击污染标记目标(context, target);

  if (changed) {
    context.上次污染标记低频台词Ms = nowMs;
    播放米亚台词(context.Boss单位, "污染标记", 0);
  } else if (nowMs - context.上次污染标记低频台词Ms >= 10000) {
    context.上次污染标记低频台词Ms = nowMs;
    播放米亚台词(context.Boss单位, "污染标记", 1);
  }
}
