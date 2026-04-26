local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local dispatchRefresh, pcallDispatchRefreshBody, taskUIInitPcallBody, onQuestManagerUiRefresh, mgr
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local applyTaskUIFacadeVisibleState = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.applyTaskUIFacadeVisibleState
local applyTaskUICategorySwitchVisibleState = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.applyTaskUICategorySwitchVisibleState
local getTaskUICategoryPageCount = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.getTaskUICategoryPageCount
local setTaskRowHandlers = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.setTaskRowHandlers
local ____13_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA = require("系统.08．任务系统.04．任务UI拆分.13．任务UI预设构建")
local createTaskUIPrecreatedListPool = ____13_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA.createTaskUIPrecreatedListPool
local ____14_FF0E_4EFB_52A1UI_5185_5BB9_540C_6B65 = require("系统.08．任务系统.04．任务UI拆分.14．任务UI内容同步")
local rebuildTaskUIFacadeListPool = ____14_FF0E_4EFB_52A1UI_5185_5BB9_540C_6B65.rebuildTaskUIFacadeListPool
local ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A = require("系统.08．任务系统.04．任务UI拆分.15．任务UI本地显示")
local toggleExpandLocal = ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A.toggleExpandLocal
local switchPageLocal = ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A.switchPageLocal
local ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E = require("系统.08．任务系统.04．任务UI拆分.10．任务UI滚动与滚轮")
local registerTaskUIListWheel = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.registerTaskUIListWheel
local updateTaskUIScrollBarVisibility = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.updateTaskUIScrollBarVisibility
local ____16_FF0E_4EFB_52A1UI_8F93_5165_7ED1_5B9A = require("系统.08．任务系统.04．任务UI拆分.16．任务UI输入绑定")
local registerTaskUIHotkeys = ____16_FF0E_4EFB_52A1UI_8F93_5165_7ED1_5B9A.registerTaskUIHotkeys
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local questManager = ____index.questManager
local ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807 = require("系统.08．任务系统.04．任务UI拆分.06．任务UI入口图标")
local buildTaskEntryIcon = ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807.buildTaskEntryIcon
local ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.08．任务UI主面板与滚动")
local buildTaskMainPanel = ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8.buildTaskMainPanel
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____index.getGameUI
local registerKeyUpSync = ____index.registerKeyUpSync
local KEY = ____index.KEY
local KEY_NUM = ____index.KEY_NUM
local getMouseFocus = ____index.getMouseFocus
local getWheelDelta = ____index.getWheelDelta
local registerMouseWheelHardware = ____index.registerMouseWheel
local ____index = require("系统.09．表现系统.01．UI工具.index")
local createFrame = ____index.createFrame
local setFramePosition = ____index.setFramePosition
local setFrameSize = ____index.setFrameSize
local setFrameTexture = ____index.setFrameTexture
local setButtonText = ____index.setButtonText
local setFrameClickEvent = ____index.setFrameClickEvent
local setFramePointRelative = ____index.setFramePointRelative
local setFrameHoverEvents = ____index.setFrameHoverEvents
local createTextLabel = ____index.createTextLabel
local FrameType = ____index.FrameType
local FramePoint = ____index.FramePoint
local hideFrame = ____index.hideFrame
local showFrame = ____index.showFrame
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local SoundUI_ClickPlay = ____index.SoundUI_ClickPlay
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local applyDzTextFontAndAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndAlignment
local applyDzTextFontAndCenterAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndCenterAlignment
local createTabLabelTextOnBackdrop = ____03_FF0EUI_51FD_6570.createTabLabelTextOnBackdrop
local setupTransparentGlueHitLayer = ____03_FF0EUI_51FD_6570.setupTransparentGlueHitLayer
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENABLE_TASK_UI_CLIENT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_CLIENT
function dispatchRefresh(self)
    if mgr then
        mgr:rebuildPages()
    end
end
function pcallDispatchRefreshBody(self)
    dispatchRefresh(nil)
end
function taskUIInitPcallBody(self)
    if mgr ~= nil then
        mgr:runInitBodyInPcall()
    end
end
function onQuestManagerUiRefresh(self, _playerId, _questId)
    pcall(pcallDispatchRefreshBody)
end
--- 当前仅由 `init` 调用；参数保留与旧调用点兼容，实现固定走 `dispatchRefresh`
function ____exports.registerTaskUIRefreshCallback(self, _rebuildPages)
    if not questManager or type(questManager.registerUIRefreshCallback) ~= "function" then
        return
    end
    questManager:registerUIRefreshCallback(onQuestManagerUiRefresh)
end
--- 12．任务UI管理器
-- 职责：全局单例 TaskUI 生命周期、持有引用、协调内容更新与本地显示控制。
-- 开局由 `10．index` 调用 `init()` 创建一套 UI（各客户端对称执行）；不再依赖英雄注册。
local jass = require("jass.common")
local japi = require("jass.japi")
mgr = nil
local clickSoundCallback = nil
local function taskUIModulePlayClickSound(self)
    if mgr ~= nil then
        mgr:playLocalClickSound()
    end
end
local function taskUIModuleRowExpand(self, questId)
    if mgr ~= nil then
        mgr:toggleExpandForRow(questId)
    end
end
local function taskUIModuleSwitchCategory(self, ____type)
    if mgr ~= nil then
        mgr:switchCategory(____type)
    end
end
local function taskUIModuleNoopTabTooltip(self, _msg)
end
local function taskUIScrollCtxIsVisible(self)
    local ____temp_8 = mgr and mgr.isVisible
    if ____temp_8 == nil then
        ____temp_8 = false
    end
    return ____temp_8
end
local function taskUIScrollCtxGetCurrentPageCount(self)
    return mgr ~= nil and mgr:getPageCountForCurrentCategory() or 0
end
local function taskUIScrollCtxGetCurrentPage(self)
    return mgr and mgr.currentPage or 0
end
local function taskUIScrollCtxSetCurrentPage(self, p)
    if mgr then
        mgr.currentPage = p
    end
end
local function taskUIScrollCtxOnPageChanged(self, prev, next)
    if mgr ~= nil then
        mgr:applyScrollPageChanged(prev, next)
    end
end
local function taskUIListCtxPlayClickSound(self)
    taskUIModulePlayClickSound(nil)
end
local function taskUIListCtxUpdateScrollBar(self, pageCount, hasQuestRows)
    if mgr ~= nil then
        mgr:syncScrollBarVisibility(pageCount, hasQuestRows)
    end
end
local function taskUIListCtxToggleExpand(self, questId)
    if mgr ~= nil then
        mgr:toggleExpandForRow(questId)
    end
end
local function taskUIListCtxGetCurrentPage(self, ____type)
    return mgr ~= nil and mgr:listGetCurrentPage(____type) or 0
end
local function taskUIListCtxSetCurrentPage(self, ____type, page)
    if mgr ~= nil then
        mgr:listSetCurrentPage(____type, page)
    end
end
local function taskUIListCtxGetExpandedQuestId(self, ____type)
    local ____temp_19
    if mgr ~= nil then
        ____temp_19 = mgr:listGetExpandedQuestId(____type)
    else
        ____temp_19 = nil
    end
    return ____temp_19
end
local function taskUITogglePanelPcallBody(self)
    if not mgr then
        return
    end
    mgr:togglePanel()
    if clickSoundCallback ~= nil then
        clickSoundCallback(nil)
    end
end
local function dispatchTogglePanel(self)
    if not mgr then
        return
    end
    pcall(taskUITogglePanelPcallBody)
end
local TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self)
    self.entryFrame = nil
    self.mainPanel = nil
    self.listContainer = nil
    self.scrollBarFrame = nil
    self.scrollThumbFrame = nil
    self.scrollThumbHitBtn = nil
    self.taskListWheelTrig = nil
    self.precreatedListPool = nil
    self.pagesDirty = false
    self.localPlayerId = 0
    self.localPlayer = nil
    self.currentCategory = QuestType.MAIN
    self.currentPage = 0
    self.expandedQuestId = nil
    self.isVisible = false
    self.uiInitialized = false
    self.listCtxCache = nil
    self.scrollCtxCache = nil
end
function TaskUI.prototype.ensureUiContextCaches(self)
    if self.scrollCtxCache ~= nil then
        return
    end
    self.scrollCtxCache = {
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        scrollBarFrame = self.scrollBarFrame,
        scrollThumbFrame = self.scrollThumbFrame,
        scrollThumbHitBtn = self.scrollThumbHitBtn,
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        taskListWheelTrig = self.taskListWheelTrig,
        getMouseFocus = getMouseFocus,
        getWheelDelta = getWheelDelta,
        registerMouseWheel = function(sync, cb, playerId)
            return registerMouseWheelHardware(nil, sync, cb, playerId)
        end,
        isVisible = taskUIScrollCtxIsVisible,
        getCurrentPageCount = taskUIScrollCtxGetCurrentPageCount,
        getCurrentPage = taskUIScrollCtxGetCurrentPage,
        setCurrentPage = taskUIScrollCtxSetCurrentPage,
        onPageChanged = taskUIScrollCtxOnPageChanged
    }
    self.listCtxCache = {
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        currentPlayerId = self.localPlayerId,
        currentCategory = self.currentCategory,
        precreatedListPool = self.precreatedListPool,
        createTextLabel = createTextLabel,
        FramePoint = FramePoint,
        FrameType = FrameType,
        createFrame = createFrame,
        setFrameTexture = setFrameTexture,
        setFramePointRelative = setFramePointRelative,
        setFrameSize = setFrameSize,
        setFrameClickEvent = setFrameClickEvent,
        setupTransparentGlueHitLayer = setupTransparentGlueHitLayer,
        showFrame = showFrame,
        hideFrame = hideFrame,
        applyDzTextFontAndCenterAlignment = applyDzTextFontAndCenterAlignment,
        applyDzTextFontAndAlignment = applyDzTextFontAndAlignment,
        playClickSound = taskUIListCtxPlayClickSound,
        updateScrollBarVisibility = taskUIListCtxUpdateScrollBar,
        toggleExpand = taskUIListCtxToggleExpand,
        getCurrentPage = taskUIListCtxGetCurrentPage,
        setCurrentPage = taskUIListCtxSetCurrentPage,
        getExpandedQuestId = taskUIListCtxGetExpandedQuestId
    }
end
function TaskUI.prototype.init(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    if self.uiInitialized then
        return
    end
    mgr = self
    pcall(taskUIInitPcallBody)
end
function TaskUI.prototype.runInitBodyInPcall(self)
    local gameUI = getGameUI(nil)
    if not gameUI then
        return
    end
    self.localPlayer = jass.GetLocalPlayer()
    self.localPlayerId = self:resolveLocalPlayerId()
    self:createEntryIcon(gameUI)
    self:createMainPanel(gameUI)
    self:createListPool()
    self:registerTaskListWheel()
    self:resetToDefault()
    self:rebuildPages()
    ____exports.registerTaskUIRefreshCallback(nil, dispatchRefresh)
    self:hidePanel()
    self.uiInitialized = true
end
function TaskUI.prototype.createEntryIcon(self, parent)
    clickSoundCallback = taskUIModulePlayClickSound
    local res = buildTaskEntryIcon(nil, {
        japi = japi,
        parent = parent,
        FrameType = FrameType,
        FramePoint = FramePoint,
        createFrame = createFrame,
        createTextLabel = createTextLabel,
        setFramePosition = setFramePosition,
        setFrameSize = setFrameSize,
        setFramePointRelative = setFramePointRelative,
        setFrameClickEvent = setFrameClickEvent,
        applyDzTextFontAndCenterAlignment = applyDzTextFontAndCenterAlignment,
        onTogglePanel = dispatchTogglePanel
    })
    self.entryFrame = res.entryFrame
end
function TaskUI.prototype.createMainPanel(self, parent)
    local res = buildTaskMainPanel(nil, {
        japi = japi,
        parent = parent,
        entryFrame = self.entryFrame,
        FrameType = FrameType,
        FramePoint = FramePoint,
        createFrame = createFrame,
        setFramePosition = setFramePosition,
        setFrameSize = setFrameSize,
        setFramePointRelative = setFramePointRelative,
        setFrameTexture = setFrameTexture,
        setFrameHoverEvents = setFrameHoverEvents,
        setFrameClickEvent = setFrameClickEvent,
        setButtonText = setButtonText,
        createTabLabelTextOnBackdrop = createTabLabelTextOnBackdrop,
        setupTransparentGlueHitLayer = setupTransparentGlueHitLayer,
        onClickSound = taskUIModulePlayClickSound,
        onSwitchCategory = taskUIModuleSwitchCategory,
        onShowTabTooltip = taskUIModuleNoopTabTooltip
    })
    self.mainPanel = res.mainPanel
    self.listContainer = res.listContainer
    self.scrollBarFrame = res.scrollBarFrame
    self.scrollThumbFrame = res.scrollThumbFrame
    self.scrollThumbHitBtn = res.scrollThumbHitBtn
end
function TaskUI.prototype.createListPool(self)
    self.precreatedListPool = createTaskUIPrecreatedListPool(
        nil,
        self:getListControlContext()
    )
    setTaskRowHandlers(nil, taskUIModuleRowExpand, taskUIModulePlayClickSound)
end
function TaskUI.prototype.registerTaskListWheel(self)
    self.taskListWheelTrig = registerTaskUIListWheel(
        nil,
        self:getScrollContext()
    )
end
function TaskUI.prototype.rebuildPages(self)
    rebuildTaskUIFacadeListPool(
        nil,
        self:getListControlContext()
    )
    self.pagesDirty = false
    if self.isVisible then
        self:showCurrentCategory()
    end
end
function TaskUI.prototype.resetToDefault(self)
    self.currentCategory = QuestType.MAIN
    self.currentPage = 0
    self.expandedQuestId = nil
end
function TaskUI.prototype.resolveLocalPlayerId(self)
    local lp = jass.GetLocalPlayer()
    if lp == nil then
        return 0
    end
    local ____temp_22
    if type(jass.GetPlayerId) == "function" then
        ____temp_22 = jass.GetPlayerId(lp)
    else
        ____temp_22 = -1
    end
    local pid = ____temp_22
    return pid < 0 and 0 or pid
end
function TaskUI.prototype.playLocalClickSound(self)
    SoundUI_ClickPlay(nil, nil, self.localPlayer)
end
function TaskUI.prototype.toggleExpandForRow(self, questId)
    self:toggleExpand(questId)
end
function TaskUI.prototype.getPageCountForCurrentCategory(self)
    return self:getPageCount(self.currentCategory)
end
function TaskUI.prototype.applyScrollPageChanged(self, prev, next)
    self.currentPage = next
    self.expandedQuestId = nil
    switchPageLocal(
        nil,
        self.precreatedListPool,
        self.currentCategory,
        prev,
        next
    )
end
function TaskUI.prototype.syncScrollBarVisibility(self, pageCount, hasQuestRows)
    updateTaskUIScrollBarVisibility(
        nil,
        self:getScrollContext(),
        pageCount,
        hasQuestRows
    )
end
function TaskUI.prototype.listGetCurrentPage(self, ____type)
    return ____type == self.currentCategory and self.currentPage or 0
end
function TaskUI.prototype.listSetCurrentPage(self, ____type, page)
    if ____type == self.currentCategory then
        self.currentPage = page
    end
end
function TaskUI.prototype.listGetExpandedQuestId(self, ____type)
    local ____temp_23
    if ____type == self.currentCategory then
        ____temp_23 = self.expandedQuestId
    else
        ____temp_23 = nil
    end
    return ____temp_23
end
function TaskUI.prototype.getPageCount(self, ____type)
    return getTaskUICategoryPageCount(nil, self.precreatedListPool, ____type)
end
function TaskUI.prototype.showCurrentCategory(self)
    applyTaskUIFacadeVisibleState(
        nil,
        self:getListControlContext()
    )
end
function TaskUI.prototype.switchCategoryState(self, ____type)
    if self.currentCategory == ____type then
        return
    end
    self.currentCategory = ____type
    self.currentPage = 0
    self.expandedQuestId = nil
end
function TaskUI.prototype.switchCategoryUI(self, ____type)
    if not self.isVisible then
        return
    end
    applyTaskUICategorySwitchVisibleState(
        nil,
        self:getListControlContext()
    )
    local pc = self:getPageCount(____type)
    updateTaskUIScrollBarVisibility(
        nil,
        self:getScrollContext(),
        pc,
        pc > 0
    )
end
function TaskUI.prototype.switchCategory(self, ____type)
    if not self.isVisible then
        return
    end
    if self.currentCategory == ____type then
        return
    end
    self:switchCategoryState(____type)
    self:switchCategoryUI(____type)
end
function TaskUI.prototype.toggleExpand(self, questId)
    local oldExpanded = self.expandedQuestId
    local ____temp_24
    if oldExpanded == questId then
        ____temp_24 = nil
    else
        ____temp_24 = questId
    end
    self.expandedQuestId = ____temp_24
    toggleExpandLocal(
        nil,
        self.precreatedListPool,
        self.currentCategory,
        self.currentPage,
        oldExpanded,
        questId
    )
end
function TaskUI.prototype.changeCurrentPage(self, delta)
    local pageCount = self:getPageCount(self.currentCategory)
    if pageCount <= 1 then
        return
    end
    local currentPage = self.currentPage
    local nextPage = math.max(
        0,
        math.min(pageCount - 1, currentPage + delta)
    )
    if nextPage == currentPage then
        return
    end
    self.currentPage = nextPage
    self.expandedQuestId = nil
    switchPageLocal(
        nil,
        self.precreatedListPool,
        self.currentCategory,
        currentPage,
        nextPage
    )
end
function TaskUI.prototype.togglePanel(self)
    if self.isVisible then
        self:hidePanel()
    else
        self:showPanel()
    end
end
function TaskUI.prototype.showPanel(self)
    if not self.mainPanel then
        return
    end
    self:resetToDefault()
    if self.pagesDirty then
        self:rebuildPages()
    end
    showFrame(nil, self.mainPanel)
    self.isVisible = true
    self:showCurrentCategory()
end
function TaskUI.prototype.hidePanel(self)
    if not self.mainPanel then
        return
    end
    if self.precreatedListPool then
        for ____, ct in ipairs({QuestType.MAIN, QuestType.SIDE, QuestType.DAILY}) do
            local cv = self.precreatedListPool.categories[ct]
            if cv then
                japi.DzFrameShow(cv.root, false)
            end
        end
    end
    hideFrame(nil, self.mainPanel)
    self.isVisible = false
end
function TaskUI.prototype.getListControlContext(self)
    self:ensureUiContextCaches()
    local c = self.listCtxCache
    c.mainPanel = self.mainPanel
    c.listContainer = self.listContainer
    c.currentPlayerId = self.localPlayerId
    c.currentCategory = self.currentCategory
    c.precreatedListPool = self.precreatedListPool
    return c
end
function TaskUI.prototype.getScrollContext(self)
    self:ensureUiContextCaches()
    local s = self.scrollCtxCache
    s.mainPanel = self.mainPanel
    s.listContainer = self.listContainer
    s.scrollBarFrame = self.scrollBarFrame
    s.scrollThumbFrame = self.scrollThumbFrame
    s.scrollThumbHitBtn = self.scrollThumbHitBtn
    s.taskListWheelTrig = self.taskListWheelTrig
    return s
end
local taskUI = __TS__New(TaskUI)
____exports.taskUI = taskUI
local function taskUIHotkeySwitchCategoryState(self, ____type)
    taskUI:switchCategoryState(____type)
end
local function taskUIHotkeySwitchCategoryUI(self, ____type)
    taskUI:switchCategoryUI(____type)
end
--- 地图加载时创建全局单例任务 UI（各客户端对称执行一次）
function ____exports.init(self)
    taskUI:init()
end
function ____exports.registerHotkey(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    registerTaskUIHotkeys(nil, {
        registerKeyUpSync = registerKeyUpSync,
        KEY = KEY,
        KEY_NUM = KEY_NUM,
        onTogglePanelLocal = dispatchTogglePanel,
        onSwitchCategoryState = taskUIHotkeySwitchCategoryState,
        onSwitchCategoryUI = taskUIHotkeySwitchCategoryUI
    })
end
return ____exports
