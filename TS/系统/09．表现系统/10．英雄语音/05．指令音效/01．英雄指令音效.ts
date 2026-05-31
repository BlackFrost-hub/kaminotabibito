/** @noSelfInFile */

const jass = require("jass.common") as any;
const { registerUnitEventTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};
const { addSelectionListener } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener: (this: void, callback: (this: void, player: any, playerId: number, unit: any, isSelected: boolean) => void) => void;
};
const { registerPointOrderListener } = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
};
const { 单位是否匹配玩家英雄名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  单位是否匹配玩家英雄名称: (this: void, unit: any, name: string) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};

import {
  英雄指令音效配置列表,
  英雄指令音效攻击冷却,
  英雄指令音效移动冷却,
  英雄指令音效选中冷却,
  英雄指令音效正在冷却,
  英雄指令音效单位字段,
  英雄目标点指令音效单位字段,
  英雄被选择音效单位字段,
  英雄正在语音单位字段,
} from "./00．配置";

type 取注册英雄函数 = (this: void, whichPlayer: any) => any | null;

const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const GetTriggerPlayer = jass.GetTriggerPlayer as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: number) => boolean;

const EventUnitSelected = jass.EVENT_UNIT_SELECTED as number;
const EventUnitIssuedPointOrder = jass.EVENT_UNIT_ISSUED_POINT_ORDER as number;
const EventUnitTargetInRange = jass.EVENT_UNIT_TARGET_IN_RANGE as number;

let 英雄指令音效系统已初始化 = false;
let 取注册英雄缓存: 取注册英雄函数 | null = null;
const 已注册英雄单位ID = new Set<number>();
const 指令音效冷却检查间隔毫秒 = 100;
let 指令音效冷却检查回调ID = 0;
const 指令音效冷却单位列表: any[] = [];
const 指令音效冷却字段列表: string[] = [];
const 指令音效冷却到期毫秒列表: number[] = [];

function 取注册英雄(this: void, whichPlayer: any): any | null {
  if (取注册英雄缓存 == null) {
    const bridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
      getRegisteredPlayerHero?: 取注册英雄函数;
    };
    if (typeof bridge.getRegisteredPlayerHero === "function") {
      取注册英雄缓存 = bridge.getRegisteredPlayerHero;
    }
  }
  if (typeof 取注册英雄缓存 !== "function") return null;
  return 取注册英雄缓存(whichPlayer);
}

function 获取单位哈希(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return (jass.GetHandleId(unit) as number) || 0;
}

function 是注册玩家英雄单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_DEAD)) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_SUMMONED)) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return 取注册英雄(owner) === unit;
}

function 取英雄指令音效配置(this: void, unit: any): { 英雄名: string; 攻击音效列表: any[]; 移动音效列表: any[]; 选中音效列表: any[] } | null {
  for (let i = 0; i < 英雄指令音效配置列表.length; i++) {
    const config = 英雄指令音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 指定列表有音效(this: void, list: any[]): boolean {
  return list != null && list.length > 0;
}

function 取随机音效(this: void, soundList: any[]): any {
  if (soundList.length <= 0) return null;
  if (soundList.length === 1) return soundList[0];
  const index = GetRandomInt(1, soundList.length) - 1;
  return soundList[index] ?? null;
}

function 取当前事件音效(this: void, unit: any, eventId: number): any {
  const config = 取英雄指令音效配置(unit);
  if (config == null) return null;
  if (eventId === EventUnitTargetInRange) return 取随机音效(config.攻击音效列表);
  if (eventId === EventUnitIssuedPointOrder) return 取随机音效(config.移动音效列表);
  if (eventId === EventUnitSelected) return 取随机音效(config.选中音效列表);
  return null;
}

function 本地播放(this: void, soundHandle: any): void {
  if (soundHandle == null || soundHandle === 0) return;
  const triggerPlayer = GetTriggerPlayer();
  if (triggerPlayer == null || triggerPlayer === 0) return;
  if (jass.GetLocalPlayer() !== triggerPlayer) return;
  PlaySoundBJ(soundHandle);
}

function 冷却结束(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 指令音效冷却单位列表.length; i++) {
    const unit = 指令音效冷却单位列表[i];
    const key = 指令音效冷却字段列表[i];
    const dueMs = 指令音效冷却到期毫秒列表[i];
    if (now >= dueMs) {
      if (unit != null && unit !== 0 && key !== "") {
        YDUserDataSetSafe("unit", unit, key, "boolean", false);
      }
    } else {
      指令音效冷却单位列表[writeIndex] = unit;
      指令音效冷却字段列表[writeIndex] = key;
      指令音效冷却到期毫秒列表[writeIndex] = dueMs;
      writeIndex++;
    }
  }
  for (let i = 指令音效冷却单位列表.length - 1; i >= writeIndex; i--) {
    指令音效冷却单位列表.pop();
    指令音效冷却字段列表.pop();
    指令音效冷却到期毫秒列表.pop();
  }
  if (指令音效冷却单位列表.length === 0 && 指令音效冷却检查回调ID !== 0) {
    removePeriodicCallback(指令音效冷却检查回调ID);
    指令音效冷却检查回调ID = 0;
  }
}

function 启动指令音效冷却检查(this: void): void {
  if (指令音效冷却检查回调ID !== 0) return;
  指令音效冷却检查回调ID = addPeriodicCallback(指令音效冷却检查间隔毫秒, 冷却结束);
}

function 记录并开始冷却(this: void, unit: any, key: string, timeout: number): void {
  YDUserDataSetSafe("unit", unit, key, "boolean", true);
  指令音效冷却单位列表.push(unit);
  指令音效冷却字段列表.push(key);
  指令音效冷却到期毫秒列表.push(getServerTime() + timeout * 1000);
  启动指令音效冷却检查();
}

function 取事件冷却(this: void, eventId: number): number {
  if (eventId === EventUnitTargetInRange) return 英雄指令音效攻击冷却;
  if (eventId === EventUnitIssuedPointOrder) return 英雄指令音效移动冷却;
  return 英雄指令音效选中冷却;
}

function 取事件冷却字段(this: void, eventId: number): string {
  if (eventId === EventUnitTargetInRange) return 英雄指令音效单位字段;
  if (eventId === EventUnitIssuedPointOrder) return 英雄目标点指令音效单位字段;
  if (eventId === EventUnitSelected) return 英雄被选择音效单位字段;
  return "";
}

function 处理指令音效(this: void): void {
  const unit = GetTriggerUnit();
  处理指定事件指令音效(unit, EventUnitTargetInRange);
}

function 处理指定事件指令音效(this: void, unit: any, eventId: number): void {
  if (!是注册玩家英雄单位(unit)) return;

  const cooldownKey = 取事件冷却字段(eventId);
  if (cooldownKey === "") return;

  if (YDUserDataGetSafe("unit", unit, 英雄正在语音单位字段, "boolean") === true) return;
  if (YDUserDataGetSafe("unit", unit, cooldownKey, "boolean") === true) return;

  const soundHandle = 取当前事件音效(unit, eventId);
  if (soundHandle == null || soundHandle === 0) return;

  本地播放(soundHandle);
  记录并开始冷却(unit, cooldownKey, 取事件冷却(eventId));
  记录并开始冷却(unit, 英雄正在语音单位字段, 英雄指令音效正在冷却);
}

function 玩家选中事件回调(this: void, _player: any, _playerId: number, unit: any, isSelected: boolean): void {
  if (isSelected !== true) return;
  处理指定事件指令音效(unit, EventUnitSelected);
}

function 玩家点命令事件回调(this: void, unit: any, _orderId: number, _x: number, _y: number): void {
  处理指定事件指令音效(unit, EventUnitIssuedPointOrder);
}

function 注册英雄指令事件(this: void, whichHero: any): void {
  if (!是注册玩家英雄单位(whichHero)) return;
  const config = 取英雄指令音效配置(whichHero);
  if (config == null || !指定列表有音效(config.攻击音效列表)) return;
  const heroId = 获取单位哈希(whichHero);
  if (heroId === 0 || 已注册英雄单位ID.has(heroId)) return;

  const trigger = jass.CreateTrigger();
  jass.TriggerAddAction(trigger, 处理指令音效);
  registerUnitEventTrigger(trigger, whichHero, EventUnitTargetInRange);
  已注册英雄单位ID.add(heroId);
}

function 扫描已注册英雄(this: void): void {
  for (let i = 0; i <= 15; i++) {
    const player = jass.Player(i);
    if (player == null || player === 0) continue;
    const hero = 取注册英雄(player);
    if (hero == null || hero === 0) continue;
    注册英雄指令事件(hero);
  }
}

export function onPlayerHeroRegistered(this: void, _whichPlayer: any, whichHero: any): void {
  注册英雄指令事件(whichHero);
}

export function init英雄指令音效系统(this: void): void {
  if (英雄指令音效系统已初始化) return;
  英雄指令音效系统已初始化 = true;
  addSelectionListener(玩家选中事件回调);
  registerPointOrderListener(玩家点命令事件回调);
  扫描已注册英雄();
}

export {};
