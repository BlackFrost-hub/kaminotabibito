const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
import {
  getSoleSelectedUnitForPlayer as getSoleSelectedUnitForPlayerImported,
  initPlayerSelectionCenter as initPlayerSelectionCenterImported,
} from "../00．核心系统/01．事件中心/05．玩家选中单位事件中心";
import { buildBuffBarViewModel as buildBuffBarViewModelImported, getMaxSlots as getMaxSlotsImported } from "./04．BuffUIViewModel";
import {
  createFrame as createFrameImported,
  tryCreateFromFdfSafe as tryCreateFromFdfSafeImported,
} from "../09．表现系统/01．UI工具/01．帧创建";
import {
  setFramePointRelative as setFramePointRelativeImported,
  setFramePosition as setFramePositionImported,
  setFrameSize as setFrameSizeImported,
} from "../09．表现系统/01．UI工具/02．位置尺寸";
import {
  setFrameHoverEvents as setFrameHoverEventsImported,
  setFrameTexture as setFrameTextureImported,
} from "../09．表现系统/01．UI工具/03．内容设置";
import { createTextLabel as createTextLabelImported } from "../09．表现系统/01．UI工具/04．复合组件";
import { hideFrame as hideFrameImported, showFrame as showFrameImported } from "../09．表现系统/01．UI工具/05．帧控制";
const UI工具 = require("系统.09．表现系统.01．UI工具.index") as {
  FrameType: { BACKDROP: number; GLUETEXTBUTTON: number };
  FramePoint: { TOPLEFT: number; TOPRIGHT: number; CENTER: number; BOTTOM: number; BOTTOMLEFT: number };
};
const ____hwMod = require("lib.扩展函数.封装函数.04．硬件输入.index");
const getGameUI = ____hwMod.getGameUI as (this: void) => number;
const ____safeUtils = require("系统.00．核心系统.07．联机安全工具");
const safeTimerStart = ____safeUtils.safeTimerStart as (timer: any, timeout: number, periodic: boolean, action: (this: void) => void) => void;
const safeDestroyTimer = ____safeUtils.safeDestroyTimer as (timer: any) => void;
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
  setDebug: (module: string, on: boolean) => void;
};

setDebug("BuffUI", false);

const MAX_SLOTS = getMaxSlotsImported();
const BUFF_BAR_X0 = 0.204;
const BUFF_BAR_Y = 0.1655;
const ICON_W = 0.02;
const ICON_H = 16 / 600;
const ICON_GAP = 0.0005;
const TIP_BOX_TEX = "UI\\wenbenkuang.blp";
const TIP_W = 0.22;
const TIP_H = 0.068;
const TIP_PAD_X = 0.009;
const TIP_PAD_TOP = 0.007;
const TIP_PAD_BOTTOM = 0.006;
const TIP_OFFSET_Y_FROM_ICON_TOP = 0.07;
const BUFF_TOOLTIP_TOC_KEY = "BuffTestTooltip";
const BUFF_TOOLTIP_TOC_PATHS = ["UI\\BuffTestTooltip.toc"];

interface SlotFrames {
  root: number;
  remainText: number;
  hit: number;
  tipBox: number;
  tipBodyText: number;
  tipSourceText: number;
}

const slots: SlotFrames[] = [];
let buffUiInitialized = false;
let refreshTimer: any = null;
let pendingInitDelayTimer: any = null;
const buffBarViewModelByPlayerId: Record<number, { slots: Array<{ visible: boolean; iconPath: string; remainText: string; tooltipBodyText: string; tooltipSourceText: string }> } | undefined> = {};
// DzFrame 返回数字 frame id，不是 JASS handle；这里直接用 frame id 做本地 hover 反查 key。
const hoverSlotIndexByFrameId: Record<number, number | undefined> = {};

function uiCreateFrame(this: void, options: any): number | null {
  return createFrameImported(options);
}

function uiSetFramePosition(this: void, frame: number, options: any): boolean {
  return setFramePositionImported(frame, options);
}

function uiSetFrameSize(this: void, frame: number, options: any): boolean {
  return setFrameSizeImported(frame, options);
}

function uiSetFrameTexture(this: void, frame: number, texture: string): boolean {
  return setFrameTextureImported(frame, texture);
}

function uiSetFrameHoverEvents(this: void, frame: number, onEnter: any, onLeave: any, sync: boolean): boolean {
  return setFrameHoverEventsImported(frame, onEnter, onLeave, sync);
}

function uiSetFramePointRelative(this: void,
  frame: number,
  point: number,
  relativeTo: number,
  relativePoint: number,
  x: number,
  y: number
): boolean {
  return setFramePointRelativeImported(frame, point, relativeTo, relativePoint, x, y);
}

function uiCreateTextLabel(this: void, name: string, parent: number, text: string, position: any, size: any): number | null {
  return createTextLabelImported(name, parent, text, position, size);
}

function uiTryCreateFromFdfSafe(this: void, frameName: string, parent: number, fallback: () => number | null, contextId: number): number | null {
  return tryCreateFromFdfSafeImported(frameName, parent, fallback, {
    tocLoadKey: BUFF_TOOLTIP_TOC_KEY,
    tocPaths: BUFF_TOOLTIP_TOC_PATHS,
    debugPrefix: "BuffUI",
    contextId,
  });
}

function uiHideFrame(this: void, frame: number): boolean {
  return hideFrameImported(frame);
}

function uiShowFrame(this: void, frame: number): boolean {
  return showFrameImported(frame);
}

function getTriggerUiEventFrame(this: void): number {
  return japi.DzGetTriggerUIEventFrame();
}

function setFrameLevelSafe(this: void, frame: number, level: number): void {
  if (frame === 0) return;
  japi.DzFrameSetPriority(frame, level);
}

function showSlotTooltipByIndex(this: void, index: number): void {
  const s = slots[index];
  if (s && s.tipBox !== 0) {
    uiShowFrame(s.tipBox);
  }
  if (s && s.tipBodyText !== 0) {
    uiShowFrame(s.tipBodyText);
  }
  if (s && s.tipSourceText !== 0) {
    uiShowFrame(s.tipSourceText);
  }
}

function hideSlotTooltipByIndex(this: void, index: number): void {
  const s = slots[index];
  if (s && s.tipBodyText !== 0) uiHideFrame(s.tipBodyText);
  if (s && s.tipSourceText !== 0) uiHideFrame(s.tipSourceText);
  if (s && s.tipBox !== 0) uiHideFrame(s.tipBox);
}

function onSlotHoverEnter(this: any): void {
  const frame = getTriggerUiEventFrame();
  if (frame === 0) return;
  const index = hoverSlotIndexByFrameId[frame];
  if (index == null) return;
  showSlotTooltipByIndex(index);
}

function onSlotHoverLeave(this: any): void {
  const frame = getTriggerUiEventFrame();
  if (frame === 0) return;
  const index = hoverSlotIndexByFrameId[frame];
  if (index == null) return;
  hideSlotTooltipByIndex(index);
}

function createOneSlot(this: void, index: number, parent: number): SlotFrames | null {
  const x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP);
  const bd =
    uiCreateFrame({
      type: UI工具.FrameType.BACKDROP,
      name: "BuffUIBarIcon" + index,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  debugLog("BuffUI", "slot" + index + " bd=" + bd);
  if (!bd || bd === 0) return null;
  uiSetFramePosition(bd, { point: UI工具.FramePoint.TOPLEFT, x, y: BUFF_BAR_Y });
  uiSetFrameSize(bd, { width: ICON_W, height: ICON_H });
  uiSetFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp");
  setFrameLevelSafe(bd, 180);

  const remainText =
    uiCreateTextLabel(
      "BuffUIBarRemain" + index,
      bd,
      "|cffffffff0.0|r",
      {
        relativeTo: bd,
        point: UI工具.FramePoint.BOTTOM,
        relativePoint: UI工具.FramePoint.BOTTOM,
        x: 0,
        y: 0.001,
      },
      { width: ICON_W, height: 0.014 }
    ) || 0;
  if (remainText && remainText !== 0) {
    japi.DzFrameSetTextAlignment(remainText, UI工具.FramePoint.CENTER);
    setFrameLevelSafe(remainText, 182);
  }

  const hit =
    uiCreateFrame({
      type: UI工具.FrameType.GLUETEXTBUTTON,
      name: "BuffUIBarHit" + index,
      parent: bd,
      template: "template",
      visible: false,
      enable: true,
      alpha: 0,
    }) || 0;
    if (hit && hit !== 0) {
      hoverSlotIndexByFrameId[hit] = index;
      japi.DzFrameSetAllPoints(hit, bd);
      setFrameLevelSafe(hit, 181);
      uiSetFrameHoverEvents(hit, onSlotHoverEnter, onSlotHoverLeave, false);
    }

  const boxW = TIP_W;
  const boxH = TIP_H;
  const tipBox =
    uiTryCreateFromFdfSafe(
      "BuffTestTooltipPanel",
      parent,
      () => {
        const fallbackFrame = uiCreateFrame({
          type: UI工具.FrameType.BACKDROP,
          name: "BuffUIBarTip" + index,
          parent,
          template: "template",
          visible: false,
        });
        if (fallbackFrame && fallbackFrame !== 0) {
          uiSetFrameTexture(fallbackFrame, TIP_BOX_TEX);
        }
        return fallbackFrame;
      },
      index + 1
    ) || 0;
  if (tipBox && tipBox !== 0) {
    uiSetFramePointRelative(
      tipBox,
      UI工具.FramePoint.TOPLEFT,
      bd,
      UI工具.FramePoint.TOPRIGHT,
      0.002,
      TIP_OFFSET_Y_FROM_ICON_TOP
    );
    uiSetFrameSize(tipBox, { width: boxW, height: boxH });
    setFrameLevelSafe(tipBox, 200);
    uiHideFrame(tipBox);
  }

  const tipBodyText =
    uiCreateTextLabel(
      "BuffUIBarTipBodyTxt" + index,
      tipBox && tipBox !== 0 ? tipBox : bd,
      "",
      tipBox && tipBox !== 0
        ? { relativeTo: tipBox, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPLEFT, x: TIP_PAD_X, y: -TIP_PAD_TOP }
        : { relativeTo: bd, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP },
      { width: boxW - TIP_PAD_X * 2, height: 0.037 }
    ) || 0;
  if (tipBodyText && tipBodyText !== 0) {
    japi.DzFrameSetTextAlignment(tipBodyText, -1);
    japi.DzFrameSetTextAlignment(tipBodyText, 0);
    setFrameLevelSafe(tipBodyText, 201);
    uiHideFrame(tipBodyText);
  }

  const tipSourceText =
    uiCreateTextLabel(
      "BuffUIBarTipSourceTxt" + index,
      tipBox && tipBox !== 0 ? tipBox : bd,
      "",
      tipBox && tipBox !== 0
        ? { relativeTo: tipBox, point: UI工具.FramePoint.BOTTOMLEFT, relativePoint: UI工具.FramePoint.BOTTOMLEFT, x: TIP_PAD_X, y: TIP_PAD_BOTTOM }
        : { relativeTo: bd, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP - 0.016 },
      { width: boxW - TIP_PAD_X * 2, height: 0.019 }
    ) || 0;
  if (tipSourceText && tipSourceText !== 0) {
    japi.DzFrameSetTextAlignment(tipSourceText, -1);
    japi.DzFrameSetTextAlignment(tipSourceText, 6);
    setFrameLevelSafe(tipSourceText, 201);
    uiHideFrame(tipSourceText);
  }

  uiHideFrame(bd);
  return {
    root: bd,
    remainText: remainText || 0,
    hit: hit || 0,
    tipBox: tipBox || 0,
    tipBodyText: tipBodyText || 0,
    tipSourceText: tipSourceText || 0,
  };
}

function hideSlot(this: void, i: number): void {
  const s = slots[i];
  if (!s) return;
  if (s.tipBodyText !== 0) uiHideFrame(s.tipBodyText);
  if (s.tipSourceText !== 0) uiHideFrame(s.tipSourceText);
  if (s.tipBox !== 0) uiHideFrame(s.tipBox);
  if (s.hit !== 0) uiHideFrame(s.hit);
  if (s.root !== 0) uiHideFrame(s.root);
}

function hideAllSlots(this: void): void {
  for (let i = 0; i < MAX_SLOTS; i++) hideSlot(i);
}

function renderBuffBarLocal(this: void, vm: { slots: Array<{ visible: boolean; iconPath: string; remainText: string; tooltipBodyText: string; tooltipSourceText: string }> }): void {
  for (let i = 0; i < MAX_SLOTS; i++) {
    const slotVM = vm.slots[i];
    const slot = slots[i];
    if (!slot) continue;
    if (slotVM.visible) {
      if (slot.root !== 0) {
        uiSetFrameTexture(slot.root, slotVM.iconPath);
        uiShowFrame(slot.root);
      }
      if (slot.remainText !== 0) {
        japi.DzFrameSetText(slot.remainText, slotVM.remainText);
      }
      if (slot.tipBodyText !== 0) {
        japi.DzFrameSetText(slot.tipBodyText, slotVM.tooltipBodyText);
      }
      if (slot.tipSourceText !== 0) {
        japi.DzFrameSetText(slot.tipSourceText, slotVM.tooltipSourceText);
      }
      if (slot.hit !== 0) uiShowFrame(slot.hit);
    } else {
      hideSlot(i);
    }
  }
}

const MAX_PLAYER_ID = 6;

function initSelectionCentersForBuffUi(this: void): void {
  for (let playerId = 0; playerId < MAX_PLAYER_ID; playerId++) {
    initPlayerSelectionCenterImported(jass.Player(playerId));
  }
}

function rebuildAllBuffBarViewModels(this: void): void {
  for (let playerId = 0; playerId < MAX_PLAYER_ID; playerId++) {
    const targetUnit = getSoleSelectedUnitForPlayerImported(playerId);
    buffBarViewModelByPlayerId[playerId] = buildBuffBarViewModelImported(targetUnit);
  }
}

function syncBuffBar(this: void): void {
  const localPlayerId = jass.GetPlayerId(jass.GetLocalPlayer());
  rebuildAllBuffBarViewModels();
  const viewModel = localPlayerId >= 0 ? buffBarViewModelByPlayerId[localPlayerId] : undefined;
  const visCount = viewModel ? viewModel.slots.filter(s => s.visible).length : 0;
  debugLog("BuffUI", "pid=" + localPlayerId + " vm=" + (viewModel ? "yes" : "nil") + " vis=" + visCount + " slotsLen=" + slots.length);
  if (jass.GetLocalPlayer() === jass.Player(localPlayerId) && viewModel) {
    renderBuffBarLocal(viewModel);
  } else if (jass.GetLocalPlayer() === jass.Player(localPlayerId)) {
    hideAllSlots();
  }
}

function createUi(this: void): void {
  const parent = getGameUI();
  debugLog("BuffUI", "createUi parent=" + parent);
  if (parent === 0 || parent == null) return;
  for (let i = 0; i < MAX_SLOTS; i++) {
    const s = createOneSlot(i, parent);
    if (s) slots[i] = s;
  }
}

function startRefreshTimer(this: void): void {
  if (refreshTimer !== null) return;
  refreshTimer = jass.CreateTimer();
  jass.TimerStart(refreshTimer, 0.1, true, onBuffUiRefreshTick);
}

function onBuffUiRefreshTick(this: void): void {
  syncBuffBar();
}

function onBuffUiInitDelayTimer(this: void): void {
  createUi();
  startRefreshTimer();
  if (pendingInitDelayTimer !== null) {
    jass.DestroyTimer(pendingInitDelayTimer);
    pendingInitDelayTimer = null;
  }
}

function startBuffUiSystem(this: void): void {
  initSelectionCentersForBuffUi();
  if (buffUiInitialized) return;
  buffUiInitialized = true;
  pendingInitDelayTimer = jass.CreateTimer();
  jass.TimerStart(pendingInitDelayTimer, 1.0, false, onBuffUiInitDelayTimer);
}

export function init(this: void): void {
  startBuffUiSystem();
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  debugLog("BuffUI", "onPlayerHeroRegistered called, init=" + buffUiInitialized);
  startBuffUiSystem();
}

export {};
