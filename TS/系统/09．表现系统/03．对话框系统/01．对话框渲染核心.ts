const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import { createFrame, FrameType } from "../01．UI工具/index";
import { frameSetScriptByCode, registerKeyDown, isKeyDown } from "../../00．核心系统/04．硬件函数";
import { Sound3DII_Mp3PlayReuse } from "../../00．核心系统/02．音效函数";
import { getActivePlayerId, resetActivePlayerIdIfMatch, setActivePlayerId } from "../04．NPC对话状态池";
import { STEP_LEN, TICK, nextTypingProgress, stringLengthCompat, substringCompat } from "./02．打字机效果";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { createNormalDialogEntry, createQuestDialogEntry, DialogEntry, Frame, Player, PlayerDialogState, Timer, onDialogFinished } from "./05．对话框业务逻辑";

const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";
const MAX_PLAYERS = 28;
const TOC_PATH = "ui\\StarGameUI.toc";
const TAG_BASE_MAIN = 1024;
const TAG_BASE_PORTRAIT = 1125;
const DEFAULT_FONT = "UI\\uizt.ttf";
const DEFAULT_TITLE_FONT_SIZE = 0.018;
const DEFAULT_BODY_FONT_SIZE = 0.012;
const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";
const KEY_SKIP_DIALOG = 192; // ~ 键（波浪号/反引号，数字键盘左边ESC下面）

// ========== 虚拟分区：运行时状态 ==========
const g_states: PlayerDialogState[] = [];
const g_questCallbacksByPlayer: Array<{ onAccept: () => void; onReject: () => void } | undefined> = [];

// ========== 虚拟分区：工具 ==========
function dzShow(f: Frame, b: boolean): void { if (f && f !== 0 && typeof japi.DzFrameShow === "function") japi.DzFrameShow(f, b); }
function dzSetText(f: Frame, s: string): void { if (f && f !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(f, s); }
function dzSetTexture(f: Frame, path: string): void { if (f && f !== 0 && typeof japi.DzFrameSetTexture === "function") japi.DzFrameSetTexture(f, path, 0); }
function dzSetAlpha(f: Frame, a: number): void { if (f && f !== 0 && typeof japi.DzFrameSetAlpha === "function") japi.DzFrameSetAlpha(f, a); }
function dzSetPriority(f: Frame, p: number): void { if (f && f !== 0 && typeof japi.DzFrameSetPriority === "function") (pcall as any)(() => japi.DzFrameSetPriority(f, p)); }
function dzSetAbsPoint(f: Frame, point: number, x: number, y: number): void { if (f && f !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") japi.DzFrameSetAbsolutePoint(f, point, x, y); }
function dzSetSize(f: Frame, w: number, h: number): void { if (f && f !== 0 && typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(f, w, h); }
function dzClearPoints(f: Frame): void { if (f && f !== 0 && typeof japi.DzFrameClearAllPoints === "function") japi.DzFrameClearAllPoints(f); }
function dzSetEnable(f: Frame, b: boolean): void { if (f && f !== 0 && typeof japi.DzFrameSetEnable === "function") japi.DzFrameSetEnable(f, b); }
function dzSetFont(f: Frame, font: string, size: number): void { if (f && f !== 0 && typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(f, font, size, 0); }
function dzCreate(template: string, tag: number): Frame {
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  if (!gameUI || gameUI === 0) return 0;
  if (typeof japi.DzCreateFrame !== "function") return 0;
  return japi.DzCreateFrame(template, gameUI, tag) as Frame;
}
function dzGetLocalPlayer(): Player { return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null; }
function dzGetPlayerId(p: Player): number { return typeof jass.GetPlayerId === "function" ? (jass.GetPlayerId(p) as number) : -1; }
function dzPlayer(index: number): Player { return typeof jass.Player === "function" ? jass.Player(index) : null; }
function dzTimerCreate(): Timer { return typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null; }
function dzTimerStart(t: Timer, timeout: number, periodic: boolean, cb: () => void): void { if (t && typeof jass.TimerStart === "function") jass.TimerStart(t, timeout, periodic, cb); }
function dzTimerPause(t: Timer): void { if (t && typeof jass.PauseTimer === "function") jass.PauseTimer(t); }
function dzLoadToc(): void { if (typeof japi.DzLoadToc === "function") japi.DzLoadToc(TOC_PATH); }
let g_tocLoaded = false;
function dzLoadTocOnce(): void { if (g_tocLoaded) return; g_tocLoaded = true; dzLoadToc(); }

// ========== 虚拟分区：回调流程 ==========
function resolveQuestCallbackByTriggerPlayer(): { state: PlayerDialogState; onAccept: () => void; onReject: () => void } | undefined {
  let pid = getActivePlayerId();
  if (pid < 0 || pid >= MAX_PLAYERS) {
    if (typeof japi.DzGetTriggerUIEventPlayer !== "function") return undefined;
    const triggerPlayer = japi.DzGetTriggerUIEventPlayer();
    pid = dzGetPlayerId(triggerPlayer);
  }
  if (pid < 0 || pid >= MAX_PLAYERS) return undefined;
  const state = g_states[pid];
  if (!state) return undefined;
  const cb = g_questCallbacksByPlayer[pid];
  if (!cb) return undefined;
  return { state, onAccept: cb.onAccept, onReject: cb.onReject };
}

function questAcceptCallback(): void {
  const ctx = resolveQuestCallbackByTriggerPlayer();
  if (!ctx) return;
  const { state, onAccept } = ctx;
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue.shift();
  onDialogFinished(state);
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    showDialogFrames(state, false);
  }
  onAccept();
}

function questRejectCallback(): void {
  const ctx = resolveQuestCallbackByTriggerPlayer();
  if (!ctx) return;
  const { state, onReject } = ctx;
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue.shift();
  onDialogFinished(state);
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    showDialogFrames(state, false);
  }
  onReject();
}

(globalThis as any).QuestAcceptCallback = questAcceptCallback;
(globalThis as any).QuestRejectCallback = questRejectCallback;

// ========== 虚拟分区：初始化 ==========
function createDialogFrames(): Frame[] {
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
  frameSetScriptByCode(bgBtn, 1, () => {
    for (let i = 0; i < MAX_PLAYERS; i++) {
      const s = g_states[i];
      if (s && s.frames[0] === bg) {
        if (s.clickCooldown) return;
        if (s.strNow < s.strLen) skipTyping(s);
        else if (s.waitingClick && s.queue.length > 0 && !s.queue[0].isQuest) { s.waitingClick = false; advanceDialog(s); }
        return;
      }
    }
  }, false);

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

  const p = 180;
  dzSetPriority(frames[0], p); dzSetPriority(frames[1], p); dzSetPriority(frames[2], p); dzSetPriority(frames[3], p); dzSetPriority(frames[4], p);
  dzSetPriority(frames[5], p); dzSetPriority(frames[6], p); dzSetPriority(frames[7], p); dzSetPriority(frames[8], p); dzSetPriority(frames[9], p); dzSetPriority(frames[10], p);
  dzSetPriority(frames[11], p); dzSetPriority(frames[12], p); dzSetPriority(frames[101], p); dzSetPriority(frames[102], p); dzSetPriority(frames[103], p);
  return frames;
}

// ========== 虚拟分区：状态管理 ==========
function ensureState(playerId: number): PlayerDialogState {
  if (g_states[playerId]) return g_states[playerId];
  const state: PlayerDialogState = { playerId, queue: [], tickTimer: dzTimerCreate(), frames: [], strNow: 0, strLen: 0, canShow: true, initialized: false, questSyncHandlersBound: false, isActive: false, clickCooldown: false, waitingClick: false };
  g_states[playerId] = state;
  return state;
}
function bindQuestSyncHandlers(state: PlayerDialogState): void {
  if (state.questSyncHandlersBound || !state.frames || state.frames.length === 0) return;
  frameSetScriptByCode(state.frames[6], 1, questAcceptCallback, true);
  frameSetScriptByCode(state.frames[8], 1, questRejectCallback, true);
  state.questSyncHandlersBound = true;
}
function showDialogFrames(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;
  if (!state.canShow) {
    for (let i = 0; i < 9; i++) dzShow(state.frames[i], false);
    for (let i = 101; i < 104; i++) dzShow(state.frames[i], false);
    return;
  }
  for (let i = 0; i < 5; i++) dzShow(state.frames[i], visible);
  if (!visible) {
    dzShow(state.frames[5], false); dzShow(state.frames[6], false); dzShow(state.frames[7], false); dzShow(state.frames[8], false); dzShow(state.frames[9], false); dzShow(state.frames[10], false); dzShow(state.frames[11], false); dzShow(state.frames[12], false);
  }
  if (visible) {
    dzSetAlpha(state.frames[0], 155);
    dzShow(state.frames[12], true);
  }
  for (let i = 101; i < 104; i++) dzShow(state.frames[i], visible);
}
function clearState(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue = [];
  onDialogFinished(state);
  showDialogFrames(state, false);
}

// ========== 虚拟分区：跳过整个对话 ==========
/**
 * 跳过指定玩家的所有非任务对话
 * 只跳过 NpcStartText、NpcCompleteText、afterCompleteDialog、Text 等普通文本对话
 * 任务对话不跳过整个对话框，但会跳过打字机效果直接显示完整文本
 */
function skipAllDialogForPlayer(targetPlayer: any): void {
  const targetPid = dzGetPlayerId(targetPlayer);
  if (targetPid < 0 || targetPid >= MAX_PLAYERS) return;

  const state = g_states[targetPid];
  if (!state || !state.isActive) return;

  // 检查当前对话是否是任务对话（需要玩家选择）
  const currentEntry = state.queue.length > 0 ? state.queue[0] : null;
  if (currentEntry && currentEntry.isQuest) {
    // 任务对话不跳过整个对话框，但跳过打字机效果
    skipTyping(state);
    return;
  }

  // 清空所有非任务对话，保留任务对话
  const newQueue: DialogEntry[] = [];
  for (const entry of state.queue) {
    if (entry.isQuest) {
      newQueue.push(entry);
    }
  }

  if (newQueue.length === state.queue.length) {
    // 没有可跳过的对话
    return;
  }

  // 如果清空后还有任务对话，保留它们并直接显示（跳过打字机）
  if (newQueue.length > 0) {
    state.queue = newQueue;
    // 播放下一个（任务对话），然后立即跳过打字机
    playEntry(state);
    // 直接跳过任务对话的打字机效果
    skipTyping(state);
  } else {
    // 完全清空
    clearState(state);
  }
}

// 初始化跳过键监听
let g_skipKeyInitialized = false;
function initSkipKeyListener(): void {
  if (g_skipKeyInitialized) return;
  g_skipKeyInitialized = true;
  
  registerKeyDown(KEY_SKIP_DIALOG, (player: any, key: number) => {
    // 只响应本地玩家
    const localPlayer = dzGetLocalPlayer();
    if (player !== localPlayer) return;
    
    // 只跳过按键玩家自己的对话框
    skipAllDialogForPlayer(localPlayer);
  });
}

// ========== 虚拟分区：播放流程 ==========
function playEntry(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const isFirstOpen = !state.isActive;
  state.isActive = true; state.waitingClick = false; state.clickCooldown = true;
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;
  if (!state.initialized) {
    dzLoadTocOnce();
    state.frames = createDialogFrames();
    state.initialized = true;
    bindQuestSyncHandlers(state);
  }
  showDialogFrames(state, true);
  if (isFirstOpen) Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, targetPlayer);
  const entry = state.queue[0];
  if (entry.isQuest && entry.questCallbacks) {
    setActivePlayerId(state.playerId);
    g_questCallbacksByPlayer[state.playerId] = { onAccept: entry.questCallbacks.onAccept, onReject: entry.questCallbacks.onReject };
    const buttonTexts = resolveQuestButtonTexts(entry.acceptText, entry.rejectText);
    setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject, dzGetLocalPlayer, dzPlayer);
  }
  if (!isLocal) {
    state.strLen = stringLengthCompat(entry.text);
    state.strNow = 0;
    dzTimerStart(state.tickTimer, TICK, true, () => {
      if (state.queue.length === 0) { dzTimerPause(state.tickTimer); return; }
      state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
      state.clickCooldown = false;
      if (state.strNow >= state.strLen) {
        dzTimerPause(state.tickTimer);
        if (!state.queue[0].isQuest) advanceDialog(state);
      }
    });
    return;
  }
  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], "");
  applyPortraitFrames(entry, state.frames, dzSetTexture, dzShow);
  state.strNow = 0;
  state.strLen = stringLengthCompat(entry.text);
  startTyping(state);
}

function skipTyping(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const entry = state.queue[0];
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  
  // 如果正在打字，先停止计时器并显示完整文本
  if (state.strNow < state.strLen) {
    dzTimerPause(state.tickTimer);
    state.strNow = state.strLen;
    if (localPlayer === targetPlayer) dzSetText(state.frames[3], entry.text);
  }
  
  // 对于任务对话框，确保按钮显示（即使打字已经完成）
  if (entry.isQuest) {
    showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
  } else { 
    state.waitingClick = true; 
    dzShow(state.frames[11], true); 
  }
}

function startTyping(state: PlayerDialogState): void {
  dzTimerStart(state.tickTimer, TICK, true, () => onTypingTick(state));
}
function onTypingTick(state: PlayerDialogState): void {
  if (state.queue.length === 0) { dzTimerPause(state.tickTimer); return; }
  state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
  state.clickCooldown = false;
  const entry = state.queue[0];
  if (!entry) { dzTimerPause(state.tickTimer); return; }
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;
  if (state.strNow >= state.strLen) {
    if (isLocal) dzSetText(state.frames[3], entry.text);
    dzTimerPause(state.tickTimer);
    if (entry.isQuest) showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    else { state.waitingClick = true; dzShow(state.frames[11], true); }
  } else if (isLocal) {
    dzSetText(state.frames[3], substringCompat(entry.text, 0, state.strNow));
  }
}
function advanceDialog(state: PlayerDialogState): void {
  showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  dzShow(state.frames[11], false);
  state.queue.shift();
  if (state.queue.length === 0) { onDialogFinished(state); showDialogFrames(state, false); } else playEntry(state);
}
function enqueue(state: PlayerDialogState, entry: DialogEntry): void {
  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) playEntry(state);
}

// ========== 虚拟分区：API ==========
export function initDialogSystem(): void {
  dzLoadTocOnce();
  for (let i = 0; i < MAX_PLAYERS; i++) {
    const state = ensureState(i);
    if (!state.initialized) { state.frames = createDialogFrames(); state.initialized = true; }
    bindQuestSyncHandlers(state);
  }
  initSkipKeyListener();
}
export function displayText(p: Player, title: string, text: string, duration: number, titleFontSize?: number, bodyFontSize?: number): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, createNormalDialogEntry(title, text, duration, "", "", "", titleFontSize ?? DEFAULT_TITLE_FONT_SIZE, bodyFontSize ?? DEFAULT_BODY_FONT_SIZE));
}
export function displayTextEx(
  p: Player, title: string, text: string, duration: number, leftPortrait: string, midPortrait: string, rightPortrait: string, titleFontSize?: number, bodyFontSize?: number,
): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, createNormalDialogEntry(title, text, duration, leftPortrait, midPortrait, rightPortrait, titleFontSize ?? DEFAULT_TITLE_FONT_SIZE, bodyFontSize ?? DEFAULT_BODY_FONT_SIZE));
}
export function clearDialog(p: Player): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state) return;
  clearState(state);
}
export function setDialogShowable(p: Player, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  state.canShow = visible;
  if (!visible && state.initialized) {
    for (let i = 0; i < 9; i++) dzShow(state.frames[i], false);
    for (let i = 101; i < 104; i++) dzShow(state.frames[i], false);
  }
}
export function setDialogBGTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[0], path);
}
export function setDialogTitleTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[1], path);
}
export function isDialogActive(p: Player): boolean {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return false;
  const state = g_states[pid];
  return !!state && state.isActive;
}
export function setDialogFinishCallback(p: Player, callback: () => void): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  ensureState(pid).onFinish = callback;
}
export function displayQuest(
  p: Player, title: string, text: string, onAccept: () => void, onReject: () => void, acceptText?: string, rejectText?: string,
): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, createQuestDialogEntry(title, text, DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE, { onAccept, onReject }, acceptText, rejectText));
}

