/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 鼠标函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
 */

const japi = require("jass.japi") as any;

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
