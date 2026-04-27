/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 鼠标函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
 * `sync=false` 的全局鼠标注册与滚轮一致，须经 `runFalseLocalRegistration`（见 `05．滚轮函数.ts`）。
 */

const japi = require("jass.japi") as any;
const { RMaxBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  RMaxBJ: (a: number, b: number) => number;
};

import { runFalseLocalRegistration } from "./02．内部工具";
import { getClientHeight, getWindowHeight } from "./06．窗口函数";

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

// -------------------- 全局鼠标 / 滚动条工具（勿 japiFn 取出再调） --------------------

/** 纵向 UI 归一化行程（如 LIST_VIEW_H - thumb）→ 与 Dz 纵向 0..0.6 对应的像素行程（任务分页滑块拖拽等） */
export function getScrollbarTrackThumbTravelPx(travelNorm: number): number {
  const ch = getClientHeight();
  const clientH = ch > 0 ? ch : getWindowHeight() || 600;
  return RMaxBJ(1, (clientH * travelNorm) / 0.6);
}

/**
 * 全局鼠标键 ByCode 注册；与 `registerMouseWheel` 同一套 sync / 本地玩家契约。
 * @param sync `true` 直接注册；`false` 必须经 `runFalseLocalRegistration`（禁止业务裸调 `DzTriggerRegisterMouseEventByCode`）
 */
export function registerMouseButtonEventByCode(
  trig: any,
  btn: number,
  status: number,
  sync: boolean,
  action: () => void,
  playerId?: number
): void {
  if (!trig || typeof (japi as any).DzTriggerRegisterMouseEventByCode !== "function") return;
  if (sync) {
    (japi as any).DzTriggerRegisterMouseEventByCode(trig, btn, status, true, action);
  } else {
    runFalseLocalRegistration(() => {
      (japi as any).DzTriggerRegisterMouseEventByCode(trig, btn, status, false, action);
    }, playerId);
  }
}

/**
 * 全局鼠标移动 ByCode；契约同 `registerMouseWheel` / `registerMouseButtonEventByCode`。
 */
export function registerMouseMoveEventByCode(
  trig: any,
  sync: boolean,
  action: () => void,
  playerId?: number
): void {
  if (!trig || typeof (japi as any).DzTriggerRegisterMouseMoveEventByCode !== "function") return;
  if (sync) {
    (japi as any).DzTriggerRegisterMouseMoveEventByCode(trig, true, action);
  } else {
    runFalseLocalRegistration(() => {
      (japi as any).DzTriggerRegisterMouseMoveEventByCode(trig, false, action);
    }, playerId);
  }
}
