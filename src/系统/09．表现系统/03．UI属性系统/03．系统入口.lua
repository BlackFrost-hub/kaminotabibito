--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local refreshAllUi, registerKey, registerDamagePanelHotkeys, registerFocusHotkeys, startRefreshLoop, jass, _____786C_4EF6_51FD_6570, _____4E2D_5FC3_8BA1_65F6_5668, _____5E38_91CF, createUiFrames, focusHeroByFunctionKey, showDamagePanel, updateDamagePanel, updateDetailPanels, ____Star_6269_5C55_5E93, initialized, refreshAccumulator, startupTickHandler
function refreshAllUi()
    updateDamagePanel()
    updateDetailPanels()
end
function registerKey(status, keyCode, action)
    _____786C_4EF6_51FD_6570:registerKeyEventRawStatus(keyCode, status, false, action)
end
function registerDamagePanelHotkeys()
    registerKey(
        _____5E38_91CF.KEY_EVENT_DOWN,
        _____5E38_91CF.KEY_TAB,
        function()
            if _____786C_4EF6_51FD_6570:getTriggerKeyPlayer() ~= jass.GetLocalPlayer() then
                return
            end
            showDamagePanel(true)
        end
    )
    registerKey(
        _____5E38_91CF.KEY_EVENT_UP,
        _____5E38_91CF.KEY_TAB,
        function()
            if _____786C_4EF6_51FD_6570:getTriggerKeyPlayer() ~= jass.GetLocalPlayer() then
                return
            end
            showDamagePanel(false)
        end
    )
end
function registerFocusHotkeys()
    do
        local i = 0
        while i < #_____5E38_91CF.KEY_F do
            local functionKey = _____5E38_91CF.KEY_F[i + 1]
            registerKey(
                _____5E38_91CF.KEY_EVENT_UP,
                functionKey,
                function()
                    local p = _____786C_4EF6_51FD_6570:getTriggerKeyPlayer()
                    if p == nil then
                        return
                    end
                    local hero = focusHeroByFunctionKey(functionKey)
                    if hero == nil then
                        return
                    end
                    ____Star_6269_5C55_5E93:StarOther_PanCameraToTimedForPlayer(
                        p,
                        jass.GetUnitX(hero),
                        jass.GetUnitY(hero),
                        0.05
                    )
                end
            )
            i = i + 1
        end
    end
end
function startRefreshLoop()
    _____4E2D_5FC3_8BA1_65F6_5668:onTick10ms(function()
        refreshAccumulator = refreshAccumulator + 0.01
        if refreshAccumulator + 0.0001 < _____5E38_91CF.REFRESH_INTERVAL_SECONDS then
            return
        end
        refreshAccumulator = 0
        refreshAllUi()
    end)
end
--- UI属性系统总入口。
function ____exports.initUiAttributeSystem()
    if not _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED then
        return
    end
    if initialized then
        return
    end
    if startupTickHandler ~= nil then
        _____4E2D_5FC3_8BA1_65F6_5668:offTick10ms(startupTickHandler)
        startupTickHandler = nil
    end
    initialized = true
    createUiFrames()
    refreshAllUi()
    registerDamagePanelHotkeys()
    registerFocusHotkeys()
    startRefreshLoop()
end
jass = require("jass.common")
_____786C_4EF6_51FD_6570 = require("系统.00．核心系统.02．硬件函数")
_____4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
_____5E38_91CF = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
createUiFrames = ____require_result_0.createUiFrames
focusHeroByFunctionKey = ____require_result_0.focusHeroByFunctionKey
showDamagePanel = ____require_result_0.showDamagePanel
updateDamagePanel = ____require_result_0.updateDamagePanel
updateDetailPanels = ____require_result_0.updateDetailPanels
____Star_6269_5C55_5E93 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
initialized = false
local startupScheduled = false
local startupAccumulator = 0
refreshAccumulator = 0
startupTickHandler = nil
--- 独立安排 UI 启动时机。
local function scheduleUiStartup()
    if startupScheduled then
        return
    end
    startupScheduled = true
    startupTickHandler = function()
        if initialized then
            return
        end
        startupAccumulator = startupAccumulator + 0.01
        if startupAccumulator + 0.0001 < _____5E38_91CF.INIT_DELAY_SECONDS then
            return
        end
        ____exports.initUiAttributeSystem()
    end
    _____4E2D_5FC3_8BA1_65F6_5668:onTick10ms(startupTickHandler)
end
function ____exports.isUiAttributeSystemEnabled()
    return _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED
end
if _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED then
    scheduleUiStartup()
end
return ____exports
