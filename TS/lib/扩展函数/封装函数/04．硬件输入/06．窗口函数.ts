/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 窗口函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
 */

const japi = require("jass.japi") as any;

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

export function getClientHeight(): number {
  return japi.DzGetClientHeight?.() || 0;
}
