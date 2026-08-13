--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
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
local ENABLE_TASK_UI_RIGHT_SCROLLBAR = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_RIGHT_SCROLLBAR
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local tryCreateFromFdfWithSource = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfWithSource
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
local ____06_FF0E_4EFB_52A1UI_5206_7C7B_6807_7B7E = require("系统.08．任务系统.02．任务UI拆分.06．任务UI分类标签")
local buildTaskPanelCategoryTabs = ____06_FF0E_4EFB_52A1UI_5206_7C7B_6807_7B7E.buildTaskPanelCategoryTabs
--- 任务主面板壳体 + 列表容器 + 右侧滚动条
-- 
-- 架构：全局1套UI，不再区分 slotPid。
local japi = require("jass.japi")
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
    local slotId = ____opts_0.slotId
    local contextId = ____opts_0.contextId
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
        scrollBarHitBtn = nil,
        scrollThumbFrame = nil,
        scrollThumbHitBtn = nil
    }
    local mainPanel = tryCreateFromFdfOnly(nil, "TaskMainPanel", parent)
    if not mainPanel then
        return empty
    end
    japi:DzFrameSetPriority(mainPanel, 200)
    japi:DzFrameClearAllPoints(mainPanel)
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
        japi:DzFrameClearAllPoints(listContainer)
        setFramePointRelative(
            nil,
            listContainer,
            FramePoint.TOPLEFT,
            mainPanel,
            FramePoint.TOPLEFT,
            LIST_CONTAINER_REL_TO_PANEL_X,
            LIST_CONTAINER_REL_TO_PANEL_Y
        )
        pcallDzFrameShow(nil, listContainer, true)
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
        onShowTabTooltip = onShowTabTooltip,
        slotId = slotId,
        contextId = contextId
    })
    local scrollBarFrame = nil
    local scrollBarHitBtn = nil
    local scrollThumbFrame = nil
    local scrollThumbHitBtn = nil
    if ENABLE_TASK_UI_RIGHT_SCROLLBAR then
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
        scrollBarFrame = sbSrc.frame
        if scrollBarFrame and scrollBarFrame ~= 0 then
            japi:DzFrameShow(scrollBarFrame, true)
            japi:DzFrameClearAllPoints(scrollBarFrame)
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
            local ____createFrame_result_2 = createFrame(nil, {
                type = FrameType.GLUETEXTBUTTON,
                name = "TaskScrollBarHitDyn",
                parent = mainPanel,
                template = "template",
                visible = true
            })
            if ____createFrame_result_2 == nil then
                ____createFrame_result_2 = 0
            end
            scrollBarHitBtn = ____createFrame_result_2
            if scrollBarHitBtn and scrollBarHitBtn ~= 0 then
                setupTransparentGlueHitLayer(nil, scrollBarFrame, scrollBarHitBtn)
                japi:DzFrameShow(scrollBarHitBtn, true)
            end
        end
        local ____createFrame_result_3 = createFrame(nil, {
            type = FrameType.BACKDROP,
            name = "TaskScrollThumbDyn",
            parent = mainPanel,
            template = "template",
            visible = true
        })
        if ____createFrame_result_3 == nil then
            ____createFrame_result_3 = 0
        end
        scrollThumbFrame = ____createFrame_result_3
        if scrollThumbFrame and scrollThumbFrame ~= 0 then
            setFrameTexture(nil, scrollThumbFrame, "UI\\Widgets\\EscMenu\\Human\\slider-knob.blp")
            setFrameSize(nil, scrollThumbFrame, {width = SCROLL_THUMB_SIZE, height = SCROLL_THUMB_SIZE})
            if scrollBarFrame and scrollBarFrame ~= 0 then
                setFramePointRelative(
                    nil,
                    scrollThumbFrame,
                    FramePoint.TOPLEFT,
                    scrollBarFrame,
                    FramePoint.TOPLEFT,
                    (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5,
                    0
                )
            end
            japi:DzFrameShow(scrollThumbFrame, true)
            local ____createFrame_result_4 = createFrame(nil, {
                type = FrameType.GLUETEXTBUTTON,
                name = "TaskScrollThumbHitDyn",
                parent = mainPanel,
                template = "template",
                visible = true
            })
            if ____createFrame_result_4 == nil then
                ____createFrame_result_4 = 0
            end
            scrollThumbHitBtn = ____createFrame_result_4
            if scrollThumbHitBtn and scrollThumbHitBtn ~= 0 then
                setupTransparentGlueHitLayer(nil, scrollThumbFrame, scrollThumbHitBtn)
                japi:DzFrameShow(scrollThumbHitBtn, true)
            end
        end
    end
    local result = {
        mainPanel = mainPanel,
        listContainer = listContainer,
        tabMainBg = tabs.tabMainBg,
        tabMain = tabs.tabMain,
        tabSideBg = tabs.tabSideBg,
        tabSide = tabs.tabSide,
        tabDailyBg = tabs.tabDailyBg,
        tabDaily = tabs.tabDaily,
        scrollBarFrame = scrollBarFrame or nil,
        scrollBarHitBtn = scrollBarHitBtn or nil,
        scrollThumbFrame = scrollThumbFrame or nil,
        scrollThumbHitBtn = scrollThumbHitBtn
    }
    return result
end
return ____exports
