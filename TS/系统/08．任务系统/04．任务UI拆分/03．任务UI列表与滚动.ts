import { QuestData, QuestType } from "../01．任务数据";
import {
  LIST_ITEM_H,
  LIST_VIEW_H,
  LIST_CONTENT_TOP_INSET,
  LIST_CONTAINER_W,
} from "./01．任务UI常量";
import { EMPTY_TEXTS, getQuestsForUI } from "./02．任务UI辅助";

// ────────────────────────────────────────────────
// 行高与总高度
// ────────────────────────────────────────────────

export function getQuestItemHeight(quest: QuestData, expanded: boolean): number {
  if (!expanded) return LIST_ITEM_H * 0.4;
  let h = LIST_ITEM_H + quest.objectives.length * 0.03 + (quest.timeLimit && quest.timeLimit > 0 ? 0.02 : 0);
  if (quest.description && quest.description !== "") h += 0.025;
  const rewardDesc = quest.rewards && quest.rewards.length > 0
    ? quest.rewards.map(r => r.description).filter(d => d && d !== "").join("、")
    : "";
  if (rewardDesc !== "") h += 0.025;
  if (quest.accepterName || quest.completerName) h += 0.025;
  return h;
}

export function calcTotalContentHeight(
  quests: QuestData[],
  isExpanded: (questId: string) => boolean
): number {
  let totalH = 0;
  for (let i = 0; i < quests.length; i++) {
    const q = quests[i];
    if (!q) continue;
    totalH += getQuestItemHeight(q, isExpanded(q.id)) + 0.01;
  }
  return totalH;
}

export function getMaxScroll(totalContentHeight: number): number {
  return Math.max(0, totalContentHeight - LIST_VIEW_H);
}

export function clampScrollOffset(scrollOffset: number, maxScroll: number): number {
  return Math.min(maxScroll, Math.max(0, scrollOffset));
}

// ────────────────────────────────────────────────
// 可视裁剪
// ────────────────────────────────────────────────

export function isQuestRowFullyInsideView(
  rowTopRel: number,
  itemHeight: number,
  visibleTopRel: number,
  visibleBottomRel: number,
  eps: number
): boolean {
  const itemTopRel = rowTopRel;
  const itemBottomRel = rowTopRel - itemHeight;
  return itemTopRel <= visibleTopRel + eps && itemBottomRel >= visibleBottomRel - eps;
}

// ────────────────────────────────────────────────
// 父链判定
// ────────────────────────────────────────────────

export function isDescendantOf(japi: any, frame: number, ancestor: number): boolean {
  if (!frame || frame === 0 || !ancestor || ancestor === 0) return false;
  let cur: number = frame;
  for (let i = 0; i < 64; i++) {
    if (cur === ancestor) return true;
    const p = typeof (japi as any).DzFrameGetParent === "function" ? (japi as any).DzFrameGetParent(cur) : 0;
    if (!p || p === 0) return false;
    cur = p;
  }
  return false;
}

// ────────────────────────────────────────────────
// 滚轮目标判定
// ────────────────────────────────────────────────

export function isWheelTargetForTaskList(
  japi: any,
  getMouseFocus: (() => number) | undefined,
  listContainer: number | null,
  scrollBarFrame: number | null,
  scrollThumbFrame: number | null,
  scrollThumbHitBtn: number | null
): boolean {
  const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
  if (!f || f === 0) return false;
  if (listContainer && (f === listContainer || isDescendantOf(japi, f, listContainer))) return true;
  if (scrollBarFrame && (f === scrollBarFrame || isDescendantOf(japi, f, scrollBarFrame))) return true;
  if (scrollThumbFrame && (f === scrollThumbFrame || isDescendantOf(japi, f, scrollThumbFrame))) return true;
  if (scrollThumbHitBtn && f === scrollThumbHitBtn) return true;
  return false;
}

// ────────────────────────────────────────────────
// 滚轮滚动计算
// ────────────────────────────────────────────────

export function computeNextScrollOffsetByWheel(
  getWheelDelta: (() => number) | undefined,
  currentOffset: number,
  totalContentHeight: number,
  listViewHeight: number
): number {
  const delta = typeof getWheelDelta === "function" ? getWheelDelta() : 0;
  if (delta === 0) return currentOffset;
  const step = LIST_ITEM_H + 0.01;
  const maxScroll = Math.max(0, totalContentHeight - listViewHeight);
  if (delta > 0) return Math.max(0, currentOffset - step);
  if (delta < 0) return Math.min(maxScroll, currentOffset + step);
  return currentOffset;
}

// ────────────────────────────────────────────────
// 滚动条显隐
// ────────────────────────────────────────────────

/**
 * 滚动条显隐：内容不足一屏时 maxScroll 为 0，但仍应显示轨道与滑块（滑块贴顶/不可用），否则用户以为滚动条坏了。
 * 仅当当前分类下没有任何任务行（空列表占位）时隐藏。
 */
export function updateScrollBarVisibility(
  japi: any,
  maxScroll: number,
  frames: Array<number | null>,
  hasQuestRows: boolean
): void {
  const vis = hasQuestRows;
  if (typeof japi.DzFrameShow !== "function") return;
  for (const f of frames) {
    if (f && f !== 0) (pcall as any)(() => japi.DzFrameShow(f, vis));
  }
}

// ────────────────────────────────────────────────
// 可视行筛选
// ────────────────────────────────────────────────

export interface VisibleQuestRow {
  quest: QuestData;
  expanded: boolean;
  rowTopRel: number;
  itemHeight: number;
}

export function calcVisibleQuestRows(
  quests: QuestData[],
  scrollOffset: number,
  isExpanded: (questId: string) => boolean
): VisibleQuestRow[] {
  const visibleRows: VisibleQuestRow[] = [];
  const visibleTopRel = LIST_CONTENT_TOP_INSET;
  const visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
  const EPS = 0.002;

  let rowTopRel = LIST_CONTENT_TOP_INSET + scrollOffset;
  for (let i = 0; i < quests.length; i++) {
    const q = quests[i];
    if (!q) continue;
    const expanded = isExpanded(q.id);
    const itemHeight = getQuestItemHeight(q, expanded);
    const fullyInside = isQuestRowFullyInsideView(rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, EPS);
    if (fullyInside) {
      visibleRows.push({
        quest: q,
        expanded,
        rowTopRel,
        itemHeight,
      });
    }
    rowTopRel -= itemHeight + 0.01;
  }
  return visibleRows;
}

// ────────────────────────────────────────────────
// 列表刷新
// ────────────────────────────────────────────────

export function refreshTaskUIList(opts: {
  currentPlayerId: number;
  currentCategory: QuestType;
  scrollOffset: number;
  setScrollOffset: (v: number) => void;
  setTotalContentHeight: (v: number) => void;
  listContainer: number;
  expandedQuestIds: Set<string>;
  createTextLabel: any;
  FramePoint: any;
  applyDzTextFontAndCenterAlignment: any;
  pushListItemFrame: (f: number) => void;
  syncScrollThumb: (maxScroll: number) => void;
  updateScrollBarVisibility: (maxScroll: number, hasQuestRows: boolean) => void;
  createListItem: (quest: any, rowTopRel: number, expanded: boolean) => void;
}): void {
  const {
    currentPlayerId,
    currentCategory,
    scrollOffset,
    setScrollOffset,
    setTotalContentHeight,
    listContainer,
    expandedQuestIds,
    createTextLabel,
    FramePoint,
    applyDzTextFontAndCenterAlignment,
    pushListItemFrame,
    syncScrollThumb,
    updateScrollBarVisibility: updateScrollBarVis,
    createListItem,
  } = opts;

  const quests = getQuestsForUI(currentPlayerId, currentCategory);
  if (quests.length === 0) {
    setTotalContentHeight(0);
    setScrollOffset(0);
    const empty = createTextLabel(
      "TaskEmpty",
      listContainer,
      EMPTY_TEXTS[currentCategory],
      {
        relativeTo: listContainer,
        point: FramePoint.CENTER,
        relativePoint: FramePoint.CENTER,
        x: 0,
        y: 0,
      },
      { width: LIST_CONTAINER_W * 0.85, height: 0.08 }
    );
    if (empty) {
      pushListItemFrame(empty);
      applyDzTextFontAndCenterAlignment(empty);
    }
    syncScrollThumb(0);
    updateScrollBarVis(0, false);
    return;
  }

  const totalH = calcTotalContentHeight(quests, (questId: string) => expandedQuestIds.has(questId));
  setTotalContentHeight(totalH);
  const maxScroll = getMaxScroll(totalH);
  const clamped = clampScrollOffset(scrollOffset, maxScroll);
  setScrollOffset(clamped);
  syncScrollThumb(maxScroll);
  updateScrollBarVis(maxScroll, true);

  const visibleRows = calcVisibleQuestRows(quests, clamped, (questId: string) => expandedQuestIds.has(questId));
  for (let i = 0; i < visibleRows.length; i++) {
    const row = visibleRows[i];
    if (!row) continue;
    createListItem(row.quest, row.rowTopRel, row.expanded);
  }
}
