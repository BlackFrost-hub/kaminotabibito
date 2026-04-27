--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local refreshAllUi, registerKey, dispatchTabKey, onTabKeyDown, onTabKeyUp, registerDamagePanelHotkeys, dispatchFocusHotkey, dispatchFocusTriggeredKey, registerFocusHotkeys, onRefreshLoopTick, startRefreshLoop, jass, registerKeyEventRawStatus, getTriggerKey, getTriggerKeyPlayer, onTick10ms, offTick10ms, _____5E38_91CF, createUiFrames, focusHeroByFunctionKey, showDamagePanel, updateDamagePanel, updateDetailPanels, panCameraToTimedForPlayer, initialized, refreshAccumulator, startupTickHandler
function refreshAllUi()
    updateDamagePanel()
    updateDetailPanels()
end
function registerKey(status, keyCode, action)
    registerKeyEventRawStatus(
        nil,
        keyCode,
        status,
        true,
        action
    )
end
function dispatchTabKey(show)
    if getTriggerKeyPlayer(nil) ~= jass.GetLocalPlayer() then
        return
    end
    showDamagePanel(show)
end
function onTabKeyDown()
    dispatchTabKey(true)
end
function onTabKeyUp()
    dispatchTabKey(false)
end
function registerDamagePanelHotkeys()
    registerKey(_____5E38_91CF.KEY_EVENT_DOWN, _____5E38_91CF.KEY_TAB, onTabKeyDown)
    registerKey(_____5E38_91CF.KEY_EVENT_UP, _____5E38_91CF.KEY_TAB, onTabKeyUp)
end
function dispatchFocusHotkey(keyCode)
    local p = getTriggerKeyPlayer(nil)
    if p == nil then
        return
    end
    local hero = focusHeroByFunctionKey(keyCode)
    if hero == nil then
        return
    end
    panCameraToTimedForPlayer(
        nil,
        p,
        jass.GetUnitX(hero),
        jass.GetUnitY(hero),
        0.05
    )
end
function dispatchFocusTriggeredKey()
    dispatchFocusHotkey(getTriggerKey(nil))
end
function registerFocusHotkeys()
    do
        local i = 0
        while i < #_____5E38_91CF.KEY_F do
            local functionKey = _____5E38_91CF.KEY_F[i + 1]
            registerKey(_____5E38_91CF.KEY_EVENT_UP, functionKey, dispatchFocusTriggeredKey)
            i = i + 1
        end
    end
end
function onRefreshLoopTick()
    refreshAccumulator = refreshAccumulator + 0.01
    if refreshAccumulator + 0.0001 < _____5E38_91CF.REFRESH_INTERVAL_SECONDS then
        return
    end
    refreshAccumulator = 0
    refreshAllUi()
end
function startRefreshLoop()
    onTick10ms(nil, onRefreshLoopTick)
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
        offTick10ms(nil, startupTickHandler)
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
local _____786C_4EF6_51FD_6570 = require("系统.00．核心系统.02．硬件函数")
local _____4E2D_5FC3_8BA1_65F6_5668 = _G
registerKeyEventRawStatus = _____786C_4EF6_51FD_6570.registerKeyEventRawStatus
getTriggerKey = _____786C_4EF6_51FD_6570.getTriggerKey
getTriggerKeyPlayer = _____786C_4EF6_51FD_6570.getTriggerKeyPlayer
onTick10ms = _____4E2D_5FC3_8BA1_65F6_5668.onTick10ms
offTick10ms = _____4E2D_5FC3_8BA1_65F6_5668.offTick10ms
_____5E38_91CF = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
createUiFrames = ____require_result_0.createUiFrames
focusHeroByFunctionKey = ____require_result_0.focusHeroByFunctionKey
local _onPlayerHeroRegistered = ____require_result_0.onPlayerHeroRegistered
showDamagePanel = ____require_result_0.showDamagePanel
updateDamagePanel = ____require_result_0.updateDamagePanel
updateDetailPanels = ____require_result_0.updateDetailPanels
local ____Star_6269_5C55_5E93 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
panCameraToTimedForPlayer = ____Star_6269_5C55_5E93.StarOther_PanCameraToTimedForPlayer
initialized = false
local startupScheduled = false
local startupAccumulator = 0
refreshAccumulator = 0
startupTickHandler = nil
local function onStartupTick()
    if initialized then
        return
    end
    startupAccumulator = startupAccumulator + 0.01
    if startupAccumulator + 0.0001 < _____5E38_91CF.INIT_DELAY_SECONDS then
        return
    end
    ____exports.initUiAttributeSystem()
end
--- 独立安排 UI 启动时机。
local function scheduleUiStartup()
    if startupScheduled then
        return
    end
    startupScheduled = true
    startupTickHandler = onStartupTick
    onTick10ms(nil, startupTickHandler)
end
function ____exports.isUiAttributeSystemEnabled()
    return _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED
end
--- 玩家英雄注册回调。
-- 由玩家系统调用，每注册一个玩家英雄就创建一个UI槽位。
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if type(_onPlayerHeroRegistered) == "function" then
        _onPlayerHeroRegistered(whichPlayer, whichHero)
    end
end
if _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED then
    scheduleUiStartup()
end
return ____exports
