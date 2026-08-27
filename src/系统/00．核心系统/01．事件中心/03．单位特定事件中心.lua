local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local unitEventListeners = {}
local unitEventRegistered = {}
local unitEventMasters = {}
local unitEventMasterActions = {}
local unitEventKeyByMasterHid = {}
local unitInRangeListeners = {}
local unitInRangeRegistered = {}
local unitInRangeMasters = {}
local unitInRangeMasterActions = {}
local unitInRangeKeyByMasterHid = {}
local oneShotRangeListeners = {}
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
local function unitEventKey(unit, eventId)
    return (handleKey(unit) .. ":") .. tostring(nil, eventId)
end
local function unitRangeKey(unit, range, filter)
    return (((handleKey(unit) .. ":") .. tostring(nil, range)) .. ":") .. filterKey(filter)
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
local function compactListeners(list)
    local writeIndex = 0
    do
        local i = 0
        while i < #list do
            local listener = list[i + 1]
            if listener and listener.active and listener.trigger then
                list[writeIndex + 1] = listener
                writeIndex = writeIndex + 1
            end
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
    return writeIndex
end
local function cleanupUnitEventMaster(key)
    local list = unitEventListeners[key]
    if list and compactListeners(list) > 0 then
        return
    end
    local master = unitEventMasters[key]
    if master then
        local action = unitEventMasterActions[key]
        if action then
            jass:TriggerRemoveAction(master, action)
        end
        jass:DestroyTrigger(master)
    end
    local hid = master and tostring(
        nil,
        jass:GetHandleId(master)
    ) or ""
    if hid ~= "" then
        __TS__Delete(unitEventKeyByMasterHid, hid)
    end
    __TS__Delete(unitEventMasters, key)
    __TS__Delete(unitEventMasterActions, key)
    __TS__Delete(unitEventRegistered, key)
    __TS__Delete(unitEventListeners, key)
end
local function cleanupUnitInRangeMaster(key)
    local list = unitInRangeListeners[key]
    if list and compactListeners(list) > 0 then
        return
    end
    local master = unitInRangeMasters[key]
    if master then
        local action = unitInRangeMasterActions[key]
        if action then
            jass:TriggerRemoveAction(master, action)
        end
        jass:DestroyTrigger(master)
    end
    local hid = master and tostring(
        nil,
        jass:GetHandleId(master)
    ) or ""
    if hid ~= "" then
        __TS__Delete(unitInRangeKeyByMasterHid, hid)
    end
    __TS__Delete(unitInRangeMasters, key)
    __TS__Delete(unitInRangeMasterActions, key)
    __TS__Delete(unitInRangeRegistered, key)
    __TS__Delete(unitInRangeListeners, key)
end
local function dispatchUnitEventMaster()
    local trig = jass:GetTriggeringTrigger()
    if not trig then
        return
    end
    local key = unitEventKeyByMasterHid[tostring(
        nil,
        jass:GetHandleId(trig)
    )]
    if not key then
        return
    end
    dispatchListeners(unitEventListeners[key] or ({}))
    cleanupUnitEventMaster(key)
end
local function dispatchUnitInRangeMaster()
    local trig = jass:GetTriggeringTrigger()
    if not trig then
        return
    end
    local key = unitInRangeKeyByMasterHid[tostring(
        nil,
        jass:GetHandleId(trig)
    )]
    if not key then
        return
    end
    dispatchListeners(unitInRangeListeners[key] or ({}))
    cleanupUnitInRangeMaster(key)
end
local function dispatchOneShotRangeListener()
    local listenerTrigger = jass:GetTriggeringTrigger()
    if not listenerTrigger then
        return
    end
    local key = tostring(
        nil,
        jass:GetHandleId(listenerTrigger)
    )
    local listener = oneShotRangeListeners[key]
    if listener == nil or not listener.active then
        return
    end
    local enteringUnit = jass:GetTriggerUnit()
    if listener.predicate ~= nil and not listener.predicate(enteringUnit) then
        return
    end
    if not listener.callback(enteringUnit) then
        return
    end
    if not listener.active then
        return
    end
    listener.active = false
    listener.unregisterRange()
    __TS__Delete(oneShotRangeListeners, key)
    jass:DestroyTrigger(listener.trigger)
end
local function addListener(store, key, trigger, once, cleanupWhenEmpty)
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
            cleanupWhenEmpty(key)
        end
    end
    local listener = {trigger = trigger, active = true, once = once}
    list[#list + 1] = listener
    return function()
        listener.active = false
        cleanupWhenEmpty(key)
    end
end
--- 为指定单位注册特定原生事件。
-- 相同 unit + eventId 只保留一个原生总触发器，其余监听都复用内部派发。
-- 返回值可用于取消当前监听；once=true 时首次命中后会自动失效。
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
        local master = jass:CreateTrigger()
        unitEventMasters[key] = master
        unitEventRegistered[key] = true
        unitEventListeners[key] = unitEventListeners[key] or ({})
        unitEventKeyByMasterHid[tostring(
            nil,
            jass:GetHandleId(master)
        )] = key
        jass:TriggerRegisterUnitEvent(master, unit, eventId)
        unitEventMasterActions[key] = jass:TriggerAddAction(master, dispatchUnitEventMaster)
    end
    return addListener(
        unitEventListeners,
        key,
        trigger,
        once,
        cleanupUnitEventMaster
    )
end
--- 为指定单位注册“单位进入范围”事件。
-- key 由 unit + range + filter 组成，保证同一组监听共享一个原生注册。
-- 返回值可用于取消当前监听；once=true 时首次命中后自动移除。
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
        local master = jass:CreateTrigger()
        unitInRangeMasters[key] = master
        unitInRangeRegistered[key] = true
        unitInRangeListeners[key] = unitInRangeListeners[key] or ({})
        unitInRangeKeyByMasterHid[tostring(
            nil,
            jass:GetHandleId(master)
        )] = key
        jass:TriggerRegisterUnitInRange(master, unit, range, normalizedFilter)
        unitInRangeMasterActions[key] = jass:TriggerAddAction(master, dispatchUnitInRangeMaster)
    end
    return addListener(
        unitInRangeListeners,
        key,
        trigger,
        once,
        cleanupUnitInRangeMaster
    )
end
--- 注册通用的一次性单位范围监听。
-- 回调返回 true 才会注销；返回 false 时保留监听，适合等待玩家英雄而忽略其他单位。
function ____exports.registerOneShotUnitRangeListener(unit, range, callback, predicate)
    if not unit or not (range > 0) or callback == nil then
        return function()
        end
    end
    local trigger = jass:CreateTrigger()
    if not trigger then
        return function()
        end
    end
    local key = tostring(
        nil,
        jass:GetHandleId(trigger)
    )
    local function unregisterRange()
    end
    local function _____8C03_7528_8303_56F4_76D1_542C_6CE8_9500()
        unregisterRange()
    end
    local listener = {
        trigger = trigger,
        callback = callback,
        predicate = predicate,
        unregisterRange = _____8C03_7528_8303_56F4_76D1_542C_6CE8_9500,
        active = true
    }
    oneShotRangeListeners[key] = listener
    jass:TriggerAddAction(trigger, dispatchOneShotRangeListener)
    unregisterRange = ____exports.registerUnitInRangeTrigger(
        trigger,
        unit,
        range,
        nil,
        false
    )
    return function()
        if not listener.active then
            return
        end
        listener.active = false
        unregisterRange()
        __TS__Delete(oneShotRangeListeners, key)
        jass:DestroyTrigger(trigger)
    end
end
return ____exports
