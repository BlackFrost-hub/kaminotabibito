/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
 *
 * 与 `lib/扩展函数/封装函数/04．硬件输入` 保持一致：
 * TSTL 会把「japi 表取出再赋给局部变量调用」编成多传 nil 首参，导致 DzFrameSetScriptByCode / 键鼠注册等参数错位。
 * 因此一律 `japi.DzXxx(...)` 直接点号调用，禁止本文件内再写 japiFn 模式。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
declare const string: { char: (n: number) => string } | undefined;

// -------------------- 常量 --------------------

/** 按键状态（DzTriggerRegisterKeyEventTrg：1=按下，0=抬起） */
export const KEY_STATE = { DOWN: 1, UP: 0 } as const;

/** 鼠标按键（BzAPI：1=左，2=右，3=中） */
export const MOUSE_BUTTON = { LEFT: 1, RIGHT: 2, MIDDLE: 3 } as const;

/** A-Z */
export const KEY = {
  A: 65, B: 66, C: 67, D: 68, E: 69, F: 70,
  G: 71, H: 72, I: 73, J: 74, K: 75, L: 76,
  M: 77, N: 78, O: 79, P: 80, Q: 81, R: 82,
  S: 83, T: 84, U: 85, V: 86, W: 87, X: 88,
  Y: 89, Z: 90,
} as const;

/** F1-F12 */
export const KEY_F = {
  F1: 112, F2: 113, F3: 114, F4: 115,
  F5: 116, F6: 117, F7: 118, F8: 119,
  F9: 120, F10: 121, F11: 122, F12: 123,
} as const;

/** 字母键（兼容旧代码，推荐使用 KEY） */
export const KEY_LETTER = KEY;

/** 0-9 */
export const KEY_NUM = {
  K0: 48, K1: 49, K2: 50, K3: 51, K4: 52,
  K5: 53, K6: 54, K7: 55, K8: 56, K9: 57,
} as const;

// -------------------- 存在性检查 --------------------

export function has(name: string): boolean {
  return typeof (japi as any)[name] === "function";
}

export function isHardwareAPIAvailable(): boolean {
  return true;
}

// -------------------- 鼠标 --------------------

export function getMouseTerrainX(): number {
  return japi.DzGetMouseTerrainX();
}
export function getMouseTerrainY(): number {
  return japi.DzGetMouseTerrainY();
}
export function getMouseTerrainZ(): number {
  return japi.DzGetMouseTerrainZ();
}
export function isMouseOverUI(): boolean {
  return !!japi.DzIsMouseOverUI();
}
export function getMouseX(): number {
  return japi.DzGetMouseX();
}
export function getMouseY(): number {
  return japi.DzGetMouseY();
}
export function getMouseXRelative(): number {
  return japi.DzGetMouseXRelative();
}
export function getMouseYRelative(): number {
  return japi.DzGetMouseYRelative();
}
export function setMousePos(x: number, y: number): void {
  japi.DzSetMousePos(x, y);
}

// -------------------- 键盘 --------------------

export function isKeyDown(keyCode: number): boolean {
  return !!japi.DzIsKeyDown(keyCode);
}

function createTriggerOrNull(): any {
  return (jass as any).CreateTrigger();
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

/** F1–F12、Tab、OEM 区（含 ~ =192）：与 JASS 一致用 VK 数字，勿用 string.char（F2→q、Tab→控制符、192→与引擎不一致）。 */
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

/** sync=false 时走 ByCode(..., false)，仅本机触发，避免纯 UI 热键走全房 sync。 */
function registerKeyBindToTriggerLocal(trig: any, status: number, keyCode: number, action: () => void): void {
  if (typeof japi.DzTriggerRegisterKeyEventByCode !== "function") {
    registerKeyBindToTrigger(trig, status, keyCode);
    return;
  }
  japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, false, action);
}

/** 注册按键事件（by code）。sync=true 全房回调；sync=false 仅本机（与 `封装函数/04．硬件输入/04．键盘函数` 一致）。 */
export function registerKeyEventByCode(
  keyCode: number,
  status: (typeof KEY_STATE)[keyof typeof KEY_STATE],
  sync: boolean,
  action: () => void
): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;

  if (sync) {
    registerKeyBindToTrigger(trig, status, keyCode);
    (jass as any).TriggerAddAction(trig, action);
  } else {
    registerKeyBindToTriggerLocal(trig, status, keyCode, action);
  }
  return trig;
}

export function registerKeyDown(keyCode: number, callback: (player: any, key: number) => void): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, () => {
    const p = japi.DzGetTriggerKeyPlayer();
    const k = japi.DzGetTriggerKey();
    callback(p, k);
  });
}

export function registerKeyUp(keyCode: number, callback: (player: any, key: number) => void): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.UP, false, () => {
    const p = japi.DzGetTriggerKeyPlayer();
    const k = japi.DzGetTriggerKey();
    callback(p, k);
  });
}

/** 仅用于测试：允许传原始 status 数值（0/1/2） */
export function registerKeyEventRawStatus(keyCode: number, status: number, sync: boolean, action: () => void): any {
  return registerKeyEventByCode(keyCode, status as any, sync, action);
}

export function getTriggerKeyPlayer(): any {
  return japi.DzGetTriggerKeyPlayer();
}

export function getTriggerKey(): number {
  return japi.DzGetTriggerKey();
}

// -------------------- 滚轮 --------------------

export function getWheelDelta(): number {
  return japi.DzGetWheelDelta();
}

export function registerMouseWheel(sync: boolean, action: () => void): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action);
  return trig;
}

// -------------------- 窗口 --------------------

export function getWindowWidth(): number {
  return japi.DzGetWindowWidth();
}
export function getWindowHeight(): number {
  return japi.DzGetWindowHeight();
}
export function getWindowX(): number {
  return japi.DzGetWindowX();
}
export function getWindowY(): number {
  return japi.DzGetWindowY();
}
export function isWindowActive(): boolean {
  return !!japi.DzIsWindowActive();
}

// -------------------- Frame（最小常用） --------------------

export function getGameUI(): number {
  return japi.DzGetGameUI();
}

export function frameFindByName(name: string, id: number): number {
  return japi.DzFrameFindByName(name, id);
}

/** 获取鼠标当前悬停的帧 */
export function getMouseFocus(): number {
  return japi.DzGetMouseFocus();
}

/** UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致 */
export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean): void {
  japi.DzFrameSetScriptByCode(frame, eventId, action, sync);
}
