/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addSelectionListener } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener: (
    this: void,
    callback: (this: void, player: any, playerId: number, unit: any, isSelected: boolean) => void
  ) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { 单位是否匹配玩家英雄名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  单位是否匹配玩家英雄名称: (this: void, unit: any, name: string) => boolean;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};

import {
  英雄购物音效冷却,
  英雄购物音效范围,
  英雄购物音效配置列表,
  购物商店判定能力Id,
} from "./00．配置";

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const IsUnitInRange = jass.IsUnitInRange as (this: void, unit: any, otherUnit: any, distance: number) => boolean;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;

let 英雄购物音效已初始化 = false;
let 购物音效冷却中 = false;

function 是购物商店(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (!IsUnitType(unit, jass.UNIT_TYPE_TOWNHALL)) return false;
  return GetUnitAbilityLevel(unit, 购物商店判定能力Id) === 1;
}

function 取英雄购物音效配置(this: void, unit: any): { 英雄名: string; 音效列表: any[] } | null {
  for (let i = 0; i < 英雄购物音效配置列表.length; i++) {
    const config = 英雄购物音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 取随机购物音效(this: void, soundList: any[]): any {
  if (soundList.length <= 0) return null;
  if (soundList.length === 1) return soundList[0];
  const index = GetRandomInt(1, soundList.length) - 1;
  return soundList[index];
}

function 购物音效冷却结束(this: void): void {
  购物音效冷却中 = false;
  const timer = GetExpiredTimer();
  if (timer != null && timer !== 0) {
    safeDestroyTimer(timer);
  }
}

function 开始购物音效冷却(this: void): void {
  购物音效冷却中 = true;
  const timer = CreateTimer();
  safeTimerStart(timer, 英雄购物音效冷却, false, 购物音效冷却结束);
}

function 本地播放购物音效(this: void, whichPlayer: any, soundHandle: any): void {
  if (soundHandle == null || soundHandle === 0) return;
  if (GetLocalPlayer() !== whichPlayer) return;
  PlaySoundBJ(soundHandle);
}

function 处理购物音效(this: void, whichPlayer: any, _playerId: number, selectedUnit: any, isSelected: boolean): void {
  if (isSelected !== true) return;
  if (购物音效冷却中) return;
  if (!是购物商店(selectedUnit)) return;

  const hero = getRegisteredPlayerHero(whichPlayer);
  if (hero == null || hero === 0) return;
  if (IsUnitType(hero, jass.UNIT_TYPE_DEAD)) return;
  if (IsUnitType(hero, jass.UNIT_TYPE_SUMMONED)) return;
  if (!IsUnitInRange(hero, selectedUnit, 英雄购物音效范围)) return;

  const config = 取英雄购物音效配置(hero);
  if (config == null) return;

  const soundHandle = 取随机购物音效(config.音效列表);
  if (soundHandle == null || soundHandle === 0) return;

  本地播放购物音效(whichPlayer, soundHandle);
  开始购物音效冷却();
}

export function init英雄购物音效(this: void): void {
  if (英雄购物音效已初始化) return;
  英雄购物音效已初始化 = true;
  addSelectionListener(处理购物音效);
}

export {};
