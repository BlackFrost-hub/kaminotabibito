import { Sound3DII_Mp3PlayReuse } from "../../../lib/扩展函数/封装函数/02．音效系统/index";
import { resetActivePlayerIdIfMatch, setActivePlayerId } from "./16．对话框同步状态";
import { STEP_LEN, TICK, nextTypingProgress, stringLengthCompat, substringCompat } from "./02．打字机效果";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { DialogEntry, onDialogFinished, PlayerDialogState } from "./05．对话框业务逻辑";
import { createDialogFrames } from "./18．对话框渲染-创建帧";
import {
  DEFAULT_FONT,
  DIALOG_OPEN_SOUND,
  dzGetLocalPlayer,
  dzPlayer,
  dzSetAlpha,
  dzSetFont,
  dzSetText,
  dzSetTexture,
  dzShow,
  dzTimerCreate,
  dzTimerPause,
  dzTimerStart,
  dzLoadTocOnce,
  g_questCallbacksByPlayer,
  g_states,
  syncQuestCallbacksTableFromQueueHead,
} from "./17．对话框渲染-Dz与状态";

let g_bindQuestSyncHandlers: ((state: PlayerDialogState) => void) | undefined;
export function setQuestSyncHandlersBinder(fn: (state: PlayerDialogState) => void): void {
  g_bindQuestSyncHandlers = fn;
}

function bindQuestSyncHandlers(state: PlayerDialogState): void {
  if (g_bindQuestSyncHandlers) g_bindQuestSyncHandlers(state);
}

function showContinueHint(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;
  dzShow(state.frames[11], visible);
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
    questSyncHandlersBound: false,
    isActive: false,
    clickCooldown: false,
    waitingClick: false,
  };
  g_states[playerId] = state;
  return state;
}

export function showDialogFrames(state: PlayerDialogState, visible: boolean): void {
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
    dzShow(state.frames[5], false);
    dzShow(state.frames[6], false);
    dzShow(state.frames[7], false);
    dzShow(state.frames[8], false);
    dzShow(state.frames[9], false);
    dzShow(state.frames[10], false);
    dzShow(state.frames[11], false);
    dzShow(state.frames[12], false);
  }
  if (visible) {
    dzSetAlpha(state.frames[0], 155);
    dzShow(state.frames[12], true);
  }
  for (let i = 101; i < 104; i++) dzShow(state.frames[i], visible);
}

export function clearState(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue = [];
  onDialogFinished(state);
  showDialogFrames(state, false);
}

export function playEntry(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const isFirstOpen = !state.isActive;
  state.isActive = true;
  state.waitingClick = false;
  state.clickCooldown = true;

  if (!state.initialized) {
    dzLoadTocOnce();
    state.frames = createDialogFrames(state.playerId);
    state.initialized = true;
    bindQuestSyncHandlers(state);
  }

  showDialogFrames(state, true);
  if (isFirstOpen) Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, dzPlayer(state.playerId));

  const entry = state.queue[0];
  setActivePlayerId(state.playerId);

  if (entry.isQuest && entry.questCallbacks) {
    syncQuestCallbacksTableFromQueueHead(state);
    const buttonTexts = resolveQuestButtonTexts(entry.acceptText, entry.rejectText);
    setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject);
  }

  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], "");
  applyPortraitFrames(entry, state, dzGetLocalPlayer, dzPlayer, dzSetTexture, dzShow);

  state.strNow = 0;
  state.strLen = stringLengthCompat(entry.text);
  startTyping(state);
}

export function skipTyping(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const entry = state.queue[0];

  if (state.strNow < state.strLen) {
    dzTimerPause(state.tickTimer);
    state.strNow = state.strLen;
    dzSetText(state.frames[3], entry.text);
  }

  if (entry.isQuest) {
    syncQuestCallbacksTableFromQueueHead(state);
    showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
  } else {
    state.waitingClick = true;
    setActivePlayerId(state.playerId);
    showContinueHint(state, true);
  }
  state.clickCooldown = false;
}

function startTyping(state: PlayerDialogState): void {
  dzTimerStart(state.tickTimer, TICK, true, () => onTypingTick(state));
}

function onTypingTick(state: PlayerDialogState): void {
  if (state.queue.length === 0) {
    dzTimerPause(state.tickTimer);
    return;
  }
  state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
  state.clickCooldown = false;
  const entry = state.queue[0];
  if (!entry) {
    dzTimerPause(state.tickTimer);
    return;
  }
  if (state.strNow >= state.strLen) {
    dzSetText(state.frames[3], entry.text);
    dzTimerPause(state.tickTimer);
    if (entry.isQuest) {
      syncQuestCallbacksTableFromQueueHead(state);
      showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    } else {
      state.waitingClick = true;
      setActivePlayerId(state.playerId);
      showContinueHint(state, true);
    }
  } else {
    dzSetText(state.frames[3], substringCompat(entry.text, 0, state.strNow));
  }
}

export function advanceDialog(state: PlayerDialogState): void {
  showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  showContinueHint(state, false);
  state.queue.shift();
  if (state.queue.length === 0) {
    resetActivePlayerIdIfMatch(state.playerId);
    onDialogFinished(state);
    showDialogFrames(state, false);
  } else {
    playEntry(state);
  }
}

export function enqueue(state: PlayerDialogState, entry: DialogEntry): void {
  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) playEntry(state);
}
