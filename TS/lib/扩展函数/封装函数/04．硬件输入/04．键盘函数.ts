/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 键盘函数
 *
 * 注意：TSTL 会把「从表里取出的 japi 函数再调用」编成多传一个 nil/self 首参，
 * 导致 DzTriggerRegisterKeyEventTrg / ByCode 等参数整体错位、热键全部失效。
 * 因此注册键位时一律用 japi.DzXxx(...) 直接点号调用（勿赋给局部再调）。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
declare const string: { char: (n: number) => string } | undefined;

import { createTriggerOrNull } from "./02．内部工具";
import { KEY_STATE } from "./01．常量定义";

// -------------------- 键盘 --------------------

export function isKeyDown(keyCode: number): boolean {
  if (typeof japi.DzIsKeyDown !== "function") return false;
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

/**
 * - VK 112–123（F1–F12）：必须用数字；string.char(113) 会变成 `q` 而非 F2。
 * - VK 1–31（含 Tab=9）：JASS 用数字；string.char(9) 是制表符，与引擎不一致会导致 Tab 失效。
 * - VK 186–192、219–222（OEM 标点 / `~ 等）：须用数字；string.char(192) 等与 Dz 侧 VK 不一致会导致 ~ 跳过等失效。
 */
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

/**
 * 注册按键事件（by code）。
 * sync=true：全房所有客户端触发；sync=false：仅本机触发。
 * 注意：这里不做 try/catch 兜底，避免不必要的同步差异。
 */
export function registerKeyEventByCode(
  keyCode: number,
  status: (typeof KEY_STATE)[keyof typeof KEY_STATE],
  sync: boolean,
  action: () => void
): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;

  registerKeyBindToTrigger(trig, status, keyCode);
  (jass as any).TriggerAddAction(trig, action);
  return trig;
}

export function registerKeyDown(keyCode: number, callback: (player: any, key: number) => void): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  const action = () => {
    const p = japi.DzGetTriggerKeyPlayer();
    const k = japi.DzGetTriggerKey();
    callback(p, k);
  };
  // DzTriggerRegisterKeyEventTrg(trg, status, key)：JASS 封装，内部 sync=true，全房所有客户端触发回调。
  // 参数顺序（JASS 源文件确认）：第2参是 status(DOWN=1)，第3参是 keyCode。
  // 注意：sync=true 的键盘回调内，全局操作必须在本地玩家判断之外执行（与 frameSetScriptByCode sync=true 规则一致）。
  DzTriggerRegisterKeyEventTrg(trig, KEY_STATE.DOWN, keyCode);
  (jass as any).TriggerAddAction(trig, action);
  return trig;
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
