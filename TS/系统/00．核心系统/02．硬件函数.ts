/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 核心系统 - 硬件函数
 *
 * 与 `lib/扩展函数/封装函数/04．硬件输入/*` 保持同一契约：
 * - `*Trg`：按同步入口处理，不包本地玩家判断
 * - `*ByCode(..., false)` / `DzFrameSetScriptByCode(..., false)`：
 *   必须走 `runFalseLocalRegistration(...)`，并支持可选 `playerId`
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
const { runFalseLocalRegistration } = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具") as {
  runFalseLocalRegistration: (register: () => void, playerId?: number) => void;
};
declare const string: { char: (n: number) => string } | undefined;

export const KEY_STATE = { DOWN: 1, UP: 0 } as const;
export const MOUSE_BUTTON = { LEFT: 1, RIGHT: 2, MIDDLE: 3 } as const;
export const KEY = {
  A: 65, B: 66, C: 67, D: 68, E: 69, F: 70,
  G: 71, H: 72, I: 73, J: 74, K: 75, L: 76,
  M: 77, N: 78, O: 79, P: 80, Q: 81, R: 82,
  S: 83, T: 84, U: 85, V: 86, W: 87, X: 88,
  Y: 89, Z: 90,
} as const;
export const KEY_F = {
  F1: 112, F2: 113, F3: 114, F4: 115,
  F5: 116, F6: 117, F7: 118, F8: 119,
  F9: 120, F10: 121, F11: 122, F12: 123,
} as const;
export const KEY_LETTER = KEY;
export const KEY_NUM = {
  K0: 48, K1: 49, K2: 50, K3: 51, K4: 52,
  K5: 53, K6: 54, K7: 55, K8: 56, K9: 57,
} as const;

export function has(name: string): boolean {
  return typeof (japi as any)[name] === "function";
}

export function isHardwareAPIAvailable(): boolean {
  return true;
}

export function getMouseTerrainX(): number { return japi.DzGetMouseTerrainX(); }
export function getMouseTerrainY(): number { return japi.DzGetMouseTerrainY(); }
export function getMouseTerrainZ(): number { return japi.DzGetMouseTerrainZ(); }
export function isMouseOverUI(): boolean { return !!japi.DzIsMouseOverUI(); }
export function getMouseX(): number { return japi.DzGetMouseX(); }
export function getMouseY(): number { return japi.DzGetMouseY(); }
export function getMouseXRelative(): number { return japi.DzGetMouseXRelative(); }
export function getMouseYRelative(): number { return japi.DzGetMouseYRelative(); }
export function setMousePos(x: number, y: number): void { japi.DzSetMousePos(x, y); }

export function isKeyDown(keyCode: number): boolean {
  return !!japi.DzIsKeyDown(keyCode);
}

function createTriggerOrNull(): any {
  return jass.CreateTrigger();
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
  action: () => void,
  playerId?: number
): void {
  if (typeof japi.DzTriggerRegisterKeyEventByCode !== "function") {
    registerKeyBindToTrigger(trig, status, keyCode);
    return;
  }
  runFalseLocalRegistration(() => {
    japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, false, action);
  }, playerId);
}

export function registerKeyEventByCode(
  keyCode: number,
  status: (typeof KEY_STATE)[keyof typeof KEY_STATE],
  sync: boolean,
  action: () => void,
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
  return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, () => {
    callback(japi.DzGetTriggerKeyPlayer(), japi.DzGetTriggerKey());
  }, playerId);
}

export function registerKeyUp(keyCode: number, callback: (player: any, key: number) => void, playerId?: number): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.UP, false, () => {
    callback(japi.DzGetTriggerKeyPlayer(), japi.DzGetTriggerKey());
  }, playerId);
}

export function registerKeyEventRawStatus(keyCode: number, status: number, sync: boolean, action: () => void, playerId?: number): any {
  return registerKeyEventByCode(keyCode, status as any, sync, action, playerId);
}

export function getTriggerKeyPlayer(): any {
  return japi.DzGetTriggerKeyPlayer();
}

export function getTriggerKey(): number {
  return japi.DzGetTriggerKey();
}

export function getWheelDelta(): number {
  return japi.DzGetWheelDelta();
}

export function registerMouseWheel(sync: boolean, action: () => void, playerId?: number): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  if (sync) {
    japi.DzTriggerRegisterMouseWheelEventByCode(trig, true, action);
  } else {
    runFalseLocalRegistration(() => {
      japi.DzTriggerRegisterMouseWheelEventByCode(trig, false, action);
    }, playerId);
  }
  return trig;
}

export function getWindowWidth(): number { return japi.DzGetWindowWidth(); }
export function getWindowHeight(): number { return japi.DzGetWindowHeight(); }
export function getWindowX(): number { return japi.DzGetWindowX(); }
export function getWindowY(): number { return japi.DzGetWindowY(); }
export function isWindowActive(): boolean { return !!japi.DzIsWindowActive(); }

export function getGameUI(): number {
  return japi.DzGetGameUI();
}

export function frameFindByName(name: string, id: number): number {
  return japi.DzFrameFindByName(name, id);
}

export function getMouseFocus(): number {
  return japi.DzGetMouseFocus();
}

export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean, playerId?: number): void {
  if (sync) {
    japi.DzFrameSetScriptByCode(frame, eventId, action, true);
    return;
  }
  runFalseLocalRegistration(() => {
    japi.DzFrameSetScriptByCode(frame, eventId, action, false);
  }, playerId);
}
