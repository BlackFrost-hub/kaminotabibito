--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local unitEventListeners = {}
local unitEventRegistered = {}
local unitEventMasters = {}
local unitEventKeyByMasterHid = {}
local unitInRangeListeners = {}
local unitInRangeRegistered = {}
local unitInRangeMasters = {}
local unitInRangeKeyByMasterHid = {}
local function handleKey(handle)
    return tostring(handle)
end
local function filterKey(filter)
    return filter == nil and "null" or tostring(filter)
end
local function normalizeFilter(filter)
    local ____temp_0
    if filter == nil then
        ____temp_0 = nil
    else
        ____temp_0 = filter
    end
    return ____temp_0
end
local function unitEventKey(unit, eventId)
    return (handleKey(unit) .. ":") .. tostring(eventId)
end
local function unitRangeKey(unit, range, filter)
    return (((handleKey(unit) .. ":") .. tostring(range)) .. ":") .. filterKey(filter)
end
local function hasListener(list, trigger)
    do
        local i = 0
        while i < #list do
            if list[i + 1].trigger == trigger and list[i + 1].active then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function dispatchListeners(list)
    local writeIndex = 0
    do
        local i = 0
        while i < #list do
            do
                local listener = list[i + 1]
                if not listener or not listener.active or not listener.trigger then
                    goto __continue13
                end
                local passed = jass.TriggerEvaluate(listener.trigger)
                if passed then
                    jass.TriggerExecute(listener.trigger)
                end
                if listener.once then
                    listener.active = false
                end
                if listener.active then
                    list[writeIndex + 1] = listener
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    do
        local i = #list - 1
        while i >= writeIndex do
            table.remove(list)
            i = i - 1
        end
    end
end
local function dispatchUnitEventMaster()
    local trig = jass.GetTriggeringTrigger()
    if not trig then
        return
    end
    local key = unitEventKeyByMasterHid[tostring(jass.GetHandleId(trig)
    )]
    if not key then
        return
    end
    dispatchListeners(unitEventListeners[key] or ({}))
end
local function dispatchUnitInRangeMaster()
    local trig = jass.GetTriggeringTrigger()
    if not trig then
        return
    end
    local key = unitInRangeKeyByMasterHid[tostring(jass.GetHandleId(trig)
    )]
    if not key then
        return
    end
    dispatchListeners(unitInRangeListeners[key] or ({}))
end
local function addListener(store, key, trigger, once)
    store[key] = store[key] or ({})
    local list = store[key]
    if hasListener(list, trigger) then
        return function()
            do
                local i = 0
                while i < #list do
                    if list[i + 1].trigger == trigger then
                        list[i + 1].active = false
                    end
                    i = i + 1
                end
            end
        end
    end
    local listener = {trigger = trigger, active = true, once = once}
    list[#list + 1] = listener
    return function()
        listener.active = false
    end
end
function ____exports.registerUnitEventTrigger(trigger, unit, eventId, once)
    if once == nil then
        once = false
    end
    if not trigger or not unit or not eventId then
        return function()
        end
    end
    local key = unitEventKey(unit, eventId)
    if not unitEventRegistered[key] then
        local master = jass.CreateTrigger()
        unitEventMasters[key] = master
        unitEventRegistered[key] = true
        unitEventListeners[key] = unitEventListeners[key] or ({})
        unitEventKeyByMasterHid[tostring(jass.GetHandleId(master)
        )] = key
        jass.TriggerRegisterUnitEvent(master, unit, eventId)
        jass.TriggerAddAction(master, dispatchUnitEventMaster)
    end
    return addListener(unitEventListeners, key, trigger, once)
end
function ____exports.registerUnitInRangeTrigger(trigger, unit, range, filter, once)
    if once == nil then
        once = false
    end
    if not trigger or not unit then
        return function()
        end
    end
    local key = unitRangeKey(unit, range, filter)
    if not unitInRangeRegistered[key] then
        local normalizedFilter = normalizeFilter(filter)
        local master = jass.CreateTrigger()
        unitInRangeMasters[key] = master
        unitInRangeRegistered[key] = true
        unitInRangeListeners[key] = unitInRangeListeners[key] or ({})
        unitInRangeKeyByMasterHid[tostring(jass.GetHandleId(master)
        )] = key
        jass.TriggerRegisterUnitInRange(master, unit, range, normalizedFilter)
        jass.TriggerAddAction(master, dispatchUnitInRangeMaster)
    end
    return addListener(unitInRangeListeners, key, trigger, once)
end
return ____exports
