import type { QuestCallbacks } from "./04．任务对话框";

// ========== 虚拟分区：基础类型 ==========
export type Player = any;
export type Timer = any;
export type Frame = number;

// ========== 虚拟分区：基础类型别名与数据接口 ==========
export interface DialogEntry {
  title: string;
  text: string;
  waitTime: number;
  leftTex: string;
  midTex: string;
  rightTex: string;
  titleFontSize: number;
  bodyFontSize: number;
  isQuest: boolean;
  questCallbacks?: QuestCallbacks;
  acceptText?: string;
  rejectText?: string;
}

export interface PlayerDialogState {
  playerId: number;
  queue: DialogEntry[];
  currentIndex: number;
  tickTimer: Timer;
  frames: Frame[];
  strNow: number;
  strLen: number;
  canShow: boolean;
  initialized: boolean;
  questSyncHandlersBound: boolean;
  isActive: boolean;
  clickCooldown: boolean;
  waitingClick: boolean;
  onFinish?: () => void;
}

// ========== 虚拟分区：条目工厂 ==========
export function createNormalDialogEntry(
  title: string,
  text: string,
  waitTime: number,
  leftTex: string,
  midTex: string,
  rightTex: string,
  titleFontSize: number,
  bodyFontSize: number,
): DialogEntry {
  return { title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize, isQuest: false };
}

export function createQuestDialogEntry(
  title: string,
  text: string,
  titleFontSize: number,
  bodyFontSize: number,
  callbacks: QuestCallbacks,
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
    acceptText,
    rejectText,
  };
}

// ========== 虚拟分区：状态收尾 ==========
/**
 * 仅清「进行中」标志，**不**触发 onFinish（用于任务接受/拒绝后立刻链式 openNpcDialog，避免先 onFinish 销毁 qipao）。
 */
export function resetDialogActiveFlagsKeepOnFinish(state: PlayerDialogState): void {
  state.isActive = false;
  state.waitingClick = false;
  state.clickCooldown = false;
}

export function onDialogFinished(state: PlayerDialogState): void {
  state.isActive = false;
  state.waitingClick = false;
  state.clickCooldown = false;
  const cb = state.onFinish;
  state.onFinish = undefined;
  if (cb) cb();
}
