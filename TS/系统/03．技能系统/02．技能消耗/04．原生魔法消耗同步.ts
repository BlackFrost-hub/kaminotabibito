/** @noSelfInFile */

const jass = require("jass.common") as any;
const Player = jass.Player as (playerId: number) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const R2I = jass.R2I as (value: number) => number;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  初始化本地选中技能快照: (this: void) => void;
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<热键位, number>;
  };
};
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { 计算最终魔法消耗 } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  计算最终魔法消耗: (this: void, unit: any, abilityId: number, level: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能魔法消耗: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
};
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位") as {
  读取命令卡按钮能力Id: (this: void, x: number, y: number) => number;
  获取D技能槽位: (this: void, whichHero: any) => readonly [number, number];
};

type 热键位 = "Q" | "W" | "E" | "R" | "D";
type 按钮槽位 = { x: number; y: number };

const { 技能_设置技能魔法消耗 } = platformAbilityAction;

const REFRESH_MS = 300;
const PLAYER_SYNC_COUNT = 4;
const 固定槽位表: Record<"Q" | "W" | "E" | "R", 按钮槽位> = {
  Q: { x: 0, y: 2 },
  W: { x: 1, y: 2 },
  E: { x: 2, y: 2 },
  R: { x: 3, y: 2 },
};

let initialized = false;
const 技能魔法消耗缓存: Record<string, number | undefined> = {};

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

function 解析槽位(this: void, whichHero: any, hotkey: 热键位): 按钮槽位 {
  if (hotkey === "D") {
    const dSlot = commandBarAbility.获取D技能槽位(whichHero);
    return { x: dSlot[0], y: dSlot[1] };
  }
  return 固定槽位表[hotkey];
}

function 获取技能Id(this: void, whichHero: any, hotkey: 热键位): number {
  const 当前快照 = selectionSnapshotSystem.获取本地选中技能快照();
  if (当前快照.hero === whichHero) return 当前快照.skills[hotkey];
  const slot = 解析槽位(whichHero, hotkey);
  return commandBarAbility.读取命令卡按钮能力Id(slot.x, slot.y);
}

function 取缓存键(this: void, unit: any, abilityId: number): string {
  return `${GetHandleId(unit)}:${abilityId}`;
}

function 写入单个技能同步结果(this: void, unit: any, abilityId: number, manaCost: number): void {
  const nativeCost = manaCost > 0 ? R2I(manaCost + 0.5) : 0;
  技能_设置技能魔法消耗(unit, abilityId, nativeCost);
  技能魔法消耗缓存[取缓存键(unit, abilityId)] = manaCost;
}

function 同步单个热键技能(this: void, whichHero: any, hotkey: 热键位): void {
  const abilityId = 获取技能Id(whichHero, hotkey);
  if (abilityId === 0) return;

  const level = GetUnitAbilityLevel(whichHero, abilityId);
  if (level <= 0) return;

  const manaCost = 计算最终魔法消耗(whichHero, abilityId, level);
  if (manaCost < 0) return;
  写入单个技能同步结果(whichHero, abilityId, manaCost);
}

function 同步注册英雄(this: void, hero: any): void {
  同步单个热键技能(hero, "Q");
  同步单个热键技能(hero, "W");
  同步单个热键技能(hero, "E");
  同步单个热键技能(hero, "R");
  同步单个热键技能(hero, "D");
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
  selectionSnapshotSystem.初始化本地选中技能快照();
  addPeriodicCallback(REFRESH_MS, onSyncTick);
}
