/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
 *
 * 目标：
 * - 只依赖运行时注入的 Dz* / EX*（平台本地/联机环境）
 * - 调用前做存在性检查，缺失时静默降级
 * - 避开 TSTL 坑：禁止对 jass API 用可选链调用；禁止把 jass.xxx 赋给局部变量再调用
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

// -------------------- 内部工具：注入/查找 --------------------

function japiFn(name: string): ((...args: any[]) => any) | null {
  const f = (japi as any)[name];
  return typeof f === "function" ? f : null;
}

// -------------------- 存在性检查 --------------------

export function has(name: string): boolean {
  return typeof (japi as any)[name] === "function";
}

export function isHardwareAPIAvailable(): boolean {
  return (
    typeof (japi as any).DzIsKeyDown === "function" &&
    typeof (japi as any).DzGetMouseX === "function" &&
    typeof (japi as any).DzGetMouseY === "function"
  );
}

// -------------------- 鼠标 --------------------

export function getMouseTerrainX(): number {
  const f = japiFn("DzGetMouseTerrainX");
  return f ? f() : 0;
}
export function getMouseTerrainY(): number {
  const f = japiFn("DzGetMouseTerrainY");
  return f ? f() : 0;
}
export function getMouseTerrainZ(): number {
  const f = japiFn("DzGetMouseTerrainZ");
  return f ? f() : 0;
}
export function isMouseOverUI(): boolean {
  const f = japiFn("DzIsMouseOverUI");
  return f ? !!f() : false;
}
export function getMouseX(): number {
  const f = japiFn("DzGetMouseX");
  return f ? f() : 0;
}
export function getMouseY(): number {
  const f = japiFn("DzGetMouseY");
  return f ? f() : 0;
}
export function getMouseXRelative(): number {
  const f = japiFn("DzGetMouseXRelative");
  return f ? f() : 0;
}
export function getMouseYRelative(): number {
  const f = japiFn("DzGetMouseYRelative");
  return f ? f() : 0;
}
export function setMousePos(x: number, y: number): void {
  const f = japiFn("DzSetMousePos");
  if (f) f(x, y);
}

// -------------------- 键盘 --------------------

export function isKeyDown(keyCode: number): boolean {
  const f = japiFn("DzIsKeyDown");
  return f ? !!f(keyCode) : false;
}

function createTriggerOrNull(): any {
  if (typeof (jass as any).CreateTrigger !== "function") return null;
  return (jass as any).CreateTrigger();
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

  // 平台 JASS 示例：DzTriggerRegisterKeyEventTrg(trig, 1, 'N')
  // 这里优先尝试 Trg 版本（第三参为单字符），再回退到 ByCode 版本。
  const fTrg = japiFn("DzTriggerRegisterKeyEventTrg") ?? ((globalThis as any)["DzTriggerRegisterKeyEventTrg"] as any);
  if (typeof fTrg === "function") {
    const keyChar = string && typeof string.char === "function" ? string.char(keyCode) : "";
    try {
      // 优先字符
      fTrg(trig, status, keyChar);
    } catch (_e0) {
      try {
        // 回退数字键码
        fTrg(trig, status, keyCode);
      } catch (_e1) {
        // ignore
      }
    }
    if (typeof (jass as any).TriggerAddAction === "function") (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

  // 只用 jass.japi：把函数取出来再调用，避免 self 注入
  const fByCode = japiFn("DzTriggerRegisterKeyEventByCode");
  if (fByCode) {
    fByCode(trig, keyCode, status, sync, action);
    return trig;
  }

  // 最后尝试 DzTriggerRegisterKeyEvent（string func）+ TriggerAddAction 兜底
  const fStr = japiFn("DzTriggerRegisterKeyEvent");
  if (fStr) {
    fStr(trig, keyCode, status, sync, "");
    if (typeof (jass as any).TriggerAddAction === "function") (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

  return trig;
}

export function registerKeyDown(keyCode: number, callback: (player: any, key: number) => void): any {
  // 实测：平台只在 sync=false 时派发
  return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, () => {
    const getP = japiFn("DzGetTriggerKeyPlayer");
    const getK = japiFn("DzGetTriggerKey");
    const p = getP ? getP() : null;
    const k = getK ? getK() : 0;
    callback(p, k);
  });
}

export function registerKeyUp(keyCode: number, callback: (player: any, key: number) => void): any {
  return registerKeyEventByCode(keyCode, KEY_STATE.UP, false, () => {
    const getP = japiFn("DzGetTriggerKeyPlayer");
    const getK = japiFn("DzGetTriggerKey");
    const p = getP ? getP() : null;
    const k = getK ? getK() : 0;
    callback(p, k);
  });
}

/** 仅用于测试：允许传原始 status 数值（0/1/2） */
function registerKeyEventRawStatus(keyCode: number, status: number, sync: boolean, action: () => void): any {
  return registerKeyEventByCode(keyCode, status as any, sync, action);
}

export function getTriggerKeyPlayer(): any {
  const f = japiFn("DzGetTriggerKeyPlayer");
  return f ? f() : null;
}

export function getTriggerKey(): number {
  const f = japiFn("DzGetTriggerKey");
  return f ? f() : 0;
}

// -------------------- 滚轮 --------------------

export function getWheelDelta(): number {
  const f = japiFn("DzGetWheelDelta");
  return f ? f() : 0;
}

export function registerMouseWheel(sync: boolean, action: () => void): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  const f = japiFn("DzTriggerRegisterMouseWheelEventByCode");
  if (!f) return null;
  f(trig, sync, action);
  return trig;
}

// -------------------- 窗口 --------------------

export function getWindowWidth(): number {
  const f = japiFn("DzGetWindowWidth");
  return f ? f() : 800;
}
export function getWindowHeight(): number {
  const f = japiFn("DzGetWindowHeight");
  return f ? f() : 600;
}
export function getWindowX(): number {
  const f = japiFn("DzGetWindowX");
  return f ? f() : 0;
}
export function getWindowY(): number {
  const f = japiFn("DzGetWindowY");
  return f ? f() : 0;
}
export function isWindowActive(): boolean {
  const f = japiFn("DzIsWindowActive");
  return f ? !!f() : true;
}

// -------------------- Frame（最小常用） --------------------

export function getGameUI(): number {
  const f = japiFn("DzGetGameUI");
  return f ? f() : 0;
}
 
export function frameFindByName(name: string, id: number): number {
  const f = japiFn("DzFrameFindByName");
  return f ? f(name, id) : 0;
}

/** 获取鼠标当前悬停的帧 */
export function getMouseFocus(): number {
  const f = japiFn("DzGetMouseFocus");
  return f ? f() : 0;
}

/** UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致 */
export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean): void {
  const f = japiFn("DzFrameSetScriptByCode");
  if (f) f(frame, eventId, action, sync);
}

// -------------------- 测试：B 键广播 9999 --------------------

function initTestKeyB(): void {
  if (typeof (jass as any).DisplayTimedTextToPlayer !== "function" || typeof (jass as any).Player !== "function") return;

  /**
   * 去抖 / 只在“松开”触发一次：
   *
   * 平台环境里键盘事件（DzTriggerRegisterKeyEventByCode）存在以下实测特性：
   * - 必须 `sync=false` 才会触发回调（sync=true 不触发）
   * - `status` 参数在 Lua/ByCode 这条链上不严格（0/1/2 都可能触发；甚至按住会重复派发）
   *
   * 因此不能指望只靠 status 区分按下/抬起。
   * 这里改用 DzIsKeyDown(keyCode) 做“边沿检测”：
   * - last=true 且 down=false 时，判定为“从按下→松开”，只触发一次。
   */
  const lastDownByPid: boolean[] = [];
  const getPid = typeof (jass as any).GetPlayerId === "function" ? (jass as any).GetPlayerId : null;

  // 监听任意键盘事件（status=0/1/2 全都注册），只在 “按下->松开” 边沿广播 9999
  const hook = (st: number) => {
    registerKeyEventRawStatus(KEY.B, st, false, () => {
      const getP = japiFn("DzGetTriggerKeyPlayer");
      const p = getP ? getP() : null;
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
  // 初始化为“未按下”，避免第一次事件误触发
  for (let i = 0; i < 12; i++) lastDownByPid[i] = false;
}

initTestKeyB();

export {};

