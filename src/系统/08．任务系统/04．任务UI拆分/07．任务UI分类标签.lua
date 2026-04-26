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
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
local pcallDzFrameSetAlpha = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameSetAlpha
--- 主面板顶部分类标签（主线 / 支线 / 小任务）
-- 
-- 架构：全局1套UI，不再区分 slotPid。
local jass = require("jass.common")
local japi = require("jass.japi")
--- 用 Record 固定三类槽位，避免 Map 弱序/迭代习惯
local categoryTabClickHandlers = {}
local currentTooltipMessage = nil
local currentTooltipHandler = nil
local function handleCategoryTabClick(self, category)
    local handler = categoryTabClickHandlers[category]
    if not handler then
        return
    end
    handler:onSwitchCategory(category)
    local ____temp_0
    if type(japi.DzGetTriggerKeyPlayer) == "function" then
        ____temp_0 = japi.DzGetTriggerKeyPlayer()
    else
        ____temp_0 = jass.GetLocalPlayer()
    end
    local triggerPlayer = ____temp_0
    if triggerPlayer == jass.GetLocalPlayer() then
        handler:onClickSound()
    end
end
local function onMainTabClick(self)
    handleCategoryTabClick(nil, QuestType.MAIN)
end
local function onSideTabClick(self)
    handleCategoryTabClick(nil, QuestType.SIDE)
end
local function onDailyTabClick(self)
    handleCategoryTabClick(nil, QuestType.DAILY)
end
local function onTabHoverShow(self)
    if currentTooltipHandler and currentTooltipMessage then
        currentTooltipHandler(nil, currentTooltipMessage)
    end
end
local function onTabHoverHide(self)
end
local tabClickHandlers = {[QuestType.MAIN] = onMainTabClick, [QuestType.SIDE] = onSideTabClick, [QuestType.DAILY] = onDailyTabClick}
local function registerCategoryTabClickHandler(self, category, onSwitchCategory, onClickSound)
    categoryTabClickHandlers[category] = {onSwitchCategory = onSwitchCategory, onClickSound = onClickSound}
end
local function createTaskTab(self, opts)
    local ____opts_1 = opts
    local japi = ____opts_1.japi
    local tabParent = ____opts_1.tabParent
    local bgName = ____opts_1.bgName
    local tabName = ____opts_1.tabName
    local labelName = ____opts_1.labelName
    local x = ____opts_1.x
    local labelText = ____opts_1.labelText
    local category = ____opts_1.category
    local tooltip = ____opts_1.tooltip
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
        pcallDzFrameShow(nil, japi, bg, true)
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
        pcallDzFrameShow(nil, japi, tab, true)
        if not bg then
            setButtonText(nil, tab, "")
            pcallDzFrameSetAlpha(nil, japi, tab, 0)
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tab, 9)
        end
        registerCategoryTabClickHandler(nil, category, onSwitchCategory, onClickSound)
        currentTooltipMessage = tooltip
        currentTooltipHandler = onShowTabTooltip
        setFrameClickEvent(nil, tab, tabClickHandlers[category], true)
        setFrameHoverEvents(
            nil,
            tab,
            onTabHoverShow,
            onTabHoverHide,
            false
        )
    end
    return {bg = bg, tab = tab}
end
function ____exports.buildTaskPanelCategoryTabs(self, opts)
    local ____opts_2 = opts
    local japi = ____opts_2.japi
    local tabParent = ____opts_2.tabParent
    local FramePoint = ____opts_2.FramePoint
    local setFramePointRelative = ____opts_2.setFramePointRelative
    local setFrameSize = ____opts_2.setFrameSize
    local setFrameHoverEvents = ____opts_2.setFrameHoverEvents
    local setFrameClickEvent = ____opts_2.setFrameClickEvent
    local setButtonText = ____opts_2.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_2.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_2.setupTransparentGlueHitLayer
    local onClickSound = ____opts_2.onClickSound
    local onSwitchCategory = ____opts_2.onSwitchCategory
    local onShowTabTooltip = ____opts_2.onShowTabTooltip
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
            tooltip = "切换到主线任务"
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
            tooltip = "切换到支线任务"
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
            tooltip = "切换到小任务"
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
