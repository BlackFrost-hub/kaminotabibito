/**
 * UI工具 - 内容设置
 * Frame文本、纹理、事件设置
 */

const japi = require("jass.japi") as any;

import { frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";
import { EventType } from "./00．类型定义";

/**
 * 设置Frame纹理（仅设置纹理和透明度，不使用DzFrameSetVertexColor）
 */
export function setFrameTexture(frame: number, texture: string): boolean {
  if (frame === 0 || frame == null) return false;

  if (texture && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(frame, texture, 0);
  }

  return true;
}

/**
 * 设置Frame点击事件
 */
export function setFrameClickEvent(frame: number, callback: () => void, sync: boolean = true): boolean {
  if (frame === 0 || frame == null) return false;

  frameSetScriptByCode(frame, EventType.MOUSE_CLICK, callback, sync);
  return true;
}

/**
 * 设置Frame悬停事件
 */
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

/**
 * 设置GLUETEXTBUTTON的文本（DzFrameSetText仅对GLUETEXTBUTTON有效）
 */
export function setButtonText(frame: number, text: string): boolean {
  if (!frame || typeof japi.DzFrameSetText !== "function") {
    return false;
  }

  japi.DzFrameSetText(frame, text);
  return true;
}