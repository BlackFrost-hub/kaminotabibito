const japi = require("jass.japi") as any;

import { ENABLE_MOUSE_WHEEL_SCROLL } from "./01．任务UI常量";
import { isWheelTargetForTaskList as isWheelTargetForTaskListByJapi } from "./03．任务UI列表与滚动";
import {
  LIST_VIEW_H,
  SCROLLBAR_W,
  SCROLL_THUMB_SIZE,
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
} from "./01．任务UI常量";

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
  registerMouseWheel: (sync: boolean, cb: () => void) => unknown;
  isVisible: () => boolean;
  getCurrentPageCount: () => number;
  getCurrentPage: () => number;
  setCurrentPage: (page: number) => void;
  onPageChanged: () => void;
}

function handleMouseWheelEvent(ctx: TaskUIScrollContext): void {
  (pcall as any)(() => {
    if (!ctx.isVisible()) return;
    if (
      !isWheelTargetForTaskListByJapi(
        japi,
        ctx.getMouseFocus,
        ctx.listContainer,
        ctx.scrollBarFrame,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
      )
    )
      return;
    handleTaskUIListWheel(ctx);
  });
}

function updateTaskUIScrollThumbPosition(ctx: TaskUIScrollContext, pageCount: number): void {
  if (!ctx.scrollBarFrame || !ctx.scrollThumbFrame) return;

  const centeredX = (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5;
  let travelRange = LIST_VIEW_H - SCROLL_THUMB_SIZE - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_BOTTOM_COMPENSATION;
  if (travelRange < 0) travelRange = 0;

  let topOffset = SCROLL_THUMB_TOP_COMPENSATION;
  if (pageCount > 1) {
    const currentPage = Math.max(0, Math.min(pageCount - 1, ctx.getCurrentPage()));
    const ratio = currentPage / (pageCount - 1);
    topOffset += travelRange * ratio;
  }

  ctx.setFramePointRelative(
    ctx.scrollThumbFrame,
    ctx.FramePoint.TOPLEFT,
    ctx.scrollBarFrame,
    ctx.FramePoint.TOPLEFT,
    centeredX,
    -topOffset
  );
}

export function isTaskUIWheelTarget(ctx: TaskUIScrollContext): boolean {
  if (!ctx.mainPanel) return false;
  return isWheelTargetForTaskListByJapi(
    japi,
    ctx.getMouseFocus,
    ctx.listContainer,
    ctx.scrollBarFrame,
    ctx.scrollThumbFrame,
    ctx.scrollThumbHitBtn
  );
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
  ctx.onPageChanged();
  updateTaskUIScrollThumbPosition(ctx, pageCount);
}

export function registerTaskUIListWheel(ctx: TaskUIScrollContext): unknown {
  if (!ENABLE_MOUSE_WHEEL_SCROLL) return ctx.taskListWheelTrig;
  if (ctx.taskListWheelTrig) return ctx.taskListWheelTrig;
  ctx.taskListWheelTrig = ctx.registerMouseWheel(false, () => handleMouseWheelEvent(ctx));
  return ctx.taskListWheelTrig;
}

export function updateTaskUIScrollBarVisibility(
  ctx: TaskUIScrollContext,
  pageCount: number,
  hasQuestRows: boolean
): void {
  const visible = hasQuestRows;
  if (typeof japi.DzFrameShow !== "function") return;
  for (const frame of [ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn]) {
    if (frame && frame !== 0) (pcall as any)(() => japi.DzFrameShow(frame, visible));
  }
  if (visible) updateTaskUIScrollThumbPosition(ctx, pageCount);
}
