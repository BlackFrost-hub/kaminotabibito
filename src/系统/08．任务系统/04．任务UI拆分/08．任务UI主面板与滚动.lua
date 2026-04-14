local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENTRY_X = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_X
local ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_Y
local PANEL_REL_TO_ENTRY_X = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_REL_TO_ENTRY_X
local PANEL_REL_TO_ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_REL_TO_ENTRY_Y
local PANEL_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_W
local PANEL_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_H
local LIST_CONTAINER_REL_TO_PANEL_X = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_REL_TO_PANEL_X
local LIST_CONTAINER_REL_TO_PANEL_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_REL_TO_PANEL_Y
local SCROLLBAR_REL_X = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_REL_X
local SCROLLBAR_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_TOP_INSET
local SCROLLBAR_BOTTOM_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_BOTTOM_INSET
local SCROLLBAR_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_W
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local SCROLL_THUMB_SIZE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local THUMB_DRAG_TICK = ____01_FF0E_4EFB_52A1UI_5E38_91CF.THUMB_DRAG_TICK
local THUMB_DRAG_SENSITIVITY = ____01_FF0E_4EFB_52A1UI_5E38_91CF.THUMB_DRAG_SENSITIVITY
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local tryCreateFromFdfWithSource = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfWithSource
local ____07_FF0E_4EFB_52A1UI_5206_7C7B_6807_7B7E = require("系统.08．任务系统.04．任务UI拆分.07．任务UI分类标签")
local buildTaskPanelCategoryTabs = ____07_FF0E_4EFB_52A1UI_5206_7C7B_6807_7B7E.buildTaskPanelCategoryTabs
local ____03_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053 = require("系统.09．表现系统.03．垂直滚动条轨道")
local VerticalScrollbarTrack = ____03_FF0E_5782_76F4_6EDA_52A8_6761_8F68_9053.VerticalScrollbarTrack
--- 创建主面板及滚动区域；任一关键 FDF 缺失时返回空壳（各字段 null），上层应跳过绑定。
-- 
-- 这里不负责渲染任务行内容，只负责把“主面板壳体 + 列表容器 + 分类标签 + 滚动轨道”搭起来。
function ____exports.buildTaskMainPanel(self, opts)
    local ____opts_0 = opts
    local japi = ____opts_0.japi
    local parent = ____opts_0.parent
    local entryFrame = ____opts_0.entryFrame
    local FrameType = ____opts_0.FrameType
    local FramePoint = ____opts_0.FramePoint
    local createFrame = ____opts_0.createFrame
    local setFramePosition = ____opts_0.setFramePosition
    local setFrameSize = ____opts_0.setFrameSize
    local setFramePointRelative = ____opts_0.setFramePointRelative
    local setFrameTexture = ____opts_0.setFrameTexture
    local setFrameHoverEvents = ____opts_0.setFrameHoverEvents
    local setFrameClickEvent = ____opts_0.setFrameClickEvent
    local setButtonText = ____opts_0.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_0.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_0.setupTransparentGlueHitLayer
    local onClickSound = ____opts_0.onClickSound
    local onSwitchCategory = ____opts_0.onSwitchCategory
    local onShowTabTooltip = ____opts_0.onShowTabTooltip
    local getTotalContentHeight = ____opts_0.getTotalContentHeight
    local getScrollOffset = ____opts_0.getScrollOffset
    local setScrollOffset = ____opts_0.setScrollOffset
    local isVisible = ____opts_0.isVisible
    local onScrollChanged = ____opts_0.onScrollChanged
    local empty = {
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
    local mainPanel = tryCreateFromFdfOnly(nil, "TaskMainPanel", parent)
    if not mainPanel then
        return empty
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
    local tabs = buildTaskPanelCategoryTabs(nil, {
        japi = japi,
        tabParent = mainPanel,
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
            local ____createFrame_result_1 = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskScrollBarBtn",
                parent = mainPanel,
                template = "template",
                visible = true
            })
            if ____createFrame_result_1 == nil then
                ____createFrame_result_1 = 0
            end
            local f = ____createFrame_result_1
            return f
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
    local ____createFrame_result_2 = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "TaskScrollThumbDyn",
        parent = mainPanel,
        template = "template",
        visible = true
    })
    if ____createFrame_result_2 == nil then
        ____createFrame_result_2 = 0
    end
    local scrollThumbFrame = ____createFrame_result_2
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
    local ____mainPanel_4 = mainPanel
    local ____listContainer_5 = listContainer
    local ____tabs_tabMainBg_6 = tabs.tabMainBg
    local ____tabs_tabMain_7 = tabs.tabMain
    local ____tabs_tabSideBg_8 = tabs.tabSideBg
    local ____tabs_tabSide_9 = tabs.tabSide
    local ____tabs_tabDailyBg_10 = tabs.tabDailyBg
    local ____tabs_tabDaily_11 = tabs.tabDaily
    local ____temp_12 = scrollBarFrame or nil
    local ____scrollThumbFrame_3 = scrollThumbFrame
    if ____scrollThumbFrame_3 == nil then
        ____scrollThumbFrame_3 = nil
    end
    return {
        mainPanel = ____mainPanel_4,
        listContainer = ____listContainer_5,
        tabMainBg = ____tabs_tabMainBg_6,
        tabMain = ____tabs_tabMain_7,
        tabSideBg = ____tabs_tabSideBg_8,
        tabSide = ____tabs_tabSide_9,
        tabDailyBg = ____tabs_tabDailyBg_10,
        tabDaily = ____tabs_tabDaily_11,
        scrollBarFrame = ____temp_12,
        scrollThumbFrame = ____scrollThumbFrame_3,
        scrollThumbHitBtn = scrollThumbHitBtn,
        vScrollTrack = vScrollTrack
    }
end
return ____exports
