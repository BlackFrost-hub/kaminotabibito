local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.01．任务UI常量")
local ENABLE_MOUSE_WHEEL_SCROLL = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_MOUSE_WHEEL_SCROLL
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local SCROLL_THUMB_SIZE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local THUMB_DRAG_TICK = ____01_FF0E_4EFB_52A1UI_5E38_91CF.THUMB_DRAG_TICK
local THUMB_DRAG_SENSITIVITY = ____01_FF0E_4EFB_52A1UI_5E38_91CF.THUMB_DRAG_SENSITIVITY
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.03．任务UI拆分.03．任务UI列表与滚动")
local isDescendantOfByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isDescendantOf
local isWheelTargetForTaskListByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isWheelTargetForTaskList
local computeNextScrollOffsetByWheel = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.computeNextScrollOffsetByWheel
local updateScrollBarVisibilityByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.updateScrollBarVisibility
local refreshTaskUIList = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.refreshTaskUIList
local ____04_FF0E_4EFB_52A1UI_6E32_67D3 = require("系统.08．任务系统.03．任务UI拆分.04．任务UI渲染")
local renderQuestRow = ____04_FF0E_4EFB_52A1UI_6E32_67D3.renderQuestRow
local ____05_FF0E_4EFB_52A1UI_6784_5EFA_4E0E_70ED_952E = require("系统.08．任务系统.03．任务UI拆分.05．任务UI构建与热键")
local registerTaskUIHotkeys = ____05_FF0E_4EFB_52A1UI_6784_5EFA_4E0E_70ED_952E.registerTaskUIHotkeys
local buildTaskMainPanel = ____05_FF0E_4EFB_52A1UI_6784_5EFA_4E0E_70ED_952E.buildTaskMainPanel
local buildTaskEntryIcon = ____05_FF0E_4EFB_52A1UI_6784_5EFA_4E0E_70ED_952E.buildTaskEntryIcon
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local getGameUI = ____04_FF0E_786C_4EF6_51FD_6570.getGameUI
local registerKeyDown = ____04_FF0E_786C_4EF6_51FD_6570.registerKeyDown
local KEY = ____04_FF0E_786C_4EF6_51FD_6570.KEY
local KEY_NUM = ____04_FF0E_786C_4EF6_51FD_6570.KEY_NUM
local getWheelDelta = ____04_FF0E_786C_4EF6_51FD_6570.getWheelDelta
local getMouseFocus = ____04_FF0E_786C_4EF6_51FD_6570.getMouseFocus
local registerMouseWheel = ____04_FF0E_786C_4EF6_51FD_6570.registerMouseWheel
local ____01_FF0EUI_5DE5_5177 = require("系统.09．表现系统.01．UI工具")
local createFrame = ____01_FF0EUI_5DE5_5177.createFrame
local setFramePosition = ____01_FF0EUI_5DE5_5177.setFramePosition
local setFrameSize = ____01_FF0EUI_5DE5_5177.setFrameSize
local setFrameTexture = ____01_FF0EUI_5DE5_5177.setFrameTexture
local setButtonText = ____01_FF0EUI_5DE5_5177.setButtonText
local setFrameClickEvent = ____01_FF0EUI_5DE5_5177.setFrameClickEvent
local setFramePointRelative = ____01_FF0EUI_5DE5_5177.setFramePointRelative
local setFrameHoverEvents = ____01_FF0EUI_5DE5_5177.setFrameHoverEvents
local createTextLabel = ____01_FF0EUI_5DE5_5177.createTextLabel
local FrameType = ____01_FF0EUI_5DE5_5177.FrameType
local FramePoint = ____01_FF0EUI_5DE5_5177.FramePoint
local hideFrame = ____01_FF0EUI_5DE5_5177.hideFrame
local showFrame = ____01_FF0EUI_5DE5_5177.showFrame
local ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053 = require("系统.09．表现系统.02．垂直滚动条轨道")
local VerticalScrollbarTrack = ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053.VerticalScrollbarTrack
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____02_FF0E_97F3_6548_51FD_6570 = require("系统.00．核心系统.02．音效函数")
local SoundUI_ClickPlay = ____02_FF0E_97F3_6548_51FD_6570.SoundUI_ClickPlay
local ____06_FF0EUI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local applyDzTextFontAndAlignment = ____06_FF0EUI_51FD_6570.applyDzTextFontAndAlignment
local applyDzTextFontAndCenterAlignment = ____06_FF0EUI_51FD_6570.applyDzTextFontAndCenterAlignment
local createTabLabelTextOnBackdrop = ____06_FF0EUI_51FD_6570.createTabLabelTextOnBackdrop
local setupTransparentGlueHitLayer = ____06_FF0EUI_51FD_6570.setupTransparentGlueHitLayer
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
    questManager:registerUIRefreshCallback(function(____, _playerId, _questId)
        pcall(function ()
                if type(jass.GetLocalPlayer) ~= "function" then
                    return
                end
                local lp = jass.GetLocalPlayer()
                if lp == nil then
                    return
                end
                if not self.isVisible then
                    return
                end
                self:refreshList()
            end
        )
    end)
end
function TaskUI.prototype.isDescendantOf(self, frame, ancestor)
    return isDescendantOfByJapi(nil, japi, frame, ancestor)
end
function TaskUI.prototype.isWheelTargetForTaskList(self)
    if not self.mainPanel then
        return false
    end
    return isWheelTargetForTaskListByJapi(
        nil,
        japi,
        type(getMouseFocus) == "function" and getMouseFocus or nil,
        self.listContainer,
        self.scrollBarFrame,
        self.scrollThumbFrame,
        self.scrollThumbHitBtn
    )
end
function TaskUI.prototype.registerTaskListWheel(self)
    if not ENABLE_MOUSE_WHEEL_SCROLL then
        return
    end
    if self.taskListWheelTrig then
        return
    end
    self.taskListWheelTrig = registerMouseWheel(
        nil,
        false,
        function()
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    if not self.isVisible then
                        return
                    end
                    if not self:isWheelTargetForTaskList() then
                        return
                    end
                    self:onListWheel()
                end
            )
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
    local next = computeNextScrollOffsetByWheel(
        nil,
        type(getWheelDelta) == "function" and getWheelDelta or nil,
        self.scrollOffset,
        self.totalContentHeight,
        LIST_VIEW_H
    )
    if next == self.scrollOffset then
        return
    end
    self.scrollOffset = next
    self:refreshList()
end
function TaskUI.prototype.setupThumbDrag(self)
    if not self.scrollThumbFrame or self.scrollThumbFrame == 0 or not self.mainPanel or not self.scrollBarFrame then
        return
    end
    local ____opt_2 = self.vScrollTrack
    if ____opt_2 ~= nil then
        ____opt_2:destroy()
    end
    self.vScrollTrack = __TS__New(
        VerticalScrollbarTrack,
        {
            trackFrame = self.scrollBarFrame,
            thumbFrame = self.scrollThumbFrame,
            hitButtonName = "TaskScrollThumbHit",
            listViewHeightNorm = LIST_VIEW_H,
            trackHeightNorm = LIST_VIEW_H,
            thumbSizeNorm = SCROLL_THUMB_SIZE,
            topCompensation = SCROLL_THUMB_TOP_COMPENSATION,
            bottomCompensation = SCROLL_THUMB_BOTTOM_COMPENSATION,
            dragTick = THUMB_DRAG_TICK,
            sensitivity = THUMB_DRAG_SENSITIVITY,
            getTotalContentHeight = function() return self.totalContentHeight end,
            getScrollOffset = function() return self.scrollOffset end,
            setScrollOffset = function(____, v)
                self.scrollOffset = v
            end,
            isInteractionEnabled = function() return self.isVisible end,
            onScrollChanged = function()
                self:refreshList()
            end,
            skipManualThumbSync = function() return false end
        }
    )
    self.vScrollTrack:attach()
    self.scrollThumbHitBtn = self.vScrollTrack:getHitButtonFrame()
end
function TaskUI.prototype.syncScrollThumb(self, maxScroll)
    if not self.vScrollTrack then
        return
    end
    self.vScrollTrack:syncThumbVisual(maxScroll)
end
function TaskUI.prototype.updateScrollBarVisibility(self, maxScroll)
    updateScrollBarVisibilityByJapi(nil, japi, maxScroll, {self.scrollBarFrame, self.scrollThumbFrame, self.scrollThumbHitBtn})
end
function TaskUI.prototype.clearList(self)
    for ____, f in ipairs(self.listItemFrames) do
        if type(japi.DzFrameShow) == "function" then
            japi.DzFrameShow(f, false)
        end
    end
    if type(japi.DzFrameShow) == "function" then
        for ____, f in __TS__Iterator(self.rowBackdropByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(self.titleByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(self.clickBtnByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(self.objFrameByKey:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(self.failFrameByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
        for ____, f in __TS__Iterator(self.rowIconByQuestId:values()) do
            if f ~= 0 then
                japi.DzFrameShow(f, false)
            end
        end
    end
    self.listItemFrames = {}
end
function TaskUI.prototype.showTabTooltip(self, msg)
    if type(japi.DzGetTriggerUIEventPlayer) ~= "function" or type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    local p = japi.DzGetTriggerUIEventPlayer()
    if p then
        jass.DisplayTextToPlayer(p, 0, 0, msg)
    end
end
function TaskUI.prototype.switchCategory(self, ____type)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            self.currentCategory = ____type
            self.expandedQuestIds:clear()
            self.scrollOffset = 0
            self:refreshList()
        end
    )
end
function TaskUI.prototype.toggleExpand(self, questId)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if self.expandedQuestIds:has(questId) then
                self.expandedQuestIds:delete(questId)
            else
                self.expandedQuestIds:add(questId)
            end
            self:refreshList()
        end
    )
end
function TaskUI.prototype.refreshList(self)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not self.mainPanel or not self.listContainer then
                return
            end
            self:clearList()
            refreshTaskUIList(
                nil,
                {
                    currentPlayerId = self.currentPlayerId,
                    currentCategory = self.currentCategory,
                    scrollOffset = self.scrollOffset,
                    setScrollOffset = function(____, v)
                        self.scrollOffset = v
                    end,
                    setTotalContentHeight = function(____, v)
                        self.totalContentHeight = v
                    end,
                    listContainer = self.listContainer,
                    expandedQuestIds = self.expandedQuestIds,
                    createTextLabel = createTextLabel,
                    FramePoint = FramePoint,
                    applyDzTextFontAndCenterAlignment = applyDzTextFontAndCenterAlignment,
                    pushListItemFrame = function(____, f)
                        local ____self_listItemFrames_4 = self.listItemFrames
                        local ____temp_5 = #____self_listItemFrames_4 + 1
                        ____self_listItemFrames_4[____temp_5] = f
                        return ____temp_5
                    end,
                    syncScrollThumb = function(____, maxScroll) return self:syncScrollThumb(maxScroll) end,
                    updateScrollBarVisibility = function(____, maxScroll) return self:updateScrollBarVisibility(maxScroll) end,
                    createListItem = function(____, quest, rowTopRel, expanded) return self:createListItem(quest, rowTopRel, expanded) end
                }
            )
        end
    )
end
function TaskUI.prototype.createListItem(self, quest, rowTopRel, expanded)
    local listParent = self.listContainer
    if not self.mainPanel or not listParent then
        return nil
    end
    local ok = renderQuestRow(
        nil,
        {
            japi = japi,
            quest = quest,
            rowTopRel = rowTopRel,
            expanded = expanded,
            listParent = listParent,
            FrameType = FrameType,
            FramePoint = FramePoint,
            createFrame = createFrame,
            createTextLabel = createTextLabel,
            setFrameTexture = setFrameTexture,
            setFramePointRelative = setFramePointRelative,
            setFrameSize = setFrameSize,
            setFrameClickEvent = setFrameClickEvent,
            showFrame = showFrame,
            applyDzTextFontAndAlignment = applyDzTextFontAndAlignment,
            onToggleExpand = function(____, questId) return self:toggleExpand(questId) end,
            onClickSound = function() return SoundUI_ClickPlay(nil) end,
            rowBackdropByQuestId = self.rowBackdropByQuestId,
            titleByQuestId = self.titleByQuestId,
            clickBtnByQuestId = self.clickBtnByQuestId,
            objFrameByKey = self.objFrameByKey,
            failFrameByQuestId = self.failFrameByQuestId,
            rowIconByQuestId = self.rowIconByQuestId,
            listItemFrames = self.listItemFrames
        }
    )
    if not ok then
        return nil
    end
    return 0
end
function TaskUI.prototype.togglePanel(self)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            self.isVisible = not self.isVisible
            if self.isVisible then
                self:show(self.currentPlayerId)
            else
                self:hide()
            end
        end
    )
end
function TaskUI.prototype.show(self, playerId)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not self.mainPanel then
                return
            end
            self.currentPlayerId = playerId
            self.isVisible = true
            showFrame(nil, self.mainPanel)
            self:refreshList()
        end
    )
end
function TaskUI.prototype.hide(self)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
            if not self.mainPanel then
                return
            end
            local ____opt_6 = self.vScrollTrack
            if ____opt_6 ~= nil then
                ____opt_6:cancelDrag()
            end
            self.isVisible = false
            hideFrame(nil, self.mainPanel)
        end
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
____exports.taskUI = __TS__New(TaskUI)
function ____exports.init(self)
    ____exports.taskUI:init()
end
function ____exports.registerHotkey(self)
    ____exports.taskUI:registerHotkey()
end
return ____exports
