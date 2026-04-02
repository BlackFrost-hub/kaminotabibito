local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
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
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local getGameUI = ____04_FF0E_786C_4EF6_51FD_6570.getGameUI
local registerKeyDown = ____04_FF0E_786C_4EF6_51FD_6570.registerKeyDown
local KEY_LETTER = ____04_FF0E_786C_4EF6_51FD_6570.KEY_LETTER
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
local loadTocOnce = ____01_FF0EUI_5DE5_5177.loadTocOnce
local FrameType = ____01_FF0EUI_5DE5_5177.FrameType
local FramePoint = ____01_FF0EUI_5DE5_5177.FramePoint
local hideFrame = ____01_FF0EUI_5DE5_5177.hideFrame
local showFrame = ____01_FF0EUI_5DE5_5177.showFrame
local ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053 = require("系统.09．表现系统.02．垂直滚动条轨道")
local VerticalScrollbarTrack = ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053.VerticalScrollbarTrack
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____02_FF0E_97F3_6548_51FD_6570 = require("系统.00．核心系统.02．音效函数")
local SoundUI_ClickPlay = ____02_FF0E_97F3_6548_51FD_6570.SoundUI_ClickPlay
local ____06_FF0EUI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local DZ_TEXT_ALIGN_CENTER = ____06_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_CENTER
local DZ_TEXT_ALIGN_LEFT = ____06_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
local applyDzTextFontAndAlignment = ____06_FF0EUI_51FD_6570.applyDzTextFontAndAlignment
local applyDzTextFontAndCenterAlignment = ____06_FF0EUI_51FD_6570.applyDzTextFontAndCenterAlignment
local createTabLabelTextOnBackdrop = ____06_FF0EUI_51FD_6570.createTabLabelTextOnBackdrop
local setupTransparentGlueHitLayer = ____06_FF0EUI_51FD_6570.setupTransparentGlueHitLayer
--- 任务系统 - 全新任务 UI（魔兽原生风格）
-- 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
-- listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
local jass = require("jass.common")
local japi = require("jass.japi")
local function dzGetLocalPlayer(self)
    local ____temp_0
    if type(jass.GetLocalPlayer) == "function" then
        ____temp_0 = jass.GetLocalPlayer()
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
local function dzPlayer(self, index)
    local ____temp_1
    if type(jass.Player) == "function" then
        ____temp_1 = jass.Player(index)
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
local TASK_UI_TOC_PATHS = {"UI\\TaskUI.toc"}
local TASK_UI_TOC_LOAD_KEY = "TaskUI"
local ENABLE_FDF_A = true
local ENABLE_FDF_B = true
local ENABLE_FDF_SCROLLBAR = true
local ENABLE_FDF_SCROLLBAR_BORDER = false
local ENABLE_FDF_SCROLLBAR_THUMB = false
local ENABLE_MOUSE_WHEEL_SCROLL = true
--- 主任务口尺寸与 TOPLEFT 绝对坐标（左下原点，y 向上）
local ENTRY_W = 0.059 * 1.3
local ENTRY_H = 0.0156 * 1.4
local ENTRY_X = 0.005
local ENTRY_Y = 0.6
local ENTRY_TITLE_TEXT_BOX_W = 0.82
local ENTRY_TITLE_TEXT_BOX_H = 0.46
local PANEL_W = 0.35
local PANEL_H = 0.5
--- Tab 背景与 GLUETEXTBUTTON 同宽同高（与背景框对齐，避免字偏）
local TAB_FRAME_W = 0.04
local TAB_FRAME_H = 0.035
--- 顶部 Tab「主线/支线/小任务」：`DzFrameSetFont` 第三参（配合与 BACKDROP 同大的 `TEXT`）
local TAB_CATEGORY_FONT_SCALE = 0.012
local LIST_ITEM_H = 0.12
local BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp"
local PANEL_TOP = 0.46
local PANEL_TOP_UP = 0.015
local LEGACY_ENTRY_X_REF = 0.06
local LEGACY_ENTRY_Y_REF = 0.51
local LEGACY_PANEL_TOP_Y = PANEL_TOP + PANEL_TOP_UP
local LEGACY_LIST_TOP = 0.41 + PANEL_TOP_UP - 0.04
--- 主面板 TOPLEFT 相对任务口 TOPLEFT（y 为负表示面板顶在入口顶下方，与旧版一致）
local PANEL_TOPLEFT_OFF_X = 0
local PANEL_TOPLEFT_OFF_Y = LEGACY_PANEL_TOP_Y - LEGACY_ENTRY_Y_REF
--- 展开区相对「PANEL_TOPLEFT_OFF 基准」再上移（并入 PANEL_REL_TO_ENTRY_Y，y 向上为正）
local PANEL_EXPANDED_UP = 0.015
--- 主面板 TOPLEFT 相对任务入口 TOPLEFT（DzFrameSetPoint）；改 ENTRY_* 只动入口即可，面板随锚点跟动
local PANEL_REL_TO_ENTRY_X = PANEL_TOPLEFT_OFF_X
local PANEL_REL_TO_ENTRY_Y = PANEL_TOPLEFT_OFF_Y + PANEL_EXPANDED_UP
--- 列表第一行顶相对主面板 TOPLEFT
local LIST_FIRST_ROW_REL_Y = LEGACY_LIST_TOP - LEGACY_PANEL_TOP_Y
--- 任务行左边相对主面板 TOPLEFT（旧 rowLeft − 面板左，面板左与入口左对齐）
local LIST_ROW_LEFT_REL_X = 0.09 - LEGACY_ENTRY_X_REF - 0.01
local TAB_Y = 0.44
local TAB_REL_Y = TAB_Y - PANEL_TOP
--- 折叠行纵向步进（行高 + 间距），与 refreshList 一致
local COLLAPSED_ROW_PITCH = LIST_ITEM_H * 0.4 + 0.01
--- 列表可视高度：目标约 7 条折叠任务（原 ~0.335 只能约 5 条）
local LIST_VIEW_TARGET_ROWS = 7
local LIST_VIEW_H = COLLAPSED_ROW_PITCH * LIST_VIEW_TARGET_ROWS + 0.012
--- 轨道与列表可视等高：主面板右缘用双锚点拉出，高度 = PANEL_H - 顶留白 - 底留白
local SCROLLBAR_BOTTOM_INSET = 0.03
local SCROLLBAR_TOP_INSET = PANEL_H - LIST_VIEW_H - SCROLLBAR_BOTTOM_INSET
--- listContainer 相对主面板 TOPLEFT（与 createMainPanel 一致）
local LIST_CONTAINER_REL_TO_PANEL_X = 0.015
local LIST_CONTAINER_REL_TO_PANEL_Y = -0.1
--- 列表内容相对 listContainer TOPLEFT；相对主面板的行/框左缘与容器锚点之差，+0.025 上移对齐装饰框
local LIST_CONTENT_LEFT_INSET = LIST_ROW_LEFT_REL_X - LIST_CONTAINER_REL_TO_PANEL_X
local LIST_CONTENT_TOP_INSET = LIST_FIRST_ROW_REL_Y - LIST_CONTAINER_REL_TO_PANEL_Y + 0.025
local LIST_CONTAINER_W = 0.32
local SCROLLBAR_W = 0.015
--- 轨道相对主面板右缘横向偏移（负数向左）；原 -0.006，再左移 0.005 + 0.004
local SCROLLBAR_REL_X = -0.006 - 0.005 - 0.004
local SCROLL_THUMB_SIZE = 0.02
--- 行程按「轨道实际高度 − 滑块」计算；非 0 会在顶/底留空
local SCROLL_THUMB_TOP_COMPENSATION = 0
local SCROLL_THUMB_BOTTOM_COMPENSATION = 0
--- 滑块拖拽：定时器间隔（秒）
local THUMB_DRAG_TICK = 0.03
--- 微调：1=与轨道像素行程 1:1（原先误用 wh*0.35 与 UI 0.6 坐标系不一致导致“跟手”差）
local THUMB_DRAG_SENSITIVITY = 1
--- 主线任务 001/002 左侧图标（正方形 w=h）：相对「未展开」行高 LIST_ITEM_H*0.4，0.90=比该行高小10%
local QUEST_ROW_ICON_HEIGHT_FACTOR = 0.84
local QUEST_ROW_ICON_PAD_LEFT = 0.003
--- 图标右缘与标题文字之间的空隙
local QUEST_ROW_TEXT_GAP_AFTER_ICON = 0.006
--- 带行图标时左侧图标相对行顶 TOPLEFT 的纵向偏移（越大越往下，避免顶到行上边框）
local QUEST_ROW_ICON_Y_OFFSET = 0.004
--- `main_`/`side_`/`daily_` + 三位序号 001–020：左侧任务图标 + 文本左对齐（与主线一致）
local function questIdTailInRange01to20(self, id, prefix)
    if #id ~= #prefix + 3 then
        return false
    end
    if __TS__StringSubstring(id, 0, #prefix) ~= prefix then
        return false
    end
    local tail = __TS__StringSubstring(id, #prefix)
    if #tail ~= 3 then
        return false
    end
    return tail >= "001" and tail <= "020"
end
local function isQuestWithRowIconLayout(self, quest)
    local id = quest.id
    if quest.type == QuestType.MAIN then
        return questIdTailInRange01to20(nil, id, "main_")
    end
    if quest.type == QuestType.SIDE then
        return questIdTailInRange01to20(nil, id, "side_")
    end
    if quest.type == QuestType.DAILY then
        return questIdTailInRange01to20(nil, id, "daily_")
    end
    return false
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
        return res.frame
    end
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
    local active = __TS__ArrayFilter(
        questManager:getPlayerQuests(playerId, ____type),
        function(____, q) return not q.uiReserved end
    )
    local completedIds = questDB:getPlayerCompletedQuests(playerId)
    local result = __TS__ArraySlice(active)
    for ____, id in ipairs(completedIds) do
        do
            local __continue29
            repeat
                local template = questDB:getQuest(id)
                if not template or template.type ~= ____type or template.uiReserved then
                    __continue29 = true
                    break
                end
                if __TS__ArraySome(
                    active,
                    function(____, q) return q.id == id end
                ) then
                    __continue29 = true
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
                __continue29 = true
            until true
            if not __continue29 then
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
            self:hide()
        end
    )
end
function TaskUI.prototype.isDescendantOf(self, frame, ancestor)
    if not frame or frame == 0 or not ancestor or ancestor == 0 then
        return false
    end
    local cur = frame
    do
        local i = 0
        while i < 64 do
            if cur == ancestor then
                return true
            end
            local ____temp_2
            if type(japi.DzFrameGetParent) == "function" then
                ____temp_2 = japi.DzFrameGetParent(cur)
            else
                ____temp_2 = 0
            end
            local p = ____temp_2
            if not p or p == 0 then
                return false
            end
            cur = p
            i = i + 1
        end
    end
    return false
end
function TaskUI.prototype.isWheelTargetForTaskList(self)
    if not self.mainPanel then
        return false
    end
    local f = type(getMouseFocus) == "function" and getMouseFocus(nil) or 0
    if not f or f == 0 then
        return false
    end
    if self.listContainer and (f == self.listContainer or self:isDescendantOf(f, self.listContainer)) then
        return true
    end
    if self.scrollBarFrame and (f == self.scrollBarFrame or self:isDescendantOf(f, self.scrollBarFrame)) then
        return true
    end
    if self.scrollThumbFrame and (f == self.scrollThumbFrame or self:isDescendantOf(f, self.scrollThumbFrame)) then
        return true
    end
    if self.scrollThumbHitBtn and f == self.scrollThumbHitBtn then
        return true
    end
    return false
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
    self.entryFrame = tryCreateFromFdfOnly(nil, "TaskEntryIcon", parent)
    if not self.entryFrame then
        return
    end
    setFramePosition(nil, self.entryFrame, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = ENTRY_Y})
    setFrameSize(nil, self.entryFrame, {width = ENTRY_W, height = ENTRY_H})
    local tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W
    local th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H
    local titleRel = {
        relativeTo = self.entryFrame,
        point = FramePoint.CENTER,
        relativePoint = FramePoint.CENTER,
        x = 0,
        y = 0
    }
    --- 强制 TEXT：`DzFrameSetFont` 主要对 TEXT 生效；`createTextLabel` 失败时会退回 GLUETEXTBUTTON，字体 native 常无效
    local textFrame = createFrame(nil, {
        type = FrameType.TEXT,
        name = "TaskEntryText",
        parent = self.entryFrame,
        template = "template",
        visible = true
    })
    if textFrame ~= nil and textFrame ~= 0 then
        self.entryText = textFrame
        setFramePointRelative(
            nil,
            textFrame,
            titleRel.point,
            titleRel.relativeTo,
            titleRel.relativePoint,
            titleRel.x,
            titleRel.y
        )
        setFrameSize(nil, textFrame, {width = tw, height = th})
    else
        self.entryText = createTextLabel(
            nil,
            "TaskEntryText",
            self.entryFrame,
            "",
            titleRel,
            {width = tw, height = th}
        )
    end
    if self.entryText ~= nil and self.entryText ~= 0 then
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(self.entryText, "|cffffcc00任务(J)|r")
        end
        applyDzTextFontAndCenterAlignment(nil, self.entryText)
    end
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
    if type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(self.mainPanel)
    end
    if self.entryFrame then
        setFramePointRelative(
            nil,
            self.mainPanel,
            FramePoint.TOPLEFT,
            self.entryFrame,
            FramePoint.TOPLEFT,
            PANEL_REL_TO_ENTRY_X,
            PANEL_REL_TO_ENTRY_Y
        )
    else
        setFramePosition(nil, self.mainPanel, {point = FramePoint.TOPLEFT, x = ENTRY_X + PANEL_REL_TO_ENTRY_X, y = ENTRY_Y + PANEL_REL_TO_ENTRY_Y})
    end
    setFrameSize(nil, self.mainPanel, {width = PANEL_W, height = PANEL_H})
    self.listContainer = tryCreateFromFdfOnly(nil, "TaskListContainer", self.mainPanel)
    if self.listContainer then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.listContainer)
        end
        setFramePointRelative(
            nil,
            self.listContainer,
            FramePoint.TOPLEFT,
            self.mainPanel,
            FramePoint.TOPLEFT,
            LIST_CONTAINER_REL_TO_PANEL_X,
            LIST_CONTAINER_REL_TO_PANEL_Y
        )
    end
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
        setFrameSize(nil, self.tabMainBg, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMainBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMainBg, 7)
        end
    end
    if self.tabMainBg then
        local tabLabel = createTabLabelTextOnBackdrop(
            nil,
            self.tabMainBg,
            "TaskTabMainLabel",
            "|cffffcc00主线(1)|r",
            TAB_CATEGORY_FONT_SCALE
        )
        if tabLabel and type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tabLabel, 8)
        end
    end
    self.tabMain = tryCreateFromFdfOnly(nil, "TaskTabMain", tabParent)
    if self.tabMain then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabMain)
        end
        if self.tabMainBg then
            setupTransparentGlueHitLayer(nil, self.tabMainBg, self.tabMain)
        else
            setFramePointRelative(
                nil,
                self.tabMain,
                FramePoint.TOPLEFT,
                tabParent,
                FramePoint.TOPLEFT,
                0.02,
                TAB_REL_Y
            )
            setFrameSize(nil, self.tabMain, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        end
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMain, true) end
            )
        end
        if not self.tabMainBg then
            setButtonText(nil, self.tabMain, "")
            if type(japi.DzFrameSetAlpha) == "function" then
                pcall(function () return japi.DzFrameSetAlpha(self.tabMain, 0) end
                )
            end
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMain, 9)
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
        setFrameSize(nil, self.tabSideBg, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSideBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSideBg, 7)
        end
    end
    if self.tabSideBg then
        local tabLabel = createTabLabelTextOnBackdrop(
            nil,
            self.tabSideBg,
            "TaskTabSideLabel",
            "|cffffcc00支线(2)|r",
            TAB_CATEGORY_FONT_SCALE
        )
        if tabLabel and type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tabLabel, 8)
        end
    end
    self.tabSide = tryCreateFromFdfOnly(nil, "TaskTabSide", tabParent)
    if self.tabSide then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabSide)
        end
        if self.tabSideBg then
            setupTransparentGlueHitLayer(nil, self.tabSideBg, self.tabSide)
        else
            setFramePointRelative(
                nil,
                self.tabSide,
                FramePoint.TOPLEFT,
                tabParent,
                FramePoint.TOPLEFT,
                0.135,
                TAB_REL_Y
            )
            setFrameSize(nil, self.tabSide, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        end
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSide, true) end
            )
        end
        if not self.tabSideBg then
            setButtonText(nil, self.tabSide, "")
            if type(japi.DzFrameSetAlpha) == "function" then
                pcall(function () return japi.DzFrameSetAlpha(self.tabSide, 0) end
                )
            end
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSide, 9)
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
        setFrameSize(nil, self.tabDailyBg, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDailyBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDailyBg, 7)
        end
    end
    if self.tabDailyBg then
        local tabLabel = createTabLabelTextOnBackdrop(
            nil,
            self.tabDailyBg,
            "TaskTabDailyLabel",
            "|cffffcc00小任务(3)|r",
            TAB_CATEGORY_FONT_SCALE
        )
        if tabLabel and type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tabLabel, 8)
        end
    end
    self.tabDaily = tryCreateFromFdfOnly(nil, "TaskTabDaily", tabParent)
    if self.tabDaily then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabDaily)
        end
        if self.tabDailyBg then
            setupTransparentGlueHitLayer(nil, self.tabDailyBg, self.tabDaily)
        else
            setFramePointRelative(
                nil,
                self.tabDaily,
                FramePoint.TOPLEFT,
                tabParent,
                FramePoint.TOPLEFT,
                0.25,
                TAB_REL_Y
            )
            setFrameSize(nil, self.tabDaily, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        end
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDaily, true) end
            )
        end
        if not self.tabDailyBg then
            setButtonText(nil, self.tabDaily, "")
            if type(japi.DzFrameSetAlpha) == "function" then
                pcall(function () return japi.DzFrameSetAlpha(self.tabDaily, 0) end
                )
            end
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDaily, 9)
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
                -SCROLLBAR_TOP_INSET
            )
            setFramePointRelative(
                nil,
                self.scrollBarFrame,
                FramePoint.BOTTOMRIGHT,
                self.mainPanel,
                FramePoint.BOTTOMRIGHT,
                SCROLLBAR_REL_X,
                SCROLLBAR_BOTTOM_INSET
            )
            setFrameSize(nil, self.scrollBarFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(self.scrollBarFrame, 30)
            end
        end
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
        end
        if self.scrollThumbFrame and self.scrollThumbFrame ~= 0 and self.scrollBarFrame and self.scrollBarFrame ~= 0 then
            local ____opt_3 = self.vScrollTrack
            if ____opt_3 ~= nil then
                ____opt_3:destroy()
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
    self:refreshList()
end
function TaskUI.prototype.setupThumbDrag(self)
    if not self.scrollThumbFrame or self.scrollThumbFrame == 0 or not self.mainPanel or not self.scrollBarFrame then
        return
    end
    local ____opt_5 = self.vScrollTrack
    if ____opt_5 ~= nil then
        ____opt_5:destroy()
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
    local vis = maxScroll > 0
    local fn = japi.DzFrameShow
    if type(fn) ~= "function" then
        return
    end
    local function setVis(____, f)
        if f and f ~= 0 then
            pcall(function () return fn(nil, f, vis) end
            )
        end
    end
    setVis(nil, self.scrollBarFrame)
    setVis(nil, self.scrollThumbFrame)
    setVis(nil, self.scrollThumbHitBtn)
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
            local quests = getQuestsForUI(nil, self.currentPlayerId, self.currentCategory)
            if #quests == 0 then
                self.totalContentHeight = 0
                self.scrollOffset = 0
                local empty = createTextLabel(
                    nil,
                    "TaskEmpty",
                    self.listContainer,
                    EMPTY_TEXTS[self.currentCategory],
                    {
                        relativeTo = self.listContainer,
                        point = FramePoint.CENTER,
                        relativePoint = FramePoint.CENTER,
                        x = 0,
                        y = 0
                    },
                    {width = LIST_CONTAINER_W * 0.85, height = 0.08}
                )
                if empty then
                    local ____self_listItemFrames_7 = self.listItemFrames
                    ____self_listItemFrames_7[#____self_listItemFrames_7 + 1] = empty
                    applyDzTextFontAndCenterAlignment(nil, empty)
                end
                self:syncScrollThumb(0)
                self:updateScrollBarVisibility(0)
                return
            end
            local totalH = 0
            do
                local i = 0
                while i < #quests do
                    do
                        local __continue219
                        repeat
                            local q = quests[i + 1]
                            if not q then
                                __continue219 = true
                                break
                            end
                            local expanded = self.expandedQuestIds:has(q.id)
                            local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                            totalH = totalH + (itemH + 0.01)
                            __continue219 = true
                        until true
                        if not __continue219 then
                            break
                        end
                    end
                    i = i + 1
                end
            end
            self.totalContentHeight = totalH
            local maxScroll = math.max(0, totalH - LIST_VIEW_H)
            self.scrollOffset = math.min(maxScroll, self.scrollOffset)
            self:syncScrollThumb(maxScroll)
            self:updateScrollBarVisibility(maxScroll)
            local visibleTopRel = LIST_CONTENT_TOP_INSET
            local visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H
            local EPS = 0.002
            local rowTopRel = LIST_CONTENT_TOP_INSET + self.scrollOffset
            do
                local i = 0
                while i < #quests do
                    do
                        local __continue222
                        repeat
                            local q = quests[i + 1]
                            if not q then
                                __continue222 = true
                                break
                            end
                            local expanded = self.expandedQuestIds:has(q.id)
                            local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                            local itemTopRel = rowTopRel
                            local itemBottomRel = rowTopRel - itemH
                            local fullyInside = itemTopRel <= visibleTopRel + EPS and itemBottomRel >= visibleBottomRel - EPS
                            if fullyInside then
                                self:createListItem(q, rowTopRel, expanded)
                            end
                            rowTopRel = rowTopRel - (itemH + 0.01)
                            __continue222 = true
                        until true
                        if not __continue222 then
                            break
                        end
                    end
                    i = i + 1
                end
            end
        end
    )
end
function TaskUI.prototype.createListItem(self, quest, rowTopRel, expanded)
    local listParent = self.listContainer
    if not self.mainPanel or not listParent then
        return nil
    end
    local itemH = expanded and LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
    local statusText = getStatusText(nil, quest.status)
    local rowWidth = LIST_CONTAINER_W * 0.9
    local rowLeftRel = LIST_CONTENT_LEFT_INSET
    local showMainRowIcon = isQuestWithRowIconLayout(nil, quest)
    --- 与未展开主线行同高（或小 2%），展开后行变高也不放大图标
    local collapsedMainRowH = LIST_ITEM_H * 0.4
    local iconHLayout = showMainRowIcon and collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR or 0
    local textXRel = showMainRowIcon and rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON or rowLeftRel + 0.03
    local listTextAlign = showMainRowIcon and DZ_TEXT_ALIGN_LEFT or DZ_TEXT_ALIGN_CENTER
    local rowTitleRightInset = 0.01
    local textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset
    local rowBackdrop = self.rowBackdropByQuestId:get(quest.id) or 0
    if rowBackdrop == 0 then
        rowBackdrop = tryCreateFromFdfOnly(nil, "TaskButtonBackdrop", listParent) or 0
        if rowBackdrop == 0 then
            local bgFrame = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskItemBg_" .. quest.id,
                parent = listParent,
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
    setFramePointRelative(
        nil,
        rowBackdrop,
        FramePoint.TOPLEFT,
        listParent,
        FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
    setFrameSize(nil, rowBackdrop, {width = rowWidth, height = itemH})
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(rowBackdrop, 1)
    end
    showFrame(nil, rowBackdrop)
    local ____self_listItemFrames_8 = self.listItemFrames
    ____self_listItemFrames_8[#____self_listItemFrames_8 + 1] = rowBackdrop
    local titleText = ((quest.title .. " [") .. statusText) .. "]"
    local titleFrame = self.titleByQuestId:get(quest.id) or 0
    if titleFrame == 0 then
        titleFrame = createTextLabel(
            nil,
            "TaskItem_" .. quest.id,
            listParent,
            titleText,
            {
                relativeTo = listParent,
                point = FramePoint.TOPLEFT,
                relativePoint = FramePoint.TOPLEFT,
                x = textXRel,
                y = rowTopRel - 0.005
            },
            {width = textW, height = LIST_ITEM_H * 0.38}
        ) or 0
        if titleFrame == 0 then
            return nil
        end
        self.titleByQuestId:set(quest.id, titleFrame)
    else
        setFramePointRelative(
            nil,
            titleFrame,
            FramePoint.TOPLEFT,
            listParent,
            FramePoint.TOPLEFT,
            textXRel,
            rowTopRel - 0.005
        )
        setFrameSize(nil, titleFrame, {width = textW, height = LIST_ITEM_H * 0.38})
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(titleFrame, titleText)
        end
    end
    applyDzTextFontAndAlignment(nil, titleFrame, listTextAlign)
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(titleFrame, 3)
    end
    showFrame(nil, titleFrame)
    local ____self_listItemFrames_9 = self.listItemFrames
    ____self_listItemFrames_9[#____self_listItemFrames_9 + 1] = titleFrame
    local clickBtn = self.clickBtnByQuestId:get(quest.id) or 0
    if clickBtn == 0 then
        clickBtn = createFrame(nil, {
            type = FrameType.GLUETEXTBUTTON,
            name = "TaskItemClick_" .. quest.id,
            parent = listParent,
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
    setFramePointRelative(
        nil,
        clickBtn,
        FramePoint.TOPLEFT,
        listParent,
        FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
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
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(clickBtn, 4)
    end
    showFrame(nil, clickBtn)
    local ____self_listItemFrames_10 = self.listItemFrames
    ____self_listItemFrames_10[#____self_listItemFrames_10 + 1] = clickBtn
    if showMainRowIcon then
        local iconPath = quest.icon and quest.icon ~= "" and quest.icon or "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp"
        local iconFr = self.rowIconByQuestId:get(quest.id) or 0
        if iconFr == 0 then
            iconFr = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskQuestRowIcon_" .. quest.id,
                parent = listParent,
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
            setFramePointRelative(
                nil,
                iconFr,
                FramePoint.TOPLEFT,
                listParent,
                FramePoint.TOPLEFT,
                rowLeftRel + QUEST_ROW_ICON_PAD_LEFT,
                rowTopRel - QUEST_ROW_ICON_Y_OFFSET
            )
            setFrameSize(nil, iconFr, {width = iconW, height = iconH})
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(iconFr, 5)
            end
            showFrame(nil, iconFr)
            local ____self_listItemFrames_11 = self.listItemFrames
            ____self_listItemFrames_11[#____self_listItemFrames_11 + 1] = iconFr
        end
    end
    if expanded then
        local objYRel = rowTopRel - LIST_ITEM_H * 0.35
        for ____, obj in ipairs(quest.objectives) do
            do
                local __continue249
                repeat
                    local txt = ((((((obj.completed and "[v] " or "[ ] ") .. obj.description) .. " (") .. tostring(obj.current)) .. "/") .. tostring(obj.required)) .. ")"
                    local objKey = (quest.id .. "|") .. obj.id
                    local objFrame = self.objFrameByKey:get(objKey) or 0
                    if objFrame == 0 then
                        objFrame = createTextLabel(
                            nil,
                            (("TaskObj_" .. quest.id) .. "_") .. obj.id,
                            listParent,
                            txt,
                            {
                                relativeTo = listParent,
                                point = FramePoint.TOPLEFT,
                                relativePoint = FramePoint.TOPLEFT,
                                x = textXRel,
                                y = objYRel
                            },
                            {width = textW, height = LIST_ITEM_H * 0.25}
                        ) or 0
                        if objFrame == 0 then
                            __continue249 = true
                            break
                        end
                        self.objFrameByKey:set(objKey, objFrame)
                    else
                        setFramePointRelative(
                            nil,
                            objFrame,
                            FramePoint.TOPLEFT,
                            listParent,
                            FramePoint.TOPLEFT,
                            textXRel,
                            objYRel
                        )
                        setFrameSize(nil, objFrame, {width = textW, height = LIST_ITEM_H * 0.25})
                        if type(japi.DzFrameSetText) == "function" then
                            japi.DzFrameSetText(objFrame, txt)
                        end
                    end
                    applyDzTextFontAndAlignment(nil, objFrame, listTextAlign)
                    if type(japi.DzFrameSetLevel) == "function" then
                        japi.DzFrameSetLevel(objFrame, 3)
                    end
                    showFrame(nil, objFrame)
                    local ____self_listItemFrames_12 = self.listItemFrames
                    ____self_listItemFrames_12[#____self_listItemFrames_12 + 1] = objFrame
                    objYRel = objYRel - LIST_ITEM_H * 0.25
                    __continue249 = true
                until true
                if not __continue249 then
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
                    listParent,
                    failText,
                    {
                        relativeTo = listParent,
                        point = FramePoint.TOPLEFT,
                        relativePoint = FramePoint.TOPLEFT,
                        x = textXRel,
                        y = objYRel
                    },
                    {width = textW, height = LIST_ITEM_H * 0.2}
                ) or 0
                if failFrame == 0 then
                    return nil
                end
                self.failFrameByQuestId:set(quest.id, failFrame)
            else
                setFramePointRelative(
                    nil,
                    failFrame,
                    FramePoint.TOPLEFT,
                    listParent,
                    FramePoint.TOPLEFT,
                    textXRel,
                    objYRel
                )
                setFrameSize(nil, failFrame, {width = textW, height = LIST_ITEM_H * 0.2})
                if type(japi.DzFrameSetText) == "function" then
                    japi.DzFrameSetText(failFrame, failText)
                end
            end
            applyDzTextFontAndAlignment(nil, failFrame, listTextAlign)
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(failFrame, 3)
            end
            showFrame(nil, failFrame)
            local ____self_listItemFrames_13 = self.listItemFrames
            ____self_listItemFrames_13[#____self_listItemFrames_13 + 1] = failFrame
        end
    end
    return nil
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
            local ____opt_14 = self.vScrollTrack
            if ____opt_14 ~= nil then
                ____opt_14:cancelDrag()
            end
            self.isVisible = false
            hideFrame(nil, self.mainPanel)
        end
    )
end
function TaskUI.prototype.registerHotkey(self)
    if type(registerKeyDown) ~= "function" then
        return
    end
    registerKeyDown(
        nil,
        KEY_LETTER.J,
        function(____, player)
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    local ____temp_16
                    if type(jass.GetPlayerId) == "function" then
                        ____temp_16 = jass.GetPlayerId
                    else
                        ____temp_16 = nil
                    end
                    local getPid = ____temp_16
                    if getPid and player then
                        self.currentPlayerId = getPid(player)
                    end
                    SoundUI_ClickPlay(nil)
                    self:togglePanel()
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K1,
        function(____, player)
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
                    SoundUI_ClickPlay(nil)
                    self:switchCategory(QuestType.MAIN)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K2,
        function(____, player)
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
                    SoundUI_ClickPlay(nil)
                    self:switchCategory(QuestType.SIDE)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K3,
        function(____, player)
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
                    SoundUI_ClickPlay(nil)
                    self:switchCategory(QuestType.DAILY)
                end
            )
        end
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
