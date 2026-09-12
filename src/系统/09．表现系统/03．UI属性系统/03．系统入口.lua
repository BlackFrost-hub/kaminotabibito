local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local refreshAllUi, dispatchTabKey, onTabKeyDown, onTabKeyUp, registerDamagePanelHotkeys, registerFocusHotkeys, onRefreshLoopTick, startRefreshLoop, finishUiAttributeSystemInitialization, jass, getTriggerKeyPlayer, onTick10ms, offTick10ms, _____5E38_91CF, createUiFrames, _onPlayerHeroRegistered, setUiRendererReady, showDamagePanel, updateDamagePanel, updateDetailPanels, initialized, refreshAccumulator, startupTickHandler, pendingHeroRegistrations, ____F_952E_56DE_8C03
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local registerKeyEventByCode = ____index.registerKeyEventByCode
function refreshAllUi()
    updateDamagePanel()
    updateDetailPanels()
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
    registerKeyEventByCode(
        nil,
        _____5E38_91CF.KEY_TAB,
        _____5E38_91CF.KEY_EVENT_DOWN,
        false,
        onTabKeyDown
    )
    registerKeyEventByCode(
        nil,
        _____5E38_91CF.KEY_TAB,
        _____5E38_91CF.KEY_EVENT_UP,
        false,
        onTabKeyUp
    )
end
function registerFocusHotkeys()
    do
        local i = 0
        while i < #_____5E38_91CF.KEY_F do
            local functionKey = _____5E38_91CF.KEY_F[i + 1]
            registerKeyEventByCode(
                nil,
                functionKey,
                _____5E38_91CF.KEY_EVENT_UP,
                false,
                ____F_952E_56DE_8C03[i + 1]
            )
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
    onTick10ms(onRefreshLoopTick)
end
function finishUiAttributeSystemInitialization()
    if not _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED or initialized then
        return
    end
    if startupTickHandler ~= nil then
        offTick10ms(startupTickHandler)
        startupTickHandler = nil
    end
    setUiRendererReady(true)
    createUiFrames()
    refreshAllUi()
    initialized = true
    registerDamagePanelHotkeys()
    registerFocusHotkeys()
    startRefreshLoop()
    do
        local i = 0
        while i < #pendingHeroRegistrations do
            local registration = pendingHeroRegistrations[i + 1]
            _onPlayerHeroRegistered(registration.player, registration.hero)
            i = i + 1
        end
    end
    __TS__ArraySetLength(pendingHeroRegistrations, 0)
end
jass = require("jass.common")
local _____786C_4EF6_51FD_6570 = require("系统.00．核心系统.02．硬件函数")
local _____4E2D_5FC3_8BA1_65F6_5668 = _G
local registerKeyEventRawStatus = _____786C_4EF6_51FD_6570.registerKeyEventRawStatus
local getTriggerKey = _____786C_4EF6_51FD_6570.getTriggerKey
getTriggerKeyPlayer = _____786C_4EF6_51FD_6570.getTriggerKeyPlayer
onTick10ms = _____4E2D_5FC3_8BA1_65F6_5668.onTick10ms
offTick10ms = _____4E2D_5FC3_8BA1_65F6_5668.offTick10ms
_____5E38_91CF = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
createUiFrames = ____require_result_0.createUiFrames
local focusHeroByFunctionKey = ____require_result_0.focusHeroByFunctionKey
_onPlayerHeroRegistered = ____require_result_0.onPlayerHeroRegistered
setUiRendererReady = ____require_result_0.setUiRendererReady
showDamagePanel = ____require_result_0.showDamagePanel
updateDamagePanel = ____require_result_0.updateDamagePanel
updateDetailPanels = ____require_result_0.updateDetailPanels
local ____Star_6269_5C55_5E93 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local panCameraToTimedForPlayer = ____Star_6269_5C55_5E93.StarOther_PanCameraToTimedForPlayer
initialized = false
local startupScheduled = false
local startupAccumulator = 0
refreshAccumulator = 0
startupTickHandler = nil
pendingHeroRegistrations = {}
--- 包一层按键注册：sync=true 全房对称；Tab 显隐在 action 内自行做本地玩家门控。
local function registerKey(status, keyCode, action)
    registerKeyEventRawStatus(
        nil,
        keyCode,
        status,
        true,
        action
    )
end
--- 模块级分发函数：F2-F6 跳镜头统一入口（避免匿名闭包）
local function dispatchFocusHotkey(keyCode)
    local p = jass.GetLocalPlayer()
    if p == nil then
        return
    end
    local hero = focusHeroByFunctionKey(keyCode)
    if hero == nil then
        return
    end
    panCameraToTimedForPlayer(
        p,
        jass.GetUnitX(hero),
        jass.GetUnitY(hero),
        0.05
    )
end
local function onF2()
    dispatchFocusHotkey(113)
end
local function onF3()
    dispatchFocusHotkey(114)
end
local function onF4()
    dispatchFocusHotkey(115)
end
local function onF5()
    dispatchFocusHotkey(116)
end
local function onF6()
    dispatchFocusHotkey(117)
end
____F_952E_56DE_8C03 = {
    onF2,
    onF3,
    onF4,
    onF5,
    onF6
}
local function onStartupTick()
    if initialized then
        return
    end
    startupAccumulator = startupAccumulator + 0.01
    if startupAccumulator + 0.0001 < _____5E38_91CF.INIT_DELAY_SECONDS then
        return
    end
    finishUiAttributeSystemInitialization()
end
--- 独立安排 UI 启动时机。
local function scheduleUiStartup()
    if startupScheduled then
        return
    end
    startupScheduled = true
    startupTickHandler = onStartupTick
    onTick10ms(startupTickHandler)
end
--- UI属性系统总入口：只安排延迟启动，避免外部初始化入口绕过 UI 就绪等待。
function ____exports.initUiAttributeSystem()
    if not _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED or initialized then
        return
    end
    scheduleUiStartup()
end
function ____exports.isUiAttributeSystemEnabled()
    return _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED
end
--- 玩家英雄注册回调。
-- 由玩家系统调用，每注册一个玩家英雄就创建一个UI槽位。
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if not initialized then
        pendingHeroRegistrations[#pendingHeroRegistrations + 1] = {player = whichPlayer, hero = whichHero}
        return
    end
    if type(_onPlayerHeroRegistered) == "function" then
        _onPlayerHeroRegistered(whichPlayer, whichHero)
    end
end
if _____5E38_91CF.UI_ATTRIBUTE_SYSTEM_ENABLED then
    scheduleUiStartup()
end
return ____exports
