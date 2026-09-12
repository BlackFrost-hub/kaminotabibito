local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local TAB_REL_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_REL_Y
local TAB_FRAME_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_FRAME_W
local TAB_FRAME_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_FRAME_H
local TAB_CATEGORY_FONT_SCALE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TAB_CATEGORY_FONT_SCALE
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
local pcallDzFrameSetAlpha = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameSetAlpha
--- 主面板顶部分类标签（主线 / 支线 / 小任务）
-- 
-- 架构：N 槽分类标签；同步点击按触发玩家选槽，只在所属玩家本机显示。
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local categoryFrameDiagnosticCount = 0
--- 用 Record 固定三类槽位，避免 Map 弱序/迭代习惯
local categoryTabClickHandlers = {}
local tabTooltipByFrameId = {}
local function handleCategoryTabClick(self, category)
    if categoryFrameDiagnosticCount < 3 then
        local frame = japi.DzGetTriggerUIEventFrame()
        local uiPlayer = japi.DzGetTriggerUIEventPlayer()
        local keyPlayer = japi.DzGetTriggerKeyPlayer()
        categoryFrameDiagnosticCount = categoryFrameDiagnosticCount + 1
        debugLogForce(
            "任务UI-Frame对照",
            "分类同步点击",
            "category",
            category,
            "frame",
            frame,
            "uiPid",
            (uiPlayer == nil or uiPlayer == 0) and -1 or jass.GetPlayerId(uiPlayer),
            "keyPid",
            (keyPlayer == nil or keyPlayer == 0) and -1 or jass.GetPlayerId(keyPlayer)
        )
    end
    local handler = categoryTabClickHandlers[category]
    if not handler then
        return
    end
    local onSwitchCategory = handler.onSwitchCategory
    onSwitchCategory(category)
    local triggerPlayer = japi.DzGetTriggerKeyPlayer()
    if triggerPlayer == jass.GetLocalPlayer() then
        local onClickSound = handler.onClickSound
        onClickSound()
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
    if japi.DzGetTriggerKeyPlayer() ~= jass.GetLocalPlayer() then
        return
    end
    local ____this_2
    ____this_2 = japi
    local ____opt_1 = ____this_2.DzGetTriggerUIEventFrame
    if ____opt_1 ~= nil then
        ____opt_1 = ____opt_1(____this_2)
    end
    local ____opt_1_3 = ____opt_1
    if ____opt_1_3 == nil then
        ____opt_1_3 = 0
    end
    local frame = ____opt_1_3
    if not frame then
        local ____this_5
        ____this_5 = japi
        local ____opt_4 = ____this_5.DzGetMouseFocus
        if ____opt_4 ~= nil then
            ____opt_4 = ____opt_4(____this_5)
        end
        local ____opt_4_6 = ____opt_4
        if ____opt_4_6 == nil then
            ____opt_4_6 = 0
        end
        frame = ____opt_4_6
    end
    local ____frame_7
    if frame then
        ____frame_7 = tabTooltipByFrameId[frame]
    else
        ____frame_7 = nil
    end
    local entry = ____frame_7
    if not entry or not entry.handler or entry.msg == "" then
        return
    end
    entry:handler(entry.msg)
end
local function onTabHoverHide(self)
end
local tabClickHandlers = {[QuestType.MAIN] = onMainTabClick, [QuestType.SIDE] = onSideTabClick, [QuestType.DAILY] = onDailyTabClick}
local function registerCategoryTabClickHandler(self, category, onSwitchCategory, onClickSound)
    categoryTabClickHandlers[category] = {onSwitchCategory = onSwitchCategory, onClickSound = onClickSound}
end
local function createTaskTab(self, opts)
    local ____opts_8 = opts
    local japi = ____opts_8.japi
    local tabParent = ____opts_8.tabParent
    local bgName = ____opts_8.bgName
    local tabName = ____opts_8.tabName
    local labelName = ____opts_8.labelName
    local x = ____opts_8.x
    local labelText = ____opts_8.labelText
    local category = ____opts_8.category
    local tooltip = ____opts_8.tooltip
    local FramePoint = ____opts_8.FramePoint
    local setFramePointRelative = ____opts_8.setFramePointRelative
    local setFrameSize = ____opts_8.setFrameSize
    local setFrameHoverEvents = ____opts_8.setFrameHoverEvents
    local setFrameClickEvent = ____opts_8.setFrameClickEvent
    local setButtonText = ____opts_8.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_8.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_8.setupTransparentGlueHitLayer
    local onClickSound = ____opts_8.onClickSound
    local onSwitchCategory = ____opts_8.onSwitchCategory
    local onShowTabTooltip = ____opts_8.onShowTabTooltip
    local contextId = ____opts_8.contextId
    local nameSuffix = ____opts_8.nameSuffix
    local bg = tryCreateFromFdfOnly(nil, bgName, tabParent, contextId)
    if bg then
        japi.DzFrameClearAllPoints(bg)
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
        pcallDzFrameShow(nil, bg, true)
    end
    if bg then
        createTabLabelTextOnBackdrop(
            nil,
            bg,
            labelName .. nameSuffix,
            labelText,
            TAB_CATEGORY_FONT_SCALE
        )
    end
    local tab = tryCreateFromFdfOnly(nil, tabName, tabParent, contextId)
    if tab then
        japi.DzFrameClearAllPoints(tab)
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
        pcallDzFrameShow(nil, tab, true)
        if not bg then
            setButtonText(nil, tab, "")
            pcallDzFrameSetAlpha(nil, tab, 0)
        end
        registerCategoryTabClickHandler(nil, category, onSwitchCategory, onClickSound)
        tabTooltipByFrameId[tab] = {msg = tooltip, handler = onShowTabTooltip}
        setFrameClickEvent(nil, tab, tabClickHandlers[category], true)
        setFrameHoverEvents(
            nil,
            tab,
            onTabHoverShow,
            onTabHoverHide,
            true
        )
    end
    return {bg = bg, tab = tab}
end
function ____exports.buildTaskPanelCategoryTabs(self, opts)
    local ____opts_9 = opts
    local japi = ____opts_9.japi
    local tabParent = ____opts_9.tabParent
    local FramePoint = ____opts_9.FramePoint
    local setFramePointRelative = ____opts_9.setFramePointRelative
    local setFrameSize = ____opts_9.setFrameSize
    local setFrameHoverEvents = ____opts_9.setFrameHoverEvents
    local setFrameClickEvent = ____opts_9.setFrameClickEvent
    local setButtonText = ____opts_9.setButtonText
    local createTabLabelTextOnBackdrop = ____opts_9.createTabLabelTextOnBackdrop
    local setupTransparentGlueHitLayer = ____opts_9.setupTransparentGlueHitLayer
    local onClickSound = ____opts_9.onClickSound
    local onSwitchCategory = ____opts_9.onSwitchCategory
    local onShowTabTooltip = ____opts_9.onShowTabTooltip
    local slotId = ____opts_9.slotId
    local contextId = ____opts_9.contextId
    local nameSuffix = "_s" .. tostring(slotId)
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
        onShowTabTooltip = onShowTabTooltip,
        contextId = contextId,
        nameSuffix = nameSuffix
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
