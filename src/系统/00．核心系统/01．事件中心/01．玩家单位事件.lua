--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
____exports.DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    13
}
local dispatchTriggers = {}
local registeredKeys = {}
local masterTrigger = nil
local function normalizeFilter(filter)
    local ____temp_0
    if filter == nil then
        ____temp_0 = nil
    else
        ____temp_0 = filter
    end
    return ____temp_0
end
local function eventKey(player, eventId)
    local playerId = jass.GetPlayerId(player)
    return (tostring(playerId) .. ":") .. tostring(eventId)
end
local function currentEventKey()
    local player = jass.GetTriggerPlayer()
    local playerId = jass.GetPlayerId(player)
    local eventId = jass.GetTriggerEventId()
    return (tostring(playerId) .. ":") .. tostring(eventId)
end
local function hasTrigger(list, trig)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == trig then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function dispatchPlayerUnitEvent(key)
    local list = dispatchTriggers[key]
    if not list then
        return
    end
    do
        local i = 0
        while i < #list do
            do
                local trig = list[i + 1]
                if not trig then
                    goto __continue12
                end
                local ____temp_1
                if type(jass.TriggerEvaluate) == "function" then
                    ____temp_1 = jass.TriggerEvaluate(trig)
                else
                    ____temp_1 = true
                end
                local passed = ____temp_1
                if passed then
                    jass.TriggerExecute(trig)
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
end
local function ensureMasterTrigger()
    if masterTrigger then
        return masterTrigger
    end
    masterTrigger = jass.CreateTrigger()
    jass.TriggerAddAction(
        masterTrigger,
        function()
            dispatchPlayerUnitEvent(currentEventKey())
        end
    )
    return masterTrigger
end
local function ensureNativeRegistration(player, eventId, key)
    if registeredKeys[key] then
        return
    end
    local master = ensureMasterTrigger()
    registeredKeys[key] = true
    dispatchTriggers[key] = dispatchTriggers[key] or ({})
    jass.TriggerRegisterPlayerUnitEvent(master, player, eventId, nil)
end
function ____exports.registerPlayerUnitEvent(trig, player, eventId, filter)
    if not trig or not player or not eventId then
        return
    end
    local normalizedFilter = normalizeFilter(filter)
    if normalizedFilter then
        jass.TriggerRegisterPlayerUnitEvent(trig, player, eventId, normalizedFilter)
        return
    end
    local key = eventKey(player, eventId)
    ensureNativeRegistration(player, eventId, key)
    local list = dispatchTriggers[key]
    if not hasTrigger(list, trig) then
        list[#list + 1] = trig
    end
end
function ____exports.registerPlayerUnitEventById(trig, playerId, eventId, filter)
    ____exports.registerPlayerUnitEvent(
        trig,
        jass.Player(playerId),
        eventId,
        filter
    )
end
function ____exports.registerPlayerUnitEventForPlayerIds(trig, playerIds, eventId, filter)
    if not trig or not eventId then
        return
    end
    do
        local i = 0
        while i < #playerIds do
            ____exports.registerPlayerUnitEventById(trig, playerIds[i + 1], eventId, filter)
            i = i + 1
        end
    end
end
function ____exports.registerDefaultPlayerUnitEvent(trig, eventId, filter)
    ____exports.registerPlayerUnitEventForPlayerIds(trig, ____exports.DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS, eventId, filter)
end
return ____exports
