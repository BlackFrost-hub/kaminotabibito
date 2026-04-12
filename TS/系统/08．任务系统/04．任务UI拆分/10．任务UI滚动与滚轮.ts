const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { LIST_VIEW_H, ENABLE_MOUSE_WHEEL_SCROLL } from "./01．任务UI常量";
import {
  isWheelTargetForTaskList as isWheelTargetForTaskListByJapi,
  computeNextScrollOffsetByWheel,
  updateScrollBarVisibility as updateScrollBarVisibilityByJapi,
} from "./03．任务UI列表与滚动";

/**
 * 任务 UI 滚动控制
 *
 * 这里只处理“滚轮/滑块/轨道可见性”这一层，不负责列表内容本身。
 * thumb 的拖拽细节仍由 `VerticalScrollbarTrack` 维护，这里只是与 TaskUI 状态对接。
 */
export interface TaskUIScrollContext {
  mainPanel: number | null;
  listContainer: number | null;
  scrollBarFrame: number | null;
  scrollThumbFrame: number | null;
  scrollThumbHitBtn: number | null;
  taskListWheelTrig: unknown;
  getMouseFocus?: () => number;
  getWheelDelta?: () => number;
  registerMouseWheel: (sync: boolean, cb: () => void) => unknown;
  vScrollTrack: { syncThumbVisual: (maxScroll: number) => void } | null;
  isVisible: () => boolean;
  getScrollOffset: () => number;
  setScrollOffset: (v: number) => void;
  getTotalContentHeight: () => number;
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

/** 根据滚轮增量计算下一帧 scrollOffset，并在值变化时触发列表重绘。 */
export function handleTaskUIListWheel(ctx: TaskUIScrollContext, refreshList: () => void): void {
  const next = computeNextScrollOffsetByWheel(
    ctx.getWheelDelta,
    ctx.getScrollOffset(),
    ctx.getTotalContentHeight(),
    LIST_VIEW_H
  );
  if (next === ctx.getScrollOffset()) return;
  ctx.setScrollOffset(next);
  refreshList();
}

/** 注册一次全局滚轮，再通过焦点父链判断把事件限制在任务列表子树内。 */
export function registerTaskUIListWheel(ctx: TaskUIScrollContext, refreshList: () => void): unknown {
  if (!ENABLE_MOUSE_WHEEL_SCROLL) return ctx.taskListWheelTrig;
  if (ctx.taskListWheelTrig) return ctx.taskListWheelTrig;
  ctx.taskListWheelTrig = ctx.registerMouseWheel(false, () => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!ctx.isVisible()) return;
      if (!isTaskUIWheelTarget(ctx)) return;
      handleTaskUIListWheel(ctx, refreshList);
    });
  });
  return ctx.taskListWheelTrig;
}

/** 只同步视觉 thumb，不参与值计算。 */
export function syncTaskUIScrollThumb(ctx: TaskUIScrollContext, maxScroll: number): void {
  if (!ctx.vScrollTrack) return;
  ctx.vScrollTrack.syncThumbVisual(maxScroll);
}

/** 轨道/滑块显隐规则统一委托给列表滚动辅助模块，避免门面层重复判断。 */
export function updateTaskUIScrollBarVisibility(
  ctx: TaskUIScrollContext,
  maxScroll: number,
  hasQuestRows: boolean
): void {
  updateScrollBarVisibilityByJapi(
    japi,
    maxScroll,
    [ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn],
    hasQuestRows
  );
}
