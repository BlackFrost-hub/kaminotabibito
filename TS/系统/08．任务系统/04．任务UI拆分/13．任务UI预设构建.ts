/**
 * 13．任务UI预设构建
 * 职责：初始化阶段一次性创建所有 page/variant/row 帧。
 * 不在交互时创建或销毁帧。
 */

const japi = require("jass.japi") as any;

import { QuestType } from "../01．任务数据";
import {
  TaskUIListControlContext,
  TaskUICategoryFrames,
  TaskUIPageFrames,
  TaskUIPageVariantFrames,
  TaskUIRowSlotFrames,
  TaskUIPrecreatedListPool,
  setVisible,
  handleTaskRowClick,
  taskRowBindingByFrameId,
} from "./09．任务UI列表控制";
import {
  LIST_VIEW_H,
  LIST_CONTAINER_W,
  MAX_PAGES_PER_CATEGORY,
  BG_TEX,
} from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";
import { DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/03．UI函数";

const ROWS_PER_PAGE = 7;
const PAGE_VARIANT_COUNT = ROWS_PER_PAGE + 1;
const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
const LIST_ITEM_H = LIST_VIEW_H * 0.14;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;
const ROOT_LEVEL = 40;
const BACKDROP_LEVEL = 41;
const TEXT_LEVEL = 43;
const BUTTON_LEVEL = 46;
const ICON_LEVEL = 45;

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
  const frame = ctx.createFrame({ type: "FRAME", name, parent, template: "template", visible: false, id: ctx.contextId }) || 0;
  if (!frame) return null;
  ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, 0, 0);
  ctx.setFrameSize(frame, { width, height });
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, ROOT_LEVEL);
  return frame;
}

function createHiddenText(ctx: TaskUIListControlContext, name: string, parent: number, width: number, height: number): number | null {
  const frame = ctx.createTextLabel(name, parent, "", { relativeTo: parent, point: ctx.FramePoint.TOPLEFT, relativePoint: ctx.FramePoint.TOPLEFT, x: 0, y: 0 }, { width, height }) || 0;
  if (!frame) return null;
  setVisible(frame, false);
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, TEXT_LEVEL);
  return frame;
}

function createHiddenBackdrop(ctx: TaskUIListControlContext, templateName: string, frameName: string, parent: number, texture?: string, contextId?: number): number | null {
  let frame = tryCreateFromFdfOnly(templateName, parent, contextId ?? 0) || 0;
  if (!frame) {
    frame = ctx.createFrame({ type: ctx.FrameType.BACKDROP, name: frameName, parent, template: "template", visible: false, id: ctx.contextId }) || 0;
    if (frame && texture) ctx.setFrameTexture(frame, texture);
  }
  if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, BACKDROP_LEVEL);
  return frame || null;
}

function createPlainHiddenBackdrop(ctx: TaskUIListControlContext, name: string, parent: number): number | null {
  const frame = ctx.createFrame({ type: ctx.FrameType.BACKDROP, name, parent, template: "template", visible: false, id: ctx.contextId }) || 0;
  if (frame && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, ICON_LEVEL);
  return frame || null;
}

function createHiddenButton(ctx: TaskUIListControlContext, name: string, parent: number, onClick: () => void): number | null {
  const frame = ctx.createFrame({ type: ctx.FrameType.GLUETEXTBUTTON, name, parent, template: "template", visible: false, enable: true, alpha: 0, id: ctx.contextId }) || 0;
  if (!frame) return null;
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(frame, BUTTON_LEVEL);
  ctx.setFrameClickEvent(frame, onClick, true);
  return frame;
}

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
    const slot = createRowSlot(ctx, root as number, prefix + "_R" + rowIndex, rowIndex, handleTaskRowClick);
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
  if (emptyText) {
    ctx.applyDzTextFontAndCenterAlignment(emptyText);
    setVisible(emptyText, false);
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
