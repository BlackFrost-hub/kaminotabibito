import { QuestType, QuestData } from "../01．任务数据";
import { LIST_ITEM_H, QUEST_ROW_ICON_PAD_LEFT, QUEST_ROW_ICON_Y_OFFSET, BG_TEX, LIST_CONTAINER_W } from "./00．配置常量";
import {
  getStatusText,
  isQuestWithRowIconLayout,
  tryCreateFromFdfOnly,
  getQuestItemHeight,
  calcTaskListItemLayout,
  resolveQuestRowIconPath,
  getQuestsForUI,
  EMPTY_TEXTS,
  calcTotalContentHeight,
  getMaxScroll,
  clampScrollOffset,
  calcVisibleQuestRows,
} from "./01．通用工具";

const EXPANDED_OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35;
const EXPANDED_OBJECTIVE_ROW_HEIGHT = LIST_ITEM_H * 0.25;
const EXPANDED_FAIL_ROW_HEIGHT = LIST_ITEM_H * 0.2;

function buildObjectiveText(completed: boolean, description: string, current: number, required: number): string {
  return (completed ? "[v] " : "[ ] ") + description + " (" + current + "/" + required + ")";
}
function buildFailText(timeLimit: number): string {
  return "失败: 时间限制 " + timeLimit + "秒";
}

export function renderExpandedQuestDetails(opts: {
  japi: any; quest: QuestData; listParent: number; rowTopRel: number; textXRel: number; textW: number; listTextAlign: number;
  FramePoint: any; createTextLabel: any; setFramePointRelative: any; setFrameSize: any; applyDzTextFontAndAlignment: any; showFrame: any;
  objFrameByKey: Map<string, number>; failFrameByQuestId: Map<string, number>; listItemFrames: number[];
}): boolean {
  const { japi, quest, listParent, rowTopRel, textXRel, textW, listTextAlign, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, objFrameByKey, failFrameByQuestId, listItemFrames } = opts;
  let objYRel = rowTopRel - EXPANDED_OBJECTIVE_START_OFFSET;
  for (const obj of quest.objectives) {
    const txt = buildObjectiveText(obj.completed, obj.description, obj.current, obj.required);
    const objKey = quest.id + "|" + obj.id;
    let objFrame = objFrameByKey.get(objKey) || 0;
    if (objFrame === 0) {
      objFrame = createTextLabel("TaskObj_" + quest.id + "_" + obj.id, listParent, txt, { relativeTo: listParent, point: FramePoint.TOPLEFT, relativePoint: FramePoint.TOPLEFT, x: textXRel, y: objYRel }, { width: textW, height: EXPANDED_OBJECTIVE_ROW_HEIGHT }) || 0;
      if (objFrame === 0) {
        objYRel -= EXPANDED_OBJECTIVE_ROW_HEIGHT;
        continue;
      }
      objFrameByKey.set(objKey, objFrame);
    } else {
      setFramePointRelative(objFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
      setFrameSize(objFrame, { width: textW, height: EXPANDED_OBJECTIVE_ROW_HEIGHT });
      if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(objFrame, txt);
    }
    applyDzTextFontAndAlignment(objFrame, listTextAlign);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(objFrame, 3);
    showFrame(objFrame);
    listItemFrames.push(objFrame);
    objYRel -= EXPANDED_OBJECTIVE_ROW_HEIGHT;
  }
  if (quest.timeLimit && quest.timeLimit > 0) {
    let failFrame = failFrameByQuestId.get(quest.id) || 0;
    const failText = buildFailText(quest.timeLimit);
    if (failFrame === 0) {
      failFrame = createTextLabel("TaskFail_" + quest.id, listParent, failText, { relativeTo: listParent, point: FramePoint.TOPLEFT, relativePoint: FramePoint.TOPLEFT, x: textXRel, y: objYRel }, { width: textW, height: EXPANDED_FAIL_ROW_HEIGHT }) || 0;
      if (failFrame === 0) return false;
      failFrameByQuestId.set(quest.id, failFrame);
    } else {
      setFramePointRelative(failFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
      setFrameSize(failFrame, { width: textW, height: EXPANDED_FAIL_ROW_HEIGHT });
      if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(failFrame, failText);
    }
    applyDzTextFontAndAlignment(failFrame, listTextAlign);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(failFrame, 3);
    showFrame(failFrame);
    listItemFrames.push(failFrame);
  }
  return true;
}

export function renderQuestRow(opts: {
  japi: any; quest: QuestData; rowTopRel: number; expanded: boolean; listParent: number; FrameType: any; FramePoint: any;
  createFrame: any; createTextLabel: any; setFrameTexture: any; setFramePointRelative: any; setFrameSize: any; setFrameClickEvent: any; showFrame: any; applyDzTextFontAndAlignment: any;
  onToggleExpand: (questId: string) => void; onClickSound: () => void;
  rowBackdropByQuestId: Map<string, number>; titleByQuestId: Map<string, number>; clickBtnByQuestId: Map<string, number>; objFrameByKey: Map<string, number>; failFrameByQuestId: Map<string, number>; rowIconByQuestId: Map<string, number>; listItemFrames: number[];
}): boolean {
  const { japi, quest, rowTopRel, expanded, listParent, FrameType, FramePoint, createFrame, createTextLabel, setFrameTexture, setFramePointRelative, setFrameSize, setFrameClickEvent, showFrame, applyDzTextFontAndAlignment, onToggleExpand, onClickSound, rowBackdropByQuestId, titleByQuestId, clickBtnByQuestId, objFrameByKey, failFrameByQuestId, rowIconByQuestId, listItemFrames } = opts;
  const itemH = getQuestItemHeight(quest, expanded);
  const statusText = getStatusText(quest.status);
  const showMainRowIcon = isQuestWithRowIconLayout(quest);
  const { rowWidth, rowLeftRel, iconHLayout, textXRel, listTextAlign, textW } = calcTaskListItemLayout(showMainRowIcon);
  let rowBackdrop = rowBackdropByQuestId.get(quest.id) || 0;
  if (rowBackdrop === 0) {
    rowBackdrop = tryCreateFromFdfOnly("TaskButtonBackdrop", listParent) || 0;
    if (rowBackdrop === 0) {
      const bgFrame = createFrame({ type: FrameType.BACKDROP, name: "TaskItemBg_" + quest.id, parent: listParent, template: "template", visible: true }) || 0;
      rowBackdrop = bgFrame || 0;
      if (rowBackdrop !== 0) setFrameTexture(rowBackdrop, BG_TEX);
    }
    if (rowBackdrop !== 0) rowBackdropByQuestId.set(quest.id, rowBackdrop);
  }
  if (rowBackdrop === 0) return false;
  setFramePointRelative(rowBackdrop, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
  setFrameSize(rowBackdrop, { width: rowWidth, height: itemH });
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(rowBackdrop, 1);
  showFrame(rowBackdrop);
  listItemFrames.push(rowBackdrop);
  const titleText = quest.title + " [" + statusText + "]";
  let titleFrame = titleByQuestId.get(quest.id) || 0;
  if (titleFrame === 0) {
    titleFrame = createTextLabel("TaskItem_" + quest.id, listParent, titleText, { relativeTo: listParent, point: FramePoint.TOPLEFT, relativePoint: FramePoint.TOPLEFT, x: textXRel, y: rowTopRel - 0.005 }, { width: textW, height: LIST_ITEM_H * 0.38 }) || 0;
    if (titleFrame === 0) return false;
    titleByQuestId.set(quest.id, titleFrame);
  } else {
    setFramePointRelative(titleFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, rowTopRel - 0.005);
    setFrameSize(titleFrame, { width: textW, height: LIST_ITEM_H * 0.38 });
    if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(titleFrame, titleText);
  }
  applyDzTextFontAndAlignment(titleFrame, listTextAlign);
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(titleFrame, 3);
  showFrame(titleFrame);
  listItemFrames.push(titleFrame);
  let clickBtn = clickBtnByQuestId.get(quest.id) || 0;
  if (clickBtn === 0) {
    clickBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "TaskItemClick_" + quest.id, parent: listParent, template: "template", visible: true, enable: true, alpha: 0 }) || 0;
    if (clickBtn === 0) return false;
    clickBtnByQuestId.set(quest.id, clickBtn);
  }
  setFramePointRelative(clickBtn, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
  setFrameSize(clickBtn, { width: rowWidth, height: itemH });
  setFrameClickEvent(clickBtn, () => { onClickSound(); onToggleExpand(quest.id); }, false);
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(clickBtn, 4);
  showFrame(clickBtn);
  listItemFrames.push(clickBtn);
  if (showMainRowIcon) {
    const iconPath = resolveQuestRowIconPath(quest.icon);
    let iconFr = rowIconByQuestId.get(quest.id) || 0;
    if (iconFr === 0) {
      iconFr = createFrame({ type: FrameType.BACKDROP, name: "TaskQuestRowIcon_" + quest.id, parent: listParent, template: "template", visible: true }) || 0;
      if (iconFr !== 0) {
        setFrameTexture(iconFr, iconPath);
        rowIconByQuestId.set(quest.id, iconFr);
      }
    } else {
      setFrameTexture(iconFr, iconPath);
    }
    if (iconFr !== 0) {
      const iconH = iconHLayout;
      const iconW = iconH;
      setFramePointRelative(iconFr, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel + QUEST_ROW_ICON_PAD_LEFT, rowTopRel - QUEST_ROW_ICON_Y_OFFSET);
      setFrameSize(iconFr, { width: iconW, height: iconH });
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(iconFr, 5);
      showFrame(iconFr);
      listItemFrames.push(iconFr);
    }
  }
  if (expanded) {
    const ok = renderExpandedQuestDetails({ japi, quest, listParent, rowTopRel, textXRel, textW, listTextAlign, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, objFrameByKey, failFrameByQuestId, listItemFrames });
    if (!ok) return false;
  }
  return true;
}

export function refreshTaskUIList(opts: {
  currentPlayerId: number; currentCategory: QuestType; scrollOffset: number; setScrollOffset: (v: number) => void; setTotalContentHeight: (v: number) => void;
  listContainer: number; expandedQuestIds: Set<string>; createTextLabel: any; FramePoint: any; applyDzTextFontAndCenterAlignment: any;
  pushListItemFrame: (f: number) => void; syncScrollThumb: (maxScroll: number) => void; updateScrollBarVisibility: (maxScroll: number) => void; createListItem: (quest: any, rowTopRel: number, expanded: boolean) => void;
}): void {
  const { currentPlayerId, currentCategory, scrollOffset, setScrollOffset, setTotalContentHeight, listContainer, expandedQuestIds, createTextLabel, FramePoint, applyDzTextFontAndCenterAlignment, pushListItemFrame, syncScrollThumb, updateScrollBarVisibility, createListItem } = opts;
  const quests = getQuestsForUI(currentPlayerId, currentCategory);
  if (quests.length === 0) {
    setTotalContentHeight(0);
    setScrollOffset(0);
    const empty = createTextLabel("TaskEmpty", listContainer, EMPTY_TEXTS[currentCategory], { relativeTo: listContainer, point: FramePoint.CENTER, relativePoint: FramePoint.CENTER, x: 0, y: 0 }, { width: LIST_CONTAINER_W * 0.85, height: 0.08 });
    if (empty) {
      pushListItemFrame(empty);
      applyDzTextFontAndCenterAlignment(empty);
    }
    syncScrollThumb(0);
    updateScrollBarVisibility(0);
    return;
  }
  const totalH = calcTotalContentHeight(quests, (questId: string) => expandedQuestIds.has(questId));
  setTotalContentHeight(totalH);
  const maxScroll = getMaxScroll(totalH);
  const clamped = clampScrollOffset(scrollOffset, maxScroll);
  setScrollOffset(clamped);
  syncScrollThumb(maxScroll);
  updateScrollBarVisibility(maxScroll);
  const visibleRows = calcVisibleQuestRows(quests, clamped, (questId: string) => expandedQuestIds.has(questId));
  for (let i = 0; i < visibleRows.length; i++) {
    const row = visibleRows[i];
    if (!row) continue;
    createListItem(row.quest, row.rowTopRel, row.expanded);
  }
}
