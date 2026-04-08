/**
 * 任务对话框模块
 * 负责任务接受/拒绝按钮的管理和回调
 */

import { frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";
import {
  PlayerDialogState,
  DialogEntry,
  dzShow,
  dzGetLocalPlayer,
  dzPlayer,
  onDialogEnd,
  dzSetText,
} from "./01．对话框渲染核心";

// ────────────────────────────────────────────────
// 任务回调类型
// ────────────────────────────────────────────────

export interface QuestCallbacks {
  onAccept: () => void;
  onReject: () => void;
}

// ────────────────────────────────────────────────
// 按钮帧索引
// ────────────────────────────────────────────────

/** 接受按钮底图 */
const ACCEPT_BG_IDX = 5;
/** 接受按钮命中层 */
const ACCEPT_BTN_IDX = 6;
/** 拒绝按钮底图 */
const REJECT_BG_IDX = 7;
/** 拒绝按钮命中层 */
const REJECT_BTN_IDX = 8;
/** 接受按钮文字标签 */
const ACCEPT_LABEL_IDX = 9;
/** 拒绝按钮文字标签 */
const REJECT_LABEL_IDX = 10;

// ────────────────────────────────────────────────
// 按钮显示控制
// ────────────────────────────────────────────────

/**
 * 显示/隐藏任务接受拒绝按钮
 * @param state 玩家对话框状态
 * @param visible 是否显示
 */
export function showQuestButtons(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  dzShow(state.frames[ACCEPT_BG_IDX], visible);
  dzShow(state.frames[ACCEPT_BTN_IDX], visible);
  dzShow(state.frames[ACCEPT_LABEL_IDX], visible);
  dzShow(state.frames[REJECT_BG_IDX], visible);
  dzShow(state.frames[REJECT_BTN_IDX], visible);
  dzShow(state.frames[REJECT_LABEL_IDX], visible);
}

/**
 * 设置任务按钮文本
 * @param state 玩家对话框状态
 * @param acceptText 接受按钮文本
 * @param rejectText 拒绝按钮文本
 */
export function setQuestButtonText(state: PlayerDialogState, acceptText: string, rejectText: string): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  dzSetText(state.frames[ACCEPT_LABEL_IDX], acceptText);
  dzSetText(state.frames[REJECT_LABEL_IDX], rejectText);
}

/**
 * 隐藏任务按钮
 * @param state 玩家对话框状态
 */
export function hideQuestButtons(state: PlayerDialogState): void {
  showQuestButtons(state, false);
}

/**
 * 检查任务按钮是否显示
 * @param state 玩家对话框状态
 */
export function areQuestButtonsVisible(state: PlayerDialogState): boolean {
  // 由于无法直接查询显示状态，通过状态推断
  const entry = state.queue[0];
  return entry?.isQuest === true;
}

// ────────────────────────────────────────────────
// 回调注册
// ────────────────────────────────────────────────

/**
 * 注册任务按钮回调
 * @param state 玩家对话框状态
 * @param callbacks 接受/拒绝回调
 */
export function registerQuestCallbacks(
  state: PlayerDialogState,
  callbacks: QuestCallbacks
): void {
  // 接受按钮回调
  frameSetScriptByCode(state.frames[ACCEPT_BTN_IDX], 1, () => {
    // 出队并结束对话框
    state.queue.shift();
    hideQuestButtons(state);
    onDialogEnd(state.playerId);
    callbacks.onAccept();
  }, true);

  // 拒绝按钮回调
  frameSetScriptByCode(state.frames[REJECT_BTN_IDX], 1, () => {
    // 出队并结束对话框
    state.queue.shift();
    hideQuestButtons(state);
    onDialogEnd(state.playerId);
    callbacks.onReject();
  }, true);
}

/**
 * 清除任务按钮回调（设置为无操作）
 * @param state 玩家对话框状态
 */
export function clearQuestCallbacks(state: PlayerDialogState): void {
  frameSetScriptByCode(state.frames[ACCEPT_BTN_IDX], 1, () => {}, true);
  frameSetScriptByCode(state.frames[REJECT_BTN_IDX], 1, () => {}, true);
}

// ────────────────────────────────────────────────
// 任务条目创建
// ────────────────────────────────────────────────

/**
 * 创建任务对话框条目
 * @param title 任务标题
 * @param text 任务描述
 * @param callbacks 接受/拒绝回调
 * @param titleFontSize 标题字体大小
 * @param bodyFontSize 正文字体大小
 * @param acceptText 接受按钮文本（默认"接受任务"）
 * @param rejectText 拒绝按钮文本（默认"拒绝任务"）
 */
export function createQuestEntry(
  title: string,
  text: string,
  callbacks: QuestCallbacks,
  titleFontSize: number,
  bodyFontSize: number,
  acceptText?: string,
  rejectText?: string,
): DialogEntry {
  return {
    title,
    text,
    waitTime: 0,
    leftTex: "",
    midTex: "",
    rightTex: "",
    titleFontSize,
    bodyFontSize,
    isQuest: true,
    questCallbacks: callbacks,
    acceptText: acceptText || "接受任务",
    rejectText: rejectText || "拒绝任务",
  };
}

/**
 * 检查当前条目是否为任务
 * @param state 玩家对话框状态
 */
export function isQuestMode(state: PlayerDialogState): boolean {
  const entry = state.queue[0];
  return entry?.isQuest === true;
}

/**
 * 获取当前任务的回调（如果存在）
 * @param state 玩家对话框状态
 */
export function getQuestCallbacks(state: PlayerDialogState): QuestCallbacks | undefined {
  const entry = state.queue[0];
  return entry?.questCallbacks;
}
