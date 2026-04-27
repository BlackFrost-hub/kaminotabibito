const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { clampRange } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  clampRange: (value: number, minValue: number, maxValue: number) => number;
};

import { QuestData, QuestType } from "../01．任务数据";
import {
  EMPTY_TEXTS,
  getQuestsForUI,
  getStatusText,
  isQuestWithRowIconLayout,
} from "./02．任务UI辅助";
import {
  getQuestItemHeight,
  isQuestRowFullyInsideView,
} from "./03．任务UI列表与滚动";
import { calcTaskListItemLayout, resolveQuestRowIconPath } from "./04．任务UI渲染";
import {
  LIST_ITEM_H,
  LIST_VIEW_H,
  LIST_CONTENT_TOP_INSET,
  QUEST_ROW_ICON_PAD_LEFT,
  QUEST_ROW_ICON_Y_OFFSET,
} from "./01．任务UI常量";
import { DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/03．UI函数";
import {
  ROWS_PER_PAGE,
  questTypes,
  createEmptyQuestIdList,
  buildObjectiveText,
  buildRewardText,
  buildInfoText,
  chunkQuests,
  findExpandedVariantIndex,
  hideAllCategoryPages,
  showOnlyPageAndVariant,
} from "./11．任务UI列表控制辅助";
import {
  clearVariant,
  clearPage,
  hideRowSlot,
} from "./17．任务UI列表帧构建";


export let currentTaskRowExpandHandler: ((this: void, rowIndex: number) => void) | null = null;
export let currentTaskRowClickSound: ((this: void) => void) | null = null;
export const taskRowBindingByFrameId: Record<number, { page: TaskUIPageFrames; rowIndex: number } | undefined> = {};

/** `pcall` 单次槽位：任务 UI 列表控制内不会嵌套这些导出 */
let pcallTaskUIListCtx: TaskUIListControlContext | null = null;

function findTaskRowBindingFrame(frame: number): number {
  let cur = frame;
  for (let i = 0; i < 16; i++) {
    if (!cur || cur === 0) return 0;
    if (taskRowBindingByFrameId[cur] !== undefined) return cur;
    if (typeof (japi as any).DzFrameGetParent !== "function") return 0;
    cur = (japi as any).DzFrameGetParent(cur);
  }
  return 0;
}

function pcallRebuildTaskUIFacadeListPoolBody(): void {
  const ctx = pcallTaskUIListCtx!;
  if (!ctx.listContainer || !ctx.precreatedListPool) return;

  for (const category of questTypes()) {
    const categoryView = ctx.precreatedListPool.categories[category];
    const quests = getQuestsForUI(ctx.currentPlayerId, category);
    const pages = chunkQuests(quests);
    const renderedPageCount = pages.length < categoryView.pages.length ? pages.length : categoryView.pages.length;

    categoryView.pageCount = renderedPageCount;
    setText(categoryView.emptyText, EMPTY_TEXTS[category]);
    setVisible(categoryView.emptyText, false);

    for (let pageIndex = 0; pageIndex < renderedPageCount; pageIndex++) {
      const page = categoryView.pages[pageIndex];
      const pageQuests = pages[pageIndex] || [];
      page.questIds = createEmptyQuestIdList();
      for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
        const quest = pageQuests[rowIndex];
        if (quest !== undefined) page.questIds[rowIndex] = quest.id;
      }
      for (let variantIndex = 0; variantIndex < page.variants.length; variantIndex++) {
        renderVariant(ctx, page.variants[variantIndex], pageQuests, variantIndex - 1);
        setVisible(page.variants[variantIndex].root, false);
      }
      setVisible(page.root, false);
    }

    for (let pageIndex = pages.length; pageIndex < categoryView.pages.length; pageIndex++) {
      clearPage(categoryView.pages[pageIndex], setVisible);
    }

    setVisible(categoryView.root, false);
  }
}

function pcallApplyTaskUIFacadeVisibleStateBody(): void {
  const ctx = pcallTaskUIListCtx!;
  const pool = ctx.precreatedListPool;
  if (!pool) return;

  for (const category of questTypes()) {
    const categoryView = pool.categories[category];
    const isCurrentCategory = category === ctx.currentCategory;
    setVisible(categoryView.root, isCurrentCategory);
    if (!isCurrentCategory) continue;

    const pageCount = categoryView.pageCount;
    if (pageCount <= 0) {
      hideAllCategoryPages(categoryView, setVisible);
      setVisible(categoryView.emptyText, true);
      ctx.updateScrollBarVisibility(0, false);
      continue;
    }

    setVisible(categoryView.emptyText, false);
    const clampedPage = clampRange(ctx.getCurrentPage(category), 0, pageCount - 1);
    const currentPage = categoryView.pages[clampedPage];
    const expandedQuestId = ctx.getExpandedQuestId(category);
    const variantIndex = findExpandedVariantIndex(currentPage, expandedQuestId);
    showOnlyPageAndVariant(categoryView, clampedPage, variantIndex, setVisible);

    ctx.updateScrollBarVisibility(pageCount, true);
  }
}

function pcallApplyTaskUICategorySwitchVisibleStateBody(): void {
  const ctx = pcallTaskUIListCtx!;
  const pool = ctx.precreatedListPool;
  if (!pool) return;

  for (const category of questTypes()) {
    const categoryView = pool.categories[category];
    const isCurrentCategory = category === ctx.currentCategory;
    setVisible(categoryView.root, isCurrentCategory);

    if (!isCurrentCategory) {
      hideAllCategoryPages(categoryView, setVisible);
      continue;
    }

    const pageCount = categoryView.pageCount;
    if (pageCount <= 0) {
      hideAllCategoryPages(categoryView, setVisible);
      setVisible(categoryView.emptyText, true);
      ctx.updateScrollBarVisibility(0, false);
      continue;
    }

    setVisible(categoryView.emptyText, false);
    showOnlyPageAndVariant(categoryView, 0, 0, setVisible);

    ctx.updateScrollBarVisibility(pageCount, true);
  }
}

function pcallApplyTaskUIExpandVisibleStateBody(): void {
  const ctx = pcallTaskUIListCtx!;
  const pool = ctx.precreatedListPool;
  if (!pool) return;

  const categoryView = pool.categories[ctx.currentCategory];
  if (!categoryView) return;

  const pageCount = categoryView.pageCount;
  if (pageCount <= 0) {
    ctx.updateScrollBarVisibility(0, false);
    return;
  }

  const clampedPage = clampRange(ctx.getCurrentPage(ctx.currentCategory), 0, pageCount - 1);
  const currentPage = categoryView.pages[clampedPage];
  if (!currentPage) return;

  const expandedQuestId = ctx.getExpandedQuestId(ctx.currentCategory);
  const variantIndex = findExpandedVariantIndex(currentPage, expandedQuestId);

  for (let i = 0; i < currentPage.variants.length; i++) {
    setVisible(currentPage.variants[i].root, i === variantIndex);
  }
}

function pcallApplyTaskUIPageSwitchVisibleStateBody(): void {
  const ctx = pcallTaskUIListCtx!;
  const pool = ctx.precreatedListPool;
  if (!pool) return;

  const categoryView = pool.categories[ctx.currentCategory];
  if (!categoryView) return;

  const pageCount = categoryView.pageCount;
  if (pageCount <= 0) {
    hideAllCategoryPages(categoryView, setVisible);
    setVisible(categoryView.emptyText, true);
    ctx.updateScrollBarVisibility(0, false);
    return;
  }

  setVisible(categoryView.emptyText, false);
  const clampedPage = clampRange(ctx.getCurrentPage(ctx.currentCategory), 0, pageCount - 1);
  showOnlyPageAndVariant(categoryView, clampedPage, 0, setVisible);

  ctx.updateScrollBarVisibility(pageCount, true);
}

const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35;
const QUEST_ROW_GAP = 0.01;
const VIEW_BOTTOM_REL = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
const VIEW_EPS = 0.002;

export interface TaskUIRowSlotFrames {
  backdrop: number | null;
  title: number | null;
  clickBtn: number | null;
  icon: number | null;
  objectiveFrames: number[];
  failFrame: number | null;
  detailFrames: number[];
}

export interface TaskUIPageVariantFrames {
  root: number | null;
  rowSlots: TaskUIRowSlotFrames[];
}

export interface TaskUIPageFrames {
  root: number | null;
  questIds: string[];
  variants: TaskUIPageVariantFrames[];
}

export interface TaskUICategoryFrames {
  root: number | null;
  emptyText: number | null;
  pageCount: number;
  pages: TaskUIPageFrames[];
}

export interface TaskUIPrecreatedListPool {
  categories: Record<QuestType, TaskUICategoryFrames>;
}

export interface TaskUIListControlContext {
  mainPanel: number | null;
  listContainer: number | null;
  currentPlayerId: number;
  currentCategory: QuestType;
  precreatedListPool: TaskUIPrecreatedListPool | null;
  contextId: number;
  createTextLabel: any;
  FramePoint: any;
  FrameType: any;
  createFrame: any;
  setFrameTexture: any;
  setFramePointRelative: any;
  setFrameSize: any;
  setFrameClickEvent: any;
  setupTransparentGlueHitLayer?: any;
  showFrame: any;
  hideFrame: any;
  applyDzTextFontAndCenterAlignment: any;
  applyDzTextFontAndAlignment: any;
  playClickSound: () => void;
  updateScrollBarVisibility: (pageCount: number, hasQuestRows: boolean) => void;
  toggleExpand: (rowIndex: number) => void;
  getCurrentPage: (type: QuestType) => number;
  setCurrentPage: (type: QuestType, page: number) => void;
  getExpandedQuestId: (type: QuestType) => string | null;
}

function setText(frame: number | null, text: string): void {
  if (!frame || frame === 0) return;
  if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(frame, text);
}

export function setVisible(frame: number | null, visible: boolean): void {
  if (!frame || frame === 0) return;
  if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(frame, visible);
}

function hideFrames(frames: Array<number | null>): void {
  for (const frame of frames) setVisible(frame, false);
}

export function handleTaskRowClick(): void {
  let frame =
    typeof (japi as any).DzGetTriggerUIEventFrame === "function" ? (japi as any).DzGetTriggerUIEventFrame() : 0;
  if (!frame && typeof (japi as any).DzGetMouseFocus === "function") {
    frame = (japi as any).DzGetMouseFocus();
  }
  const bindingFrame = findTaskRowBindingFrame(frame);
  if (!bindingFrame) return;
  const binding = taskRowBindingByFrameId[bindingFrame];
  if (!binding) return;
  const questId = binding.page.questIds[binding.rowIndex];
  if (!questId) return;
  currentTaskRowExpandHandler?.(binding.rowIndex);
  const triggerPlayer = typeof (japi as any).DzGetTriggerKeyPlayer === "function"
    ? (japi as any).DzGetTriggerKeyPlayer() : jass.GetLocalPlayer();
  if (triggerPlayer === jass.GetLocalPlayer()) {
    currentTaskRowClickSound?.();
  }
}

function handleTaskRowClickByRowIndex(rowIndex: number): void {
  currentTaskRowExpandHandler?.(rowIndex);
  const triggerPlayer = typeof (japi as any).DzGetTriggerKeyPlayer === "function"
    ? (japi as any).DzGetTriggerKeyPlayer() : jass.GetLocalPlayer();
  if (triggerPlayer === jass.GetLocalPlayer()) {
    currentTaskRowClickSound?.();
  }
}

export function handleTaskRowClickRow0(): void { handleTaskRowClickByRowIndex(0); }
export function handleTaskRowClickRow1(): void { handleTaskRowClickByRowIndex(1); }
export function handleTaskRowClickRow2(): void { handleTaskRowClickByRowIndex(2); }
export function handleTaskRowClickRow3(): void { handleTaskRowClickByRowIndex(3); }
export function handleTaskRowClickRow4(): void { handleTaskRowClickByRowIndex(4); }
export function handleTaskRowClickRow5(): void { handleTaskRowClickByRowIndex(5); }
export function handleTaskRowClickRow6(): void { handleTaskRowClickByRowIndex(6); }

export const taskRowClickHandlersByIndex: Array<() => void> = [
  handleTaskRowClickRow0,
  handleTaskRowClickRow1,
  handleTaskRowClickRow2,
  handleTaskRowClickRow3,
  handleTaskRowClickRow4,
  handleTaskRowClickRow5,
  handleTaskRowClickRow6,
];

/** 行按钮在 `ensurePage` 之后绑定，避免 `createHiddenButton` 注册期携带工厂闭包 */
export function bindTaskRowClickButtonsForPage(page: TaskUIPageFrames): void {
  for (let vi = 0; vi < page.variants.length; vi++) {
    const variant = page.variants[vi];
    for (let ri = 0; ri < variant.rowSlots.length; ri++) {
      const btn = variant.rowSlots[ri]?.clickBtn ?? null;
      if (btn) {
        taskRowBindingByFrameId[btn] = { page, rowIndex: ri };
      }
    }
  }
}

function renderQuestRowSlot(
  ctx: TaskUIListControlContext,
  slot: TaskUIRowSlotFrames,
  quest: QuestData,
  rowTopRel: number,
  expanded: boolean,
  parent: number
): void {
  const itemH = getQuestItemHeight(quest, expanded);
  const statusText = getStatusText(quest.status);
  const showIcon = isQuestWithRowIconLayout(quest);
  const { rowWidth, rowLeftRel, iconHLayout, textXRel, listTextAlign, textW } = calcTaskListItemLayout(showIcon);
  const titleText = "|cffffff00【" + quest.title + "】|r→发布NPC:|cff00ccff【" + (quest.startNpc || "未知") + "】|r [" + statusText + "]";

  ctx.setFramePointRelative(slot.backdrop, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
  ctx.setFrameSize(slot.backdrop, { width: rowWidth, height: itemH });
  setVisible(slot.backdrop, true);

  ctx.setFramePointRelative(slot.title, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, textXRel, rowTopRel - 0.005);
  ctx.setFrameSize(slot.title, { width: textW, height: TITLE_HEIGHT });
  setText(slot.title, titleText);
  ctx.applyDzTextFontAndAlignment(slot.title, listTextAlign);
  setVisible(slot.title, true);

  ctx.setFramePointRelative(slot.clickBtn, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
  ctx.setFrameSize(slot.clickBtn, { width: rowWidth, height: itemH });
  setVisible(slot.clickBtn, true);

  if (showIcon) {
    ctx.setFramePointRelative(
      slot.icon,
      ctx.FramePoint.TOPLEFT,
      parent,
      ctx.FramePoint.TOPLEFT,
      rowLeftRel + QUEST_ROW_ICON_PAD_LEFT,
      rowTopRel - QUEST_ROW_ICON_Y_OFFSET
    );
    ctx.setFrameSize(slot.icon, { width: iconHLayout, height: iconHLayout });
    ctx.setFrameTexture(slot.icon, resolveQuestRowIconPath(quest.icon));
    setVisible(slot.icon, true);
  } else {
    setVisible(slot.icon, false);
  }

  hideFrames(slot.objectiveFrames);
  setVisible(slot.failFrame, false);
  hideFrames(slot.detailFrames);

  if (!expanded) return;

  let y = rowTopRel - OBJECTIVE_START_OFFSET;
  for (let i = 0; i < slot.objectiveFrames.length; i++) {
    const frame = slot.objectiveFrames[i] || 0;
    const text = buildObjectiveText(quest, i);
    if (!frame || text === "") continue;
    ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, textXRel, y);
    ctx.setFrameSize(frame, { width: textW, height: OBJECTIVE_HEIGHT });
    setText(frame, text);
    ctx.applyDzTextFontAndAlignment(frame, listTextAlign);
    setVisible(frame, true);
    y -= OBJECTIVE_HEIGHT;
  }

  if (quest.timeLimit && quest.timeLimit > 0 && slot.failFrame) {
    ctx.setFramePointRelative(slot.failFrame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, textXRel, y);
    ctx.setFrameSize(slot.failFrame, { width: textW, height: FAIL_HEIGHT });
    setText(slot.failFrame, "|cffff4444失败:|r 时间限制 " + quest.timeLimit + "秒");
    ctx.applyDzTextFontAndAlignment(slot.failFrame, listTextAlign);
    setVisible(slot.failFrame, true);
    y -= FAIL_HEIGHT;
  }

  const details = [
    quest.description && quest.description !== "" ? "|cffcccccc任务详情：|r" + quest.description : "",
    buildRewardText(quest),
    buildInfoText(quest),
  ];

  for (let i = 0; i < slot.detailFrames.length; i++) {
    const frame = slot.detailFrames[i] || 0;
    const text = details[i] || "";
    if (!frame || text === "") continue;
    ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, textXRel, y);
    ctx.setFrameSize(frame, { width: textW, height: DETAIL_HEIGHT });
    setText(frame, text);
    ctx.applyDzTextFontAndAlignment(frame, DZ_TEXT_ALIGN_LEFT);
    setVisible(frame, true);
    y -= DETAIL_HEIGHT;
  }
}

function renderVariant(
  ctx: TaskUIListControlContext,
  variant: TaskUIPageVariantFrames,
  pageQuests: QuestData[],
  expandedRowIndex: number
): void {
  clearVariant(variant, setVisible);
  const parent = variant.root as number;

  let rowTopRel = LIST_CONTENT_TOP_INSET;
  if (expandedRowIndex >= 0) {
    let probeTopRel = LIST_CONTENT_TOP_INSET;
    for (let rowIndex = 0; rowIndex <= expandedRowIndex; rowIndex++) {
      const quest = pageQuests[rowIndex];
      if (!quest) break;
      const expanded = rowIndex === expandedRowIndex;
      const itemH = getQuestItemHeight(quest, expanded);
      if (expanded) {
        const itemBottomRel = probeTopRel - itemH;
        if (itemBottomRel < VIEW_BOTTOM_REL) {
          rowTopRel += VIEW_BOTTOM_REL - itemBottomRel;
        }
        break;
      }
      probeTopRel -= itemH + QUEST_ROW_GAP;
    }
  }

  for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
    const quest = pageQuests[rowIndex];
    const slot = variant.rowSlots[rowIndex];
    if (!quest) {
      hideRowSlot(slot, setVisible);
      continue;
    }

    const expanded = rowIndex === expandedRowIndex;
    const itemH = getQuestItemHeight(quest, expanded);
    const fullyInside = isQuestRowFullyInsideView(rowTopRel, itemH, LIST_CONTENT_TOP_INSET, VIEW_BOTTOM_REL, VIEW_EPS);
    if (fullyInside) {
      renderQuestRowSlot(ctx, slot, quest, rowTopRel, expanded, parent);
    } else {
      hideRowSlot(slot, setVisible);
    }
    rowTopRel -= itemH + QUEST_ROW_GAP;
  }

  setVisible(variant.root, false);
}

export function rebuildTaskUIFacadeListPool(ctx: TaskUIListControlContext): void {
  pcallTaskUIListCtx = ctx;
  pcall(pcallRebuildTaskUIFacadeListPoolBody);
  pcallTaskUIListCtx = null;
}

/** 设置行点击的回调，由管理器在创建池时调用 */
export function setTaskRowHandlers(
  expand: (this: void, rowIndex: number) => void,
  sound: (this: void) => void
): void {
  currentTaskRowExpandHandler = expand;
  currentTaskRowClickSound = sound;
}

export function getTaskUICategoryPageCount(
  pool: TaskUIPrecreatedListPool | null,
  category: QuestType
): number {
  if (!pool) return 0;
  return pool.categories[category]?.pageCount ?? 0;
}

export function applyTaskUIFacadeVisibleState(ctx: TaskUIListControlContext): void {
  pcallTaskUIListCtx = ctx;
  pcall(pcallApplyTaskUIFacadeVisibleStateBody);
  pcallTaskUIListCtx = null;
}

export function applyTaskUICategorySwitchVisibleState(ctx: TaskUIListControlContext): void {
  pcallTaskUIListCtx = ctx;
  pcall(pcallApplyTaskUICategorySwitchVisibleStateBody);
  pcallTaskUIListCtx = null;
}

export function applyTaskUIExpandVisibleState(ctx: TaskUIListControlContext): void {
  pcallTaskUIListCtx = ctx;
  pcall(pcallApplyTaskUIExpandVisibleStateBody);
  pcallTaskUIListCtx = null;
}

export function applyTaskUIPageSwitchVisibleState(ctx: TaskUIListControlContext): void {
  pcallTaskUIListCtx = ctx;
  pcall(pcallApplyTaskUIPageSwitchVisibleStateBody);
  pcallTaskUIListCtx = null;
}
