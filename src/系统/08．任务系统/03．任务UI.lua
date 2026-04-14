local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local ____exports = {}
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local refreshTaskUIFacadeList = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.refreshTaskUIFacadeList
local createTaskUIListItem = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.createTaskUIListItem
local clearTaskUIList = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.clearTaskUIList
local ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E = require("系统.08．任务系统.04．任务UI拆分.10．任务UI滚动与滚轮")
local registerTaskUIListWheel = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.registerTaskUIListWheel
local handleTaskUIListWheel = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.handleTaskUIListWheel
local syncTaskUIScrollThumb = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.syncTaskUIScrollThumb
local updateTaskUIScrollBarVisibility = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.updateTaskUIScrollBarVisibility
local ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI面板控制")
local registerTaskUIRefreshCallback = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.registerTaskUIRefreshCallback
local showTaskUITabTooltip = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.showTaskUITabTooltip
local switchTaskUICategory = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.switchTaskUICategory
local toggleTaskUIPanel = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.toggleTaskUIPanel
local showTaskUIPanel = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.showTaskUIPanel
local hideTaskUIPanel = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.hideTaskUIPanel
local ____05_FF0E_4EFB_52A1UI_70ED_952E = require("系统.08．任务系统.04．任务UI拆分.05．任务UI热键")
local registerTaskUIHotkeys = ____05_FF0E_4EFB_52A1UI_70ED_952E.registerTaskUIHotkeys
local ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807 = require("系统.08．任务系统.04．任务UI拆分.06．任务UI入口图标")
local buildTaskEntryIcon = ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807.buildTaskEntryIcon
local ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.08．任务UI主面板与滚动")
local buildTaskMainPanel = ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8.buildTaskMainPanel
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____index.getGameUI
local registerKeyDown = ____index.registerKeyDown
local KEY = ____index.KEY
local KEY_NUM = ____index.KEY_NUM
local getWheelDelta = ____index.getWheelDelta
local getMouseFocus = ____index.getMouseFocus
local registerMouseWheel = ____index.registerMouseWheel
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
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local questManager = ____index.questManager
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local SoundUI_ClickPlay = ____index.SoundUI_ClickPlay
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local applyDzTextFontAndAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndAlignment
local applyDzTextFontAndCenterAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndCenterAlignment
local createTabLabelTextOnBackdrop = ____03_FF0EUI_51FD_6570.createTabLabelTextOnBackdrop
local setupTransparentGlueHitLayer = ____03_FF0EUI_51FD_6570.setupTransparentGlueHitLayer
--- 任务系统 - 全新任务 UI（魔兽原生风格）
-- 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
-- listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
local jass = require("jass.common")
local japi = require("jass.japi")
local TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self)
    self.entryFrame = nil
    self.entryText = nil
    self.mainPanel = nil
    self.listContainer = nil
    self.tabMain = nil
    self.tabSide = nil
    self.tabDaily = nil
    self.tabMainBg = nil
    self.tabSideBg = nil
    self.tabDailyBg = nil
    self.currentCategory = QuestType.MAIN
    self.listItemFrames = {}
    self.scrollBarFrame = nil
    self.scrollThumbFrame = nil
    self.scrollThumbHitBtn = nil
    self.vScrollTrack = nil
    self.taskListWheelTrig = nil
    self.scrollOffset = 0
    self.totalContentHeight = 0
    self.expandedQuestIds = __TS__New(Set)
    self.isVisible = false
    self.currentPlayerId = 0
    self.rowBackdropByQuestId = __TS__New(Map)
    self.titleByQuestId = __TS__New(Map)
    self.clickBtnByQuestId = __TS__New(Map)
    self.objFrameByKey = __TS__New(Map)
    self.failFrameByQuestId = __TS__New(Map)
    self.rowIconByQuestId = __TS__New(Map)
end
function TaskUI.prototype.init(self)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            local gameUI = getGameUI(nil)
            if not gameUI then
                return
            end
            self:createEntryIcon(gameUI)
            self:createMainPanel(gameUI)
            self:registerTaskListWheel()
            self:registerRefreshCallback()
            self:hide()
        end
    )
end
function TaskUI.prototype.registerRefreshCallback(self)
    registerTaskUIRefreshCallback(
        nil,
        self:getPanelControlContext(),
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.registerTaskListWheel(self)
    self.taskListWheelTrig = registerTaskUIListWheel(
        nil,
        self:getScrollContext(),
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.createEntryIcon(self, parent)
    local res = buildTaskEntryIcon(
        nil,
        {
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
            onClickSound = function() return SoundUI_ClickPlay(nil) end,
            onTogglePanel = function() return self:togglePanel() end
        }
    )
    self.entryFrame = res.entryFrame
    self.entryText = res.entryText
end
function TaskUI.prototype.createMainPanel(self, parent)
    local res = buildTaskMainPanel(
        nil,
        {
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
            onClickSound = function() return SoundUI_ClickPlay(nil) end,
            onSwitchCategory = function(____, ____type) return self:switchCategory(____type) end,
            onShowTabTooltip = function(____, msg) return self:showTabTooltip(msg) end,
            getTotalContentHeight = function() return self.totalContentHeight end,
            getScrollOffset = function() return self.scrollOffset end,
            setScrollOffset = function(____, v)
                self.scrollOffset = v
            end,
            isVisible = function() return self.isVisible end,
            onScrollChanged = function() return self:refreshList() end
        }
    )
    self.mainPanel = res.mainPanel
    self.listContainer = res.listContainer
    self.tabMainBg = res.tabMainBg
    self.tabMain = res.tabMain
    self.tabSideBg = res.tabSideBg
    self.tabSide = res.tabSide
    self.tabDailyBg = res.tabDailyBg
    self.tabDaily = res.tabDaily
    self.scrollBarFrame = res.scrollBarFrame
    self.scrollThumbFrame = res.scrollThumbFrame
    self.scrollThumbHitBtn = res.scrollThumbHitBtn
    local ____opt_0 = self.vScrollTrack
    if ____opt_0 ~= nil then
        ____opt_0:destroy()
    end
    self.vScrollTrack = res.vScrollTrack
end
function TaskUI.prototype.onListWheel(self)
    handleTaskUIListWheel(
        nil,
        self:getScrollContext(),
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.syncScrollThumb(self, maxScroll)
    syncTaskUIScrollThumb(
        nil,
        self:getScrollContext(),
        maxScroll
    )
end
function TaskUI.prototype.updateScrollBarVisibility(self, maxScroll, hasQuestRows)
    updateTaskUIScrollBarVisibility(
        nil,
        self:getScrollContext(),
        maxScroll,
        hasQuestRows
    )
end
function TaskUI.prototype.clearList(self)
    clearTaskUIList(
        nil,
        self:getListControlContext()
    )
end
function TaskUI.prototype.showTabTooltip(self, msg)
    showTaskUITabTooltip(nil, msg)
end
function TaskUI.prototype.switchCategory(self, ____type)
    switchTaskUICategory(
        nil,
        self:getPanelControlContext(),
        ____type,
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.toggleExpand(self, questId)
    local ctx = self:getListControlContext()
    if ctx.expandedQuestIds:has(questId) then
        ctx.expandedQuestIds:delete(questId)
    else
        ctx.expandedQuestIds:add(questId)
    end
    self:refreshList()
end
function TaskUI.prototype.refreshList(self)
    refreshTaskUIFacadeList(
        nil,
        self:getListControlContext(),
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.createListItem(self, quest, rowTopRel, expanded)
    return createTaskUIListItem(
        nil,
        self:getListControlContext(),
        quest,
        rowTopRel,
        expanded,
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.togglePanel(self)
    toggleTaskUIPanel(
        nil,
        self:getPanelControlContext(),
        function(____, playerId) return self:show(playerId) end,
        function() return self:hide() end
    )
end
function TaskUI.prototype.show(self, playerId)
    showTaskUIPanel(
        nil,
        self:getPanelControlContext(),
        playerId,
        function() return self:refreshList() end
    )
end
function TaskUI.prototype.hide(self)
    hideTaskUIPanel(
        nil,
        self:getPanelControlContext()
    )
end
function TaskUI.prototype.registerHotkey(self)
    registerTaskUIHotkeys(
        nil,
        {
            registerKeyDown = registerKeyDown,
            KEY = KEY,
            KEY_NUM = KEY_NUM,
            onClickSound = function() return SoundUI_ClickPlay(nil) end,
            onTogglePanel = function() return self:togglePanel() end,
            onSwitchCategory = function(____, ____type) return self:switchCategory(____type) end,
            isVisible = function() return self.isVisible end,
            setCurrentPlayerId = function(____, pid)
                self.currentPlayerId = pid
            end
        }
    )
end
function TaskUI.prototype.getListControlContext(self)
    return {
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        currentPlayerId = self.currentPlayerId,
        currentCategory = self.currentCategory,
        expandedQuestIds = self.expandedQuestIds,
        listItemFrames = self.listItemFrames,
        rowBackdropByQuestId = self.rowBackdropByQuestId,
        titleByQuestId = self.titleByQuestId,
        clickBtnByQuestId = self.clickBtnByQuestId,
        objFrameByKey = self.objFrameByKey,
        failFrameByQuestId = self.failFrameByQuestId,
        rowIconByQuestId = self.rowIconByQuestId,
        createTextLabel = createTextLabel,
        FramePoint = FramePoint,
        FrameType = FrameType,
        createFrame = createFrame,
        setFrameTexture = setFrameTexture,
        setFramePointRelative = setFramePointRelative,
        setFrameSize = setFrameSize,
        setFrameClickEvent = setFrameClickEvent,
        showFrame = showFrame,
        applyDzTextFontAndCenterAlignment = applyDzTextFontAndCenterAlignment,
        applyDzTextFontAndAlignment = applyDzTextFontAndAlignment,
        syncScrollThumb = function(____, maxScroll) return self:syncScrollThumb(maxScroll) end,
        updateScrollBarVisibility = function(____, maxScroll, hasQuestRows) return self:updateScrollBarVisibility(maxScroll, hasQuestRows) end,
        toggleExpand = function(____, questId) return self:toggleExpand(questId) end,
        getScrollOffset = function() return self.scrollOffset end,
        setScrollOffset = function(____, v)
            self.scrollOffset = v
        end,
        getTotalContentHeight = function() return self.totalContentHeight end,
        setTotalContentHeight = function(____, v)
            self.totalContentHeight = v
        end
    }
end
function TaskUI.prototype.getScrollContext(self)
    return {
        mainPanel = self.mainPanel,
        listContainer = self.listContainer,
        scrollBarFrame = self.scrollBarFrame,
        scrollThumbFrame = self.scrollThumbFrame,
        scrollThumbHitBtn = self.scrollThumbHitBtn,
        taskListWheelTrig = self.taskListWheelTrig,
        getMouseFocus = type(getMouseFocus) == "function" and getMouseFocus or nil,
        getWheelDelta = type(getWheelDelta) == "function" and getWheelDelta or nil,
        registerMouseWheel = registerMouseWheel,
        vScrollTrack = self.vScrollTrack,
        isVisible = function() return self.isVisible end,
        getScrollOffset = function() return self.scrollOffset end,
        setScrollOffset = function(____, v)
            self.scrollOffset = v
        end,
        getTotalContentHeight = function() return self.totalContentHeight end
    }
end
function TaskUI.prototype.getPanelControlContext(self)
    return {
        mainPanel = self.mainPanel,
        expandedQuestIds = self.expandedQuestIds,
        vScrollTrack = self.vScrollTrack,
        showFrame = showFrame,
        hideFrame = hideFrame,
        questManager = questManager,
        getCurrentCategory = function() return self.currentCategory end,
        setCurrentCategory = function(____, ____type)
            self.currentCategory = ____type
        end,
        getScrollOffset = function() return self.scrollOffset end,
        setScrollOffset = function(____, v)
            self.scrollOffset = v
        end,
        isVisible = function() return self.isVisible end,
        setVisible = function(____, v)
            self.isVisible = v
        end,
        getCurrentPlayerId = function() return self.currentPlayerId end,
        setCurrentPlayerId = function(____, v)
            self.currentPlayerId = v
        end
    }
end
____exports.taskUI = __TS__New(TaskUI)
function ____exports.init(self)
    ____exports.taskUI:init()
end
function ____exports.registerHotkey(self)
    ____exports.taskUI:registerHotkey()
end
return ____exports
