import { QuestType } from "../01．任务数据";
import { LIST_ITEM_H } from "./00．配置常量";

const jass = require("jass.common") as any;

export function registerTaskUIHotkeys(opts: {
  registerKeyDown: any;
  KEY: any;
  KEY_NUM: any;
  onClickSound: () => void;
  onTogglePanel: () => void;
  onSwitchCategory: (type: QuestType) => void;
  isVisible: () => boolean;
  setCurrentPlayerId: (pid: number) => void;
}): void {
  const { registerKeyDown, KEY, KEY_NUM, onClickSound, onTogglePanel, onSwitchCategory, isVisible, setCurrentPlayerId } = opts;
  if (typeof registerKeyDown !== "function") return;
  registerKeyDown(KEY.J, (player: any) => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;
      const getPid = typeof (jass as any).GetPlayerId === "function" ? (jass as any).GetPlayerId : null;
      if (getPid && player) setCurrentPlayerId(getPid(player));
      onClickSound();
      onTogglePanel();
    });
  });
  registerKeyDown(KEY_NUM.K1, () => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      if (jass.GetLocalPlayer() == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.MAIN);
    });
  });
  registerKeyDown(KEY_NUM.K2, () => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      if (jass.GetLocalPlayer() == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.SIDE);
    });
  });
  registerKeyDown(KEY_NUM.K3, () => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      if (jass.GetLocalPlayer() == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.DAILY);
    });
  });
}

function isDescendantOfFrame(japi: any, frame: number, ancestor: number): boolean {
  if (!frame || frame === 0 || !ancestor || ancestor === 0) return false;
  let cur: number = frame;
  for (let i = 0; i < 64; i++) {
    if (cur === ancestor) return true;
    const p = typeof (japi as any).DzFrameGetParent === "function" ? (japi as any).DzFrameGetParent(cur) : 0;
    if (!p || p === 0) return false;
    cur = p;
  }
  return false;
}

function isWheelTargetForTaskList(japi: any, getMouseFocus: (() => number) | undefined, listContainer: number | null, scrollBarFrame: number | null, scrollThumbFrame: number | null, scrollThumbHitBtn: number | null): boolean {
  const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
  if (!f || f === 0) return false;
  if (listContainer && (f === listContainer || isDescendantOfFrame(japi, f, listContainer))) return true;
  if (scrollBarFrame && (f === scrollBarFrame || isDescendantOfFrame(japi, f, scrollBarFrame))) return true;
  if (scrollThumbFrame && (f === scrollThumbFrame || isDescendantOfFrame(japi, f, scrollThumbFrame))) return true;
  if (scrollThumbHitBtn && f === scrollThumbHitBtn) return true;
  return false;
}

export const isDescendantOf = isDescendantOfFrame;
export { isWheelTargetForTaskList };

export function registerTaskListWheelBridge(opts: {
  japi: any; registerMouseWheel: any; getMouseFocus?: () => number; isVisible: () => boolean; isMainPanelReady: () => boolean;
  listContainer: () => number | null; scrollBarFrame: () => number | null; scrollThumbFrame: () => number | null; scrollThumbHitBtn: () => number | null; onWheelAccepted: () => void;
}): unknown {
  const { japi, registerMouseWheel, getMouseFocus, isVisible, isMainPanelReady, listContainer, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn, onWheelAccepted } = opts;
  if (typeof registerMouseWheel !== "function") return null;
  return registerMouseWheel(false, () => {
    (pcall as any)(() => {
      if (!isMainPanelReady()) return;
      if (!isVisible()) return;
      const ok = isWheelTargetForTaskList(japi, getMouseFocus, listContainer(), scrollBarFrame(), scrollThumbFrame(), scrollThumbHitBtn());
      if (!ok) return;
      onWheelAccepted();
    });
  });
}

export function applyWheelScrollOffset(opts: { getWheelDelta?: () => number; listItemHeight: number; listGap: number; totalContentHeight: number; listViewHeight: number; scrollOffset: number; setScrollOffset: (v: number) => void }): boolean {
  const { getWheelDelta, listItemHeight, listGap, totalContentHeight, listViewHeight, scrollOffset, setScrollOffset } = opts;
  const delta = typeof getWheelDelta === "function" ? getWheelDelta() : 0;
  if (delta === 0) return false;
  const step = listItemHeight + listGap;
  const maxScroll = Math.max(0, totalContentHeight - listViewHeight);
  let next = scrollOffset;
  if (delta > 0) next = Math.max(0, scrollOffset - step);
  else if (delta < 0) next = Math.min(maxScroll, scrollOffset + step);
  if (next === scrollOffset) return false;
  setScrollOffset(next);
  return true;
}

export function computeNextScrollOffsetByWheel(
  getWheelDelta: (() => number) | undefined,
  currentOffset: number,
  totalContentHeight: number,
  listViewHeight: number
): number {
  const delta = typeof getWheelDelta === "function" ? getWheelDelta() : 0;
  if (delta === 0) return currentOffset;
  const step = LIST_ITEM_H + 0.01;
  const maxScroll = Math.max(0, totalContentHeight - listViewHeight);
  if (delta > 0) return Math.max(0, currentOffset - step);
  if (delta < 0) return Math.min(maxScroll, currentOffset + step);
  return currentOffset;
}

export function syncTaskUIScrollThumb(vScrollTrack: any, maxScroll: number): void {
  if (!vScrollTrack) return;
  vScrollTrack.syncThumbVisual(maxScroll);
}

export function updateTaskUIScrollBarVisibility(japi: any, maxScroll: number, frames: Array<number | null>): void {
  const vis = maxScroll > 0;
  const show = (japi as any).DzFrameShow;
  if (typeof show !== "function") return;
  for (const f of frames) {
    if (f && f !== 0) (pcall as any)(() => show(f, vis));
  }
}

export const updateScrollBarVisibility = updateTaskUIScrollBarVisibility;

export function clearTaskUIReusableFrames(opts: {
  japi: any; listItemFrames: number[]; rowBackdropByQuestId: Map<string, number>; titleByQuestId: Map<string, number>; clickBtnByQuestId: Map<string, number>;
  objFrameByKey: Map<string, number>; failFrameByQuestId: Map<string, number>; rowIconByQuestId: Map<string, number>; setListItemFrames: (frames: number[]) => void;
}): void {
  const { japi, listItemFrames, rowBackdropByQuestId, titleByQuestId, clickBtnByQuestId, objFrameByKey, failFrameByQuestId, rowIconByQuestId, setListItemFrames } = opts;
  const show = (japi as any).DzFrameShow;
  if (typeof show !== "function") {
    setListItemFrames([]);
    return;
  }
  for (const f of listItemFrames) show(f, false);
  for (const f of rowBackdropByQuestId.values()) if (f !== 0) show(f, false);
  for (const f of titleByQuestId.values()) if (f !== 0) show(f, false);
  for (const f of clickBtnByQuestId.values()) if (f !== 0) show(f, false);
  for (const f of objFrameByKey.values()) if (f !== 0) show(f, false);
  for (const f of failFrameByQuestId.values()) if (f !== 0) show(f, false);
  for (const f of rowIconByQuestId.values()) if (f !== 0) show(f, false);
  setListItemFrames([]);
}

export function toggleTaskUIPanel(opts: { isVisible: () => boolean; setVisible: (v: boolean) => void; show: () => void; hide: () => void }): void {
  const { isVisible, setVisible, show, hide } = opts;
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    if (jass.GetLocalPlayer() == null) return;
    const next = !isVisible();
    setVisible(next);
    if (next) show();
    else hide();
  });
}
export function showTaskUIPanel(opts: { mainPanel: number | null; playerId: number; setCurrentPlayerId: (pid: number) => void; setVisible: (v: boolean) => void; showFrame: (f: number) => void; refreshList: () => void }): void {
  const { mainPanel, playerId, setCurrentPlayerId, setVisible, showFrame, refreshList } = opts;
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    if (jass.GetLocalPlayer() == null) return;
    if (!mainPanel) return;
    setCurrentPlayerId(playerId);
    setVisible(true);
    showFrame(mainPanel);
    refreshList();
  });
}
export function hideTaskUIPanel(opts: { mainPanel: number | null; vScrollTrack: any; setVisible: (v: boolean) => void; hideFrame: (f: number) => void }): void {
  const { mainPanel, vScrollTrack, setVisible, hideFrame } = opts;
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    if (jass.GetLocalPlayer() == null) return;
    if (!mainPanel) return;
    if (vScrollTrack && typeof vScrollTrack.cancelDrag === "function") vScrollTrack.cancelDrag();
    setVisible(false);
    hideFrame(mainPanel);
  });
}

export const LIST_WHEEL_STEP_BASE = LIST_ITEM_H;
