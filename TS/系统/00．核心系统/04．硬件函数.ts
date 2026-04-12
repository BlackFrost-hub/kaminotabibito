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
declare const string: { char: (n: number) => string } | undefined;

// -------------------- 常量 --------------------

/** 按键状态（BzAPI：1=按下，2=抬起） */
export const KEY_STATE = { DOWN: 1, UP: 2 } as const;

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
  return (
    typeof japi.DzIsKeyDown === "function" &&
    typeof japi.DzGetMouseX === "function" &&
    typeof japi.DzGetMouseY === "function"
  );
}

// -------------------- 鼠标 --------------------

export function getMouseTerrainX(): number {
  if (typeof japi.DzGetMouseTerrainX !== "function") return 0;
  return japi.DzGetMouseTerrainX();
}
export function getMouseTerrainY(): number {
  if (typeof japi.DzGetMouseTerrainY !== "function") return 0;
  return japi.DzGetMouseTerrainY();
}
export function getMouseTerrainZ(): number {
  if (typeof japi.DzGetMouseTerrainZ !== "function") return 0;
  return japi.DzGetMouseTerrainZ();
}
export function isMouseOverUI(): boolean {
  if (typeof japi.DzIsMouseOverUI !== "function") return false;
  return !!japi.DzIsMouseOverUI();
}
export function getMouseX(): number {
  if (typeof japi.DzGetMouseX !== "function") return 0;
  return japi.DzGetMouseX();
}
export function getMouseY(): number {
  if (typeof japi.DzGetMouseY !== "function") return 0;
  return japi.DzGetMouseY();
}
export function getMouseXRelative(): number {
  if (typeof japi.DzGetMouseXRelative !== "function") return 0;
  return japi.DzGetMouseXRelative();
}
export function getMouseYRelative(): number {
  if (typeof japi.DzGetMouseYRelative !== "function") return 0;
  return japi.DzGetMouseYRelative();
}
export function setMousePos(x: number, y: number): void {
  if (typeof japi.DzSetMousePos !== "function") return;
  japi.DzSetMousePos(x, y);
}

// -------------------- 键盘 --------------------

export function isKeyDown(keyCode: number): boolean {
  if (typeof japi.DzIsKeyDown !== "function") return false;
  return !!japi.DzIsKeyDown(keyCode);
}

function createTriggerOrNull(): any {
  if (typeof (jass as any).CreateTrigger !== "function") return null;
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

/** 注册按键事件（by code）。注意：这里不做 try/catch 兜底，避免不必要的同步差异。 */
export function registerKeyEventByCode(
  keyCode: number,
  status: (typeof KEY_STATE)[keyof typeof KEY_STATE],
  sync: boolean,
  action: () => void
): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;

  const keyChar = keyCodeToTrgChar(keyCode);
  if (typeof japi.DzTriggerRegisterKeyEventTrg === "function") {
    try {
      japi.DzTriggerRegisterKeyEventTrg(trig, status, keyChar);
    } catch (_e0) {
      try {
        japi.DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
      } catch (_e1) {
        // ignore
      }
    }
    if (typeof (jass as any).TriggerAddAction === "function") (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

  if (typeof japi.DzTriggerRegisterKeyEventByCode === "function") {
    japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, sync, action);
    return trig;
  }

  if (typeof japi.DzTriggerRegisterKeyEvent === "function") {
    japi.DzTriggerRegisterKeyEvent(trig, keyCode, status, sync, "");
    if (typeof (jass as any).TriggerAddAction === "function") (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

  return trig;
}

export function registerKeyDown(keyCode: number, callback: (player: any, key: number) => void): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, () => {
    const p = typeof japi.DzGetTriggerKeyPlayer === "function" ? japi.DzGetTriggerKeyPlayer() : null;
    const k = typeof japi.DzGetTriggerKey === "function" ? japi.DzGetTriggerKey() : 0;
    callback(p, k);
  });
}

export function registerKeyUp(keyCode: number, callback: (player: any, key: number) => void): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.UP, false, () => {
    const p = typeof japi.DzGetTriggerKeyPlayer === "function" ? japi.DzGetTriggerKeyPlayer() : null;
    const k = typeof japi.DzGetTriggerKey === "function" ? japi.DzGetTriggerKey() : 0;
    callback(p, k);
  });
}

/** 仅用于测试：允许传原始 status 数值（0/1/2） */
export function registerKeyEventRawStatus(keyCode: number, status: number, sync: boolean, action: () => void): any {
  return registerKeyEventByCode(keyCode, status as any, sync, action);
}

export function getTriggerKeyPlayer(): any {
  return typeof japi.DzGetTriggerKeyPlayer === "function" ? japi.DzGetTriggerKeyPlayer() : null;
}

export function getTriggerKey(): number {
  return typeof japi.DzGetTriggerKey === "function" ? japi.DzGetTriggerKey() : 0;
}

// -------------------- 滚轮 --------------------

export function getWheelDelta(): number {
  if (typeof japi.DzGetWheelDelta !== "function") return 0;
  return japi.DzGetWheelDelta();
}

export function registerMouseWheel(sync: boolean, action: () => void): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  if (typeof japi.DzTriggerRegisterMouseWheelEventByCode !== "function") return null;
  japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action);
  return trig;
}

// -------------------- 窗口 --------------------

export function getWindowWidth(): number {
  if (typeof japi.DzGetWindowWidth !== "function") return 800;
  return japi.DzGetWindowWidth();
}
export function getWindowHeight(): number {
  if (typeof japi.DzGetWindowHeight !== "function") return 600;
  return japi.DzGetWindowHeight();
}
export function getWindowX(): number {
  if (typeof japi.DzGetWindowX !== "function") return 0;
  return japi.DzGetWindowX();
}
export function getWindowY(): number {
  if (typeof japi.DzGetWindowY !== "function") return 0;
  return japi.DzGetWindowY();
}
export function isWindowActive(): boolean {
  if (typeof japi.DzIsWindowActive !== "function") return true;
  return !!japi.DzIsWindowActive();
}

// -------------------- Frame（最小常用） --------------------

export function getGameUI(): number {
  if (typeof japi.DzGetGameUI !== "function") return 0;
  return japi.DzGetGameUI();
}

export function frameFindByName(name: string, id: number): number {
  if (typeof japi.DzFrameFindByName !== "function") return 0;
  return japi.DzFrameFindByName(name, id);
}

/** 获取鼠标当前悬停的帧 */
export function getMouseFocus(): number {
  if (typeof japi.DzGetMouseFocus !== "function") return 0;
  return japi.DzGetMouseFocus();
}

/** UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致 */
export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean): void {
  if (typeof japi.DzFrameSetScriptByCode !== "function") return;
  japi.DzFrameSetScriptByCode(frame, eventId, action, sync);
}

// -------------------- 测试：B 键广播 9999 --------------------

function initTestKeyB(): void {
  if (typeof (jass as any).DisplayTimedTextToPlayer !== "function" || typeof (jass as any).Player !== "function") return;

  const lastDownByPid: boolean[] = [];
  const getPid = typeof (jass as any).GetPlayerId === "function" ? (jass as any).GetPlayerId : null;

  const hook = (st: number) => {
    registerKeyEventRawStatus(KEY.B, st, false, () => {
      const p = typeof japi.DzGetTriggerKeyPlayer === "function" ? japi.DzGetTriggerKeyPlayer() : null;
      const pid = getPid && p ? getPid(p) : 0;
      const down = isKeyDown(KEY.B);
      const last = !!lastDownByPid[pid];
      lastDownByPid[pid] = down;
      if (last && !down) {
        for (let i = 0; i < 12; i++) {
          (jass as any).DisplayTimedTextToPlayer((jass as any).Player(i), 0, 0, 3, "9999");
        }
        if (typeof (jass as any).GetPlayerName === "function" && p) {
          (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 3, "from=" + (jass as any).GetPlayerName(p));
        }
      }
    });
  };

  hook(0);
  hook(1);
  hook(2);
  for (let i = 0; i < 12; i++) lastDownByPid[i] = false;
}

initTestKeyB();
