/** @noSelfInFile */
// BuffUI 重构版：全端计算 + 本地渲染
// 选中单位来源由事件中心维护，不再本地 GroupEnumUnitsSelected

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const UI工具 = require("系统.09．表现系统.01．UI工具.index") as {
  createFrame: (options: any) => number;
  setFramePosition: (frame: number, options: any) => void;
  setFrameSize: (frame: number, options: any) => void;
  setFrameTexture: (frame: number, texture: string) => void;
  setFrameHoverEvents: (frame: number, onHover: () => void, onUnhover: () => void, enable: boolean) => void;
  setFramePointRelative: (frame: number, point: number, relativeTo: number, relativePoint: number, x: number, y: number) => void;
  createTextLabel: (name: string, parent: number, text: string, position: any, size: any) => number;
  FrameType: { BACKDROP: number; GLUETEXTBUTTON: number };
  FramePoint: { TOPLEFT: number; TOPRIGHT: number; CENTER: number; BOTTOM: number };
  hideFrame: (frame: number) => void;
  showFrame: (frame: number) => void;
};
const ____hwMod = require("lib.扩展函数.封装函数.04．硬件输入.index");
const getGameUI = ____hwMod.getGameUI as () => number;
const ____safeUtils = require("系统.00．核心系统.07．联机安全工具");
const safeTimerStart = ____safeUtils.safeTimerStart as (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
const safeDestroyTimer = ____safeUtils.safeDestroyTimer as (timer: any) => void;

const ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心");
const getSoleSelectedUnitForPlayer = ____selectionCenter.getSoleSelectedUnitForPlayer as (playerId: number) => any | null;

const ____viewModelMod = require("系统.05．Buff系统.04．BuffUIViewModel");
const buildBuffBarViewModel = ____viewModelMod.buildBuffBarViewModel as (unit: any | null) => { slots: Array<{ visible: boolean; iconPath: string; remainText: string; tooltipText: string }> };
const getMaxSlots = ____viewModelMod.getMaxSlots as () => number;

const MAX_SLOTS = getMaxSlots();
const BUFF_BAR_X0 = 0.204;
const BUFF_BAR_Y = 0.1655;
const ICON_W = 0.02;
const ICON_H = 16 / 600;
const ICON_GAP = 0.0005;
const TIP_BOX_TEX = "UI\\wenbenkuang.blp";
const TIP_W = 0.22;
const TIP_H = 0.056;
const TIP_PAD = 0.005;
const TIP_OFFSET_Y_FROM_ICON_TOP = 0.07;

interface SlotFrames {
  root: number;
  remainText: number;
  hit: number;
  tipBox: number;
  tipText: number;
}

const slots: SlotFrames[] = [];
let buffUiInitialized = false;
let refreshTimer: any = null;
let pendingInitDelayTimer: any = null;
const buffBarViewModelByPlayerId: Record<number, { slots: Array<{ visible: boolean; iconPath: string; remainText: string; tooltipText: string }> } | undefined> = {};
const hoverSlotIndexByFrameId: Record<number, number | undefined> = {};

function getTriggerUiEventFrame(): number {
  return typeof (japi as any).DzGetTriggerUIEventFrame === "function" ? (japi as any).DzGetTriggerUIEventFrame() : 0;
}

function setFrameLevelSafe(frame: number, level: number): void {
  if (frame === 0) return;
  if (typeof (japi as any).DzFrameSetPriority === "function") {
    (japi as any).DzFrameSetPriority(frame, level);
  }
}

function showSlotTooltipByIndex(index: number): void {
  const s = slots[index];
  if (s && s.tipBox !== 0) UI工具.showFrame(s.tipBox);
  if (s && s.tipText !== 0) UI工具.showFrame(s.tipText);
}

function hideSlotTooltipByIndex(index: number): void {
  const s = slots[index];
  if (s && s.tipText !== 0) UI工具.hideFrame(s.tipText);
  if (s && s.tipBox !== 0) UI工具.hideFrame(s.tipBox);
}

function onSlotHoverEnter(): void {
  const frame = getTriggerUiEventFrame();
  if (frame === 0) return;
  const index = hoverSlotIndexByFrameId[frame];
  if (index == null) return;
  showSlotTooltipByIndex(index);
}

function onSlotHoverLeave(): void {
  const frame = getTriggerUiEventFrame();
  if (frame === 0) return;
  const index = hoverSlotIndexByFrameId[frame];
  if (index == null) return;
  hideSlotTooltipByIndex(index);
}

function createOneSlot(index: number, parent: number): SlotFrames | null {
  const x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP);
  const bd =
    UI工具.createFrame({
      type: UI工具.FrameType.BACKDROP,
      name: "BuffUIBarIcon" + index,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[BuffUI] slot" + index + " bd=" + bd);
  if (!bd || bd === 0) return null;
  UI工具.setFramePosition(bd, { point: UI工具.FramePoint.TOPLEFT, x, y: BUFF_BAR_Y });
  UI工具.setFrameSize(bd, { width: ICON_W, height: ICON_H });
  UI工具.setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp");
  setFrameLevelSafe(bd, 180);

  const remainText =
    UI工具.createTextLabel(
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
    (japi as any).DzFrameSetTextAlignment(remainText, UI工具.FramePoint.CENTER);
    setFrameLevelSafe(remainText, 182);
  }

  const hit =
    UI工具.createFrame({
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
    (japi as any).DzFrameSetAllPoints(hit, bd);
    setFrameLevelSafe(hit, 181);
    UI工具.setFrameHoverEvents(hit, onSlotHoverEnter, onSlotHoverLeave, false);
  }

  const boxW = TIP_W + TIP_PAD * 2;
  const boxH = TIP_H + TIP_PAD * 2;
  const tipBox =
    UI工具.createFrame({
      type: UI工具.FrameType.BACKDROP,
      name: "BuffUIBarTip" + index,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  if (tipBox && tipBox !== 0) {
    UI工具.setFramePointRelative(
      tipBox,
      UI工具.FramePoint.TOPLEFT,
      bd,
      UI工具.FramePoint.TOPRIGHT,
      0.002,
      TIP_OFFSET_Y_FROM_ICON_TOP
    );
    UI工具.setFrameSize(tipBox, { width: boxW, height: boxH });
    UI工具.setFrameTexture(tipBox, TIP_BOX_TEX);
    setFrameLevelSafe(tipBox, 0);
    UI工具.hideFrame(tipBox);
  }

  const tipText =
    UI工具.createTextLabel(
      "BuffUIBarTipTxt" + index,
      tipBox && tipBox !== 0 ? tipBox : bd,
      "",
      tipBox && tipBox !== 0
        ? { relativeTo: tipBox, point: UI工具.FramePoint.CENTER, relativePoint: UI工具.FramePoint.CENTER, x: 0, y: 0 }
        : { relativeTo: bd, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP },
      { width: boxW * 0.92, height: boxH * 0.88 }
    ) || 0;
  if (tipText && tipText !== 0) {
    (japi as any).DzFrameSetTextAlignment(tipText, 0);
    setFrameLevelSafe(tipText, 0);
    UI工具.hideFrame(tipText);
  }

  if (hit !== 0 && tipBox !== 0) {
    (japi as any).DzFrameSetTooltip(hit, tipBox);
  }

  UI工具.hideFrame(bd);
  return {
    root: bd,
    remainText: remainText || 0,
    hit: hit || 0,
    tipBox: tipBox || 0,
    tipText: tipText || 0,
  };
}

function hideSlot(i: number): void {
  const s = slots[i];
  if (!s) return;
  if (s.tipText !== 0) UI工具.hideFrame(s.tipText);
  if (s.tipBox !== 0) UI工具.hideFrame(s.tipBox);
  if (s.hit !== 0) UI工具.hideFrame(s.hit);
  if (s.root !== 0) UI工具.hideFrame(s.root);
}

function hideAllSlots(): void {
  for (let i = 0; i < MAX_SLOTS; i++) hideSlot(i);
}

function renderBuffBarLocal(vm: { slots: Array<{ visible: boolean; iconPath: string; remainText: string; tooltipText: string }> }): void {
  for (let i = 0; i < MAX_SLOTS; i++) {
    const slotVM = vm.slots[i];
    const slot = slots[i];
    if (!slot) continue;
    if (slotVM.visible) {
      if (slot.root !== 0) {
        UI工具.setFrameTexture(slot.root, slotVM.iconPath);
        UI工具.showFrame(slot.root);
      }
      if (slot.remainText !== 0) {
        (japi as any).DzFrameSetText(slot.remainText, slotVM.remainText);
      }
      if (slot.tipText !== 0) {
        (japi as any).DzFrameSetText(slot.tipText, slotVM.tooltipText);
      }
      if (slot.hit !== 0) UI工具.showFrame(slot.hit);
    } else {
      hideSlot(i);
    }
  }
}

function rebuildAllBuffBarViewModels(): void {
  for (let playerId = 0; playerId < 16; playerId++) {
    const targetUnit = getSoleSelectedUnitForPlayer(playerId);
    buffBarViewModelByPlayerId[playerId] = buildBuffBarViewModel(targetUnit);
  }
}

function syncBuffBar(): void {
  const localPlayerId = (jass as any).GetPlayerId((jass as any).GetLocalPlayer());
  rebuildAllBuffBarViewModels();
  const viewModel = localPlayerId >= 0 ? buffBarViewModelByPlayerId[localPlayerId] : undefined;
  const visCount = viewModel ? viewModel.slots.filter(s => s.visible).length : 0;
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 5, "[BuffUI] pid=" + localPlayerId + " vm=" + (viewModel ? "yes" : "nil") + " vis=" + visCount + " slotsLen=" + slots.length);
  if ((jass as any).GetLocalPlayer() === (jass as any).Player(localPlayerId) && viewModel) {
    renderBuffBarLocal(viewModel);
  } else if ((jass as any).GetLocalPlayer() === (jass as any).Player(localPlayerId)) {
    hideAllSlots();
  }
}

function createUi(): void {
  const parent = getGameUI();
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[BuffUI] createUi parent=" + parent);
  if (parent === 0 || parent == null) return;
  for (let i = 0; i < MAX_SLOTS; i++) {
    const s = createOneSlot(i, parent);
    if (s) slots[i] = s;
  }
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[BuffUI] slots created=" + slots.length);
}

function startRefreshTimer(): void {
  if (refreshTimer !== null) return;
  refreshTimer = jass.CreateTimer();
  safeTimerStart(refreshTimer, 0.1, true, onBuffUiRefreshTick);
}

function onBuffUiRefreshTick(): void {
  syncBuffBar();
}

function onBuffUiInitDelayTimer(): void {
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[BuffUI] initDelayTimer fired, buffUiInit=" + buffUiInitialized);
  createUi();
  startRefreshTimer();
  if (pendingInitDelayTimer !== null) {
    safeDestroyTimer(pendingInitDelayTimer);
    pendingInitDelayTimer = null;
  }
}

export function init(): void {
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[BuffUI] onPlayerHeroRegistered called, init=" + buffUiInitialized);
  if (buffUiInitialized) return;
  buffUiInitialized = true;
  pendingInitDelayTimer = jass.CreateTimer();
  safeTimerStart(pendingInitDelayTimer, 1.0, false, onBuffUiInitDelayTimer);
}

export function setDebugMode(enabled: boolean): void {
}

export {};
