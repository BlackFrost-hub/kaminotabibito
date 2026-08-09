/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 键盘函数
 *
 * 约定：
 * - `DzTriggerRegisterKeyEventTrg` 视为同步入口，不包本地玩家判断
 * - `DzTriggerRegisterKeyEventByCode(..., false, ...)` 视为本地入口，必须经由
 *   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
 * - `registerKeyUpSync` 先在本机过滤聊天框，再通过同步数据回调全端派发
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
declare const string: { char: (n: number) => string } | undefined;

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (
  this: void,
  trigger: any,
  callback: (this: void) => void
) => any;
const I2S = jass.I2S as (this: void, value: number) => string;
const S2I = jass.S2I as (this: void, value: string) => number;
const DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode as (
  this: void,
  trigger: any,
  keyCode: number,
  status: number,
  sync: boolean,
  callback: (this: void) => void
) => void;
const DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData as (
  this: void,
  trigger: any,
  prefix: string,
  server: boolean
) => void;
const DzSyncData = japi.DzSyncData as (this: void, prefix: string, data: string) => void;
const DzGetTriggerSyncPlayer = japi.DzGetTriggerSyncPlayer as (this: void) => any;
const DzGetTriggerSyncData = japi.DzGetTriggerSyncData as (this: void) => string;
const DzGetTriggerKey = japi.DzGetTriggerKey as (this: void) => number;

import { createTriggerOrNull, runFalseLocalRegistration } from "./02．内部工具";
import { KEY_STATE } from "./01．常量定义";

const syncKeyUpCallbacksByKey: Record<number, Array<(player: any, key: number) => void> | undefined> = {};
const syncKeyUpTriggerByKey: Record<number, any | undefined> = {};
const localKeyCallbacksByKeyAndStatus: Record<string, Array<(this: any) => void> | undefined> = {};
const syncKeyUpPrefix = "KEYUP";
let syncKeyUpDataTrigger: any = null;

export function isKeyDown(keyCode: number): boolean {
  return !!japi.DzIsKeyDown(keyCode);
}

function keyCodeToTrgChar(keyCode: number): string {
  if (string && typeof string.char === "function" && keyCode >= 1 && keyCode <= 255) {
    try {
      return string.char(keyCode);
    } catch (_e) {
      return "";
    }
  }
  return "";
}

function registerKeyBindToTrigger(trig: any, status: number, keyCode: number): void {
  if (keyCode >= 112 && keyCode <= 123) {
    DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
    return;
  }
  if (keyCode >= 1 && keyCode < 32) {
    DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
    return;
  }
  if ((keyCode >= 186 && keyCode <= 192) || (keyCode >= 219 && keyCode <= 222)) {
    DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
    return;
  }
  const keyChar = keyCodeToTrgChar(keyCode);
  try {
    DzTriggerRegisterKeyEventTrg(trig, status, keyChar);
  } catch (_e0) {
    try {
      DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
    } catch (_e1) {
      // ignore
    }
  }
}

function registerKeyBindToTriggerLocal(
  trig: any,
  status: number,
  keyCode: number,
  action: (this: any) => void,
  playerId?: number
): void {
  const dispatchKey = getLocalDispatchKey(keyCode, status);
  let list = localKeyCallbacksByKeyAndStatus[dispatchKey];
  if (list == null) {
    list = [];
    localKeyCallbacksByKeyAndStatus[dispatchKey] = list;
  }
  list.push(action);
  runFalseLocalRegistration(() => {
    japi.DzTriggerRegisterKeyEventByCode(
      trig,
      keyCode,
      status,
      false,
      status === KEY_STATE.UP ? onLocalKeyUpEvent : onLocalKeyDownEvent
    );
  }, playerId);
}

function getTriggerKeyPlayerOrLocal(): any {
  const player = japi.DzGetTriggerKeyPlayer();
  if (player != null && player !== 0) return player;
  return jass.GetLocalPlayer();
}

export function registerKeyEventByCode(
  keyCode: number,
  status: (typeof KEY_STATE)[keyof typeof KEY_STATE],
  sync: boolean,
  action: (this: any) => void,
  playerId?: number
): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;

  if (sync) {
    registerKeyBindToTrigger(trig, status, keyCode);
    jass.TriggerAddAction(trig, action);
  } else {
    registerKeyBindToTriggerLocal(trig, status, keyCode, action, playerId);
  }
  return trig;
}

export function registerKeyDown(keyCode: number, callback: (player: any, key: number) => void, playerId?: number): any {
  return registerKeyEventByCode(
    keyCode,
    KEY_STATE.DOWN,
    false,
    () => {
      callback(getTriggerKeyPlayerOrLocal(), japi.DzGetTriggerKey());
    },
    playerId
  );
}

export function registerKeyDownLocal(keyCode: number, callback: (player: any, key: number) => void, playerId?: number): any {
  return registerKeyDown(keyCode, callback, playerId);
}

export function registerKeyUp(keyCode: number, callback: (player: any, key: number) => void, playerId?: number): any {
  return registerKeyEventByCode(
    keyCode,
    KEY_STATE.UP,
    false,
    () => {
      callback(getTriggerKeyPlayerOrLocal(), japi.DzGetTriggerKey());
    },
    playerId
  );
}

export function registerKeyUpLocal(keyCode: number, callback: (player: any, key: number) => void, playerId?: number): any {
  return registerKeyUp(keyCode, callback, playerId);
}

export function registerKeyUpSync(keyCode: number, callback: (player: any, key: number) => void): any {
  ensureSyncKeyUpDataTrigger();

  let callbacks = syncKeyUpCallbacksByKey[keyCode];
  if (callbacks == null) {
    callbacks = [];
    syncKeyUpCallbacksByKey[keyCode] = callbacks;
  }
  callbacks.push(callback);

  let trig = syncKeyUpTriggerByKey[keyCode];
  if (trig != null && trig !== 0) return trig;
  trig = CreateTrigger();
  if (trig == null || trig === 0) return null;
  syncKeyUpTriggerByKey[keyCode] = trig;
  DzTriggerRegisterKeyEventByCode(trig, keyCode, KEY_STATE.UP, false, onLocalSyncKeyUpRequest);
  return trig;
}

function ensureSyncKeyUpDataTrigger(this: void): void {
  if (syncKeyUpDataTrigger != null && syncKeyUpDataTrigger !== 0) return;
  syncKeyUpDataTrigger = CreateTrigger();
  if (syncKeyUpDataTrigger == null || syncKeyUpDataTrigger === 0) return;
  TriggerAddAction(syncKeyUpDataTrigger, onSyncKeyUpData);
  DzTriggerRegisterSyncData(syncKeyUpDataTrigger, syncKeyUpPrefix, false);
}

function onLocalSyncKeyUpRequest(this: void): void {
  if (isChatInputActive()) return;
  const keyCode = DzGetTriggerKey();
  if (!(keyCode > 0)) return;
  DzSyncData(syncKeyUpPrefix, I2S(keyCode));
}

function onSyncKeyUpData(this: void): void {
  const triggerPlayer = DzGetTriggerSyncPlayer();
  if (triggerPlayer == null || triggerPlayer === 0) return;
  const keyCode = S2I(DzGetTriggerSyncData());
  const callbacks = syncKeyUpCallbacksByKey[keyCode];
  if (callbacks == null) return;
  for (let i = 0; i < callbacks.length; i++) {
    const callback = callbacks[i];
    if (typeof callback === "function") callback(triggerPlayer, keyCode);
  }
}

function isChatInputActive(this: void): boolean {
  if (japi.DzIsChatBoxOpen()) return true;

  const chatEditBar = japi.DzFrameGetChatEditBar();
  if (chatEditBar != null && chatEditBar !== 0 && japi.DzFrameIsFocus(chatEditBar)) return true;

  return false;
}

function getLocalDispatchKey(this: void, keyCode: number, status: number): string {
  return tostring(keyCode) + ":" + tostring(status);
}

function dispatchLocalKeyEvent(this: void, status: number): void {
  if (isChatInputActive()) return;

  const key = japi.DzGetTriggerKey();
  const callbacks = localKeyCallbacksByKeyAndStatus[getLocalDispatchKey(key, status)];
  if (callbacks == null) return;
  for (let i = 0; i < callbacks.length; i++) {
    const cb = callbacks[i];
    if (typeof cb === "function") cb();
  }
}

function onLocalKeyDownEvent(this: void): void {
  dispatchLocalKeyEvent(KEY_STATE.DOWN);
}

function onLocalKeyUpEvent(this: void): void {
  dispatchLocalKeyEvent(KEY_STATE.UP);
}

export function registerKeyEventRawStatus(keyCode: number, status: number, sync: boolean, action: (this: any) => void, playerId?: number): any {
  return registerKeyEventByCode(keyCode, status as any, sync, action, playerId);
}

export function getTriggerKeyPlayer(): any {
  return japi.DzGetTriggerKeyPlayer();
}

export function getTriggerKey(): number {
  return japi.DzGetTriggerKey();
}
