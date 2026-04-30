import { QuestType } from "../01．任务数据";
import {
  TaskUIListControlContext,
  TaskUICategoryFrames,
  TaskUIPageFrames,
  TaskUIPageVariantFrames,
  TaskUIRowSlotFrames,
  TaskUIPrecreatedListPool,
  taskRowClickHandlersByIndex,
  taskRowBindingByFrameId,
} from "./09．任务UI列表控制";
import {
  LIST_VIEW_H,
  LIST_CONTAINER_W,
  MAX_PAGES_PER_CATEGORY,
  BG_TEX,
} from "./01．任务UI常量";
import {
  createHiddenRoot,
  createHiddenText,
  createHiddenBackdrop,
  createPlainHiddenBackdrop,
  createHiddenButton,
} from "./17．任务UI列表帧构建";
import {
  ROWS_PER_PAGE,
  PAGE_VARIANT_COUNT,
  createEmptyQuestIdList,
} from "./11．任务UI列表控制辅助";

const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
const LIST_ITEM_H = LIST_VIEW_H * 0.14;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;

function createRowSlot(ctx: TaskUIListControlContext, parent: number, prefix: string, rowIndex: number, onClick: () => void): TaskUIRowSlotFrames {
  const objectiveFrames: number[] = [];
  const detailFrames: number[] = [];
  const backdrop = createHiddenBackdrop(ctx, "TaskButtonBackdrop", prefix + "_Backdrop_" + rowIndex, parent, BG_TEX, rowIndex + 1) || 0;
  const icon = createPlainHiddenBackdrop(ctx, prefix + "_Icon_" + rowIndex, parent) || 0;
  const title = createHiddenText(ctx, prefix + "_Title_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, TITLE_HEIGHT) || 0;
  const clickBtn = createHiddenButton(ctx, prefix + "_Click_" + rowIndex, parent, onClick) || 0;
  for (let i = 0; i < 4; i++) {
    objectiveFrames.push(createHiddenText(ctx, prefix + "_Obj" + i, parent, LIST_CONTAINER_W * 0.9, OBJECTIVE_HEIGHT) || 0);
  }
  const failFrame = createHiddenText(ctx, prefix + "_Fail_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, FAIL_HEIGHT) || 0;
  for (let i = 0; i < 6; i++) {
    detailFrames.push(createHiddenText(ctx, prefix + "_Det" + i, parent, LIST_CONTAINER_W * 0.9, DETAIL_HEIGHT) || 0);
  }
  return { backdrop, title, clickBtn, icon, objectiveFrames, failFrame, detailFrames };
}

function createVariant(ctx: TaskUIListControlContext, page: TaskUIPageFrames, category: QuestType, pageIndex: number, variantIndex: number): TaskUIPageVariantFrames {
  const root = createHiddenRoot(ctx, "TaskVariant_" + category + "_" + pageIndex + "_" + variantIndex, page.root as number, LIST_CONTAINER_W, PAGE_ROOT_HEIGHT);
  const rowSlots: TaskUIRowSlotFrames[] = [];
  const prefix = "TV" + category + "_" + pageIndex + "_" + variantIndex;
  for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
    const slot = createRowSlot(ctx, root as number, prefix + "_R" + rowIndex, rowIndex, taskRowClickHandlersByIndex[rowIndex]!);
    if (slot.clickBtn) taskRowBindingByFrameId[slot.clickBtn] = { page, rowIndex };
    rowSlots.push(slot);
  }
  return { root, rowSlots };
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
  const emptyText = createHiddenText(ctx, "TaskEmpty_" + category, root as number, LIST_CONTAINER_W * 0.85, 0.08) || 0;
  if (emptyText !== 0) {
    ctx.applyDzTextFontAndCenterAlignment(emptyText);
  }
  const pages: TaskUIPageFrames[] = [];
  for (let pageIndex = 0; pageIndex < MAX_PAGES_PER_CATEGORY; pageIndex++) {
    pages.push(createPage(ctx, root as number, category, pageIndex));
  }
  return { root, emptyText: emptyText || null, pageCount: 0, pages };
}

export function createTaskUIPrecreatedListPool(ctx: TaskUIListControlContext): TaskUIPrecreatedListPool | null {
  if (!ctx.listContainer) return null;
  return {
    categories: {
      [QuestType.MAIN]: createCategory(ctx, QuestType.MAIN),
      [QuestType.SIDE]: createCategory(ctx, QuestType.SIDE),
      [QuestType.DAILY]: createCategory(ctx, QuestType.DAILY),
    },
  };
}
