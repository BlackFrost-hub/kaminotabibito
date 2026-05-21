/**
 * 11．任务UI管理器
 * N 槽架构：每个英雄注册的玩家创建一套任务 UI（全局创建），只显示给对应玩家（异步显隐）。
 * 由 `00．玩家英雄获取桥接` 的 `onPlayerHeroRegistered` 触发创建。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
import { QuestType } from "../01．任务数据";
import { applyTaskUIFacadeVisibleState, applyTaskUICategorySwitchVisibleState, getTaskUICategoryPageCount, setTaskRowHandlers, rebuildTaskUIFacadeListPool, } from "./08．任务UI列表控制";
import { createTaskUIPrecreatedListPool } from "./12．任务UI预设构建";
import { toggleExpandLocal, switchPageLocal } from "./13．任务UI本地显示";
import { registerTaskUIListWheel, updateTaskUIScrollBarVisibility, } from "./09．任务UI滚动与滚轮";
import { registerTaskUIHotkeys } from "./04．任务UI热键";
import { questManager } from "../01．任务管理器/index";
import { buildTaskEntryIcon } from "./05．任务UI入口图标";
import { buildTaskMainPanel } from "./07．任务UI主面板与滚动";
import { getGameUI, registerKeyUpSync, KEY, KEY_NUM, getMouseFocus, getWheelDelta, registerMouseWheel as registerMouseWheelHardware, } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { createFrame, setFramePosition, setFrameSize, setFrameTexture, setButtonText, setFrameClickEvent, setFramePointRelative, setFrameHoverEvents, createTextLabel, FrameType, FramePoint, hideFrame, showFrame, } from "../../09．表现系统/01．UI工具/index";
import { SoundUI_ClickPlay } from "../../../lib/扩展函数/封装函数/02．音效系统/index";
import { applyDzTextFontAndAlignment, applyDzTextFontAndCenterAlignment, createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer, } from "../../00．核心系统/03．UI函数";
import { ENABLE_TASK_UI_CLIENT, MAX_PLAYERS, TAG_SLOT_OFFSET } from "./01．任务UI常量";
// ── 虚拟分区：模块级回调路由函数 ──
const taskUIs = {};
let hotkeyRegistered = false;
let refreshCallbackRegistered = false;
/** 获取按键玩家对应的 playerId（-1 表示无效） */
function getTriggerPlayerId() {
    const tp = japi.DzGetTriggerKeyPlayer != null
        ? japi.DzGetTriggerKeyPlayer()
        : null;
    if (tp == null || tp === 0)
        return -1;
    const pid = jass.GetPlayerId(tp);
    return (typeof pid === "number" && pid >= 0 && pid < MAX_PLAYERS) ? pid : -1;
}
function taskUIModulePlayClickSound() {
    const lp = jass.GetLocalPlayer();
    const pid = jass.GetPlayerId(lp);
    const ui = pid >= 0 && pid < MAX_PLAYERS ? taskUIs[pid] : undefined;
    if (ui)
        ui.playLocalClickSound();
}
function taskUIModuleRowExpand(rowIndex) {
    const pid = getTriggerPlayerId();
    const ui = pid >= 0 && pid < MAX_PLAYERS ? taskUIs[pid] : undefined;
    if (ui)
        ui.toggleExpandForVisibleRow(rowIndex);
}
function taskUIModuleSwitchCategory(type) {
    const pid = getTriggerPlayerId();
    const ui = pid >= 0 && pid < MAX_PLAYERS ? taskUIs[pid] : undefined;
    if (ui)
        ui.switchCategory(type);
}
function taskUIModuleNoopTabTooltip(_msg) { }
function getTriggerPlayerOrLocal() {
    if (japi.DzGetTriggerKeyPlayer != null) {
        return japi.DzGetTriggerKeyPlayer();
    }
    return jass.GetLocalPlayer();
}
function getTaskUIByPlayerId(playerId) {
    if (typeof playerId !== "number" || playerId < 0 || playerId >= MAX_PLAYERS)
        return undefined;
    return taskUIs[playerId];
}
function taskUIEntryClick() {
    taskUIHotkeyTogglePanel(getTriggerPlayerOrLocal());
}
class TaskUI {
    slotId;
    playerId;
    entryFrame = null;
    mainPanel = null;
    listContainer = null;
    scrollBarFrame = null;
    scrollBarHitBtn = null;
    scrollThumbFrame = null;
    scrollThumbHitBtn = null;
    taskListWheelRegistered = false;
    precreatedListPool = null;
    pagesDirty = false;
    localPlayerId = 0;
    // ========== 虚拟分区：TaskUI 类与生命周期方法 ==========
    localPlayer = null;
    currentCategory = QuestType.MAIN;
    currentPage = 0;
    expandedQuestId = null;
    isVisible = false;
    uiInitialized = false;
    listCtxCache = null;
    scrollCtxCache = null;
    constructor(slotId) {
        this.slotId = slotId;
        this.playerId = slotId;
    }
    ensureUiContextCaches() {
        const self = this;
        if (this.scrollCtxCache != null)
            return;
        this.scrollCtxCache = {
            playerId: this.playerId,
            mainPanel: this.mainPanel,
            listContainer: this.listContainer,
            scrollBarFrame: this.scrollBarFrame,
            scrollBarHitBtn: this.scrollBarHitBtn,
            scrollThumbFrame: this.scrollThumbFrame,
            scrollThumbHitBtn: this.scrollThumbHitBtn,
            FramePoint,
            setFramePointRelative,
            taskListWheelRegistered: this.taskListWheelRegistered,
            getMouseFocus,
            getWheelDelta,
            registerMouseWheel: function (sync, cb, playerId) {
                return registerMouseWheelHardware(sync, cb, playerId);
            },
            isVisible: () => self.isVisible,
            isOwnedByLocalPlayer: () => self.localPlayer === jass.GetLocalPlayer(),
            getCurrentPageCount: () => self.getPageCountForCurrentCategory(),
            getCurrentPage: () => self.currentPage,
            setCurrentPage: (p) => { self.currentPage = p; },
            onPageChanged: (prev, next) => { self.applyScrollPageChanged(prev, next); },
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
            updateScrollBarVisibility: (pageCount, hasQuestRows) => { self.syncScrollBarVisibility(pageCount, hasQuestRows); },
            toggleExpand: (rowIndex) => { self.toggleExpandForVisibleRow(rowIndex); },
            getCurrentPage: (type) => self.listGetCurrentPage(type),
            setCurrentPage: (type, page) => { self.listSetCurrentPage(type, page); },
            getExpandedQuestId: (type) => self.listGetExpandedQuestId(type),
        };
    }
    init(playerId) {
        if (!ENABLE_TASK_UI_CLIENT)
            return false;
        if (this.uiInitialized)
            return true;
        this.localPlayer = jass.Player(playerId);
        this.localPlayerId = playerId;
        pcallInitTarget = this;
        try {
            taskUIInitPcallBody();
        }
        catch (_e) {
            pcallInitTarget = null;
            return false;
        }
        pcallInitTarget = null;
        if (!this.uiInitialized) {
            return false;
        }
        taskUIs[playerId] = this;
        return true;
    }
    /** nameSuffix 用于帧名区分不同槽位 */
    get nameSuffix() { return `_s${this.slotId}`; }
    /** contextId 偏移用于 DzCreateFrame 区分不同槽位的 FDF 实例 */
    get slotContextId() { return this.slotId * TAG_SLOT_OFFSET; }
    /** 供 `taskUIInitPcallBody` 调用 */
    runInitBodyInPcall() {
        const gameUI = getGameUI();
        if (!gameUI)
            return;
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
    createEntryIcon(parent) {
        const res = buildTaskEntryIcon({
            japi, parent, FrameType, FramePoint, createFrame, createTextLabel,
            setFramePosition, setFrameSize, setFramePointRelative, setFrameClickEvent,
            applyDzTextFontAndCenterAlignment,
            onTogglePanel: taskUIEntryClick,
            slotId: this.slotId,
            contextId: this.slotContextId,
        });
        this.entryFrame = res.entryFrame;
    }
    createMainPanel(parent) {
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
        this.scrollBarHitBtn = res.scrollBarHitBtn;
        this.scrollThumbFrame = res.scrollThumbFrame;
        this.scrollThumbHitBtn = res.scrollThumbHitBtn;
    }
    createListPool() {
        this.precreatedListPool = createTaskUIPrecreatedListPool(this.getListControlContext());
        setTaskRowHandlers(taskUIModuleRowExpand, taskUIModulePlayClickSound);
    }
    registerTaskListWheel() {
        registerTaskUIListWheel(this.getScrollContext());
    }
    rebuildPages() {
        rebuildTaskUIFacadeListPool(this.getListControlContext());
        this.pagesDirty = false;
        if (this.isVisible) {
            const localPlayer = jass.GetLocalPlayer();
            if (this.localPlayer != null && this.localPlayer === localPlayer) {
                this.showCurrentCategory();
            }
        }
    }
    resetToDefault() {
        this.currentCategory = QuestType.MAIN;
        this.currentPage = 0;
        this.expandedQuestId = null;
    }
    playLocalClickSound() {
        SoundUI_ClickPlay(undefined, this.localPlayer);
    }
    toggleExpandForRow(questId) {
        this.toggleExpand(questId);
    }
    toggleExpandForVisibleRow(rowIndex) {
        const categoryView = this.precreatedListPool?.categories[this.currentCategory];
        if (!categoryView)
            return;
        const page = categoryView.pages[this.currentPage];
        if (!page)
            return;
        const questId = page.questIds[rowIndex];
        if (!questId)
            return;
        this.toggleExpand(questId);
    }
    getPageCountForCurrentCategory() {
        return this.getPageCount(this.currentCategory);
    }
    applyScrollPageChanged(prev, next) {
        this.currentPage = next;
        // 滚轮/拖拽走 sync=false，本地翻页不能清共享展开态；
        // 否则后续 sync=true 行点击读取 oldExpanded 时，各端会出现状态分叉。
        switchPageLocal(this.precreatedListPool, this.currentCategory, prev, next);
    }
    syncScrollBarVisibility(pageCount, hasQuestRows) {
        updateTaskUIScrollBarVisibility(this.getScrollContext(), pageCount, hasQuestRows);
    }
    listGetCurrentPage(type) {
        return type === this.currentCategory ? this.currentPage : 0;
    }
    listSetCurrentPage(type, page) {
        if (type === this.currentCategory)
            this.currentPage = page;
    }
    listGetExpandedQuestId(type) {
        return type === this.currentCategory ? this.expandedQuestId : null;
    }
    getPageCount(type) {
        return getTaskUICategoryPageCount(this.precreatedListPool, type);
    }
    /** 显示当前分类的 page0 + variant0 */
    showCurrentCategory() {
        applyTaskUIFacadeVisibleState(this.getListControlContext());
    }
    /** 同步修改分类全局状态（所有客户端执行，不受 GetLocalPlayer 限制） */
    switchCategoryState(type) {
        if (this.currentCategory === type)
            return;
        this.currentCategory = type;
        this.currentPage = 0;
        this.expandedQuestId = null;
    }
    /** 本地显示分类UI（仅在 GetLocalPlayer === triggerPlayer 时执行） */
    switchCategoryUI(type) {
        if (!this.isVisible)
            return;
        applyTaskUICategorySwitchVisibleState(this.getListControlContext());
        const pc = this.getPageCount(type);
        updateTaskUIScrollBarVisibility(this.getScrollContext(), pc, pc > 0);
    }
    /** sync=true 回调入口：全局状态在所有客户端同步修改，UI 只对按键者显示 */
    switchCategorySync(player, type) {
        this.switchCategoryState(type);
        const localPlayer = jass.GetLocalPlayer();
        if (player === localPlayer) {
            this.switchCategoryUI(type);
        }
    }
    /** 鼠标 Tab 点击入口（sync=true 帧回调，全房触发） */
    switchCategory(type) {
        const triggerPlayer = japi.DzGetTriggerKeyPlayer();
        this.switchCategorySync(triggerPlayer, type);
    }
    /** sync=true 回调入口：展开/折叠，全局状态全房同步，UI 只对按键者执行 */
    toggleExpandSync(player, questId) {
        const oldExpanded = this.expandedQuestId;
        this.expandedQuestId = oldExpanded === questId ? null : questId;
        const localPlayer = jass.GetLocalPlayer();
        if (player === localPlayer) {
            toggleExpandLocal(this.precreatedListPool, this.currentCategory, this.currentPage, oldExpanded, questId);
        }
    }
    toggleExpand(questId) {
        const triggerPlayer = getTriggerPlayerOrLocal();
        this.toggleExpandSync(triggerPlayer, questId);
    }
    changeCurrentPage(delta) {
        const pageCount = this.getPageCount(this.currentCategory);
        if (pageCount <= 1)
            return;
        const currentPage = this.currentPage;
        let nextPage = currentPage + delta;
        if (nextPage < 0)
            nextPage = 0;
        if (nextPage > pageCount - 1)
            nextPage = pageCount - 1;
        if (nextPage === currentPage)
            return;
        this.currentPage = nextPage;
        this.expandedQuestId = null;
        switchPageLocal(this.precreatedListPool, this.currentCategory, currentPage, nextPage);
    }
    /** sync=true 回调入口：面板切换，全局状态全房同步，UI 只对按键者显示 */
    togglePanelSync(player) {
        if (this.isVisible) {
            this.hidePanelState();
            const localPlayer = jass.GetLocalPlayer();
            if (player === localPlayer) {
                this.hidePanelUI();
            }
        }
        else {
            this.showPanelState();
            const localPlayer = jass.GetLocalPlayer();
            if (player === localPlayer) {
                this.showPanelUI();
            }
        }
    }
    togglePanel() {
        const triggerPlayer = getTriggerPlayerOrLocal();
        this.togglePanelSync(triggerPlayer);
    }
    /** 全局状态：标记面板可见 + 重置状态 */
    showPanelState() {
        this.resetToDefault();
        if (this.pagesDirty)
            this.rebuildPages();
        this.isVisible = true;
    }
    /** 本地 UI：显示面板帧 + 刷新分类显示 */
    showPanelUI() {
        if (!this.mainPanel)
            return;
        showFrame(this.mainPanel);
        this.showCurrentCategory();
    }
    /** 全局状态：标记面板不可见 */
    hidePanelState() {
        this.isVisible = false;
    }
    /** 本地 UI：隐藏面板帧 + 隐藏分类 */
    hidePanelUI() {
        if (!this.mainPanel)
            return;
        if (this.precreatedListPool) {
            for (const ct of [QuestType.MAIN, QuestType.SIDE, QuestType.DAILY]) {
                const cv = this.precreatedListPool.categories[ct];
                if (cv != null)
                    japi.DzFrameShow(cv.root, false);
            }
        }
        hideFrame(this.mainPanel);
    }
    getListControlContext() {
        this.ensureUiContextCaches();
        const c = this.listCtxCache;
        c.mainPanel = this.mainPanel;
        c.listContainer = this.listContainer;
        c.currentPlayerId = this.localPlayerId;
        c.currentCategory = this.currentCategory;
        c.precreatedListPool = this.precreatedListPool;
        c.contextId = this.slotContextId;
        return c;
    }
    getScrollContext() {
        this.ensureUiContextCaches();
        const s = this.scrollCtxCache;
        s.playerId = this.playerId;
        s.mainPanel = this.mainPanel;
        s.listContainer = this.listContainer;
        s.scrollBarFrame = this.scrollBarFrame;
        s.scrollBarHitBtn = this.scrollBarHitBtn;
        s.scrollThumbFrame = this.scrollThumbFrame;
        s.scrollThumbHitBtn = this.scrollThumbHitBtn;
        s.taskListWheelRegistered = this.taskListWheelRegistered;
        return s;
    }
}
// ── 虚拟分区：pcall 槽位与热键回调路由 ──
let pcallInitTarget = null;
function taskUIInitPcallBody() {
    pcallInitTarget?.runInitBodyInPcall();
}
// ── 虚拟分区：热键回调：sync=true 全房触发，按 triggerPlayerId 路由到对应槽位 ──
let __togglePanelTriggerPlayer = null;
function taskUITogglePanelPcallBody() {
    const player = __togglePanelTriggerPlayer;
    const pid = (player != null && player !== 0) ? jass.GetPlayerId(player) : -1;
    const ui = getTaskUIByPlayerId(pid);
    if (ui)
        ui.togglePanelSync(player);
}
function taskUIHotkeyTogglePanel(player) {
    __togglePanelTriggerPlayer = player;
    pcall(taskUITogglePanelPcallBody);
}
function taskUIHotkeySwitchCategory(player, type) {
    const pid = (player != null && player !== 0) ? jass.GetPlayerId(player) : -1;
    const ui = getTaskUIByPlayerId(pid);
    if (ui)
        ui.switchCategorySync(player, type);
}
// ── 虚拟分区：英雄注册 + 热键注册 + 刷新回调 ──
/**
 * 由 `00．玩家英雄获取桥接` 调用。
 * 所有客户端对称执行（全局创建），异步显隐。
 */
export function onPlayerHeroRegistered(whichPlayer, _whichHero) {
    if (!ENABLE_TASK_UI_CLIENT)
        return false;
    if (whichPlayer == null || whichPlayer === 0)
        return false;
    const pid = jass.GetPlayerId(whichPlayer);
    if (typeof pid !== "number" || pid < 0 || pid >= MAX_PLAYERS)
        return false;
    if (taskUIs[pid]?.uiInitialized === true)
        return true;
    const ui = new TaskUI(pid);
    const ok = ui.init(pid);
    return ok;
}
/** 热键注册：全局只注册一次 */
export function registerHotkey() {
    if (!ENABLE_TASK_UI_CLIENT)
        return;
    if (hotkeyRegistered)
        return;
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
function onQuestManagerUiRefresh(_playerId, _questId) {
    for (let i = 0; i < MAX_PLAYERS; i++) {
        const ui = taskUIs[i];
        if (ui == null || !ui.uiInitialized)
            continue;
        ui.pagesDirty = true;
        if (ui.isVisible) {
            ui.rebuildPages();
        }
    }
}
export function registerTaskUIRefreshCallback() {
    if (refreshCallbackRegistered)
        return;
    refreshCallbackRegistered = true;
    if (!questManager || typeof questManager.registerUIRefreshCallback !== "function")
        return;
    questManager.registerUIRefreshCallback(onQuestManagerUiRefresh);
}
