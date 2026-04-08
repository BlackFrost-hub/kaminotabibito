/**
 * 对话框渲染核心
 * 负责DzAPI封装、帧创建、显示控制
 */

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import { createFrame, FrameType } from "../../09．表现系统/01．UI工具/index";
import { frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";
import {
  destroyBubbleEffect,
  releaseNpcOccupation,
  setActivePlayerId,
  getActivePlayerId,
  resetActivePlayerIdIfMatch,
  triggerFinishCallback,
  getNpcUnit,
} from "../../09．表现系统/04．NPC对话状态池";

// ────────────────────────────────────────────────
// 类型别名
// ────────────────────────────────────────────────

/** WC3 player 句柄（Lua 下为 userdata，TS 侧用 any） */
export type Player = any;
/** WC3 timer 句柄 */
export type Timer = any;
/** Dz 帧句柄（整数） */
export type Frame = number;

// ────────────────────────────────────────────────
// 常量
// ────────────────────────────────────────────────

/** 最大支持玩家数 */
export const MAX_PLAYERS = 28;

/** TOC 加载路径 */
const TOC_PATH = "ui\\StarGameUI.toc";

/** 对话框帧标签起始 ID */
export const TAG_BASE_MAIN = 1024;
export const TAG_BASE_PORTRAIT = 1125;

// ────────────────────────────────────────────────
// 默认资源路径
// ────────────────────────────────────────────────

/** 默认字体路径 */
export const DEFAULT_FONT = "UI\\uizt.ttf";
/** 默认标题字体大小 */
export const DEFAULT_TITLE_FONT_SIZE = 0.018;
/** 默认正文字体大小 */
export const DEFAULT_BODY_FONT_SIZE = 0.012;
/** 默认背景贴图 */
export const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
/** 默认标题栏贴图 */
export const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";

/** 对话框首次展开时的提示音效 */
export const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";

// ────────────────────────────────────────────────
// Dz API 安全调用封装
// ────────────────────────────────────────────────

export function dzShow(f: Frame, b: boolean): void {
  if (f && f !== 0 && typeof japi.DzFrameShow === "function") {
    japi.DzFrameShow(f, b);
  }
}

export function dzSetText(f: Frame, s: string): void {
  if (f && f !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(f, s);
  }
}

export function dzSetTexture(f: Frame, path: string): void {
  if (f && f !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(f, path, 0);
  }
}

export function dzSetAlpha(f: Frame, a: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(f, a);
  }
}

export function dzSetAbsPoint(f: Frame, point: number, x: number, y: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(f, point, x, y);
  }
}

export function dzSetSize(f: Frame, w: number, h: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(f, w, h);
  }
}

export function dzClearPoints(f: Frame): void {
  if (f && f !== 0 && typeof japi.DzFrameClearAllPoints === "function") {
    japi.DzFrameClearAllPoints(f);
  }
}

export function dzSetEnable(f: Frame, b: boolean): void {
  if (f && f !== 0 && typeof japi.DzFrameSetEnable === "function") {
    japi.DzFrameSetEnable(f, b);
  }
}

export function dzSetFont(f: Frame, font: string, size: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(f, font, size, 0);
  }
}

export function dzCreate(template: string, tag: number): Frame {
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  if (!gameUI || gameUI === 0) return 0;
  if (typeof japi.DzCreateFrame !== "function") return 0;
  return japi.DzCreateFrame(template, gameUI, tag) as Frame;
}

export function dzSubString(s: string, start: number, end: number): string {
  if (typeof jass.SubString === "function") return jass.SubString(s, start, end) as string;
  return (s as any).sub(start + 1, end) as string;
}

export function dzStringLength(s: string): number {
  if (typeof jass.StringLength === "function") return jass.StringLength(s) as number;
  return s.length;
}

export function dzGetLocalPlayer(): Player {
  return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null;
}

export function dzGetPlayerId(p: Player): number {
  return typeof jass.GetPlayerId === "function" ? (jass.GetPlayerId(p) as number) : -1;
}

export function dzPlayer(index: number): Player {
  return typeof jass.Player === "function" ? jass.Player(index) : null;
}

export function dzTimerCreate(): Timer {
  return typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null;
}

export function dzTimerStart(t: Timer, timeout: number, periodic: boolean, cb: () => void): void {
  if (t && typeof jass.TimerStart === "function") {
    jass.TimerStart(t, timeout, periodic, cb);
  }
}

export function dzTimerPause(t: Timer): void {
  if (t && typeof jass.PauseTimer === "function") {
    jass.PauseTimer(t);
  }
}

function dzLoadToc(): void {
  if (typeof japi.DzLoadToc === "function") {
    japi.DzLoadToc(TOC_PATH);
  }
}

/** TOC 是否已加载过（全局只需一次） */
let g_tocLoaded = false;

export function dzLoadTocOnce(): void {
  if (g_tocLoaded) return;
  g_tocLoaded = true;
  dzLoadToc();
}

// ────────────────────────────────────────────────
// 帧索引常量
// ────────────────────────────────────────────────

/** 帧索引规范：
 * [0]   背景 BACKDROP
 * [1]   标题栏背景（GameUI）
 * [2]   名字文字（GameText）
 * [3]   正文文字（GameTextpxL）
 * [4]   背景透明点击层（GLUETEXTBUTTON，铺满[0]）
 * [5]   接受按钮底图（BACKDROP，任务模式）
 * [6]   接受按钮命中层（GLUETEXTBUTTON，铺满[5]）
 * [7]   拒绝按钮底图（BACKDROP，任务模式）
 * [8]   拒绝按钮命中层（GLUETEXTBUTTON，铺满[7]）
 * [9]   接受按钮文字标签（TEXT，叠在[5]上）
 * [10]  拒绝按钮文字标签（TEXT，叠在[7]上）
 * [11]  "点击以继续 ▼" 提示标签（TEXT）
 * [101] 左立绘（GameUI）
 * [102] 中立绘（GameUI）
 * [103] 右立绘（GameUI）
 */

// ────────────────────────────────────────────────
// 对话框条目类型
// ────────────────────────────────────────────────

export interface DialogEntry {
  title: string;
  text: string;
  waitTime: number;
  leftTex: string;
  midTex: string;
  rightTex: string;
  titleFontSize: number;
  bodyFontSize: number;
  /** 是否为任务对话 */
  isQuest: boolean;
  /** 任务回调 */
  questCallbacks?: {
    onAccept: () => void;
    onReject: () => void;
  };
  /** 接受按钮文本（默认"接受任务"） */
  acceptText?: string;
  /** 拒绝按钮文本（默认"拒绝任务"） */
  rejectText?: string;
}

// ────────────────────────────────────────────────
// 玩家对话框状态
// ────────────────────────────────────────────────

export interface PlayerDialogState {
  /** 玩家索引 0-based */
  playerId: number;
  /** 对话队列（先进先出） */
  queue: DialogEntry[];
  /** 打字机计时器（逐字） */
  tickTimer: Timer;
  /** 帧句柄：[0..11] 主体, [101..103] 立绘 */
  frames: Frame[];
  /** 当前正文已显示字符数 */
  strNow: number;
  /** 当前正文总字符数 */
  strLen: number;
  /** 是否允许显示（本地玩家开关） */
  canShow: boolean;
  /** 系统是否已初始化帧 */
  initialized: boolean;
  /** 对话框是否正在活跃播放 */
  isActive: boolean;
  /** 对话框刚弹出的点击冷却 */
  clickCooldown: boolean;
  /** 文字已全部显示，等待玩家点击才推进 */
  waitingClick: boolean;
}

// ────────────────────────────────────────────────
// 全局状态表
// ────────────────────────────────────────────────

const g_states: PlayerDialogState[] = [];

export function getState(playerId: number): PlayerDialogState | undefined {
  return g_states[playerId];
}

export function ensureState(playerId: number): PlayerDialogState {
  if (g_states[playerId]) return g_states[playerId];

  const state: PlayerDialogState = {
    playerId,
    queue: [],
    tickTimer: dzTimerCreate(),
    frames: [],
    strNow: 0,
    strLen: 0,
    canShow: true,
    initialized: false,
    isActive: false,
    clickCooldown: false,
    waitingClick: false,
  };
  g_states[playerId] = state;
  return state;
}

export function initAllStates(): void {
  for (let i = 0; i < MAX_PLAYERS; i++) {
    ensureState(i);
  }
}

// ────────────────────────────────────────────────
// 帧创建
// ────────────────────────────────────────────────

/**
 * 为指定玩家创建对话框帧（只有本地玩家才真正执行创建）
 * 返回帧数组（非本地玩家返回全0数组，避免 desync）
 */
export function createDialogFrames(
  onBgClick: (state: PlayerDialogState) => void
): Frame[] {
  // 只初始化实际使用的槽位
  const frames: Frame[] = [];
  for (let i = 0; i <= 11; i++) frames[i] = 0;
  frames[101] = 0; frames[102] = 0; frames[103] = 0;

  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;

  // 立绘帧 [101] [102] [103]
  const portraits = [
    { idx: 101, tag: TAG_BASE_PORTRAIT,     x: 0.24,                    y: 0.1421 + 0.2 },
    { idx: 102, tag: TAG_BASE_PORTRAIT + 1, x: 0.24 + 0.377 / 3,        y: 0.1421 + 0.2 },
    { idx: 103, tag: TAG_BASE_PORTRAIT + 2, x: 0.24 + 0.377 / 1.5,      y: 0.1421 + 0.2 },
  ];
  for (const p of portraits) {
    const f = dzCreate("GameUI", p.tag);
    frames[p.idx] = f;
    dzShow(f, false);
    dzClearPoints(f);
    dzSetAbsPoint(f, 3, p.x, p.y);
    dzSetSize(f, 0.367 / 3, 0.231);
    dzSetAlpha(f, 255);
    dzSetTexture(f, "");
  }

  // [0] 背景 BACKDROP
  const bg = createFrame({ type: FrameType.BACKDROP, name: "DialogBG", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[0] = bg;
  dzClearPoints(bg);
  dzSetAbsPoint(bg, 3, 0.23, 0.2421);
  dzSetSize(bg, 0.377, 0.131);
  dzSetAlpha(bg, 255);
  dzSetTexture(bg, DEFAULT_BG_TEX);

  // [4] 透明 GLUETEXTBUTTON 铺满背景，作为点击命中层
  const bgBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogBGBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[4] = bgBtn;
  if (bgBtn !== 0) {
    if (typeof japi.DzFrameSetParent === "function") {
      (pcall as any)(() => japi.DzFrameSetParent(bgBtn, bg));
    }
    if (typeof japi.DzFrameClearAllPoints === "function") {
      (pcall as any)(() => japi.DzFrameClearAllPoints(bgBtn));
    }
    if (typeof japi.DzFrameSetAllPoints === "function") {
      (pcall as any)(() => japi.DzFrameSetAllPoints(bgBtn, bg));
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(bgBtn, "");
    }
    if (typeof japi.DzFrameSetAlpha === "function") {
      (pcall as any)(() => japi.DzFrameSetAlpha(bgBtn, 0));
    }
  }
  // 点击回调
  frameSetScriptByCode(bgBtn, 1, () => {
    const pid = getActivePlayerId();
    if (pid < 0 || pid >= MAX_PLAYERS) return;
    const s = g_states[pid];
    if (!s) return;
    onBgClick(s);
  }, true);

  // [1] 标题栏背景
  const titleBg = dzCreate("GameUI", TAG_BASE_MAIN + 2);
  frames[1] = titleBg;
  dzShow(titleBg, false);
  dzClearPoints(titleBg);
  dzSetAbsPoint(titleBg, 3, 0.24, 0.3083);
  dzSetSize(titleBg, 0.107, 0.0328);
  dzSetAlpha(titleBg, 255);
  dzSetTexture(titleBg, DEFAULT_TITLE_TEX);

  // [2] 名字文字
  const nameText = dzCreate("GameText", TAG_BASE_MAIN + 3);
  frames[2] = nameText;
  dzShow(nameText, false);
  dzClearPoints(nameText);
  if (nameText !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    (pcall as any)(() => japi.DzFrameSetAllPoints(nameText, titleBg));
  }
  dzSetText(nameText, "");
  dzSetFont(nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE);
  dzSetEnable(nameText, false);
  if (nameText !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetTextAlignment(nameText, -1);
      japi.DzFrameSetTextAlignment(nameText, 18);
    });
  }

  // [3] 正文文字
  const bodyText = dzCreate("GameTextpxL", TAG_BASE_MAIN + 4);
  frames[3] = bodyText;
  dzShow(bodyText, false);
  dzClearPoints(bodyText);
  dzSetAbsPoint(bodyText, 0, 0.24, 0.28);
  dzSetSize(bodyText, 0.35, 0.22);
  dzSetText(bodyText, "");
  dzSetFont(bodyText, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE);
  dzSetEnable(bodyText, false);

  // [5] 接受按钮底图 BACKDROP
  const acceptBg = createFrame({ type: FrameType.BACKDROP, name: "DialogAcceptBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[5] = acceptBg;
  if (acceptBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.1800);
  }
  if (acceptBg !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(acceptBg, 0.08, 0.022);
  }
  if (acceptBg !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(acceptBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  }
  // 接受按钮文字
  const acceptLabel = createFrame({ type: FrameType.TEXT, name: "DialogAcceptLabel", parent: acceptBg, template: "template", visible: false }) ?? 0;
  frames[9] = acceptLabel;
  if (acceptLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(acceptLabel, acceptBg);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(acceptLabel, "接受任务");
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") {
    japi.DzFrameSetTextColor(acceptLabel, 255, 255, 255, 255);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    japi.DzFrameSetTextAlignment(acceptLabel, 18);
  }

  // [6] 接受按钮命中层 GLUETEXTBUTTON
  const acceptBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogAcceptBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[6] = acceptBtn;
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(acceptBtn, acceptBg);
  }
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(acceptBtn, 0);
  }
  if (acceptBtn !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(acceptBtn, "");
  }

  // [7] 拒绝按钮底图 BACKDROP
  const rejectBg = createFrame({ type: FrameType.BACKDROP, name: "DialogRejectBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[7] = rejectBg;
  if (rejectBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.1800);
  }
  if (rejectBg !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(rejectBg, 0.08, 0.022);
  }
  if (rejectBg !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(rejectBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  }
  // 拒绝按钮文字
  const rejectLabel = createFrame({ type: FrameType.TEXT, name: "DialogRejectLabel", parent: rejectBg, template: "template", visible: false }) ?? 0;
  frames[10] = rejectLabel;
  if (rejectLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(rejectLabel, rejectBg);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(rejectLabel, "拒绝任务");
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") {
    japi.DzFrameSetTextColor(rejectLabel, 255, 255, 255, 255);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    japi.DzFrameSetTextAlignment(rejectLabel, 18);
  }

  // [8] 拒绝按钮命中层 GLUETEXTBUTTON
  const rejectBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogRejectBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[8] = rejectBtn;
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(rejectBtn, rejectBg);
  }
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(rejectBtn, 0);
  }
  if (rejectBtn !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(rejectBtn, "");
  }

  // [11] "点击以继续 ▼" 提示文字
  const hintLabel = createFrame({ type: FrameType.TEXT, name: "DialogHintLabel", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[11] = hintLabel;
  if (hintLabel !== 0) {
    if (typeof japi.DzFrameSetPoint === "function") {
      (pcall as any)(() => japi.DzFrameSetPoint(hintLabel, 8, bg, 8, -0.008, 0.008));
    }
    if (typeof japi.DzFrameSetSize === "function") {
      japi.DzFrameSetSize(hintLabel, 0.12, 0.018);
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r");
    }
    if (typeof japi.DzFrameSetFont === "function") {
      japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0);
    }
    if (typeof japi.DzFrameSetTextAlignment === "function") {
      japi.DzFrameSetTextAlignment(hintLabel, -1);
      japi.DzFrameSetTextAlignment(hintLabel, 5);
    }
  }

  return frames;
}

// ────────────────────────────────────────────────
// 显示控制
// ────────────────────────────────────────────────

export function showDialogFrames(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  if (!state.canShow) {
    for (let i = 0; i < 9; i++) {
      dzShow(state.frames[i], false);
    }
    for (let i = 101; i < 104; i++) {
      dzShow(state.frames[i], false);
    }
    return;
  }

  // [5]~[8] 任务按钮由任务模块单独控制
  for (let i = 0; i < 5; i++) {
    dzShow(state.frames[i], visible);
  }
  if (!visible) {
    for (let i = 5; i <= 11; i++) {
      dzShow(state.frames[i], false);
    }
  }
  if (visible) {
    dzSetAlpha(state.frames[0], 155);
  }
  for (let i = 101; i < 104; i++) {
    dzShow(state.frames[i], visible);
  }
}

// ────────────────────────────────────────────────
// 对话框结束处理
// ────────────────────────────────────────────────

export function onDialogEnd(playerId: number): void {
  const state = g_states[playerId];
  if (!state) return;

  resetActivePlayerIdIfMatch(playerId);
  destroyBubbleEffect(playerId);
  releaseNpcOccupation(playerId);

  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(playerId);
  const isLocal = localPlayer === targetPlayer;

  if (isLocal && state.initialized) {
    for (let i = 0; i <= 11; i++) {
      dzShow(state.frames[i], false);
    }
    for (let i = 101; i < 104; i++) {
      dzShow(state.frames[i], false);
    }
  }

  state.isActive = false;
  state.waitingClick = false;
  state.clickCooldown = false;

  triggerFinishCallback(playerId);
}

export function clearState(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  state.queue = [];
  onDialogEnd(state.playerId);
}
