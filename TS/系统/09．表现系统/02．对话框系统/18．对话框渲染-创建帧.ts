const japi = require("jass.japi") as any;

import { createFrame, FrameType } from "../01．UI工具/index";
import type { Frame } from "./05．对话框业务逻辑";
import {
  DEFAULT_BG_TEX,
  DEFAULT_BODY_FONT_SIZE,
  DEFAULT_FONT,
  DEFAULT_TITLE_FONT_SIZE,
  DEFAULT_TITLE_TEX,
  dzClearPoints,
  dzCreate,
  dzSetAbsPoint,
  dzSetAlpha,
  dzSetEnable,
  dzSetFont,
  dzSetPriority,
  dzSetSize,
  dzSetText,
  dzSetTexture,
  dzShow,
  TAG_BASE_MAIN,
  TAG_BASE_PORTRAIT,
} from "./17．对话框渲染-Dz与状态";

/** 由「任务回调与命中」模块在加载末尾注入，避免 createDialogFrames ↔ dialogPanelHitCallback 循环依赖 */
let g_bindDialogPanelHitFrame: ((hitFrame: Frame) => void) | undefined;

export function setDialogPanelHitBinder(fn: (hitFrame: Frame) => void): void {
  g_bindDialogPanelHitFrame = fn;
}

function bindDialogPanelHitFrame(hitFrame: Frame): void {
  if (g_bindDialogPanelHitFrame) g_bindDialogPanelHitFrame(hitFrame);
}

// ========== 虚拟分区：初始化 ==========
export function createDialogFrames(): Frame[] {
  const frames: Frame[] = [];
  for (let i = 0; i <= 11; i++) frames[i] = 0;
  frames[101] = 0; frames[102] = 0; frames[103] = 0;
  const portraits = [
    { idx: 101, tag: TAG_BASE_PORTRAIT, x: 0.24, y: 0.1421 + 0.2 },
    { idx: 102, tag: TAG_BASE_PORTRAIT + 1, x: 0.24 + 0.377 / 3, y: 0.1421 + 0.2 },
    { idx: 103, tag: TAG_BASE_PORTRAIT + 2, x: 0.24 + 0.377 / 1.5, y: 0.1421 + 0.2 },
  ];
  for (const p of portraits) {
    const f = dzCreate("GameUI", p.tag);
    frames[p.idx] = f;
    dzShow(f, false); dzClearPoints(f); dzSetAbsPoint(f, 3, p.x, p.y); dzSetSize(f, 0.367 / 3, 0.231); dzSetAlpha(f, 255); dzSetTexture(f, "");
  }
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  const bg = createFrame({ type: FrameType.BACKDROP, name: "DialogBG", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[0] = bg;
  dzClearPoints(bg); dzSetAbsPoint(bg, 3, 0.23, 0.2421); dzSetSize(bg, 0.377, 0.131); dzSetAlpha(bg, 255); dzSetTexture(bg, DEFAULT_BG_TEX);
  const bgBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogBGBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[4] = bgBtn;
  if (bgBtn !== 0) {
    if (typeof japi.DzFrameSetParent === "function") (pcall as any)(() => japi.DzFrameSetParent(bgBtn, bg));
    if (typeof japi.DzFrameClearAllPoints === "function") (pcall as any)(() => japi.DzFrameClearAllPoints(bgBtn));
    if (typeof japi.DzFrameSetAllPoints === "function") (pcall as any)(() => japi.DzFrameSetAllPoints(bgBtn, bg));
    if (typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(bgBtn, "");
    if (typeof japi.DzFrameSetAlpha === "function") (pcall as any)(() => japi.DzFrameSetAlpha(bgBtn, 0));
  }
  bindDialogPanelHitFrame(bgBtn);

  const titleBg = dzCreate("GameUI", TAG_BASE_MAIN + 2);
  frames[1] = titleBg;
  dzShow(titleBg, false); dzClearPoints(titleBg); dzSetAbsPoint(titleBg, 3, 0.24, 0.3083); dzSetSize(titleBg, 0.107, 0.0328); dzSetAlpha(titleBg, 255); dzSetTexture(titleBg, DEFAULT_TITLE_TEX);
  const nameText = dzCreate("GameText", TAG_BASE_MAIN + 3);
  frames[2] = nameText;
  dzShow(nameText, false); dzClearPoints(nameText);
  if (nameText !== 0 && typeof japi.DzFrameSetAllPoints === "function") (pcall as any)(() => japi.DzFrameSetAllPoints(nameText, titleBg));
  dzSetText(nameText, ""); dzSetFont(nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE); dzSetEnable(nameText, false);
  if (nameText !== 0 && typeof japi.DzFrameSetTextAlignment === "function") (pcall as any)(() => { japi.DzFrameSetTextAlignment(nameText, -1); japi.DzFrameSetTextAlignment(nameText, 18); });
  const bodyText = dzCreate("GameTextpxL", TAG_BASE_MAIN + 4);
  frames[3] = bodyText;
  dzShow(bodyText, false); dzClearPoints(bodyText); dzSetAbsPoint(bodyText, 0, 0.24, 0.28); dzSetSize(bodyText, 0.35, 0.22); dzSetText(bodyText, ""); dzSetFont(bodyText, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE); dzSetEnable(bodyText, false);

  const acceptBg = createFrame({ type: FrameType.BACKDROP, name: "DialogAcceptBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[5] = acceptBg; if (acceptBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.1800);
  if (acceptBg !== 0 && typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(acceptBg, 0.08, 0.022);
  if (acceptBg !== 0 && typeof japi.DzFrameSetTexture === "function") japi.DzFrameSetTexture(acceptBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  const acceptLabel = createFrame({ type: FrameType.TEXT, name: "DialogAcceptLabel", parent: acceptBg, template: "template", visible: false }) ?? 0;
  frames[9] = acceptLabel;
  if (acceptLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") japi.DzFrameSetAllPoints(acceptLabel, acceptBg);
  if (acceptLabel !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(acceptLabel, "接受任务");
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") japi.DzFrameSetTextColor(acceptLabel, 255, 255, 255, 255);
  if (acceptLabel !== 0 && typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") japi.DzFrameSetTextAlignment(acceptLabel, 18);
  const acceptBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogAcceptBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[6] = acceptBtn;
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") japi.DzFrameSetAllPoints(acceptBtn, acceptBg);
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") japi.DzFrameSetAlpha(acceptBtn, 0);
  if (acceptBtn !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(acceptBtn, "");

  const rejectBg = createFrame({ type: FrameType.BACKDROP, name: "DialogRejectBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[7] = rejectBg; if (rejectBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.1800);
  if (rejectBg !== 0 && typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(rejectBg, 0.08, 0.022);
  if (rejectBg !== 0 && typeof japi.DzFrameSetTexture === "function") japi.DzFrameSetTexture(rejectBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  const rejectLabel = createFrame({ type: FrameType.TEXT, name: "DialogRejectLabel", parent: rejectBg, template: "template", visible: false }) ?? 0;
  frames[10] = rejectLabel;
  if (rejectLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") japi.DzFrameSetAllPoints(rejectLabel, rejectBg);
  if (rejectLabel !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(rejectLabel, "拒绝任务");
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") japi.DzFrameSetTextColor(rejectLabel, 255, 255, 255, 255);
  if (rejectLabel !== 0 && typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") japi.DzFrameSetTextAlignment(rejectLabel, 18);
  const rejectBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogRejectBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[8] = rejectBtn;
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") japi.DzFrameSetAllPoints(rejectBtn, rejectBg);
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") japi.DzFrameSetAlpha(rejectBtn, 0);
  if (rejectBtn !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(rejectBtn, "");

  const hintLabel = createFrame({ type: FrameType.TEXT, name: "DialogHintLabel", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[11] = hintLabel;
  if (hintLabel !== 0) {
    if (typeof japi.DzFrameSetPoint === "function") (pcall as any)(() => japi.DzFrameSetPoint(hintLabel, 8, bg, 8, -0.008, 0.008));
    if (typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(hintLabel, 0.12, 0.018);
    if (typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r");
    if (typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0);
    if (typeof japi.DzFrameSetTextAlignment === "function") { japi.DzFrameSetTextAlignment(hintLabel, -1); japi.DzFrameSetTextAlignment(hintLabel, 5); }
  }

  // 跳过提示文本（在说话人标题下方）
  const skipHintLabel = createFrame({ type: FrameType.TEXT, name: "DialogSkipHint", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[12] = skipHintLabel;
  if (skipHintLabel !== 0) {
    // 锚定到标题背景的左下角，往下偏移一点
    if (typeof japi.DzFrameSetPoint === "function") (pcall as any)(() => japi.DzFrameSetPoint(skipHintLabel, 0, titleBg, 2, 0.005, -0.022));
    if (typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(skipHintLabel, 0.12, 0.018);
    if (typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(skipHintLabel, "|cff333333按下 ~ 键跳过对话|r");
    if (typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(skipHintLabel, DEFAULT_FONT, 0.012, 0);
    if (typeof japi.DzFrameSetTextAlignment === "function") { japi.DzFrameSetTextAlignment(skipHintLabel, -1); japi.DzFrameSetTextAlignment(skipHintLabel, 4); }
  }

  bindDialogPanelHitFrame(nameText);
  bindDialogPanelHitFrame(bodyText);
  bindDialogPanelHitFrame(hintLabel);
  bindDialogPanelHitFrame(skipHintLabel);

  const p = 180;
  dzSetPriority(frames[0], p); dzSetPriority(frames[1], p); dzSetPriority(frames[2], p); dzSetPriority(frames[3], p); dzSetPriority(frames[4], p);
  dzSetPriority(frames[5], p); dzSetPriority(frames[6], p); dzSetPriority(frames[7], p); dzSetPriority(frames[8], p); dzSetPriority(frames[9], p); dzSetPriority(frames[10], p);
  dzSetPriority(frames[11], p); dzSetPriority(frames[12], p); dzSetPriority(frames[101], p); dzSetPriority(frames[102], p); dzSetPriority(frames[103], p);
  return frames;
}
