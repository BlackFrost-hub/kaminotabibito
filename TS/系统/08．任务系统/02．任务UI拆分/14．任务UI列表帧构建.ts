import { LIST_CONTAINER_W, LIST_VIEW_H } from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";
import type { TaskUIListControlContext } from "./08．任务UI列表控制";
import { createEmptyQuestIdList } from "./10．任务UI列表控制辅助";
import type { TaskUIPageFrames, TaskUIPageVariantFrames, TaskUIRowSlotFrames } from "./08．任务UI列表控制";

const japi = require("jass.japi") as any;

const PAGE_ROOT_HEIGHT = LIST_VIEW_H;

type SetVisibleLike = (frame: number | null, visible: boolean) => void;

// ========== 虚拟分区：帧工厂（隐藏根/文本/背景/按钮）+ 清理 ==========
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
