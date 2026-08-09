/** @noSelfInFile */

const jass = require("jass.common") as any;
const Player = jass.Player as (playerId: number) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const R2I = jass.R2I as (value: number) => number;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const heroConfigTool = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位英雄Rawcode: (this: void, unit: any) => string;
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { 获取英雄升级配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表") as {
  获取英雄升级配置: (this: void, heroRawcode: string) => {
    awakeningSkills?: readonly { abilityId: string }[];
    learnedSkills?: readonly { abilityId: string }[];
  } | null;
};
const { 计算最终魔法消耗 } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  计算最终魔法消耗: (this: void, unit: any, abilityId: number, level: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能魔法消耗: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const { 技能_设置技能魔法消耗 } = platformAbilityAction;

const REFRESH_MS = 300;
const PLAYER_SYNC_COUNT = 4;

let initialized = false;
const 技能魔法消耗缓存: Record<string, number | undefined> = {};
const 英雄类型技能列表缓存: Record<string, number[] | undefined> = {};

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function 获取注册玩家英雄(this: void, playerId: number): any | null {
  const whichPlayer = Player(playerId);
  if (!isValidHandle(whichPlayer)) return null;

  const hero = heroBridge.getRegisteredPlayerHero(whichPlayer);
  if (!isValidHandle(hero)) return null;
  return hero;
}

function 追加技能ID(this: void, result: number[], seen: Record<number, boolean | undefined>, rawcode: string): void {
  const abilityId = stringToFourCCSafe(rawcode);
  if (abilityId === 0 || seen[abilityId] === true) return;
  seen[abilityId] = true;
  result.push(abilityId);
}

function 追加配置技能字段(this: void, result: number[], seen: Record<number, boolean | undefined>, rawList: any): void {
  if (typeof rawList !== "string" || rawList === "") return;
  const parts = rawList.split(",");
  for (let i = 0; i < parts.length; i++) {
    追加技能ID(result, seen, parts[i]);
  }
}

function 获取英雄确定性技能列表(this: void, whichHero: any): number[] {
  const heroRawcode = heroConfigTool.获取单位英雄Rawcode(whichHero);
  if (heroRawcode === "") return [];

  const cached = 英雄类型技能列表缓存[heroRawcode];
  if (cached != null) return cached;

  const result: number[] = [];
  const seen: Record<number, boolean | undefined> = {};
  const heroConfig = heroConfigTool.获取单位玩家英雄配置(whichHero);
  if (heroConfig != null) {
    追加配置技能字段(result, seen, heroConfig.heroAbilList);
    追加配置技能字段(result, seen, heroConfig.abilList);
  }

  const upgradeConfig = 获取英雄升级配置(heroRawcode);
  const awakeningSkills = upgradeConfig?.awakeningSkills;
  if (awakeningSkills != null) {
    for (let i = 0; i < awakeningSkills.length; i++) {
      追加技能ID(result, seen, awakeningSkills[i].abilityId);
    }
  }
  const learnedSkills = upgradeConfig?.learnedSkills;
  if (learnedSkills != null) {
    for (let i = 0; i < learnedSkills.length; i++) {
      追加技能ID(result, seen, learnedSkills[i].abilityId);
    }
  }

  英雄类型技能列表缓存[heroRawcode] = result;
  return result;
}

function 取缓存键(this: void, unit: any, abilityId: number): string {
  return `${GetHandleId(unit)}:${abilityId}`;
}

function 写入单个技能同步结果(this: void, unit: any, abilityId: number, manaCost: number): void {
  const cacheKey = 取缓存键(unit, abilityId);
  if (技能魔法消耗缓存[cacheKey] === manaCost) return;
  const nativeCost = manaCost > 0 ? R2I(manaCost + 0.5) : 0;
  技能_设置技能魔法消耗(unit, abilityId, nativeCost);
  技能魔法消耗缓存[cacheKey] = manaCost;
}

function 同步单个技能(this: void, whichHero: any, abilityId: number): void {
  const level = GetUnitAbilityLevel(whichHero, abilityId);
  if (level <= 0) return;

  const manaCost = 计算最终魔法消耗(whichHero, abilityId, level);
  if (manaCost < 0) return;
  写入单个技能同步结果(whichHero, abilityId, manaCost);
}

function 同步注册英雄(this: void, hero: any): void {
  const abilityIds = 获取英雄确定性技能列表(hero);
  for (let i = 0; i < abilityIds.length; i++) {
    同步单个技能(hero, abilityIds[i]);
  }
}

function onSyncTick(this: void): void {
  for (let playerId = 0; playerId < PLAYER_SYNC_COUNT; playerId++) {
    const hero = 获取注册玩家英雄(playerId);
    if (isValidHandle(hero)) {
      同步注册英雄(hero);
    }
  }
}

export function 获取已同步技能魔法消耗(this: void, unit: any, abilityId: number): number {
  if (!isValidHandle(unit) || abilityId === 0) return -1;
  return 技能魔法消耗缓存[取缓存键(unit, abilityId)] ?? -1;
}

export function 初始化原生魔法消耗同步(this: void): void {
  if (initialized) return;
  initialized = true;
  addPeriodicCallback(REFRESH_MS, onSyncTick);
}
