/**
 * 主面板顶部分类标签（主线 / 支线 / 小任务）
 *
 * 每个分类一组：可选背景底图 + 可点标签 + 文案；标签与底图用透明命中层对齐（setupTransparentGlueHitLayer）。
 * 仅被主面板构建使用；不在这里创建 listContainer 或滚动条。
 */

import { QuestType } from "../01．任务数据";
import { TAB_REL_Y, TAB_FRAME_W, TAB_FRAME_H, TAB_CATEGORY_FONT_SCALE } from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";

/** 单个分类的标签构建结果：bg 可能为 null（无 FDF 底图时走纯透明标签） */
interface TabPair {
  bg: number | null;
  tab: number | null;
}

export interface TaskCategoryTabFrames {
  tabMainBg: number | null;
  tabMain: number | null;
  tabSideBg: number | null;
  tabSide: number | null;
  tabDailyBg: number | null;
  tabDaily: number | null;
}

export interface BuildTaskCategoryTabsOpts {
  japi: any;
  /** 一般为 TaskMainPanel 根帧 */
  tabParent: number;
  FramePoint: any;
  setFramePointRelative: any;
  setFrameSize: any;
  setFrameHoverEvents: any;
  setFrameClickEvent: any;
  setButtonText: any;
  createTabLabelTextOnBackdrop: any;
  setupTransparentGlueHitLayer: any;
  onClickSound: () => void;
  onSwitchCategory: (type: QuestType) => void;
  onShowTabTooltip: (msg: string) => void;
  /** 槽位号 0..N-1，多槽位 FDF 实例 contextId，区分同名分类背景/标签帧 */
  slotPid?: number;
}

/**
 * 创建一组标签：背景（若 FDF 存在）、Dz 文字、点击切分类、悬停 tooltip。
 */
function createTaskTab(opts: {
  japi: any;
  tabParent: number;
  bgName: string;
  tabName: string;
  labelName: string;
  x: number;
  labelText: string;
  category: QuestType;
  tooltip: string;
  FramePoint: any;
  setFramePointRelative: any;
  setFrameSize: any;
  setFrameHoverEvents: any;
  setFrameClickEvent: any;
  setButtonText: any;
  createTabLabelTextOnBackdrop: any;
  setupTransparentGlueHitLayer: any;
  onClickSound: () => void;
  onSwitchCategory: (type: QuestType) => void;
  onShowTabTooltip: (msg: string) => void;
  ctxId: number;
}): TabPair {
  const {
    japi,
    tabParent,
    bgName,
    tabName,
    labelName,
    x,
    labelText,
    category,
    tooltip,
    FramePoint,
    setFramePointRelative,
    setFrameSize,
    setFrameHoverEvents,
    setFrameClickEvent,
    setButtonText,
    createTabLabelTextOnBackdrop,
    setupTransparentGlueHitLayer,
    onClickSound,
    onSwitchCategory,
    onShowTabTooltip,
    ctxId,
  } = opts;

  const bg = tryCreateFromFdfOnly(bgName, tabParent, ctxId);
  if (bg) {
    if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(bg);
    setFramePointRelative(bg, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, x, TAB_REL_Y);
    setFrameSize(bg, { width: TAB_FRAME_W, height: TAB_FRAME_H });
    if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(bg, true));
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(bg, 7);
  }

  if (bg) {
    const tabLabel = createTabLabelTextOnBackdrop(bg, labelName, labelText, TAB_CATEGORY_FONT_SCALE);
    if (tabLabel && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tabLabel, 8);
  }

  const tab = tryCreateFromFdfOnly(tabName, tabParent, ctxId);
  if (tab) {
    if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(tab);
    if (bg) {
      setupTransparentGlueHitLayer(bg, tab);
    } else {
      setFramePointRelative(tab, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, x, TAB_REL_Y);
      setFrameSize(tab, { width: TAB_FRAME_W, height: TAB_FRAME_H });
    }
    if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(tab, true));
    if (!bg) {
      setButtonText(tab, "");
      if (typeof (japi as any).DzFrameSetAlpha === "function") {
        (pcall as any)(() => (japi as any).DzFrameSetAlpha(tab, 0));
      }
    }
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tab, 9);
    setFrameClickEvent(
      tab,
      () => {
        onClickSound();
        onSwitchCategory(category);
      },
      false
    );
    setFrameHoverEvents(tab, () => onShowTabTooltip(tooltip), () => {}, false);
  }

  return { bg, tab };
}

/**
 * 在主面板上铺好三个分类标签；x 位置与热键 1/2/3、文案「主线(1)」等保持一致。
 */
export function buildTaskPanelCategoryTabs(opts: BuildTaskCategoryTabsOpts): TaskCategoryTabFrames {
  const {
    japi,
    tabParent,
    FramePoint,
    setFramePointRelative,
    setFrameSize,
    setFrameHoverEvents,
    setFrameClickEvent,
    setButtonText,
    createTabLabelTextOnBackdrop,
    setupTransparentGlueHitLayer,
    onClickSound,
    onSwitchCategory,
    onShowTabTooltip,
  } = opts;

  const common = {
    japi,
    tabParent,
    FramePoint,
    setFramePointRelative,
    setFrameSize,
    setFrameHoverEvents,
    setFrameClickEvent,
    setButtonText,
    createTabLabelTextOnBackdrop,
    setupTransparentGlueHitLayer,
    onClickSound,
    onSwitchCategory,
    onShowTabTooltip,
    ctxId: opts.slotPid ?? 0,
  };
  const suf = `_s${common.ctxId}`;

  const mainResult = createTaskTab({
    ...common,
    bgName: "TaskTabMainBg",
    tabName: "TaskTabMain",
    labelName: "TaskTabMainLabel" + suf,
    x: 0.02,
    labelText: "|cffffcc00主线(1)|r",
    category: QuestType.MAIN,
    tooltip: "按 1 切换主线任务",
  });

  const sideResult = createTaskTab({
    ...common,
    bgName: "TaskTabSideBg",
    tabName: "TaskTabSide",
    labelName: "TaskTabSideLabel" + suf,
    x: 0.135,
    labelText: "|cffffcc00支线(2)|r",
    category: QuestType.SIDE,
    tooltip: "按 2 切换支线任务",
  });

  const dailyResult = createTaskTab({
    ...common,
    bgName: "TaskTabDailyBg",
    tabName: "TaskTabDaily",
    labelName: "TaskTabDailyLabel" + suf,
    x: 0.25,
    labelText: "|cffffcc00小任务(3)|r",
    category: QuestType.DAILY,
    tooltip: "按 3 切换小任务",
  });

  return {
    tabMainBg: mainResult.bg,
    tabMain: mainResult.tab,
    tabSideBg: sideResult.bg,
    tabSide: sideResult.tab,
    tabDailyBg: dailyResult.bg,
    tabDaily: dailyResult.tab,
  };
}
