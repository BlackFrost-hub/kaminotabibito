/**
 * UI工具 - 位置尺寸
 * Frame位置和尺寸设置
 */

const japi = require("jass.japi") as any;

import { PositionConfig, SizeConfig } from "./00．类型定义";

/**
 * 设置Frame位置（绝对坐标，屏幕）
 */
export function setFramePosition(frame: number, position: PositionConfig): boolean {
  if (frame === 0 || frame == null || typeof japi.DzFrameSetAbsolutePoint !== "function") {
    return false;
  }

  japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y);
  return true;
}

/**
 * 设置Frame相对位置（相对父/参考帧，用于子控件）
 */
export function setFramePointRelative(
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number
): boolean {
  if (
    frame === 0 ||
    frame == null ||
    relativeFrame === 0 ||
    relativeFrame == null ||
    typeof japi.DzFrameSetPoint !== "function"
  ) {
    return false;
  }
  japi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y);
  return true;
}

/**
 * 设置Frame尺寸
 */
export function setFrameSize(frame: number, size: SizeConfig): boolean {
  if (frame === 0 || frame == null || typeof japi.DzFrameSetSize !== "function") {
    return false;
  }

  japi.DzFrameSetSize(frame, size.width, size.height);
  return true;
}