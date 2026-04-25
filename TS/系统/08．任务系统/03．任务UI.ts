const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  applyTaskUIFacadeVisibleState,
  applyTaskUICategorySwitchVisibleState,
  applyTaskUIExpandVisibleState,
  applyTaskUIPageSwitchVisibleState,
  createTaskUIPrecreatedListPool,
  getTaskUICategoryPageCount,
  rebuildTaskUIFacadeListPool,
  TaskUIPrecreatedListPool,
} from "./04．任务UI拆分/09．任务UI列表控制";
import {
  registerTaskUIListWheel,
  updateTaskUIScrollBarVisibility,
} from "./04．任务UI拆分/10．任务UI滚动与滚轮";
import {
  registerTaskUIRefreshCallback,
  showTaskUITabTooltip,
} from "./04．任务UI拆分/11．任务UI面板控制";

import { registerTaskUIHotkeys } from "./04．任务UI拆分/05．任务UI热键";
import { buildTaskEntryIcon } from "./04．任务UI拆分/06．任务UI入口图标";
import { buildTaskMainPanel } from "./04．任务UI拆分/08．任务UI主面板与滚动";

import {
  getGameUI,
  registerKeyUpLocal,
  KEY,
  KEY_NUM,
  getMouseFocus,
  getWheelDelta,
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
import { QuestType } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../../lib/扩展函数/封装函数/02．音效系统/index";
import {
  applyDzTextFontAndAlignment,
  applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop,
  setupTransparentGlueHitLayer,
} from "../00．核心系统/03．UI函数";
import { ENABLE_TASK_UI_CLIENT } from "./04．任务UI拆分/01．任务UI常量";

class TaskUI {
  private entryFrame: number | null = null;
  private mainPanel: number | null = null;
  private listContainer: number | null = null;
  private scrollBarFrame: number | null = null;
  private scrollThumbFrame: number | null = null;
  private scrollThumbHitBtn: number | null = null;
  private taskListWheelTrig: unknown = null;
  private precreatedListPool: TaskUIPrecreatedListPool | null = null;
  private pagesDirty = false;
  private localPlayerId = 0;
  private localPlayer: any = null;

  private currentCategory: QuestType = QuestType.MAIN;
  private currentPage = 0;
  private expandedQuestId: string | null = null;
  private isVisible = false;

  init(): void {
    if (!ENABLE_TASK_UI_CLIENT) return;
    (pcall as any)(() => {
      const gameUI = getGameUI();
      if (!gameUI) return;
      this.localPlayer = jass.GetLocalPlayer();
      this.localPlayerId = this.resolveLocalPlayerId();

      this.createEntryIcon(gameUI);
      this.createMainPanel(gameUI);
      this.createListPool();
      this.registerTaskListWheel();
      this.resetToDefault();
      this.rebuildPages();
      registerTaskUIRefreshCallback(() => this.markPagesDirty());
      this.doHide();
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
      onClickSound: () => this.playLocalClickSound(),
      onTogglePanel: () => this.togglePanelByVisibilityOnly(),
    });
    this.entryFrame = res.entryFrame;
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
      onClickSound: () => this.playLocalClickSound(),
      onSwitchCategory: (type: QuestType) => this.switchCategory(type),
      onShowTabTooltip: (msg: string) => this.showTabTooltip(msg),
    });

    this.mainPanel = res.mainPanel;
    this.listContainer = res.listContainer;
    this.scrollBarFrame = res.scrollBarFrame;
    this.scrollThumbFrame = res.scrollThumbFrame;
    this.scrollThumbHitBtn = res.scrollThumbHitBtn;
  }

  private createListPool(): void {
    this.precreatedListPool = createTaskUIPrecreatedListPool(this.getListControlContext());
  }

  private registerTaskListWheel(): void {
    this.taskListWheelTrig = registerTaskUIListWheel(this.getScrollContext());
  }

  private rebuildPages(): void {
    rebuildTaskUIFacadeListPool(this.getListControlContext());
    this.normalizeVisibleState();
    this.pagesDirty = false;
    if (this.isVisible) this.applyVisibleState();
  }

  private markPagesDirty(): void {
    this.pagesDirty = true;
  }

  private normalizeVisibleState(): void {
    const category = this.currentCategory;
    const pageCount = this.getPageCount(category);
    if (pageCount <= 0) {
      this.currentPage = 0;
      this.expandedQuestId = null;
      return;
    }
    const clampedPage = Math.max(0, Math.min(pageCount - 1, this.currentPage));
    this.currentPage = clampedPage;
    if (!this.expandedQuestId) return;
    const pageQuestIds = this.getQuestIdsForPage(category, clampedPage);
    if (!pageQuestIds.includes(this.expandedQuestId)) {
      this.expandedQuestId = null;
    }
  }

  private applyVisibleState(): void {
    applyTaskUIFacadeVisibleState(this.getListControlContext());
  }

  private applyCategorySwitchVisibleState(): void {
    applyTaskUICategorySwitchVisibleState(this.getListControlContext());
  }

  private applyExpandVisibleState(): void {
    applyTaskUIExpandVisibleState(this.getListControlContext());
  }

  private resetToDefault(): void {
    this.currentCategory = QuestType.MAIN;
    this.currentPage = 0;
    this.expandedQuestId = null;
  }

  private resolveLocalPlayerId(): number {
    const lp = jass.GetLocalPlayer();
    if (lp == null) return 0;
    const pid = typeof jass.GetPlayerId === "function" ? jass.GetPlayerId(lp) : -1;
    return pid < 0 ? 0 : pid;
  }

  private showTabTooltip(msg: string): void {
    showTaskUITabTooltip(msg);
  }

  playLocalClickSound(): void {
    SoundUI_ClickPlay(undefined, this.localPlayer);
  }

  private getCurrentPage(type: QuestType): number {
    return type === this.currentCategory ? this.currentPage : 0;
  }

  private setCurrentPage(type: QuestType, page: number): void {
    if (type !== this.currentCategory) return;
    this.currentPage = Math.max(0, page);
  }

  private getExpandedQuestId(type: QuestType): string | null {
    return type === this.currentCategory ? this.expandedQuestId : null;
  }

  private setExpandedQuestId(type: QuestType, questId: string | null): void {
    if (type !== this.currentCategory) return;
    this.expandedQuestId = questId;
  }

  private getPageCount(type: QuestType): number {
    return getTaskUICategoryPageCount(this.precreatedListPool, type);
  }

  private getQuestIdsForPage(type: QuestType, page: number): string[] {
    const categoryView = this.precreatedListPool?.categories[type];
    if (!categoryView) return [];
    const pageView = categoryView.pages[page];
    return pageView?.questIds ?? [];
  }

  switchCategory(type: QuestType): void {
    if (!this.isVisible) return;
    if (this.currentCategory === type) return;
    this.currentCategory = type;
    this.setCurrentPage(type, 0);
    this.setExpandedQuestId(type, null);
    this.applyCategorySwitchVisibleState();
  }

  private toggleExpand(questId: string): void {
    const current = this.getExpandedQuestId(this.currentCategory);
    const next = current === questId ? null : questId;
    this.setExpandedQuestId(this.currentCategory, next);
    this.applyExpandVisibleState();
  }

  private changeCurrentPage(delta: number): void {
    const pageCount = this.getPageCount(this.currentCategory);
    if (pageCount <= 1) return;
    const currentPage = this.getCurrentPage(this.currentCategory);
    const nextPage = Math.max(0, Math.min(pageCount - 1, currentPage + delta));
    if (nextPage === currentPage) return;
    this.setCurrentPage(this.currentCategory, nextPage);
    this.setExpandedQuestId(this.currentCategory, null);
    this.applyVisibleState();
  }

  togglePanelByVisibilityOnly(): void {
    if (this.isVisible) {
      this.doHide();
    } else {
      this.doShow();
    }
  }

  private doShow(): void {
    this.resetToDefault();
    if (this.pagesDirty) this.rebuildPages();
    this.applyVisibleState();
    this.isVisible = true;
    if (this.mainPanel) showFrame(this.mainPanel);
  }

  private doHide(): void {
    this.resetToDefault();
    this.applyVisibleState();
    if (this.mainPanel) hideFrame(this.mainPanel);
    this.isVisible = false;
  }

  private getListControlContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      currentPlayerId: this.localPlayerId,
      currentCategory: this.currentCategory,
      precreatedListPool: this.precreatedListPool,
      createTextLabel,
      FramePoint,
      FrameType,
      createFrame,
      setFrameTexture,
      setFramePointRelative,
      setFrameSize,
      setFrameClickEvent,
      setupTransparentGlueHitLayer,
      showFrame,
      hideFrame,
      applyDzTextFontAndCenterAlignment,
      applyDzTextFontAndAlignment,
      playClickSound: () => this.playLocalClickSound(),
      updateScrollBarVisibility: (pageCount: number, hasQuestRows: boolean) =>
        this.updateScrollBarVisibility(pageCount, hasQuestRows),
      toggleExpand: (questId: string) => this.toggleExpand(questId),
      getCurrentPage: (type: QuestType) => this.getCurrentPage(type),
      setCurrentPage: (type: QuestType, page: number) => this.setCurrentPage(type, page),
      getExpandedQuestId: (type: QuestType) => this.getExpandedQuestId(type),
    };
  }

  private getScrollContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      scrollBarFrame: this.scrollBarFrame,
      scrollThumbFrame: this.scrollThumbFrame,
      scrollThumbHitBtn: this.scrollThumbHitBtn,
      FramePoint,
      setFramePointRelative,
      taskListWheelTrig: this.taskListWheelTrig,
      getMouseFocus: getMouseFocus,
      getWheelDelta: getWheelDelta,
      registerMouseWheel,
      isVisible: () => this.isVisible,
      getCurrentPageCount: () => this.getPageCount(this.currentCategory),
      getCurrentPage: () => this.getCurrentPage(this.currentCategory),
      setCurrentPage: (page: number) => this.setCurrentPage(this.currentCategory, page),
      onPageChanged: () => {
        this.setExpandedQuestId(this.currentCategory, null);
        applyTaskUIPageSwitchVisibleState(this.getListControlContext());
      },
    };
  }

  private updateScrollBarVisibility(pageCount: number, hasQuestRows: boolean): void {
    updateTaskUIScrollBarVisibility(this.getScrollContext(), pageCount, hasQuestRows);
  }
}

const taskUI = new TaskUI();

export { taskUI };

export function init(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  taskUI.init();
}

export function registerHotkey(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  registerTaskUIHotkeys({
    registerKeyUpLocal,
    KEY,
    KEY_NUM,
    onClickSound: () => taskUI.playLocalClickSound(),
    onTogglePanelLocal: () => taskUI.togglePanelByVisibilityOnly(),
    onSwitchCategoryLocal: (type: QuestType) => taskUI.switchCategory(type),
  });
}
