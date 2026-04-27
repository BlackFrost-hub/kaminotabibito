local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local taskUIInitPcallBody, taskUITogglePanelPcallBody, taskUIHotkeyTogglePanel, onQuestManagerUiRefresh, jass, taskUIs, refreshCallbackRegistered, pcallInitTarget, __togglePanelTriggerPlayer
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
local MAX_PLAYERS = ____01_FF0E_4EFB_52A1UI_5E38_91CF.MAX_PLAYERS
local TAG_SLOT_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAG_SLOT_OFFSET
function taskUIInitPcallBody(self)
    if pcallInitTarget ~= nil then
        pcallInitTarget:runInitBodyInPcall()
    end
end
function taskUITogglePanelPcallBody(self)
    local player = __togglePanelTriggerPlayer
    local ____temp_13
    if player ~= nil and player ~= 0 then
        ____temp_13 = jass:GetPlayerId(player)
    else
        ____temp_13 = -1
    end
    local pid = ____temp_13
    if pid >= 0 and pid < #taskUIs then
        local ____opt_14 = taskUIs[pid]
        if ____opt_14 ~= nil then
            ____opt_14:togglePanelSync(player)
        end
    end
end
function taskUIHotkeyTogglePanel(self, player)
    __togglePanelTriggerPlayer = player
    pcall(taskUITogglePanelPcallBody)
end
function onQuestManagerUiRefresh(self, _playerId, _questId)
    do
        local i = 0
        while i < #taskUIs do
            do
                local ui = taskUIs[i + 1]
                if ui == nil or not ui.uiInitialized then
                    goto __continue100
                end
                ui.pagesDirty = true
                if ui.isVisible then
                    ui:rebuildPages()
                end
            end
            ::__continue100::
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
        ____temp_0 = japi:DzGetTriggerKeyPlayer()
    else
        ____temp_0 = nil
    end
    local tp = ____temp_0
    if tp == nil or tp == 0 then
        return -1
    end
    local pid = jass:GetPlayerId(tp)
    return type(pid) == "number" and pid >= 0 and pid < MAX_PLAYERS and pid or -1
end
local function taskUIModulePlayClickSound(self)
    local lp = jass:GetLocalPlayer()
    local pid = jass:GetPlayerId(lp)
    if pid >= 0 and pid < #taskUIs then
        local ____opt_1 = taskUIs[pid]
        if ____opt_1 ~= nil then
            ____opt_1:playLocalClickSound()
        end
    end
end
local function taskUIModuleRowExpand(self, questId)
    local pid = getTriggerPlayerId(nil)
    if pid >= 0 and pid < #taskUIs then
        local ____opt_3 = taskUIs[pid + 1]
        if ____opt_3 ~= nil then
            ____opt_3:toggleExpandForRow(questId)
        end
    end
end
local function taskUIModuleSwitchCategory(self, ____type)
    local pid = getTriggerPlayerId(nil)
    if pid >= 0 and pid < #taskUIs then
        local ____opt_5 = taskUIs[pid + 1]
        if ____opt_5 ~= nil then
            ____opt_5:switchCategory(____type)
        end
    end
end
local function taskUIModuleNoopTabTooltip(self, _msg)
end
local TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self, slotId)
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
    self.slotId = slotId
    self.playerId = slotId
end
function TaskUI.prototype.ensureUiContextCaches(self)
    local ____self = self
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
        isVisible = function() return ____self.isVisible end,
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
        toggleExpand = function(____, questId)
            ____self:toggleExpandForRow(questId)
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
        return
    end
    if self.uiInitialized then
        return
    end
    taskUIs[playerId + 1] = self
    self.localPlayer = jass:Player(playerId)
    self.localPlayerId = playerId
    pcall(taskUIInitPcallBody)
end
function TaskUI.prototype.runInitBodyInPcall(self)
    local gameUI = getGameUI(nil)
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
        onTogglePanel = taskUIHotkeyTogglePanel,
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
        local localPlayer = jass:GetLocalPlayer()
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
    local ____temp_7
    if ____type == self.currentCategory then
        ____temp_7 = self.expandedQuestId
    else
        ____temp_7 = nil
    end
    return ____temp_7
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
    local localPlayer = jass:GetLocalPlayer()
    if player == localPlayer then
        self:switchCategoryUI(____type)
    end
end
function TaskUI.prototype.switchCategory(self, ____type)
    local triggerPlayer = japi:DzGetTriggerKeyPlayer()
    self:switchCategorySync(triggerPlayer, ____type)
end
function TaskUI.prototype.toggleExpandSync(self, player, questId)
    local oldExpanded = self.expandedQuestId
    local ____temp_8
    if oldExpanded == questId then
        ____temp_8 = nil
    else
        ____temp_8 = questId
    end
    self.expandedQuestId = ____temp_8
    local localPlayer = jass:GetLocalPlayer()
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
    local ____temp_9
    if japi.DzGetTriggerKeyPlayer ~= nil then
        ____temp_9 = japi:DzGetTriggerKeyPlayer()
    else
        ____temp_9 = jass:GetLocalPlayer()
    end
    local triggerPlayer = ____temp_9
    self:toggleExpandSync(triggerPlayer, questId)
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
function TaskUI.prototype.togglePanelSync(self, player)
    if self.isVisible then
        self:hidePanelState()
        local localPlayer = jass:GetLocalPlayer()
        if player == localPlayer then
            self:hidePanelUI()
        end
    else
        self:showPanelState()
        local localPlayer = jass:GetLocalPlayer()
        if player == localPlayer then
            self:showPanelUI()
        end
    end
end
function TaskUI.prototype.togglePanel(self)
    local ____temp_10
    if japi.DzGetTriggerKeyPlayer ~= nil then
        ____temp_10 = japi:DzGetTriggerKeyPlayer()
    else
        ____temp_10 = jass:GetLocalPlayer()
    end
    local triggerPlayer = ____temp_10
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
                japi:DzFrameShow(cv.root, false)
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
    s.mainPanel = self.mainPanel
    s.listContainer = self.listContainer
    s.scrollBarFrame = self.scrollBarFrame
    s.scrollThumbFrame = self.scrollThumbFrame
    s.scrollThumbHitBtn = self.scrollThumbHitBtn
    s.taskListWheelTrig = self.taskListWheelTrig
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
local function taskUIHotkeySwitchCategory(self, player, ____type)
    local ____temp_16
    if player ~= nil and player ~= 0 then
        ____temp_16 = jass:GetPlayerId(player)
    else
        ____temp_16 = -1
    end
    local pid = ____temp_16
    if pid >= 0 and pid < #taskUIs then
        local ____opt_17 = taskUIs[pid]
        if ____opt_17 ~= nil then
            ____opt_17:switchCategorySync(player, ____type)
        end
    end
end
--- 英雄注册回调：当玩家英雄注册时，为该玩家创建一套任务 UI。
-- 由 `00．玩家英雄获取桥接` 调用。
-- 所有客户端对称执行（全局创建），异步显隐。
function ____exports.onPlayerHeroRegistered(whichPlayer, _whichHero)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    if whichPlayer == nil or whichPlayer == 0 then
        return
    end
    local pid = jass:GetPlayerId(whichPlayer)
    if type(pid) ~= "number" or pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    if taskUIs[pid + 1] ~= nil then
        return
    end
    local ui = __TS__New(TaskUI, pid)
    pcallInitTarget = ui
    ui:init(pid)
    pcallInitTarget = nil
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
