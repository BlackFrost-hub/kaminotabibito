const japi = require("jass.japi") as any;

import { QuestData, QuestType } from "../01．任务数据";
import {
  EMPTY_TEXTS,
  getQuestsForUI,
  getStatusText,
  isQuestWithRowIconLayout,
  tryCreateFromFdfOnly,
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
  LIST_CONTAINER_W,
  QUEST_ROW_ICON_PAD_LEFT,
  QUEST_ROW_ICON_Y_OFFSET,
  BG_TEX,
} from "./01．任务UI常量";
import { DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/03．UI函数";


export let currentTaskRowExpandHandler: ((questId: string) => void) | null = null;
export let currentTaskRowClickSound: (() => void) | null = null;
export const taskRowBindingByFrameId: Record<number, { page: TaskUIPageFrames; rowIndex: number } | undefined> = {};

const ROWS_PER_PAGE = 7;
/** 相邻页在任务列表上错开的行数（原 3，改为 1 则每次翻页少滑一行） */
const ROWS_PER_SCROLL_STEP = 1;
const PAGE_VARIANT_COUNT = ROWS_PER_PAGE + 1;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;
const OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35;
const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
const QUEST_ROW_GAP = 0.01;
const VIEW_BOTTOM_REL = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
const VIEW_EPS = 0.002;
const ROOT_LEVEL = 40;
const BACKDROP_LEVEL = 41;
const TEXT_LEVEL = 43;
const BUTTON_LEVEL = 46;
const ICON_LEVEL = 45;

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
  toggleExpand: (questId: string) => void;
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

function questTypes(): QuestType[] {
  return [QuestType.MAIN, QuestType.SIDE, QuestType.DAILY];
}

function createEmptyQuestIdList(): string[] {
  const questIds: string[] = [];
  for (let i = 0; i < ROWS_PER_PAGE; i++) questIds.push("");
  return questIds;
}

function createHiddenRoot(
  ctx: TaskUIListControlContext,
  name: string,
  parent: number,
  width: number = LIST_CONTAINER_W,
  height: number = PAGE_ROOT_HEIGHT
): number | null {
  const frame =
    ctx.createFrame({
      type: "FRAME",
      name,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  if (!frame) return null;
  ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, 0, 0);
  ctx.setFrameSize(frame, { width, height });
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, ROOT_LEVEL);
  return frame;
}

function createHiddenText(
  ctx: TaskUIListControlContext,
  name: string,
  parent: number,
  width: number,
  height: number
): number | null {
  const frame =
    ctx.createTextLabel(
      name,
      parent,
      "",
      {
        relativeTo: parent,
        point: ctx.FramePoint.TOPLEFT,
        relativePoint: ctx.FramePoint.TOPLEFT,
        x: 0,
        y: 0,
      },
      { width, height }
    ) || 0;
  if (!frame) return null;
  setVisible(frame, false);
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, TEXT_LEVEL);
  return frame;
}

function createHiddenBackdrop(
  ctx: TaskUIListControlContext,
  templateName: string,
  frameName: string,
  parent: number,
  texture?: string,
  contextId?: number
): number | null {
  let frame = tryCreateFromFdfOnly(templateName, parent, contextId ?? 0) || 0;
  if (!frame) {
    frame =
      ctx.createFrame({
        type: ctx.FrameType.BACKDROP,
        name: frameName,
        parent,
        template: "template",
        visible: false,
      }) || 0;
    if (frame && texture) {
      ctx.setFrameTexture(frame, texture);
    }
  }
  if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, BACKDROP_LEVEL);
  return frame || null;
}

function createPlainHiddenBackdrop(
  ctx: TaskUIListControlContext,
  name: string,
  parent: number
): number | null {
  const frame =
    ctx.createFrame({
      type: ctx.FrameType.BACKDROP,
      name,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, ICON_LEVEL);
  return frame || null;
}

function createHiddenButton(
  ctx: TaskUIListControlContext,
  name: string,
  parent: number,
  onClick: () => void
): number | null {
  const frame =
    ctx.createFrame({
      type: ctx.FrameType.GLUETEXTBUTTON,
      name,
      parent,
      template: "template",
      visible: false,
      enable: true,
      alpha: 0,
    }) || 0;
  if (!frame) return null;
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, BUTTON_LEVEL);
  ctx.setFrameClickEvent(frame, onClick, false);
  return frame;
}

function hideRowSlot(slot: TaskUIRowSlotFrames): void {
  hideFrames([slot.backdrop, slot.title, slot.clickBtn, slot.icon, slot.failFrame]);
  hideFrames(slot.objectiveFrames);
  hideFrames(slot.detailFrames);
}

function createRowSlot(
  ctx: TaskUIListControlContext,
  parent: number,
  prefix: string,
  rowIndex: number,
  onClick: () => void
): TaskUIRowSlotFrames {
  const objectiveFrames: number[] = [];
  const detailFrames: number[] = [];

  const backdrop = createHiddenBackdrop(
    ctx,
    "TaskButtonBackdrop",
    prefix + "_Backdrop_" + rowIndex,
    parent,
    BG_TEX,
    rowIndex + 1
  );
  const title = createHiddenText(ctx, prefix + "_Title_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, TITLE_HEIGHT);
  const clickBtn = createHiddenButton(ctx, prefix + "_Click_" + rowIndex, parent, onClick);
  const icon = createPlainHiddenBackdrop(ctx, prefix + "_Icon_" + rowIndex, parent);

  if (backdrop && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(backdrop, BACKDROP_LEVEL);
  if (title && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(title, TEXT_LEVEL);
  if (clickBtn && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(clickBtn, BUTTON_LEVEL);
  if (icon && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(icon, ICON_LEVEL);

  for (let i = 0; i < 4; i++) {
    const frame = createHiddenText(ctx, prefix + "_Obj_" + rowIndex + "_" + i, parent, LIST_CONTAINER_W * 0.9, OBJECTIVE_HEIGHT);
    if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, TEXT_LEVEL);
    objectiveFrames.push(frame || 0);
  }

  const failFrame = createHiddenText(ctx, prefix + "_Fail_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, FAIL_HEIGHT);
  if (failFrame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(failFrame, TEXT_LEVEL);

  for (let i = 0; i < 3; i++) {
    const frame = createHiddenText(ctx, prefix + "_Detail_" + rowIndex + "_" + i, parent, LIST_CONTAINER_W * 0.9, DETAIL_HEIGHT);
    if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, TEXT_LEVEL);
    detailFrames.push(frame || 0);
  }

  return {
    backdrop,
    title,
    clickBtn,
    icon,
    objectiveFrames,
    failFrame,
    detailFrames,
  };
}

function createVariant(
  ctx: TaskUIListControlContext,
  page: TaskUIPageFrames,
  category: QuestType,
  pageIndex: number,
  variantIndex: number
): TaskUIPageVariantFrames {
  const root = createHiddenRoot(ctx, "TaskVariant_" + category + "_" + pageIndex + "_" + variantIndex, page.root as number);
  const rowSlots: TaskUIRowSlotFrames[] = [];
  for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
    const slotRowIndex = rowIndex;
    rowSlots.push(
      createRowSlot(
        ctx,
        root as number,
        "TaskVar_" + category + "_" + pageIndex + "_" + variantIndex,
        slotRowIndex,
        handleTaskRowClick
      )
    );
    const clickBtn = rowSlots[rowSlots.length - 1]?.clickBtn;
    if (clickBtn) taskRowBindingByFrameId[clickBtn] = { page, rowIndex: slotRowIndex };
  }
  return { root, rowSlots };
}

export function handleTaskRowClick(): void {
  const frame =
    typeof (japi as any).DzGetTriggerUIEventFrame === "function" ? (japi as any).DzGetTriggerUIEventFrame() : 0;
  if (!frame) return;
  const binding = taskRowBindingByFrameId[frame];
  if (!binding) return;
  const questId = binding.page.questIds[binding.rowIndex];
  if (!questId) return;
  currentTaskRowClickSound?.();
  currentTaskRowExpandHandler?.(questId);
}

function createPage(ctx: TaskUIListControlContext, categoryRoot: number, category: QuestType, pageIndex: number): TaskUIPageFrames {
  const page: TaskUIPageFrames = {
    root: createHiddenRoot(ctx, "TaskPage_" + category + "_" + pageIndex, categoryRoot),
    questIds: createEmptyQuestIdList(),
    variants: [],
  };
  for (let variantIndex = 0; variantIndex < PAGE_VARIANT_COUNT; variantIndex++) {
    page.variants.push(createVariant(ctx, page, category, pageIndex, variantIndex));
  }
  return page;
}

function createCategory(ctx: TaskUIListControlContext, category: QuestType): TaskUICategoryFrames {
  const root = createHiddenRoot(ctx, "TaskCategory_" + category, ctx.listContainer as number);
  const emptyText =
    ctx.createTextLabel(
      "TaskEmpty_" + category,
      root,
      EMPTY_TEXTS[category],
      {
        relativeTo: root,
        point: ctx.FramePoint.TOPLEFT,
        relativePoint: ctx.FramePoint.TOPLEFT,
        x: 0,
        y: -(LIST_VIEW_H * 0.5),
      },
      { width: LIST_CONTAINER_W * 0.85, height: 0.08 }
    ) || 0;
  if (emptyText) {
    ctx.applyDzTextFontAndCenterAlignment(emptyText);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(emptyText, TEXT_LEVEL);
    setVisible(emptyText, false);
  }

  return {
    root,
    emptyText: emptyText || null,
    pageCount: 0,
    pages: [],
  };
}

export function createTaskUIPrecreatedListPool(ctx: TaskUIListControlContext): TaskUIPrecreatedListPool | null {
  if (!ctx.listContainer) return null;
  currentTaskRowExpandHandler = ctx.toggleExpand;
  currentTaskRowClickSound = ctx.playClickSound;

  return {
    categories: {
      [QuestType.MAIN]: createCategory(ctx, QuestType.MAIN),
      [QuestType.SIDE]: createCategory(ctx, QuestType.SIDE),
      [QuestType.DAILY]: createCategory(ctx, QuestType.DAILY),
    },
  };
}

function ensurePage(ctx: TaskUIListControlContext, categoryView: TaskUICategoryFrames, category: QuestType, pageIndex: number): TaskUIPageFrames {
  while (categoryView.pages.length <= pageIndex) {
    categoryView.pages.push(createPage(ctx, categoryView.root as number, category, categoryView.pages.length));
  }
  return categoryView.pages[pageIndex];
}

function clearVariant(variant: TaskUIPageVariantFrames): void {
  for (const slot of variant.rowSlots) hideRowSlot(slot);
}

function clearPage(page: TaskUIPageFrames): void {
  page.questIds = createEmptyQuestIdList();
  for (const variant of page.variants) {
    clearVariant(variant);
    setVisible(variant.root, false);
  }
  setVisible(page.root, false);
}

function buildObjectiveText(quest: QuestData, index: number): string {
  const obj = quest.objectives[index];
  if (!obj) return "";
  const mark = obj.completed ? "|cffffcc00鈭�|r" : "|cffffcc00脳|r";
  return mark + " " + obj.description + " (" + obj.current + "/" + obj.required + ")";
}

function buildRewardText(quest: QuestData): string {
  if (!quest.rewards || quest.rewards.length <= 0) return "";
  const descs: string[] = [];
  for (const r of quest.rewards) {
    if (r.description && r.description !== "") descs.push(r.description);
  }
  if (descs.length === 0) return "";
  let rewardDesc = descs[0];
  for (let i = 1; i < descs.length; i++) rewardDesc += "、" + descs[i];
  return "|cffff9900任务奖励：|r|cffffcc00" + rewardDesc + "|r";
}

function buildInfoText(quest: QuestData): string {
  const accepter = quest.accepterName;
  const completer = quest.completerName;
  if (!accepter && !completer) return "";

  let text = "";
  if (accepter) text += "接受者：|cff00ccff【" + accepter + "】|r";
  if (accepter && completer) text += "|";
  if (completer) text += "完成者：|cff00ff66【" + completer + "】|r";
  return text;
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
  if (slot.backdrop && ctx.setupTransparentGlueHitLayer) {
    ctx.setupTransparentGlueHitLayer(slot.backdrop, slot.clickBtn);
  }
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
  clearVariant(variant);
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
      hideRowSlot(slot);
      continue;
    }

    const expanded = rowIndex === expandedRowIndex;
    const itemH = getQuestItemHeight(quest, expanded);
    const fullyInside = isQuestRowFullyInsideView(rowTopRel, itemH, LIST_CONTENT_TOP_INSET, VIEW_BOTTOM_REL, VIEW_EPS);
    if (fullyInside) {
      renderQuestRowSlot(ctx, slot, quest, rowTopRel, expanded, parent);
    } else {
      hideRowSlot(slot);
    }
    rowTopRel -= itemH + QUEST_ROW_GAP;
  }

  setVisible(variant.root, false);
}

function chunkQuests(quests: QuestData[]): QuestData[][] {
  const pages: QuestData[][] = [];
  if (quests.length <= ROWS_PER_PAGE) {
    if (quests.length > 0) pages.push(quests.slice(0, ROWS_PER_PAGE));
    return pages;
  }

  for (let i = 0; i < quests.length; i += ROWS_PER_SCROLL_STEP) {
    const end = i + ROWS_PER_PAGE;
    if (end >= quests.length) {
      pages.push(quests.slice(Math.max(0, quests.length - ROWS_PER_PAGE), quests.length));
      break;
    }
    pages.push(quests.slice(i, end));
  }
  return pages;
}

export function rebuildTaskUIFacadeListPool(ctx: TaskUIListControlContext): void {
  (pcall as any)(() => {
    if (!ctx.listContainer || !ctx.precreatedListPool) return;

    for (const category of questTypes()) {
      const categoryView = ctx.precreatedListPool.categories[category];
      const quests = getQuestsForUI(ctx.currentPlayerId, category);
      const pages = chunkQuests(quests);

      categoryView.pageCount = pages.length;
      setText(categoryView.emptyText, EMPTY_TEXTS[category]);
      setVisible(categoryView.emptyText, false);

      for (let pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        const page = ensurePage(ctx, categoryView, category, pageIndex);
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
        clearPage(categoryView.pages[pageIndex]);
      }

      setVisible(categoryView.root, false);
    }
  });
}

/** 设置行点击的回调，由管理器在创建池时调用 */
export function setTaskRowHandlers(expand: (questId: string) => void, sound: () => void): void {
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
  (pcall as any)(() => {
    const pool = ctx.precreatedListPool;
    if (!pool) return;

    for (const category of questTypes()) {
      const categoryView = pool.categories[category];
      const isCurrentCategory = category === ctx.currentCategory;
      setVisible(categoryView.root, isCurrentCategory);
      if (!isCurrentCategory) continue;

      const pageCount = categoryView.pageCount;
      if (pageCount <= 0) {
        setVisible(categoryView.emptyText, true);
        for (const page of categoryView.pages) {
          for (const variant of page.variants) {
            setVisible(variant.root, false);
          }
          setVisible(page.root, false);
        }
        ctx.updateScrollBarVisibility(0, false);
        continue;
      }

      setVisible(categoryView.emptyText, false);
      const clampedPage = Math.max(0, Math.min(pageCount - 1, ctx.getCurrentPage(category)));
      const currentPage = categoryView.pages[clampedPage];
      const expandedQuestId = ctx.getExpandedQuestId(category);
      let variantIndex = 0;
      if (expandedQuestId) {
        let rowIndex = -1;
        for (let i = 0; i < currentPage.questIds.length; i++) {
          if (currentPage.questIds[i] === expandedQuestId) {
            rowIndex = i;
            break;
          }
        }
        if (rowIndex >= 0) variantIndex = rowIndex + 1;
      }

      for (let pageIndex = 0; pageIndex < categoryView.pages.length; pageIndex++) {
        const page = categoryView.pages[pageIndex];
        const isCurrentPage = pageIndex === clampedPage;
        setVisible(page.root, isCurrentPage);
        if (!isCurrentPage) continue;
        for (let i = 0; i < page.variants.length; i++) {
          setVisible(page.variants[i].root, i === variantIndex);
        }
      }

      ctx.updateScrollBarVisibility(pageCount, true);
    }
  });
}

export function applyTaskUICategorySwitchVisibleState(ctx: TaskUIListControlContext): void {
  (pcall as any)(() => {
    const pool = ctx.precreatedListPool;
    if (!pool) return;

    for (const category of questTypes()) {
      const categoryView = pool.categories[category];
      const isCurrentCategory = category === ctx.currentCategory;
      setVisible(categoryView.root, isCurrentCategory);

      if (!isCurrentCategory) {
        setVisible(categoryView.emptyText, false);
        for (const page of categoryView.pages) {
          for (const variant of page.variants) {
            setVisible(variant.root, false);
          }
          setVisible(page.root, false);
        }
        continue;
      }

      const pageCount = categoryView.pageCount;
      if (pageCount <= 0) {
        setVisible(categoryView.emptyText, true);
        for (const page of categoryView.pages) {
          for (const variant of page.variants) {
            setVisible(variant.root, false);
          }
          setVisible(page.root, false);
        }
        ctx.updateScrollBarVisibility(0, false);
        continue;
      }

      setVisible(categoryView.emptyText, false);
      for (let pageIndex = 0; pageIndex < categoryView.pages.length; pageIndex++) {
        const page = categoryView.pages[pageIndex];
        const isCurrentPage = pageIndex === 0;
        setVisible(page.root, isCurrentPage);
        for (let variantIndex = 0; variantIndex < page.variants.length; variantIndex++) {
          setVisible(page.variants[variantIndex].root, isCurrentPage && variantIndex === 0);
        }
      }

      ctx.updateScrollBarVisibility(pageCount, true);
    }
  });
}

export function applyTaskUIExpandVisibleState(ctx: TaskUIListControlContext): void {
  (pcall as any)(() => {
    const pool = ctx.precreatedListPool;
    if (!pool) return;

    const categoryView = pool.categories[ctx.currentCategory];
    if (!categoryView) return;

    const pageCount = categoryView.pageCount;
    if (pageCount <= 0) {
      ctx.updateScrollBarVisibility(0, false);
      return;
    }

    const clampedPage = Math.max(0, Math.min(pageCount - 1, ctx.getCurrentPage(ctx.currentCategory)));
    const currentPage = categoryView.pages[clampedPage];
    if (!currentPage) return;

    const expandedQuestId = ctx.getExpandedQuestId(ctx.currentCategory);
    let variantIndex = 0;
    if (expandedQuestId) {
      let rowIndex = -1;
      for (let i = 0; i < currentPage.questIds.length; i++) {
        if (currentPage.questIds[i] === expandedQuestId) {
          rowIndex = i;
          break;
        }
      }
      if (rowIndex >= 0) variantIndex = rowIndex + 1;
    }

    for (let i = 0; i < currentPage.variants.length; i++) {
      setVisible(currentPage.variants[i].root, i === variantIndex);
    }
  });
}

export function applyTaskUIPageSwitchVisibleState(ctx: TaskUIListControlContext): void {
  (pcall as any)(() => {
    const pool = ctx.precreatedListPool;
    if (!pool) return;

    const categoryView = pool.categories[ctx.currentCategory];
    if (!categoryView) return;

    const pageCount = categoryView.pageCount;
    if (pageCount <= 0) {
      setVisible(categoryView.emptyText, true);
      for (const page of categoryView.pages) {
        for (const variant of page.variants) {
          setVisible(variant.root, false);
        }
        setVisible(page.root, false);
      }
      ctx.updateScrollBarVisibility(0, false);
      return;
    }

    setVisible(categoryView.emptyText, false);
    const clampedPage = Math.max(0, Math.min(pageCount - 1, ctx.getCurrentPage(ctx.currentCategory)));
    for (let pageIndex = 0; pageIndex < categoryView.pages.length; pageIndex++) {
      const page = categoryView.pages[pageIndex];
      const isCurrentPage = pageIndex === clampedPage;
      setVisible(page.root, isCurrentPage);
      for (let variantIndex = 0; variantIndex < page.variants.length; variantIndex++) {
        setVisible(page.variants[variantIndex].root, isCurrentPage && variantIndex === 0);
      }
    }

    ctx.updateScrollBarVisibility(pageCount, true);
  });
}
