local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_914D_7F6E_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.00．配置常量")
local ENTRY_X = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_X
local ENTRY_Y = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_Y
local ENTRY_W = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_W
local ENTRY_H = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_H
local ENTRY_TITLE_TEXT_BOX_W = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_TITLE_TEXT_BOX_W
local ENTRY_TITLE_TEXT_BOX_H = ____00_FF0E_914D_7F6E_5E38_91CF.ENTRY_TITLE_TEXT_BOX_H
local PANEL_REL_TO_ENTRY_X = ____00_FF0E_914D_7F6E_5E38_91CF.PANEL_REL_TO_ENTRY_X
local PANEL_REL_TO_ENTRY_Y = ____00_FF0E_914D_7F6E_5E38_91CF.PANEL_REL_TO_ENTRY_Y
local PANEL_W = ____00_FF0E_914D_7F6E_5E38_91CF.PANEL_W
local PANEL_H = ____00_FF0E_914D_7F6E_5E38_91CF.PANEL_H
local LIST_CONTAINER_REL_TO_PANEL_X = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTAINER_REL_TO_PANEL_X
local LIST_CONTAINER_REL_TO_PANEL_Y = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTAINER_REL_TO_PANEL_Y
local TAB_REL_Y = ____00_FF0E_914D_7F6E_5E38_91CF.TAB_REL_Y
local TAB_FRAME_W = ____00_FF0E_914D_7F6E_5E38_91CF.TAB_FRAME_W
local TAB_FRAME_H = ____00_FF0E_914D_7F6E_5E38_91CF.TAB_FRAME_H
local TAB_CATEGORY_FONT_SCALE = ____00_FF0E_914D_7F6E_5E38_91CF.TAB_CATEGORY_FONT_SCALE
local SCROLLBAR_REL_X = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLLBAR_REL_X
local SCROLLBAR_TOP_INSET = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLLBAR_TOP_INSET
local SCROLLBAR_BOTTOM_INSET = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLLBAR_BOTTOM_INSET
local SCROLLBAR_W = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLLBAR_W
local LIST_VIEW_H = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_VIEW_H
local SCROLL_THUMB_SIZE = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____00_FF0E_914D_7F6E_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local THUMB_DRAG_TICK = ____00_FF0E_914D_7F6E_5E38_91CF.THUMB_DRAG_TICK
local THUMB_DRAG_SENSITIVITY = ____00_FF0E_914D_7F6E_5E38_91CF.THUMB_DRAG_SENSITIVITY
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____01_FF0E_901A_7528_5DE5_5177 = require("系统.08．任务系统.03．任务UI拆分.01．通用工具")
local tryCreateFromFdfOnly = ____01_FF0E_901A_7528_5DE5_5177.tryCreateFromFdfOnly
local tryCreateFromFdfWithSource = ____01_FF0E_901A_7528_5DE5_5177.tryCreateFromFdfWithSource
local ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053 = require("系统.09．表现系统.02．垂直滚动条轨道")
local VerticalScrollbarTrack = ____02_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053.VerticalScrollbarTrack
function ____exports.buildTaskEntryIcon(self, opts)
    local ____opts_0 = opts
    local japi = ____opts_0.japi
    local parent = ____opts_0.parent
    local FrameType = ____opts_0.FrameType
    local FramePoint = ____opts_0.FramePoint
    local createFrame = ____opts_0.createFrame
    local createTextLabel = ____opts_0.createTextLabel
    local setFramePosition = ____opts_0.setFramePosition
    local setFrameSize = ____opts_0.setFrameSize
    local setFramePointRelative = ____opts_0.setFramePointRelative
    local setFrameClickEvent = ____opts_0.setFrameClickEvent
    local applyDzTextFontAndCenterAlignment = ____opts_0.applyDzTextFontAndCenterAlignment
    local onClickSound = ____opts_0.onClickSound
    local onTogglePanel = ____opts_0.onTogglePanel
    local entryFrame = tryCreateFromFdfOnly(nil, "TaskEntryIcon", parent)
    if not entryFrame then
        return {entryFrame = nil, entryText = nil}
    end
    setFramePosition(nil, entryFrame, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = ENTRY_Y})
    setFrameSize(nil, entryFrame, {width = ENTRY_W, height = ENTRY_H})
    local tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W
    local th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H
    local titleRel = {
        relativeTo = entryFrame,
        point = FramePoint.CENTER,
        relativePoint = FramePoint.CENTER,
        x = 0,
        y = 0
    }
    local entryText = nil
    local ____createFrame_result_1 = createFrame(nil, {
        type = FrameType.TEXT,
        name = "TaskEntryText",
        parent = entryFrame,
        template = "template",
        visible = true
    })
    if ____createFrame_result_1 == nil then
        ____createFrame_result_1 = 0
    end
    local textFrame = ____createFrame_result_1
    if textFrame ~= nil and textFrame ~= 0 then
        entryText = textFrame
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
        entryText = createTextLabel(
            nil,
            "TaskEntryText",
            entryFrame,
            "",
            titleRel,
            {width = tw, height = th}
        )
    end
    if entryText ~= nil and entryText ~= 0 then
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(entryText, "|cffffcc00任务(J)|r")
        end
        applyDzTextFontAndCenterAlignment(nil, entryText)
    end
    local ____createFrame_result_2 = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "TaskEntryBtn",
        parent = entryFrame,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if ____createFrame_result_2 == nil then
        ____createFrame_result_2 = 0
    end
    local btn = ____createFrame_result_2
    if btn and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(btn, entryFrame)
        setFrameClickEvent(
            nil,
            btn,
            function()
                onClickSound(nil)
                onTogglePanel(nil)
            end,
            false
        )
    end
    return {entryFrame = entryFrame, entryText = entryText}
end
local function createTaskTab(self, opts)
    local ____opts_3 = opts
    local japi = ____opts_3.japi
    local tabParent = ____opts_3.tabParent
    local bgName = ____opts_3.bgName
    local tabName = ____opts_3.tabName
    local labelName = ____opts_3.labelName
    local x = ____opts_3.x
    local labelText = ____opts_3.labelText
    local category = ____opts_3.category
    local tooltip = ____opts_3.tooltip
    local FramePoint = ____opts_3.FramePoint
    local setFramePointRelative = ____opts_3.setFramePointRelative
    local setFrameSize = ____opts_3.setFrameSize
    local setFrameHoverEvents = ____opts_3.setFrameHoverEvents
    local setFrameClickEvent = ____opts_3.setFrameClickEvent
    local setButtonText = ____opts_3.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_3.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_3.setupTransparentGlueHitLayer
    local onClickSound = ____opts_3.onClickSound
    local onSwitchCategory = ____opts_3.onSwitchCategory
    local onShowTabTooltip = ____opts_3.onShowTabTooltip
    local bg = tryCreateFromFdfOnly(nil, bgName, tabParent)
    if bg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(bg)
        end
        setFramePointRelative(
            nil,
            bg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            x,
            TAB_REL_Y
        )
        setFrameSize(nil, bg, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(bg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(bg, 7)
        end
    end
    if bg then
        local tabLabel = createTabLabelTextOnBackdrop(
            nil,
            bg,
            labelName,
            labelText,
            TAB_CATEGORY_FONT_SCALE
        )
        if tabLabel and type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tabLabel, 8)
        end
    end
    local tab = tryCreateFromFdfOnly(nil, tabName, tabParent)
    if tab then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(tab)
        end
        if bg then
            setupTransparentGlueHitLayer(nil, bg, tab)
        else
            setFramePointRelative(
                nil,
                tab,
                FramePoint.TOPLEFT,
                tabParent,
                FramePoint.TOPLEFT,
                x,
                TAB_REL_Y
            )
            setFrameSize(nil, tab, {width = TAB_FRAME_W, height = TAB_FRAME_H})
        end
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(tab, true) end
            )
        end
        if not bg then
            setButtonText(nil, tab, "")
            if type(japi.DzFrameSetAlpha) == "function" then
                pcall(function () return japi.DzFrameSetAlpha(tab, 0) end
                )
            end
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tab, 9)
        end
        setFrameClickEvent(
            nil,
            tab,
            function()
                onClickSound(nil)
                onSwitchCategory(nil, category)
            end,
            false
        )
        setFrameHoverEvents(
            nil,
            tab,
            function() return onShowTabTooltip(nil, tooltip) end,
            function()
            end,
            false
        )
    end
    return {bg = bg, tab = tab}
end
function ____exports.buildTaskMainPanel(self, opts)
    local ____opts_4 = opts
    local japi = ____opts_4.japi
    local parent = ____opts_4.parent
    local entryFrame = ____opts_4.entryFrame
    local FrameType = ____opts_4.FrameType
    local FramePoint = ____opts_4.FramePoint
    local createFrame = ____opts_4.createFrame
    local setFramePosition = ____opts_4.setFramePosition
    local setFrameSize = ____opts_4.setFrameSize
    local setFramePointRelative = ____opts_4.setFramePointRelative
    local setFrameTexture = ____opts_4.setFrameTexture
    local setFrameHoverEvents = ____opts_4.setFrameHoverEvents
    local setFrameClickEvent = ____opts_4.setFrameClickEvent
    local setButtonText = ____opts_4.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_4.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_4.setupTransparentGlueHitLayer
    local onClickSound = ____opts_4.onClickSound
    local onSwitchCategory = ____opts_4.onSwitchCategory
    local onShowTabTooltip = ____opts_4.onShowTabTooltip
    local getTotalContentHeight = ____opts_4.getTotalContentHeight
    local getScrollOffset = ____opts_4.getScrollOffset
    local setScrollOffset = ____opts_4.setScrollOffset
    local isVisible = ____opts_4.isVisible
    local onScrollChanged = ____opts_4.onScrollChanged
    local mainPanel = tryCreateFromFdfOnly(nil, "TaskMainPanel", parent)
    if not mainPanel then
        return {
            mainPanel = nil,
            listContainer = nil,
            tabMainBg = nil,
            tabMain = nil,
            tabSideBg = nil,
            tabSide = nil,
            tabDailyBg = nil,
            tabDaily = nil,
            scrollBarFrame = nil,
            scrollThumbFrame = nil,
            scrollThumbHitBtn = nil,
            vScrollTrack = nil
        }
    end
    if type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(mainPanel)
    end
    if entryFrame then
        setFramePointRelative(
            nil,
            mainPanel,
            FramePoint.TOPLEFT,
            entryFrame,
            FramePoint.TOPLEFT,
            PANEL_REL_TO_ENTRY_X,
            PANEL_REL_TO_ENTRY_Y
        )
    else
        setFramePosition(nil, mainPanel, {point = FramePoint.TOPLEFT, x = ENTRY_X + PANEL_REL_TO_ENTRY_X, y = ENTRY_Y + PANEL_REL_TO_ENTRY_Y})
    end
    setFrameSize(nil, mainPanel, {width = PANEL_W, height = PANEL_H})
    local listContainer = tryCreateFromFdfOnly(nil, "TaskListContainer", mainPanel)
    if listContainer then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(listContainer)
        end
        setFramePointRelative(
            nil,
            listContainer,
            FramePoint.TOPLEFT,
            mainPanel,
            FramePoint.TOPLEFT,
            LIST_CONTAINER_REL_TO_PANEL_X,
            LIST_CONTAINER_REL_TO_PANEL_Y
        )
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(listContainer, true) end
            )
        end
    end
    local tabParent = mainPanel
    local mainResult = createTaskTab(nil, {
        japi = japi,
        tabParent = tabParent,
        bgName = "TaskTabMainBg",
        tabName = "TaskTabMain",
        labelName = "TaskTabMainLabel",
        x = 0.02,
        labelText = "|cffffcc00主线(1)|r",
        category = QuestType.MAIN,
        tooltip = "按 1 切换主线任务",
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        setFrameSize = setFrameSize,
        setFrameHoverEvents = setFrameHoverEvents,
        setFrameClickEvent = setFrameClickEvent,
        setButtonText = setButtonText,
        createTabLabelTextOnBackdrop = createTabLabelTextOnBackdrop,
        setupTransparentGlueHitLayer = setupTransparentGlueHitLayer,
        onClickSound = onClickSound,
        onSwitchCategory = onSwitchCategory,
        onShowTabTooltip = onShowTabTooltip
    })
    local sideResult = createTaskTab(nil, {
        japi = japi,
        tabParent = tabParent,
        bgName = "TaskTabSideBg",
        tabName = "TaskTabSide",
        labelName = "TaskTabSideLabel",
        x = 0.135,
        labelText = "|cffffcc00支线(2)|r",
        category = QuestType.SIDE,
        tooltip = "按 2 切换支线任务",
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        setFrameSize = setFrameSize,
        setFrameHoverEvents = setFrameHoverEvents,
        setFrameClickEvent = setFrameClickEvent,
        setButtonText = setButtonText,
        createTabLabelTextOnBackdrop = createTabLabelTextOnBackdrop,
        setupTransparentGlueHitLayer = setupTransparentGlueHitLayer,
        onClickSound = onClickSound,
        onSwitchCategory = onSwitchCategory,
        onShowTabTooltip = onShowTabTooltip
    })
    local dailyResult = createTaskTab(nil, {
        japi = japi,
        tabParent = tabParent,
        bgName = "TaskTabDailyBg",
        tabName = "TaskTabDaily",
        labelName = "TaskTabDailyLabel",
        x = 0.25,
        labelText = "|cffffcc00小任务(3)|r",
        category = QuestType.DAILY,
        tooltip = "按 3 切换小任务",
        FramePoint = FramePoint,
        setFramePointRelative = setFramePointRelative,
        setFrameSize = setFrameSize,
        setFrameHoverEvents = setFrameHoverEvents,
        setFrameClickEvent = setFrameClickEvent,
        setButtonText = setButtonText,
        createTabLabelTextOnBackdrop = createTabLabelTextOnBackdrop,
        setupTransparentGlueHitLayer = setupTransparentGlueHitLayer,
        onClickSound = onClickSound,
        onSwitchCategory = onSwitchCategory,
        onShowTabTooltip = onShowTabTooltip
    })
    local sbSrc = tryCreateFromFdfWithSource(
        nil,
        "TaskScrollBar",
        mainPanel,
        function()
            local ____createFrame_result_5 = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskScrollBarBtn",
                parent = mainPanel,
                template = "template",
                visible = true
            })
            if ____createFrame_result_5 == nil then
                ____createFrame_result_5 = 0
            end
            return ____createFrame_result_5
        end
    )
    local scrollBarFrame = sbSrc.frame
    if scrollBarFrame and scrollBarFrame ~= 0 then
        if type(japi.DzFrameShow) == "function" then
            japi.DzFrameShow(scrollBarFrame, true)
        end
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(scrollBarFrame)
        end
        setFramePointRelative(
            nil,
            scrollBarFrame,
            FramePoint.TOPRIGHT,
            mainPanel,
            FramePoint.TOPRIGHT,
            SCROLLBAR_REL_X,
            -SCROLLBAR_TOP_INSET
        )
        setFramePointRelative(
            nil,
            scrollBarFrame,
            FramePoint.BOTTOMRIGHT,
            mainPanel,
            FramePoint.BOTTOMRIGHT,
            SCROLLBAR_REL_X,
            SCROLLBAR_BOTTOM_INSET
        )
        setFrameSize(nil, scrollBarFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(scrollBarFrame, 30)
        end
    end
    local ____createFrame_result_6 = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "TaskScrollThumbDyn",
        parent = mainPanel,
        template = "template",
        visible = true
    })
    if ____createFrame_result_6 == nil then
        ____createFrame_result_6 = 0
    end
    local scrollThumbFrame = ____createFrame_result_6
    if scrollThumbFrame and scrollThumbFrame ~= 0 then
        setFrameTexture(nil, scrollThumbFrame, "UI\\Widgets\\EscMenu\\Human\\slider-knob.blp")
        setFrameSize(nil, scrollThumbFrame, {width = SCROLL_THUMB_SIZE, height = SCROLL_THUMB_SIZE})
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(scrollThumbFrame, 120)
        end
        if type(japi.DzFrameShow) == "function" then
            japi.DzFrameShow(scrollThumbFrame, true)
        end
    end
    local vScrollTrack = nil
    local scrollThumbHitBtn = nil
    if scrollThumbFrame and scrollThumbFrame ~= 0 and scrollBarFrame and scrollBarFrame ~= 0 then
        vScrollTrack = __TS__New(
            VerticalScrollbarTrack,
            {
                trackFrame = scrollBarFrame,
                thumbFrame = scrollThumbFrame,
                hitButtonName = "TaskScrollThumbHit",
                listViewHeightNorm = LIST_VIEW_H,
                trackHeightNorm = LIST_VIEW_H,
                thumbSizeNorm = SCROLL_THUMB_SIZE,
                topCompensation = SCROLL_THUMB_TOP_COMPENSATION,
                bottomCompensation = SCROLL_THUMB_BOTTOM_COMPENSATION,
                dragTick = THUMB_DRAG_TICK,
                sensitivity = THUMB_DRAG_SENSITIVITY,
                getTotalContentHeight = getTotalContentHeight,
                getScrollOffset = getScrollOffset,
                setScrollOffset = setScrollOffset,
                isInteractionEnabled = isVisible,
                onScrollChanged = onScrollChanged,
                skipManualThumbSync = function() return false end
            }
        )
        vScrollTrack:attach()
        scrollThumbHitBtn = vScrollTrack:getHitButtonFrame()
    end
    local ____mainPanel_8 = mainPanel
    local ____listContainer_9 = listContainer
    local ____mainResult_bg_10 = mainResult.bg
    local ____mainResult_tab_11 = mainResult.tab
    local ____sideResult_bg_12 = sideResult.bg
    local ____sideResult_tab_13 = sideResult.tab
    local ____dailyResult_bg_14 = dailyResult.bg
    local ____dailyResult_tab_15 = dailyResult.tab
    local ____temp_16 = scrollBarFrame or nil
    local ____scrollThumbFrame_7 = scrollThumbFrame
    if ____scrollThumbFrame_7 == nil then
        ____scrollThumbFrame_7 = nil
    end
    return {
        mainPanel = ____mainPanel_8,
        listContainer = ____listContainer_9,
        tabMainBg = ____mainResult_bg_10,
        tabMain = ____mainResult_tab_11,
        tabSideBg = ____sideResult_bg_12,
        tabSide = ____sideResult_tab_13,
        tabDailyBg = ____dailyResult_bg_14,
        tabDaily = ____dailyResult_tab_15,
        scrollBarFrame = ____temp_16,
        scrollThumbFrame = ____scrollThumbFrame_7,
        scrollThumbHitBtn = scrollThumbHitBtn,
        vScrollTrack = vScrollTrack
    }
end
return ____exports
