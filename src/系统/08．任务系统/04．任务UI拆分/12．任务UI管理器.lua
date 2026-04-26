local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local applyTaskUIFacadeVisibleState = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.applyTaskUIFacadeVisibleState
local getTaskUICategoryPageCount = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.getTaskUICategoryPageCount
local setTaskRowHandlers = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.setTaskRowHandlers
local ____13_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA = require("系统.08．任务系统.04．任务UI拆分.13．任务UI预设构建")
local createTaskUIPrecreatedListPool = ____13_FF0E_4EFB_52A1UI_9884_8BBE_6784_5EFA.createTaskUIPrecreatedListPool
local ____14_FF0E_4EFB_52A1UI_5185_5BB9_540C_6B65 = require("系统.08．任务系统.04．任务UI拆分.14．任务UI内容同步")
local rebuildTaskUIFacadeListPool = ____14_FF0E_4EFB_52A1UI_5185_5BB9_540C_6B65.rebuildTaskUIFacadeListPool
local ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A = require("系统.08．任务系统.04．任务UI拆分.15．任务UI本地显示")
local switchCategoryLocal = ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A.switchCategoryLocal
local toggleExpandLocal = ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A.toggleExpandLocal
local switchPageLocal = ____15_FF0E_4EFB_52A1UI_672C_5730_663E_793A.switchPageLocal
local ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E = require("系统.08．任务系统.04．任务UI拆分.10．任务UI滚动与滚轮")
local registerTaskUIListWheel = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.registerTaskUIListWheel
local updateTaskUIScrollBarVisibility = ____10_FF0E_4EFB_52A1UI_6EDA_52A8_4E0E_6EDA_8F6E.updateTaskUIScrollBarVisibility
local ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI面板控制")
local registerTaskUIRefreshCallback = ____11_FF0E_4EFB_52A1UI_9762_677F_63A7_5236.registerTaskUIRefreshCallback
local ____16_FF0E_4EFB_52A1UI_8F93_5165_7ED1_5B9A = require("系统.08．任务系统.04．任务UI拆分.16．任务UI输入绑定")
local registerTaskUIHotkeys = ____16_FF0E_4EFB_52A1UI_8F93_5165_7ED1_5B9A.registerTaskUIHotkeys
local ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807 = require("系统.08．任务系统.04．任务UI拆分.06．任务UI入口图标")
local buildTaskEntryIcon = ____06_FF0E_4EFB_52A1UI_5165_53E3_56FE_6807.buildTaskEntryIcon
local ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.08．任务UI主面板与滚动")
local buildTaskMainPanel = ____08_FF0E_4EFB_52A1UI_4E3B_9762_677F_4E0E_6EDA_52A8.buildTaskMainPanel
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____index.getGameUI
local registerKeyUpLocal = ____index.registerKeyUpLocal
local KEY = ____index.KEY
local KEY_NUM = ____index.KEY_NUM
local getMouseFocus = ____index.getMouseFocus
local getWheelDelta = ____index.getWheelDelta
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
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local SoundUI_ClickPlay = ____index.SoundUI_ClickPlay
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local applyDzTextFontAndAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndAlignment
local applyDzTextFontAndCenterAlignment = ____03_FF0EUI_51FD_6570.applyDzTextFontAndCenterAlignment
local createTabLabelTextOnBackdrop = ____03_FF0EUI_51FD_6570.createTabLabelTextOnBackdrop
local setupTransparentGlueHitLayer = ____03_FF0EUI_51FD_6570.setupTransparentGlueHitLayer
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENABLE_TASK_UI_CLIENT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_CLIENT
--- 12．任务UI管理器
-- 职责：TaskUI 生命周期、持有引用、协调内容更新与本地显示控制。
local jass = require("jass.common")
local japi = require("jass.japi")
local mgr = nil
local function dispatchTogglePanel(self)
    if mgr then
        mgr:togglePanel()
    end
end
local function dispatchRefresh(self)
    if mgr then
        mgr:rebuildPages()
    end
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
end
function TaskUI.prototype.init(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    mgr = self
    pcall(function ()
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
            registerTaskUIRefreshCallback(nil, dispatchRefresh)
            self:hidePanel()
        end
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
            onClickSound = function() return self:playLocalClickSound() end,
            onTogglePanel = dispatchTogglePanel
        }
    )
    self.entryFrame = res.entryFrame
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
            onClickSound = function() return self:playLocalClickSound() end,
            onSwitchCategory = function(____, ____type) return self:switchCategory(____type) end,
            onShowTabTooltip = function()
            end
        }
    )
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
    setTaskRowHandlers(
        nil,
        function(____, questId) return self:toggleExpand(questId) end,
        function() return self:playLocalClickSound() end
    )
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
    local ____temp_0
    if type(jass.GetPlayerId) == "function" then
        ____temp_0 = jass.GetPlayerId(lp)
    else
        ____temp_0 = -1
    end
    local pid = ____temp_0
    return pid < 0 and 0 or pid
end
function TaskUI.prototype.playLocalClickSound(self)
    SoundUI_ClickPlay(nil, nil, self.localPlayer)
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
function TaskUI.prototype.switchCategory(self, ____type)
    if not self.isVisible then
        return
    end
    if self.currentCategory == ____type then
        return
    end
    local old = self.currentCategory
    self.currentCategory = ____type
    self.currentPage = 0
    self.expandedQuestId = nil
    switchCategoryLocal(nil, self.precreatedListPool, old, ____type)
    local pc = self:getPageCount(____type)
    updateTaskUIScrollBarVisibility(
        nil,
        self:getScrollContext(),
        pc,
        pc > 0
    )
end
function TaskUI.prototype.toggleExpand(self, questId)
    local oldExpanded = self.expandedQuestId
    local ____temp_1
    if oldExpanded == questId then
        ____temp_1 = nil
    else
        ____temp_1 = questId
    end
    self.expandedQuestId = ____temp_1
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
    return {
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
        playClickSound = function() return self:playLocalClickSound() end,
        updateScrollBarVisibility = function(____, pageCount, hasQuestRows) return updateTaskUIScrollBarVisibility(
            nil,
            self:getScrollContext(),
            pageCount,
            hasQuestRows
        ) end,
        toggleExpand = function(____, questId) return self:toggleExpand(questId) end,
        getCurrentPage = function(____, ____type) return ____type == self.currentCategory and self.currentPage or 0 end,
        setCurrentPage = function(____, ____type, page)
            if ____type == self.currentCategory then
                self.currentPage = page
            end
        end,
        getExpandedQuestId = function(____, ____type)
            local ____temp_2
            if ____type == self.currentCategory then
                ____temp_2 = self.expandedQuestId
            else
                ____temp_2 = nil
            end
            return ____temp_2
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
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        taskListWheelTrig = self.taskListWheelTrig,
        getMouseFocus = getMouseFocus,
        getWheelDelta = getWheelDelta,
        registerMouseWheel = registerMouseWheel,
        isVisible = function() return self.isVisible end,
        getCurrentPageCount = function() return self:getPageCount(self.currentCategory) end,
        getCurrentPage = function() return self.currentPage end,
        setCurrentPage = function(____, p)
            self.currentPage = p
        end,
        onPageChanged = function(____, prev, next)
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
    }
end
local taskUI = __TS__New(TaskUI)
____exports.taskUI = taskUI
function ____exports.init(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    taskUI:init()
end
function ____exports.registerHotkey(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    registerTaskUIHotkeys(
        nil,
        {
            registerKeyUpLocal = registerKeyUpLocal,
            KEY = KEY,
            KEY_NUM = KEY_NUM,
            onClickSound = function() return taskUI:playLocalClickSound() end,
            onTogglePanelLocal = function() return taskUI:togglePanel() end,
            onSwitchCategoryLocal = function(____, ____type) return taskUI:switchCategory(____type) end
        }
    )
end
return ____exports
