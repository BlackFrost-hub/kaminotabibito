import { LIST_CONTAINER_W, LIST_VIEW_H, LIST_ITEM_H, BG_TEX } from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";
import type { TaskUIListControlContext } from "./09．任务UI列表控制";
import { QuestType } from "../01．任务数据";
import { EMPTY_TEXTS } from "./02．任务UI辅助";
import { createEmptyQuestIdList, PAGE_VARIANT_COUNT, ROWS_PER_PAGE } from "./11．任务UI列表控制辅助";
import type { TaskUICategoryFrames, TaskUIPageFrames, TaskUIPageVariantFrames, TaskUIRowSlotFrames } from "./09．任务UI列表控制";

const japi = require("jass.japi") as any;

const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;

type SetVisibleLike = (frame: number | null, visible: boolean) => void;

export function createHiddenRoot(
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
      id: ctx.contextId,
    }) || 0;
  if (!frame) return null;
  ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, 0, 0);
  ctx.setFrameSize(frame, { width, height });
  return frame;
}

export function createHiddenText(
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
  (japi as any).DzFrameShow(frame, false);
  return frame;
}

export function createHiddenBackdrop(
  ctx: TaskUIListControlContext,
  templateName: string,
  frameName: string,
  parent: number,
  texture?: string,
  contextId?: number
): number | null {
  let frame = tryCreateFromFdfOnly(templateName, parent, contextId ?? ctx.contextId) || 0;
  if (!frame) {
    frame =
      ctx.createFrame({
        type: ctx.FrameType.BACKDROP,
        name: frameName,
        parent,
        template: "template",
        visible: false,
        id: ctx.contextId,
      }) || 0;
    if (frame && texture) {
      ctx.setFrameTexture(frame, texture);
    }
  }
  return frame || null;
}

export function createPlainHiddenBackdrop(
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
      id: ctx.contextId,
    }) || 0;
  return frame || null;
}

export function createHiddenButton(
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
      id: ctx.contextId,
    }) || 0;
  if (!frame) return null;
  ctx.setFrameClickEvent(frame, onClick, true);
  return frame;
}

function hideFrames(frames: Array<number | null>, setVisible: SetVisibleLike): void {
  for (const frame of frames) setVisible(frame, false);
}

export function hideRowSlot(slot: TaskUIRowSlotFrames, setVisible: SetVisibleLike): void {
  hideFrames([slot.backdrop, slot.title, slot.clickBtn, slot.icon, slot.failFrame], setVisible);
  hideFrames(slot.objectiveFrames, setVisible);
  hideFrames(slot.detailFrames, setVisible);
}

export function clearVariant(variant: TaskUIPageVariantFrames, setVisible: SetVisibleLike): void {
  for (const slot of variant.rowSlots) hideRowSlot(slot, setVisible);
}

export function clearPage(page: TaskUIPageFrames, setVisible: SetVisibleLike): void {
  page.questIds = createEmptyQuestIdList();
  for (const variant of page.variants) {
    clearVariant(variant, setVisible);
    setVisible(variant.root, false);
  }
  setVisible(page.root, false);
}

export function createRowSlot(
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

  for (let i = 0; i < 4; i++) {
    const frame = createHiddenText(ctx, prefix + "_Obj_" + rowIndex + "_" + i, parent, LIST_CONTAINER_W * 0.9, OBJECTIVE_HEIGHT);
    objectiveFrames.push(frame || 0);
  }

  const failFrame = createHiddenText(ctx, prefix + "_Fail_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, FAIL_HEIGHT);

  for (let i = 0; i < 3; i++) {
    const frame = createHiddenText(ctx, prefix + "_Detail_" + rowIndex + "_" + i, parent, LIST_CONTAINER_W * 0.9, DETAIL_HEIGHT);
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

export function createVariant(
  ctx: TaskUIListControlContext,
  page: TaskUIPageFrames,
  category: QuestType,
  pageIndex: number,
  variantIndex: number,
  rowClickHandlers: Array<() => void>
): TaskUIPageVariantFrames {
  const root = createHiddenRoot(ctx, "TaskVariant_" + category + "_" + pageIndex + "_" + variantIndex, page.root as number);
  const rowSlots: TaskUIRowSlotFrames[] = [];
  for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
    rowSlots.push(
      createRowSlot(
        ctx,
        root as number,
        "TaskVar_" + category + "_" + pageIndex + "_" + variantIndex,
        rowIndex,
        rowClickHandlers[rowIndex] ?? (() => {})
      )
    );
  }
  return { root, rowSlots };
}

export function createPage(
  ctx: TaskUIListControlContext,
  categoryRoot: number,
  category: QuestType,
  pageIndex: number,
  rowClickHandlers: Array<() => void>
): TaskUIPageFrames {
  const page: TaskUIPageFrames = {
    root: createHiddenRoot(ctx, "TaskPage_" + category + "_" + pageIndex, categoryRoot),
    questIds: createEmptyQuestIdList(),
    variants: [],
  };
  for (let variantIndex = 0; variantIndex < PAGE_VARIANT_COUNT; variantIndex++) {
    page.variants.push(createVariant(ctx, page, category, pageIndex, variantIndex, rowClickHandlers));
  }
  return page;
}

export function createCategory(
  ctx: TaskUIListControlContext,
  category: QuestType,
  setVisible: SetVisibleLike,
  rowClickHandlers: Array<() => void>
): TaskUICategoryFrames {
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
    setVisible(emptyText, false);
  }

  return {
    root,
    emptyText: emptyText || null,
    pageCount: 0,
    pages: [],
  };
}
