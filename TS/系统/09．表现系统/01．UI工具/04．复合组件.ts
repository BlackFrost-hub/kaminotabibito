const japi = require("jass.japi") as any;

import {
  FrameType,
  PositionConfig,
  RelativePositionConfig,
  SizeConfig,
} from "./00．类型定义";
import { createFrame } from "./01．帧创建";
import { setFramePosition, setFramePointRelative, setFrameSize } from "./02．位置尺寸";
import { setButtonText, setFrameClickEvent, setFrameTexture } from "./03．内容设置";
import { destroyFrame } from "./05．帧控制";

// ========== 虚拟分区：可点击图标 ==========
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

  japi.DzFrameSetAllPoints(button, backdrop);
  setFrameClickEvent(button, onClick);
  return { backdrop, button };
}

// ========== 虚拟分区：文本按钮 ==========
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
  if (onClick) setFrameClickEvent(frame, onClick);
  return frame;
}

// ========== 虚拟分区：文本标签 ==========
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
    japi.DzFrameSetText(frame, text);
    return frame;
  }

  const fallback = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name,
    parent,
    template: "template",
    visible: true,
  });
  if (!fallback) return null;
  setPos(fallback);
  setFrameSize(fallback, size);
  setButtonText(fallback, text);
  return fallback;
}

// ========== 虚拟分区：文本区域 ==========
export function createTextArea(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture?: string
): number | null {
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
    if (backgroundTexture) {
      japi.DzFrameSetTexture(backdrop, backgroundTexture, 0);
    }
  }

  const frame = createFrame({
    type: FrameType.TEXTAREA,
    name,
    parent: backdrop || parent,
    template: "template",
    visible: true,
  });
  if (frame) {
    if (backdrop) {
      japi.DzFrameSetAllPoints(frame, backdrop);
    } else {
      setFramePosition(frame, position);
      setFrameSize(frame, size);
    }
    japi.DzFrameSetText(frame, text);
    return frame;
  }

  return createTextLabel(name, parent, text, position, size);
}

// ========== 虚拟分区：文本框 ==========
export function createTextBox(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture: string
): { backdrop: number; text: number } | null {
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
  japi.DzFrameSetText(textFrame, text);
  return { backdrop, text: textFrame };
}

