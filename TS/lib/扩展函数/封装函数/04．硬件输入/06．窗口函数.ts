/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 窗口函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
 */

const japi = require("jass.japi") as any;

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
