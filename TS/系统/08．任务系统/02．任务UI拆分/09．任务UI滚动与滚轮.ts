const { round, clampMin, clampRange } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  round: (this: void, value: number) => number;
  clampMin: (this: void, value: number, minValue: number) => number;
  clampRange: (this: void, value: number, minValue: number, maxValue: number) => number;
};
const japi = require("jass.japi") as any;
const { createTriggerOrNull, getMouseY, registerMouseButtonEventByCode, registerMouseMoveEventByCode } = require("../../../lib/扩展函数/封装函数/04．硬件输入/index") as {
  createTriggerOrNull: () => any;
  getMouseY: () => number;
  registerMouseButtonEventByCode: (trigger: any, button: number, status: number, sync: boolean, action: () => void) => void;
  registerMouseMoveEventByCode: (trigger: any, sync: boolean, action: () => void) => void;
};

import {
  ENABLE_MOUSE_WHEEL_SCROLL,
  ENABLE_TASK_UI_TRACK_CLICK,
  ENTRY_Y,
  PANEL_REL_TO_ENTRY_Y,
  LIST_VIEW_H,
  SCROLLBAR_W,
  SCROLLBAR_TOP_INSET,
  SCROLL_THUMB_SIZE,
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
} from "./01．任务UI常量";
import {
  getClientHeight,
  getMouseYRelative,
  getWindowHeight,
  getScrollbarTrackThumbTravelPx,
  frameSetScriptByCode,
} from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { pcallDzFrameShow } from "./02．任务UI辅助";

/** 帧事件 ID（见 `.cursor/rules/engine/dzapi/ui-frame-types.mdc`） */
const FRAME_EVENT_CLICK = 1;

export interface TaskUIScrollContext {
  playerId: number;
  mainPanel: number | null;
  listContainer: number | null;
  scrollBarFrame: number | null;
  scrollBarHitBtn: number | null;
  scrollThumbFrame: number | null;
  scrollThumbHitBtn: number | null;
  FramePoint: any;
  setFramePointRelative: any;
  taskListWheelRegistered: boolean;
  getWheelDelta?: () => number;
  registerMouseWheel?: (this: void, sync: boolean, cb: () => void, playerId?: number) => unknown;
  isVisible: () => boolean;
  isOwnedByLocalPlayer: () => boolean;
  getCurrentPageCount: () => number;
  getCurrentPage: () => number;
  setCurrentPage: (page: number) => void;
  onPageChanged: (prevPage: number, nextPage: number) => void;
}

// ── 模块级上下文（避免匿名闭包进 JASS） ──
/** N 槽：所有已注册的滚动上下文，滚轮/轨道点击帧事件路由到可见的那个 */
const allWheelCtxs: TaskUIScrollContext[] = [];
let taskThumbGlobalMouseRegistered = false;
let taskGlobalWheelRegistered = false;
let dragCtx: TaskUIScrollContext | null = null;
let thumbDragActive = false;
let thumbDragStartMouseYPx = 0;
let thumbDragStartPage = 0;

function findVisibleWheelCtx(): TaskUIScrollContext | null {
  for (let i = 0; i < allWheelCtxs.length; i++) {
    const ctx = allWheelCtxs[i];
    if (ctx.isOwnedByLocalPlayer() && ctx.isVisible()) return ctx;
  }
  return null;
}

/**
 * 本地全局滚轮回调，只路由到本地玩家当前可见的槽位。
 * 回调为全局具名函数，符合 Dz 回调约束。
 */
function onMouseWheelEvent(): void {
  const ctx = findVisibleWheelCtx();
  if (!ctx || !ctx.isVisible()) return;
  handleTaskUIListWheel(ctx);
}

function thumbTravelNorm(): number {
  return LIST_VIEW_H - SCROLL_THUMB_SIZE - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_BOTTOM_COMPENSATION;
}

/** 按 0..1 比例摆放滑块（按页索引换算，非拖拽跟手） */
function setTaskScrollThumbByRatio(ctx: TaskUIScrollContext, ratio: number): void {
  if (!ctx.scrollBarFrame || !ctx.scrollThumbFrame) return;
  const centeredX = (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5;
  let travelRange = thumbTravelNorm();
  if (travelRange < 0) travelRange = 0;
  const r = clampRange(ratio, 0, 1);
  const topOffset = SCROLL_THUMB_TOP_COMPENSATION + travelRange * r;
  ctx.setFramePointRelative(ctx.scrollThumbFrame, ctx.FramePoint.TOPLEFT, ctx.scrollBarFrame, ctx.FramePoint.TOPLEFT, centeredX, -topOffset);
}

function updateTaskUIScrollThumbPosition(ctx: TaskUIScrollContext, pageCount: number): void {
  if (pageCount <= 1) {
    setTaskScrollThumbByRatio(ctx, 0);
    return;
  }
  const currentPage = clampRange(ctx.getCurrentPage(), 0, pageCount - 1);
  const ratio = currentPage / (pageCount - 1);
  setTaskScrollThumbByRatio(ctx, ratio);
}

export function handleTaskUIListWheel(ctx: TaskUIScrollContext): void {
  const pageCount = ctx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const delta = typeof ctx.getWheelDelta === "function" ? ctx.getWheelDelta() : 0;
  if (delta === 0) return;
  const currentPage = ctx.getCurrentPage();
  let nextPage = currentPage;
  if (delta > 0) nextPage = clampMin(currentPage - 1, 0);
  if (delta < 0) nextPage = currentPage + 1 < pageCount ? currentPage + 1 : pageCount - 1;
  if (nextPage === currentPage) return;
  ctx.setCurrentPage(nextPage);
  ctx.onPageChanged(currentPage, nextPage);
  updateTaskUIScrollThumbPosition(ctx, pageCount);
}

// ── 虚拟分区：轨道点击跳页 ──
function getTaskScrollTrackTopYNorm(): number {
  return ENTRY_Y + PANEL_REL_TO_ENTRY_Y - SCROLLBAR_TOP_INSET;
}

function getTaskScrollTrackBottomYNorm(): number {
  return getTaskScrollTrackTopYNorm() - LIST_VIEW_H;
}

function getTaskScrollThumbCenterTopYNorm(): number {
  return getTaskScrollTrackTopYNorm() - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_SIZE * 0.5;
}

function getTaskScrollThumbCenterBottomYNorm(): number {
  return getTaskScrollThumbCenterTopYNorm() - thumbTravelNorm();
}

function getTaskScrollTrackClickRatio(): number {
  const topY = getTaskScrollThumbCenterTopYNorm();
  const bottomY = getTaskScrollThumbCenterBottomYNorm();
  const mouseYPx = getMouseYRelative();
  const clientH = getClientHeight();
  const baseH = clientH > 0 ? clientH : getWindowHeight() || 600;
  const mouseY = ((baseH - mouseYPx) * 0.6) / baseH;
  if (topY <= bottomY) return 0;
  const ratio = clampRange((topY - mouseY) / (topY - bottomY), 0, 1);
  return ratio;
}

function onScrollBarTrackClick(ctx: TaskUIScrollContext): void {
  const pageCount = ctx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const ratio = getTaskScrollTrackClickRatio();
  const targetPage = clampRange(round(ratio * (pageCount - 1)), 0, pageCount - 1);
  const currentPage = ctx.getCurrentPage();
  if (targetPage === currentPage) {
    updateTaskUIScrollThumbPosition(ctx, pageCount);
    return;
  }
  ctx.setCurrentPage(targetPage);
  ctx.onPageChanged(currentPage, targetPage);
  updateTaskUIScrollThumbPosition(ctx, pageCount);
}

// ── 虚拟分区：轨道点击（帧事件 ID 1） ──
/**
 * 轨道点击回调：帧事件已带命中信息，直接用本地鼠标纵坐标换算目标页。
 * 纯本机 UI 交互，`sync=false`（见 n-slot-ui-symmetric-execution §4.4）。
 */
function onTaskUITrackClickEvent(): void {
  const ctx = findVisibleWheelCtx();
  if (!ctx || !ctx.isVisible()) return;
  onScrollBarTrackClick(ctx);
}

function ratioFromThumbDragMouseY(pageCount: number, mouseYPx: number): number {
  const travelPx = getScrollbarTrackThumbTravelPx(thumbTravelNorm());
  if (travelPx <= 0 || pageCount <= 1) return 0;
  const startRatio = thumbDragStartPage / (pageCount - 1);
  return clampRange(startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx, 0, 1);
}

function onThumbDragStart(): void {
  if (!dragCtx) return;
  if (dragCtx.getCurrentPageCount() <= 1) return;
  thumbDragStartMouseYPx = getMouseY();
  thumbDragStartPage = dragCtx.getCurrentPage();
  thumbDragActive = true;
}

function onThumbDragMove(): void {
  if (!thumbDragActive || !dragCtx) return;
  const pageCount = dragCtx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const ratio = ratioFromThumbDragMouseY(pageCount, getMouseY());
  setTaskScrollThumbByRatio(dragCtx, ratio);
  const targetPage = clampRange(round(ratio * (pageCount - 1)), 0, pageCount - 1);
  const currentPage = dragCtx.getCurrentPage();
  if (targetPage !== currentPage) {
    dragCtx.setCurrentPage(targetPage);
    dragCtx.onPageChanged(currentPage, targetPage);
  }
}

function onThumbDragEnd(): void {
  if (!thumbDragActive) return;
  thumbDragActive = false;
  if (dragCtx) updateTaskUIScrollThumbPosition(dragCtx, dragCtx.getCurrentPageCount());
}

function onGlobalThumbLeftPress(): void {
  const ctx = findVisibleWheelCtx();
  if (!ctx) return;
  const focus = japi.DzGetMouseFocus();
  if (focus !== ctx.scrollThumbFrame && focus !== ctx.scrollThumbHitBtn) return;
  dragCtx = ctx;
  onThumbDragStart();
}

function onGlobalThumbLeftRelease(): void { onThumbDragEnd(); }
function onGlobalThumbDragMove(): void { onThumbDragMove(); }

function ensureTaskThumbGlobalMouseRegistered(): void {
  if (taskThumbGlobalMouseRegistered) return;
  const trigger = createTriggerOrNull();
  if (!trigger) return;
  registerMouseButtonEventByCode(trigger, 1, 1, false, onGlobalThumbLeftPress);
  registerMouseButtonEventByCode(trigger, 1, 0, false, onGlobalThumbLeftRelease);
  registerMouseMoveEventByCode(trigger, false, onGlobalThumbDragMove);
  taskThumbGlobalMouseRegistered = true;
}

function registerSlotFrameEvents(ctx: TaskUIScrollContext): void {
  if (ctx.taskListWheelRegistered) return;

  // 轨道点击跳页：帧事件 ID 1，挂轨道命中帧；纯本机 UI 交互 → sync=false
  if (ENABLE_TASK_UI_TRACK_CLICK) {
    const trackFrame = ctx.scrollBarHitBtn || ctx.scrollBarFrame;
    if (trackFrame) {
      frameSetScriptByCode(trackFrame, FRAME_EVENT_CLICK, onTaskUITrackClickEvent, false);
    }
  }

  ctx.taskListWheelRegistered = true;
}

export function registerTaskUIListWheel(ctx: TaskUIScrollContext): unknown {
  allWheelCtxs.push(ctx);
  dragCtx = ctx;
  ensureTaskThumbGlobalMouseRegistered();
  if (ENABLE_MOUSE_WHEEL_SCROLL && !taskGlobalWheelRegistered && ctx.registerMouseWheel) {
    // 滚轮是每个客户端一套的本地硬件事件，不能绑定第一个初始化槽位。
    // 所有玩家槽位都在每个客户端创建；只注册一次后由回调路由到本地可见槽位。
    ctx.registerMouseWheel(false, onMouseWheelEvent);
    taskGlobalWheelRegistered = true;
  }
  registerSlotFrameEvents(ctx);
  return null;
}

export function updateTaskUIScrollBarVisibility(ctx: TaskUIScrollContext, pageCount: number, hasQuestRows: boolean): void {
  const visible = hasQuestRows;
  for (const frame of [ctx.scrollBarFrame, ctx.scrollBarHitBtn, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn]) {
    if (frame && frame !== 0) pcallDzFrameShow(frame, visible);
  }
  if (visible) updateTaskUIScrollThumbPosition(ctx, pageCount);
}
