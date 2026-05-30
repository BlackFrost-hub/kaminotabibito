local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local getTaskUIByPlayerId, taskUIInitPcallBody, taskUITogglePanelPcallBody, taskUIHotkeyTogglePanel, isHumanPlayingPlayer, onQuestManagerUiRefresh, jass, taskUIs, refreshCallbackRegistered, TaskUI, pcallInitTarget, __togglePanelTriggerPlayer
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.02．任务UI拆分.08．任务UI列表控制")
local applyTaskUIFacadeVisibleState = ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.applyTaskUIFacadeVisibleState
local applyTaskUICategorySwitchVisibleState = ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.applyTaskUICategorySwitchVisibleState
local getTaskUICategoryPageCount = ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.getTaskUICategoryPageCount
local setTaskRowHandlers = ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.setTaskRowHandlers
local rebuildTaskUIFacadeListPool = ____08_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.rebuildTaskUIFacadeListPool
local ____12_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA = require("系统.08．任务系统.02．任务UI拆分.12．任务UI预设构建")
local createTaskUIPrecreatedListPool = ____12_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA.createTaskUIPrecreatedListPool
local ____13_FF0E_4EFB_52A1UI_672C_5730_663E_793A = require("系统.08．任务系统.02．任务UI拆分.13．任务UI本地显示")
local toggleExpandLocal = ____13_FF0E_4EFB_52A1UI_672C_5730_663E_793A.toggleExpandLocal
local switchPageLocal = ____13_FF0E_4EFB_52A1UI_672C_5730_663E_793A.switchPageLocal
local ____09_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E = require("系统.08．任务系统.02．任务UI拆分.09．任务UI滚动与滚轮")
local registerTaskUIListWheel = ____09_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.registerTaskUIListWheel
local updateTaskUIScrollBarVisibility = ____09_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.updateTaskUIScrollBarVisibility
local ____04_FF0E_4EFB_52A1UI_70ED_952E = require("系统.08．任务系统.02．任务UI拆分.04．任务UI热键")
local registerTaskUIHotkeys = ____04_FF0E_4EFB_52A1UI_70ED_952E.registerTaskUIHotkeys
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____05_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807 = require("系统.08．任务系统.02．任务UI拆分.05．任务UI入口图标")
local buildTaskEntryIcon = ____05_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807.buildTaskEntryIcon
local ____07_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8 = require("系统.08．任务系统.02．任务UI拆分.07．任务UI主面板与滚动")
local buildTaskMainPanel = ____07_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8.buildTaskMainPanel
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
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local ENABLE_TASK_UI_CLIENT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_CLIENT
local MAX_PLAYERS = ____01_FF0E_4EFB_52A1UI_5E38_91CF.MAX_PLAYERS
local TAG_SLOT_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAG_SLOT_OFFSET
function getTaskUIByPlayerId(playerId)
    if type(playerId) ~= "number" or playerId < 0 or playerId >= MAX_PLAYERS then
        return nil
    end
    return taskUIs[playerId]
end
function taskUIInitPcallBody(self)
    if pcallInitTarget ~= nil then
        pcallInitTarget:runInitBodyInPcall()
    end
end
function taskUITogglePanelPcallBody(self)
    local player = __togglePanelTriggerPlayer
    local ____temp_10
    if player ~= nil and player ~= 0 then
        ____temp_10 = jass.GetPlayerId(player)
    else
        ____temp_10 = -1
    end
    local pid = ____temp_10
    local ui = getTaskUIByPlayerId(pid)
    if ui then
        ui:togglePanelSync(player)
    end
end
function taskUIHotkeyTogglePanel(player)
    __togglePanelTriggerPlayer = player
    pcall(taskUITogglePanelPcallBody)
end
function isHumanPlayingPlayer(whichPlayer)
    if whichPlayer == nil or whichPlayer == 0 then
        return false
    end
    local pid = jass.GetPlayerId(whichPlayer)
    if type(pid) ~= "number" or pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    if jass.GetPlayerController(whichPlayer) == jass.MAP_CONTROL_COMPUTER then
        return false
    end
    return jass.GetPlayerSlotState(whichPlayer) == jass.PLAYER_SLOT_STATE_PLAYING
end
function ____exports.initTaskUIForPlayer(whichPlayer)
    if not ENABLE_TASK_UI_CLIENT then
        return false
    end
    if not isHumanPlayingPlayer(whichPlayer) then
        return false
    end
    local pid = jass.GetPlayerId(whichPlayer)
    local ____opt_12 = taskUIs[pid]
    if (____opt_12 and ____opt_12.uiInitialized) == true then
        return true
    end
    local ui = __TS__New(TaskUI, pid)
    return ui:init(pid)
end
function onQuestManagerUiRefresh(self, _playerId, _questId)
    do
        local i = 0
        while i < MAX_PLAYERS do
            do
                local ui = taskUIs[i]
                if ui == nil or not ui.uiInitialized then
                    goto __continue123
                end
                ui.pagesDirty = true
                if ui.isVisible then
                    ui:rebuildPages()
                end
            end
            ::__continue123::
            i = i + 1
        end
    end
end
function ____exports.registerTaskUIRefreshCallback(self)
    if refreshCallbackRegistered then
        return
    end
    refreshCallbackRegistered = true
    if not questManager or type(questManager.registerUIRefreshCallback) ~= "function" then
        return
    end
    questManager:registerUIRefreshCallback(onQuestManagerUiRefresh)
end
jass = require("jass.common")
local japi = require("jass.japi")
taskUIs = {}
local hotkeyRegistered = false
refreshCallbackRegistered = false
--- 获取按键玩家对应的 playerId（-1 表示无效）
local function getTriggerPlayerId(self)
    local ____temp_0
    if japi.DzGetTriggerKeyPlayer ~= nil then
        ____temp_0 = japi.DzGetTriggerKeyPlayer()
    else
        ____temp_0 = nil
    end
    local tp = ____temp_0
    if tp == nil or tp == 0 then
        return -1
    end
    local pid = jass.GetPlayerId(tp)
    return type(pid) == "number" and pid >= 0 and pid < MAX_PLAYERS and pid or -1
end
local function taskUIModulePlayClickSound()
    local lp = jass.GetLocalPlayer()
    local pid = jass.GetPlayerId(lp)
    local ____temp_1
    if pid >= 0 and pid < MAX_PLAYERS then
        ____temp_1 = taskUIs[pid]
    else
        ____temp_1 = nil
    end
    local ui = ____temp_1
    if ui then
        ui:playLocalClickSound()
    end
end
local function taskUIModuleRowExpand(rowIndex)
    local pid = getTriggerPlayerId(nil)
    local ____temp_2
    if pid >= 0 and pid < MAX_PLAYERS then
        ____temp_2 = taskUIs[pid]
    else
        ____temp_2 = nil
    end
    local ui = ____temp_2
    if ui then
        ui:toggleExpandForVisibleRow(rowIndex)
    end
end
local function taskUIModuleSwitchCategory(____type)
    local pid = getTriggerPlayerId(nil)
    local ____temp_3
    if pid >= 0 and pid < MAX_PLAYERS then
        ____temp_3 = taskUIs[pid]
    else
        ____temp_3 = nil
    end
    local ui = ____temp_3
    if ui then
        ui:switchCategory(____type)
    end
end
local function taskUIModuleNoopTabTooltip(_msg)
end
local function getTriggerPlayerOrLocal()
    if japi.DzGetTriggerKeyPlayer ~= nil then
        return japi.DzGetTriggerKeyPlayer()
    end
    return jass.GetLocalPlayer()
end
local function taskUIEntryClick()
    taskUIHotkeyTogglePanel(getTriggerPlayerOrLocal())
end
TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self, slotId)
    self.entryFrame = nil
    self.mainPanel = nil
    self.listContainer = nil
    self.scrollBarFrame = nil
    self.scrollBarHitBtn = nil
    self.scrollThumbFrame = nil
    self.scrollThumbHitBtn = nil
    self.taskListWheelRegistered = false
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
    self.slotId = slotId
    self.playerId = slotId
end
function TaskUI.prototype.ensureUiContextCaches(self)
    local ____self = self
    if self.scrollCtxCache ~= nil then
        return
    end
    self.scrollCtxCache = {
        playerId = self.playerId,
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        scrollBarFrame = self.scrollBarFrame,
        scrollBarHitBtn = self.scrollBarHitBtn,
        scrollThumbFrame = self.scrollThumbFrame,
        scrollThumbHitBtn = self.scrollThumbHitBtn,
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        taskListWheelRegistered = self.taskListWheelRegistered,
        getMouseFocus = getMouseFocus,
        getWheelDelta = getWheelDelta,
        registerMouseWheel = function(sync, cb, playerId)
            return registerMouseWheelHardware(nil, sync, cb, playerId)
        end,
        isVisible = function() return ____self.isVisible end,
        isOwnedByLocalPlayer = function() return ____self.localPlayer == jass.GetLocalPlayer() end,
        getCurrentPageCount = function() return ____self:getPageCountForCurrentCategory() end,
        getCurrentPage = function() return ____self.currentPage end,
        setCurrentPage = function(____, p)
            ____self.currentPage = p
        end,
        onPageChanged = function(____, prev, next)
            ____self:applyScrollPageChanged(prev, next)
        end
    }
    self.listCtxCache = {
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        currentPlayerId = self.localPlayerId,
        currentCategory = self.currentCategory,
        precreatedListPool = self.precreatedListPool,
        contextId = self.slotContextId,
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
        playClickSound = function()
            ____self:playLocalClickSound()
        end,
        updateScrollBarVisibility = function(____, pageCount, hasQuestRows)
            ____self:syncScrollBarVisibility(pageCount, hasQuestRows)
        end,
        toggleExpand = function(____, rowIndex)
            ____self:toggleExpandForVisibleRow(rowIndex)
        end,
        getCurrentPage = function(____, ____type) return ____self:listGetCurrentPage(____type) end,
        setCurrentPage = function(____, ____type, page)
            ____self:listSetCurrentPage(____type, page)
        end,
        getExpandedQuestId = function(____, ____type) return ____self:listGetExpandedQuestId(____type) end
    }
end
function TaskUI.prototype.init(self, playerId)
    if not ENABLE_TASK_UI_CLIENT then
        return false
    end
    if self.uiInitialized then
        return true
    end
    self.localPlayer = jass.Player(playerId)
    self.localPlayerId = playerId
    pcallInitTarget = self
    do
        local function ____catch(_e)
            pcallInitTarget = nil
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            taskUIInitPcallBody(nil)
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
    pcallInitTarget = nil
    if not self.uiInitialized then
        return false
    end
    taskUIs[playerId] = self
    return true
end
function TaskUI.prototype.runInitBodyInPcall(self)
    local gameUI = getGameUI()
    if not gameUI then
        return
    end
    self:createEntryIcon(gameUI)
    self:createMainPanel(gameUI)
    self:createListPool()
    self:registerTaskListWheel()
    self:resetToDefault()
    self:rebuildPages()
    ____exports.registerTaskUIRefreshCallback(nil)
    self:hidePanelState()
    self:hidePanelUI()
    self.uiInitialized = true
end
function TaskUI.prototype.createEntryIcon(self, parent)
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
        onTogglePanel = taskUIEntryClick,
        slotId = self.slotId,
        contextId = self.slotContextId
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
        onShowTabTooltip = taskUIModuleNoopTabTooltip,
        slotId = self.slotId,
        contextId = self.slotContextId
    })
    self.mainPanel = res.mainPanel
    self.listContainer = res.listContainer
    self.scrollBarFrame = res.scrollBarFrame
    self.scrollBarHitBtn = res.scrollBarHitBtn
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
    registerTaskUIListWheel(
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
        local localPlayer = jass.GetLocalPlayer()
        if self.localPlayer ~= nil and self.localPlayer == localPlayer then
            self:showCurrentCategory()
        end
    end
end
function TaskUI.prototype.resetToDefault(self)
    self.currentCategory = QuestType.MAIN
    self.currentPage = 0
    self.expandedQuestId = nil
end
function TaskUI.prototype.playLocalClickSound(self)
    SoundUI_ClickPlay(nil, self.localPlayer)
end
function TaskUI.prototype.toggleExpandForRow(self, questId)
    self:toggleExpand(questId)
end
function TaskUI.prototype.toggleExpandForVisibleRow(self, rowIndex)
    local ____opt_4 = self.precreatedListPool
    local categoryView = ____opt_4 and ____opt_4.categories[self.currentCategory]
    if not categoryView then
        return
    end
    local page = categoryView.pages[self.currentPage + 1]
    if not page then
        return
    end
    local questId = page.questIds[rowIndex + 1]
    if not questId then
        return
    end
    self:toggleExpand(questId)
end
function TaskUI.prototype.getPageCountForCurrentCategory(self)
    return self:getPageCount(self.currentCategory)
end
function TaskUI.prototype.applyScrollPageChanged(self, prev, next)
    self.currentPage = next
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
    local ____temp_6
    if ____type == self.currentCategory then
        ____temp_6 = self.expandedQuestId
    else
        ____temp_6 = nil
    end
    return ____temp_6
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
function TaskUI.prototype.switchCategorySync(self, player, ____type)
    self:switchCategoryState(____type)
    local localPlayer = jass.GetLocalPlayer()
    if player == localPlayer then
        self:switchCategoryUI(____type)
    end
end
function TaskUI.prototype.switchCategory(self, ____type)
    local triggerPlayer = japi.DzGetTriggerKeyPlayer()
    self:switchCategorySync(triggerPlayer, ____type)
end
function TaskUI.prototype.toggleExpandSync(self, player, questId)
    local oldExpanded = self.expandedQuestId
    local ____temp_7
    if oldExpanded == questId then
        ____temp_7 = nil
    else
        ____temp_7 = questId
    end
    self.expandedQuestId = ____temp_7
    local localPlayer = jass.GetLocalPlayer()
    if player == localPlayer then
        toggleExpandLocal(
            nil,
            self.precreatedListPool,
            self.currentCategory,
            self.currentPage,
            oldExpanded,
            questId
        )
    end
end
function TaskUI.prototype.toggleExpand(self, questId)
    local triggerPlayer = getTriggerPlayerOrLocal()
    self:toggleExpandSync(triggerPlayer, questId)
end
function TaskUI.prototype.changeCurrentPage(self, delta)
    local pageCount = self:getPageCount(self.currentCategory)
    if pageCount <= 1 then
        return
    end
    local currentPage = self.currentPage
    local nextPage = currentPage + delta
    if nextPage < 0 then
        nextPage = 0
    end
    if nextPage > pageCount - 1 then
        nextPage = pageCount - 1
    end
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
function TaskUI.prototype.togglePanelSync(self, player)
    if self.isVisible then
        self:hidePanelState()
        local localPlayer = jass.GetLocalPlayer()
        if player == localPlayer then
            self:hidePanelUI()
        end
    else
        self:showPanelState()
        local localPlayer = jass.GetLocalPlayer()
        if player == localPlayer then
            self:showPanelUI()
        end
    end
end
function TaskUI.prototype.togglePanel(self)
    local triggerPlayer = getTriggerPlayerOrLocal()
    self:togglePanelSync(triggerPlayer)
end
function TaskUI.prototype.showPanelState(self)
    self:resetToDefault()
    if self.pagesDirty then
        self:rebuildPages()
    end
    self.isVisible = true
end
function TaskUI.prototype.showPanelUI(self)
    if not self.mainPanel then
        return
    end
    showFrame(nil, self.mainPanel)
    self:showCurrentCategory()
end
function TaskUI.prototype.hidePanelState(self)
    self.isVisible = false
end
function TaskUI.prototype.hidePanelUI(self)
    if not self.mainPanel then
        return
    end
    if self.precreatedListPool then
        for ____, ct in ipairs({QuestType.MAIN, QuestType.SIDE, QuestType.DAILY}) do
            local cv = self.precreatedListPool.categories[ct]
            if cv ~= nil then
                japi.DzFrameShow(cv.root, false)
            end
        end
    end
    hideFrame(nil, self.mainPanel)
end
function TaskUI.prototype.getListControlContext(self)
    self:ensureUiContextCaches()
    local c = self.listCtxCache
    c.mainPanel = self.mainPanel
    c.listContainer = self.listContainer
    c.currentPlayerId = self.localPlayerId
    c.currentCategory = self.currentCategory
    c.precreatedListPool = self.precreatedListPool
    c.contextId = self.slotContextId
    return c
end
function TaskUI.prototype.getScrollContext(self)
    self:ensureUiContextCaches()
    local s = self.scrollCtxCache
    s.playerId = self.playerId
    s.mainPanel = self.mainPanel
    s.listContainer = self.listContainer
    s.scrollBarFrame = self.scrollBarFrame
    s.scrollBarHitBtn = self.scrollBarHitBtn
    s.scrollThumbFrame = self.scrollThumbFrame
    s.scrollThumbHitBtn = self.scrollThumbHitBtn
    s.taskListWheelRegistered = self.taskListWheelRegistered
    return s
end
__TS__SetDescriptor(
    TaskUI.prototype,
    "nameSuffix",
    {get = function(self)
        return "_s" .. tostring(self.slotId)
    end},
    true
)
__TS__SetDescriptor(
    TaskUI.prototype,
    "slotContextId",
    {get = function(self)
        return self.slotId * TAG_SLOT_OFFSET
    end},
    true
)
pcallInitTarget = nil
__togglePanelTriggerPlayer = nil
local function taskUIHotkeySwitchCategory(player, ____type)
    local ____temp_11
    if player ~= nil and player ~= 0 then
        ____temp_11 = jass.GetPlayerId(player)
    else
        ____temp_11 = -1
    end
    local pid = ____temp_11
    local ui = getTaskUIByPlayerId(pid)
    if ui then
        ui:switchCategorySync(player, ____type)
    end
end
--- 由 `00．玩家英雄获取桥接` 调用。
-- 所有客户端对称执行（全局创建），异步显隐。
function ____exports.onPlayerHeroRegistered(whichPlayer, _whichHero)
    return ____exports.initTaskUIForPlayer(whichPlayer)
end
function ____exports.initTaskUIForActivePlayers()
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    do
        local i = 0
        while i < MAX_PLAYERS do
            ____exports.initTaskUIForPlayer(jass.Player(i))
            i = i + 1
        end
    end
end
--- 热键注册：全局只注册一次
function ____exports.registerHotkey(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    if hotkeyRegistered then
        return
    end
    hotkeyRegistered = true
    registerTaskUIHotkeys(nil, {
        registerKeyUpSync = registerKeyUpSync,
        KEY = KEY,
        KEY_NUM = KEY_NUM,
        onTogglePanelSync = taskUIHotkeyTogglePanel,
        onSwitchCategorySync = taskUIHotkeySwitchCategory
    })
end
return ____exports
