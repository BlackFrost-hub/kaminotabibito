/**
 * 12．任务UI管理器
 * 职责：全局单例 TaskUI 生命周期、持有引用、协调内容更新与本地显示控制。
 * 开局由 `10．index` 调用 `init()` 创建一套 UI（各客户端对称执行）；不再依赖英雄注册。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { QuestType } from "../01．任务数据";
import {
  applyTaskUIFacadeVisibleState,
  applyTaskUICategorySwitchVisibleState,
  getTaskUICategoryPageCount,
  setTaskRowHandlers,
  TaskUIPrecreatedListPool,
  type TaskUIListControlContext,
} from "./09．任务UI列表控制";
import { createTaskUIPrecreatedListPool } from "./13．任务UI预设构建";
import { rebuildTaskUIFacadeListPool } from "./14．任务UI内容同步";
import { toggleExpandLocal, switchPageLocal } from "./15．任务UI本地显示";
import {
  registerTaskUIListWheel,
  updateTaskUIScrollBarVisibility,
  type TaskUIScrollContext,
} from "./10．任务UI滚动与滚轮";
import { registerTaskUIHotkeys } from "./16．任务UI输入绑定";
import { questManager } from "../02．任务管理器/index";
import { buildTaskEntryIcon } from "./06．任务UI入口图标";
import { buildTaskMainPanel } from "./08．任务UI主面板与滚动";
import {
  getGameUI, registerKeyUpSync, KEY, KEY_NUM,
  getMouseFocus, getWheelDelta,
  registerMouseWheel as registerMouseWheelHardware,
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
let clickSoundCallback: (() => void) | null = null;

function taskUIModulePlayClickSound(): void {
  mgr?.playLocalClickSound();
}

function taskUIModuleRowExpand(questId: string): void {
  mgr?.toggleExpandForRow(questId);
}

function taskUIModuleSwitchCategory(type: QuestType): void {
  mgr?.switchCategory(type);
}

function taskUIModuleNoopTabTooltip(_msg: string): void {}

function taskUIScrollCtxIsVisible(): boolean {
  return mgr?.isVisible ?? false;
}

function taskUIScrollCtxGetCurrentPageCount(): number {
  return mgr != null ? mgr.getPageCountForCurrentCategory() : 0;
}

function taskUIScrollCtxGetCurrentPage(): number {
  return mgr?.currentPage ?? 0;
}

function taskUIScrollCtxSetCurrentPage(p: number): void {
  if (mgr) mgr.currentPage = p;
}

function taskUIScrollCtxOnPageChanged(prev: number, next: number): void {
  mgr?.applyScrollPageChanged(prev, next);
}

function taskUIListCtxPlayClickSound(): void {
  taskUIModulePlayClickSound();
}

function taskUIListCtxUpdateScrollBar(pageCount: number, hasQuestRows: boolean): void {
  mgr?.syncScrollBarVisibility(pageCount, hasQuestRows);
}

function taskUIListCtxToggleExpand(questId: string): void {
  mgr?.toggleExpandForRow(questId);
}

function taskUIListCtxGetCurrentPage(type: QuestType): number {
  return mgr != null ? mgr.listGetCurrentPage(type) : 0;
}

function taskUIListCtxSetCurrentPage(type: QuestType, page: number): void {
  mgr?.listSetCurrentPage(type, page);
}

function taskUIListCtxGetExpandedQuestId(type: QuestType): string | null {
  return mgr != null ? mgr.listGetExpandedQuestId(type) : null;
}

function taskUITogglePanelPcallBody(): void {
  if (!mgr) return;
  mgr.togglePanel();
  clickSoundCallback?.();
}

// 统一的面板切换回调（键盘 J 键和鼠标点击入口图标共用）
function dispatchTogglePanel(): void {
  if (!mgr) return;
  pcall(taskUITogglePanelPcallBody);
}

function dispatchRefresh(): void {
  if (mgr) mgr.rebuildPages();
}

function pcallDispatchRefreshBody(): void {
  dispatchRefresh();
}

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
  /** 防止 `init()` 被重复调用时叠多套帧与回调 */
  private uiInitialized = false;
  /** 列表/滚动上下文各建一次，避免每次 `rebuild` 分配新闭包对象 */
  private listCtxCache: TaskUIListControlContext | null = null;
  private scrollCtxCache: TaskUIScrollContext | null = null;

  private ensureUiContextCaches(): void {
    if (this.scrollCtxCache != null) return;
    this.scrollCtxCache = {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      scrollBarFrame: this.scrollBarFrame,
      scrollThumbFrame: this.scrollThumbFrame,
      scrollThumbHitBtn: this.scrollThumbHitBtn,
      FramePoint,
      setFramePointRelative,
      taskListWheelTrig: this.taskListWheelTrig,
      getMouseFocus,
      getWheelDelta,
      registerMouseWheel: function (this: void, sync: boolean, cb: () => void, playerId?: number): unknown {
        return registerMouseWheelHardware(sync, cb, playerId);
      },
      isVisible: taskUIScrollCtxIsVisible,
      getCurrentPageCount: taskUIScrollCtxGetCurrentPageCount,
      getCurrentPage: taskUIScrollCtxGetCurrentPage,
      setCurrentPage: taskUIScrollCtxSetCurrentPage,
      onPageChanged: taskUIScrollCtxOnPageChanged,
    };

    this.listCtxCache = {
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
      playClickSound: taskUIListCtxPlayClickSound,
      updateScrollBarVisibility: taskUIListCtxUpdateScrollBar,
      toggleExpand: taskUIListCtxToggleExpand,
      getCurrentPage: taskUIListCtxGetCurrentPage,
      setCurrentPage: taskUIListCtxSetCurrentPage,
      getExpandedQuestId: taskUIListCtxGetExpandedQuestId,
    };
  }

  init(): void {
    if (!ENABLE_TASK_UI_CLIENT) return;
    if (this.uiInitialized) return;
    mgr = this;
    pcall(taskUIInitPcallBody);
  }

  /** 供模块级 `taskUIInitPcallBody` 调用；初始化体须为顶层具名函数供 `pcall(具名)` 使用 */
  runInitBodyInPcall(): void {
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
    this.uiInitialized = true;
  }

  private createEntryIcon(parent: number): void {
    // 设置音效回调，供 dispatchTogglePanel 使用
    clickSoundCallback = taskUIModulePlayClickSound;
    const res = buildTaskEntryIcon({
      japi, parent, FrameType, FramePoint, createFrame, createTextLabel,
      setFramePosition, setFrameSize, setFramePointRelative, setFrameClickEvent,
      applyDzTextFontAndCenterAlignment,
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
      onClickSound: taskUIModulePlayClickSound,
      onSwitchCategory: taskUIModuleSwitchCategory,
      onShowTabTooltip: taskUIModuleNoopTabTooltip,
    });
    this.mainPanel = res.mainPanel;
    this.listContainer = res.listContainer;
    this.scrollBarFrame = res.scrollBarFrame;
    this.scrollThumbFrame = res.scrollThumbFrame;
    this.scrollThumbHitBtn = res.scrollThumbHitBtn;
  }

  private createListPool(): void {
    this.precreatedListPool = createTaskUIPrecreatedListPool(this.getListControlContext());
    setTaskRowHandlers(taskUIModuleRowExpand, taskUIModulePlayClickSound);
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

  toggleExpandForRow(questId: string): void {
    this.toggleExpand(questId);
  }

  getPageCountForCurrentCategory(): number {
    return this.getPageCount(this.currentCategory);
  }

  applyScrollPageChanged(prev: number, next: number): void {
    this.currentPage = next;
    this.expandedQuestId = null;
    switchPageLocal(this.precreatedListPool, this.currentCategory, prev, next);
  }

  syncScrollBarVisibility(pageCount: number, hasQuestRows: boolean): void {
    updateTaskUIScrollBarVisibility(this.getScrollContext(), pageCount, hasQuestRows);
  }

  listGetCurrentPage(type: QuestType): number {
    return type === this.currentCategory ? this.currentPage : 0;
  }

  listSetCurrentPage(type: QuestType, page: number): void {
    if (type === this.currentCategory) this.currentPage = page;
  }

  listGetExpandedQuestId(type: QuestType): string | null {
    return type === this.currentCategory ? this.expandedQuestId : null;
  }

  private getPageCount(type: QuestType): number {
    return getTaskUICategoryPageCount(this.precreatedListPool, type);
  }

  /** 显示当前分类的 page0 + variant0 */
  showCurrentCategory(): void {
    applyTaskUIFacadeVisibleState(this.getListControlContext());
  }

  /** 同步修改分类状态（所有客户端执行） */
  switchCategoryState(type: QuestType): void {
    if (this.currentCategory === type) return;
    this.currentCategory = type;
    this.currentPage = 0;
    this.expandedQuestId = null;
  }

  /** 本地显示分类UI（仅本地玩家执行） */
  switchCategoryUI(type: QuestType): void {
    if (!this.isVisible) return;
    applyTaskUICategorySwitchVisibleState(this.getListControlContext());
    const pc = this.getPageCount(type);
    updateTaskUIScrollBarVisibility(this.getScrollContext(), pc, pc > 0);
  }

  switchCategory(type: QuestType): void {
    if (!this.isVisible) return;
    if (this.currentCategory === type) return;
    this.switchCategoryState(type);
    this.switchCategoryUI(type);
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

  private getListControlContext(): TaskUIListControlContext {
    this.ensureUiContextCaches();
    const c = this.listCtxCache!;
    c.mainPanel = this.mainPanel;
    c.listContainer = this.listContainer;
    c.currentPlayerId = this.localPlayerId;
    c.currentCategory = this.currentCategory;
    c.precreatedListPool = this.precreatedListPool;
    return c;
  }

  private getScrollContext(): TaskUIScrollContext {
    this.ensureUiContextCaches();
    const s = this.scrollCtxCache!;
    s.mainPanel = this.mainPanel;
    s.listContainer = this.listContainer;
    s.scrollBarFrame = this.scrollBarFrame;
    s.scrollThumbFrame = this.scrollThumbFrame;
    s.scrollThumbHitBtn = this.scrollThumbHitBtn;
    s.taskListWheelTrig = this.taskListWheelTrig;
    return s;
  }
}

function taskUIInitPcallBody(): void {
  mgr?.runInitBodyInPcall();
}

const taskUI = new TaskUI();
export { taskUI };

function taskUIHotkeySwitchCategoryState(type: QuestType): void {
  taskUI.switchCategoryState(type);
}

function taskUIHotkeySwitchCategoryUI(type: QuestType): void {
  taskUI.switchCategoryUI(type);
}

/** 地图加载时创建全局单例任务 UI（各客户端对称执行一次） */
export function init(): void {
  taskUI.init();
}

// 热键不在此模块顶层注册：与 `系统.08．任务系统.10．index` 中 `registerHotkey()` 重复会导致同一键挂两个触发器，一次松键 toggle 两次（J「无效」）。
// 由 `10．index` 在 `require("…03．任务UI")` 之后统一调用 `registerHotkey()`；`05．任务UI热键` 内另有 `taskUIKeybindsInstalled` 防重复。

export function registerHotkey(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  registerTaskUIHotkeys({
    registerKeyUpSync, KEY, KEY_NUM,
    onTogglePanelLocal: dispatchTogglePanel,
    onSwitchCategoryState: taskUIHotkeySwitchCategoryState,
    onSwitchCategoryUI: taskUIHotkeySwitchCategoryUI,
  });
}

/**
 * 注册任务UI刷新回调。
 * 当任务数据变化时，重建UI列表。
 */
function onQuestManagerUiRefresh(_playerId: number, _questId?: string): void {
  pcall(pcallDispatchRefreshBody);
}

/** 当前仅由 `init` 调用；参数保留与旧调用点兼容，实现固定走 `dispatchRefresh` */
export function registerTaskUIRefreshCallback(_rebuildPages: () => void): void {
  if (!questManager || typeof questManager.registerUIRefreshCallback !== "function") return;
  questManager.registerUIRefreshCallback(onQuestManagerUiRefresh);
}
