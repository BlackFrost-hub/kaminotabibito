/** @noSelfInFile */

const japi = require("jass.japi") as any;

import {
  FRAME_POINT_BOTTOMRIGHT,
  FRAME_POINT_CENTER,
  FRAME_POINT_TOPLEFT,
  MANUAL_BASE_PRIORITY,
  MANUAL_BODY_FONT_SIZE,
  MANUAL_BODY_PRIORITY,
  MANUAL_BODY_TEXT_HEIGHT,
  MANUAL_BODY_TEXT_OFFSET_X,
  MANUAL_BODY_TEXT_OFFSET_Y,
  MANUAL_BODY_TEXT_WIDTH,
  MANUAL_CENTER_X,
  MANUAL_CENTER_Y,
  MANUAL_CLOSE_HEIGHT,
  MANUAL_CLOSE_WIDTH,
  MANUAL_FLIP_PRIORITY_START,
  MANUAL_HEIGHT,
  MANUAL_HOTSPOT_HEIGHT,
  MANUAL_HOTSPOT_PRIORITY,
  MANUAL_HOTSPOT_WIDTH,
  MANUAL_INDICATOR_PRIORITY,
  MANUAL_TITLE_FONT_SIZE,
  MANUAL_TITLE_HEIGHT,
  MANUAL_TITLE_OFFSET_X,
  MANUAL_TITLE_OFFSET_Y,
  MANUAL_TITLE_WIDTH,
  MANUAL_WIDTH,
  MANUAL_FONT,
} from "./00．常量定义";
import { MANUAL_BASE_TEXTURE, MANUAL_FLIP_TEXTURES, MANUAL_INDICATOR_TEXTURE } from "./01．资源定义";

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  type: string,
  name: string,
  parent: number,
  template: string,
  id: number
) => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number
) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, font: string, size: number, flag: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (
  frame: number,
  red: number,
  green: number,
  blue: number,
  alpha: number
) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

export interface 手册UI帧 {
  base: number;
  indicator: number;
  overlays: number[];
  overlayTitleTexts: number[];
  overlayBodyTexts: number[];
  nextHotspot: number;
  closeHotspot: number;
  titleText: number;
  bodyText: number;
  hintText: number;
}

function 有效帧(this: void, frame: number): boolean {
  return frame != null && frame !== 0;
}

function 创建背景帧(this: void, name: string, texture: string, priority: number): number {
  const parent = DzGetGameUI();
  if (!有效帧(parent)) return 0;

  const frame = DzCreateFrameByTagName("BACKDROP", name, parent, "template", 0);
  if (!有效帧(frame)) return 0;

  DzFrameSetSize(frame, MANUAL_WIDTH, MANUAL_HEIGHT);
  DzFrameSetAbsolutePoint(frame, FRAME_POINT_CENTER, MANUAL_CENTER_X, MANUAL_CENTER_Y);
  DzFrameSetTexture(frame, texture, 0);
  DzFrameSetPriority(frame, priority);
  return frame;
}

function 创建文本帧(this: void, name: string, baseFrame: number, width: number, height: number, x: number, y: number, fontSize: number, priority: number): number {
  if (!有效帧(baseFrame)) return 0;

  const frame = DzCreateFrameByTagName("TEXT", name, baseFrame, "template", 0);
  if (!有效帧(frame)) return 0;

  DzFrameSetSize(frame, width, height);
  DzFrameSetPoint(frame, FRAME_POINT_TOPLEFT, baseFrame, FRAME_POINT_TOPLEFT, x, y);
  DzFrameSetTextAlignment(frame, -1);
  DzFrameSetTextAlignment(frame, 0);
  DzFrameSetFont(frame, MANUAL_FONT, fontSize, 0);
  DzFrameSetTextColor(frame, 80, 48, 24, 255);
  DzFrameSetPriority(frame, priority);
  return frame;
}

function 创建按钮热区(this: void, name: string, baseFrame: number, width: number, height: number, x: number, y: number): number {
  const parent = DzGetGameUI();
  if (!有效帧(parent) || !有效帧(baseFrame)) return 0;

  const frame = DzCreateFrameByTagName("GLUETEXTBUTTON", name, parent, "template", 0);
  if (!有效帧(frame)) return 0;

  DzFrameSetSize(frame, width, height);
  DzFrameSetPoint(frame, FRAME_POINT_BOTTOMRIGHT, baseFrame, FRAME_POINT_BOTTOMRIGHT, x, y);
  DzFrameSetText(frame, "");
  DzFrameSetAlpha(frame, 0);
  DzFrameSetPriority(frame, MANUAL_HOTSPOT_PRIORITY);
  return frame;
}

function 创建提示文本(this: void, nextHotspot: number): number {
  const parent = DzGetGameUI();
  if (!有效帧(parent) || !有效帧(nextHotspot)) return 0;

  const frame = DzCreateFrameByTagName("TEXT", "GameManualHintText", parent, "template", 0);
  if (!有效帧(frame)) return 0;

  DzFrameSetSize(frame, MANUAL_HOTSPOT_WIDTH, MANUAL_HOTSPOT_HEIGHT);
  DzFrameSetPoint(frame, FRAME_POINT_CENTER, nextHotspot, FRAME_POINT_CENTER, 0, 0);
  DzFrameSetTextAlignment(frame, -1);
  DzFrameSetTextAlignment(frame, 18);
  DzFrameSetTextColor(frame, 201, 160, 103, 255);
  DzFrameSetPriority(frame, MANUAL_HOTSPOT_PRIORITY - 1);
  return frame;
}

export function 创建游戏说明手册UI(this: void): 手册UI帧 {
  const base = 创建背景帧("GameManualBase", MANUAL_BASE_TEXTURE, MANUAL_BASE_PRIORITY);
  const indicator = 创建背景帧("GameManualIndicator", MANUAL_INDICATOR_TEXTURE, MANUAL_INDICATOR_PRIORITY);
  const overlays: number[] = [];
  const overlayTitleTexts: number[] = [];
  const overlayBodyTexts: number[] = [];

  for (let i = 0; i < MANUAL_FLIP_TEXTURES.length; i++) {
    const frame = 创建背景帧("GameManualFlipOverlay" + (i + 1).toString(), MANUAL_FLIP_TEXTURES[i], MANUAL_FLIP_PRIORITY_START + i);
    if (有效帧(frame)) {
      const overlayTitleText = i === 0
        ? 创建文本帧("GameManualOverlayTitleText1", frame, MANUAL_TITLE_WIDTH, MANUAL_TITLE_HEIGHT, MANUAL_TITLE_OFFSET_X, MANUAL_TITLE_OFFSET_Y, MANUAL_TITLE_FONT_SIZE, MANUAL_BODY_PRIORITY)
        : 0;
      const overlayBodyText = i === 0
        ? 创建文本帧("GameManualOverlayBodyText1", frame, MANUAL_BODY_TEXT_WIDTH, MANUAL_BODY_TEXT_HEIGHT, MANUAL_BODY_TEXT_OFFSET_X, MANUAL_BODY_TEXT_OFFSET_Y, MANUAL_BODY_FONT_SIZE, MANUAL_BODY_PRIORITY)
        : 0;
      overlayTitleTexts.push(overlayTitleText);
      overlayBodyTexts.push(overlayBodyText);
      DzFrameShow(frame, false);
      overlays.push(frame);
    }
  }

  const titleText = 创建文本帧("GameManualTitleText", base, MANUAL_TITLE_WIDTH, MANUAL_TITLE_HEIGHT, MANUAL_TITLE_OFFSET_X, MANUAL_TITLE_OFFSET_Y, MANUAL_TITLE_FONT_SIZE, MANUAL_BODY_PRIORITY);
  const bodyText = 创建文本帧("GameManualBodyText", base, MANUAL_BODY_TEXT_WIDTH, MANUAL_BODY_TEXT_HEIGHT, MANUAL_BODY_TEXT_OFFSET_X, MANUAL_BODY_TEXT_OFFSET_Y, MANUAL_BODY_FONT_SIZE, MANUAL_BODY_PRIORITY);
  const nextHotspot = 创建按钮热区("GameManualNextHotspot", base, MANUAL_HOTSPOT_WIDTH, MANUAL_HOTSPOT_HEIGHT, 0, 0);
  const closeHotspot = 创建按钮热区("GameManualCloseHotspot", base, MANUAL_CLOSE_WIDTH, MANUAL_CLOSE_HEIGHT, -0.018, -0.018);
  const hintText = 创建提示文本(nextHotspot);

  if (有效帧(indicator)) DzFrameShow(indicator, false);
  if (有效帧(hintText)) {
    DzFrameSetText(hintText, "翻页");
    DzFrameShow(hintText, false);
  }

  return { base, indicator, overlays, overlayTitleTexts, overlayBodyTexts, nextHotspot, closeHotspot, titleText, bodyText, hintText };
}

export function 设置手册帧显示(this: void, ui: 手册UI帧, visible: boolean): void {
  if (有效帧(ui.base)) DzFrameShow(ui.base, visible);
  if (有效帧(ui.nextHotspot)) DzFrameShow(ui.nextHotspot, visible);
  if (有效帧(ui.closeHotspot)) DzFrameShow(ui.closeHotspot, visible);
  if (有效帧(ui.titleText)) DzFrameShow(ui.titleText, visible);
  if (有效帧(ui.bodyText)) DzFrameShow(ui.bodyText, visible);
  if (有效帧(ui.hintText)) DzFrameShow(ui.hintText, false);
  if (有效帧(ui.indicator)) DzFrameShow(ui.indicator, false);
  for (let i = 0; i < ui.overlays.length; i++) {
    DzFrameShow(ui.overlays[i], false);
  }
}
