local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchUnitSummon, jass, playerUnitEvent, listeners, initialized, GetSummonedUnit, GetSummoningUnit
function dispatchUnitSummon()
    local summonedUnit = GetSummonedUnit()
    if summonedUnit == nil or summonedUnit == 0 then
        return
    end
    local summoningUnit = GetSummoningUnit()
    do
        local i = 0
        while i < #listeners do
            local callback = listeners[i + 1]
            if type(callback) == "function" then
                callback(summonedUnit, summoningUnit)
            end
            i = i + 1
        end
    end
end
function ____exports.initUnitSummonEventCenter()
    if initialized then
        return
    end
    initialized = true
    local trigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trigger, ____exports.SUMMON_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SUMMON)
    jass:TriggerAddAction(trigger, dispatchUnitSummon)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.SUMMON_EVENT_PLAYER_IDS = {
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
GetSummonedUnit = jass.GetSummonedUnit
GetSummoningUnit = jass.GetSummoningUnit
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
function ____exports.registerSummonListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initUnitSummonEventCenter()
    if not hasListener(callback) then
        listeners[#listeners + 1] = callback
    end
end
function ____exports.unregisterSummonListener(callback)
    local index = __TS__ArrayIndexOf(listeners, callback)
    if index >= 0 then
        __TS__ArraySplice(listeners, index, 1)
    end
end
return ____exports
