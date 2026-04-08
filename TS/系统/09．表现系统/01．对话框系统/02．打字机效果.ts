/**
 * 打字机效果模块
 * 负责逐字显示动画、跳过逻辑、完成回调
 */

import {
  PlayerDialogState,
  dzTimerStart,
  dzTimerPause,
  dzSetText,
  dzShow,
  dzGetLocalPlayer,
  dzPlayer,
  dzSubString,
} from "./01．对话框渲染核心";

// ────────────────────────────────────────────────
// 常量
// ────────────────────────────────────────────────

/** 打字机每帧步进（字符数） */
export const STEP_LEN = 2;

/** 打字机帧间隔（秒） */
export const TICK = 0.03;

// ────────────────────────────────────────────────
// 回调类型
// ────────────────────────────────────────────────

export interface TypingCallbacks {
  /** 打字完成时的回调 */
  onComplete: (state: PlayerDialogState) => void;
  /** 显示"点击以继续"提示的回调 */
  onShowContinueHint: (state: PlayerDialogState, show: boolean) => void;
  /** 显示任务按钮的回调 */
  onShowQuestButtons: (state: PlayerDialogState, show: boolean) => void;
}

let g_callbacks: TypingCallbacks | null = null;

export function setTypingCallbacks(callbacks: TypingCallbacks): void {
  g_callbacks = callbacks;
}

// ────────────────────────────────────────────────
// 打字机控制
// ────────────────────────────────────────────────

/**
 * 开始打字机效果
 */
export function startTyping(state: PlayerDialogState): void {
  dzTimerStart(state.tickTimer, TICK, true, () => {
    onTypingTick(state);
  });
}

/**
 * 跳过打字机，直接显示完整文本
 */
export function skipTyping(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  if (state.strNow >= state.strLen) return;

  dzTimerPause(state.tickTimer);
  state.strNow = state.strLen;

  const entry = state.queue[0];
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);

  if (localPlayer === targetPlayer) {
    dzSetText(state.frames[3], entry.text);
  }

  onTypingComplete(state);
}

/**
 * 检查是否正在打字中
 */
export function isTyping(state: PlayerDialogState): boolean {
  return state.strNow < state.strLen;
}

/**
 * 获取当前打字进度（0-1）
 */
export function getTypingProgress(state: PlayerDialogState): number {
  if (state.strLen === 0) return 1;
  return state.strNow / state.strLen;
}

// ────────────────────────────────────────────────
// 内部实现
// ────────────────────────────────────────────────

function onTypingTick(state: PlayerDialogState): void {
  if (state.queue.length === 0) {
    dzTimerPause(state.tickTimer);
    return;
  }

  state.strNow += STEP_LEN;
  state.clickCooldown = false; // 打字机已跑起来，解除点击冷却

  const entry = state.queue[0];
  if (!entry) {
    dzTimerPause(state.tickTimer);
    return;
  }

  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;

  if (state.strNow >= state.strLen) {
    // 文字已全部显示
    if (isLocal) {
      dzSetText(state.frames[3], entry.text);
    }
    dzTimerPause(state.tickTimer);
    onTypingComplete(state);
  } else {
    // 仍在打字中
    if (isLocal) {
      const partial = dzSubString(entry.text, 0, state.strNow);
      dzSetText(state.frames[3], partial);
    }
  }
}

function onTypingComplete(state: PlayerDialogState): void {
  const entry = state.queue[0];
  if (!entry) return;

  if (entry.isQuest) {
    // 任务模式：显示接受/拒绝按钮
    if (g_callbacks) {
      g_callbacks.onShowQuestButtons(state, true);
    }
  } else {
    // 普通模式：等待玩家点击
    state.waitingClick = true;
    if (g_callbacks) {
      g_callbacks.onShowContinueHint(state, true);
    }
  }

  if (g_callbacks) {
    g_callbacks.onComplete(state);
  }
}

// ────────────────────────────────────────────────
// 工具函数
// ────────────────────────────────────────────────

/**
 * 重置打字状态
 */
export function resetTyping(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  state.strNow = 0;
  state.strLen = 0;
  state.waitingClick = false;
}

/**
 * 设置新的文本长度
 */
export function setTextLength(state: PlayerDialogState, length: number): void {
  state.strLen = length;
  state.strNow = 0;
}
