import {
  TASK_UI_TOC_LOAD_KEY,
  TASK_UI_TOC_PATHS,
  ENABLE_FDF_A,
  ENABLE_FDF_B,
  ENABLE_FDF_SCROLLBAR,
  ENABLE_FDF_SCROLLBAR_BORDER,
  ENABLE_FDF_SCROLLBAR_THUMB,
  LIST_ITEM_H,
  LIST_VIEW_H,
  LIST_CONTENT_TOP_INSET,
  LIST_CONTAINER_W,
  LIST_CONTENT_LEFT_INSET,
  QUEST_ROW_ICON_HEIGHT_FACTOR,
  QUEST_ROW_ICON_PAD_LEFT,
  QUEST_ROW_TEXT_GAP_AFTER_ICON,
} from "./00．配置常量";
import { loadTocOnce } from "../../09．表现系统/01．UI工具";
import { questManager } from "../02．任务管理器";
import { questDB, QuestType, QuestStatus, QuestData } from "../01．任务数据";
import { DZ_TEXT_ALIGN_CENTER, DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/06．UI函数";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

export function dzGetLocalPlayer(): any {
  return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null;
}
export function dzPlayer(index: number): any {
  return typeof jass.Player === "function" ? jass.Player(index) : null;
}
export function questIdTailInRange01to20(id: string, prefix: string): boolean {
  if (id.length !== prefix.length + 3) return false;
  if (id.substring(0, prefix.length) !== prefix) return false;
  const tail = id.substring(prefix.length);
  if (tail.length !== 3) return false;
  return tail >= "001" && tail <= "020";
}
export function isQuestWithRowIconLayout(quest: QuestData): boolean {
  const id = quest.id;
  if (quest.type === QuestType.MAIN) return questIdTailInRange01to20(id, "main_");
  if (quest.type === QuestType.SIDE) return questIdTailInRange01to20(id, "side_");
  if (quest.type === QuestType.DAILY) return questIdTailInRange01to20(id, "daily_");
  return false;
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
export function tryCreateFromFdfWithSource(name: string, parent: number, fallback: () => number | null): { frame: number | null; fromFdf: boolean } {
  if (!isFdfFrameEnabled(name)) return { frame: fallback(), fromFdf: false };
  loadTocOnce(TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI");
  if (typeof (japi as any).DzCreateFrame !== "function") return { frame: fallback(), fromFdf: false };
  let f: number = 0;
  const ok = (pcall as any)(() => {
    f = (japi as any).DzCreateFrame(name, parent, 0);
  });
  if (ok && f != null && f !== 0) return { frame: f, fromFdf: true };
  return { frame: fallback(), fromFdf: false };
}
export function tryCreateFromFdfOnly(name: string, parent: number): number | null {
  const res = tryCreateFromFdfWithSource(name, parent, () => null);
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
export function getQuestsForUI(playerId: number, type: QuestType): QuestData[] {
  const active = questManager.getPlayerQuests(playerId, type).filter(q => !q.uiReserved);
  const completedIds = questDB.getPlayerCompletedQuests(playerId);
  const result: QuestData[] = active.slice();
  for (const id of completedIds) {
    const template = questDB.getQuest(id);
    if (!template || template.type !== type || template.uiReserved) continue;
    if (active.some(q => q.id === id)) continue;
    result.push({ ...template, status: QuestStatus.COMPLETED, objectives: template.objectives.map(o => ({ ...o, completed: true, current: o.required })) });
  }
  return result;
}
export const EMPTY_TEXTS: Record<QuestType, string> = {
  [QuestType.MAIN]: "暂无主线任务",
  [QuestType.SIDE]: "暂无支线任务",
  [QuestType.DAILY]: "暂无小任务",
};
export function getQuestItemHeight(quest: QuestData, expanded: boolean): number {
  if (!expanded) return LIST_ITEM_H * 0.4;
  return LIST_ITEM_H + quest.objectives.length * 0.03 + (quest.timeLimit && quest.timeLimit > 0 ? 0.02 : 0);
}
export function calcTotalContentHeight(quests: QuestData[], isExpanded: (questId: string) => boolean): number {
  let totalH = 0;
  for (let i = 0; i < quests.length; i++) {
    const q = quests[i];
    if (!q) continue;
    totalH += getQuestItemHeight(q, isExpanded(q.id)) + 0.01;
  }
  return totalH;
}
export function getMaxScroll(totalContentHeight: number): number {
  return Math.max(0, totalContentHeight - LIST_VIEW_H);
}
export function clampScrollOffset(scrollOffset: number, maxScroll: number): number {
  return Math.min(maxScroll, Math.max(0, scrollOffset));
}
export function isQuestRowFullyInsideView(rowTopRel: number, itemHeight: number, visibleTopRel: number, visibleBottomRel: number, eps: number): boolean {
  const itemTopRel = rowTopRel;
  const itemBottomRel = rowTopRel - itemHeight;
  return itemTopRel <= visibleTopRel + eps && itemBottomRel >= visibleBottomRel - eps;
}
export interface VisibleQuestRow {
  quest: QuestData;
  expanded: boolean;
  rowTopRel: number;
  itemHeight: number;
}
export function calcVisibleQuestRows(quests: QuestData[], scrollOffset: number, isExpanded: (questId: string) => boolean): VisibleQuestRow[] {
  const visibleRows: VisibleQuestRow[] = [];
  const visibleTopRel = LIST_CONTENT_TOP_INSET;
  const visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
  const EPS = 0.002;
  let rowTopRel = LIST_CONTENT_TOP_INSET + scrollOffset;
  for (let i = 0; i < quests.length; i++) {
    const q = quests[i];
    if (!q) continue;
    const expanded = isExpanded(q.id);
    const itemHeight = getQuestItemHeight(q, expanded);
    const fullyInside = isQuestRowFullyInsideView(rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, EPS);
    if (fullyInside) visibleRows.push({ quest: q, expanded, rowTopRel, itemHeight });
    rowTopRel -= itemHeight + 0.01;
  }
  return visibleRows;
}
export interface TaskListItemLayout {
  rowWidth: number;
  rowLeftRel: number;
  iconHLayout: number;
  textXRel: number;
  listTextAlign: number;
  textW: number;
}
export function calcTaskListItemLayout(showMainRowIcon: boolean): TaskListItemLayout {
  const rowWidth = LIST_CONTAINER_W * 0.9;
  const rowLeftRel = LIST_CONTENT_LEFT_INSET;
  const collapsedMainRowH = LIST_ITEM_H * 0.4;
  const iconHLayout = showMainRowIcon ? collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR : 0;
  const textXRel = showMainRowIcon ? rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON : rowLeftRel + 0.03;
  const listTextAlign = showMainRowIcon ? DZ_TEXT_ALIGN_LEFT : DZ_TEXT_ALIGN_CENTER;
  const rowTitleRightInset = 0.01;
  const textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset;
  return { rowWidth, rowLeftRel, iconHLayout, textXRel, listTextAlign, textW };
}
export function resolveQuestRowIconPath(icon: string | undefined): string {
  if (icon && icon !== "") return icon;
  return "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp";
}
