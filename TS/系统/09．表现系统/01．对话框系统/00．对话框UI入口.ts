/**
 * 对话框UI系统入口
 *
 * 对话框系统模块：
 * - 01．对话框渲染核心.ts  - DzAPI封装、帧创建、显示控制
 * - 02．打字机效果.ts     - 逐字显示动画
 * - 03．对话框立绘系统.ts  - 左/中/右立绘管理
 * - 04．任务对话框.ts     - 接受/拒绝按钮逻辑
 * - 05．对话框业务逻辑.ts  - 对话播放、推进、入队控制
 */

import {
  Player,
  MAX_PLAYERS,
  DEFAULT_TITLE_FONT_SIZE,
  DEFAULT_BODY_FONT_SIZE,
  ensureState,
  initAllStates,
  getState,
  dzGetPlayerId,
  dzPlayer,
  dzGetLocalPlayer,
  showDialogFrames,
  clearState,
  dzSetText,
  dzSetFont,
  dzShow,
  dzSetTexture,
} from "./01．对话框渲染核心";
import {
  setFinishCallback,
  setDialogNpcUnit,
  isNpcOccupied,
  tryOccupyNpc,
} from "../../09．表现系统/04．NPC对话状态池";
import {
  initTypingCallbacks,
  playEntry,
  advanceDialog,
  enqueue,
} from "./05．对话框业务逻辑";
import { createQuestEntry } from "./04．任务对话框";

// 初始化打字机回调
initTypingCallbacks();

// ────────────────────────────────────────────────
// 公共 API
// ────────────────────────────────────────────────

/**
 * 初始化对话框系统
 */
export function initDialogSystem(): void {
  initAllStates();
}

/**
 * 为指定玩家添加一条对话（无立绘）
 */
export function displayText(
  p: Player,
  title: string,
  text: string,
  duration: number,
  titleFontSize?: number,
  bodyFontSize?: number,
): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, title, text, duration, "", "", "",
    titleFontSize ?? DEFAULT_TITLE_FONT_SIZE,
    bodyFontSize ?? DEFAULT_BODY_FONT_SIZE);
}

/**
 * 为指定玩家添加一条对话（带立绘）
 */
export function displayTextEx(
  p: Player,
  title: string,
  text: string,
  duration: number,
  leftPortrait: string,
  midPortrait: string,
  rightPortrait: string,
  titleFontSize?: number,
  bodyFontSize?: number,
): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, title, text, duration, leftPortrait, midPortrait, rightPortrait,
    titleFontSize ?? DEFAULT_TITLE_FONT_SIZE,
    bodyFontSize ?? DEFAULT_BODY_FONT_SIZE);
}

/**
 * 清除指定玩家的全部对话队列
 */
export function clearDialog(p: Player): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = getState(pid);
  if (!state) return;
  clearState(state);
}

/**
 * 设置指定玩家是否显示对话框
 */
export function setDialogShowable(p: Player, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  state.canShow = visible;
  if (!visible && state.initialized) {
    showDialogFrames(state, false);
  }
}

/**
 * 设置对话框背景贴图
 */
export function setDialogBGTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = getState(pid);
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[0], path);
}

/**
 * 设置对话框标题栏贴图
 */
export function setDialogTitleTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = getState(pid);
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[1], path);
}

/**
 * 查询对话框是否正在显示
 */
export function isDialogActive(p: Player): boolean {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return false;
  const state = getState(pid);
  if (!state) return false;
  return state.isActive;
}

/**
 * 注册对话结束回调
 */
export function setDialogFinishCallback(p: Player, callback: () => void): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  setFinishCallback(pid, callback);
}

/**
 * 显示任务对话框
 */
export function displayQuest(
  p: Player,
  title: string,
  text: string,
  onAccept: () => void,
  onReject: () => void,
): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);

  const entry = createQuestEntry(title, text, { onAccept, onReject },
    DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE);

  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) {
    playEntry(state);
  }
}

// 重新导出NPC相关函数
export { setDialogNpcUnit, isNpcOccupied, tryOccupyNpc } from "../../09．表现系统/04．NPC对话状态池";
