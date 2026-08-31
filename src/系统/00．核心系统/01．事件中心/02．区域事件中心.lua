local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_0.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_0.safeDestroyTrigger
local enterRegionListeners = {}
local enterRegionRegistered = {}
local enterRegionMasters = {}
local enterRegionMasterActions = {}
local enterRegionKeyByMasterHid = {}
local function handleKey(handle)
    return tostring(handle)
end
local function filterKey(filter)
    return filter == nil and "null" or tostring(filter)
end
local function normalizeFilter(filter)
    local ____temp_1
    if filter == nil then
        ____temp_1 = nil
    else
        ____temp_1 = filter
    end
    return ____temp_1
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
local function cleanupEnterRegionMaster(key)
    local list = enterRegionListeners[key]
    if list and compactListeners(list) > 0 then
        return
    end
    local master = enterRegionMasters[key]
    if master then
        local action = enterRegionMasterActions[key]
        if action then
            jass.TriggerRemoveAction(master, action)
        end
        jass.DestroyTrigger(master)
    end
    local hid = master and tostring(jass.GetHandleId(master)
    ) or ""
    if hid ~= "" then
        __TS__Delete(enterRegionKeyByMasterHid, hid)
    end
    __TS__Delete(enterRegionMasters, key)
    __TS__Delete(enterRegionMasterActions, key)
    __TS__Delete(enterRegionRegistered, key)
    __TS__Delete(enterRegionListeners, key)
end
local function dispatchEnterRegionMaster()
    local trig = jass.GetTriggeringTrigger()
    if not trig then
        return
    end
    local key = enterRegionKeyByMasterHid[tostring(jass.GetHandleId(trig)
    )]
    if not key then
        return
    end
    dispatchListeners(enterRegionListeners[key] or ({}))
    cleanupEnterRegionMaster(key)
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
            cleanupEnterRegionMaster(key)
        end
    end
    local listener = {trigger = trigger, active = true, once = once}
    list[#list + 1] = listener
    return function()
        listener.active = false
        cleanupEnterRegionMaster(key)
    end
end
--- 为区域进入事件注册监听。
-- 相同 region + filter 只会创建一个原生总触发器，后续监听统一走内部派发。
-- 返回值用于取消当前监听，不会影响同 key 下的其他监听者。
function ____exports.registerEnterRegionTrigger(trigger, region, filter)
    if not trigger or not region then
        return function()
        end
    end
    local key = regionKey(region, filter)
    if not enterRegionRegistered[key] then
        local normalizedFilter = normalizeFilter(filter)
        local master = jass.CreateTrigger()
        enterRegionMasters[key] = master
        enterRegionRegistered[key] = true
        enterRegionListeners[key] = enterRegionListeners[key] or ({})
        enterRegionKeyByMasterHid[tostring(jass.GetHandleId(master)
        )] = key
        jass.TriggerRegisterEnterRegion(master, region, normalizedFilter)
        enterRegionMasterActions[key] = jass.TriggerAddAction(master, dispatchEnterRegionMaster)
    end
    return addListener(enterRegionListeners, key, trigger, false)
end
--- 为已有矩形创建独立 Region/Trigger，并在取消时统一销毁监听资源；矩形生命周期仍由调用方管理。
____exports["创建矩形进入监听"] = function(_____77E9_5F62, _____56DE_8C03, _____8FC7_6EE4_5668)
    if _____77E9_5F62 == nil or _____77E9_5F62 == 0 then
        return nil
    end
    local _____533A_57DF = jass.CreateRegion()
    local _____89E6_53D1_5668 = jass.CreateTrigger()
    if _____533A_57DF == nil or _____533A_57DF == 0 or _____89E6_53D1_5668 == nil or _____89E6_53D1_5668 == 0 then
        if _____89E6_53D1_5668 ~= nil and _____89E6_53D1_5668 ~= 0 then
            safeDestroyTrigger(_____89E6_53D1_5668)
        end
        if _____533A_57DF ~= nil and _____533A_57DF ~= 0 then
            jass.RemoveRegion(_____533A_57DF)
        end
        return nil
    end
    jass.RegionAddRect(_____533A_57DF, _____77E9_5F62)
    if safeTriggerAddAction(_____89E6_53D1_5668, _____56DE_8C03) == nil then
        safeDestroyTrigger(_____89E6_53D1_5668)
        jass.RemoveRegion(_____533A_57DF)
        return nil
    end
    local _____53D6_6D88_76D1_542C = ____exports.registerEnterRegionTrigger(_____89E6_53D1_5668, _____533A_57DF, _____8FC7_6EE4_5668)
    local _____5DF2_53D6_6D88 = false
    local function _____53D6_6D88()
        if _____5DF2_53D6_6D88 then
            return
        end
        _____5DF2_53D6_6D88 = true
        _____53D6_6D88_76D1_542C()
        safeDestroyTrigger(_____89E6_53D1_5668)
        jass.RemoveRegion(_____533A_57DF)
    end
    return {["区域"] = _____533A_57DF, ["触发器"] = _____89E6_53D1_5668, ["取消"] = _____53D6_6D88}
end
return ____exports
