/**
 * NPC 头顶叹号/问号 + qipao 气泡
 * 对话期间会在问号/叹号和气泡之间切换
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

import { 对话NPC配置列表 } from "../../08．任务系统/00．配置表/01．对话配置表";
import { 任务配置列表 } from "../../08．任务系统/00．配置表/02．任务配置表";
import type { 支线NPC配置 } from "../../11．剧情系统/02．支线任务/01．支线NPC配置表";
import { createUnitEffect, destroyUnitEffect } from "../../../lib/扩展函数/封装函数/01．通用工具/03．特效";
import { YDWEAngleBetweenUnitsSafe } from "../../../lib/扩展函数/YDWE函数/09．YDUserData安全版";

/** NPC 对话占用与气泡状态固定绑定到 4 个玩家槽位。 */
const MAX_PLAYERS = 4;

const BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx";
const NPC_OVERHEAD_BLUE_EXCL = "resource\\models\\exclamation\\bluetanhao.mdx";
const NPC_OVERHEAD_YELLOW_EXCL = "resource\\models\\exclamation\\yellowtanhao.mdx";
const NPC_OVERHEAD_GRAY_QUESTION = "resource\\models\\exclamation\\huisewenhao.mdx";
const NPC_PROMPT_EFFECT_KEY = "npc_prompt";
const NPC_BUBBLE_EFFECT_KEY = "npc_bubble";

const g_bubbleEffects: any[] = [];
const g_bubbleScheduleTaskIds: Array<number | undefined> = [];
const g_npcUnits: any[] = [];
const g_npc配置朝向列表: Array<number | undefined> = [];
const g_npcOccupiedBy: Map<number, number> = new Map();
const g_npcPromptEffectByHandle = new Map<number, boolean>();

const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;

type Player = any;

function npcPromptHandleKey(unit: any): number {
  if (!unit) return 0;
  const id = jass.GetUnitTypeId(unit) as number;
  if (id != null && id !== 0) return id;
  return jass.GetHandleId(unit) as number;
}

/** 占用表 key：用 GetHandleId（同类型多 NPC 需独立占用，不能用 UnitTypeId） */
function npcOccupationKey(unit: any): number {
  if (!unit) return 0;
  return jass.GetHandleId(unit) as number;
}

function dzGetPlayerId(p: Player): number {
  return jass.GetPlayerId(p) as number;
}

/** 兼容旧调用点：标记切换已改为即时执行，目前没有待取消的任务。 */
export function cancelPendingNpcMarkerSchedules(_npcUnit: any): void {
  return;
}

// ========== 虚拟分区：NPC 头顶叹号/问号特效 ==========
// ========== 虚拟分区：NPC 头顶叹号/问号特效 ==========
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

function npcConfigQualifiesForQuestMarker(npc: 支线NPC配置 | null | undefined): boolean {
  if (npc == null) return false;
  if (npc.任务ID == null) return false;
  const rid = npc.任务ID;
  const hasDialog = 对话NPC配置列表.some(d => d.对话ID === rid);
  const hasEnabledQuest = 任务配置列表.some(q => q.任务ID === rid && q.启用 !== false);
  if (npc.类型 === "任务") return true;
  return hasDialog || hasEnabledQuest;
}

export function tryAttachQuestMarkerForConfigNpc(unit: any, npcConfig: 支线NPC配置 | null | undefined): void {
  if (!unit || npcConfig == null || !npcConfigQualifiesForQuestMarker(npcConfig)) return;
  if (npcConfig.类型 === "对话") {
    attachNpcPromptEffect(unit, NPC_OVERHEAD_BLUE_EXCL);
  } else {
    attachNpcPromptEffect(unit, NPC_OVERHEAD_YELLOW_EXCL);
  }
}

export function attachQuestMarkerToUnit(unit: any): void {
  attachNpcPromptEffect(unit, NPC_OVERHEAD_YELLOW_EXCL);
}

export function setNpcQuestPromptAcceptedState(npcUnit: any): void {
  attachNpcPromptEffect(npcUnit, NPC_OVERHEAD_GRAY_QUESTION);
}

export const BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY = 0.85;

export function scheduleGrayQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  setNpcQuestPromptAcceptedState(npcUnit);
}

export function scheduleYellowQuestMarkerAfterBubbleFade(npcUnit: any): void {
  if (!npcUnit) return;
  const key = npcPromptHandleKey(npcUnit);
  if (key === 0) return;
  attachQuestMarkerToUnit(npcUnit);
}

export function removeQuestMarkerAfterNpcTriggered(npcUnit: any): boolean {
  cancelPendingNpcMarkerSchedules(npcUnit);
  return destroyNpcPromptEffectInternal(npcUnit);
}

function cancelBubbleEffectSchedule(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  const taskId = g_bubbleScheduleTaskIds[playerId];
  if (taskId != null) {
    removeDelayedCallback(taskId);
    g_bubbleScheduleTaskIds[playerId] = undefined;
  }
  g_bubbleScheduleNpcUnit[playerId] = undefined;
}

function npcUnitsSameForBubble(a: any, b: any): boolean {
  if (a === b) return true;
  if (!a || !b) return false;
  const ha = jass.GetHandleId(a) as number;
  const hb = jass.GetHandleId(b) as number;
  if (ha !== 0 && ha === hb) return true;
  return false;
}

export function shouldSkipNewBubbleSchedule(playerId: number, npcUnit: any): boolean {
  if (playerId < 0 || playerId >= MAX_PLAYERS || !npcUnit) return false;
  if (!npcUnitsSameForBubble(g_npcUnits[playerId], npcUnit)) return false;
  if (g_bubbleEffects[playerId]) return true;
  if (g_bubbleScheduleTaskIds[playerId] != null) return true;
  return false;
}

/** 延迟气泡回调的 npcUnit 快照（避免闭包捕获 handle） */
const g_bubbleScheduleNpcUnit: any[] = [];

function runBubbleScheduleForPlayer(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  const npcUnit = g_bubbleScheduleNpcUnit[playerId];
  g_bubbleScheduleNpcUnit[playerId] = undefined;
  g_bubbleScheduleTaskIds[playerId] = undefined;
  const uNow = g_npcUnits[playerId];
  if (!npcUnitsSameForBubble(uNow, npcUnit)) return;
  if (!uNow || g_npcOccupiedBy.get(npcOccupationKey(uNow)) !== playerId) return;
  createBubbleEffect(playerId, uNow);
}

function bubbleScheduleCallbackP0(): void { runBubbleScheduleForPlayer(0); }
function bubbleScheduleCallbackP1(): void { runBubbleScheduleForPlayer(1); }
function bubbleScheduleCallbackP2(): void { runBubbleScheduleForPlayer(2); }
function bubbleScheduleCallbackP3(): void { runBubbleScheduleForPlayer(3); }

function startBubbleScheduleTask(playerId: number, delay: number): void {
  switch (playerId) {
    case 0: g_bubbleScheduleTaskIds[playerId] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP0); return;
    case 1: g_bubbleScheduleTaskIds[playerId] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP1); return;
    case 2: g_bubbleScheduleTaskIds[playerId] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP2); return;
    case 3: g_bubbleScheduleTaskIds[playerId] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP3); return;
    default: return;
  }
}

export function scheduleBubbleEffectAfterOverheadClear(playerId: number, npcUnit: any, waitForOverheadClearDelay: boolean): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS || !npcUnit) return;
  cancelBubbleEffectSchedule(playerId);
  if (!waitForOverheadClearDelay) {
    createBubbleEffect(playerId, npcUnit);
    return;
  }
  g_bubbleScheduleNpcUnit[playerId] = npcUnit;
  startBubbleScheduleTask(playerId, BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY);
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
    const key = npcOccupationKey(npcUnit);
    if (key !== 0 && g_npcOccupiedBy.get(key) === playerId) {
      g_npcOccupiedBy.delete(key);
    }
  }
  g_npcUnits[playerId] = undefined;
}

export function getNpcUnit(playerId: number): any {
  return g_npcUnits[playerId];
}

export function 让对话NPC面向玩家单位(
  this: void,
  玩家ID: number,
  NPC单位: any,
  玩家单位: any,
  配置朝向: number | undefined,
): void {
  if (玩家ID < 0 || 玩家ID >= MAX_PLAYERS) return;
  if (!NPC单位 || !玩家单位 || 配置朝向 == null) return;
  g_npc配置朝向列表[玩家ID] = 配置朝向;
  SetUnitFacing(NPC单位, YDWEAngleBetweenUnitsSafe(NPC单位, 玩家单位));
}

export function 恢复对话NPC配置朝向(this: void, 玩家ID: number): void {
  if (玩家ID < 0 || 玩家ID >= MAX_PLAYERS) return;
  const NPC单位 = g_npcUnits[玩家ID];
  const 配置朝向 = g_npc配置朝向列表[玩家ID];
  g_npc配置朝向列表[玩家ID] = undefined;
  if (!NPC单位 || 配置朝向 == null) return;
  SetUnitFacing(NPC单位, 配置朝向);
}

export function tryOccupyNpc(p: Player, npcUnit: any): boolean {
  if (!npcUnit) return false;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return false;
  const key = npcOccupationKey(npcUnit);
  if (key === 0) return false;
  const occupiedBy = g_npcOccupiedBy.get(key);
  if (occupiedBy !== undefined && occupiedBy !== pid) {
    return false;
  }
  g_npcOccupiedBy.set(key, pid);
  g_npcUnits[pid] = npcUnit;
  return true;
}

export function setDialogNpcUnit(p: Player, npcUnit: any): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  g_npcUnits[pid] = npcUnit;
}

export {};
