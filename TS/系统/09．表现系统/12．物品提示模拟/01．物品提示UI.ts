/** @noSelfInFile */

import type { 物品提示内容 } from "./03．物品提示内容";

const japi = require("jass.japi") as any;

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzLoadToc = japi.DzLoadToc as (path: string) => void;
const DzCreateFrame = japi.DzCreateFrame as (name: string, parent: number, id: number) => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameClearAllPoints = japi.DzFrameClearAllPoints as (frame: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetEnable = japi.DzFrameSetEnable as (frame: number, enable: boolean) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;

const POINT_TOPLEFT = 0;
const POINT_TOP = 1;
const POINT_BOTTOM = 7;
const TOOLTIP_TOC_PATH = "UI\\BuffTestTooltip.toc";
const TOOLTIP_FDF_NAME = "ItemTooltipNativePanel";
const TOOLTIP_FDF_CONTEXT = 9301;
const TOOLTIP_TEXT_CONTEXT_BASE = 9310;
const TOOLTIP_WIDTH = 0.220;
const TOOLTIP_MIN_HEIGHT = 0.070;
const TOOLTIP_COMMAND_BAR_ROW = 0;
const TOOLTIP_COMMAND_BAR_COLUMN = 1;
const TOOLTIP_COMMAND_BAR_OFFSET_X = 0.010;
const TOOLTIP_COMMAND_BAR_OFFSET_Y = 0.035;
const HEADER_X = 0.004;
const HEADER_TEXT_WITH_ICON_X = 0.018;
const HEADER_ICON_Y_OFFSET = -0.002;
const NAME_Y = -0.006;
const LINE_STEP = 0.015;
const BODY_GAP = 0.009;
const BODY_LINE_HEIGHT = 0.0130;
const BODY_BOTTOM_PADDING = 0.008;
const BODY_WRAP_VISIBLE_WIDTH = 42;
const SELL_HINT_TEXT = "|cff808080将物品扔在商店上以卖出|r";
const GOLD_TEXT_COLOR = "|cffffcc00";
const COLOR_END = "|r";
const USE_HINT_TEXT = GOLD_TEXT_COLOR + "点击左键使用" + COLOR_END;

export interface 物品提示UI帧 {
  root: number;
  name: number;
  manaIcon: number;
  manaText: number;
  goldIcon: number;
  goldText: number;
  sellText: number;
  useText: number;
  body: number;
}

export function 有效帧(this: void, frame: number): boolean {
  return frame != null && frame !== 0;
}

function 安全显示(this: void, frame: number, visible: boolean): void {
  if (有效帧(frame)) DzFrameShow(frame, visible);
}

function 安全设文本(this: void, frame: number, text: string): void {
  if (有效帧(frame)) DzFrameSetText(frame, text);
}

function 锚到左上(this: void, frame: number, root: number, x: number, y: number): void {
  if (!有效帧(frame) || !有效帧(root)) return;
  DzFrameClearAllPoints(frame);
  DzFrameSetPoint(frame, POINT_TOPLEFT, root, POINT_TOPLEFT, x, y);
}

export function 锚定提示根框到原生物品提示位置(this: void, root: number): void {
  if (!有效帧(root)) return;
  const commandButton = DzFrameGetCommandBarButton(TOOLTIP_COMMAND_BAR_ROW, TOOLTIP_COMMAND_BAR_COLUMN);
  if (!有效帧(commandButton)) return;
  DzFrameClearAllPoints(root);
  DzFrameSetPoint(root, POINT_BOTTOM, commandButton, POINT_TOP, TOOLTIP_COMMAND_BAR_OFFSET_X, TOOLTIP_COMMAND_BAR_OFFSET_Y);
}

let fdf已加载 = false;
let 待加载Toc路径 = "";

function 执行加载Toc(this: any): void {
  DzLoadToc(待加载Toc路径);
}

function 加载物品提示Fdf(this: void): boolean {
  if (fdf已加载) return true;
  待加载Toc路径 = TOOLTIP_TOC_PATH;
  const ok = pcall(执行加载Toc) as unknown as boolean;
  fdf已加载 = ok === true;
  return fdf已加载;
}

function 创建Fdf文本帧(this: void, name: string, parent: number, contextId: number): number {
  const frame = DzCreateFrame(name, parent, contextId);
  if (有效帧(frame)) DzFrameSetEnable(frame, false);
  return frame;
}

function 创建Fdf图标帧(this: void, name: string, parent: number, contextId: number): number {
  return DzCreateFrame(name, parent, contextId);
}

function 格式化整数(this: void, value: number): string {
  return tostring(Math.floor(value + 0.5));
}

function 格式化金色整数(this: void, value: number): string {
  return GOLD_TEXT_COLOR + 格式化整数(value) + COLOR_END;
}

function 取颜色码结束位置(this: void, text: string, index: number): number {
  if (text.substr(index, 2) === "|r" || text.substr(index, 2) === "|n") return index + 2;
  if (text.substr(index, 2) !== "|c") return index;
  return index + 10 <= text.length ? index + 10 : index + 2;
}

function 计算可见文本宽度(this: void, text: string): number {
  let width = 0;
  let index = 0;
  while (index < text.length) {
    const code = string.byte(text, index + 1) || 0;
    if (code === 124) {
      const nextIndex = 取颜色码结束位置(text, index);
      if (nextIndex > index) {
        index = nextIndex;
        continue;
      }
    }
    if (code >= 240) {
      width += 1.6;
      index += 4;
    } else if (code >= 224) {
      width += 1.6;
      index += 3;
    } else if (code >= 192) {
      width += 1.6;
      index += 2;
    } else {
      width += 0.8;
      index++;
    }
  }
  return width;
}

function 计算提示正文行数(this: void, text: string): number {
  if (text === "") return 0;
  let count = 0;
  let searchIndex = 0;
  while (true) {
    const nextIndex = text.indexOf("|n", searchIndex);
    const lineText = nextIndex < 0 ? text.substring(searchIndex) : text.substring(searchIndex, nextIndex);
    const visibleWidth = 计算可见文本宽度(lineText);
    count += 取较大数(1, Math.ceil(visibleWidth / BODY_WRAP_VISIBLE_WIDTH));
    if (nextIndex < 0) break;
    searchIndex = nextIndex + 2;
  }
  return count;
}

function 取较大数(this: void, a: number, b: number): number {
  return a > b ? a : b;
}

export function 更新物品提示内容(this: void, 帧: 物品提示UI帧, 内容: 物品提示内容): void {
  const titleText = 内容.activeUseHotkey != null && 内容.activeUseHotkey !== ""
    ? 内容.name + " |cffffcc00（小键盘" + 内容.activeUseHotkey + "）|r"
    : 内容.name;
  安全设文本(帧.name, titleText);

  let lineIndex = 1;
  if ((内容.manaCost ?? 0) > 0) {
    const y = NAME_Y - LINE_STEP * lineIndex;
    锚到左上(帧.manaIcon, 帧.root, HEADER_X, y + HEADER_ICON_Y_OFFSET);
    锚到左上(帧.manaText, 帧.root, HEADER_TEXT_WITH_ICON_X, y);
    安全设文本(帧.manaText, 格式化整数(内容.manaCost ?? 0));
    安全显示(帧.manaIcon, true);
    安全显示(帧.manaText, true);
    lineIndex++;
  } else {
    安全显示(帧.manaIcon, false);
    安全显示(帧.manaText, false);
  }

  if (内容.sellable === true && (内容.sellGold ?? 0) > 0) {
    const goldY = NAME_Y - LINE_STEP * lineIndex;
    锚到左上(帧.goldIcon, 帧.root, HEADER_X, goldY + HEADER_ICON_Y_OFFSET);
    锚到左上(帧.goldText, 帧.root, HEADER_TEXT_WITH_ICON_X, goldY);
    安全设文本(帧.goldText, 格式化金色整数(内容.sellGold ?? 0));
    安全显示(帧.goldIcon, true);
    安全显示(帧.goldText, true);
    lineIndex++;

    const sellY = NAME_Y - LINE_STEP * lineIndex;
    锚到左上(帧.sellText, 帧.root, HEADER_X, sellY);
    安全设文本(帧.sellText, SELL_HINT_TEXT);
    安全显示(帧.sellText, true);
    lineIndex++;
  } else {
    安全显示(帧.goldIcon, false);
    安全显示(帧.goldText, false);
    安全显示(帧.sellText, false);
  }

  if (内容.activeUsable === true) {
    const useY = NAME_Y - LINE_STEP * lineIndex;
    锚到左上(帧.useText, 帧.root, HEADER_X, useY);
    安全设文本(帧.useText, USE_HINT_TEXT);
    安全显示(帧.useText, true);
    lineIndex++;
  } else {
    安全显示(帧.useText, false);
  }

  const bodyY = NAME_Y - LINE_STEP * lineIndex - BODY_GAP;
  const bodyLineCount = 计算提示正文行数(内容.dynamicText);
  const bodyHeight = bodyLineCount > 0 ? bodyLineCount * BODY_LINE_HEIGHT + 0.004 : 0;
  const tooltipHeight = 取较大数(TOOLTIP_MIN_HEIGHT, -bodyY + bodyHeight + BODY_BOTTOM_PADDING);
  DzFrameSetSize(帧.root, TOOLTIP_WIDTH, tooltipHeight);
  if (有效帧(帧.body)) {
    DzFrameSetSize(帧.body, 0.190, bodyHeight);
  }
  锚到左上(帧.body, 帧.root, HEADER_X, bodyY);
  安全设文本(帧.body, 内容.dynamicText);
  安全显示(帧.body, 内容.dynamicText !== "");
}

export function 创建物品提示UI(this: void): 物品提示UI帧 | null {
  const gameUI = DzGetGameUI();
  if (!有效帧(gameUI)) return null;
  if (!加载物品提示Fdf()) return null;

  const root = DzCreateFrame(TOOLTIP_FDF_NAME, gameUI, TOOLTIP_FDF_CONTEXT);
  if (!有效帧(root)) return null;
  DzFrameShow(root, false);
  锚定提示根框到原生物品提示位置(root);
  DzFrameSetPriority(root, 8700);

  const name = 创建Fdf文本帧("ItemTooltipNativeNameText", root, TOOLTIP_TEXT_CONTEXT_BASE + 1);
  const manaIcon = 创建Fdf图标帧("ItemTooltipNativeManaIcon", root, TOOLTIP_TEXT_CONTEXT_BASE + 2);
  const manaText = 创建Fdf文本帧("ItemTooltipNativeManaText", root, TOOLTIP_TEXT_CONTEXT_BASE + 3);
  const goldIcon = 创建Fdf图标帧("ItemTooltipNativeGoldIcon", root, TOOLTIP_TEXT_CONTEXT_BASE + 4);
  const goldText = 创建Fdf文本帧("ItemTooltipNativeGoldText", root, TOOLTIP_TEXT_CONTEXT_BASE + 5);
  const sellText = 创建Fdf文本帧("ItemTooltipNativeSellText", root, TOOLTIP_TEXT_CONTEXT_BASE + 6);
  const useText = 创建Fdf文本帧("ItemTooltipNativeUseText", root, TOOLTIP_TEXT_CONTEXT_BASE + 7);
  const body = 创建Fdf文本帧("ItemTooltipNativeBodyText", root, TOOLTIP_TEXT_CONTEXT_BASE + 8);
  if (有效帧(name)) {
    DzFrameSetPoint(name, POINT_TOPLEFT, root, POINT_TOPLEFT, HEADER_X, NAME_Y);
  }
  if (!有效帧(name) || !有效帧(body)) return null;
  return { root, name, manaIcon, manaText, goldIcon, goldText, sellText, useText, body };
}

export {};
