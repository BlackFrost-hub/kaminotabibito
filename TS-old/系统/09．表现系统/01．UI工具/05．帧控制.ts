/**
 * UI工具 - 帧控制
 * Frame显示/隐藏、销毁、获取游戏UI
 */

const japi = require("jass.japi") as any;

import { getGameUI } from "../../00．核心系统/04．硬件函数";

/**
 * 隐藏Frame
 */
export function hideFrame(frame: number): boolean {
  if (!frame || typeof japi.DzFrameShow !== "function") {
    return false;
  }

  japi.DzFrameShow(frame, false);
  return true;
}

/**
 * 显示Frame
 */
export function showFrame(frame: number): boolean {
  if (!frame || typeof japi.DzFrameShow !== "function") {
    return false;
  }

  japi.DzFrameShow(frame, true);
  return true;
}

/**
 * 获取游戏UI根Frame
 */
export function getGameUIFrame(): number {
  return getGameUI();
}