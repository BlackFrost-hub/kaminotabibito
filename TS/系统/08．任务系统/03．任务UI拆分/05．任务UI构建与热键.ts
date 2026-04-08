import { QuestType } from "../01．任务数据";
import {
  ENTRY_X,
  ENTRY_Y,
  ENTRY_W,
  ENTRY_H,
  ENTRY_TITLE_TEXT_BOX_W,
  ENTRY_TITLE_TEXT_BOX_H,
  PANEL_REL_TO_ENTRY_X,
  PANEL_REL_TO_ENTRY_Y,
  PANEL_W,
  PANEL_H,
  LIST_CONTAINER_REL_TO_PANEL_X,
  LIST_CONTAINER_REL_TO_PANEL_Y,
  TAB_REL_Y,
  TAB_FRAME_W,
  TAB_FRAME_H,
  TAB_CATEGORY_FONT_SCALE,
  SCROLLBAR_REL_X,
  SCROLLBAR_TOP_INSET,
  SCROLLBAR_BOTTOM_INSET,
  SCROLLBAR_W,
  LIST_VIEW_H,
  SCROLL_THUMB_SIZE,
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
  THUMB_DRAG_TICK,
  THUMB_DRAG_SENSITIVITY,
} from "./01．任务UI常量";
import { tryCreateFromFdfOnly, tryCreateFromFdfWithSource } from "./02．任务UI辅助";
import { VerticalScrollbarTrack } from "../../09．表现系统/02．垂直滚动条轨道";

const jass = require("jass.common") as any;

// ────────────────────────────────────────────────
// 热键注册
// ────────────────────────────────────────────────

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

  registerKeyDown(KEY_NUM.K1, (_player: any) => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.MAIN);
    });
  });

  registerKeyDown(KEY_NUM.K2, (_player: any) => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.SIDE);
    });
  });

  registerKeyDown(KEY_NUM.K3, (_player: any) => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.DAILY);
    });
  });
}

// ────────────────────────────────────────────────
// 入口构建
// ────────────────────────────────────────────────

export interface BuildEntryIconResult {
  entryFrame: number | null;
  entryText: number | null;
}

export function buildTaskEntryIcon(opts: {
  japi: any;
  parent: number;
  FrameType: any;
  FramePoint: any;
  createFrame: any;
  createTextLabel: any;
  setFramePosition: any;
  setFrameSize: any;
  setFramePointRelative: any;
  setFrameClickEvent: any;
  applyDzTextFontAndCenterAlignment: any;
  onClickSound: () => void;
  onTogglePanel: () => void;
}): BuildEntryIconResult {
  const {
    japi,
    parent,
    FrameType,
    FramePoint,
    createFrame,
    createTextLabel,
    setFramePosition,
    setFrameSize,
    setFramePointRelative,
    setFrameClickEvent,
    applyDzTextFontAndCenterAlignment,
    onClickSound,
    onTogglePanel,
  } = opts;

  const entryFrame = tryCreateFromFdfOnly("TaskEntryIcon", parent);
  if (!entryFrame) return { entryFrame: null, entryText: null };

  setFramePosition(entryFrame, { point: FramePoint.TOPLEFT, x: ENTRY_X, y: ENTRY_Y });
  setFrameSize(entryFrame, { width: ENTRY_W, height: ENTRY_H });

  const tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W;
  const th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H;
  const titleRel = {
    relativeTo: entryFrame,
    point: FramePoint.CENTER,
    relativePoint: FramePoint.CENTER,
    x: 0,
    y: 0,
  };

  let entryText: number | null = null;
  const textFrame =
    createFrame({
      type: FrameType.TEXT,
      name: "TaskEntryText",
      parent: entryFrame,
      template: "template",
      visible: true,
    }) ?? 0;
  if (textFrame != null && textFrame !== 0) {
    entryText = textFrame;
    setFramePointRelative(textFrame, titleRel.point, titleRel.relativeTo, titleRel.relativePoint, titleRel.x, titleRel.y);
    setFrameSize(textFrame, { width: tw, height: th });
  } else {
    entryText = createTextLabel("TaskEntryText", entryFrame, "", titleRel, { width: tw, height: th });
  }

  if (entryText != null && entryText !== 0) {
    if (typeof (japi as any).DzFrameSetText === "function") {
      (japi as any).DzFrameSetText(entryText, "|cffffcc00任务(J)|r");
    }
    applyDzTextFontAndCenterAlignment(entryText);
  }

  const btn =
    createFrame({
      type: FrameType.GLUETEXTBUTTON,
      name: "TaskEntryBtn",
      parent: entryFrame,
      template: "template",
      visible: true,
      enable: true,
      alpha: 0,
    }) ?? 0;
  if (btn && typeof (japi as any).DzFrameSetAllPoints === "function") {
    (japi as any).DzFrameSetAllPoints(btn, entryFrame);
    setFrameClickEvent(
      btn,
      () => {
        onClickSound();
        onTogglePanel();
      },
      false
    );
  }

  return { entryFrame, entryText };
}

// ────────────────────────────────────────────────
// 主面板构建
// ────────────────────────────────────────────────

export interface BuildMainPanelResult {
  mainPanel: number | null;
  listContainer: number | null;
  tabMainBg: number | null;
  tabMain: number | null;
  tabSideBg: number | null;
  tabSide: number | null;
  tabDailyBg: number | null;
  tabDaily: number | null;
  scrollBarFrame: number | null;
  scrollThumbFrame: number | null;
  scrollThumbHitBtn: number | null;
  vScrollTrack: VerticalScrollbarTrack | null;
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
}): { bg: number | null; tab: number | null } {
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

export function buildTaskMainPanel(opts: {
  japi: any;
  parent: number;
  entryFrame: number | null;
  FrameType: any;
  FramePoint: any;
  createFrame: any;
  setFramePosition: any;
  setFrameSize: any;
  setFramePointRelative: any;
  setFrameTexture: any;
  setFrameHoverEvents: any;
  setFrameClickEvent: any;
  setButtonText: any;
  createTabLabelTextOnBackdrop: any;
  setupTransparentGlueHitLayer: any;
  onClickSound: () => void;
  onSwitchCategory: (type: QuestType) => void;
  onShowTabTooltip: (msg: string) => void;
  getTotalContentHeight: () => number;
  getScrollOffset: () => number;
  setScrollOffset: (v: number) => void;
  isVisible: () => boolean;
  onScrollChanged: () => void;
}): BuildMainPanelResult {
  const {
    japi,
    parent,
    entryFrame,
    FrameType,
    FramePoint,
    createFrame,
    setFramePosition,
    setFrameSize,
    setFramePointRelative,
    setFrameTexture,
    setFrameHoverEvents,
    setFrameClickEvent,
    setButtonText,
    createTabLabelTextOnBackdrop,
    setupTransparentGlueHitLayer,
    onClickSound,
    onSwitchCategory,
    onShowTabTooltip,
    getTotalContentHeight,
    getScrollOffset,
    setScrollOffset,
    isVisible,
    onScrollChanged,
  } = opts;

  const mainPanel = tryCreateFromFdfOnly("TaskMainPanel", parent);
  if (!mainPanel) {
    return {
      mainPanel: null,
      listContainer: null,
      tabMainBg: null,
      tabMain: null,
      tabSideBg: null,
      tabSide: null,
      tabDailyBg: null,
      tabDaily: null,
      scrollBarFrame: null,
      scrollThumbFrame: null,
      scrollThumbHitBtn: null,
      vScrollTrack: null,
    };
  }

  if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(mainPanel);
  if (entryFrame) {
    setFramePointRelative(mainPanel, FramePoint.TOPLEFT, entryFrame, FramePoint.TOPLEFT, PANEL_REL_TO_ENTRY_X, PANEL_REL_TO_ENTRY_Y);
  } else {
    setFramePosition(mainPanel, {
      point: FramePoint.TOPLEFT,
      x: ENTRY_X + PANEL_REL_TO_ENTRY_X,
      y: ENTRY_Y + PANEL_REL_TO_ENTRY_Y,
    });
  }
  setFrameSize(mainPanel, { width: PANEL_W, height: PANEL_H });

  const listContainer = tryCreateFromFdfOnly("TaskListContainer", mainPanel);
  if (listContainer) {
    if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(listContainer);
    setFramePointRelative(
      listContainer,
      FramePoint.TOPLEFT,
      mainPanel,
      FramePoint.TOPLEFT,
      LIST_CONTAINER_REL_TO_PANEL_X,
      LIST_CONTAINER_REL_TO_PANEL_Y
    );
    if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(listContainer, true));
  }

  const tabParent = mainPanel;
  const mainResult = createTaskTab({
    japi,
    tabParent,
    bgName: "TaskTabMainBg",
    tabName: "TaskTabMain",
    labelName: "TaskTabMainLabel",
    x: 0.02,
    labelText: "|cffffcc00主线(1)|r",
    category: QuestType.MAIN,
    tooltip: "按 1 切换主线任务",
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
  });

  const sideResult = createTaskTab({
    japi,
    tabParent,
    bgName: "TaskTabSideBg",
    tabName: "TaskTabSide",
    labelName: "TaskTabSideLabel",
    x: 0.135,
    labelText: "|cffffcc00支线(2)|r",
    category: QuestType.SIDE,
    tooltip: "按 2 切换支线任务",
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
  });

  const dailyResult = createTaskTab({
    japi,
    tabParent,
    bgName: "TaskTabDailyBg",
    tabName: "TaskTabDaily",
    labelName: "TaskTabDailyLabel",
    x: 0.25,
    labelText: "|cffffcc00小任务(3)|r",
    category: QuestType.DAILY,
    tooltip: "按 3 切换小任务",
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
  });

  const sbSrc = tryCreateFromFdfWithSource("TaskScrollBar", mainPanel, () => {
    const f =
      createFrame({
        type: FrameType.BACKDROP,
        name: "TaskScrollBarBtn",
        parent: mainPanel,
        template: "template",
        visible: true,
      }) ?? 0;
    return f;
  });
  const scrollBarFrame = sbSrc.frame;
  if (scrollBarFrame && scrollBarFrame !== 0) {
    if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(scrollBarFrame, true);
    if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(scrollBarFrame);
    setFramePointRelative(scrollBarFrame, FramePoint.TOPRIGHT, mainPanel, FramePoint.TOPRIGHT, SCROLLBAR_REL_X, -SCROLLBAR_TOP_INSET);
    setFramePointRelative(scrollBarFrame, FramePoint.BOTTOMRIGHT, mainPanel, FramePoint.BOTTOMRIGHT, SCROLLBAR_REL_X, SCROLLBAR_BOTTOM_INSET);
    setFrameSize(scrollBarFrame, { width: SCROLLBAR_W, height: LIST_VIEW_H });
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(scrollBarFrame, 30);
  }

  const scrollThumbFrame =
    createFrame({
      type: FrameType.BACKDROP,
      name: "TaskScrollThumbDyn",
      parent: mainPanel,
      template: "template",
      visible: true,
    }) ?? 0;
  if (scrollThumbFrame && scrollThumbFrame !== 0) {
    setFrameTexture(scrollThumbFrame, "UI\\Widgets\\EscMenu\\Human\\slider-knob.blp");
    setFrameSize(scrollThumbFrame, { width: SCROLL_THUMB_SIZE, height: SCROLL_THUMB_SIZE });
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(scrollThumbFrame, 120);
    if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(scrollThumbFrame, true);
  }

  let vScrollTrack: VerticalScrollbarTrack | null = null;
  let scrollThumbHitBtn: number | null = null;
  if (scrollThumbFrame && scrollThumbFrame !== 0 && scrollBarFrame && scrollBarFrame !== 0) {
    vScrollTrack = new VerticalScrollbarTrack({
      trackFrame: scrollBarFrame,
      thumbFrame: scrollThumbFrame,
      hitButtonName: "TaskScrollThumbHit",
      listViewHeightNorm: LIST_VIEW_H,
      trackHeightNorm: LIST_VIEW_H,
      thumbSizeNorm: SCROLL_THUMB_SIZE,
      topCompensation: SCROLL_THUMB_TOP_COMPENSATION,
      bottomCompensation: SCROLL_THUMB_BOTTOM_COMPENSATION,
      dragTick: THUMB_DRAG_TICK,
      sensitivity: THUMB_DRAG_SENSITIVITY,
      getTotalContentHeight,
      getScrollOffset,
      setScrollOffset,
      isInteractionEnabled: isVisible,
      onScrollChanged,
      skipManualThumbSync: () => false,
    });
    vScrollTrack.attach();
    scrollThumbHitBtn = vScrollTrack.getHitButtonFrame();
  }

  return {
    mainPanel,
    listContainer,
    tabMainBg: mainResult.bg,
    tabMain: mainResult.tab,
    tabSideBg: sideResult.bg,
    tabSide: sideResult.tab,
    tabDailyBg: dailyResult.bg,
    tabDaily: dailyResult.tab,
    scrollBarFrame: scrollBarFrame ?? null,
    scrollThumbFrame: scrollThumbFrame ?? null,
    scrollThumbHitBtn,
    vScrollTrack,
  };
}
