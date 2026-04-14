/**
 * NPC 头顶叹号/问号 + qipao 气泡
 * 对话期间会在问号/叹号和气泡之间切换
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { DIALOG_NPC_CONFIGS } from "../../08．任务系统/00．配置表/01．对话配置表";
import { QUEST_CONFIGS } from "../../08．任务系统/00．配置表/02．任务配置表";
import type { NPCData } from "../../08．任务系统/00．配置表/03．NPC配置表";
import { createUnitEffect, destroyUnitEffect } from "../../../lib/扩展函数/封装函数/01．通用工具/03．特效";

const MAX_PLAYERS = 28;

const BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx";
const NPC_OVERHEAD_BLUE_EXCL = "resource\\models\\exclamation\\bluetanhao.mdx";
const NPC_OVERHEAD_YELLOW_EXCL = "resource\\models\\exclamation\\yellowtanhao.mdx";
const NPC_OVERHEAD_GRAY_QUESTION = "resource\\models\\exclamation\\huisewenhao.mdx";
const NPC_PROMPT_EFFECT_KEY = "npc_prompt";
const NPC_BUBBLE_EFFECT_KEY = "npc_bubble";

const g_bubbleEffects: any[] = [];
const g_bubbleScheduleTimers: any[] = [];
const g_npcUnits: any[] = [];
const g_npcOccupiedBy: Map<any, number> = new Map();
const g_npcPromptEffectByHandle = new Map<number, boolean>();
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

export function cancelPendingNpcMarkerSchedules(npcUnit: any): void {
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingGrayMarkerTimerForHandle(key);
  cancelPendingYellowMarkerTimerForHandle(key);
}

function destroyNpcPromptEffectInternal(unit: any): boolean {
  const key = npcPromptHandleKey(unit);
  if (key === 0) return false;
  const hadQuestMarker = g_npcPromptEffectByHandle.get(key) === true;
  destroyUnitEffect(unit, NPC_PROMPT_EFFECT_KEY);
  g_npcPromptEffectByHandle.delete(key);
  return hadQuestMarker;
}

function attachNpcPromptEffect(unit: any, modelPath: string): void {
  if (!unit || modelPath === "") return;
  const key = npcPromptHandleKey(unit);
  if (key === 0) return;
  destroyNpcPromptEffectInternal(unit);
  if (createUnitEffect(unit, "overhead", modelPath, undefined, NPC_PROMPT_EFFECT_KEY)) {
    g_npcPromptEffectByHandle.set(key, true);
  }
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
}

export function setNpcQuestPromptAcceptedState(npcUnit: any): void {
  const key = npcPromptHandleKey(npcUnit);
  if (key !== 0) {
    cancelPendingGrayMarkerTimerForHandle(key);
    cancelPendingYellowMarkerTimerForHandle(key);
  }
  attachNpcPromptEffect(npcUnit, NPC_OVERHEAD_GRAY_QUESTION);
}

export const BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY = 0.85;

export function scheduleGrayQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingGrayMarkerTimerForHandle(key);
  setNpcQuestPromptAcceptedState(npcUnit);
}

export function scheduleYellowQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  cancelPendingYellowMarkerTimerForHandle(key);
  attachQuestMarkerToUnit(npcUnit);
}

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

export function shouldSkipNewBubbleSchedule(playerId: number, npcUnit: any): boolean {
  if (playerId < 0 || playerId >= MAX_PLAYERS || !npcUnit) return false;
  if (!npcUnitsSameForBubble(g_npcUnits[playerId], npcUnit)) return false;
  if (g_bubbleEffects[playerId]) return true;
  if (g_bubbleScheduleTimers[playerId]) return true;
  return false;
}

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
  if (!npcUnit) return;
  if (createUnitEffect(npcUnit, "overhead", BUBBLE_EFFECT_PATH, undefined, NPC_BUBBLE_EFFECT_KEY)) {
    g_bubbleEffects[playerId] = npcUnit;
  }
}

export function destroyBubbleEffect(playerId: number): void {
  cancelBubbleEffectSchedule(playerId);
  const bubbleUnit = g_bubbleEffects[playerId];
  if (bubbleUnit) {
    destroyUnitEffect(bubbleUnit, NPC_BUBBLE_EFFECT_KEY);
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
