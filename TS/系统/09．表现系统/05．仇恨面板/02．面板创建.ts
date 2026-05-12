/** @noSelfInFile */
/**
 * 仇恨面板 - 面板创建
 *
 * 包含面板工具函数、创建单/全部玩家面板。
 */
import {
  THREAT_PANEL_BODY_FONT,
  THREAT_PANEL_BODY_SIZE,
  THREAT_PANEL_BG_TEXTURE,
  THREAT_PANEL_FDF_FRAME,
  THREAT_PANEL_HEIGHT,
  THREAT_PANEL_HEADER_OFFSET_Y,
  THREAT_PANEL_INNER_ALPHA,
  THREAT_PANEL_INNER_HEIGHT,
  THREAT_PANEL_INNER_OFFSET_X,
  THREAT_PANEL_INNER_OFFSET_Y,
  THREAT_PANEL_INNER_WIDTH,
  THREAT_PANEL_NAME_COL_WIDTH,
  THREAT_PANEL_NAME_COL_X,
  THREAT_PANEL_PERCENT_COL_WIDTH,
  THREAT_PANEL_PERCENT_COL_X,
  THREAT_PANEL_PLAYER_SLOTS,
  THREAT_PANEL_PRIORITY,
  THREAT_PANEL_ROW_COUNT,
  THREAT_PANEL_ROW_GAP,
  THREAT_PANEL_ROW_START_OFFSET_Y,
  THREAT_PANEL_SELECTED_OFFSET_Y,
  THREAT_PANEL_SUMMARY_OFFSET_Y,
  THREAT_PANEL_TEXT_HEIGHT,
  THREAT_PANEL_TEXT_OFFSET_X,
  THREAT_PANEL_TEXT_WIDTH,
  THREAT_PANEL_THREAT_COL_WIDTH,
  THREAT_PANEL_THREAT_COL_X,
  THREAT_PANEL_TITLE,
  THREAT_PANEL_TITLE_FONT,
  THREAT_PANEL_TITLE_OFFSET_X,
  THREAT_PANEL_TITLE_OFFSET_Y,
  THREAT_PANEL_TITLE_SIZE,
  THREAT_PANEL_TITLE_WIDTH,
  THREAT_PANEL_TOC_PATH,
  THREAT_PANEL_WIDTH,
  THREAT_PANEL_X,
  THREAT_PANEL_Y,
} from "./00．常量定义";
import {
  DzCreateFrame,
  DzCreateFrameByTagName,
  DzFrameSetAbsolutePoint,
  DzFrameSetFont,
  DzFrameSetPriority,
  DzFrameSetSize,
  DzFrameSetTexture,
  DzFrameSetAlpha,
  DzFrameSetText,
  DzFrameSetTextAlignment,
  DzFrameShow,
  DzLoadToc,
  ABS_BOTTOMLEFT,
  TEXT_ALIGN_CENTER,
  TEXT_ALIGN_LEFT,
  EMPTY_ROW,
  ThreatPanelFrames,
  玩家面板表,
} from "./01．共享";

let 已加载Toc = false;

let __待加载Toc路径 = "";
let __待创建Fdf名称 = "";
let __待创建Fdf父级 = 0;
let __待创建Fdf实例 = 0;
let __创建Fdf结果 = 0;

function __加载TocPcallBody(this: any): void {
  DzLoadToc(__待加载Toc路径);
}

function __创建FdfPcallBody(this: any): void {
  __创建Fdf结果 = DzCreateFrame(__待创建Fdf名称, __待创建Fdf父级, __待创建Fdf实例);
}

export function 加载仇恨面板Toc(): void {
  if (已加载Toc) return;
  已加载Toc = true;
  __待加载Toc路径 = THREAT_PANEL_TOC_PATH;
  pcall(__加载TocPcallBody);
}

function 创建Fdf面板(name: string, parent: number, instanceId: number, x: number, y: number, width: number, height: number, priority: number): number {
  __待创建Fdf名称 = name;
  __待创建Fdf父级 = parent;
  __待创建Fdf实例 = instanceId;
  __创建Fdf结果 = 0;
  const ok = pcall(__创建FdfPcallBody);
  const frame = __创建Fdf结果;
  if (!ok || frame === 0) return 0;
  DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y);
  DzFrameSetSize(frame, width, height);
  DzFrameSetPriority(frame, priority);
  DzFrameShow(frame, true);
  return frame;
}

function 创建背景(
  name: string,
  parent: number,
  x: number,
  y: number,
  width: number,
  height: number,
  texture: string,
  alpha: number,
  priority: number
): number {
  const frame = DzCreateFrameByTagName("BACKDROP", name, parent, "template", 0);
  if (frame === 0) return 0;
  DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y);
  DzFrameSetSize(frame, width, height);
  DzFrameSetTexture(frame, texture, 0);
  DzFrameSetAlpha(frame, alpha);
  DzFrameSetPriority(frame, priority);
  DzFrameShow(frame, true);
  return frame;
}

function 创建文本带对齐(
  name: string,
  parent: number,
  x: number,
  y: number,
  text: string,
  font: string,
  size: number,
  priority: number,
  align: number,
  width = THREAT_PANEL_TEXT_WIDTH,
  height = THREAT_PANEL_TEXT_HEIGHT
): number {
  const frame = DzCreateFrameByTagName("TEXT", name, parent, "template", 0);
  if (frame === 0) return 0;
  DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y);
  DzFrameSetSize(frame, width, height);
  DzFrameSetText(frame, text);
  DzFrameSetFont(frame, font, size, 0);
  DzFrameSetTextAlignment(frame, -1);
  DzFrameSetTextAlignment(frame, align);
  DzFrameSetPriority(frame, priority);
  DzFrameShow(frame, true);
  return frame;
}

function 创建文本(
  name: string,
  parent: number,
  x: number,
  y: number,
  text: string,
  font: string,
  size: number,
  priority: number,
  align = TEXT_ALIGN_CENTER,
  width = THREAT_PANEL_TEXT_WIDTH,
  height = THREAT_PANEL_TEXT_HEIGHT
): number {
  return 创建文本带对齐(name, parent, x, y, text, font, size, priority, align, width, height);
}

function 创建单玩家面板(playerId: number, gameUI: number): ThreatPanelFrames | null {
  const root = 创建Fdf面板(
    THREAT_PANEL_FDF_FRAME,
    gameUI,
    playerId + 1,
    THREAT_PANEL_X,
    THREAT_PANEL_Y,
    THREAT_PANEL_WIDTH,
    THREAT_PANEL_HEIGHT,
    THREAT_PANEL_PRIORITY
  );
  if (root === 0) return null;

  const inner = 创建背景(
    "ThreatPanelInner_P" + playerId,
    gameUI,
    THREAT_PANEL_X + THREAT_PANEL_INNER_OFFSET_X,
    THREAT_PANEL_Y + THREAT_PANEL_INNER_OFFSET_Y,
    THREAT_PANEL_INNER_WIDTH,
    THREAT_PANEL_INNER_HEIGHT,
    THREAT_PANEL_BG_TEXTURE,
    THREAT_PANEL_INNER_ALPHA,
    THREAT_PANEL_PRIORITY + 2
  );
  const title = 创建文本(
    "ThreatPanelTitle_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_TITLE_OFFSET_X,
    THREAT_PANEL_Y + THREAT_PANEL_TITLE_OFFSET_Y,
    `|cffffcc33${THREAT_PANEL_TITLE}|r`,
    THREAT_PANEL_TITLE_FONT,
    THREAT_PANEL_TITLE_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_CENTER,
    THREAT_PANEL_TITLE_WIDTH,
    THREAT_PANEL_TEXT_HEIGHT
  );
  const selected = 创建文本带对齐(
    "ThreatPanelSelected_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_TEXT_OFFSET_X,
    THREAT_PANEL_Y + THREAT_PANEL_SELECTED_OFFSET_Y,
    "",
    THREAT_PANEL_BODY_FONT,
    THREAT_PANEL_BODY_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_LEFT
  );
  const summary = 创建文本带对齐(
    "ThreatPanelSummary_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_TEXT_OFFSET_X,
    THREAT_PANEL_Y + THREAT_PANEL_SUMMARY_OFFSET_Y,
    "",
    THREAT_PANEL_BODY_FONT,
    THREAT_PANEL_BODY_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_LEFT
  );
  const header = 创建文本带对齐(
    "ThreatPanelHeaderName_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_NAME_COL_X,
    THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
    "",
    THREAT_PANEL_BODY_FONT,
    THREAT_PANEL_BODY_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_LEFT,
    THREAT_PANEL_NAME_COL_WIDTH,
    THREAT_PANEL_TEXT_HEIGHT
  );
  const headerPercent = 创建文本带对齐(
    "ThreatPanelHeaderPercent_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_PERCENT_COL_X,
    THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
    "",
    THREAT_PANEL_BODY_FONT,
    THREAT_PANEL_BODY_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_LEFT,
    THREAT_PANEL_PERCENT_COL_WIDTH,
    THREAT_PANEL_TEXT_HEIGHT
  );
  const headerThreat = 创建文本带对齐(
    "ThreatPanelHeaderThreat_P" + playerId,
    root,
    THREAT_PANEL_X + THREAT_PANEL_THREAT_COL_X,
    THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
    "",
    THREAT_PANEL_BODY_FONT,
    THREAT_PANEL_BODY_SIZE,
    THREAT_PANEL_PRIORITY + 2,
    TEXT_ALIGN_LEFT,
    THREAT_PANEL_THREAT_COL_WIDTH,
    THREAT_PANEL_TEXT_HEIGHT
  );

  const rowNames: number[] = [];
  const rowPercents: number[] = [];
  const rowThreats: number[] = [];
  for (let i = 0; i < THREAT_PANEL_ROW_COUNT; i++) {
    const nameFrame = 创建文本带对齐(
      "ThreatPanelRowName_P" + playerId + "_" + i,
      root,
      THREAT_PANEL_X + THREAT_PANEL_NAME_COL_X,
      THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
      EMPTY_ROW,
      THREAT_PANEL_BODY_FONT,
      THREAT_PANEL_BODY_SIZE,
      THREAT_PANEL_PRIORITY + 2,
      TEXT_ALIGN_LEFT,
      THREAT_PANEL_NAME_COL_WIDTH,
      THREAT_PANEL_TEXT_HEIGHT
    );
    const percentFrame = 创建文本带对齐(
      "ThreatPanelRowPercent_P" + playerId + "_" + i,
      root,
      THREAT_PANEL_X + THREAT_PANEL_PERCENT_COL_X,
      THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
      EMPTY_ROW,
      THREAT_PANEL_BODY_FONT,
      THREAT_PANEL_BODY_SIZE,
      THREAT_PANEL_PRIORITY + 2,
      TEXT_ALIGN_LEFT,
      THREAT_PANEL_PERCENT_COL_WIDTH,
      THREAT_PANEL_TEXT_HEIGHT
    );
    const threatFrame = 创建文本带对齐(
      "ThreatPanelRowThreat_P" + playerId + "_" + i,
      root,
      THREAT_PANEL_X + THREAT_PANEL_THREAT_COL_X,
      THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
      EMPTY_ROW,
      THREAT_PANEL_BODY_FONT,
      THREAT_PANEL_BODY_SIZE,
      THREAT_PANEL_PRIORITY + 2,
      TEXT_ALIGN_LEFT,
      THREAT_PANEL_THREAT_COL_WIDTH,
      THREAT_PANEL_TEXT_HEIGHT
    );
    rowNames.push(nameFrame);
    rowPercents.push(percentFrame);
    rowThreats.push(threatFrame);
  }

  return { root, inner, title, selected, summary, headerName: header, headerPercent, headerThreat, rowNames, rowPercents, rowThreats };
}

export function 创建全部玩家面板(gameUI: number): void {
  for (let playerId = 0; playerId < THREAT_PANEL_PLAYER_SLOTS; playerId++) {
    const panel = 创建单玩家面板(playerId, gameUI);
    if (panel != null) {
      玩家面板表[playerId] = panel;
    }
  }
}
