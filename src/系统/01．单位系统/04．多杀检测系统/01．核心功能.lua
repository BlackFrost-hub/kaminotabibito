local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local removeGroupMonitor, jass, YDUserDataClear, groupMonitors, groupUnitMap
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.04．多杀检测系统.00．常量定义")
local MULTI_KILL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_SYSTEM_ENABLED
local ____02_FF0ESTES_4E8B_4EF6_89E6_53D1 = require("系统.01．单位系统.04．多杀检测系统.02．STES事件触发")
local fireMultiKillEffectEvent = ____02_FF0ESTES_4E8B_4EF6_89E6_53D1.fireMultiKillEffectEvent
function removeGroupMonitor(self, instance)
    if instance.killGroup ~= nil then
        local unit = jass.FirstOfGroup(instance.killGroup)
        while unit ~= nil do
            groupUnitMap:delete(unit)
            YDUserDataClear(
                nil,
                "unit",
                unit,
                "killer",
                "boolean"
            )
            jass.GroupRemoveUnit(instance.killGroup, unit)
            unit = jass.FirstOfGroup(instance.killGroup)
        end
        if instance.isOwnKillGroup then
            jass.DestroyGroup(instance.killGroup)
        end
        instance.killGroup = nil
    end
    local idx = __TS__ArrayIndexOf(groupMonitors, instance)
    if idx >= 0 then
        __TS__ArraySplice(groupMonitors, idx, 1)
    end
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
YDUserDataClear = ____require_result_0.YDUserDataClear
local ____require_result_1 = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
local registerDeathListener = ____require_result_1.registerDeathListener
groupMonitors = {}
groupUnitMap = __TS__New(Map)
local deathCallbackRegistered = false
local function buildEffectParams(self, instance)
    return {
        effectID = instance.effectID,
        healAmount = instance.healAmount,
        healTarget = instance.healTarget,
        healSource = instance.healSource,
        diyEvent = instance.diyEvent,
        diyEventString = instance.diyEventString
    }
end
local function killAllInGroup(self, instance)
    if instance.killGroup == nil then
        return
    end
    local group = instance.killGroup
    local unit = jass.FirstOfGroup(group)
    while unit ~= nil do
        jass.GroupRemoveUnit(group, unit)
        groupUnitMap:delete(unit)
        YDUserDataSet(
            nil,
            "unit",
            unit,
            "killer",
            true
        )
        jass.KillUnit(unit)
        unit = jass.FirstOfGroup(group)
    end
    if instance.isOwnKillGroup then
        jass.DestroyGroup(group)
    end
    instance.killGroup = nil
end
local function onUnitDeath(self, dyingUnit, killingUnit)
    local instance = groupUnitMap:get(dyingUnit)
    if instance == nil then
        return
    end
    if instance.killGroup == nil then
        return
    end
    jass.GroupRemoveUnit(instance.killGroup, dyingUnit)
    groupUnitMap:delete(dyingUnit)
    killAllInGroup(nil, instance)
    local isKiller = YDUserDataGet(
        nil,
        "unit",
        dyingUnit,
        "killer",
        "boolean"
    )
    if not isKiller and killingUnit ~= nil then
        fireMultiKillEffectEvent(
            nil,
            buildEffectParams(nil, instance)
        )
    end
    if instance.finish then
        jass.ShowUnit(instance.effectSource, true)
    end
    removeGroupMonitor(nil, instance)
end
function ____exports.startMultiKillMonitor(self, config)
    if not MULTI_KILL_SYSTEM_ENABLED then
        return
    end
    if config.killGroup == nil then
        return
    end
    local existingIdx = __TS__ArrayFindIndex(
        groupMonitors,
        function(____, m) return m.effectSource == config.effectSource end
    )
    if existingIdx >= 0 then
        removeGroupMonitor(nil, groupMonitors[existingIdx + 1])
    end
    local ____config_effectSource_6 = config.effectSource
    local ____config_killGroup_7 = config.killGroup
    local ____config_diyEvent_2 = config.diyEvent
    if ____config_diyEvent_2 == nil then
        ____config_diyEvent_2 = false
    end
    local ____temp_8 = config.diyEventString or ""
    local ____config_finish_3 = config.finish
    if ____config_finish_3 == nil then
        ____config_finish_3 = false
    end
    local ____temp_9 = config.effectID or 0
    local ____temp_10 = config.healAmount or 0
    local ____config_healTarget_4 = config.healTarget
    if ____config_healTarget_4 == nil then
        ____config_healTarget_4 = nil
    end
    local ____config_healSource_5 = config.healSource
    if ____config_healSource_5 == nil then
        ____config_healSource_5 = nil
    end
    local instance = {
        effectSource = ____config_effectSource_6,
        killGroup = ____config_killGroup_7,
        isOwnKillGroup = false,
        diyEvent = ____config_diyEvent_2,
        diyEventString = ____temp_8,
        finish = ____config_finish_3,
        effectID = ____temp_9,
        healAmount = ____temp_10,
        healTarget = ____config_healTarget_4,
        healSource = ____config_healSource_5
    }
    local tempGroup = jass.CreateGroup()
    jass.GroupAddGroup(instance.killGroup, tempGroup)
    local unit = jass.FirstOfGroup(tempGroup)
    while unit ~= nil do
        groupUnitMap:set(unit, instance)
        jass.GroupRemoveUnit(tempGroup, unit)
        unit = jass.FirstOfGroup(tempGroup)
    end
    jass.DestroyGroup(tempGroup)
    groupMonitors[#groupMonitors + 1] = instance
    if not deathCallbackRegistered then
        registerDeathListener(nil, onUnitDeath)
        deathCallbackRegistered = true
    end
end
function ____exports.stopMultiKillMonitor(self, effectSource)
    local instance = __TS__ArrayFind(
        groupMonitors,
        function(____, m) return m.effectSource == effectSource end
    )
    if instance ~= nil then
        removeGroupMonitor(nil, instance)
    end
end
function ____exports.addToKillGroup(self, effectSource, unit)
    local instance = __TS__ArrayFind(
        groupMonitors,
        function(____, m) return m.effectSource == effectSource end
    )
    if instance == nil then
        return
    end
    if instance.killGroup == nil then
        instance.killGroup = jass.CreateGroup()
        instance.isOwnKillGroup = true
    end
    jass.GroupAddUnit(instance.killGroup, unit)
    groupUnitMap:set(unit, instance)
end
function ____exports.removeFromKillGroup(self, effectSource, unit)
    local instance = __TS__ArrayFind(
        groupMonitors,
        function(____, m) return m.effectSource == effectSource end
    )
    if instance == nil or instance.killGroup == nil then
        return
    end
    jass.GroupRemoveUnit(instance.killGroup, unit)
    groupUnitMap:delete(unit)
end
function ____exports.isMultiKillMonitored(self, unit)
    return groupUnitMap:has(unit)
end
function ____exports.getMultiKillMonitorCount(self)
    return #groupMonitors
end
return ____exports
