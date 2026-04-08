/**
 * 对话框业务逻辑
 * 负责内部状态管理、对话播放控制
 */

import { Sound3DII_Mp3PlayReuse } from "../../00．核心系统/02．音效函数";
import {
  Player,
  PlayerDialogState,
  MAX_PLAYERS,
  DIALOG_OPEN_SOUND,
  ensureState,
  dzGetPlayerId,
  dzPlayer,
  dzGetLocalPlayer,
  dzLoadTocOnce,
  createDialogFrames,
  showDialogFrames,
  onDialogEnd,
  clearState,
  DialogEntry,
  dzSetText,
  dzSetFont,
  dzShow,
} from "./01．对话框渲染核心";
import {
  setActivePlayerId,
  getNpcUnit,
  createBubbleEffect,
} from "../../09．表现系统/04．NPC对话状态池";
import {
  startTyping,
  skipTyping,
  isTyping,
  setTypingCallbacks,
  setTextLength,
} from "./02．打字机效果";
import { updatePortraits } from "./03．对话框立绘系统";
import {
  showQuestButtons,
  hideQuestButtons,
  registerQuestCallbacks,
  createQuestEntry,
  setQuestButtonText,
} from "./04．任务对话框";

// ────────────────────────────────────────────────
// 背景点击处理
// ────────────────────────────────────────────────

/**
 * 背景点击回调 - 处理打字机跳过和对话推进
 * 注意：此函数从 sync=true 的帧回调中调用，所有客户端都会执行。
 * 但对话框是本地私有的（每个玩家独立），非本地客户端直接返回。
 */
export function onBackgroundClick(state: PlayerDialogState): void {
  // 只有对话框所属玩家的本地客户端才处理点击
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  if (state.clickCooldown) return;

  if (isTyping(state)) {
    skipTyping(state);
  } else if (state.waitingClick && state.queue.length > 0) {
    const entry = state.queue[0];
    if (!entry.isQuest) {
      state.waitingClick = false;
      advanceDialog(state);
    }
  }
}

// ────────────────────────────────────────────────
// 播放控制
// ────────────────────────────────────────────────

/**
 * 播放队列中当前对话条目
 */
export function playEntry(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;

  setActivePlayerId(state.playerId);
  const isFirstOpen = !state.isActive;

  state.isActive = true;
  state.waitingClick = false;
  state.clickCooldown = true;

  // 首次展开创建气泡特效
  if (isFirstOpen) {
    const npcUnit = getNpcUnit(state.playerId);
    if (npcUnit) {
      createBubbleEffect(state.playerId, npcUnit);
    }
  }

  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;

  // 帧创建、打字机 timer、任务按钮注册 —— 只在本地玩家执行
  // 原因：这些操作要么是纯 UI（帧创建/显示），要么含 TimerStart（游戏状态）。
  // 通过 sync=true 回调进入 playEntry 的非本地客户端不应执行这些操作，
  // 否则 TimerStart 在不同 tick 被调用 → desync。
  if (!isLocal) return;

  // 帧创建
  if (!state.initialized) {
    dzLoadTocOnce();
    state.frames = createDialogFrames(onBackgroundClick);
    state.initialized = true;
  }

  showDialogFrames(state, true);

  if (isFirstOpen) {
    Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, targetPlayer);
  }

  const entry = state.queue[0];

  dzSetFont(state.frames[2], "UI\\uizt.ttf", entry.titleFontSize);
  dzSetFont(state.frames[3], "UI\\uizt.ttf", entry.bodyFontSize);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], "");
  updatePortraits(state, entry.leftTex, entry.midTex, entry.rightTex);

  setTextLength(state, entry.text.length);

  dzShow(state.frames[11], false);
  hideQuestButtons(state);

  if (entry.isQuest && entry.questCallbacks) {
    registerQuestCallbacks(state, entry.questCallbacks);
    setQuestButtonText(state, entry.acceptText || "接受任务", entry.rejectText || "拒绝任务");
  }

  startTyping(state);
}

/**
 * 推进到下一条对话
 */
export function advanceDialog(state: PlayerDialogState): void {
  hideQuestButtons(state);

  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    dzShow(state.frames[11], false);
  }

  state.queue.shift();

  if (state.queue.length === 0) {
    onDialogEnd(state.playerId);
  } else {
    playEntry(state);
  }
}

/**
 * 添加对话到队列
 */
export function enqueue(
  state: PlayerDialogState,
  title: string,
  text: string,
  waitTime: number,
  leftTex: string,
  midTex: string,
  rightTex: string,
  titleFontSize: number,
  bodyFontSize: number,
): void {
  const entry: DialogEntry = {
    title,
    text,
    waitTime,
    leftTex,
    midTex,
    rightTex,
    titleFontSize,
    bodyFontSize,
    isQuest: false,
  };
  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) {
    playEntry(state);
  }
}

// ────────────────────────────────────────────────
// 初始化打字机回调
// ────────────────────────────────────────────────

export function initTypingCallbacks(): void {
  setTypingCallbacks({
    onComplete: () => {},
    onShowContinueHint: (state, show) => {
      const localPlayer = dzGetLocalPlayer();
      const targetPlayer = dzPlayer(state.playerId);
      if (localPlayer === targetPlayer) {
        dzShow(state.frames[11], show);
      }
    },
    onShowQuestButtons: (state, show) => {
      showQuestButtons(state, show);
    },
  });
}
