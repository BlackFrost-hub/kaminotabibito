/**
 * NPC 头顶叹号/问号 + qipao 气泡（对话流程专用）
 * - 仅用 `jass.AddSpecialEffectTarget` / `DestroyEffect`，在同步上下文执行
 * - 与 `16．对话框同步状态`（活跃玩家 ID / 结束回调）分离；占用与气泡同文件管理
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { DIALOG_NPC_CONFIGS } from "../../08．任务系统/00．配置表/01．对话配置表";
import { QUEST_CONFIGS } from "../../08．任务系统/00．配置表/02．任务配置表";
import type { NPCData } from "../../08．任务系统/00．配置表/03．NPC配置表";

const MAX_PLAYERS = 28;

const BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx";
const NPC_OVERHEAD_BLUE_EXCL = "resource\\models\\exclamation\\bluetanhao.mdx";
const NPC_OVERHEAD_YELLOW_EXCL = "resource\\models\\exclamation\\yellowtanhao.mdx";
const NPC_OVERHEAD_GRAY_QUESTION = "resource\\models\\exclamation\\huisewenhao.mdx";

const g_bubbleEffects: any[] = [];
const g_bubbleScheduleTimers: any[] = [];
const g_npcUnits: any[] = [];
const g_npcOccupiedBy: Map<any, number> = new Map();
const g_npcPromptEffectByHandle = new Map<number, any>();
const g_pendingGrayMarkerTimerByHandle = new Map<number, any>();
const g_pendingYellowMarkerTimerByHandle = new Map<number, any>();

type Player = any;

function npcPromptHandleKey(unit: any): number {
  if (!unit) return 0;
  if (typeof japi.DzGetUnitObjectId === "function") {
    const id = japi.DzGetUnitObjectId(unit) as number;
    if (id != null && id !== 0) return id;
  }
  if (typeof jass.GetHandleId === "function") {
    return jass.GetHandleId(unit) as number;
  }
  return 0;
}

function dzGetPlayerId(p: Player): number {
  return typeof jass.GetPlayerId === "function" ? (jass.GetPlayerId(p) as number) : -1;
}

function cancelTimerHandle(t: any): void {
  if (!t) return;
  jass.PauseTimer(t);
  jass.DestroyTimer(t);
}

function cancelPendingGrayMarkerTimerForHandle(key: number): void {
  if (key === 0) return;
  const t = g_pendingGrayMarkerTimerByHandle.get(key);
  if (t) {
    cancelTimerHandle(t);
    g_pendingGrayMarkerTimerByHandle.delete(key);
  }
}

function cancelPendingYellowMarkerTimerForHandle(key: number): void {
  if (key === 0) return;
  const t = g_pendingYellowMarkerTimerByHandle.get(key);
  if (t) {
    cancelTimerHandle(t);
    g_pendingYellowMarkerTimerByHandle.delete(key);
  }
}

/** 取消该 NPC 上所有「延迟挂灰/黄」的待定计时器（不改变当前已挂模型；任务完成/重开对话前常配合 remove 使用）。 */
export function cancelPendingNpcMarkerSchedules(npcUnit: any): void {
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingGrayMarkerTimerForHandle(key);
  cancelPendingYellowMarkerTimerForHandle(key);
}

/** @returns 是否曾挂有叹号/问号等非 qipao 头顶特效并已销毁 */
function destroyNpcPromptEffectInternal(unit: any): boolean {
  const key = npcPromptHandleKey(unit);
  if (key === 0) return false;
  const eff = g_npcPromptEffectByHandle.get(key);
  const hadQuestMarker = eff != null;
  if (eff && typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(eff);
  }
  g_npcPromptEffectByHandle.delete(key);
  return hadQuestMarker;
}

function attachNpcPromptEffect(unit: any, modelPath: string): void {
  if (!unit || modelPath === "" || typeof jass.AddSpecialEffectTarget !== "function") return;
  const key = npcPromptHandleKey(unit);
  if (key === 0) return;
  destroyNpcPromptEffectInternal(unit);
  const eff = jass.AddSpecialEffectTarget(modelPath, unit, "overhead");
  if (eff) g_npcPromptEffectByHandle.set(key, eff);
}

function npcConfigQualifiesForQuestMarker(npc: NPCData): boolean {
  if (npc.requireID == null) return false;
  const rid = npc.requireID;
  const hasDialog = DIALOG_NPC_CONFIGS.some(d => d.requireid === rid);
  const hasEnabledQuest = QUEST_CONFIGS.some(q => q.requireID === rid && q.enabled !== false);
  if (npc.requireType === "任务") return true;
  return hasDialog || hasEnabledQuest;
}

export function tryAttachQuestMarkerForConfigNpc(unit: any, npcConfig: NPCData): void {
  if (!unit || !npcConfigQualifiesForQuestMarker(npcConfig)) return;
  if (npcConfig.requireType === "对话") {
    attachNpcPromptEffect(unit, NPC_OVERHEAD_BLUE_EXCL);
  } else {
    attachNpcPromptEffect(unit, NPC_OVERHEAD_YELLOW_EXCL);
  }
}

export function attachQuestMarkerToUnit(unit: any): void {
  const key = npcPromptHandleKey(unit);
  if (key !== 0) {
    cancelPendingGrayMarkerTimerForHandle(key);
    cancelPendingYellowMarkerTimerForHandle(key);
  }
  attachNpcPromptEffect(unit, NPC_OVERHEAD_YELLOW_EXCL);
}

export function attachQuestMarkersToMainStoryNpcMap(_map: Record<string, any>): void {
  // 主线 NPC 暂不设置头顶提示
}

export function setNpcQuestPromptAcceptedState(npcUnit: any): void {
  const key = npcPromptHandleKey(npcUnit);
  if (key !== 0) {
    cancelPendingGrayMarkerTimerForHandle(key);
    cancelPendingYellowMarkerTimerForHandle(key);
  }
  attachNpcPromptEffect(npcUnit, NPC_OVERHEAD_GRAY_QUESTION);
}

/** 仅当本次确实移除了叹号/问号等头顶提示时，再延迟该时长挂 qipao；头顶本来就没有这类特效时则立刻挂 qipao */
export const BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY = 0.85;
export const NPC_OVERHEAD_MARKER_AFTER_BUBBLE_DELAY = 4.9;

export function scheduleGrayQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingGrayMarkerTimerForHandle(key);
  const t = jass.CreateTimer();
  g_pendingGrayMarkerTimerByHandle.set(key, t);
  jass.TimerStart(t, NPC_OVERHEAD_MARKER_AFTER_BUBBLE_DELAY, false, () => {
    if (g_pendingGrayMarkerTimerByHandle.get(key) !== t) return;
    g_pendingGrayMarkerTimerByHandle.delete(key);
    cancelTimerHandle(t);
    setNpcQuestPromptAcceptedState(npcUnit);
  });
}

export function scheduleYellowQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingYellowMarkerTimerForHandle(key);
  const t = jass.CreateTimer();
  g_pendingYellowMarkerTimerByHandle.set(key, t);
  jass.TimerStart(t, NPC_OVERHEAD_MARKER_AFTER_BUBBLE_DELAY, false, () => {
    if (g_pendingYellowMarkerTimerByHandle.get(key) !== t) return;
    g_pendingYellowMarkerTimerByHandle.delete(key);
    cancelTimerHandle(t);
    attachQuestMarkerToUnit(npcUnit);
  });
}

/**
 * 移除头顶叹号/问号等（非 qipao）并取消待定灰/黄计时。
 * @returns 是否**实际存在并已移除**叹号/问号特效（用于决定是否使用 0.85s 后再挂 qipao）
 */
export function removeQuestMarkerAfterNpcTriggered(npcUnit: any): boolean {
  cancelPendingNpcMarkerSchedules(npcUnit);
  return destroyNpcPromptEffectInternal(npcUnit);
}

function cancelBubbleEffectSchedule(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  const t = g_bubbleScheduleTimers[playerId];
  if (t) {
    jass.PauseTimer(t);
    jass.DestroyTimer(t);
    g_bubbleScheduleTimers[playerId] = undefined;
  }
}

/** Lua 下同一单位多次取引用可能不是同一 table，用 HandleId 对齐 */
function npcUnitsSameForBubble(a: any, b: any): boolean {
  if (a === b) return true;
  if (!a || !b) return false;
  if (typeof jass.GetHandleId === "function") {
    const ha = jass.GetHandleId(a) as number;
    const hb = jass.GetHandleId(b) as number;
    if (ha !== 0 && ha === hb) return true;
  }
  return false;
}

/**
 * 同玩家、同 NPC 链式对白：已有气泡或已排程延迟创建时不再排程，避免叠两层；应用 HandleId 判断，避免 `!==` 误判导致日后谈等场景不挂气泡。
 */
export function shouldSkipNewBubbleSchedule(playerId: number, npcUnit: any): boolean {
  if (playerId < 0 || playerId >= MAX_PLAYERS || !npcUnit) return false;
  if (!npcUnitsSameForBubble(g_npcUnits[playerId], npcUnit)) return false;
  if (g_bubbleEffects[playerId]) return true;
  if (g_bubbleScheduleTimers[playerId]) return true;
  return false;
}

/**
 * @param waitForOverheadClearDelay 为 true：刚移除了叹号/问号，等 `BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY` 再挂 qipao；
 * 为 false：头顶本无此类特效，立刻挂 qipao。
 */
export function scheduleBubbleEffectAfterOverheadClear(playerId: number, npcUnit: any, waitForOverheadClearDelay: boolean): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS || !npcUnit) return;
  cancelBubbleEffectSchedule(playerId);
  if (!waitForOverheadClearDelay) {
    createBubbleEffect(playerId, npcUnit);
    return;
  }
  const t = jass.CreateTimer();
  g_bubbleScheduleTimers[playerId] = t;
  jass.TimerStart(t, BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY, false, () => {
    g_bubbleScheduleTimers[playerId] = undefined;
    jass.PauseTimer(t);
    jass.DestroyTimer(t);
    const uNow = g_npcUnits[playerId];
    if (!npcUnitsSameForBubble(uNow, npcUnit)) return;
    if (!uNow || g_npcOccupiedBy.get(uNow) !== playerId) return;
    createBubbleEffect(playerId, uNow);
  });
}

export function createBubbleEffect(playerId: number, npcUnit: any): void {
  cancelBubbleEffectSchedule(playerId);
  destroyBubbleEffect(playerId);
  g_npcUnits[playerId] = npcUnit;
  if (npcUnit && typeof jass.AddSpecialEffectTarget === "function") {
    const effect = jass.AddSpecialEffectTarget(BUBBLE_EFFECT_PATH, npcUnit, "overhead");
    g_bubbleEffects[playerId] = effect;
  }
}

export function destroyBubbleEffect(playerId: number): void {
  cancelBubbleEffectSchedule(playerId);
  const effect = g_bubbleEffects[playerId];
  if (effect && typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(effect);
  }
  g_bubbleEffects[playerId] = undefined;
}

export function releaseNpcOccupation(playerId: number): void {
  const npcUnit = g_npcUnits[playerId];
  if (npcUnit) {
    if (g_npcOccupiedBy.get(npcUnit) === playerId) {
      g_npcOccupiedBy.delete(npcUnit);
    }
  }
  g_npcUnits[playerId] = undefined;
}

export function getNpcUnit(playerId: number): any {
  return g_npcUnits[playerId];
}

export function isNpcOccupied(npcUnit: any): number {
  if (!npcUnit) return -1;
  return g_npcOccupiedBy.get(npcUnit) ?? -1;
}

export function tryOccupyNpc(p: Player, npcUnit: any): boolean {
  if (!npcUnit) return false;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return false;
  const occupiedBy = g_npcOccupiedBy.get(npcUnit);
  if (occupiedBy !== undefined && occupiedBy !== pid) {
    return false;
  }
  g_npcOccupiedBy.set(npcUnit, pid);
  g_npcUnits[pid] = npcUnit;
  return true;
}

export function setDialogNpcUnit(p: Player, npcUnit: any): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  g_npcUnits[pid] = npcUnit;
}

export {};
