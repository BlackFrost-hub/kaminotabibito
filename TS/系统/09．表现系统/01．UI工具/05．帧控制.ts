const japi = require("jass.japi") as any;

import { getGameUI } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

// ========== 虚拟分区：销毁 ==========
export function destroyFrame(frame: number): boolean {
  if (!frame) return false;
  japi.DzDestroyFrame(frame);
  return true;
}

// ========== 虚拟分区：显示隐藏 ==========
export function hideFrame(frame: number): boolean {
  if (!frame) return false;
  japi.DzFrameShow(frame, false);
  return true;
}

export function showFrame(frame: number): boolean {
  if (!frame) return false;
  japi.DzFrameShow(frame, true);
  return true;
}

// ========== 虚拟分区：根节点 ==========
export function getGameUIFrame(): number {
  return getGameUI();
}

