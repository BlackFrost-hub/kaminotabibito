const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import { setActivePlayerId } from "./16．对话框同步状态";
import type { Frame, Player, PlayerDialogState, Timer } from "./05．对话框业务逻辑";

export const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";
export const MAX_PLAYERS = 28;
export const TOC_PATH = "ui\\StarGameUI.toc";
export const TAG_BASE_MAIN = 1024;
export const TAG_BASE_PORTRAIT = 1125;
export const DEFAULT_FONT = "UI\\uizt.ttf";
export const DEFAULT_TITLE_FONT_SIZE = 0.018;
export const DEFAULT_BODY_FONT_SIZE = 0.012;
export const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
export const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";
/** ~ 键（波浪号/反引号，数字键盘左边ESC下面） */
export const KEY_SKIP_DIALOG = 192;

// ========== 虚拟分区：运行时状态 ==========
export const g_states: PlayerDialogState[] = [];
export const g_questCallbacksByPlayer: Array<{ onAccept: () => void; onReject: () => void } | undefined> = [];

// ========== 虚拟分区：Dz / JASS 封装 ==========
export function dzShow(f: Frame, b: boolean): void { if (f && f !== 0 && typeof japi.DzFrameShow === "function") japi.DzFrameShow(f, b); }
export function dzSetText(f: Frame, s: string): void { if (f && f !== 0 && typeof japi.DzFrameSetText === "function") japi.DzFrameSetText(f, s); }
export function dzSetTexture(f: Frame, path: string): void { if (f && f !== 0 && typeof japi.DzFrameSetTexture === "function") japi.DzFrameSetTexture(f, path, 0); }
export function dzSetAlpha(f: Frame, a: number): void { if (f && f !== 0 && typeof japi.DzFrameSetAlpha === "function") japi.DzFrameSetAlpha(f, a); }
export function dzSetPriority(f: Frame, p: number): void { if (f && f !== 0 && typeof japi.DzFrameSetPriority === "function") (pcall as any)(() => japi.DzFrameSetPriority(f, p)); }
export function dzSetAbsPoint(f: Frame, point: number, x: number, y: number): void { if (f && f !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") japi.DzFrameSetAbsolutePoint(f, point, x, y); }
export function dzSetSize(f: Frame, w: number, h: number): void { if (f && f !== 0 && typeof japi.DzFrameSetSize === "function") japi.DzFrameSetSize(f, w, h); }
export function dzClearPoints(f: Frame): void { if (f && f !== 0 && typeof japi.DzFrameClearAllPoints === "function") japi.DzFrameClearAllPoints(f); }
export function dzSetEnable(f: Frame, b: boolean): void { if (f && f !== 0 && typeof japi.DzFrameSetEnable === "function") japi.DzFrameSetEnable(f, b); }
export function dzSetFont(f: Frame, font: string, size: number): void { if (f && f !== 0 && typeof japi.DzFrameSetFont === "function") japi.DzFrameSetFont(f, font, size, 0); }
export function dzCreate(template: string, tag: number): Frame {
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  if (!gameUI || gameUI === 0) return 0;
  if (typeof japi.DzCreateFrame !== "function") return 0;
  return japi.DzCreateFrame(template, gameUI, tag) as Frame;
}
export function dzGetLocalPlayer(): Player { return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null; }
export function dzGetPlayerId(p: Player): number { return typeof jass.GetPlayerId === "function" ? (jass.GetPlayerId(p) as number) : -1; }
export function dzPlayer(index: number): Player { return typeof jass.Player === "function" ? jass.Player(index) : null; }
export function dzTimerCreate(): Timer { return typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null; }
export function dzTimerStart(t: Timer, timeout: number, periodic: boolean, cb: () => void): void { if (t && typeof jass.TimerStart === "function") jass.TimerStart(t, timeout, periodic, cb); }
export function dzTimerPause(t: Timer): void { if (t && typeof jass.PauseTimer === "function") jass.PauseTimer(t); }
export function dzLoadToc(): void { if (typeof japi.DzLoadToc === "function") japi.DzLoadToc(TOC_PATH); }
let g_tocLoaded = false;
export function dzLoadTocOnce(): void { if (g_tocLoaded) return; g_tocLoaded = true; dzLoadToc(); }

/** 联机：~ / DzSync 交错时保证 g_questCallbacksByPlayer 与 queue[0].questCallbacks 同源；否则接受/拒绝 resolve 不对称 → 掉线 */
export function syncQuestCallbacksTableFromQueueHead(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  const e = state.queue[0];
  if (!e.isQuest || !e.questCallbacks) return;
  g_questCallbacksByPlayer[state.playerId] = {
    onAccept: e.questCallbacks.onAccept,
    onReject: e.questCallbacks.onReject,
  };
  setActivePlayerId(state.playerId);
}

/**
 * 在玩家队列中找第一个任务行（不要求必须是队首）。
 * ~ 键跳过后队首可能仍是普通行（本地视觉快进不修改队列），
 * 接受/拒绝时需要从整个队列里找到任务行来执行回调。
 */
export function findFirstQuestEntryIndex(state: PlayerDialogState): number {
  for (let i = 0; i < state.queue.length; i++) {
    if (state.queue[i].isQuest && state.queue[i].questCallbacks) return i;
  }
  return -1;
}

export { japi, jass };
