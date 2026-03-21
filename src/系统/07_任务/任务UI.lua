local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local _____786C_4EF6_51FD_6570 = require("系统.00_核心.硬件函数")
local getGameUI = _____786C_4EF6_51FD_6570.getGameUI
local registerKeyDown = _____786C_4EF6_51FD_6570.registerKeyDown
local KEY_LETTER = _____786C_4EF6_51FD_6570.KEY_LETTER
local KEY_NUM = _____786C_4EF6_51FD_6570.KEY_NUM
local frameSetScriptByCode = _____786C_4EF6_51FD_6570.frameSetScriptByCode
local getWheelDelta = _____786C_4EF6_51FD_6570.getWheelDelta
local getMouseFocus = _____786C_4EF6_51FD_6570.getMouseFocus
local ____UI_5DE5_5177 = require("系统.表现.UI工具")
local createFrame = ____UI_5DE5_5177.createFrame
local setFramePosition = ____UI_5DE5_5177.setFramePosition
local setFrameSize = ____UI_5DE5_5177.setFrameSize
local setFrameTexture = ____UI_5DE5_5177.setFrameTexture
local setButtonText = ____UI_5DE5_5177.setButtonText
local setFrameClickEvent = ____UI_5DE5_5177.setFrameClickEvent
local setFramePointRelative = ____UI_5DE5_5177.setFramePointRelative
local setFrameHoverEvents = ____UI_5DE5_5177.setFrameHoverEvents
local createTextLabel = ____UI_5DE5_5177.createTextLabel
local loadTocOnce = ____UI_5DE5_5177.loadTocOnce
local tryCreateFromFdfSafe = ____UI_5DE5_5177.tryCreateFromFdfSafe
local FrameType = ____UI_5DE5_5177.FrameType
local FramePoint = ____UI_5DE5_5177.FramePoint
local EventType = ____UI_5DE5_5177.EventType
local hideFrame = ____UI_5DE5_5177.hideFrame
local showFrame = ____UI_5DE5_5177.showFrame
local _____5782_76F4_6EDA_52A8_6761_8F68_9053 = require("系统.表现.垂直滚动条轨道")
local VerticalScrollbarTrack = _____5782_76F4_6EDA_52A8_6761_8F68_9053.VerticalScrollbarTrack
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local questManager = _____4EFB_52A1_7BA1_7406_5668.questManager
local _____4EFB_52A1_6570_636E = require("系统.07_任务.任务数据")
local questDB = _____4EFB_52A1_6570_636E.questDB
local QuestType = _____4EFB_52A1_6570_636E.QuestType
local QuestStatus = _____4EFB_52A1_6570_636E.QuestStatus
local _____97F3_6548_51FD_6570 = require("系统.00_核心.音效函数")
local SoundUI_ClickPlay = _____97F3_6548_51FD_6570.SoundUI_ClickPlay
--- 任务系统 - 全新任务 UI（魔兽原生风格）
-- 入口图标 F9 下方，点击/P 展开，三标签：主线｜支线｜小任务
local jass = require("jass.common")
local japi = require("jass.japi")
local TASK_UI_TOC_PATHS = {"UI\\TaskUI.toc"}
local TASK_UI_TOC_LOAD_KEY = "TaskUI"
local ENABLE_FDF_A = true
local ENABLE_FDF_B = true
local ENABLE_FDF_SCROLLBAR = true
local ENABLE_FDF_SCROLLBAR_BORDER = false
local ENABLE_FDF_SCROLLBAR_THUMB = false
local USE_NATIVE_SCROLLBAR_TRACK = false
local ENABLE_SCROLL_INPUT = false
local ENABLE_WHEEL_OVERLAY = false
local ENABLE_MOUSE_WHEEL_SCROLL = true
local ENTRY_SIZE = 0.04
local ENTRY_X = 0.06
local ENTRY_Y = 0.51
local PANEL_W = 0.35
local PANEL_H = 0.5
local TAB_TEXT_Y_NUDGE = -0.01
local LIST_ITEM_H = 0.12
local BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp"
local BORDER_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-border.blp"
local PANEL_TOP = 0.46
local PANEL_TOP_UP = 0.015
local LIST_TOP = 0.41 + PANEL_TOP_UP - 0.04
local TAB_Y = 0.44
local TAB_REL_Y = TAB_Y - PANEL_TOP
local LIST_LEFT = 0.05 + 0.04
local LIST_RIGHT = 0.34
local LIST_BOTTOM = 0.01
local LIST_VIEW_H = LIST_TOP - LIST_BOTTOM - 0.04
local LIST_CONTAINER_W = 0.32
local SCROLLBAR_W = 0.015
--- 轨道相对主面板右缘横向偏移（负数向左）；原 -0.006，再左移 0.005 + 0.004
local SCROLLBAR_REL_X = -0.006 - 0.005 - 0.004
local SCROLL_THUMB_SIZE = 0.02
local SCROLL_THUMB_TOP_COMPENSATION = 0.016
local SCROLL_THUMB_BOTTOM_COMPENSATION = 0.017
--- 滑块拖拽：定时器间隔（秒）
local THUMB_DRAG_TICK = 0.03
--- 微调：1=与轨道像素行程 1:1（原先误用 wh*0.35 与 UI 0.6 坐标系不一致导致“跟手”差）
local THUMB_DRAG_SENSITIVITY = 1
local EMPTY_X = 0.2
local EMPTY_Y = 0.35
--- 主线任务 001/002 左侧图标（正方形 w=h）：相对「未展开」行高 LIST_ITEM_H*0.4，0.90=比该行高小10%
local QUEST_ROW_ICON_HEIGHT_FACTOR = 0.84
local QUEST_ROW_ICON_PAD_LEFT = 0.003
--- 图标右缘与标题文字之间的空隙
local QUEST_ROW_TEXT_GAP_AFTER_ICON = 0.006
--- 主线 01/02 左侧头像相对行顶 TOPLEFT 的纵向偏移（越大越往下，避免顶到行上边框）
local QUEST_ROW_ICON_MAIN0102_Y_OFFSET = 0.004
local function debugPrint(self, msg)
    local pr = _G.print
    if type(pr) == "function" then
        pr("[TaskUI] " .. msg)
    end
end
local function isFdfFrameEnabled(self, frameName)
    local isA = frameName == "TaskEntryIcon" or frameName == "TaskMainPanel" or frameName == "TaskListContainer"
    local isB = frameName == "TaskTabMain" or frameName == "TaskTabSide" or frameName == "TaskTabDaily" or frameName == "TaskButtonBackdrop" or frameName == "TaskTabMainBg" or frameName == "TaskTabSideBg" or frameName == "TaskTabDailyBg"
    if frameName == "TaskScrollBar" then
        return ENABLE_FDF_SCROLLBAR
    end
    if frameName == "TaskScrollBarBorder" then
        return ENABLE_FDF_SCROLLBAR_BORDER
    end
    if frameName == "TaskScrollThumb" then
        return ENABLE_FDF_SCROLLBAR_THUMB
    end
    if isA then
        return ENABLE_FDF_A
    end
    if isB then
        return ENABLE_FDF_B
    end
    return false
end
local function tryCreateFromFdf(self, name, parent, fallback)
    if not isFdfFrameEnabled(nil, name) then
        return fallback(nil)
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    return tryCreateFromFdfSafe(
        nil,
        name,
        parent,
        fallback,
        {tocLoadKey = TASK_UI_TOC_LOAD_KEY, tocPaths = TASK_UI_TOC_PATHS, debugPrefix = "TaskUI"}
    )
end
local function tryCreateFromFdfWithSource(self, name, parent, fallback)
    if not isFdfFrameEnabled(nil, name) then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    if type(japi.DzCreateFrame) ~= "function" then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(name, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return {frame = f, fromFdf = true}
    end
    return {
        frame = fallback(nil),
        fromFdf = false
    }
end
local function tryCreateFromFdfOnly(self, name, parent)
    local res = tryCreateFromFdfWithSource(
        nil,
        name,
        parent,
        function() return nil end
    )
    if res.fromFdf and res.frame and res.frame ~= 0 then
        debugPrint(nil, "FDF创建成功: " .. name)
        return res.frame
    end
    debugPrint(nil, "FDF创建失败: " .. name)
    return nil
end
local function getStatusText(self, status)
    local m = {
        [QuestStatus.IN_PROGRESS] = "|cff00ff66进行中|r",
        [QuestStatus.COMPLETED] = "|cffc0c0c0已完成|r",
        [QuestStatus.FAILED] = "|cffff5555已失败|r",
        [QuestStatus.DISCOVERED] = "|cff66ccff已发现|r",
        [QuestStatus.UNDISCOVERED] = "|cff888888未发现|r"
    }
    return m[status] or status
end
--- 获取任务列表（进行中 + 已完成，保留历史）
local function getQuestsForUI(self, playerId, ____type)
    local active = questManager:getPlayerQuests(playerId, ____type)
    local completedIds = questDB:getPlayerCompletedQuests(playerId)
    local result = __TS__ArraySlice(active)
    for ____, id in ipairs(completedIds) do
        do
            local __continue22
            repeat
                local template = questDB:getQuest(id)
                if not template or template.type ~= ____type then
                    __continue22 = true
                    break
                end
                if __TS__ArraySome(
                    active,
                    function(____, q) return q.id == id end
                ) then
                    __continue22 = true
                    break
                end
                result[#result + 1] = __TS__ObjectAssign(
                    {},
                    template,
                    {
                        status = QuestStatus.COMPLETED,
                        objectives = __TS__ArrayMap(
                            template.objectives,
                            function(____, o) return __TS__ObjectAssign({}, o, {completed = true, current = o.required}) end
                        )
                    }
                )
                __continue22 = true
            until true
            if not __continue22 then
                break
            end
        end
    end
    return result
end
local EMPTY_TEXTS = {[QuestType.MAIN] = "暂无主线任务", [QuestType.SIDE] = "暂无支线任务", [QuestType.DAILY] = "暂无小任务"}
local TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self)
    self.entryFrame = nil
    self.entryText = nil
    self.entryHint = nil
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
    self.scrollInputFrame = nil
    self.wheelOverlay = nil
    self.scrollOffset = 0
    self._updatingScrollBar = false
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
    local gameUI = getGameUI(nil)
    if not gameUI then
        debugPrint(nil, "无法获取游戏UI")
        return
    end
    self:createEntryIcon(gameUI)
    self:createMainPanel(gameUI)
    self:hide()
    debugPrint(nil, "任务UI初始化完成")
end
function TaskUI.prototype.createEntryIcon(self, parent)
    self.entryFrame = tryCreateFromFdfOnly(nil, "TaskEntryIcon", parent)
    if not self.entryFrame then
        return
    end
    setFramePosition(nil, self.entryFrame, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = ENTRY_Y})
    setFrameSize(nil, self.entryFrame, {width = ENTRY_SIZE, height = ENTRY_SIZE})
    self.entryText = createTextLabel(
        nil,
        "TaskEntryText",
        self.entryFrame,
        "|cffffcc00任务(J)|r",
        {
            relativeTo = self.entryFrame,
            point = FramePoint.CENTER,
            relativePoint = FramePoint.CENTER,
            x = 0,
            y = 0
        },
        {width = ENTRY_SIZE * 1, height = ENTRY_SIZE * 0.5}
    )
    self.entryHint = createTextLabel(
        nil,
        "TaskEntryHint",
        self.entryFrame,
        "|cff888888按J打开|r",
        {
            relativeTo = self.entryFrame,
            point = FramePoint.TOP,
            relativePoint = FramePoint.BOTTOM,
            x = 0,
            y = -0.005
        },
        {width = ENTRY_SIZE * 1, height = ENTRY_SIZE * 0.35}
    )
    local btn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "TaskEntryBtn",
        parent = self.entryFrame,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if btn and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(btn, self.entryFrame)
        setFrameClickEvent(
            nil,
            btn,
            function()
                SoundUI_ClickPlay(nil)
                self:togglePanel()
            end,
            false
        )
    end
end
function TaskUI.prototype.createMainPanel(self, parent)
    self.mainPanel = tryCreateFromFdfOnly(nil, "TaskMainPanel", parent)
    if not self.mainPanel then
        return
    end
    setFramePosition(nil, self.mainPanel, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = PANEL_TOP + PANEL_TOP_UP})
    setFrameSize(nil, self.mainPanel, {width = PANEL_W, height = PANEL_H})
    self.listContainer = tryCreateFromFdfOnly(nil, "TaskListContainer", self.mainPanel)
    if self.listContainer and type(japi.DzFrameShow) == "function" then
        pcall(function () return japi.DzFrameShow(self.listContainer, true) end
        )
    end
    local tabParent = self.mainPanel
    self.tabMainBg = tryCreateFromFdfOnly(nil, "TaskTabMainBg", tabParent)
    if self.tabMainBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabMainBg)
        end
        setFramePointRelative(
            nil,
            self.tabMainBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.02,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabMainBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMainBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMainBg, 7)
        end
    end
    self.tabMain = tryCreateFromFdfOnly(nil, "TaskTabMain", tabParent)
    if self.tabMain then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabMain)
        end
        setFramePointRelative(
            nil,
            self.tabMain,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.02,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabMain, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMain, true) end
            )
        end
        setButtonText(nil, self.tabMain, "|cffffcc00主线(1)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMain, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabMain,
            function()
                SoundUI_ClickPlay(nil)
                self:switchCategory(QuestType.MAIN)
            end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabMain,
            function() return self:showTabTooltip("按 1 切换主线任务") end,
            function()
            end,
            false
        )
    end
    self.tabSideBg = tryCreateFromFdfOnly(nil, "TaskTabSideBg", tabParent)
    if self.tabSideBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabSideBg)
        end
        setFramePointRelative(
            nil,
            self.tabSideBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.135,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabSideBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSideBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSideBg, 7)
        end
    end
    self.tabSide = tryCreateFromFdfOnly(nil, "TaskTabSide", tabParent)
    if self.tabSide then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabSide)
        end
        setFramePointRelative(
            nil,
            self.tabSide,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.135,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabSide, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSide, true) end
            )
        end
        setButtonText(nil, self.tabSide, "|cffffcc00支线(2)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSide, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabSide,
            function()
                SoundUI_ClickPlay(nil)
                self:switchCategory(QuestType.SIDE)
            end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabSide,
            function() return self:showTabTooltip("按 2 切换支线任务") end,
            function()
            end,
            false
        )
    end
    self.tabDailyBg = tryCreateFromFdfOnly(nil, "TaskTabDailyBg", tabParent)
    if self.tabDailyBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabDailyBg)
        end
        setFramePointRelative(
            nil,
            self.tabDailyBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.25,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabDailyBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDailyBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDailyBg, 7)
        end
    end
    self.tabDaily = tryCreateFromFdfOnly(nil, "TaskTabDaily", tabParent)
    if self.tabDaily then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabDaily)
        end
        setFramePointRelative(
            nil,
            self.tabDaily,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.25,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabDaily, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDaily, true) end
            )
        end
        setButtonText(nil, self.tabDaily, "|cffffcc00小任务(3)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDaily, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabDaily,
            function()
                SoundUI_ClickPlay(nil)
                self:switchCategory(QuestType.DAILY)
            end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabDaily,
            function() return self:showTabTooltip("按 3 切换小任务") end,
            function()
            end,
            false
        )
    end
    if self.mainPanel ~= nil then
        if not USE_NATIVE_SCROLLBAR_TRACK then
            local sbSrc = tryCreateFromFdfWithSource(
                nil,
                "TaskScrollBar",
                self.mainPanel,
                function()
                    local f = createFrame(nil, {
                        type = FrameType.BACKDROP,
                        name = "TaskScrollBarBtn",
                        parent = self.mainPanel,
                        template = "template",
                        visible = true
                    })
                    return f or 0
                end
            )
            self.scrollBarFrame = sbSrc.frame
            debugPrint(
                nil,
                (("scrollBar=" .. tostring(self.scrollBarFrame)) .. " fromFdf=") .. tostring(sbSrc.fromFdf)
            )
            if self.scrollBarFrame and self.scrollBarFrame ~= 0 and self.mainPanel then
                if type(japi.DzFrameShow) == "function" then
                    japi.DzFrameShow(self.scrollBarFrame, true)
                end
                if type(japi.DzFrameClearAllPoints) == "function" then
                    japi.DzFrameClearAllPoints(self.scrollBarFrame)
                end
                setFramePointRelative(
                    nil,
                    self.scrollBarFrame,
                    FramePoint.TOPRIGHT,
                    self.mainPanel,
                    FramePoint.TOPRIGHT,
                    SCROLLBAR_REL_X,
                    -0.08
                )
                setFramePointRelative(
                    nil,
                    self.scrollBarFrame,
                    FramePoint.BOTTOMRIGHT,
                    self.mainPanel,
                    FramePoint.BOTTOMRIGHT,
                    SCROLLBAR_REL_X,
                    0.03
                )
                setFrameSize(nil, self.scrollBarFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollBarFrame, 30)
                end
            end
            if ENABLE_FDF_SCROLLBAR_THUMB and self.mainPanel ~= nil then
                self.scrollThumbFrame = tryCreateFromFdfOnly(nil, "TaskScrollThumb", self.mainPanel)
                if self.scrollThumbFrame and self.scrollThumbFrame ~= 0 then
                    if type(japi.DzFrameShow) == "function" then
                        japi.DzFrameShow(self.scrollThumbFrame, true)
                    end
                    if type(japi.DzFrameSetLevel) == "function" then
                        japi.DzFrameSetLevel(self.scrollThumbFrame, 31)
                    end
                end
            elseif self.mainPanel ~= nil then
                self.scrollThumbFrame = createFrame(nil, {
                    type = FrameType.BACKDROP,
                    name = "TaskScrollThumbDyn",
                    parent = self.mainPanel,
                    template = "template",
                    visible = true
                })
                if self.scrollThumbFrame and self.scrollThumbFrame ~= 0 then
                    setFrameTexture(nil, self.scrollThumbFrame, "UI\\Widgets\\EscMenu\\Human\\slider-knob.blp")
                    setFrameSize(nil, self.scrollThumbFrame, {width = SCROLL_THUMB_SIZE, height = SCROLL_THUMB_SIZE})
                    if type(japi.DzFrameSetLevel) == "function" then
                        japi.DzFrameSetLevel(self.scrollThumbFrame, 120)
                    end
                    if type(japi.DzFrameShow) == "function" then
                        japi.DzFrameShow(self.scrollThumbFrame, true)
                    end
                    debugPrint(nil, "TS创建滚动滑块成功: TaskScrollThumbDyn")
                else
                    debugPrint(nil, "TS创建滚动滑块失败: TaskScrollThumbDyn")
                end
            end
            if self.scrollThumbFrame and self.scrollThumbFrame ~= 0 then
                self:setupThumbDrag()
            end
        end
        if ENABLE_SCROLL_INPUT then
            self.scrollInputFrame = createFrame(nil, {
                type = FrameType.SCROLLBAR,
                name = "TaskScrollInput",
                parent = self.mainPanel,
                template = "EscMenuScrollBarTemplate",
                visible = true,
                enable = true,
                alpha = 1
            })
            if not self.scrollInputFrame or self.scrollInputFrame == 0 then
                self.scrollInputFrame = createFrame(nil, {
                    type = FrameType.SLIDER,
                    name = "TaskScrollInput",
                    parent = self.mainPanel,
                    template = "template",
                    visible = true,
                    enable = true,
                    alpha = 1
                })
            end
            if self.scrollInputFrame and self.scrollInputFrame ~= 0 then
                if type(japi.DzFrameClearAllPoints) == "function" then
                    japi.DzFrameClearAllPoints(self.scrollInputFrame)
                end
                setFramePointRelative(
                    nil,
                    self.scrollInputFrame,
                    FramePoint.TOPRIGHT,
                    self.mainPanel,
                    FramePoint.TOPRIGHT,
                    SCROLLBAR_REL_X,
                    -0.08
                )
                setFramePointRelative(
                    nil,
                    self.scrollInputFrame,
                    FramePoint.BOTTOMRIGHT,
                    self.mainPanel,
                    FramePoint.BOTTOMRIGHT,
                    SCROLLBAR_REL_X,
                    0.03
                )
                setFrameSize(nil, self.scrollInputFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollInputFrame, 32)
                end
                frameSetScriptByCode(
                    nil,
                    self.scrollInputFrame,
                    EventType.SLIDER_VALUE_CHANGED,
                    function() return self:onScrollBarChange() end,
                    false
                )
            end
            if ENABLE_WHEEL_OVERLAY then
                self.wheelOverlay = createFrame(nil, {
                    type = FrameType.GLUETEXTBUTTON,
                    name = "TaskWheelOverlay",
                    parent = self.mainPanel,
                    template = "template",
                    visible = true,
                    enable = true,
                    alpha = 0
                })
                if self.wheelOverlay and self.listContainer and type(japi.DzFrameSetAllPoints) == "function" then
                    japi.DzFrameSetAllPoints(self.wheelOverlay, self.listContainer)
                end
            end
        end
    end
end
function TaskUI.prototype.onListWheel(self)
    local delta = type(getWheelDelta) == "function" and getWheelDelta(nil) or 0
    if delta == 0 then
        return
    end
    local step = LIST_ITEM_H + 0.01
    local maxScroll = math.max(0, self.totalContentHeight - LIST_VIEW_H)
    if delta > 0 then
        self.scrollOffset = math.max(0, self.scrollOffset - step)
    elseif delta < 0 then
        self.scrollOffset = math.min(maxScroll, self.scrollOffset + step)
    end
    self:syncScrollBarValue()
    self:refreshList()
end
function TaskUI.prototype.processWheel(self, delta)
    local step = LIST_ITEM_H + 0.01
    local maxScroll = math.max(0, self.totalContentHeight - LIST_VIEW_H)
    if delta > 0 then
        self.scrollOffset = math.max(0, self.scrollOffset - step)
    elseif delta < 0 then
        self.scrollOffset = math.min(maxScroll, self.scrollOffset + step)
    end
    self:syncScrollBarValue()
    self:refreshList()
end
function TaskUI.prototype.isMouseOverPanel(self)
    local focused = getMouseFocus(nil)
    if not focused or focused == 0 then
        return false
    end
    if focused == self.mainPanel or focused == self.listContainer or focused == self.scrollBarFrame or focused == self.scrollThumbHitBtn or focused == self.scrollInputFrame or focused == self.wheelOverlay or focused == self.tabMain or focused == self.tabSide or focused == self.tabDaily then
        return true
    end
    for ____, f in ipairs(self.listItemFrames) do
        if focused == f then
            return true
        end
    end
    return false
end
function TaskUI.prototype.onScrollBarChange(self)
    if self._updatingScrollBar then
        return
    end
    local getVal = japi.DzFrameGetValue
    if type(getVal) ~= "function" then
        return
    end
    if self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        self.scrollOffset = getVal(nil, self.scrollInputFrame)
    else
        return
    end
    self:refreshList()
end
function TaskUI.prototype.syncScrollBarValue(self)
    local setVal = japi.DzFrameSetValue
    if type(setVal) == "function" and self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        self._updatingScrollBar = true
        setVal(nil, self.scrollInputFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
end
function TaskUI.prototype.setupThumbDrag(self)
    if not self.scrollThumbFrame or self.scrollThumbFrame == 0 or not self.mainPanel or not self.scrollBarFrame then
        return
    end
    local ____opt_0 = self.vScrollTrack
    if ____opt_0 ~= nil then
        ____opt_0:destroy()
    end
    self.vScrollTrack = __TS__New(
        VerticalScrollbarTrack,
        {
            trackFrame = self.scrollBarFrame,
            thumbFrame = self.scrollThumbFrame,
            hitButtonName = "TaskScrollThumbHit",
            listViewHeightNorm = LIST_VIEW_H,
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
                self:syncScrollBarValue()
                self:refreshList()
            end,
            skipManualThumbSync = function() return ENABLE_SCROLL_INPUT and self.scrollInputFrame ~= nil and self.scrollInputFrame ~= 0 end
        }
    )
    self.vScrollTrack:attach()
    self.scrollThumbHitBtn = self.vScrollTrack:getHitButtonFrame()
end
function TaskUI.prototype.syncScrollThumb(self, maxScroll)
    if not self.vScrollTrack then
        return
    end
    debugPrint(
        nil,
        (("syncScrollThumb start maxScroll=" .. tostring(maxScroll)) .. " scrollOffset=") .. tostring(self.scrollOffset)
    )
    self.vScrollTrack:syncThumbVisual(maxScroll)
    debugPrint(nil, "syncScrollThumb end")
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
    self.currentCategory = ____type
    self.expandedQuestIds:clear()
    self.scrollOffset = 0
    self:refreshList()
end
function TaskUI.prototype.toggleExpand(self, questId)
    if self.expandedQuestIds:has(questId) then
        self.expandedQuestIds:delete(questId)
    else
        self.expandedQuestIds:add(questId)
    end
    self:refreshList()
end
function TaskUI.prototype.refreshList(self)
    if not self.listContainer then
        return
    end
    self:clearList()
    local quests = getQuestsForUI(nil, self.currentPlayerId, self.currentCategory)
    if #quests == 0 then
        self.totalContentHeight = 0
        self.scrollOffset = 0
        debugPrint(nil, "refreshList empty: category=" .. self.currentCategory)
        local empty = createTextLabel(
            nil,
            "TaskEmpty",
            self.listContainer,
            EMPTY_TEXTS[self.currentCategory],
            {point = FramePoint.CENTER, x = EMPTY_X, y = EMPTY_Y},
            {width = 0.9, height = 0.1}
        )
        if empty then
            local ____self_listItemFrames_2 = self.listItemFrames
            ____self_listItemFrames_2[#____self_listItemFrames_2 + 1] = empty
        end
        self:syncScrollThumb(0)
        return
    end
    local totalH = 0
    do
        local i = 0
        while i < #quests do
            do
                local __continue168
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue168 = true
                        break
                    end
                    local expanded = self.expandedQuestIds:has(q.id)
                    local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                    totalH = totalH + (itemH + 0.01)
                    __continue168 = true
                until true
                if not __continue168 then
                    break
                end
            end
            i = i + 1
        end
    end
    self.totalContentHeight = totalH
    local maxScroll = math.max(0, totalH - LIST_VIEW_H)
    self.scrollOffset = math.min(maxScroll, self.scrollOffset)
    debugPrint(
        nil,
        (((("refreshList compute: quests=" .. tostring(#quests)) .. " maxScroll=") .. tostring(maxScroll)) .. " offset=") .. tostring(self.scrollOffset)
    )
    local setMinMax = japi.DzFrameSetMinMaxValue
    local setVal = japi.DzFrameSetValue
    if type(setMinMax) == "function" and type(setVal) == "function" and self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        debugPrint(
            nil,
            (("refreshList set slider value: maxScroll=" .. tostring(maxScroll)) .. " offset=") .. tostring(self.scrollOffset)
        )
        setMinMax(
            nil,
            self.scrollInputFrame,
            0,
            math.max(1, maxScroll)
        )
        self._updatingScrollBar = true
        setVal(nil, self.scrollInputFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
    self:syncScrollThumb(maxScroll)
    local visibleTop = LIST_TOP
    local visibleBottom = LIST_BOTTOM + 0.01
    local EPS = 0.002
    local absY = LIST_TOP + self.scrollOffset
    do
        local i = 0
        while i < #quests do
            do
                local __continue172
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue172 = true
                        break
                    end
                    local expanded = self.expandedQuestIds:has(q.id)
                    local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                    local itemTop = absY
                    local itemBottom = absY - itemH
                    local fullyInside = itemTop <= visibleTop + EPS and itemBottom >= visibleBottom - EPS
                    if fullyInside then
                        self:createListItem(q, absY, expanded)
                    end
                    absY = absY - (itemH + 0.01)
                    __continue172 = true
                until true
                if not __continue172 then
                    break
                end
            end
            i = i + 1
        end
    end
end
function TaskUI.prototype.createListItem(self, quest, absY, expanded)
    if not self.listContainer then
        return nil
    end
    debugPrint(
        nil,
        (((((("createListItem questId=" .. quest.id) .. " expanded=") .. tostring(expanded)) .. " absY=") .. tostring(absY)) .. " title=") .. quest.title
    )
    local itemH = expanded and LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
    local statusText = getStatusText(nil, quest.status)
    local rowWidth = LIST_CONTAINER_W * 0.9
    local rowLeft = LIST_LEFT - 0.01
    local isMain0102Icon = quest.id == "main_001" or quest.id == "main_002"
    --- 与未展开主线行同高（或小 2%），展开后行变高也不放大图标
    local collapsedMainRowH = LIST_ITEM_H * 0.4
    local iconHLayout = isMain0102Icon and collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR or 0
    local textX = isMain0102Icon and rowLeft + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON or rowLeft + 0.03
    local rowTitleRightInset = 0.01
    local textW = rowWidth - (textX - rowLeft) - rowTitleRightInset
    local rowBackdrop = self.rowBackdropByQuestId:get(quest.id) or 0
    if rowBackdrop == 0 then
        rowBackdrop = tryCreateFromFdfOnly(nil, "TaskButtonBackdrop", self.listContainer) or 0
        if rowBackdrop == 0 then
            local bgFrame = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskItemBg_" .. quest.id,
                parent = self.listContainer,
                template = "template",
                visible = true
            })
            rowBackdrop = bgFrame or 0
            if rowBackdrop ~= 0 then
                setFrameTexture(nil, rowBackdrop, BG_TEX)
            end
        end
        if rowBackdrop ~= 0 then
            self.rowBackdropByQuestId:set(quest.id, rowBackdrop)
        end
    end
    if rowBackdrop == 0 then
        return nil
    end
    setFramePosition(nil, rowBackdrop, {point = FramePoint.TOPLEFT, x = rowLeft, y = absY})
    setFrameSize(nil, rowBackdrop, {width = rowWidth, height = itemH})
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(rowBackdrop, 1)
    end
    showFrame(nil, rowBackdrop)
    local ____self_listItemFrames_3 = self.listItemFrames
    ____self_listItemFrames_3[#____self_listItemFrames_3 + 1] = rowBackdrop
    debugPrint(nil, "createListItem rowBackdrop ok questId=" .. quest.id)
    local titleText = ((quest.title .. " [") .. statusText) .. "]"
    local titleFrame = self.titleByQuestId:get(quest.id) or 0
    if titleFrame == 0 then
        titleFrame = createTextLabel(
            nil,
            "TaskItem_" .. quest.id,
            self.listContainer,
            titleText,
            {point = FramePoint.TOPLEFT, x = textX, y = absY - 0.005},
            {width = textW, height = LIST_ITEM_H * 0.38}
        ) or 0
        if titleFrame == 0 then
            return nil
        end
        self.titleByQuestId:set(quest.id, titleFrame)
    else
        setFramePosition(nil, titleFrame, {point = FramePoint.TOPLEFT, x = textX, y = absY - 0.005})
        setFrameSize(nil, titleFrame, {width = textW, height = LIST_ITEM_H * 0.38})
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(titleFrame, titleText)
        end
    end
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(titleFrame, 3)
    end
    showFrame(nil, titleFrame)
    local ____self_listItemFrames_4 = self.listItemFrames
    ____self_listItemFrames_4[#____self_listItemFrames_4 + 1] = titleFrame
    debugPrint(nil, "createListItem title ok questId=" .. quest.id)
    local clickBtn = self.clickBtnByQuestId:get(quest.id) or 0
    if clickBtn == 0 then
        clickBtn = createFrame(nil, {
            type = FrameType.GLUETEXTBUTTON,
            name = "TaskItemClick_" .. quest.id,
            parent = self.listContainer,
            template = "template",
            visible = true,
            enable = true,
            alpha = 0
        }) or 0
        if clickBtn == 0 then
            return nil
        end
        self.clickBtnByQuestId:set(quest.id, clickBtn)
    end
    setFramePosition(nil, clickBtn, {point = FramePoint.TOPLEFT, x = rowLeft, y = absY})
    setFrameSize(nil, clickBtn, {width = rowWidth, height = itemH})
    setFrameClickEvent(
        nil,
        clickBtn,
        function()
            SoundUI_ClickPlay(nil)
            self:toggleExpand(quest.id)
        end,
        false
    )
    if ENABLE_MOUSE_WHEEL_SCROLL then
        frameSetScriptByCode(
            nil,
            clickBtn,
            EventType.MOUSE_WHEEL,
            function() return self:onListWheel() end,
            false
        )
    end
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(clickBtn, 4)
    end
    showFrame(nil, clickBtn)
    local ____self_listItemFrames_5 = self.listItemFrames
    ____self_listItemFrames_5[#____self_listItemFrames_5 + 1] = clickBtn
    debugPrint(nil, "createListItem clickBtn ok questId=" .. quest.id)
    if isMain0102Icon then
        local iconPath = quest.icon and quest.icon ~= "" and quest.icon or "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp"
        local iconFr = self.rowIconByQuestId:get(quest.id) or 0
        if iconFr == 0 then
            iconFr = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskQuestRowIcon_" .. quest.id,
                parent = self.listContainer,
                template = "template",
                visible = true
            }) or 0
            if iconFr ~= 0 then
                setFrameTexture(nil, iconFr, iconPath)
                self.rowIconByQuestId:set(quest.id, iconFr)
            end
        else
            setFrameTexture(nil, iconFr, iconPath)
        end
        if iconFr ~= 0 then
            local iconH = iconHLayout
            local iconW = iconH
            setFramePosition(nil, iconFr, {point = FramePoint.TOPLEFT, x = rowLeft + QUEST_ROW_ICON_PAD_LEFT, y = absY - QUEST_ROW_ICON_MAIN0102_Y_OFFSET})
            setFrameSize(nil, iconFr, {width = iconW, height = iconH})
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(iconFr, 5)
            end
            showFrame(nil, iconFr)
            local ____self_listItemFrames_6 = self.listItemFrames
            ____self_listItemFrames_6[#____self_listItemFrames_6 + 1] = iconFr
        end
    end
    if expanded then
        local objY = absY - LIST_ITEM_H * 0.35
        for ____, obj in ipairs(quest.objectives) do
            do
                local __continue201
                repeat
                    local txt = ((((((obj.completed and "[v] " or "[ ] ") .. obj.description) .. " (") .. tostring(obj.current)) .. "/") .. tostring(obj.required)) .. ")"
                    local objKey = (quest.id .. "|") .. obj.id
                    local objFrame = self.objFrameByKey:get(objKey) or 0
                    if objFrame == 0 then
                        objFrame = createTextLabel(
                            nil,
                            (("TaskObj_" .. quest.id) .. "_") .. obj.id,
                            self.listContainer,
                            txt,
                            {point = FramePoint.TOPLEFT, x = textX, y = objY},
                            {width = textW, height = LIST_ITEM_H * 0.25}
                        ) or 0
                        if objFrame == 0 then
                            __continue201 = true
                            break
                        end
                        self.objFrameByKey:set(objKey, objFrame)
                    else
                        setFramePosition(nil, objFrame, {point = FramePoint.TOPLEFT, x = textX, y = objY})
                        setFrameSize(nil, objFrame, {width = textW, height = LIST_ITEM_H * 0.25})
                        if type(japi.DzFrameSetText) == "function" then
                            japi.DzFrameSetText(objFrame, txt)
                        end
                    end
                    if type(japi.DzFrameSetLevel) == "function" then
                        japi.DzFrameSetLevel(objFrame, 3)
                    end
                    showFrame(nil, objFrame)
                    local ____self_listItemFrames_7 = self.listItemFrames
                    ____self_listItemFrames_7[#____self_listItemFrames_7 + 1] = objFrame
                    objY = objY - LIST_ITEM_H * 0.25
                    __continue201 = true
                until true
                if not __continue201 then
                    break
                end
            end
        end
        if quest.timeLimit and quest.timeLimit > 0 then
            local failFrame = self.failFrameByQuestId:get(quest.id) or 0
            local failText = ("失败: 时间限制 " .. tostring(quest.timeLimit)) .. "秒"
            if failFrame == 0 then
                failFrame = createTextLabel(
                    nil,
                    "TaskFail_" .. quest.id,
                    self.listContainer,
                    failText,
                    {point = FramePoint.TOPLEFT, x = textX, y = objY},
                    {width = textW, height = LIST_ITEM_H * 0.2}
                ) or 0
                if failFrame == 0 then
                    return nil
                end
                self.failFrameByQuestId:set(quest.id, failFrame)
            else
                setFramePosition(nil, failFrame, {point = FramePoint.TOPLEFT, x = textX, y = objY})
                setFrameSize(nil, failFrame, {width = textW, height = LIST_ITEM_H * 0.2})
                if type(japi.DzFrameSetText) == "function" then
                    japi.DzFrameSetText(failFrame, failText)
                end
            end
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(failFrame, 3)
            end
            showFrame(nil, failFrame)
            local ____self_listItemFrames_8 = self.listItemFrames
            ____self_listItemFrames_8[#____self_listItemFrames_8 + 1] = failFrame
        end
    end
    debugPrint(nil, "createListItem end questId=" .. quest.id)
    return nil
end
function TaskUI.prototype.togglePanel(self)
    self.isVisible = not self.isVisible
    if self.isVisible then
        self:show(self.currentPlayerId)
    else
        self:hide()
    end
end
function TaskUI.prototype.show(self, playerId)
    if not self.mainPanel then
        return
    end
    self.currentPlayerId = playerId
    self.isVisible = true
    debugPrint(
        nil,
        "show(): before showFrame mainPanel=" .. tostring(self.mainPanel)
    )
    showFrame(nil, self.mainPanel)
    debugPrint(
        nil,
        (("show(): after showFrame mainPanel, playerId=" .. tostring(playerId)) .. ", category=") .. self.currentCategory
    )
    self:refreshList()
    debugPrint(
        nil,
        "任务UI显示完成，玩家ID: " .. tostring(playerId)
    )
end
function TaskUI.prototype.hide(self)
    if not self.mainPanel then
        return
    end
    local ____opt_9 = self.vScrollTrack
    if ____opt_9 ~= nil then
        ____opt_9:cancelDrag()
    end
    self.isVisible = false
    debugPrint(
        nil,
        "hide(): before showFrame mainPanel=" .. tostring(self.mainPanel)
    )
    hideFrame(nil, self.mainPanel)
    debugPrint(nil, "hide(): after showFrame mainPanel")
end
function TaskUI.prototype.registerHotkey(self)
    if type(registerKeyDown) ~= "function" then
        return
    end
    registerKeyDown(
        nil,
        KEY_LETTER.J,
        function(____, player)
            local ____temp_11
            if type(jass.GetPlayerId) == "function" then
                ____temp_11 = jass.GetPlayerId
            else
                ____temp_11 = nil
            end
            local getPid = ____temp_11
            if getPid and player then
                self.currentPlayerId = getPid(player)
            end
            SoundUI_ClickPlay(nil)
            self:togglePanel()
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K1,
        function(____, player)
            if not self.isVisible then
                return
            end
            SoundUI_ClickPlay(nil)
            self:switchCategory(QuestType.MAIN)
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K2,
        function(____, player)
            if not self.isVisible then
                return
            end
            SoundUI_ClickPlay(nil)
            self:switchCategory(QuestType.SIDE)
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K3,
        function(____, player)
            if not self.isVisible then
                return
            end
            SoundUI_ClickPlay(nil)
            self:switchCategory(QuestType.DAILY)
        end
    )
    debugPrint(nil, "已注册 J 打开任务，1/2/3 切换标签")
end
____exports.taskUI = __TS__New(TaskUI)
function ____exports.init(self)
    ____exports.taskUI:init()
end
function ____exports.registerHotkey(self)
    ____exports.taskUI:registerHotkey()
end
return ____exports
