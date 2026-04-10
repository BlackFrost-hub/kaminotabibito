/**
 * 任务系统 - 全新任务 UI（魔兽原生风格）
 * 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
 * listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
import { ENABLE_MOUSE_WHEEL_SCROLL, LIST_VIEW_H, SCROLL_THUMB_SIZE, SCROLL_THUMB_TOP_COMPENSATION, SCROLL_THUMB_BOTTOM_COMPENSATION, THUMB_DRAG_TICK, THUMB_DRAG_SENSITIVITY, } from "./03．任务UI拆分/01．任务UI常量";
import { isDescendantOf as isDescendantOfByJapi, isWheelTargetForTaskList as isWheelTargetForTaskListByJapi, computeNextScrollOffsetByWheel, updateScrollBarVisibility as updateScrollBarVisibilityByJapi, refreshTaskUIList, } from "./03．任务UI拆分/03．任务UI列表与滚动";
import { renderQuestRow } from "./03．任务UI拆分/04．任务UI渲染";
import { registerTaskUIHotkeys, buildTaskMainPanel, buildTaskEntryIcon } from "./03．任务UI拆分/05．任务UI构建与热键";
import { getGameUI, registerKeyDown, KEY, KEY_NUM, getWheelDelta, getMouseFocus, registerMouseWheel, } from "../00．核心系统/04．硬件函数";
import { createFrame, setFramePosition, setFrameSize, setFrameTexture, setButtonText, setFrameClickEvent, setFramePointRelative, setFrameHoverEvents, createTextLabel, FrameType, FramePoint, hideFrame, showFrame, } from "../09．表现系统/01．UI工具/index";
import { VerticalScrollbarTrack } from "../09．表现系统/02．垂直滚动条轨道";
import { questManager } from "./02．任务管理器";
import { QuestType } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../00．核心系统/02．音效函数";
import { applyDzTextFontAndAlignment, applyDzTextFontAndCenterAlignment, createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer, } from "../00．核心系统/06．UI函数";
// （以上常量/辅助函数已拆分到 `03．任务UI拆分/*`）
class TaskUI {
    entryFrame = null;
    entryText = null;
    mainPanel = null;
    listContainer = null;
    tabMain = null;
    tabSide = null;
    tabDaily = null;
    tabMainBg = null;
    tabSideBg = null;
    tabDailyBg = null;
    currentCategory = QuestType.MAIN;
    listItemFrames = [];
    scrollBarFrame = null;
    scrollThumbFrame = null;
    /** 叠在滑块上的透明按钮，用于接收按下/拖拽（BACKDROP 本身不响应点击） */
    scrollThumbHitBtn = null;
    /** 封装：全局鼠标 + focus 判定 + thumb 同步（见 `垂直滚动条轨道.ts`） */
    vScrollTrack = null;
    /** 列表区域滚轮：用全局滚轮 + 父链判定，避免只绑在行 clickBtn 上时 TEXT/子帧抢焦点导致滚轮无效 */
    taskListWheelTrig = null;
    scrollOffset = 0;
    totalContentHeight = 0;
    expandedQuestIds = new Set();
    isVisible = false;
    currentPlayerId = 0;
    // 复用动态创建的帧，避免每次刷新都创建同名帧（以及由此带来的溢出/性能问题）
    rowBackdropByQuestId = new Map();
    titleByQuestId = new Map();
    clickBtnByQuestId = new Map();
    objFrameByKey = new Map(); // questId|objectiveId
    failFrameByQuestId = new Map();
    rowIconByQuestId = new Map();
    init() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            const gameUI = getGameUI();
            if (!gameUI)
                return;
            this.createEntryIcon(gameUI);
            this.createMainPanel(gameUI);
            this.registerTaskListWheel();
            this.registerRefreshCallback();
            this.hide();
        });
    }
    registerRefreshCallback() {
        questManager.registerUIRefreshCallback((_playerId, _questId) => {
            pcall(() => {
                if (typeof jass.GetLocalPlayer !== "function")
                    return;
                const lp = jass.GetLocalPlayer();
                if (lp == null)
                    return;
                if (!this.isVisible)
                    return;
                this.refreshList();
            });
        });
    }
    /** 从 frame 沿父链向上，是否落在 ancestor 子树内 */
    isDescendantOf(frame, ancestor) {
        return isDescendantOfByJapi(japi, frame, ancestor);
    }
    /** 滚轮是否应作用在任务列表（列表容器、滚动条轨道、滑块及其子帧） */
    isWheelTargetForTaskList() {
        if (!this.mainPanel)
            return false;
        return isWheelTargetForTaskListByJapi(japi, typeof getMouseFocus === "function" ? getMouseFocus : undefined, this.listContainer, this.scrollBarFrame, this.scrollThumbFrame, this.scrollThumbHitBtn);
    }
    registerTaskListWheel() {
        if (!ENABLE_MOUSE_WHEEL_SCROLL)
            return;
        if (this.taskListWheelTrig)
            return;
        this.taskListWheelTrig = registerMouseWheel(false, () => {
            pcall(() => {
                if (typeof jass.GetLocalPlayer !== "function")
                    return;
                const lp = jass.GetLocalPlayer();
                if (lp == null)
                    return;
                if (!this.isVisible)
                    return;
                if (!this.isWheelTargetForTaskList())
                    return;
                this.onListWheel();
            });
        });
    }
    createEntryIcon(parent) {
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
    createMainPanel(parent) {
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
            onSwitchCategory: (type) => this.switchCategory(type),
            onShowTabTooltip: (msg) => this.showTabTooltip(msg),
            getTotalContentHeight: () => this.totalContentHeight,
            getScrollOffset: () => this.scrollOffset,
            setScrollOffset: (v) => {
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
    onListWheel() {
        const next = computeNextScrollOffsetByWheel(typeof getWheelDelta === "function" ? getWheelDelta : undefined, this.scrollOffset, this.totalContentHeight, LIST_VIEW_H);
        if (next === this.scrollOffset)
            return;
        this.scrollOffset = next;
        this.refreshList();
    }
    /** 手动同步圆形 thumb + 全局鼠标拖拽（逻辑在 `垂直滚动条轨道.ts`） */
    setupThumbDrag() {
        if (!this.scrollThumbFrame || this.scrollThumbFrame === 0 || !this.mainPanel || !this.scrollBarFrame)
            return;
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
    syncScrollThumb(maxScroll) {
        if (!this.vScrollTrack)
            return;
        this.vScrollTrack.syncThumbVisual(maxScroll);
    }
    /** 内容不足一屏时隐藏轨道与滑块，避免多余滚动条 */
    updateScrollBarVisibility(maxScroll) {
        updateScrollBarVisibilityByJapi(japi, maxScroll, [this.scrollBarFrame, this.scrollThumbFrame, this.scrollThumbHitBtn]);
    }
    clearList() {
        for (const f of this.listItemFrames) {
            if (typeof japi.DzFrameShow === "function")
                japi.DzFrameShow(f, false);
        }
        if (typeof japi.DzFrameShow === "function") {
            for (const f of this.rowBackdropByQuestId.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
            for (const f of this.titleByQuestId.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
            for (const f of this.clickBtnByQuestId.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
            for (const f of this.objFrameByKey.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
            for (const f of this.failFrameByQuestId.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
            for (const f of this.rowIconByQuestId.values()) {
                if (f !== 0)
                    japi.DzFrameShow(f, false);
            }
        }
        this.listItemFrames = [];
    }
    showTabTooltip(msg) {
        if (typeof japi.DzGetTriggerUIEventPlayer !== "function" || typeof jass.DisplayTextToPlayer !== "function")
            return;
        const p = japi.DzGetTriggerUIEventPlayer();
        if (p)
            jass.DisplayTextToPlayer(p, 0, 0, msg);
    }
    switchCategory(type) {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            this.currentCategory = type;
            this.expandedQuestIds.clear();
            this.scrollOffset = 0;
            this.refreshList();
        });
    }
    toggleExpand(questId) {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (this.expandedQuestIds.has(questId)) {
                this.expandedQuestIds.delete(questId);
            }
            else {
                this.expandedQuestIds.add(questId);
            }
            this.refreshList();
        });
    }
    refreshList() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.mainPanel || !this.listContainer)
                return;
            this.clearList();
            refreshTaskUIList({
                currentPlayerId: this.currentPlayerId,
                currentCategory: this.currentCategory,
                scrollOffset: this.scrollOffset,
                setScrollOffset: (v) => {
                    this.scrollOffset = v;
                },
                setTotalContentHeight: (v) => {
                    this.totalContentHeight = v;
                },
                listContainer: this.listContainer,
                expandedQuestIds: this.expandedQuestIds,
                createTextLabel,
                FramePoint,
                applyDzTextFontAndCenterAlignment,
                pushListItemFrame: (f) => this.listItemFrames.push(f),
                syncScrollThumb: (maxScroll) => this.syncScrollThumb(maxScroll),
                updateScrollBarVisibility: (maxScroll) => this.updateScrollBarVisibility(maxScroll),
                createListItem: (quest, rowTopRel, expanded) => this.createListItem(quest, rowTopRel, expanded),
            });
        });
    }
    createListItem(quest, rowTopRel, expanded) {
        const listParent = this.listContainer;
        if (!this.mainPanel || !listParent)
            return null;
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
            onToggleExpand: (questId) => this.toggleExpand(questId),
            onClickSound: () => SoundUI_ClickPlay(),
            rowBackdropByQuestId: this.rowBackdropByQuestId,
            titleByQuestId: this.titleByQuestId,
            clickBtnByQuestId: this.clickBtnByQuestId,
            objFrameByKey: this.objFrameByKey,
            failFrameByQuestId: this.failFrameByQuestId,
            rowIconByQuestId: this.rowIconByQuestId,
            listItemFrames: this.listItemFrames,
        });
        if (!ok)
            return null;
        return 0;
    }
    togglePanel() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            this.isVisible = !this.isVisible;
            if (this.isVisible)
                this.show(this.currentPlayerId);
            else
                this.hide();
        });
    }
    show(playerId) {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.mainPanel)
                return;
            this.currentPlayerId = playerId;
            this.isVisible = true;
            showFrame(this.mainPanel);
            this.refreshList();
        });
    }
    hide() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.mainPanel)
                return;
            this.vScrollTrack?.cancelDrag();
            this.isVisible = false;
            hideFrame(this.mainPanel);
        });
    }
    registerHotkey() {
        registerTaskUIHotkeys({
            registerKeyDown,
            KEY,
            KEY_NUM,
            onClickSound: () => SoundUI_ClickPlay(),
            onTogglePanel: () => this.togglePanel(),
            onSwitchCategory: (type) => this.switchCategory(type),
            isVisible: () => this.isVisible,
            setCurrentPlayerId: (pid) => {
                this.currentPlayerId = pid;
            },
        });
    }
}
export const taskUI = new TaskUI();
export function init() {
    taskUI.init();
}
export function registerHotkey() {
    taskUI.registerHotkey();
}
