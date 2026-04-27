--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local enterRegionListeners = {}
local enterRegionRegistered = {}
local enterRegionMasters = {}
local function handleKey(handle)
    return tostring(nil, handle)
end
local function filterKey(filter)
    return filter == nil and "null" or tostring(nil, filter)
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
local function regionKey(region, filter)
    return (handleKey(region) .. ":") .. filterKey(filter)
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
                    goto __continue12
                end
                local passed = jass:TriggerEvaluate(listener.trigger)
                if passed then
                    jass:TriggerExecute(listener.trigger)
                end
                if listener.once then
                    listener.active = false
                end
                if listener.active then
                    list[writeIndex + 1] = listener
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue12::
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
function ____exports.registerEnterRegionTrigger(trigger, region, filter)
    if not trigger or not region then
        return function()
        end
    end
    local key = regionKey(region, filter)
    if not enterRegionRegistered[key] then
        local normalizedFilter = normalizeFilter(filter)
        local master = jass:CreateTrigger()
        enterRegionMasters[key] = master
        enterRegionRegistered[key] = true
        enterRegionListeners[key] = enterRegionListeners[key] or ({})
        jass:TriggerRegisterEnterRegion(master, region, normalizedFilter)
        jass:TriggerAddAction(
            master,
            function()
                dispatchListeners(enterRegionListeners[key])
            end
        )
    end
    return addListener(enterRegionListeners, key, trigger, false)
end
return ____exports
