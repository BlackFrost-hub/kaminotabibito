/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const 玩家系统常量 = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../00．核心系统/00．玩家系统/00．常量");
const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  getSoleSelectedUnitForPlayer: (this: void, playerId: number) => any | null;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位") as {
  读取命令卡按钮能力Id: (this: void, x: number, y: number) => number;
  获取D技能槽位: (this: void, whichHero: any) => readonly [number, number];
};

export type 技能热键位 = "Q" | "W" | "E" | "R" | "D";
type 按钮槽位 = { x: number; y: number };
type 技能ID表 = Record<技能热键位, number>;
type 槽位表 = Record<技能热键位, 按钮槽位>;

export type 本地选中技能快照 = {
  hero: any | null;
  skills: 技能ID表;
  slots: 槽位表;
};

const 获取玩家唯一选中单位 = selectionCenterSystem.getSoleSelectedUnitForPlayer as
  | ((this: void, playerId: number) => any | null)
  | undefined;

const 固定槽位表: Record<"Q" | "W" | "E" | "R", 按钮槽位> = {
  Q: { x: 0, y: 2 },
  W: { x: 1, y: 2 },
  E: { x: 2, y: 2 },
  R: { x: 3, y: 2 },
};

const REFRESH_MS = 100;

let initialized = false;
let 当前快照: 本地选中技能快照 = {
  hero: null,
  skills: { Q: 0, W: 0, E: 0, R: 0, D: 0 },
  slots: {
    Q: { x: 0, y: 2 },
    W: { x: 1, y: 2 },
    E: { x: 2, y: 2 },
    R: { x: 3, y: 2 },
    D: { x: 3, y: 1 },
  },
};

function isValidHandle(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 清空快照(this: void): void {
  当前快照.hero = null;
  当前快照.skills.Q = 0;
  当前快照.skills.W = 0;
  当前快照.skills.E = 0;
  当前快照.skills.R = 0;
  当前快照.skills.D = 0;
  当前快照.slots.Q = { x: 0, y: 2 };
  当前快照.slots.W = { x: 1, y: 2 };
  当前快照.slots.E = { x: 2, y: 2 };
  当前快照.slots.R = { x: 3, y: 2 };
  当前快照.slots.D = { x: 3, y: 1 };
}

function 读取玩家唯一选中英雄(this: void, playerId: number): any | null {
  if (typeof 获取玩家唯一选中单位 !== "function") return null;
  const selectedUnit = 获取玩家唯一选中单位(playerId);
  if (!isValidHandle(selectedUnit)) return null;
  if (jass.IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) !== true) return null;
  return selectedUnit;
}

function 获取已注册玩家英雄(this: void, whichPlayer: any): any | null {
  if (!isValidHandle(whichPlayer)) return null;
  const hero = YDUserDataGetSafe("player", whichPlayer, 玩家系统常量.YD_ATTR_PLAYER_HERO_UNIT, "unit");
  return isValidHandle(hero) ? hero : null;
}

function 获取本地当前选中英雄(this: void): any | null {
  const localPlayer = jass.GetLocalPlayer();
  if (!isValidHandle(localPlayer)) return null;

  const selectedHero = 读取玩家唯一选中英雄(jass.GetPlayerId(localPlayer));
  if (!isValidHandle(selectedHero)) return null;

  const owner = jass.GetOwningPlayer(selectedHero);
  if (!isValidHandle(owner)) return null;

  const registeredHero = 获取已注册玩家英雄(owner);
  if (!isValidHandle(registeredHero)) return null;
  if (registeredHero !== selectedHero) return null;
  return selectedHero;
}

function 刷新快照(this: void): void {
  const hero = 获取本地当前选中英雄();
  if (!isValidHandle(hero)) {
    清空快照();
    return;
  }

  当前快照.hero = hero;
  当前快照.slots.Q = 固定槽位表.Q;
  当前快照.slots.W = 固定槽位表.W;
  当前快照.slots.E = 固定槽位表.E;
  当前快照.slots.R = 固定槽位表.R;
  const dSlot = commandBarAbility.获取D技能槽位(hero);
  当前快照.slots.D = { x: dSlot[0], y: dSlot[1] };

  当前快照.skills.Q = commandBarAbility.读取命令卡按钮能力Id(当前快照.slots.Q.x, 当前快照.slots.Q.y);
  当前快照.skills.W = commandBarAbility.读取命令卡按钮能力Id(当前快照.slots.W.x, 当前快照.slots.W.y);
  当前快照.skills.E = commandBarAbility.读取命令卡按钮能力Id(当前快照.slots.E.x, 当前快照.slots.E.y);
  当前快照.skills.R = commandBarAbility.读取命令卡按钮能力Id(当前快照.slots.R.x, 当前快照.slots.R.y);
  当前快照.skills.D = commandBarAbility.读取命令卡按钮能力Id(当前快照.slots.D.x, 当前快照.slots.D.y);
}

export function 获取本地选中技能快照(this: void): 本地选中技能快照 {
  return 当前快照;
}

export function 初始化本地选中技能快照(this: void): void {
  if (initialized) return;
  initialized = true;
  刷新快照();
  addPeriodicCallback(REFRESH_MS, 刷新快照);
}
