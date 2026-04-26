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
  onTogglePanel: () => void;
}

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
    onTogglePanel,
  } = opts;

  const entryFrame = tryCreateFromFdfOnly("TaskEntryIcon", parent);
  if (!entryFrame) return { entryFrame: null, entryText: null };

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

  let entryText: number | null = null;
  const textFrame =
    createFrame({
      type: FrameType.TEXT,
      name: "TaskEntryText",
      parent: entryFrame,
      template: "template",
      visible: true,
    }) ?? 0;
  if (textFrame != null && textFrame !== 0) {
    entryText = textFrame;
    setFramePointRelative(textFrame, titleRel.point, titleRel.relativeTo, titleRel.relativePoint, titleRel.x, titleRel.y);
    setFrameSize(textFrame, { width: tw, height: th });
  } else {
    entryText = createTextLabel("TaskEntryText", entryFrame, "", titleRel, { width: tw, height: th });
  }

  if (entryText != null && entryText !== 0) {
    if (typeof (japi as any).DzFrameSetText === "function") {
      (japi as any).DzFrameSetText(entryText, "|cffffcc00任务(J)|r");
    }
    applyDzTextFontAndCenterAlignment(entryText);
  }

  const btn =
    createFrame({
      type: FrameType.GLUETEXTBUTTON,
      name: "TaskEntryBtn",
      parent: entryFrame,
      template: "template",
      visible: true,
      enable: true,
      alpha: 0,
    }) ?? 0;
  if (btn) {
    if (typeof (japi as any).DzFrameSetAllPoints === "function") {
      (japi as any).DzFrameSetAllPoints(btn, entryFrame);
    }
    // sync=true：帧点击全房触发，回调内部做全局状态+本地UI分层
    setFrameClickEvent(btn, onTogglePanel, true);
  }

  return { entryFrame, entryText };
}
