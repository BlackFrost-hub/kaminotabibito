/**
 * 任务系统 - 全新任务 UI（魔兽原生风格）
 * 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
 * listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  refreshTaskUIFacadeList,
  createTaskUIListItem,
  clearTaskUIList,
} from "./04．任务UI拆分/09．任务UI列表控制";
import {
  registerTaskUIListWheel,
  handleTaskUIListWheel,
  syncTaskUIScrollThumb,
  updateTaskUIScrollBarVisibility,
} from "./04．任务UI拆分/10．任务UI滚动与滚轮";
import {
  registerTaskUIRefreshCallback,
  showTaskUITabTooltip,
  switchTaskUICategory,
  toggleTaskUIPanel,
  showTaskUIPanel,
  hideTaskUIPanel,
} from "./04．任务UI拆分/11．任务UI面板控制";
import { registerTaskUIHotkeys } from "./04．任务UI拆分/05．任务UI热键";
import { buildTaskEntryIcon } from "./04．任务UI拆分/06．任务UI入口图标";
import { buildTaskMainPanel } from "./04．任务UI拆分/08．任务UI主面板与滚动";

import {
  getGameUI,
  registerKeyDown,
  KEY,
  KEY_NUM,
  getWheelDelta,
  getMouseFocus,
  registerMouseWheel,
} from "../../lib/扩展函数/封装函数/04．硬件输入/index";
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
  FrameType,
  FramePoint,
  hideFrame,
  showFrame,
} from "../09．表现系统/01．UI工具/index";
import { VerticalScrollbarTrack } from "../09．表现系统/03．垂直滚动条轨道";
import { questManager } from "./02．任务管理器/index";
import { QuestType, QuestData } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../../lib/扩展函数/封装函数/02．音效系统/index";
import {
  applyDzTextFontAndAlignment,
  applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop,
  setupTransparentGlueHitLayer,
} from "../00．核心系统/03．UI函数";

// （以上常量/辅助函数已拆分到 `04．任务UI拆分/*`）

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
    registerTaskUIRefreshCallback(this.getPanelControlContext(), () => this.refreshList());
  }

  private registerTaskListWheel(): void {
    this.taskListWheelTrig = registerTaskUIListWheel(this.getScrollContext(), () => this.refreshList());
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
    handleTaskUIListWheel(this.getScrollContext(), () => this.refreshList());
  }

  private syncScrollThumb(maxScroll: number): void {
    syncTaskUIScrollThumb(this.getScrollContext(), maxScroll);
  }

  /** 无任务时隐藏轨道；有任务时始终显示轨道与滑块（内容不满一屏时滑块贴顶） */
  private updateScrollBarVisibility(maxScroll: number, hasQuestRows: boolean): void {
    updateTaskUIScrollBarVisibility(this.getScrollContext(), maxScroll, hasQuestRows);
  }

  private clearList(): void {
    clearTaskUIList(this.getListControlContext());
  }

  private showTabTooltip(msg: string): void {
    showTaskUITabTooltip(msg);
  }

  private switchCategory(type: QuestType): void {
    switchTaskUICategory(this.getPanelControlContext(), type, () => this.refreshList());
  }

  private toggleExpand(questId: string): void {
    const ctx = this.getListControlContext();
    if (ctx.expandedQuestIds.has(questId)) {
      ctx.expandedQuestIds.delete(questId);
    } else {
      ctx.expandedQuestIds.add(questId);
    }
    this.refreshList();
  }

  refreshList(): void {
    refreshTaskUIFacadeList(this.getListControlContext(), () => this.refreshList());
  }

  private createListItem(quest: QuestData, rowTopRel: number, expanded: boolean): number | null {
    return createTaskUIListItem(this.getListControlContext(), quest, rowTopRel, expanded, () => this.refreshList());
  }

  private togglePanel(): void {
    toggleTaskUIPanel(this.getPanelControlContext(), (playerId: number) => this.show(playerId), () => this.hide());
  }

  public show(playerId: number): void {
    showTaskUIPanel(this.getPanelControlContext(), playerId, () => this.refreshList());
  }

  public hide(): void {
    hideTaskUIPanel(this.getPanelControlContext());
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

  /** 把门面类的字段包装成“列表控制模块”可消费的上下文，避免拆分文件直接持有 `this`。 */
  private getListControlContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      currentPlayerId: this.currentPlayerId,
      currentCategory: this.currentCategory,
      expandedQuestIds: this.expandedQuestIds,
      listItemFrames: this.listItemFrames,
      rowBackdropByQuestId: this.rowBackdropByQuestId,
      titleByQuestId: this.titleByQuestId,
      clickBtnByQuestId: this.clickBtnByQuestId,
      objFrameByKey: this.objFrameByKey,
      failFrameByQuestId: this.failFrameByQuestId,
      rowIconByQuestId: this.rowIconByQuestId,
      createTextLabel,
      FramePoint,
      FrameType,
      createFrame,
      setFrameTexture,
      setFramePointRelative,
      setFrameSize,
      setFrameClickEvent,
      showFrame,
      applyDzTextFontAndCenterAlignment,
      applyDzTextFontAndAlignment,
      syncScrollThumb: (maxScroll: number) => this.syncScrollThumb(maxScroll),
      updateScrollBarVisibility: (maxScroll: number, hasQuestRows: boolean) =>
        this.updateScrollBarVisibility(maxScroll, hasQuestRows),
      toggleExpand: (questId: string) => this.toggleExpand(questId),
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      getTotalContentHeight: () => this.totalContentHeight,
      setTotalContentHeight: (v: number) => {
        this.totalContentHeight = v;
      },
    };
  }

  /** 滚动模块只拿它真正关心的滚动状态与输入函数，降低耦合面。 */
  private getScrollContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      scrollBarFrame: this.scrollBarFrame,
      scrollThumbFrame: this.scrollThumbFrame,
      scrollThumbHitBtn: this.scrollThumbHitBtn,
      taskListWheelTrig: this.taskListWheelTrig,
      getMouseFocus: typeof getMouseFocus === "function" ? getMouseFocus : undefined,
      getWheelDelta: typeof getWheelDelta === "function" ? getWheelDelta : undefined,
      registerMouseWheel,
      vScrollTrack: this.vScrollTrack,
      isVisible: () => this.isVisible,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      getTotalContentHeight: () => this.totalContentHeight,
    };
  }

  /** 面板控制模块通过显式 getter/setter 读写状态，兼容 typescript-to-lua。 */
  private getPanelControlContext() {
    return {
      mainPanel: this.mainPanel,
      expandedQuestIds: this.expandedQuestIds,
      vScrollTrack: this.vScrollTrack,
      showFrame,
      hideFrame,
      questManager,
      getCurrentCategory: () => this.currentCategory,
      setCurrentCategory: (type: QuestType) => {
        this.currentCategory = type;
      },
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      isVisible: () => this.isVisible,
      setVisible: (v: boolean) => {
        this.isVisible = v;
      },
      getCurrentPlayerId: () => this.currentPlayerId,
      setCurrentPlayerId: (v: number) => {
        this.currentPlayerId = v;
      },
    };
  }
}

export const taskUI = new TaskUI();

export function init(): void {
  taskUI.init();
}

export function registerHotkey(): void {
  taskUI.registerHotkey();
}
