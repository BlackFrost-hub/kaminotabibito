const japi = require("jass.japi") as any;
const { round, clampMin, clampRange } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  round: (this: void, value: number) => number;
  clampMin: (this: void, value: number, minValue: number) => number;
  clampRange: (this: void, value: number, minValue: number, maxValue: number) => number;
};
declare const print: ((msg: string) => void) | undefined;

import {
  ENABLE_MOUSE_WHEEL_SCROLL,
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
  isWheelTargetForTaskList as isWheelTargetForTaskListByJapi,
  isTaskScrollThumbDragHit,
  isTaskScrollBarTrackHit,
} from "./03．任务UI列表与滚动";
import {
  createTriggerOrNull,
  getClientHeight,
  getMouseY,
  getMouseYRelative,
  getWindowHeight,
  getScrollbarTrackThumbTravelPx,
  registerMouseButtonEventByCode,
  registerMouseMoveEventByCode,
} from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { pcallDzFrameShow } from "./02．任务UI辅助";

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
  getMouseFocus?: (this: void) => number;
  getWheelDelta?: () => number;
  /** `this: void`：避免 TSTL 编成 `ctx:registerMouseWheel` 把上下文表塞进 `sync` 位 */
  registerMouseWheel(this: void, sync: boolean, cb: () => void, playerId?: number): unknown;
  isVisible: () => boolean;
  isOwnedByLocalPlayer: () => boolean;
  getCurrentPageCount: () => number;
  getCurrentPage: () => number;
  setCurrentPage: (page: number) => void;
  onPageChanged: (prevPage: number, nextPage: number) => void;
}

// ── 模块级上下文（避免匿名闭包进 JASS） ──
/** N 槽：所有已注册的滚动上下文，滚轮/拖拽事件路由到可见的那个 */
// ========== 虚拟分区：滚轮翻页 + 滑块拖拽 ==========
const allWheelCtxs: TaskUIScrollContext[] = [];
/** 帧上 MOUSE_DOWN 在部分环境不触发；用全局鼠标（`registerMouseButtonEventByCode`，见 ui-frame-types.mdc） */
let taskThumbGlobalMouseRegistered = false;

function findVisibleWheelCtx(): TaskUIScrollContext | null {
  for (let i = 0; i < allWheelCtxs.length; i++) {
    const ctx = allWheelCtxs[i];
    if (ctx.isOwnedByLocalPlayer() && ctx.isVisible()) return ctx;
  }
  return null;
}

function taskUIWheelEventPcallBody(): void {
  const ctx = findVisibleWheelCtx();
  if (!ctx || !ctx.isVisible()) return;
  if (!isWheelTargetForTaskListByJapi(japi, ctx.getMouseFocus, ctx.listContainer, ctx.scrollBarHitBtn || ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn)) return;
  handleTaskUIListWheel(ctx);
}

function onMouseWheelEvent(): void {
  taskUIWheelEventPcallBody();
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

export function isTaskUIWheelTarget(ctx: TaskUIScrollContext): boolean {
  if (!ctx.mainPanel) return false;
  return isWheelTargetForTaskListByJapi(japi, ctx.getMouseFocus, ctx.listContainer, ctx.scrollBarHitBtn || ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn);
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

// ── 虚拟分区：滑块拖拽（按下/移动/抬起） ──
let dragCtx: TaskUIScrollContext | null = null;
// 褰撳墠浠诲姟 UI 鍙湁涓€濂楀彲鎷栨嫿婊戝潡锛屾墍浠ヤ娇鐢ㄦā鍧楃骇 drag session銆?
// 濡傛灉鍚庣画鍚屼竴瀹㈡埛绔唴鍚屾椂寮曞叆澶氬鍙嫋鎷?UI锛岃繖閲岄渶瑕佹敼鎴愭寜 context 鎸傝浇鐨勬嫋鎷界姸鎬併€? 
/** 仅在为 true 时处理 MOUSE_UP / MOVE，避免未收到 DOWN 时误算 */
let thumbDragActive = false;
let thumbDragStartMouseYPx = 0;
let thumbDragStartPage = 0;

function ratioFromThumbDragMouseY(pageCount: number, mouseYPx: number): number {
  const travelNorm = thumbTravelNorm();
  if (travelNorm <= 0 || pageCount <= 1) return 0;
  const travelPx = getScrollbarTrackThumbTravelPx(travelNorm);
  const startRatio = pageCount > 1 ? thumbDragStartPage / (pageCount - 1) : 0;
  return clampRange(startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx, 0, 1);
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
  const targetPage = clampRange(round(ratio * (pageCount - 1)), 0, pageCount - 1);
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
  const targetPage = clampRange(round(ratio * (pageCount - 1)), 0, pageCount - 1);
  const cur = dragCtx.getCurrentPage();
  if (targetPage !== cur) {
    dragCtx.setCurrentPage(targetPage);
    dragCtx.onPageChanged(cur, targetPage);
  }
  updateTaskUIScrollThumbPosition(dragCtx, pageCount);
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

/** 本图约定：左键按下 (btn=1,status=1)、释放 (1,0)，见 .cursor/rules/dzapi/ui-frame-types.mdc */
function taskUIThumbPressPcallBody(): void {
  const ctx = findVisibleWheelCtx();
  if (!ctx || !ctx.isVisible()) return;
  const thumbHit = isTaskScrollThumbDragHit(japi, ctx.getMouseFocus, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn);
  if (thumbHit) {
    dragCtx = ctx;
    onThumbDragStart();
    return;
  }
  const trackHit = isTaskScrollBarTrackHit(japi, ctx.getMouseFocus, ctx.scrollBarHitBtn || ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn);
  if (!trackHit) return;
  onScrollBarTrackClick(ctx);
}

function onGlobalThumbLeftPress(): void {
  taskUIThumbPressPcallBody();
}

function taskUIThumbReleasePcallBody(): void {
  onThumbDragEnd();
}

function onGlobalThumbLeftRelease(): void {
  taskUIThumbReleasePcallBody();
}

function taskUIThumbMovePcallBody(): void {
  onThumbDragMove();
}

function onGlobalThumbDragMove(): void {
  taskUIThumbMovePcallBody();
}

// ── 虚拟分区：全局鼠标事件注册与滚轮注册 ──
function ensureTaskThumbGlobalMouseRegistered(): void {
  if (taskThumbGlobalMouseRegistered) return;
  const trig = createTriggerOrNull();
  if (!trig) return;
  registerMouseButtonEventByCode(trig, 1, 1, false, onGlobalThumbLeftPress);
  registerMouseButtonEventByCode(trig, 1, 0, false, onGlobalThumbLeftRelease);
  registerMouseMoveEventByCode(trig, false, onGlobalThumbDragMove);
  taskThumbGlobalMouseRegistered = true;
}

export function registerTaskUIListWheel(ctx: TaskUIScrollContext): unknown {
  dragCtx = ctx;
  allWheelCtxs.push(ctx);
  ensureTaskThumbGlobalMouseRegistered();

  if (!ENABLE_MOUSE_WHEEL_SCROLL) return null;
  if (ctx.taskListWheelRegistered) return null;
  ctx.registerMouseWheel(false, onMouseWheelEvent);
  ctx.taskListWheelRegistered = true;
  return null;
}

export function updateTaskUIScrollBarVisibility(ctx: TaskUIScrollContext, pageCount: number, hasQuestRows: boolean): void {
  const visible = hasQuestRows;
  for (const frame of [ctx.scrollBarFrame, ctx.scrollBarHitBtn, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn]) {
    if (frame && frame !== 0) pcallDzFrameShow(frame, visible);
  }
  if (visible) updateTaskUIScrollThumbPosition(ctx, pageCount);
}
