/**
 * 任务主面板壳体 + 列表容器 + 右侧滚动条
 *
 * 流程概览：
 * 1. TaskMainPanel：相对入口图标定位（无入口则退化为绝对坐标 + ENTRY_*）。
 * 2. TaskListContainer：任务行由列表模块渲染，此处只负责帧布局与显示。
 * 3. 顶部分类标签委托给 `07．任务UI分类标签`。
 * 4. 滚动条：FDF `TaskScrollBar` 或动态 BACKDROP；滑块用 VerticalScrollbarTrack 绑定列表滚动。
 */

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
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
  THUMB_DRAG_TICK,
  THUMB_DRAG_SENSITIVITY,
} from "./01．任务UI常量";
import { QuestType } from "../01．任务数据";
import { tryCreateFromFdfOnly, tryCreateFromFdfWithSource } from "./02．任务UI辅助";
import { buildTaskPanelCategoryTabs } from "./07．任务UI分类标签";
import { VerticalScrollbarTrack } from "../../09．表现系统/03．垂直滚动条轨道";

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
  onClickSound: () => void;
  onSwitchCategory: (type: QuestType) => void;
  onShowTabTooltip: (msg: string) => void;
  getTotalContentHeight: () => number;
  getScrollOffset: () => number;
  setScrollOffset: (v: number) => void;
  isVisible: () => boolean;
  onScrollChanged: () => void;
}

/**
 * 创建主面板及滚动区域；任一关键 FDF 缺失时返回空壳（各字段 null），上层应跳过绑定。
 *
 * 这里不负责渲染任务行内容，只负责把“主面板壳体 + 列表容器 + 分类标签 + 滚动轨道”搭起来。
 */
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
    getTotalContentHeight,
    getScrollOffset,
    setScrollOffset,
    isVisible,
    onScrollChanged,
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
    vScrollTrack: null,
  };

  const mainPanel = tryCreateFromFdfOnly("TaskMainPanel", parent);
  if (!mainPanel) return empty;

  if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(mainPanel);
  if (entryFrame) {
    // 正常路径：主面板跟随入口图标定位，便于入口位置调整时整块 UI 一起移动。
    setFramePointRelative(mainPanel, FramePoint.TOPLEFT, entryFrame, FramePoint.TOPLEFT, PANEL_REL_TO_ENTRY_X, PANEL_REL_TO_ENTRY_Y);
  } else {
    // 兜底路径：入口帧缺失时退回常量里的绝对坐标，避免整套任务 UI 直接失踪。
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
    // 列表模块只往这个容器里塞任务行；容器本身的尺寸/锚点统一在这里管理。
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
  });

  // 轨道：优先 TOC/FDF，失败则用代码创建窄条 BACKDROP
  const sbSrc = tryCreateFromFdfWithSource("TaskScrollBar", mainPanel, () => {
    // BACKDROP 只承担视觉轨道；不要把它当原生 Slider 用，数值滚动交给 VerticalScrollbarTrack。
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
    // thumb 本体是 BACKDROP，不直接接点击；命中层和拖拽注册都由 VerticalScrollbarTrack 内部统一处理。
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
    // attach 之后才会创建透明 hit button 并挂好鼠标拖拽/滚轮逻辑。
    vScrollTrack.attach();
    scrollThumbHitBtn = vScrollTrack.getHitButtonFrame();
  }

  return {
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
    vScrollTrack,
  };
}
