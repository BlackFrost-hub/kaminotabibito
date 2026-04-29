import {
  TASK_UI_TOC_LOAD_KEY,
  TASK_UI_TOC_PATHS,
  ENABLE_FDF_A,
  ENABLE_FDF_B,
  ENABLE_FDF_SCROLLBAR,
  ENABLE_FDF_SCROLLBAR_BORDER,
  ENABLE_FDF_SCROLLBAR_THUMB,
} from "./01．任务UI常量";
import { loadTocOnce } from "../../09．表现系统/01．UI工具/index";
import { questManager } from "../02．任务管理器/index";
import { questDB, QuestType, QuestStatus, QuestData } from "../01．任务数据";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

// ── Dz 调用 pcall：仅用模块顶层具名体 + 全局 `pcall(具名)`（勿 `(pcall as any)(具名)`，TSTL 会编成 `pcall(nil, fn)`） ──
let __dzPcallFrame = 0;
let __dzPcallVis = false;

function __dzPcallFrameShowBody(): void {
  japi.DzFrameShow(__dzPcallFrame, __dzPcallVis);
}

export function pcallDzFrameShow(frame: number, visible: boolean): void {
  __dzPcallFrame = frame;
  __dzPcallVis = visible;
  pcall(__dzPcallFrameShowBody);
}

let __dzPcallAlphaVal = 0;

function __dzPcallFrameSetAlphaBody(): void {
  japi.DzFrameSetAlpha(__dzPcallFrame, __dzPcallAlphaVal);
}

export function pcallDzFrameSetAlpha(frame: number, alpha: number): void {
  __dzPcallFrame = frame;
  __dzPcallAlphaVal = alpha;
  pcall(__dzPcallFrameSetAlphaBody);
}

export function dzGetLocalPlayer(): any {
  return jass.GetLocalPlayer();
}

export function dzPlayer(index: number): any {
  return jass.Player(index);
}

export function questIdTailInRange01to20(id: string, prefix: string): boolean {
  if (id.length !== prefix.length + 3) return false;
  if (id.substring(0, prefix.length) !== prefix) return false;
  const tail = id.substring(prefix.length);
  if (tail.length !== 3) return false;
  return tail >= "001" && tail <= "020";
}

export function isQuestWithRowIconLayout(quest: QuestData): boolean {
  if (quest.icon && quest.icon !== "") return true;
  const id = quest.id;
  if (quest.type === QuestType.MAIN) return questIdTailInRange01to20(id, "main_");
  if (quest.type === QuestType.SIDE) return questIdTailInRange01to20(id, "side_");
  if (quest.type === QuestType.DAILY) return questIdTailInRange01to20(id, "daily_");
  // 任务 UI 默认给列表项保留图标位，避免测试任务/运行时任务因为 id 命名不同而整列丢图标。
  return true;
}

export function isFdfFrameEnabled(frameName: string): boolean {
  const isA = frameName === "TaskEntryIcon" || frameName === "TaskMainPanel" || frameName === "TaskListContainer";
  const isB =
    frameName === "TaskTabMain" ||
    frameName === "TaskTabSide" ||
    frameName === "TaskTabDaily" ||
    frameName === "TaskButtonBackdrop" ||
    frameName === "TaskTabMainBg" ||
    frameName === "TaskTabSideBg" ||
    frameName === "TaskTabDailyBg";
  if (frameName === "TaskScrollBar") return ENABLE_FDF_SCROLLBAR;
  if (frameName === "TaskScrollBarBorder") return ENABLE_FDF_SCROLLBAR_BORDER;
  if (frameName === "TaskScrollThumb") return ENABLE_FDF_SCROLLBAR_THUMB;
  if (isA) return ENABLE_FDF_A;
  if (isB) return ENABLE_FDF_B;
  return false;
}

function tryCreateFromFdfOnlyNullFallback(): number | null {
  return null;
}

let __dzCreateName = "";
let __dzCreateParent = 0;
let __dzCreateContextId = 0;
let __dzCreateResultFrame = 0;

function __dzCreateFramePcallBody(): void {
  __dzCreateResultFrame = (japi as any).DzCreateFrame(__dzCreateName, __dzCreateParent, __dzCreateContextId);
}

export function tryCreateFromFdfWithSource(
  name: string,
  parent: number,
  fallback: () => number | null,
  contextId: number = 0
): { frame: number | null; fromFdf: boolean } {
  if (!isFdfFrameEnabled(name)) return { frame: fallback(), fromFdf: false };
  loadTocOnce(TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI");
  __dzCreateName = name;
  __dzCreateParent = parent;
  __dzCreateContextId = contextId;
  // void 具名体写槽位 + `local ok = pcall(具名)`：首返回值即 boolean，勿对 `pcall` 结果做下标/解构元组（见 `01．帧创建` 同构实现）。
  const ok = pcall(__dzCreateFramePcallBody);
  const f = __dzCreateResultFrame;
  if (ok && f != null && f !== 0) return { frame: f, fromFdf: true };
  return { frame: fallback(), fromFdf: false };
}

export function tryCreateFromFdfOnly(name: string, parent: number, contextId: number = 0): number | null {
  const res = tryCreateFromFdfWithSource(name, parent, tryCreateFromFdfOnlyNullFallback, contextId);
  if (res.fromFdf && res.frame && res.frame !== 0) return res.frame;
  return null;
}

export function getStatusText(status: QuestStatus): string {
  const m: Record<string, string> = {
    [QuestStatus.IN_PROGRESS]: "|cff00ff66进行中|r",
    [QuestStatus.COMPLETED]: "|cffc0c0c0已完成|r",
    [QuestStatus.FAILED]: "|cffff5555已失败|r",
    [QuestStatus.DISCOVERED]: "|cff66ccff已发现|r",
    [QuestStatus.UNDISCOVERED]: "|cff888888未发现|r",
  };
  return m[status] || status;
}

function questIdTailIsAllDigits(s: string): boolean {
  if (s.length === 0) return false;
  for (let i = 0; i < s.length; i++) {
    const c = s.charCodeAt(i);
    if (c < 48 || c > 57) return false;
  }
  return true;
}

/** TSTL 无 `lastIndexOf`，手写从右找 `_` */
function lastUnderscoreIndex(s: string): number {
  for (let i = s.length - 1; i >= 0; i--) {
    if (s.charAt(i) === "_") return i;
  }
  return -1;
}

/** `foo_2` 与 `foo_10` 字典序会乱；同一「末段 `_` 前」前缀且尾为纯数字时按数值比，否则字典序 */
function compareQuestIdForListOrder(aId: string, bId: string): number {
  const ua = lastUnderscoreIndex(aId);
  const ub = lastUnderscoreIndex(bId);
  if (ua > 0 && ub > 0) {
    const preA = aId.substring(0, ua + 1);
    const preB = bId.substring(0, ub + 1);
    if (preA === preB) {
      const tailA = aId.substring(ua + 1);
      const tailB = bId.substring(ub + 1);
      if (questIdTailIsAllDigits(tailA) && questIdTailIsAllDigits(tailB)) {
        const na = parseInt(tailA, 10);
        const nb = parseInt(tailB, 10);
        if (na !== nb) return na - nb;
      }
    }
  }
  if (aId < bId) return -1;
  if (aId > bId) return 1;
  return 0;
}

export function getQuestsForUI(playerId: number, type: QuestType): QuestData[] {
  const active = questDB
    .getPlayerActiveQuests(playerId)
    .filter(q => q.type === type && !q.uiReserved);
  const completedIds = questDB.getPlayerCompletedQuests(playerId);
  const result: QuestData[] = active.slice();

  for (const id of completedIds) {
    const template = questDB.getQuest(id);
    if (!template || template.type !== type || template.uiReserved) continue;
    if (active.some(q => q.id === id)) continue;
    result.push({
      ...template,
      status: QuestStatus.COMPLETED,
      objectives: template.objectives.map(o => ({ ...o, completed: true, current: o.required })),
    });
  }

  // 稳定顺序：避免底层表迭代顺序在各端不一致 → chunk 分页数/重绘次数分叉 → 联机不同步
  result.sort((a, b) => compareQuestIdForListOrder(a.id, b.id));
  return result;
}

export const EMPTY_TEXTS: Record<QuestType, string> = {
  [QuestType.MAIN]: "暂无主线任务",
  [QuestType.SIDE]: "暂无支线任务",
  [QuestType.DAILY]: "暂无小任务",
};
