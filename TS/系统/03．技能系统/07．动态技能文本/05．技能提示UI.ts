/** @noSelfInFile */

/**
 * 技能悬停提示。
 * 采用与物品提示模拟相同的同步 Frame 方案，避免原生提示框固定高度裁剪长说明。
 */
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
    slots: Record<"Q" | "W" | "E" | "R" | "D", { x: number; y: number }>;
  };
};
const dynamicTextCore = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑") as {
  刷新单个英雄技能动态文本: (this: void, hero: any, abilityId: number) => void;
};

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzLoadToc = japi.DzLoadToc as (path: string) => void;
const DzCreateFrame = japi.DzCreateFrame as (name: string, parent: number, id: number) => number;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;
const DzFrameGetTooltip = japi.DzFrameGetTooltip as () => number;
const DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode as (frame: number, eventId: number, callback: (this: void) => void, sync: boolean) => void;
const DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame as () => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relative: number, relativePoint: number, x: number, y: number) => void;
const DzFrameClearAllPoints = japi.DzFrameClearAllPoints as (frame: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, red: number, green: number, blue: number, alpha: number) => void;
const DzFrameSetEnable = japi.DzFrameSetEnable as (frame: number, enable: boolean) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzGetUnitAbilityTip = japi.DzGetUnitAbilityTip as (unit: any, abilityId: number) => string;
const DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip as (unit: any, abilityId: number) => string;
const DzGetUnitAbilityCost = japi.DzGetUnitAbilityCost as (unit: any, abilityId: number) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const TOC_PATH = "UI\\BuffTestTooltip.toc";
const FDF_NAME = "AbilityTooltipNativePanel";
const FRAME_CONTEXT = 9401;
const TEXT_CONTEXT = 9410;
const POINT_BOTTOM = 7;
const POINT_TOP = 1;
const POINT_TOPLEFT = 0;
const TOOLTIP_COMMAND_BAR_ROW = 0;
const TOOLTIP_COMMAND_BAR_COLUMN = 1;
const TOOLTIP_COMMAND_BAR_OFFSET_X = 0.010;
const TOOLTIP_COMMAND_BAR_OFFSET_Y = 0.035;
const MOUSE_ENTER = 2;
const MOUSE_LEAVE = 3;
const ROOT_WIDTH = 0.220;
const ROOT_MIN_HEIGHT = 0.070;
const PAD_X = 0.004;
const NAME_Y = -0.006;
// 图标顶部不能侵入技能名称行；相对蓝耗文字向下留出原生视觉间距。
const MANA_ICON_Y_OFFSET = 0.0025;
const LINE_STEP = 0.015;
const BODY_GAP = 0.009;
const BODY_LINE_HEIGHT = 0.0130;
const BODY_BOTTOM_PADDING = 0.008;
const BODY_WIDTH = 42;

type 技能位 = "Q" | "W" | "E" | "R" | "D";
type 技能提示帧 = { root: number; name: number; manaIcon: number; manaText: number; body: number };

let 已初始化 = false;
let fdf已加载 = false;
let 提示帧: 技能提示帧 | null = null;

function 有效帧(this: void, frame: number): boolean { return frame != null && frame !== 0; }
function 安全显示(this: void, frame: number, visible: boolean): void { if (有效帧(frame)) DzFrameShow(frame, visible); }
function 安全文本(this: void, frame: number, text: string): void { if (有效帧(frame)) DzFrameSetText(frame, text); }
function 锚左上(this: void, frame: number, root: number, x: number, y: number): void {
  if (!有效帧(frame) || !有效帧(root)) return;
  DzFrameClearAllPoints(frame);
  DzFrameSetPoint(frame, POINT_TOPLEFT, root, POINT_TOPLEFT, x, y);
}

function 隐藏原生提示(this: void): void {
  const tooltip = DzFrameGetTooltip();
  const gameUI = DzGetGameUI();
  if (!有效帧(tooltip) || !有效帧(gameUI)) return;
  DzFrameClearAllPoints(tooltip);
  DzFrameSetPoint(tooltip, POINT_BOTTOM, gameUI, POINT_BOTTOM, 0, -0.60);
}

function 恢复原生提示(this: void): void {
  const tooltip = DzFrameGetTooltip();
  const gameUI = DzGetGameUI();
  if (!有效帧(tooltip) || !有效帧(gameUI)) return;
  DzFrameClearAllPoints(tooltip);
  DzFrameSetPoint(tooltip, 8, gameUI, 8, 0, 0.16);
}

function 加载Fdf(this: void): boolean {
  if (fdf已加载) return true;
  let ok = false;
  function 执行加载(this: any): void { DzLoadToc(TOC_PATH); ok = true; }
  pcall(执行加载);
  fdf已加载 = ok;
  return ok;
}

function 创建文本帧(this: void, name: string, parent: number, context: number): number {
  const frame = DzCreateFrame(name, parent, context);
  if (有效帧(frame)) DzFrameSetEnable(frame, false);
  return frame;
}

function 创建提示帧(this: void): 技能提示帧 | null {
  const gameUI = DzGetGameUI();
  if (!有效帧(gameUI) || !加载Fdf()) return null;
  const root = DzCreateFrame(FDF_NAME, gameUI, FRAME_CONTEXT);
  if (!有效帧(root)) return null;
  const name = 创建文本帧("AbilityTooltipNativeNameText", root, TEXT_CONTEXT + 1);
  const manaIcon = DzCreateFrame("AbilityTooltipNativeManaIcon", root, TEXT_CONTEXT + 2);
  const manaText = 创建文本帧("AbilityTooltipNativeManaText", root, TEXT_CONTEXT + 3);
  const body = 创建文本帧("AbilityTooltipNativeBodyText", root, TEXT_CONTEXT + 4);
  if (!有效帧(name) || !有效帧(manaIcon) || !有效帧(manaText) || !有效帧(body)) return null;
  DzFrameSetTextColor(manaText, 255, 204, 0, 255);
  DzFrameShow(root, false);
  DzFrameSetPriority(root, 8700);
  return { root, name, manaIcon, manaText, body };
}

function 颜色码结束位置(this: void, text: string, index: number): number {
  if (text.substr(index, 2) === "|r" || text.substr(index, 2) === "|n") return index + 2;
  if (text.substr(index, 2) === "|c") return index + 10 <= text.length ? index + 10 : index + 2;
  return index;
}

function 可见宽度(this: void, text: string): number {
  let width = 0;
  let index = 0;
  while (index < text.length) {
    const code = string.byte(text, index + 1) || 0;
    const colorEnd = code === 124 ? 颜色码结束位置(text, index) : index;
    if (colorEnd > index) { index = colorEnd; continue; }
    if (code >= 240) { width += 1.6; index += 4; }
    else if (code >= 224) { width += 1.6; index += 3; }
    else if (code >= 192) { width += 1.6; index += 2; }
    else { width += 0.8; index++; }
  }
  return width;
}

function 正文行数(this: void, text: string): number {
  if (text === "") return 0;
  let count = 0;
  let start = 0;
  while (true) {
    const end = text.indexOf("|n", start);
    const line = end < 0 ? text.substring(start) : text.substring(start, end);
    count += Math.max(1, Math.ceil(可见宽度(line) / BODY_WIDTH));
    if (end < 0) return count;
    start = end + 2;
  }
}

function 格式化魔耗(this: void, value: number): string {
  if (!(value > 0)) return "";
  return jass.I2S(jass.R2I(value + 0.5));
}

function 锚定根框(this: void, root: number): void {
  if (!有效帧(root)) return;
  const commandButton = DzFrameGetCommandBarButton(TOOLTIP_COMMAND_BAR_ROW, TOOLTIP_COMMAND_BAR_COLUMN);
  if (!有效帧(commandButton)) return;
  DzFrameClearAllPoints(root);
  DzFrameSetPoint(root, POINT_BOTTOM, commandButton, POINT_TOP, TOOLTIP_COMMAND_BAR_OFFSET_X, TOOLTIP_COMMAND_BAR_OFFSET_Y);
}

function 更新提示(this: void, hero: any, abilityId: number): void {
  if (提示帧 == null || !有效帧(hero) || abilityId === 0) return;
  dynamicTextCore.刷新单个英雄技能动态文本(hero, abilityId);
  const title = DzGetUnitAbilityTip(hero, abilityId) || "";
  const body = DzGetUnitAbilityUberTip(hero, abilityId) || "";
  const cost = DzGetUnitAbilityCost(hero, abilityId) || 0;
  安全文本(提示帧.name, title);
  const costText = 格式化魔耗(cost);
  安全文本(提示帧.manaText, costText);
  安全显示(提示帧.manaIcon, costText !== "");
  安全显示(提示帧.manaText, costText !== "");
  const lineIndex = costText !== "" ? 2 : 1;
  const bodyY = NAME_Y - LINE_STEP * lineIndex - BODY_GAP;
  const bodyHeight = 正文行数(body) * BODY_LINE_HEIGHT + (body !== "" ? 0.004 : 0);
  const rootHeight = Math.max(ROOT_MIN_HEIGHT, -bodyY + bodyHeight + BODY_BOTTOM_PADDING);
  DzFrameSetSize(提示帧.root, ROOT_WIDTH, rootHeight);
  DzFrameSetSize(提示帧.body, ROOT_WIDTH - PAD_X * 2, bodyHeight);
  锚左上(提示帧.name, 提示帧.root, PAD_X, NAME_Y);
  // 与物品提示框相同：图标向上偏移，和数字保持同一视觉基线。
  锚左上(提示帧.manaIcon, 提示帧.root, PAD_X, NAME_Y - LINE_STEP + MANA_ICON_Y_OFFSET);
  锚左上(提示帧.manaText, 提示帧.root, PAD_X + 0.014, NAME_Y - LINE_STEP);
  锚左上(提示帧.body, 提示帧.root, PAD_X, bodyY);
  安全文本(提示帧.body, body);
  安全显示(提示帧.body, body !== "");
  锚定根框(提示帧.root);
  隐藏原生提示();
  DzFrameShow(提示帧.root, true);
  隐藏原生提示();
}

function 读取技能位(this: void, hero: any, frame: number): 技能位 | null {
  const snapshot = selectionSnapshotSystem.获取本地选中技能快照();
  if (snapshot.hero !== hero) return null;
  const keys: 技能位[] = ["Q", "W", "E", "R", "D"];
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    const slot = snapshot.slots[key];
    if (DzFrameGetCommandBarButton(slot.y, slot.x) === frame) return key;
  }
  return null;
}

function 技能按钮进入(this: void): void {
  if (提示帧 == null) return;
  const frame = DzGetTriggerUIEventFrame();
  const hero = selectionSnapshotSystem.获取本地选中技能快照().hero;
  if (!有效帧(hero)) return;
  const key = 读取技能位(hero, frame);
  if (key == null) return;
  const abilityId = selectionSnapshotSystem.获取本地选中技能快照().skills[key];
  if (abilityId === 0) return;
  更新提示(hero, abilityId);
}

function 技能按钮离开(this: void): void {
  if (提示帧 != null) DzFrameShow(提示帧.root, false);
  恢复原生提示();
}

function 注册技能按钮(this: void): void {
  // D 槽会因英雄配置落在第二排不同列，整排注册后再按当前快照识别实际技能。
  const positions: Array<[number, number]> = [[0, 2], [1, 2], [2, 2], [3, 2], [0, 1], [1, 1], [2, 1], [3, 1]];
  for (let i = 0; i < positions.length; i++) {
    const button = DzFrameGetCommandBarButton(positions[i][1], positions[i][0]);
    if (!有效帧(button)) continue;
    DzFrameSetScriptByCode(button, MOUSE_ENTER, 技能按钮进入, false);
    DzFrameSetScriptByCode(button, MOUSE_LEAVE, 技能按钮离开, false);
  }
}

export function 初始化技能提示UI(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  提示帧 = 创建提示帧();
  if (提示帧 == null) return;
  注册技能按钮();
}

export {};
