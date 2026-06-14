/** @noSelfInFile */

import type { ThreatEntry } from "./00．仇恨存储";
import { getEnemyThreats, getHighestThreat } from "./00．仇恨存储";
import { 获取应攻击目标 } from "./02．目标选择";

const jass = require("jass.common") as any;
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};

const Player = jass.Player as (id: number) => any;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (whichUnit: any, whichPlayer: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

export interface Boss技能仇恨目标 {
  targetHid: number;
  targetRef: any;
  threat: number;
  lastUpdateTime?: number;
}

export type 技能目标过滤器 = (entry: Boss技能仇恨目标) => boolean;
export type Boss技能英雄过滤器 = (this: void, hero: any) => boolean;
export type Boss技能英雄权重函数 = (this: void, hero: any) => number;

export function 获取Boss技能最高仇恨目标(
  this: void,
  boss: any,
  filter?: 技能目标过滤器
): ThreatEntry | null {
  return getHighestThreat(boss, filter);
}

export function 获取Boss技能应攻击目标(
  this: void,
  boss: any,
  filter?: 技能目标过滤器
): Boss技能仇恨目标 | null {
  return 获取应攻击目标(boss, filter);
}

export function 获取Boss技能仇恨目标列表(this: void, boss: any, filter?: 技能目标过滤器): ThreatEntry[] {
  const entries = getEnemyThreats(boss);
  if (filter == null) return entries;
  const result: ThreatEntry[] = [];
  for (let i = 0; i < entries.length; i++) {
    if (filter(entries[i])) result.push(entries[i]);
  }
  return result;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 距离平方(this: void, source: any, target: any): number {
  const dx = GetUnitX(source) - GetUnitX(target);
  const dy = GetUnitY(source) - GetUnitY(target);
  return dx * dx + dy * dy;
}

function 单位在列表中(this: void, unit: any, list: any[] | undefined): boolean {
  if (list == null) return false;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === unit) return true;
  }
  return false;
}

function 获取玩家首个存活英雄(this: void, whichPlayer: any): any {
  const registeredHero = getRegisteredPlayerHero(whichPlayer);
  if (单位有效(registeredHero) && IsUnitType(registeredHero, UNIT_TYPE_HERO) === true) return registeredHero;

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, whichPlayer, null);
  let result: any = null;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (单位有效(unit) && IsUnitType(unit, UNIT_TYPE_HERO) === true) {
      result = unit;
      break;
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

export function 获取Boss技能敌对英雄列表(this: void, boss: any): any[] {
  const result: any[] = [];
  if (!单位有效(boss)) return result;
  const bossOwner = GetOwningPlayer(boss);
  for (let pid = 0; pid <= 5; pid++) {
    const hero = 获取玩家首个存活英雄(Player(pid));
    if (单位有效(hero) && IsUnitEnemy(hero, bossOwner) === true) result.push(hero);
  }
  return result;
}

export function 获取Boss技能敌对英雄列表Ex(
  this: void,
  boss: any,
  centerUnit?: any,
  radius?: number,
  excludeList?: any[],
  filter?: Boss技能英雄过滤器
): any[] {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const result: any[] = [];
  const radius2 = radius != null && radius > 0 ? radius * radius : 0;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (单位在列表中(hero, excludeList)) continue;
    if (filter != null && !filter(hero)) continue;
    if (centerUnit != null && centerUnit !== 0 && radius2 > 0 && 距离平方(centerUnit, hero) > radius2) continue;
    result.push(hero);
  }
  return result;
}

export function 获取Boss技能随机敌对英雄(
  this: void,
  boss: any,
  centerUnit?: any,
  radius?: number,
  excludeList?: any[],
  filter?: Boss技能英雄过滤器
): any {
  const heroes = 获取Boss技能敌对英雄列表Ex(boss, centerUnit, radius, excludeList, filter);
  if (heroes.length <= 0) return null;
  return heroes[GetRandomInt(0, heroes.length - 1)];
}

export function 获取Boss技能最近敌对英雄Ex(
  this: void,
  boss: any,
  centerUnit?: any,
  radius?: number,
  excludeList?: any[],
  filter?: Boss技能英雄过滤器,
  weight?: Boss技能英雄权重函数
): any {
  const center = centerUnit ?? boss;
  const heroes = 获取Boss技能敌对英雄列表Ex(boss, center, radius, excludeList, filter);
  let best: any = null;
  let bestScore = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    const w = weight != null ? weight(hero) : 1;
    const score = w > 0 ? 距离平方(center, hero) / w : 距离平方(center, hero);
    if (score < bestScore) {
      bestScore = score;
      best = hero;
    }
  }
  return best;
}

export function 获取Boss技能最近敌对英雄(this: void, boss: any): any {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let best: any = null;
  let bestDistance = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    const distance = 距离平方(boss, heroes[i]);
    if (distance < bestDistance) {
      bestDistance = distance;
      best = heroes[i];
    }
  }
  return best;
}

export function 获取Boss技能最远敌对英雄(this: void, boss: any): any {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let best: any = null;
  let bestDistance = -1;
  for (let i = 0; i < heroes.length; i++) {
    const distance = 距离平方(boss, heroes[i]);
    if (distance > bestDistance) {
      bestDistance = distance;
      best = heroes[i];
    }
  }
  return best;
}
