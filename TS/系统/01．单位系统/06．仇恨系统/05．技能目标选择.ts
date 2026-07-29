/** @noSelfInFile */

import type { ThreatEntry } from "./00．仇恨存储";
import { getEnemyThreats, getHighestThreat } from "./00．仇恨存储";
import { 获取应攻击目标 } from "./02．目标选择";

const jass = require("jass.common") as any;
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

const Player = jass.Player as (id: number) => any;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (whichUnit: any, whichPlayer: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (whichUnit: any, abilCode: number) => number;
const IsUnitIllusion = jass.IsUnitIllusion as (whichUnit: any) => boolean;
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
const UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const 蝗虫技能ID = stringToFourCCSafe("Aloc");

export interface Boss技能仇恨目标 {
  targetHid: number;
  targetRef: any;
  threat: number;
  lastUpdateTime?: number;
}

export type 技能目标过滤器 = (entry: Boss技能仇恨目标) => boolean;
export type Boss技能英雄过滤器 = (this: void, hero: any) => boolean;
export type Boss技能英雄权重函数 = (this: void, hero: any) => number;

const Boss技能测试目标列表: any[] = [];

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

function 单位可作为Boss技能敌对目标(this: void, unit: any, bossOwner: any): boolean {
  return 单位有效(unit)
    && IsUnitEnemy(unit, bossOwner) === true
    && IsUnitType(unit, UNIT_TYPE_SUMMONED) !== true
    && IsUnitIllusion(unit) !== true
    && GetUnitAbilityLevel(unit, 蝗虫技能ID) <= 0
    && IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true;
}

function 单位是已注册玩家英雄(this: void, unit: any): boolean {
  return IsUnitType(unit, UNIT_TYPE_HERO) === true
    && getRegisteredPlayerHero(GetOwningPlayer(unit)) === unit;
}

function 获取Boss技能目标优先级(this: void, unit: any): number {
  if (单位是已注册玩家英雄(unit)) return 1;
  if (IsUnitType(unit, UNIT_TYPE_HERO) === true) return 2;
  return 3;
}

function 添加Boss技能敌对目标(
  this: void,
  unit: any,
  bossOwner: any,
  playerHeroes: any[],
  otherHeroes: any[],
  normalUnits: any[]
): void {
  if (!单位可作为Boss技能敌对目标(unit, bossOwner)) return;
  if (单位在列表中(unit, playerHeroes) || 单位在列表中(unit, otherHeroes) || 单位在列表中(unit, normalUnits)) return;
  if (单位是已注册玩家英雄(unit)) playerHeroes.push(unit);
  else if (IsUnitType(unit, UNIT_TYPE_HERO) === true) otherHeroes.push(unit);
  else normalUnits.push(unit);
}

function 获取最高优先级目标数量(this: void, targets: any[]): number {
  if (targets.length <= 0) return 0;
  const priority = 获取Boss技能目标优先级(targets[0]);
  let count = 1;
  while (count < targets.length && 获取Boss技能目标优先级(targets[count]) === priority) count += 1;
  return count;
}

export function 注册Boss技能测试目标(this: void, unit: any): void {
  if (!单位有效(unit) || 单位在列表中(unit, Boss技能测试目标列表)) return;
  Boss技能测试目标列表.push(unit);
}

export function 注销Boss技能测试目标(this: void, unit: any): void {
  for (let i = Boss技能测试目标列表.length - 1; i >= 0; i--) {
    if (Boss技能测试目标列表[i] === unit) Boss技能测试目标列表.splice(i, 1);
  }
}

function 获取有效Boss技能测试目标列表(this: void, boss: any): any[] {
  const result: any[] = [];
  const bossOwner = GetOwningPlayer(boss);
  for (let i = Boss技能测试目标列表.length - 1; i >= 0; i--) {
    const unit = Boss技能测试目标列表[i];
    if (!单位有效(unit)) {
      Boss技能测试目标列表.splice(i, 1);
    } else if (IsUnitEnemy(unit, bossOwner) === true) {
      result.push(unit);
    }
  }
  return result;
}

export function 获取Boss技能敌对英雄列表(this: void, boss: any): any[] {
  return 获取Boss技能敌对目标列表(boss);
}

export function 获取Boss技能敌对目标列表(this: void, boss: any): any[] {
  const result: any[] = [];
  const playerHeroes: any[] = [];
  const otherHeroes: any[] = [];
  const normalUnits: any[] = [];
  if (!单位有效(boss)) return result;
  const bossOwner = GetOwningPlayer(boss);
  const testTargets = 获取有效Boss技能测试目标列表(boss);
  if (testTargets.length > 0) {
    for (let i = 0; i < testTargets.length; i++) {
      添加Boss技能敌对目标(testTargets[i], bossOwner, playerHeroes, otherHeroes, normalUnits);
    }
  } else {
    const group = CreateGroup();
    for (let pid = 0; pid <= 5; pid++) {
      GroupEnumUnitsOfPlayer(group, Player(pid), null);
      let unit = FirstOfGroup(group);
      while (unit != null && unit !== 0) {
        GroupRemoveUnit(group, unit);
        添加Boss技能敌对目标(unit, bossOwner, playerHeroes, otherHeroes, normalUnits);
        unit = FirstOfGroup(group);
      }
    }
    DestroyGroup(group);
  }
  for (let i = 0; i < playerHeroes.length; i++) result.push(playerHeroes[i]);
  for (let i = 0; i < otherHeroes.length; i++) result.push(otherHeroes[i]);
  for (let i = 0; i < normalUnits.length; i++) result.push(normalUnits[i]);
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
  const priorityCount = 获取最高优先级目标数量(heroes);
  return heroes[GetRandomInt(0, priorityCount - 1)];
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
  const priorityCount = 获取最高优先级目标数量(heroes);
  let best: any = null;
  let bestScore = 999999999;
  for (let i = 0; i < priorityCount; i++) {
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
  const priorityCount = 获取最高优先级目标数量(heroes);
  let best: any = null;
  let bestDistance = 999999999;
  for (let i = 0; i < priorityCount; i++) {
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
  const priorityCount = 获取最高优先级目标数量(heroes);
  let best: any = null;
  let bestDistance = -1;
  for (let i = 0; i < priorityCount; i++) {
    const distance = 距离平方(boss, heroes[i]);
    if (distance > bestDistance) {
      bestDistance = distance;
      best = heroes[i];
    }
  }
  return best;
}
