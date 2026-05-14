/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 键盘函数
 *
 * 约定：
 * - `DzTriggerRegisterKeyEventTrg` 视为同步入口，不包本地玩家判断
 * - `DzTriggerRegisterKeyEventByCode(..., false, ...)` 视为本地入口，必须经由
 *   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
declare const string: { char: (n: number) => string } | undefined;

import { createTriggerOrNull, runFalseLocalRegistration } from "./02．内部工具";
import { KEY_STATE } from "./01．常量定义";

const syncKeyUpCallbackByTriggerHid: Record<number, ((player: any, key: number) => void) | undefined> = {};
const localKeyCallbackByTriggerHid: Record<number, ((this: any) => void) | undefined> = {};

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
  localKeyCallbackByTriggerHid[jass.GetHandleId(trig) as number] = action;
  runFalseLocalRegistration(() => {
    japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, false, onLocalKeyEvent);
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
  const trig = createTriggerOrNull();
  if (!trig) return null;
  DzTriggerRegisterKeyEventTrg(trig, KEY_STATE.UP, keyCode);
  syncKeyUpCallbackByTriggerHid[jass.GetHandleId(trig) as number] = callback;
  jass.TriggerAddAction(trig, onSyncKeyUp);
  return trig;
}

function onSyncKeyUp(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const cb = syncKeyUpCallbackByTriggerHid[jass.GetHandleId(trig) as number];
  if (typeof cb !== "function") return;
  const triggerPlayer = japi.DzGetTriggerKeyPlayer();
  const localPlayer = jass.GetLocalPlayer();
  // sync=true 热键仍会全房触发；这里只用本机聊天框状态过滤触发玩家本机的按键输入。
  // 已经过联机持续输入 J 压测，未发现掉线；但理论上仍保留约 1% 的状态分叉/掉线猜想风险。
  if (triggerPlayer === localPlayer && isChatInputActive()) return;
  cb(triggerPlayer, japi.DzGetTriggerKey());
}

function isChatInputActive(): boolean {
  if (japi.DzIsChatBoxOpen()) return true;

  const chatEditBar = japi.DzFrameGetChatEditBar();
  if (chatEditBar != null && chatEditBar !== 0 && japi.DzFrameIsFocus(chatEditBar)) return true;

  return false;
}

function onLocalKeyEvent(): void {
  if (isChatInputActive()) return;

  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const cb = localKeyCallbackByTriggerHid[jass.GetHandleId(trig) as number] as ((this: void) => void) | undefined;
  if (typeof cb !== "function") return;
  cb();
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
