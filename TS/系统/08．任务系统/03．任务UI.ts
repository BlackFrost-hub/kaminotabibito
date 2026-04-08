/**
 * 任务系统 - 全新任务 UI（魔兽原生风格）
 * 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
 * listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  TASK_UI_TOC_PATHS,
  TASK_UI_TOC_LOAD_KEY,
  ENABLE_FDF_A,
  ENABLE_FDF_B,
  ENABLE_FDF_SCROLLBAR,
  ENABLE_FDF_SCROLLBAR_BORDER,
  ENABLE_FDF_SCROLLBAR_THUMB,
  ENABLE_MOUSE_WHEEL_SCROLL,
  ENTRY_W,
  ENTRY_H,
  ENTRY_X,
  ENTRY_Y,
  ENTRY_TITLE_TEXT_BOX_W,
  ENTRY_TITLE_TEXT_BOX_H,
  PANEL_W,
  PANEL_H,
  TAB_FRAME_W,
  TAB_FRAME_H,
  TAB_CATEGORY_FONT_SCALE,
  LIST_ITEM_H,
  BG_TEX,
  PANEL_REL_TO_ENTRY_X,
  PANEL_REL_TO_ENTRY_Y,
  TAB_REL_Y,
  LIST_VIEW_H,
  SCROLLBAR_BOTTOM_INSET,
  SCROLLBAR_TOP_INSET,
  LIST_CONTAINER_REL_TO_PANEL_X,
  LIST_CONTAINER_REL_TO_PANEL_Y,
  LIST_CONTENT_LEFT_INSET,
  LIST_CONTENT_TOP_INSET,
  LIST_CONTAINER_W,
  SCROLLBAR_W,
  SCROLLBAR_REL_X,
  SCROLL_THUMB_SIZE,
  SCROLL_THUMB_TOP_COMPENSATION,
  SCROLL_THUMB_BOTTOM_COMPENSATION,
  THUMB_DRAG_TICK,
  THUMB_DRAG_SENSITIVITY,
  QUEST_ROW_ICON_HEIGHT_FACTOR,
  QUEST_ROW_ICON_PAD_LEFT,
  QUEST_ROW_TEXT_GAP_AFTER_ICON,
  QUEST_ROW_ICON_Y_OFFSET,
} from "./03．任务UI拆分/01．任务UI常量";
import {
  dzGetLocalPlayer,
  dzPlayer,
  isQuestWithRowIconLayout,
  isFdfFrameEnabled,
  tryCreateFromFdfWithSource,
  tryCreateFromFdfOnly,
  getStatusText,
  getQuestsForUI,
  EMPTY_TEXTS,
} from "./03．任务UI拆分/02．任务UI辅助";
import {
  getQuestItemHeight,
  calcTotalContentHeight,
  getMaxScroll,
  clampScrollOffset,
  isDescendantOf as isDescendantOfByJapi,
  isWheelTargetForTaskList as isWheelTargetForTaskListByJapi,
  computeNextScrollOffsetByWheel,
  updateScrollBarVisibility as updateScrollBarVisibilityByJapi,
  calcVisibleQuestRows,
  refreshTaskUIList,
} from "./03．任务UI拆分/03．任务UI列表与滚动";
import { renderQuestRow } from "./03．任务UI拆分/04．任务UI渲染";
import { registerTaskUIHotkeys, buildTaskMainPanel, buildTaskEntryIcon } from "./03．任务UI拆分/05．任务UI构建与热键";

import {
  getGameUI,
  registerKeyDown,
  KEY,
  KEY_NUM,
  getWheelDelta,
  getMouseFocus,
  registerMouseWheel,
} from "../00．核心系统/04．硬件函数";
import {
  createFrame,
  setFramePosition,
  setFrameSize,
  setFrameTexture,
  setButtonText,
  setFrameClickEvent,
  setFramePointRelative,
  setFrameHoverEvents,
  createTextLabel,
  loadTocOnce,
  FrameType,
  FramePoint,
  hideFrame,
  showFrame,
} from "../09．表现系统/01．UI工具";
import { VerticalScrollbarTrack } from "../09．表现系统/02．垂直滚动条轨道";
import { questManager } from "./02．任务管理器";
import { questDB, QuestType, QuestStatus, QuestData } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../00．核心系统/02．音效函数";
import {
  DZ_TEXT_ALIGN_CENTER,
  applyDzTextFontAndAlignment,
  applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop,
  setupTransparentGlueHitLayer,
} from "../00．核心系统/06．UI函数";

// （以上常量/辅助函数已拆分到 `03．任务UI拆分/*`）

class TaskUI {
  private entryFrame: number | null = null;
  private entryText: number | null = null;
  private mainPanel: number | null = null;
  private listContainer: number | null = null;
  private tabMain: number | null = null;
  private tabSide: number | null = null;
  private tabDaily: number | null = null;
  private tabMainBg: number | null = null;
  private tabSideBg: number | null = null;
  private tabDailyBg: number | null = null;
  private currentCategory: QuestType = QuestType.MAIN;
  private listItemFrames: number[] = [];
  private scrollBarFrame: number | null = null;
  private scrollThumbFrame: number | null = null;
  /** 叠在滑块上的透明按钮，用于接收按下/拖拽（BACKDROP 本身不响应点击） */
  private scrollThumbHitBtn: number | null = null;
  /** 封装：全局鼠标 + focus 判定 + thumb 同步（见 `垂直滚动条轨道.ts`） */
  private vScrollTrack: VerticalScrollbarTrack | null = null;
  /** 列表区域滚轮：用全局滚轮 + 父链判定，避免只绑在行 clickBtn 上时 TEXT/子帧抢焦点导致滚轮无效 */
  private taskListWheelTrig: unknown = null;
  private scrollOffset = 0;
  private totalContentHeight = 0;
  private expandedQuestIds = new Set<string>();
  private isVisible = false;
  private currentPlayerId = 0;

  // 复用动态创建的帧，避免每次刷新都创建同名帧（以及由此带来的溢出/性能问题）
  private rowBackdropByQuestId = new Map<string, number>();
  private titleByQuestId = new Map<string, number>();
  private clickBtnByQuestId = new Map<string, number>();
  private objFrameByKey = new Map<string, number>();   // questId|objectiveId
  private failFrameByQuestId = new Map<string, number>();
  private rowIconByQuestId = new Map<string, number>();

  public init(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      const gameUI = getGameUI();
      if (!gameUI) return;

      this.createEntryIcon(gameUI);
      this.createMainPanel(gameUI);
      this.registerTaskListWheel();
      this.registerRefreshCallback();
      this.hide();
    });
  }

  private registerRefreshCallback(): void {
    questManager.registerUIRefreshCallback((_playerId: number, _questId?: string) => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        this.refreshList();
      });
    });
  }

  /** 从 frame 沿父链向上，是否落在 ancestor 子树内 */
  private isDescendantOf(frame: number, ancestor: number): boolean {
    return isDescendantOfByJapi(japi, frame, ancestor);
  }

  /** 滚轮是否应作用在任务列表（列表容器、滚动条轨道、滑块及其子帧） */
  private isWheelTargetForTaskList(): boolean {
    if (!this.mainPanel) return false;
    return isWheelTargetForTaskListByJapi(
      japi,
      typeof getMouseFocus === "function" ? getMouseFocus : undefined,
      this.listContainer,
      this.scrollBarFrame,
      this.scrollThumbFrame,
      this.scrollThumbHitBtn
    );
  }

  private registerTaskListWheel(): void {
    if (!ENABLE_MOUSE_WHEEL_SCROLL) return;
    if (this.taskListWheelTrig) return;
    this.taskListWheelTrig = registerMouseWheel(false, () => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        if (!this.isWheelTargetForTaskList()) return;
        this.onListWheel();
      });
    });
  }

  private createEntryIcon(parent: number): void {
    const res = buildTaskEntryIcon({
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
      onClickSound: () => SoundUI_ClickPlay(),
      onTogglePanel: () => this.togglePanel(),
    });
    this.entryFrame = res.entryFrame;
    this.entryText = res.entryText;
  }

  private createMainPanel(parent: number): void {
    const res = buildTaskMainPanel({
      japi,
      parent,
      entryFrame: this.entryFrame,
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
      onClickSound: () => SoundUI_ClickPlay(),
      onSwitchCategory: (type: QuestType) => this.switchCategory(type),
      onShowTabTooltip: (msg: string) => this.showTabTooltip(msg),
      getTotalContentHeight: () => this.totalContentHeight,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      isVisible: () => this.isVisible,
      onScrollChanged: () => this.refreshList(),
    });

    this.mainPanel = res.mainPanel;
    this.listContainer = res.listContainer;
    this.tabMainBg = res.tabMainBg;
    this.tabMain = res.tabMain;
    this.tabSideBg = res.tabSideBg;
    this.tabSide = res.tabSide;
    this.tabDailyBg = res.tabDailyBg;
    this.tabDaily = res.tabDaily;
    this.scrollBarFrame = res.scrollBarFrame;
    this.scrollThumbFrame = res.scrollThumbFrame;
    this.scrollThumbHitBtn = res.scrollThumbHitBtn;
    this.vScrollTrack?.destroy();
    this.vScrollTrack = res.vScrollTrack;
  }

  private onListWheel(): void {
    const next = computeNextScrollOffsetByWheel(
      typeof getWheelDelta === "function" ? getWheelDelta : undefined,
      this.scrollOffset,
      this.totalContentHeight,
      LIST_VIEW_H
    );
    if (next === this.scrollOffset) return;
    this.scrollOffset = next;
    this.refreshList();
  }

  /** 手动同步圆形 thumb + 全局鼠标拖拽（逻辑在 `垂直滚动条轨道.ts`） */
  private setupThumbDrag(): void {
    if (!this.scrollThumbFrame || this.scrollThumbFrame === 0 || !this.mainPanel || !this.scrollBarFrame) return;
    this.vScrollTrack?.destroy();
    this.vScrollTrack = new VerticalScrollbarTrack({
      trackFrame: this.scrollBarFrame,
      thumbFrame: this.scrollThumbFrame,
      hitButtonName: "TaskScrollThumbHit",
      listViewHeightNorm: LIST_VIEW_H,
      trackHeightNorm: LIST_VIEW_H,
      thumbSizeNorm: SCROLL_THUMB_SIZE,
      topCompensation: SCROLL_THUMB_TOP_COMPENSATION,
      bottomCompensation: SCROLL_THUMB_BOTTOM_COMPENSATION,
      dragTick: THUMB_DRAG_TICK,
      sensitivity: THUMB_DRAG_SENSITIVITY,
      getTotalContentHeight: () => this.totalContentHeight,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v) => {
        this.scrollOffset = v;
      },
      isInteractionEnabled: () => this.isVisible,
      onScrollChanged: () => {
        this.refreshList();
      },
      skipManualThumbSync: () => false,
    });
    this.vScrollTrack.attach();
    this.scrollThumbHitBtn = this.vScrollTrack.getHitButtonFrame();
  }

  private syncScrollThumb(maxScroll: number): void {
    if (!this.vScrollTrack) return;
    this.vScrollTrack.syncThumbVisual(maxScroll);
  }

  /** 内容不足一屏时隐藏轨道与滑块，避免多余滚动条 */
  private updateScrollBarVisibility(maxScroll: number): void {
    updateScrollBarVisibilityByJapi(japi, maxScroll, [this.scrollBarFrame, this.scrollThumbFrame, this.scrollThumbHitBtn]);
  }

  private clearList(): void {
    for (const f of this.listItemFrames) {
      if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(f, false);
    }
    if (typeof (japi as any).DzFrameShow === "function") {
      for (const f of this.rowBackdropByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.titleByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.clickBtnByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.objFrameByKey.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.failFrameByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.rowIconByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
    }
    this.listItemFrames = [];
  }

  private showTabTooltip(msg: string): void {
    if (typeof (japi as any).DzGetTriggerUIEventPlayer !== "function" || typeof (jass as any).DisplayTextToPlayer !== "function") return;
    const p = (japi as any).DzGetTriggerUIEventPlayer();
    if (p) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
  }

  private switchCategory(type: QuestType): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      this.currentCategory = type;
      this.expandedQuestIds.clear();
      this.scrollOffset = 0;
      this.refreshList();
    });
  }

  private toggleExpand(questId: string): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (this.expandedQuestIds.has(questId)) {
        this.expandedQuestIds.delete(questId);
      } else {
        this.expandedQuestIds.add(questId);
      }
      this.refreshList();
    });
  }

  private refreshList(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel || !this.listContainer) return;
      this.clearList();
      refreshTaskUIList({
        currentPlayerId: this.currentPlayerId,
        currentCategory: this.currentCategory,
        scrollOffset: this.scrollOffset,
        setScrollOffset: (v: number) => {
          this.scrollOffset = v;
        },
        setTotalContentHeight: (v: number) => {
          this.totalContentHeight = v;
        },
        listContainer: this.listContainer,
        expandedQuestIds: this.expandedQuestIds,
        createTextLabel,
        FramePoint,
        applyDzTextFontAndCenterAlignment,
        pushListItemFrame: (f: number) => this.listItemFrames.push(f),
        syncScrollThumb: (maxScroll: number) => this.syncScrollThumb(maxScroll),
        updateScrollBarVisibility: (maxScroll: number) => this.updateScrollBarVisibility(maxScroll),
        createListItem: (quest: any, rowTopRel: number, expanded: boolean) => this.createListItem(quest, rowTopRel, expanded),
      });
    });
  }

  private createListItem(quest: QuestData, rowTopRel: number, expanded: boolean): number | null {
    const listParent = this.listContainer;
    if (!this.mainPanel || !listParent) return null;
    const ok = renderQuestRow({
      japi,
      quest,
      rowTopRel,
      expanded,
      listParent,
      FrameType,
      FramePoint,
      createFrame,
      createTextLabel,
      setFrameTexture,
      setFramePointRelative,
      setFrameSize,
      setFrameClickEvent,
      showFrame,
      applyDzTextFontAndAlignment,
      onToggleExpand: (questId: string) => this.toggleExpand(questId),
      onClickSound: () => SoundUI_ClickPlay(),
      rowBackdropByQuestId: this.rowBackdropByQuestId,
      titleByQuestId: this.titleByQuestId,
      clickBtnByQuestId: this.clickBtnByQuestId,
      objFrameByKey: this.objFrameByKey,
      failFrameByQuestId: this.failFrameByQuestId,
      rowIconByQuestId: this.rowIconByQuestId,
      listItemFrames: this.listItemFrames,
    });
    if (!ok) return null;
    return 0;
  }

  private togglePanel(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      this.isVisible = !this.isVisible;
      if (this.isVisible) this.show(this.currentPlayerId);
      else this.hide();
    });
  }

  public show(playerId: number): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel) return;
      this.currentPlayerId = playerId;
      this.isVisible = true;
      showFrame(this.mainPanel);
      this.refreshList();
    });
  }

  public hide(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel) return;
      this.vScrollTrack?.cancelDrag();
      this.isVisible = false;
      hideFrame(this.mainPanel);
    });
  }

  public registerHotkey(): void {
    registerTaskUIHotkeys({
      registerKeyDown,
      KEY,
      KEY_NUM,
      onClickSound: () => SoundUI_ClickPlay(),
      onTogglePanel: () => this.togglePanel(),
      onSwitchCategory: (type: QuestType) => this.switchCategory(type),
      isVisible: () => this.isVisible,
      setCurrentPlayerId: (pid: number) => {
        this.currentPlayerId = pid;
      },
    });
  }
}

export const taskUI = new TaskUI();

export function init(): void {
  taskUI.init();
}

export function registerHotkey(): void {
  taskUI.registerHotkey();
}
