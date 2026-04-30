const jass = require("jass.common") as any;

import { frameSetScriptByCode, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";
import { stringLengthCompat } from "./02．打字机效果";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { DialogEntry, Frame, PlayerDialogState, onDialogFinished, resetDialogActiveFlagsKeepOnFinish } from "./05．对话框业务逻辑";
import { resetActivePlayerIdIfMatch, setActivePlayerId } from "./16．对话框同步状态";
import { setDialogPanelHitBinder } from "./18．对话框渲染-创建帧";
import {
  DEFAULT_BODY_FONT_SIZE,
  DEFAULT_FONT,
  DEFAULT_TITLE_FONT_SIZE,
  dzGetLocalPlayer,
  dzGetPlayerId,
  dzPlayer,
  dzSetFont,
  dzSetText,
  dzSetTexture,
  dzShow,
  dzTimerPause,
  findFirstQuestEntryIndex,
  g_questCallbacksByPlayer,
  g_states,
  japi,
  KEY_SKIP_DIALOG,
  MAX_PLAYERS,
} from "./17．对话框渲染-Dz与状态";
import { advanceDialog, showDialogFrames, skipTyping, playEntry } from "./19．对话框渲染-播放与状态管理";
import { safeTimerStart, safeDestroyTimer } from "../../../系统/00．核心系统/07．联机安全工具";

// ========== 虚拟分区：队列索引/当前页查找辅助 ==========

function getCurrentEntry(state: PlayerDialogState): DialogEntry | undefined {
  return state.queue[state.currentIndex];
}

function findLastNormalEntryIndex(state: PlayerDialogState): number {
  for (let i = state.queue.length - 1; i >= 0; i--) {
    if (!state.queue[i].isQuest) return i;
  }
  return -1;
}

/** 统一渲染当前页（标题/正文/字体/立绘），不包含 quest buttons / continue hint（由调用方决定） */
function renderCurrentEntry(state: PlayerDialogState, revealFullText: boolean): void {
  const entry = state.queue[state.currentIndex];
  if (!entry) return;

  if (revealFullText) {
    state.strLen = stringLengthCompat(entry.text);
    state.strNow = state.strLen;
    state.waitingClick = true;
    state.clickCooldown = false;
  }

  setActivePlayerId(state.playerId);
  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize ?? DEFAULT_TITLE_FONT_SIZE);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize ?? DEFAULT_BODY_FONT_SIZE);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], revealFullText ? entry.text : "");
  showDialogFrames(state, true);
  applyPortraitFrames(entry, state, dzGetLocalPlayer, dzPlayer, dzSetTexture, dzShow);
}

/** 统一收尾：清空 queue/索引/活跃标记 → finish → 隐藏 UI */
function finishDialogAndCleanup(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue = [];
  state.currentIndex = 0;
  state.strNow = 0;
  state.strLen = 0;
  onDialogFinished(state);
  showDialogFrames(state, false);
}

// ========== 虚拟分区：任务接受/拒绝按钮回调调度 ==========

function resolveQuestCallbackByPlayerId(playerId: number): { state: PlayerDialogState; questIdx: number; onAccept: () => void; onReject: () => void } | undefined {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return undefined;
  const state = g_states[playerId];
  if (!state) return undefined;
  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx < 0) return undefined;
  const entry = state.queue[questIdx];
  const cb = entry.questCallbacks!;
  return { state, questIdx, onAccept: cb.onAccept, onReject: cb.onReject };
}

function runQuestAcceptForPlayer(playerId: number): void {
  const ctx = resolveQuestCallbackByPlayerId(playerId);
  if (!ctx) return;
  const { state, questIdx, onAccept } = ctx;
  const hadRemainingEntries = state.queue.length > questIdx + 1;
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue.splice(0, questIdx + 1);
  state.currentIndex = 0;
  state.strNow = 0;
  state.strLen = 0;
  resetDialogActiveFlagsKeepOnFinish(state);
  onAccept();
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  }
  if (state.queue.length === 0) {
    onDialogFinished(state);
    if (localPlayer === targetPlayer) showDialogFrames(state, false);
  } else if (state.isActive) {
    return;
  } else if (hadRemainingEntries || state.queue.length > 0) {
    playEntry(state);
  }
}

function runQuestRejectForPlayer(playerId: number): void {
  const ctx = resolveQuestCallbackByPlayerId(playerId);
  if (!ctx) return;
  const { state, questIdx, onReject } = ctx;
  const hadRemainingEntries = state.queue.length > questIdx + 1;
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue.splice(0, questIdx + 1);
  state.currentIndex = 0;
  state.strNow = 0;
  state.strLen = 0;
  resetDialogActiveFlagsKeepOnFinish(state);
  onReject();
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  }
  if (state.queue.length === 0) {
    onDialogFinished(state);
    if (localPlayer === targetPlayer) showDialogFrames(state, false);
  } else if (state.isActive) {
    return;
  } else if (hadRemainingEntries || state.queue.length > 0) {
    playEntry(state);
  }
}

function questAcceptCallbackP0(): void { runQuestAcceptForPlayer(0); }
function questAcceptCallbackP1(): void { runQuestAcceptForPlayer(1); }
function questAcceptCallbackP2(): void { runQuestAcceptForPlayer(2); }
function questAcceptCallbackP3(): void { runQuestAcceptForPlayer(3); }
function questRejectCallbackP0(): void { runQuestRejectForPlayer(0); }
function questRejectCallbackP1(): void { runQuestRejectForPlayer(1); }
function questRejectCallbackP2(): void { runQuestRejectForPlayer(2); }
function questRejectCallbackP3(): void { runQuestRejectForPlayer(3); }

(globalThis as any).QuestAcceptCallbackP0 = questAcceptCallbackP0;
(globalThis as any).QuestAcceptCallbackP1 = questAcceptCallbackP1;
(globalThis as any).QuestAcceptCallbackP2 = questAcceptCallbackP2;
(globalThis as any).QuestAcceptCallbackP3 = questAcceptCallbackP3;
(globalThis as any).QuestRejectCallbackP0 = questRejectCallbackP0;
(globalThis as any).QuestRejectCallbackP1 = questRejectCallbackP1;
(globalThis as any).QuestRejectCallbackP2 = questRejectCallbackP2;
(globalThis as any).QuestRejectCallbackP3 = questRejectCallbackP3;

// ========== 虚拟分区：面板点击交互处理 ==========

function handleDialogPanelClick(state: PlayerDialogState): void {
  // 情况 A：打字中 → 只补全
  if (state.strNow < state.strLen) {
    skipTyping(state);
    return;
  }
  if (state.clickCooldown) return;

  const entry = state.queue[state.currentIndex];

  // 情况 C：任务页，打字完成 → 不前进
  if (entry.isQuest) return;

  // 情况 B：普通页，打字完成 → 前进
  if (state.waitingClick) {
    state.waitingClick = false;
    // 情况 B2：已经是最后一页 → 直接结束
    if (state.currentIndex >= state.queue.length - 1) {
      finishDialogAndCleanup(state);
      return;
    }
    // 情况 B1：还有下一��� → 前进
    advanceDialog(state);
  }
}

function runDialogPanelHitForPlayer(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  const state = g_states[playerId];
  if (!state) return;
  handleDialogPanelClick(state);
}

function dialogPanelHitCallbackP0(): void { runDialogPanelHitForPlayer(0); }
function dialogPanelHitCallbackP1(): void { runDialogPanelHitForPlayer(1); }
function dialogPanelHitCallbackP2(): void { runDialogPanelHitForPlayer(2); }
function dialogPanelHitCallbackP3(): void { runDialogPanelHitForPlayer(3); }

(globalThis as any).DialogPanelHitCallbackP0 = dialogPanelHitCallbackP0;
(globalThis as any).DialogPanelHitCallbackP1 = dialogPanelHitCallbackP1;
(globalThis as any).DialogPanelHitCallbackP2 = dialogPanelHitCallbackP2;
(globalThis as any).DialogPanelHitCallbackP3 = dialogPanelHitCallbackP3;

function showContinueHintLocal(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;
  dzShow(state.frames[11], visible);
}

export function bindDialogPanelHitFrame(_hitFrame: Frame): void {
  return;
}

// ========== 虚拟分区：~ 键跳过冷却 timer ==========

const SKIP_KEY_COOLDOWN_SECONDS = 0.12;
const g_skipKeyCooldown: boolean[] = [];
const g_skipKeyCooldownTimers: any[] = [];

function finishSkipKeyCooldownForPlayer(pid: number): void {
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  g_skipKeyCooldown[pid] = false;
  const t = g_skipKeyCooldownTimers[pid];
  g_skipKeyCooldownTimers[pid] = undefined;
  if (!t) return;
  jass.PauseTimer(t);
  safeDestroyTimer(t);
}

function skipKeyCooldownCallbackP0(): void { finishSkipKeyCooldownForPlayer(0); }
function skipKeyCooldownCallbackP1(): void { finishSkipKeyCooldownForPlayer(1); }
function skipKeyCooldownCallbackP2(): void { finishSkipKeyCooldownForPlayer(2); }
function skipKeyCooldownCallbackP3(): void { finishSkipKeyCooldownForPlayer(3); }

function startSkipKeyCooldown(pid: number): void {
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  g_skipKeyCooldown[pid] = true;
  const t = jass.CreateTimer();
  g_skipKeyCooldownTimers[pid] = t;
  switch (pid) {
    case 0:
      safeTimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP0);
      return;
    case 1:
      safeTimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP1);
      return;
    case 2:
      safeTimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP2);
      return;
    case 3:
      safeTimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP3);
      return;
    default:
      jass.PauseTimer(t);
      safeDestroyTimer(t);
      g_skipKeyCooldownTimers[pid] = undefined;
      g_skipKeyCooldown[pid] = false;
      return;
  }
}

// ========== 虚拟分区：~ 键 skip 核心（跳到任务页/最后一页/结束对话） ==========
// ~ 保持 sync=true，但只用 currentIndex 跳页，不再裁剪 queue。

function skipDialogLocal(): void {
  const triggerPlayer = (japi as any).DzGetTriggerKeyPlayer();
  if (!triggerPlayer) return;
  const triggerPid = dzGetPlayerId(triggerPlayer);
  if (triggerPid == null || triggerPid < 0 || triggerPid >= MAX_PLAYERS) return;
  if (g_skipKeyCooldown[triggerPid]) return;
  const state = g_states[triggerPid];
  if (!state || state.queue.length === 0) return;

  startSkipKeyCooldown(triggerPid);
  dzTimerPause(state.tickTimer);

  const questIdx = findFirstQuestEntryIndex(state); // 从 currentIndex 往后找
  const currentEntry = state.queue[state.currentIndex];

  // 情况 A：打字中 → 补全
  if (state.strNow < state.strLen) {
    state.strNow = state.strLen;
    if (currentEntry !== undefined) dzSetText(state.frames[3], currentEntry.text);
  }

  // 情况 B：存在任务页（在当前位置之后）→ 跳到任务页
  if (questIdx >= 0) {
    state.currentIndex = questIdx;
    renderCurrentEntry(state, true);
    const questEntry = state.queue[questIdx];
    const buttonTexts = resolveQuestButtonTexts(questEntry.acceptText, questEntry.rejectText);
    setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject);
    showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    return;
  }

  // 情况 C：无任务页 → 跳到普通最后一页
  const lastNormalIdx = findLastNormalEntryIndex(state);
  if (lastNormalIdx >= 0 && lastNormalIdx !== state.currentIndex) {
    state.currentIndex = lastNormalIdx;
    renderCurrentEntry(state, true);
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    showContinueHintLocal(state, true);
    return;
  }

  // 情况 D：已在普通最后一页（或单页），打字已完成 → 结束对话
  if (currentEntry !== undefined && !currentEntry.isQuest) {
    finishDialogAndCleanup(state);
    return;
  }

  // 情况 E：已在任务页，打字已完成 → 保持任务按钮态，不结束
}

let g_skipKeyInitialized = false;
export function initSkipKeyListener(): void {
  if (g_skipKeyInitialized) return;
  g_skipKeyInitialized = true;
  registerKeyEventByCode(KEY_SKIP_DIALOG, KEY_STATE.DOWN, true, skipDialogLocal);
}

// ========== 虚拟分区：任务按钮/面板/文本帧的点击回调绑定 ==========

export function bindQuestSyncHandlersImpl(state: PlayerDialogState): void {
  if (state.questSyncHandlersBound || !state.frames || state.frames.length === 0) return;
  let acceptCallback: () => void;
  let rejectCallback: () => void;
  let panelCallback: () => void;
  switch (state.playerId) {
    case 0:
      acceptCallback = questAcceptCallbackP0;
      rejectCallback = questRejectCallbackP0;
      panelCallback = dialogPanelHitCallbackP0;
      break;
    case 1:
      acceptCallback = questAcceptCallbackP1;
      rejectCallback = questRejectCallbackP1;
      panelCallback = dialogPanelHitCallbackP1;
      break;
    case 2:
      acceptCallback = questAcceptCallbackP2;
      rejectCallback = questRejectCallbackP2;
      panelCallback = dialogPanelHitCallbackP2;
      break;
    case 3:
      acceptCallback = questAcceptCallbackP3;
      rejectCallback = questRejectCallbackP3;
      panelCallback = dialogPanelHitCallbackP3;
      break;
    default:
      return;
  }
  frameSetScriptByCode(state.frames[6], 1, acceptCallback, true);
  frameSetScriptByCode(state.frames[8], 1, rejectCallback, true);
  frameSetScriptByCode(state.frames[4], 1, panelCallback, true);
  frameSetScriptByCode(state.frames[3], 1, panelCallback, true);
  frameSetScriptByCode(state.frames[2], 1, panelCallback, true);
  frameSetScriptByCode(state.frames[11], 1, panelCallback, true);
  frameSetScriptByCode(state.frames[12], 1, panelCallback, true);
  state.questSyncHandlersBound = true;
}

setDialogPanelHitBinder(bindDialogPanelHitFrame);
