/**
 * 主面板顶部分类标签（主线 / 支线 / 小任务）
 *
 * 架构：全局1套UI，不再区分 slotPid。
 */

const japi = require("jass.japi") as any;

import { QuestType } from "../01．任务数据";
import { TAB_REL_Y, TAB_FRAME_W, TAB_FRAME_H, TAB_CATEGORY_FONT_SCALE } from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";

// 分类标签点击处理器缓存
const categoryTabClickHandlers: Map<QuestType, { onSwitchCategory: (type: QuestType) => void; onClickSound: () => void }> = new Map();

// 当前悬停提示消息（避免匿名闭包）
let currentTooltipMessage: string | null = null;
let currentTooltipHandler: ((msg: string) => void) | null = null;

function handleCategoryTabClick(category: QuestType): void {
  const handler = categoryTabClickHandlers.get(category);
  if (!handler) return;
  handler.onSwitchCategory(category);
  handler.onClickSound();
}

// 命名函数替代匿名闭包 - 分类标签点击
function onMainTabClick(): void { handleCategoryTabClick(QuestType.MAIN); }
function onSideTabClick(): void { handleCategoryTabClick(QuestType.SIDE); }
function onDailyTabClick(): void { handleCategoryTabClick(QuestType.DAILY); }

// 命名函数替代匿名闭包 - 悬停提示
function onTabHoverShow(): void {
  if (currentTooltipHandler && currentTooltipMessage) {
    currentTooltipHandler(currentTooltipMessage);
  }
}
function onTabHoverHide(): void { /* 空操作 */ }

const tabClickHandlers: Record<QuestType, () => void> = {
  [QuestType.MAIN]: onMainTabClick,
  [QuestType.SIDE]: onSideTabClick,
  [QuestType.DAILY]: onDailyTabClick,
};

function registerCategoryTabClickHandler(category: QuestType, onSwitchCategory: (type: QuestType) => void, onClickSound: () => void): void {
  categoryTabClickHandlers.set(category, { onSwitchCategory, onClickSound });
}

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
}

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
  } = opts;

  const bg = tryCreateFromFdfOnly(bgName, tabParent);
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

  const tab = tryCreateFromFdfOnly(tabName, tabParent);
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
    registerCategoryTabClickHandler(category, onSwitchCategory, onClickSound);
    // 使用命名函数替代匿名闭包，避免 JASS 回调中的闭包问题
    currentTooltipMessage = tooltip;
    currentTooltipHandler = onShowTabTooltip;
    setFrameClickEvent(tab, tabClickHandlers[category], false);
    setFrameHoverEvents(tab, onTabHoverShow, onTabHoverHide, false);
  }

  return { bg, tab };
}

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
  };
  const mainResult = createTaskTab({
    ...common,
    bgName: "TaskTabMainBg",
    tabName: "TaskTabMain",
    labelName: "TaskTabMainLabel",
    x: 0.02,
    labelText: "|cffffcc00主线(1)|r",
    category: QuestType.MAIN,
    tooltip: "切换到主线任务",
  });

  const sideResult = createTaskTab({
    ...common,
    bgName: "TaskTabSideBg",
    tabName: "TaskTabSide",
    labelName: "TaskTabSideLabel",
    x: 0.135,
    labelText: "|cffffcc00支线(2)|r",
    category: QuestType.SIDE,
    tooltip: "切换到支线任务",
  });

  const dailyResult = createTaskTab({
    ...common,
    bgName: "TaskTabDailyBg",
    tabName: "TaskTabDaily",
    labelName: "TaskTabDailyLabel",
    x: 0.25,
    labelText: "|cffffcc00小任务(3)|r",
    category: QuestType.DAILY,
    tooltip: "切换到小任务",
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
