/** @noSelfInFile */

import { 确保物品提示缓存清理Tick } from "./02．物品提示读取缓存";
import { 构建物品提示内容 } from "./03．物品提示内容";
import { 创建物品提示UI, 更新物品提示内容, 锚定提示根框到原生物品提示位置, 有效帧 } from "./01．物品提示UI";
import type { 物品提示UI帧 } from "./01．物品提示UI";

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;
const bjTrigger = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterPlayerSelectionEventBJ: (this: void, trig: any, whichPlayer: any, selected: boolean) => any;
};
const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};

const 注册玩家选中事件BJ = bjTrigger.TriggerRegisterPlayerSelectionEventBJ;
const 添加延迟回调 = centerTimer.addDelayedCallback;
const 添加周期回调 = centerTimer.addPeriodicCallback;
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameGetItemBarButton = japi.DzFrameGetItemBarButton as (slot: number) => number;
const DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode as (frame: number, eventId: number, callback: (this: void) => void, sync: boolean) => void;
const DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame as () => number;
const DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer as () => any;
const DzFrameGetTooltip = japi.DzFrameGetTooltip as () => number;
const DzFrameClearAllPoints = japi.DzFrameClearAllPoints as (frame: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const UnitItemInSlot = jass.UnitItemInSlot as (whichUnit: any, itemSlot: number) => any;
const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, actionFunc: (this: void) => void) => any;
const GetTriggerPlayer = jass.GetTriggerPlayer as () => any;
const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const Player = jass.Player as (playerId: number) => any;

const POINT_BOTTOM = 7;
const POINT_BOTTOMRIGHT = 8;
const ITEM_BAR_SLOT_COUNT = 6;
const MOUSE_ENTER_EVENT_ID = 2;
const MOUSE_LEAVE_EVENT_ID = 3;
const 原生物品提示压制间隔毫秒 = 33;
const 原生物品提示延迟压制次数 = 6;

let 已初始化 = false;
let 帧: 物品提示UI帧 | null = null;
let 当前悬停物品槽位 = -1;
let 选中单位触发器: any = null;
let 已注册选中单位触发器 = false;
let 社区式选中单位By玩家ID: Record<number, any | null> = {};
let 原生物品提示压制TickID = 0;

function 社区式选中单位记录(this: void): void {
  const player = GetTriggerPlayer();
  const unit = GetTriggerUnit();
  const playerId = player != null && player !== 0 ? GetPlayerId(player) : -1;
  if (playerId < 0) return;
  社区式选中单位By玩家ID[playerId] = unit;
}

function 注册社区式选中单位记录(this: void): void {
  if (已注册选中单位触发器) return;
  已注册选中单位触发器 = true;
  选中单位触发器 = CreateTrigger();
  TriggerAddAction(选中单位触发器, 社区式选中单位记录);
  for (let playerId = 0; playerId < 16; playerId++) {
    注册玩家选中事件BJ(选中单位触发器, Player(playerId), true);
  }
}

function 取社区式触发玩家选中单位(this: void): any {
  const triggerPlayer = DzGetTriggerUIEventPlayer();
  const playerId = triggerPlayer != null && triggerPlayer !== 0 ? GetPlayerId(triggerPlayer) : -1;
  return playerId >= 0 ? 社区式选中单位By玩家ID[playerId] : null;
}

function 隐藏原生物品提示(this: void): void {
  const tooltip = DzFrameGetTooltip();
  if (!有效帧(tooltip)) return;
  DzFrameClearAllPoints(tooltip);
  DzFrameSetPoint(tooltip, POINT_BOTTOM, DzGetGameUI(), POINT_BOTTOM, 0, -0.60);
}

function 执行原生物品提示压制(this: void): void {
  if (当前悬停物品槽位 < 0) return;
  隐藏原生物品提示();
}

function 调度原生物品提示延迟压制(this: void): void {
  for (let i = 1; i <= 原生物品提示延迟压制次数; i++) {
    添加延迟回调(i * 10, 执行原生物品提示压制);
  }
}

function 确保原生物品提示压制Tick(this: void): void {
  if (原生物品提示压制TickID !== 0) return;
  原生物品提示压制TickID = 添加周期回调(原生物品提示压制间隔毫秒, 执行原生物品提示压制);
}

function 恢复原生物品提示(this: void): void {
  const tooltip = DzFrameGetTooltip();
  if (!有效帧(tooltip)) return;
  DzFrameClearAllPoints(tooltip);
  DzFrameSetPoint(tooltip, POINT_BOTTOMRIGHT, DzGetGameUI(), POINT_BOTTOMRIGHT, 0, 0.16);
}

function 隐藏物品提示模拟UI(this: void): void {
  当前悬停物品槽位 = -1;
  if (帧 != null) DzFrameShow(帧.root, false);
}

function 显示物品栏槽位提示(this: void, slot: number, hero: any, item: any): void {
  if (帧 == null) {
    隐藏物品提示模拟UI();
    return;
  }

  const 内容 = 构建物品提示内容(item, hero);
  if (内容 == null) {
    隐藏物品提示模拟UI();
    return;
  }

  当前悬停物品槽位 = slot;
  更新物品提示内容(帧, 内容);
  锚定提示根框到原生物品提示位置(帧.root);
  隐藏原生物品提示();
  DzFrameShow(帧.root, true);
  隐藏原生物品提示();
  调度原生物品提示延迟压制();
}

function 物品栏按钮进入(this: void): void {
  const triggerFrame = DzGetTriggerUIEventFrame();
  const hero = 取社区式触发玩家选中单位();

  let matched = false;
  for (let slot = 0; slot < ITEM_BAR_SLOT_COUNT; slot++) {
    const button = DzFrameGetItemBarButton(slot);
    const item = hero != null && hero !== 0 ? UnitItemInSlot(hero, slot) : null;
    if (item != null && item !== 0 && triggerFrame === button) {
      matched = true;
      隐藏原生物品提示();
      显示物品栏槽位提示(slot, hero, item);
      隐藏原生物品提示();
    }
  }

  if (!matched) 隐藏物品提示模拟UI();
}

function 物品栏按钮离开(this: void): void {
  隐藏物品提示模拟UI();
  恢复原生物品提示();
}

function 注册原生物品栏提示劫持(this: void): void {
  if (帧 == null) return;
  for (let slot = 0; slot < ITEM_BAR_SLOT_COUNT; slot++) {
    const button = DzFrameGetItemBarButton(slot);
    if (!有效帧(button)) continue;
    DzFrameSetScriptByCode(button, MOUSE_ENTER_EVENT_ID, 物品栏按钮进入, false);
    DzFrameSetScriptByCode(button, MOUSE_LEAVE_EVENT_ID, 物品栏按钮离开, false);
  }
}

function 创建并显示物品提示模拟UI(this: void): void {
  帧 = 创建物品提示UI();
  if (帧 == null) return;
  注册原生物品栏提示劫持();
  DzFrameShow(帧.root, false);
}

export function 初始化物品提示模拟UI(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  注册社区式选中单位记录();
  确保物品提示缓存清理Tick();
  确保原生物品提示压制Tick();
  添加延迟回调(500, 创建并显示物品提示模拟UI);
}

export {};
