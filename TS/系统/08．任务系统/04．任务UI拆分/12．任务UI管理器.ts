/**
 * 12．任务UI管理器
 * N 槽架构：每个英雄注册的玩家创建一套任务 UI（全局创建），只显示给对应玩家（异步显隐）。
 * 由 `00．玩家英雄获取桥接` 的 `onPlayerHeroRegistered` 触发创建。
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
import { ENABLE_TASK_UI_CLIENT, MAX_PLAYERS, TAG_SLOT_OFFSET } from "./01．任务UI常量";

// ── N 槽：按 playerId 索引的 TaskUI 数组 ──
const taskUIs: TaskUI[] = [];
let hotkeyRegistered = false;
let refreshCallbackRegistered = false;

/** 获取按键玩家对应的 playerId（-1 表示无效） */
function getTriggerPlayerId(): number {
  const tp = (japi as any).DzGetTriggerKeyPlayer != null
    ? (japi as any).DzGetTriggerKeyPlayer()
    : null;
  if (tp == null || tp === 0) return -1;
  const pid = jass.GetPlayerId(tp);
  return (typeof pid === "number" && pid >= 0 && pid < MAX_PLAYERS) ? pid : -1;
}

function taskUIModulePlayClickSound(): void {
  const lp = jass.GetLocalPlayer();
  const pid = jass.GetPlayerId(lp);
  if (pid >= 0 && pid < taskUIs.length) {
    taskUIs[pid]?.playLocalClickSound();
  }
}

function taskUIModuleRowExpand(questId: string): void {
  const pid = getTriggerPlayerId();
  if (pid >= 0 && pid < taskUIs.length) {
    taskUIs[pid]?.toggleExpandForRow(questId);
  }
}

function taskUIModuleSwitchCategory(type: QuestType): void {
  const pid = getTriggerPlayerId();
  if (pid >= 0 && pid < taskUIs.length) {
    taskUIs[pid]?.switchCategory(type);
  }
}

function taskUIModuleNoopTabTooltip(_msg: string): void {}

class TaskUI {
  readonly slotId: number;
  readonly playerId: number;
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
  uiInitialized = false;
  private listCtxCache: TaskUIListControlContext | null = null;
  private scrollCtxCache: TaskUIScrollContext | null = null;

  constructor(slotId: number) {
    this.slotId = slotId;
    this.playerId = slotId;
  }

  private ensureUiContextCaches(): void {
    const self = this;
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
      isVisible: () => self.isVisible,
      getCurrentPageCount: () => self.getPageCountForCurrentCategory(),
      getCurrentPage: () => self.currentPage,
      setCurrentPage: (p: number) => { self.currentPage = p; },
      onPageChanged: (prev: number, next: number) => { self.applyScrollPageChanged(prev, next); },
    };

    this.listCtxCache = {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      currentPlayerId: this.localPlayerId,
      currentCategory: this.currentCategory,
      precreatedListPool: this.precreatedListPool,
      contextId: this.slotContextId,
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
      playClickSound: () => { self.playLocalClickSound(); },
      updateScrollBarVisibility: (pageCount: number, hasQuestRows: boolean) => { self.syncScrollBarVisibility(pageCount, hasQuestRows); },
      toggleExpand: (questId: string) => { self.toggleExpandForRow(questId); },
      getCurrentPage: (type: QuestType) => self.listGetCurrentPage(type),
      setCurrentPage: (type: QuestType, page: number) => { self.listSetCurrentPage(type, page); },
      getExpandedQuestId: (type: QuestType) => self.listGetExpandedQuestId(type),
    };
  }

  init(playerId: number): void {
    if (!ENABLE_TASK_UI_CLIENT) return;
    if (this.uiInitialized) return;
    taskUIs[playerId] = this;
    this.localPlayer = jass.Player(playerId);
    this.localPlayerId = playerId;
    pcall(taskUIInitPcallBody);
  }

  /** nameSuffix 用于帧名区分不同槽位 */
  private get nameSuffix(): string { return `_s${this.slotId}`; }
  /** contextId 偏移用于 DzCreateFrame 区分不同槽位的 FDF 实例 */
  private get slotContextId(): number { return this.slotId * TAG_SLOT_OFFSET; }

  /** 供 `taskUIInitPcallBody` 调用 */
  runInitBodyInPcall(): void {
    const gameUI = getGameUI();
    if (!gameUI) return;
    this.createEntryIcon(gameUI);
    this.createMainPanel(gameUI);
    this.createListPool();
    this.registerTaskListWheel();
    this.resetToDefault();
    this.rebuildPages();
    registerTaskUIRefreshCallback();
    this.hidePanelState();
    this.hidePanelUI();
    this.uiInitialized = true;
  }

  private createEntryIcon(parent: number): void {
    const res = buildTaskEntryIcon({
      japi, parent, FrameType, FramePoint, createFrame, createTextLabel,
      setFramePosition, setFrameSize, setFramePointRelative, setFrameClickEvent,
      applyDzTextFontAndCenterAlignment,
      onTogglePanel: taskUIHotkeyTogglePanel,
      slotId: this.slotId,
      contextId: this.slotContextId,
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
      slotId: this.slotId,
      contextId: this.slotContextId,
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
    if (this.isVisible) {
      const localPlayer = jass.GetLocalPlayer();
      if (this.localPlayer != null && this.localPlayer === localPlayer) {
        this.showCurrentCategory();
      }
    }
  }

  private resetToDefault(): void {
    this.currentCategory = QuestType.MAIN;
    this.currentPage = 0;
    this.expandedQuestId = null;
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

  /** 同步修改分类全局状态（所有客户端执行，不受 GetLocalPlayer 限制） */
  switchCategoryState(type: QuestType): void {
    if (this.currentCategory === type) return;
    this.currentCategory = type;
    this.currentPage = 0;
    this.expandedQuestId = null;
  }

  /** 本地显示分类UI（仅在 GetLocalPlayer === triggerPlayer 时执行） */
  switchCategoryUI(type: QuestType): void {
    if (!this.isVisible) return;
    applyTaskUICategorySwitchVisibleState(this.getListControlContext());
    const pc = this.getPageCount(type);
    updateTaskUIScrollBarVisibility(this.getScrollContext(), pc, pc > 0);
  }

  /** sync=true 回调入口：全局状态在所有客户端同步修改，UI 只对按键者显示 */
  switchCategorySync(player: any, type: QuestType): void {
    this.switchCategoryState(type);
    const localPlayer = jass.GetLocalPlayer();
    if (player === localPlayer) {
      this.switchCategoryUI(type);
    }
  }

  /** 鼠标 Tab 点击入口（sync=true 帧回调，全房触发） */
  switchCategory(type: QuestType): void {
    const triggerPlayer = japi.DzGetTriggerKeyPlayer();
    this.switchCategorySync(triggerPlayer, type);
  }

  /** sync=true 回调入口：展开/折叠，全局状态全房同步，UI 只对按键者执行 */
  toggleExpandSync(player: any, questId: string): void {
    const oldExpanded = this.expandedQuestId;
    this.expandedQuestId = oldExpanded === questId ? null : questId;
    const localPlayer = jass.GetLocalPlayer();
    if (player === localPlayer) {
      toggleExpandLocal(this.precreatedListPool, this.currentCategory, this.currentPage, oldExpanded, questId);
    }
  }

  private toggleExpand(questId: string): void {
    const triggerPlayer = (japi as any).DzGetTriggerKeyPlayer != null
      ? (japi as any).DzGetTriggerKeyPlayer()
      : jass.GetLocalPlayer();
    this.toggleExpandSync(triggerPlayer, questId);
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

  /** sync=true 回调入口：面板切换，全局状态全房同步，UI 只对按键者显示 */
  togglePanelSync(player: any): void {
    if (this.isVisible) {
      this.hidePanelState();
      const localPlayer = jass.GetLocalPlayer();
      if (player === localPlayer) {
        this.hidePanelUI();
      }
    } else {
      this.showPanelState();
      const localPlayer = jass.GetLocalPlayer();
      if (player === localPlayer) {
        this.showPanelUI();
      }
    }
  }

  togglePanel(): void {
    const triggerPlayer = (japi as any).DzGetTriggerKeyPlayer != null
      ? (japi as any).DzGetTriggerKeyPlayer()
      : jass.GetLocalPlayer();
    this.togglePanelSync(triggerPlayer);
  }

  /** 全局状态：标记面板可见 + 重置状态 */
  private showPanelState(): void {
    this.resetToDefault();
    if (this.pagesDirty) this.rebuildPages();
    this.isVisible = true;
  }

  /** 本地 UI：显示面板帧 + 刷新分类显示 */
  private showPanelUI(): void {
    if (!this.mainPanel) return;
    showFrame(this.mainPanel);
    this.showCurrentCategory();
  }

  /** 全局状态：标记面板不可见 */
  private hidePanelState(): void {
    this.isVisible = false;
  }

  /** 本地 UI：隐藏面板帧 + 隐藏分类 */
  private hidePanelUI(): void {
    if (!this.mainPanel) return;
    if (this.precreatedListPool) {
      for (const ct of [QuestType.MAIN, QuestType.SIDE, QuestType.DAILY]) {
        const cv = this.precreatedListPool.categories[ct];
        if (cv != null) (japi as any).DzFrameShow(cv.root, false);
      }
    }
    hideFrame(this.mainPanel);
  }

  private getListControlContext(): TaskUIListControlContext {
    this.ensureUiContextCaches();
    const c = this.listCtxCache!;
    c.mainPanel = this.mainPanel;
    c.listContainer = this.listContainer;
    c.currentPlayerId = this.localPlayerId;
    c.currentCategory = this.currentCategory;
    c.precreatedListPool = this.precreatedListPool;
    c.contextId = this.slotContextId;
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

// ── pcall 槽位：供 TaskUI.init 内 pcall 调用 ──
let pcallInitTarget: TaskUI | null = null;

function taskUIInitPcallBody(): void {
  pcallInitTarget?.runInitBodyInPcall();
}

// ── 热键回调：sync=true 全房触发，按 triggerPlayerId 路由到对应槽位 ──
let __togglePanelTriggerPlayer: any = null;

function taskUITogglePanelPcallBody(): void {
  const player = __togglePanelTriggerPlayer;
  const pid = (player != null && player !== 0) ? jass.GetPlayerId(player) : -1;
  if (pid >= 0 && pid < taskUIs.length) {
    taskUIs[pid]?.togglePanelSync(player);
  }
}

function taskUIHotkeyTogglePanel(player: any): void {
  __togglePanelTriggerPlayer = player;
  pcall(taskUITogglePanelPcallBody);
}

function taskUIHotkeySwitchCategory(player: any, type: QuestType): void {
  const pid = (player != null && player !== 0) ? jass.GetPlayerId(player) : -1;
  if (pid >= 0 && pid < taskUIs.length) {
    taskUIs[pid]?.switchCategorySync(player, type);
  }
}

/**
 * 英雄注册回调：当玩家英雄注册时，为该玩家创建一套任务 UI。
 * 由 `00．玩家英雄获取桥接` 调用。
 * 所有客户端对称执行（全局创建），异步显隐。
 */
export function onPlayerHeroRegistered(this: void, whichPlayer: any, _whichHero: any): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  if (whichPlayer == null || whichPlayer === 0) return;
  const pid = jass.GetPlayerId(whichPlayer);
  if (typeof pid !== "number" || pid < 0 || pid >= MAX_PLAYERS) return;
  if (taskUIs[pid] != null) return;

  const ui = new TaskUI(pid);
  pcallInitTarget = ui;
  ui.init(pid);
  pcallInitTarget = null;
}

/** 热键注册：全局只注册一次 */
export function registerHotkey(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  if (hotkeyRegistered) return;
  hotkeyRegistered = true;
  registerTaskUIHotkeys({
    registerKeyUpSync, KEY, KEY_NUM,
    onTogglePanelSync: taskUIHotkeyTogglePanel,
    onSwitchCategorySync: taskUIHotkeySwitchCategory,
  });
}

/**
 * 注册任务UI刷新回调。
 * 当任务数据变化时，遍历所有已创建槽位重建UI列表。
 */
function onQuestManagerUiRefresh(_playerId: number, _questId?: string): void {
  for (let i = 0; i < taskUIs.length; i++) {
    const ui = taskUIs[i];
    if (ui == null || !ui.uiInitialized) continue;
    ui.pagesDirty = true;
    if (ui.isVisible) {
      ui.rebuildPages();
    }
  }
}

export function registerTaskUIRefreshCallback(): void {
  if (refreshCallbackRegistered) return;
  refreshCallbackRegistered = true;
  if (!questManager || typeof questManager.registerUIRefreshCallback !== "function") return;
  questManager.registerUIRefreshCallback(onQuestManagerUiRefresh);
}
