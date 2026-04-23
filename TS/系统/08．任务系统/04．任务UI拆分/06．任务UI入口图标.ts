/**
 * 任务入口图标（GameUI 上的「任务」按钮区域）
 *
 * 依赖 FDF 名 `TaskEntryIcon`：内含标题字、透明全屏点击按钮，点击行为与 J 键一致（音效 + 开关面板）。
 */

import {
  ENTRY_X,
  ENTRY_Y,
  ENTRY_W,
  ENTRY_H,
  ENTRY_TITLE_TEXT_BOX_W,
  ENTRY_TITLE_TEXT_BOX_H,
} from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";

export interface BuildEntryIconResult {
  entryFrame: number | null;
  entryText: number | null;
}

export interface BuildTaskEntryIconOpts {
  japi: any;
  parent: number;
  FrameType: any;
  FramePoint: any;
  createFrame: any;
  createTextLabel: any;
  setFramePosition: any;
  setFrameSize: any;
  setFramePointRelative: any;
  setFrameClickEvent: any;
  applyDzTextFontAndCenterAlignment: any;
  onClickSound: () => void;
  onTogglePanel: () => void;
  /** 槽位号 0..N-1，用于在多槽位(每客户端对称创建 N 套)时区分 FDF contextId 与子帧名，避免冲突。 */
  slotPid?: number;
}

/**
 * 在 parent（一般为 GameUI）下创建入口；FDF 缺失时返回双 null，由上层决定是否降级。
 */
export function buildTaskEntryIcon(opts: BuildTaskEntryIconOpts): BuildEntryIconResult {
  const {
    japi,
    parent,
    FrameType,
    FramePoint,
    createFrame,
    createTextLabel,
    setFramePosition,
    setFrameSize,
    setFramePointRelative,
    setFrameClickEvent,
    applyDzTextFontAndCenterAlignment,
    onClickSound,
    onTogglePanel,
    slotPid,
  } = opts;
  const ctxId = slotPid ?? 0;
  const suf = `_s${ctxId}`;

  const entryFrame = tryCreateFromFdfOnly("TaskEntryIcon", parent, ctxId);
  if (!entryFrame) return { entryFrame: null, entryText: null };

  // 整体位置与尺寸来自常量（与主面板的相对偏移配合）
  setFramePosition(entryFrame, { point: FramePoint.TOPLEFT, x: ENTRY_X, y: ENTRY_Y });
  setFrameSize(entryFrame, { width: ENTRY_W, height: ENTRY_H });

  const tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W;
  const th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H;
  const titleRel = {
    relativeTo: entryFrame,
    point: FramePoint.CENTER,
    relativePoint: FramePoint.CENTER,
    x: 0,
    y: 0,
  };

  // 优先用 TEXT 帧（便于 Dz 换字）；失败则退回 createTextLabel
  let entryText: number | null = null;
  const textFrame =
    createFrame({
      type: FrameType.TEXT,
      name: "TaskEntryText" + suf,
      parent: entryFrame,
      template: "template",
      visible: true,
    }) ?? 0;
  if (textFrame != null && textFrame !== 0) {
    entryText = textFrame;
    setFramePointRelative(textFrame, titleRel.point, titleRel.relativeTo, titleRel.relativePoint, titleRel.x, titleRel.y);
    setFrameSize(textFrame, { width: tw, height: th });
  } else {
    entryText = createTextLabel("TaskEntryText" + suf, entryFrame, "", titleRel, { width: tw, height: th });
  }

  if (entryText != null && entryText !== 0) {
    if (typeof (japi as any).DzFrameSetText === "function") {
      (japi as any).DzFrameSetText(entryText, "|cffffcc00任务(J)|r");
    }
    applyDzTextFontAndCenterAlignment(entryText);
  }

  // 透明 GLUETEXTBUTTON 盖住整块入口，保证点击区域与视觉一致
  const btn =
    createFrame({
      type: FrameType.GLUETEXTBUTTON,
      name: "TaskEntryBtn" + suf,
      parent: entryFrame,
      template: "template",
      visible: true,
      enable: true,
      alpha: 0,
    }) ?? 0;
  if (btn && typeof (japi as any).DzFrameSetAllPoints === "function") {
    (japi as any).DzFrameSetAllPoints(btn, entryFrame);
    setFrameClickEvent(
      btn,
      () => {
        onClickSound();
        onTogglePanel();
      },
      false
    );
  }

  return { entryFrame, entryText };
}
