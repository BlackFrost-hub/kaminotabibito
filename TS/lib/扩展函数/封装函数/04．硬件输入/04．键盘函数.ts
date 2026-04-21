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
    (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

  if (japi.DzTriggerRegisterKeyEventByCode) {
    japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, sync, action);
    return trig;
  }

  if (japi.DzTriggerRegisterKeyEvent) {
    japi.DzTriggerRegisterKeyEvent(trig, keyCode, status, sync, "");
    (jass as any).TriggerAddAction(trig, action);
    return trig;
  }

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
  if (typeof japi.DzTriggerRegisterKeyEventTrg === "function") {
    japi.DzTriggerRegisterKeyEventTrg(trig, KEY_STATE.DOWN, keyCode);
    (jass as any).TriggerAddAction(trig, action);
    return trig;
  }
  // fallback：DzTriggerRegisterKeyEventByCode（sync=false，仅本机触发）
  if (japi.DzTriggerRegisterKeyEventByCode) {
    japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, KEY_STATE.DOWN, false, action);
    return trig;
  }
  return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, action);
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
