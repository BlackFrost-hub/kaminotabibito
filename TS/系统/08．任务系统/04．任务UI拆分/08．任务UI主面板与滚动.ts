/**
 * 任务主面板壳体 + 列表容器 + 右侧滚动条
 *
 * 架构：全局1套UI，不再区分 slotPid。
 */

const japi = require("jass.japi") as any;

import {
  ENTRY_X,
  ENTRY_Y,
  PANEL_REL_TO_ENTRY_X,
  PANEL_REL_TO_ENTRY_Y,
  PANEL_W,
  PANEL_H,
  LIST_CONTAINER_REL_TO_PANEL_X,
  LIST_CONTAINER_REL_TO_PANEL_Y,
  SCROLLBAR_REL_X,
  SCROLLBAR_TOP_INSET,
  SCROLLBAR_BOTTOM_INSET,
  SCROLLBAR_W,
  LIST_VIEW_H,
  SCROLL_THUMB_SIZE,
  ENABLE_TASK_UI_RIGHT_SCROLLBAR,
} from "./01．任务UI常量";
import { QuestType } from "../01．任务数据";
import { tryCreateFromFdfOnly, tryCreateFromFdfWithSource, pcallDzFrameShow } from "./02．任务UI辅助";
import { buildTaskPanelCategoryTabs } from "./07．任务UI分类标签";

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
}

export interface BuildTaskMainPanelOpts {
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
  onClickSound: (this: void) => void;
  onSwitchCategory: (this: void, type: QuestType) => void;
  onShowTabTooltip: (this: void, msg: string) => void;
  slotId: number;
  contextId: number;
}

export function buildTaskMainPanel(opts: BuildTaskMainPanelOpts): BuildMainPanelResult {
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
    slotId,
    contextId,
  } = opts;

  const empty: BuildMainPanelResult = {
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
  };

  const mainPanel = tryCreateFromFdfOnly("TaskMainPanel", parent);
  if (!mainPanel) {
    return empty;
  }

  (japi as any).DzFrameClearAllPoints(mainPanel);
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
    (japi as any).DzFrameClearAllPoints(listContainer);
    setFramePointRelative(
      listContainer,
      FramePoint.TOPLEFT,
      mainPanel,
      FramePoint.TOPLEFT,
      LIST_CONTAINER_REL_TO_PANEL_X,
      LIST_CONTAINER_REL_TO_PANEL_Y
    );
    pcallDzFrameShow(listContainer, true);
  }

  const tabs = buildTaskPanelCategoryTabs({
    japi,
    tabParent: mainPanel,
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
    slotId,
    contextId,
  });

  let scrollBarFrame: number | null = null;
  let scrollThumbFrame: number | null = null;
  let scrollThumbHitBtn: number | null = null;

  if (ENABLE_TASK_UI_RIGHT_SCROLLBAR) {
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
    scrollBarFrame = sbSrc.frame;
    if (scrollBarFrame && scrollBarFrame !== 0) {
      (japi as any).DzFrameShow(scrollBarFrame, true);
      (japi as any).DzFrameClearAllPoints(scrollBarFrame);
      setFramePointRelative(scrollBarFrame, FramePoint.TOPRIGHT, mainPanel, FramePoint.TOPRIGHT, SCROLLBAR_REL_X, -SCROLLBAR_TOP_INSET);
      setFramePointRelative(scrollBarFrame, FramePoint.BOTTOMRIGHT, mainPanel, FramePoint.BOTTOMRIGHT, SCROLLBAR_REL_X, SCROLLBAR_BOTTOM_INSET);
      setFrameSize(scrollBarFrame, { width: SCROLLBAR_W, height: LIST_VIEW_H });
    }

    scrollThumbFrame =
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
      if (scrollBarFrame && scrollBarFrame !== 0) {
        setFramePointRelative(
          scrollThumbFrame,
          FramePoint.TOPLEFT,
          scrollBarFrame,
          FramePoint.TOPLEFT,
          (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5,
          0
        );
      }
      (japi as any).DzFrameShow(scrollThumbFrame, true);

      scrollThumbHitBtn =
        createFrame({
          type: FrameType.GLUETEXTBUTTON,
          name: "TaskScrollThumbHitDyn",
          parent: mainPanel,
          template: "template",
          visible: true,
        }) ?? 0;
      if (scrollThumbHitBtn && scrollThumbHitBtn !== 0) {
        setupTransparentGlueHitLayer(scrollThumbFrame, scrollThumbHitBtn);
        (japi as any).DzFrameShow(scrollThumbHitBtn, true);
      }
    }
  }

  const result: BuildMainPanelResult = {
    mainPanel,
    listContainer,
    tabMainBg: tabs.tabMainBg,
    tabMain: tabs.tabMain,
    tabSideBg: tabs.tabSideBg,
    tabSide: tabs.tabSide,
    tabDailyBg: tabs.tabDailyBg,
    tabDaily: tabs.tabDaily,
    scrollBarFrame: scrollBarFrame ?? null,
    scrollThumbFrame: scrollThumbFrame ?? null,
    scrollThumbHitBtn,
  };
  return result;
}
