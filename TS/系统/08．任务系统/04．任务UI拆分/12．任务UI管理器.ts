/**
 * 12．任务UI管理器
 * 职责：TaskUI 生命周期、持有引用、协调内容更新与本地显示控制。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { QuestType } from "../01．任务数据";
import {
  applyTaskUIFacadeVisibleState,
  getTaskUICategoryPageCount,
  setTaskRowHandlers,
  TaskUIPrecreatedListPool,
} from "./09．任务UI列表控制";
import { createTaskUIPrecreatedListPool } from "./13．任务UI预设构建";
import { rebuildTaskUIFacadeListPool } from "./14．任务UI内容同步";
import { switchCategoryLocal, toggleExpandLocal, switchPageLocal } from "./15．任务UI本地显示";
import {
  registerTaskUIListWheel,
  updateTaskUIScrollBarVisibility,
} from "./10．任务UI滚动与滚轮";
import { registerTaskUIRefreshCallback } from "./11．任务UI面板控制";
import { registerTaskUIHotkeys } from "./16．任务UI输入绑定";
import { buildTaskEntryIcon } from "./06．任务UI入口图标";
import { buildTaskMainPanel } from "./08．任务UI主面板与滚动";
import {
  getGameUI, registerKeyUpLocal, KEY, KEY_NUM,
  getMouseFocus, getWheelDelta, registerMouseWheel,
} from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import {
  createFrame, setFramePosition, setFrameSize, setFrameTexture,
  setButtonText, setFrameClickEvent, setFramePointRelative,
  setFrameHoverEvents, createTextLabel, FrameType, FramePoint,
  hideFrame, showFrame,
} from "../../09．表现系统/01．UI工具/index";
import { SoundUI_ClickPlay } from "../../../lib/扩展函数/封装函数/02．音效系统/index";
import {
  applyDzTextFontAndAlignment, applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer,
} from "../../00．核心系统/03．UI函数";
import { ENABLE_TASK_UI_CLIENT } from "./01．任务UI常量";

// ── 模块级分发变量（避免匿名闭包进 JASS 回调） ──
let mgr: TaskUI | null = null;
function dispatchTogglePanel(): void { if (mgr) mgr.togglePanel(); }
function dispatchRefresh(): void { if (mgr) mgr.rebuildPages(); }

class TaskUI {
  entryFrame: number | null = null;
  mainPanel: number | null = null;
  listContainer: number | null = null;
  scrollBarFrame: number | null = null;
  scrollThumbFrame: number | null = null;
  scrollThumbHitBtn: number | null = null;
  taskListWheelTrig: unknown = null;
  precreatedListPool: TaskUIPrecreatedListPool | null = null;
  pagesDirty = false;
  localPlayerId = 0;
  private localPlayer: any = null;
  currentCategory: QuestType = QuestType.MAIN;
  currentPage = 0;
  expandedQuestId: string | null = null;
  isVisible = false;

  init(): void {
    if (!ENABLE_TASK_UI_CLIENT) return;
    mgr = this;
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
      registerTaskUIRefreshCallback(dispatchRefresh);
      this.hidePanel();
    });
  }

  private createEntryIcon(parent: number): void {
    const res = buildTaskEntryIcon({
      japi, parent, FrameType, FramePoint, createFrame, createTextLabel,
      setFramePosition, setFrameSize, setFramePointRelative, setFrameClickEvent,
      applyDzTextFontAndCenterAlignment,
      onClickSound: () => this.playLocalClickSound(),
      onTogglePanel: dispatchTogglePanel,
    });
    this.entryFrame = res.entryFrame;
  }

  private createMainPanel(parent: number): void {
    const res = buildTaskMainPanel({
      japi, parent, entryFrame: this.entryFrame, FrameType, FramePoint,
      createFrame, setFramePosition, setFrameSize, setFramePointRelative,
      setFrameTexture, setFrameHoverEvents, setFrameClickEvent, setButtonText,
      createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer,
      onClickSound: () => this.playLocalClickSound(),
      onSwitchCategory: (type: QuestType) => this.switchCategory(type),
      onShowTabTooltip: () => {},
    });
    this.mainPanel = res.mainPanel;
    this.listContainer = res.listContainer;
    this.scrollBarFrame = res.scrollBarFrame;
    this.scrollThumbFrame = res.scrollThumbFrame;
    this.scrollThumbHitBtn = res.scrollThumbHitBtn;
  }

  private createListPool(): void {
    this.precreatedListPool = createTaskUIPrecreatedListPool(this.getListControlContext());
    setTaskRowHandlers(
      (questId: string) => this.toggleExpand(questId),
      () => this.playLocalClickSound(),
    );
  }

  private registerTaskListWheel(): void {
    this.taskListWheelTrig = registerTaskUIListWheel(this.getScrollContext());
  }

  rebuildPages(): void {
    rebuildTaskUIFacadeListPool(this.getListControlContext());
    this.pagesDirty = false;
    if (this.isVisible) this.showCurrentCategory();
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

  playLocalClickSound(): void {
    SoundUI_ClickPlay(undefined, this.localPlayer);
  }

  private getPageCount(type: QuestType): number {
    return getTaskUICategoryPageCount(this.precreatedListPool, type);
  }

  /** 显示当前分类的 page0 + variant0 */
  showCurrentCategory(): void {
    applyTaskUIFacadeVisibleState(this.getListControlContext());
  }

  switchCategory(type: QuestType): void {
    if (!this.isVisible) return;
    if (this.currentCategory === type) return;
    const old = this.currentCategory;
    this.currentCategory = type;
    this.currentPage = 0;
    this.expandedQuestId = null;
    switchCategoryLocal(this.precreatedListPool, old, type);
    const pc = this.getPageCount(type);
    updateTaskUIScrollBarVisibility(this.getScrollContext(), pc, pc > 0);
  }

  private toggleExpand(questId: string): void {
    const oldExpanded = this.expandedQuestId;
    this.expandedQuestId = oldExpanded === questId ? null : questId;
    toggleExpandLocal(this.precreatedListPool, this.currentCategory, this.currentPage, oldExpanded, questId);
  }

  private changeCurrentPage(delta: number): void {
    const pageCount = this.getPageCount(this.currentCategory);
    if (pageCount <= 1) return;
    const currentPage = this.currentPage;
    const nextPage = Math.max(0, Math.min(pageCount - 1, currentPage + delta));
    if (nextPage === currentPage) return;
    this.currentPage = nextPage;
    this.expandedQuestId = null;
    switchPageLocal(this.precreatedListPool, this.currentCategory, currentPage, nextPage);
  }

  togglePanel(): void {
    if (this.isVisible) {
      this.hidePanel();
    } else {
      this.showPanel();
    }
  }

  private showPanel(): void {
    if (!this.mainPanel) return;
    this.resetToDefault();
    if (this.pagesDirty) this.rebuildPages();
    showFrame(this.mainPanel);
    this.isVisible = true;
    this.showCurrentCategory();
  }

  private hidePanel(): void {
    if (!this.mainPanel) return;
    if (this.precreatedListPool) {
      for (const ct of [QuestType.MAIN, QuestType.SIDE, QuestType.DAILY]) {
        const cv = this.precreatedListPool.categories[ct];
        if (cv) (japi as any).DzFrameShow(cv.root, false);
      }
    }
    hideFrame(this.mainPanel);
    this.isVisible = false;
  }

  private getListControlContext() {
    return {
      mainPanel: this.mainPanel, listContainer: this.listContainer,
      currentPlayerId: this.localPlayerId, currentCategory: this.currentCategory,
      precreatedListPool: this.precreatedListPool,
      createTextLabel, FramePoint, FrameType, createFrame, setFrameTexture,
      setFramePointRelative, setFrameSize, setFrameClickEvent,
      setupTransparentGlueHitLayer, showFrame, hideFrame,
      applyDzTextFontAndCenterAlignment, applyDzTextFontAndAlignment,
      playClickSound: () => this.playLocalClickSound(),
      updateScrollBarVisibility: (pageCount: number, hasQuestRows: boolean) =>
        updateTaskUIScrollBarVisibility(this.getScrollContext(), pageCount, hasQuestRows),
      toggleExpand: (questId: string) => this.toggleExpand(questId),
      getCurrentPage: (type: QuestType) => type === this.currentCategory ? this.currentPage : 0,
      setCurrentPage: (type: QuestType, page: number) => { if (type === this.currentCategory) this.currentPage = page; },
      getExpandedQuestId: (type: QuestType) => type === this.currentCategory ? this.expandedQuestId : null,
    };
  }

  private getScrollContext() {
    return {
      mainPanel: this.mainPanel, listContainer: this.listContainer,
      scrollBarFrame: this.scrollBarFrame, scrollThumbFrame: this.scrollThumbFrame,
      scrollThumbHitBtn: this.scrollThumbHitBtn, FramePoint, setFramePointRelative,
      taskListWheelTrig: this.taskListWheelTrig,
      getMouseFocus, getWheelDelta, registerMouseWheel,
      isVisible: () => this.isVisible,
      getCurrentPageCount: () => this.getPageCount(this.currentCategory),
      getCurrentPage: () => this.currentPage,
      setCurrentPage: (p: number) => { this.currentPage = p; },
      onPageChanged: (prev: number, next: number) => {
        this.currentPage = next;
        this.expandedQuestId = null;
        switchPageLocal(this.precreatedListPool, this.currentCategory, prev, next);
      },
    };
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
    registerKeyUpLocal, KEY, KEY_NUM,
    onClickSound: () => taskUI.playLocalClickSound(),
    onTogglePanelLocal: () => taskUI.togglePanel(),
    onSwitchCategoryLocal: (type: QuestType) => taskUI.switchCategory(type),
  });
}
