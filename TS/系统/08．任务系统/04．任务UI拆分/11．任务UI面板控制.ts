const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { QuestType } from "../01．任务数据";

/**
 * 任务 UI 面板控制
 *
 * 职责：
 * - 面板显隐
 * - 分类切换
 * - 任务数据变更后的 UI 刷新订阅
 * - 标签提示文字输出
 */
export interface TaskUIPanelContext {
  mainPanel: number | null;
  expandedQuestIds: Set<string>;
  vScrollTrack: { cancelDrag: () => void } | null;
  showFrame: (frame: number) => void;
  hideFrame: (frame: number) => void;
  questManager: { registerUIRefreshCallback: (cb: (playerId: number, questId?: string) => void) => void };
  getCurrentCategory: () => QuestType;
  setCurrentCategory: (type: QuestType) => void;
  getScrollOffset: () => number;
  setScrollOffset: (v: number) => void;
  isVisible: () => boolean;
  setVisible: (v: boolean) => void;
  getCurrentPlayerId: () => number;
  setCurrentPlayerId: (v: number) => void;
}

export function registerTaskUIRefreshCallback(ctx: TaskUIPanelContext, refreshList: () => void): void {
  ctx.questManager.registerUIRefreshCallback((_playerId: number, _questId?: string) => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!ctx.isVisible()) return;
      refreshList();
    });
  });
}

/** 标签 hover 提示直接发给当前 UI 事件玩家，不走同步逻辑。 */
export function showTaskUITabTooltip(msg: string): void {
  if (typeof (japi as any).DzGetTriggerUIEventPlayer !== "function" || typeof (jass as any).DisplayTextToPlayer !== "function") return;
  const p = (japi as any).DzGetTriggerUIEventPlayer();
  if (p) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
}

/** 切分类时顺手清空展开态并回到顶部，保证列表状态可预期。 */
export function switchTaskUICategory(ctx: TaskUIPanelContext, type: QuestType, refreshList: () => void): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    ctx.setCurrentCategory(type);
    ctx.expandedQuestIds.clear();
    ctx.setScrollOffset(0);
    refreshList();
  });
}

/** 只负责切换显隐状态；具体 show/hide 的副作用交给调用方传入。 */
export function toggleTaskUIPanel(
  ctx: TaskUIPanelContext,
  show: (playerId: number) => void,
  hide: () => void
): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    const nextVisible = !ctx.isVisible();
    ctx.setVisible(nextVisible);
    if (nextVisible) show(ctx.getCurrentPlayerId());
    else hide();
  });
}

/** 显示面板时记录当前玩家并立刻刷新列表，确保内容和分类状态同步。 */
export function showTaskUIPanel(ctx: TaskUIPanelContext, playerId: number, refreshList: () => void): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    if (!ctx.mainPanel) return;
    ctx.setCurrentPlayerId(playerId);
    ctx.setVisible(true);
    ctx.showFrame(ctx.mainPanel);
    refreshList();
  });
}

/** 隐藏前先取消可能进行中的 thumb 拖拽，避免下次打开残留交互状态。 */
export function hideTaskUIPanel(ctx: TaskUIPanelContext): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    if (!ctx.mainPanel) return;
    ctx.vScrollTrack?.cancelDrag();
    ctx.setVisible(false);
    ctx.hideFrame(ctx.mainPanel);
  });
}
