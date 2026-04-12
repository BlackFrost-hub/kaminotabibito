const japi = require("jass.japi") as any;

import { frameSetScriptByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { EventType } from "./00．类型定义";

// ========== 虚拟分区：视觉内容 ==========
export function setFrameTexture(frame: number, texture: string): boolean {
  if (frame === 0 || frame == null) return false;
  if (texture && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(frame, texture, 0);
  }
  return true;
}

// ========== 虚拟分区：交互事件 ==========
export function setFrameClickEvent(frame: number, callback: () => void, sync: boolean = true): boolean {
  if (frame === 0 || frame == null) return false;
  frameSetScriptByCode(frame, EventType.MOUSE_CLICK, callback, sync);
  return true;
}

export function setFrameHoverEvents(
  frame: number,
  onEnter: () => void,
  onLeave: () => void,
  sync: boolean = true
): boolean {
  if (frame === 0 || frame == null) return false;
  frameSetScriptByCode(frame, EventType.MOUSE_ENTER, onEnter, sync);
  frameSetScriptByCode(frame, EventType.MOUSE_LEAVE, onLeave, sync);
  return true;
}

// ========== 虚拟分区：文本内容 ==========
export function setButtonText(frame: number, text: string): boolean {
  if (!frame || typeof japi.DzFrameSetText !== "function") return false;
  japi.DzFrameSetText(frame, text);
  return true;
}

