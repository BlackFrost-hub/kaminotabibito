local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchUnitDeath, jass, playerUnitEvent, listeners, initialized
function dispatchUnitDeath()
    local dyingUnit = jass.GetTriggerUnit()
    if dyingUnit == nil then
        return
    end
    local killingUnit = jass.GetKillingUnit()
    do
        local i = 0
        while i < #listeners do
            local callback = listeners[i + 1]
            if type(callback) == "function" then
                callback(dyingUnit, killingUnit)
            end
            i = i + 1
        end
    end
end
--- 初始化单位死亡事件中心。
-- 对所有项目玩家统一注册原生死亡事件，并集中派发给监听器。
function ____exports.initUnitDeathEventCenter()
    if initialized then
        return
    end
    initialized = true
    local trigger = jass.CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trigger, ____exports.DEATH_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DEATH)
    jass.TriggerAddAction(trigger, dispatchUnitDeath)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.DEATH_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
listeners = {}
initialized = false
local function hasListener(callback)
    do
        local i = 0
        while i < #listeners do
            if listeners[i + 1] == callback then
                return true
            end
            i = i + 1
        end
    end
    return false
end
--- 注册单位死亡监听。
-- 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
function ____exports.registerDeathListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initUnitDeathEventCenter()
    if not hasListener(callback) then
        listeners[#listeners + 1] = callback
    end
end
--- 取消单位死亡监听。
function ____exports.unregisterDeathListener(callback)
    local index = __TS__ArrayIndexOf(listeners, callback)
    if index >= 0 then
        __TS__ArraySplice(listeners, index, 1)
    end
end
return ____exports
