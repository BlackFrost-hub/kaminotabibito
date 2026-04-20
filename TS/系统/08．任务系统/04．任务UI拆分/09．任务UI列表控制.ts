const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { QuestData, QuestType } from "../01．任务数据";
import { refreshTaskUIList } from "./03．任务UI列表与滚动";
import { renderQuestRow } from "./04．任务UI渲染";
import { SoundUI_ClickPlay } from "../../../lib/扩展函数/封装函数/02．音效系统/index";

/**
 * 任务 UI 列表控制
 *
 * 职责：
 * - 清空并隐藏当前已创建的任务行相关帧
 * - 调用列表模块计算可见行并触发行渲染
 * - 处理“展开/折叠任务详情”这类列表内部状态切换
 */
export interface TaskUIListControlContext {
  mainPanel: number | null;
  listContainer: number | null;
  currentPlayerId: number;
  currentCategory: QuestType;
  expandedQuestIds: Set<string>;
  listItemFrames: number[];
  rowBackdropByQuestId: Map<string, number>;
  titleByQuestId: Map<string, number>;
  clickBtnByQuestId: Map<string, number>;
  objFrameByKey: Map<string, number>;
  failFrameByQuestId: Map<string, number>;
  rowIconByQuestId: Map<string, number>;
  createTextLabel: any;
  FramePoint: any;
  FrameType: any;
  createFrame: any;
  setFrameTexture: any;
  setFramePointRelative: any;
  setFrameSize: any;
  setFrameClickEvent: any;
  showFrame: any;
  applyDzTextFontAndCenterAlignment: any;
  applyDzTextFontAndAlignment: any;
  syncScrollThumb: (maxScroll: number) => void;
  updateScrollBarVisibility: (maxScroll: number, hasQuestRows: boolean) => void;
  toggleExpand: (questId: string) => void;
  getScrollOffset: () => number;
  setScrollOffset: (v: number) => void;
  getTotalContentHeight: () => number;
  setTotalContentHeight: (v: number) => void;
}

export function clearTaskUIList(ctx: TaskUIListControlContext): void {
  for (const f of ctx.listItemFrames) {
    if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(f, false);
  }
  if (typeof (japi as any).DzFrameShow === "function") {
    for (const f of ctx.rowBackdropByQuestId.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
    for (const f of ctx.titleByQuestId.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
    for (const f of ctx.clickBtnByQuestId.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
    for (const f of ctx.objFrameByKey.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
    for (const f of ctx.failFrameByQuestId.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
    for (const f of ctx.rowIconByQuestId.values()) {
      if (f !== 0) (japi as any).DzFrameShow(f, false);
    }
  }
  ctx.listItemFrames.length = 0;
}

/** 只切换展开状态；真正的重排与滚动同步仍交给 `refreshList`。 */
export function toggleTaskUIQuestExpand(ctx: TaskUIListControlContext, questId: string, refreshList: () => void): void {
  (pcall as any)(() => {
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    if (ctx.expandedQuestIds.has(questId)) {
      ctx.expandedQuestIds.delete(questId);
    } else {
      ctx.expandedQuestIds.add(questId);
    }
    refreshList();
  });
}

/** 渲染单行任务，行内点击/展开回调统一回到门面层的 `refreshList`。 */
export function createTaskUIListItem(
  ctx: TaskUIListControlContext,
  quest: QuestData,
  rowTopRel: number,
  expanded: boolean,
  refreshList: () => void
): number | null {
  const listParent = ctx.listContainer;
  if (!ctx.mainPanel || !listParent) return null;
  const ok = renderQuestRow({
    japi,
    quest,
    rowTopRel,
    expanded,
    listParent,
    FrameType: ctx.FrameType,
    FramePoint: ctx.FramePoint,
    createFrame: ctx.createFrame,
    createTextLabel: ctx.createTextLabel,
    setFrameTexture: ctx.setFrameTexture,
    setFramePointRelative: ctx.setFramePointRelative,
    setFrameSize: ctx.setFrameSize,
    setFrameClickEvent: ctx.setFrameClickEvent,
    showFrame: ctx.showFrame,
    applyDzTextFontAndAlignment: ctx.applyDzTextFontAndAlignment,
    onToggleExpand: (questId: string) => toggleTaskUIQuestExpand(ctx, questId, refreshList),
    onClickSound: () => SoundUI_ClickPlay(),
    rowBackdropByQuestId: ctx.rowBackdropByQuestId,
    titleByQuestId: ctx.titleByQuestId,
    clickBtnByQuestId: ctx.clickBtnByQuestId,
    objFrameByKey: ctx.objFrameByKey,
    failFrameByQuestId: ctx.failFrameByQuestId,
    rowIconByQuestId: ctx.rowIconByQuestId,
    listItemFrames: ctx.listItemFrames,
  });
  if (!ok) return null;
  return 0;
}

/** 门面层的列表刷新入口：先清旧帧，再把数据和回调委托给列表模块。 */
export function refreshTaskUIFacadeList(ctx: TaskUIListControlContext, refreshList: () => void): void {
  (pcall as any)(() => {
    const lp = jass.GetLocalPlayer();
    if (lp == null) return;

    if (!ctx.mainPanel || !ctx.listContainer) return;
    clearTaskUIList(ctx);
    refreshTaskUIList({
      currentPlayerId: ctx.currentPlayerId,
      currentCategory: ctx.currentCategory,
      scrollOffset: ctx.getScrollOffset(),
      setScrollOffset: (v: number) => {
        ctx.setScrollOffset(v);
      },
      setTotalContentHeight: (v: number) => {
        ctx.setTotalContentHeight(v);
      },
      listContainer: ctx.listContainer,
      expandedQuestIds: ctx.expandedQuestIds,
      createTextLabel: ctx.createTextLabel,
      FramePoint: ctx.FramePoint,
      applyDzTextFontAndCenterAlignment: ctx.applyDzTextFontAndCenterAlignment,
      pushListItemFrame: (f: number) => ctx.listItemFrames.push(f),
      syncScrollThumb: (maxScroll: number) => ctx.syncScrollThumb(maxScroll),
      updateScrollBarVisibility: (maxScroll: number, hasQuestRows: boolean) =>
        ctx.updateScrollBarVisibility(maxScroll, hasQuestRows),
      createListItem: (quest: QuestData, rowTopRel: number, expanded: boolean) =>
        createTaskUIListItem(ctx, quest, rowTopRel, expanded, refreshList),
    });
  });
}
