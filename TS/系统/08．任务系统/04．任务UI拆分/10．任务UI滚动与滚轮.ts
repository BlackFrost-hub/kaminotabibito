const japi = require("jass.japi") as any;

import { ENABLE_MOUSE_WHEEL_SCROLL } from "./01．任务UI常量";
import {
  isWheelTargetForTaskList as isWheelTargetForTaskListByJapi,
  isTaskScrollThumbDragHit,
} from "./03．任务UI列表与滚动";
import {
  createTriggerOrNull,
  getMouseY,
  getScrollbarTrackThumbTravelPx,
  registerMouseButtonEventByCode,
  registerMouseMoveEventByCode,
} from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import {
  LIST_VIEW_H,
  SCROLLBAR_W,
  SCROLL_THUMB_SIZE,
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
} from "./01．任务UI常量";
import { pcallDzFrameShow } from "./02．任务UI辅助";

export interface TaskUIScrollContext {
  mainPanel: number | null;
  listContainer: number | null;
  scrollBarFrame: number | null;
  scrollThumbFrame: number | null;
  scrollThumbHitBtn: number | null;
  FramePoint: any;
  setFramePointRelative: any;
  taskListWheelTrig: unknown;
  getMouseFocus?: () => number;
  getWheelDelta?: () => number;
  registerMouseWheel: (sync: boolean, cb: () => void, playerId?: number) => unknown;
  isVisible: () => boolean;
  getCurrentPageCount: () => number;
  getCurrentPage: () => number;
  setCurrentPage: (page: number) => void;
  onPageChanged: (prevPage: number, nextPage: number) => void;
}

// ── 模块级上下文（避免匿名闭包进 JASS） ──
let wheelCtx: TaskUIScrollContext | null = null;
/** 帧上 MOUSE_DOWN 在部分环境不触发；用全局鼠标（`registerMouseButtonEventByCode`，见 ui-frame-types.mdc） */
let taskThumbGlobalMouseTrig: unknown = null;

function taskUIWheelEventPcallBody(): void {
  const ctx = wheelCtx!;
  if (!ctx.isVisible()) return;
  if (!isWheelTargetForTaskListByJapi(japi, ctx.getMouseFocus, ctx.listContainer, ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn)) return;
  handleTaskUIListWheel(ctx);
}

function onMouseWheelEvent(): void {
  if (!wheelCtx) return;
  (pcall as any)(taskUIWheelEventPcallBody);
}

function thumbTravelNorm(): number {
  return LIST_VIEW_H - SCROLL_THUMB_SIZE - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_BOTTOM_COMPENSATION;
}

/** 按 0..1 比例摆 thumb（与当前页无关，用于拖拽跟手） */
function setTaskScrollThumbByRatio(ctx: TaskUIScrollContext, ratio: number): void {
  if (!ctx.scrollBarFrame || !ctx.scrollThumbFrame) return;
  const centeredX = (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5;
  let travelRange = thumbTravelNorm();
  if (travelRange < 0) travelRange = 0;
  const r = Math.max(0, Math.min(1, ratio));
  const topOffset = SCROLL_THUMB_TOP_COMPENSATION + travelRange * r;
  ctx.setFramePointRelative(ctx.scrollThumbFrame, ctx.FramePoint.TOPLEFT, ctx.scrollBarFrame, ctx.FramePoint.TOPLEFT, centeredX, -topOffset);
}

function updateTaskUIScrollThumbPosition(ctx: TaskUIScrollContext, pageCount: number): void {
  if (pageCount <= 1) {
    setTaskScrollThumbByRatio(ctx, 0);
    return;
  }
  const currentPage = Math.max(0, Math.min(pageCount - 1, ctx.getCurrentPage()));
  const ratio = currentPage / (pageCount - 1);
  setTaskScrollThumbByRatio(ctx, ratio);
}

export function isTaskUIWheelTarget(ctx: TaskUIScrollContext): boolean {
  if (!ctx.mainPanel) return false;
  return isWheelTargetForTaskListByJapi(japi, ctx.getMouseFocus, ctx.listContainer, ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn);
}

export function handleTaskUIListWheel(ctx: TaskUIScrollContext): void {
  const pageCount = ctx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const delta = typeof ctx.getWheelDelta === "function" ? ctx.getWheelDelta() : 0;
  if (delta === 0) return;
  const currentPage = ctx.getCurrentPage();
  let nextPage = currentPage;
  if (delta > 0) nextPage = Math.max(0, currentPage - 1);
  if (delta < 0) nextPage = Math.min(pageCount - 1, currentPage + 1);
  if (nextPage === currentPage) return;
  ctx.setCurrentPage(nextPage);
  ctx.onPageChanged(currentPage, nextPage);
  updateTaskUIScrollThumbPosition(ctx, pageCount);
}

// ── 滑块拖拽：按下记录起点；移动时 thumb 跟手 + 仅当比例跨过「整页」才 onPageChanged；抬起再对齐一次 ──
let dragCtx: TaskUIScrollContext | null = null;
/** 仅在为 true 时处理 MOUSE_UP / MOVE，避免未收到 DOWN 时误算 */
let thumbDragActive = false;
let thumbDragStartMouseYPx = 0;
let thumbDragStartPage = 0;

function ratioFromThumbDragMouseY(pageCount: number, mouseYPx: number): number {
  const travelNorm = thumbTravelNorm();
  if (travelNorm <= 0 || pageCount <= 1) return 0;
  const travelPx = getScrollbarTrackThumbTravelPx(travelNorm);
  const startRatio = pageCount > 1 ? thumbDragStartPage / (pageCount - 1) : 0;
  return Math.max(0, Math.min(1, startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx));
}

function onThumbDragStart(): void {
  if (!dragCtx) return;
  if (dragCtx.getCurrentPageCount() <= 1) return;
  thumbDragStartMouseYPx = getMouseY();
  thumbDragStartPage = dragCtx.getCurrentPage();
  thumbDragActive = true;
  onThumbDragMove();
}

/** 鼠标移动：thumb 实时跟手；翻页仅当 round(ratio) 对应页与当前页不同（即跨过至少半格「页距」） */
function onThumbDragMove(): void {
  if (!thumbDragActive || !dragCtx) return;
  const pageCount = dragCtx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const ratio = ratioFromThumbDragMouseY(pageCount, getMouseY());
  setTaskScrollThumbByRatio(dragCtx, ratio);
  const targetPage = Math.max(0, Math.min(pageCount - 1, Math.round(ratio * (pageCount - 1))));
  const cur = dragCtx.getCurrentPage();
  if (targetPage !== cur) {
    dragCtx.setCurrentPage(targetPage);
    dragCtx.onPageChanged(cur, targetPage);
  }
}

function onThumbDragEnd(): void {
  if (!thumbDragActive) return;
  thumbDragActive = false;
  if (!dragCtx) return;
  const pageCount = dragCtx.getCurrentPageCount();
  if (pageCount <= 1) return;
  const ratio = ratioFromThumbDragMouseY(pageCount, getMouseY());
  const targetPage = Math.max(0, Math.min(pageCount - 1, Math.round(ratio * (pageCount - 1))));
  const cur = dragCtx.getCurrentPage();
  if (targetPage !== cur) {
    dragCtx.setCurrentPage(targetPage);
    dragCtx.onPageChanged(cur, targetPage);
  }
  updateTaskUIScrollThumbPosition(dragCtx, pageCount);
}

/** 本图约定：左键按下 (btn=1,status=1)、释放 (1,0)，见 .cursor/rules/dzapi/ui-frame-types.mdc */
function taskUIThumbPressPcallBody(): void {
  const ctx = wheelCtx;
  if (!ctx || !ctx.isVisible()) return;
  if (!isTaskScrollThumbDragHit(japi, ctx.getMouseFocus, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn)) {
    return;
  }
  dragCtx = ctx;
  onThumbDragStart();
}

function onGlobalThumbLeftPress(): void {
  (pcall as any)(taskUIThumbPressPcallBody);
}

function taskUIThumbReleasePcallBody(): void {
  onThumbDragEnd();
}

function onGlobalThumbLeftRelease(): void {
  (pcall as any)(taskUIThumbReleasePcallBody);
}

function taskUIThumbMovePcallBody(): void {
  onThumbDragMove();
}

function onGlobalThumbDragMove(): void {
  (pcall as any)(taskUIThumbMovePcallBody);
}

function ensureTaskThumbGlobalMouseRegistered(): void {
  if (taskThumbGlobalMouseTrig != null) return;
  const trig = createTriggerOrNull();
  if (!trig) return;
  // 左键按下/抬起 (btn=1,status) 见 ui-frame-types.mdc；sync 与滚轮一致走本机 false
  registerMouseButtonEventByCode(trig, 1, 1, false, onGlobalThumbLeftPress);
  registerMouseButtonEventByCode(trig, 1, 0, false, onGlobalThumbLeftRelease);
  registerMouseMoveEventByCode(trig, false, onGlobalThumbDragMove);
  taskThumbGlobalMouseTrig = trig;
}

export function registerTaskUIListWheel(ctx: TaskUIScrollContext): unknown {
  wheelCtx = ctx;
  dragCtx = ctx;
  ensureTaskThumbGlobalMouseRegistered();

  if (!ENABLE_MOUSE_WHEEL_SCROLL) return ctx.taskListWheelTrig;
  if (ctx.taskListWheelTrig) return ctx.taskListWheelTrig;
  ctx.taskListWheelTrig = ctx.registerMouseWheel(false, onMouseWheelEvent);
  return ctx.taskListWheelTrig;
}

export function updateTaskUIScrollBarVisibility(ctx: TaskUIScrollContext, pageCount: number, hasQuestRows: boolean): void {
  const visible = hasQuestRows;
  for (const frame of [ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn]) {
    if (frame && frame !== 0) pcallDzFrameShow(japi, frame, visible);
  }
  if (visible) updateTaskUIScrollThumbPosition(ctx, pageCount);
}
