const jass = require("jass.common") as any;

import { frameSetScriptByCode, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";
import { stringLengthCompat } from "./02．打字机效果";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { Frame, PlayerDialogState, onDialogFinished, resetDialogActiveFlagsKeepOnFinish } from "./05．对话框业务逻辑";
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

function handleDialogPanelClick(state: PlayerDialogState): void {
  if (state.strNow < state.strLen) {
    skipTyping(state);
    return;
  }
  if (state.clickCooldown) return;
  if (state.waitingClick && state.queue.length > 0 && !state.queue[0].isQuest) {
    state.waitingClick = false;
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
  jass.DestroyTimer(t);
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
      jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP0);
      return;
    case 1:
      jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP1);
      return;
    case 2:
      jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP2);
      return;
    case 3:
      jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP3);
      return;
    default:
      jass.PauseTimer(t);
      jass.DestroyTimer(t);
      g_skipKeyCooldownTimers[pid] = undefined;
      g_skipKeyCooldown[pid] = false;
      return;
  }
}

function fastForwardQueueToLastNormalLine(state: PlayerDialogState): void {
  if (state.queue.length <= 1) return;
  const last = state.queue[state.queue.length - 1];
  if (!last || last.isQuest) return;
  state.queue = [last];

  showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  showContinueHintLocal(state, false);
  dzTimerPause(state.tickTimer);

  const entry = state.queue[0]!;
  state.strLen = stringLengthCompat(entry.text);
  state.strNow = state.strLen;
  state.waitingClick = true;
  state.clickCooldown = false;
  setActivePlayerId(state.playerId);

  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize ?? DEFAULT_TITLE_FONT_SIZE);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize ?? DEFAULT_BODY_FONT_SIZE);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], entry.text);
  showDialogFrames(state, true);
  applyPortraitFrames(entry, state, dzGetLocalPlayer, dzPlayer, dzSetTexture, dzShow);
  showContinueHintLocal(state, true);
}

function skipDialogLocal(): void {
  const triggerPlayer = (japi as any).DzGetTriggerKeyPlayer();
  if (!triggerPlayer) return;
  const triggerPid = dzGetPlayerId(triggerPlayer);
  if (triggerPid == null || triggerPid < 0 || triggerPid >= MAX_PLAYERS) return;
  if (g_skipKeyCooldown[triggerPid]) return;
  const state = g_states[triggerPid];
  if (!state || state.queue.length === 0) return;

  const isLocal = dzGetLocalPlayer() === triggerPlayer;

  startSkipKeyCooldown(triggerPid);
  dzTimerPause(state.tickTimer);

  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx >= 0) {
    if (state.strNow < state.strLen) {
      state.strNow = state.strLen;
      const head = state.queue[0];
      if (head !== undefined) dzSetText(state.frames[3], head.text);
    }
    const questEntry = state.queue[questIdx];
    dzSetFont(state.frames[2], DEFAULT_FONT, questEntry.titleFontSize ?? DEFAULT_TITLE_FONT_SIZE);
    dzSetFont(state.frames[3], DEFAULT_FONT, questEntry.bodyFontSize ?? DEFAULT_BODY_FONT_SIZE);
    dzSetText(state.frames[2], questEntry.title);
    dzSetText(state.frames[3], questEntry.text);
    showDialogFrames(state, true);
    applyPortraitFrames(questEntry, state, dzGetLocalPlayer, dzPlayer, dzSetTexture, dzShow);
    const buttonTexts = resolveQuestButtonTexts(questEntry.acceptText, questEntry.rejectText);
    setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject);
    showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    return;
  }

  if (state.queue.length > 1) {
    fastForwardQueueToLastNormalLine(state);
    return;
  }

  if (state.strNow < state.strLen) {
    skipTyping(state);
    return;
  }

  if (state.queue.length > 0 && !state.queue[0].isQuest) {
    handleDialogPanelClick(state);
  }
}

let g_skipKeyInitialized = false;
export function initSkipKeyListener(): void {
  if (g_skipKeyInitialized) return;
  g_skipKeyInitialized = true;
  // sync=true：全房回调都用触发玩家（DzGetTriggerKeyPlayer）定位 state，所有客户端对称修改。
  // 禁止在 sync=true 回调里调用 DzClickFrame（会导致每客户端各触发一次重复点击）。
  registerKeyEventByCode(KEY_SKIP_DIALOG, KEY_STATE.DOWN, true, skipDialogLocal);
}

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
