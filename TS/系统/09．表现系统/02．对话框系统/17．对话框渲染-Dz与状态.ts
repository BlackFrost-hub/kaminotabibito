const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;
import { safeTimerStart } from "../../../系统/00．核心系统/07．联机安全工具";

import { setActivePlayerId } from "./16．对话框同步状态";
import type { Frame, Player, PlayerDialogState, Timer } from "./05．对话框业务逻辑";

export const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";
/** 对话框系统固定为 4 个玩家槽位：P1~P4。 */
export const MAX_PLAYERS = 4;
export const TOC_PATH = "ui\\StarGameUI.toc";
export const TAG_BASE_MAIN = 1024;
export const TAG_BASE_PORTRAIT = 1125;
export const DEFAULT_FONT = "UI\\uizt.ttf";
export const DEFAULT_TITLE_FONT_SIZE = 0.018;
export const DEFAULT_BODY_FONT_SIZE = 0.012;
export const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
export const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";
/** ~ 键 VK_OEM_3（192）；注册须走数字 VK，见 `封装函数/04．硬件输入/04．键盘函数` 中 registerKeyBindToTrigger */
export const KEY_SKIP_DIALOG = 192;

// ========== 虚拟分区：4 槽位玩家运行时状态表 ==========
export const g_states: PlayerDialogState[] = [];
export const g_questCallbacksByPlayer: Array<{ onAccept: () => void; onReject: () => void } | undefined> = [];

// ========== 虚拟分区：pcall 具名体槽位 ==========
let __dzPcallFrame = 0;
let __dzPcallPriority = 0;
function __dzSetPriorityPcallBody(): void { japi.DzFrameSetPriority(__dzPcallFrame, __dzPcallPriority); }

// ========== 虚拟分区：Dz/JASS API 安全封装 ==========
export function dzShow(f: Frame, b: boolean): void { if (f && f !== 0) japi.DzFrameShow(f, b); }
export function dzSetText(f: Frame, s: string): void { if (f && f !== 0) japi.DzFrameSetText(f, s); }
export function dzSetTexture(f: Frame, path: string): void { if (f && f !== 0) japi.DzFrameSetTexture(f, path, 0); }
export function dzSetAlpha(f: Frame, a: number): void { if (f && f !== 0) japi.DzFrameSetAlpha(f, a); }
export function dzSetPriority(f: Frame, p: number): void { if (f && f !== 0) { __dzPcallFrame = f; __dzPcallPriority = p; pcall(__dzSetPriorityPcallBody); } }
export function dzSetAbsPoint(f: Frame, point: number, x: number, y: number): void { if (f && f !== 0) japi.DzFrameSetAbsolutePoint(f, point, x, y); }
export function dzSetSize(f: Frame, w: number, h: number): void { if (f && f !== 0) japi.DzFrameSetSize(f, w, h); }
export function dzClearPoints(f: Frame): void { if (f && f !== 0) japi.DzFrameClearAllPoints(f); }
export function dzSetEnable(f: Frame, b: boolean): void { if (f && f !== 0) japi.DzFrameSetEnable(f, b); }
export function dzSetFont(f: Frame, font: string, size: number): void { if (f && f !== 0) japi.DzFrameSetFont(f, font, size, 0); }
export function dzCreate(template: string, tag: number): Frame {
  const gameUI = japi.DzGetGameUI();
  if (!gameUI || gameUI === 0) return 0;
  return japi.DzCreateFrame(template, gameUI, tag) as Frame;
}
export function dzGetLocalPlayer(): Player { return jass.GetLocalPlayer(); }
export function dzGetPlayerId(p: Player): number { return jass.GetPlayerId(p) as number; }
export function dzPlayer(index: number): Player { return jass.Player(index); }
export function dzTimerCreate(): Timer { return jass.CreateTimer(); }
export function dzTimerStart(t: Timer, timeout: number, periodic: boolean, cb: () => void): void { if (t) safeTimerStart(t, timeout, periodic, cb); }
export function dzTimerPause(t: Timer): void { if (t) jass.PauseTimer(t); }
export function dzLoadToc(): void { japi.DzLoadToc(TOC_PATH); }
let g_tocLoaded = false;
export function dzLoadTocOnce(): void { if (g_tocLoaded) return; g_tocLoaded = true; dzLoadToc(); }

/** 联机：~ / DzSync 交错时保证 g_questCallbacksByPlayer 与 queue 中任务条目同源；否则接受/拒绝 resolve 不对称 → 掉线 */
export function syncQuestCallbacksTableFromQueueHead(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx < 0) return;
  const e = state.queue[questIdx];
  if (!e.isQuest || !e.questCallbacks) return;
  g_questCallbacksByPlayer[state.playerId] = {
    onAccept: e.questCallbacks.onAccept,
    onReject: e.questCallbacks.onReject,
  };
  setActivePlayerId(state.playerId);
}

/**
 * 从当前页往后找第一个任务行。
 * 不再从 queue 头开始，避免 ~ 跳回前面已经看过的任务页。
 */
export function findFirstQuestEntryIndex(state: PlayerDialogState): number {
  for (let i = state.currentIndex; i < state.queue.length; i++) {
    if (state.queue[i].isQuest && state.queue[i].questCallbacks) return i;
  }
  return -1;
}

export { japi, jass };
