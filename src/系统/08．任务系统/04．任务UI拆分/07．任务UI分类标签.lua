local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local TAB_REL_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_REL_Y
local TAB_FRAME_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_FRAME_W
local TAB_FRAME_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_FRAME_H
local TAB_CATEGORY_FONT_SCALE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_CATEGORY_FONT_SCALE
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
--- 创建一组标签：背景（若 FDF 存在）、Dz 文字、点击切分类、悬停 tooltip。
local function createTaskTab(self, opts)
    local ____opts_0 = opts
    local japi = ____opts_0.japi
    local tabParent = ____opts_0.tabParent
    local bgName = ____opts_0.bgName
    local tabName = ____opts_0.tabName
    local labelName = ____opts_0.labelName
    local x = ____opts_0.x
    local labelText = ____opts_0.labelText
    local category = ____opts_0.category
    local tooltip = ____opts_0.tooltip
    local FramePoint = ____opts_0.FramePoint
    local setFramePointRelative = ____opts_0.setFramePointRelative
    local setFrameSize = ____opts_0.setFrameSize
    local setFrameHoverEvents = ____opts_0.setFrameHoverEvents
    local setFrameClickEvent = ____opts_0.setFrameClickEvent
    local setButtonText = ____opts_0.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_0.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_0.setupTransparentGlueHitLayer
    local onClickSound = ____opts_0.onClickSound
    local onSwitchCategory = ____opts_0.onSwitchCategory
    local onShowTabTooltip = ____opts_0.onShowTabTooltip
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
--- 在主面板上铺好三个分类标签；x 位置与热键 1/2/3、文案「主线(1)」等保持一致。
function ____exports.buildTaskPanelCategoryTabs(self, opts)
    local ____opts_1 = opts
    local japi = ____opts_1.japi
    local tabParent = ____opts_1.tabParent
    local FramePoint = ____opts_1.FramePoint
    local setFramePointRelative = ____opts_1.setFramePointRelative
    local setFrameSize = ____opts_1.setFrameSize
    local setFrameHoverEvents = ____opts_1.setFrameHoverEvents
    local setFrameClickEvent = ____opts_1.setFrameClickEvent
    local setButtonText = ____opts_1.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_1.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_1.setupTransparentGlueHitLayer
    local onClickSound = ____opts_1.onClickSound
    local onSwitchCategory = ____opts_1.onSwitchCategory
    local onShowTabTooltip = ____opts_1.onShowTabTooltip
    local common = {
        japi = japi,
        tabParent = tabParent,
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
    }
    local mainResult = createTaskTab(
        nil,
        __TS__ObjectAssign({}, common, {
            bgName = "TaskTabMainBg",
            tabName = "TaskTabMain",
            labelName = "TaskTabMainLabel",
            x = 0.02,
            labelText = "|cffffcc00主线(1)|r",
            category = QuestType.MAIN,
            tooltip = "按 1 切换主线任务"
        })
    )
    local sideResult = createTaskTab(
        nil,
        __TS__ObjectAssign({}, common, {
            bgName = "TaskTabSideBg",
            tabName = "TaskTabSide",
            labelName = "TaskTabSideLabel",
            x = 0.135,
            labelText = "|cffffcc00支线(2)|r",
            category = QuestType.SIDE,
            tooltip = "按 2 切换支线任务"
        })
    )
    local dailyResult = createTaskTab(
        nil,
        __TS__ObjectAssign({}, common, {
            bgName = "TaskTabDailyBg",
            tabName = "TaskTabDaily",
            labelName = "TaskTabDailyLabel",
            x = 0.25,
            labelText = "|cffffcc00小任务(3)|r",
            category = QuestType.DAILY,
            tooltip = "按 3 切换小任务"
        })
    )
    return {
        tabMainBg = mainResult.bg,
        tabMain = mainResult.tab,
        tabSideBg = sideResult.bg,
        tabSide = sideResult.tab,
        tabDailyBg = dailyResult.bg,
        tabDaily = dailyResult.tab
    }
end
return ____exports
