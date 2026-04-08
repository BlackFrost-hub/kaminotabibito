/**
 * UI工具 - 复合组件
 * 预组合的UI组件（图标按钮、文本按钮、文本标签、文本框等）
 */

const japi = require("jass.japi") as any;

import { FrameType } from "./00．类型定义";
import { PositionConfig, RelativePositionConfig, SizeConfig } from "./00．类型定义";
import { createFrame } from "./01．帧创建";
import { setFramePosition, setFramePointRelative, setFrameSize } from "./02．位置尺寸";
import { setFrameTexture, setFrameClickEvent, setFrameHoverEvents, setButtonText } from "./03．内容设置";

/**
 * 创建可点击的图标（BACKDROP + GLUETEXTBUTTON组合）
 */
export function createClickableIcon(
  name: string,
  parent: number,
  texture: string,
  position: PositionConfig,
  size: SizeConfig,
  onClick: () => void
): { backdrop: number; button: number } | null {
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (!backdrop) return null;

  setFramePosition(backdrop, position);
  setFrameSize(backdrop, size);
  setFrameTexture(backdrop, texture);

  const button = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name: `${name}_Button`,
    parent: backdrop,
    template: "template",
    visible: true,
    enable: true,
    alpha: 0,
  });

  if (!button) return null;

  if (typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(button, backdrop);
  } else {
    setFramePosition(button, position);
    setFrameSize(button, size);
  }

  setFrameClickEvent(button, onClick);

  return { backdrop, button };
}

/**
 * 创建文本按钮（GLUETEXTBUTTON显示文本，可点击）
 */
export function createTextButton(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  onClick?: () => void
): number | null {
  const frame = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name,
    parent,
    template: "template",
    visible: true,
    enable: true,
  });

  if (!frame) return null;

  setFramePosition(frame, position);
  setFrameSize(frame, size);
  setButtonText(frame, text);

  if (onClick) {
    setFrameClickEvent(frame, onClick);
  }

  return frame;
}

/**
 * 创建纯文本标签（使用TEXT类型）
 * position 支持 PositionConfig（绝对）或 RelativePositionConfig（相对父帧）
 */
export function createTextLabel(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig | RelativePositionConfig,
  size: SizeConfig
): number | null {
  const isRelative = "relativeTo" in position;
  const setPos = (f: number) => {
    if (isRelative) {
      const r = position as RelativePositionConfig;
      setFramePointRelative(f, r.point, r.relativeTo, r.relativePoint, r.x, r.y);
    } else {
      setFramePosition(f, position as PositionConfig);
    }
  };

  // 优先使用TEXT类型
  const frame = createFrame({
    type: FrameType.TEXT,
    name,
    parent,
    template: "template",
    visible: true,
  });

  if (frame) {
    setPos(frame);
    setFrameSize(frame, size);
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(frame, text);
    }
    return frame;
  }

  // 回退到GLUETEXTBUTTON
  const fallbackFrame = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name,
    parent,
    template: "template",
    visible: true,
  });

  if (!fallbackFrame) return null;

  setPos(fallbackFrame);
  setFrameSize(fallbackFrame, size);
  setButtonText(fallbackFrame, text);

  return fallbackFrame;
}

/**
 * 创建文本框（使用TEXTAREA类型，带背景）
 */
export function createTextArea(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture?: string
): number | null {
  // 创建背景
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (backdrop) {
    setFramePosition(backdrop, position);
    setFrameSize(backdrop, size);
    if (backgroundTexture && typeof japi.DzFrameSetTexture === "function") {
      japi.DzFrameSetTexture(backdrop, backgroundTexture, 0);
    }
  }

  // 创建TEXTAREA
  const frame = createFrame({
    type: FrameType.TEXTAREA,
    name,
    parent: backdrop || parent,
    template: "template",
    visible: true,
  });

  if (frame) {
    // 使用DzFrameSetAllPoints让TEXTAREA填充背景
    if (backdrop && typeof japi.DzFrameSetAllPoints === "function") {
      japi.DzFrameSetAllPoints(frame, backdrop);
    } else {
      setFramePosition(frame, position);
      setFrameSize(frame, size);
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(frame, text);
    }
    return frame;
  }

  // 回退到TEXT
  return createTextLabel(name, parent, text, position, size);
}

/**
 * 创建带背景的文本框容器
 */
export function createTextBox(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture: string
): { backdrop: number; text: number } | null {
  // 创建背景
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (!backdrop) return null;

  setFramePosition(backdrop, position);
  setFrameSize(backdrop, size);
  setFrameTexture(backdrop, backgroundTexture);

  // 创建文本
  const textFrame = createFrame({
    type: FrameType.TEXT,
    name: `${name}_Text`,
    parent: backdrop,
    template: "template",
    visible: true,
  });

  if (!textFrame) {
    destroyFrame(backdrop);
    return null;
  }

  // 文本稍微内缩
  const innerPos: PositionConfig = {
    point: position.point,
    x: position.x + 0.005,
    y: position.y - 0.005,
  };
  const innerSize: SizeConfig = {
    width: size.width - 0.01,
    height: size.height - 0.01,
  };

  setFramePosition(textFrame, innerPos);
  setFrameSize(textFrame, innerSize);

  if (typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(textFrame, text);
  }

  return { backdrop, text: textFrame };
}

/**
 * 销毁Frame
 */
export function destroyFrame(frame: number): boolean {
  if (!frame || typeof japi.DzDestroyFrame !== "function") {
    return false;
  }

  japi.DzDestroyFrame(frame);
  return true;
}
