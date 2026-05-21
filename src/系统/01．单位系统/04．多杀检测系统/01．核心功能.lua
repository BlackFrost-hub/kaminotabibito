local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.04．多杀检测系统.00．常量定义")
local MULTI_KILL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_SYSTEM_ENABLED
--- ==========================================================================================
-- 多杀检测系统（同步击杀系统）- 核心功能
-- ==========================================================================================
-- 
-- 【系统功能】
-- 实现单位组的同步击杀机制：当组内不同单位在指定时间窗口内受到致命伤害达到阈值时，
-- 组内所有单位一起死亡。
-- 
-- 【核心机制】
-- 1. 全局计数器：整个单位组共享一个伤害计数器（hitCount）
-- 2. 时间窗口：在 killWindow 秒内累计不同单位的致命伤害
-- 3. 去重机制：同一单位连续受到致命伤害只算一次（防止快速连击错误计数）
-- 4. 窗口重置：时间窗口过期后计数器自动重置
-- 5. 触发击杀：达到 killThreshold 阈值时，组内所有单位一起死亡
-- 6. 排除自然死亡：只计算有凶手单位的击杀（玩家/敌人造成的伤害）
-- 
-- 【使用场景】
-- - 需要多个单位同时死亡的剧情/机制
-- - 防止玩家逐个击杀，要求在一定时间内同时击杀所有目标
-- 
-- 【JASS 调用方式】
-- 1. 通过 STES "OnMultiKill" 事件启动监控
-- 2. 参数通过 YDLocal5Set 传递：
--    - killGroup: 要监控的单位组
--    - killWindow: 时间窗口（秒，默认3）
--    - killThreshold: 击杀阈值（默认3）
--    - effectSource: 逻辑锚点单位（推荐用隐藏单位）
-- 
-- 【注意事项】
-- 1. effectSource：多杀系统的来源标识（如分裂后隐藏的母体单位），用于区分多路监控
-- 2. finish：与 effectSource 配套使用，为 true 时组内单位全死后会显示 effectSource
-- 3. 同一单位组不能重叠（后启动的会覆盖先启动的）
-- 4. 系统使用中心计时器获取时间，支持毫秒精度
-- 
-- 【示例】
-- // JASS 端调用示例
-- call YDLocal5Set(group, "killGroup", GetUnitsInRectAll(gg_rct_Area))
-- call YDLocal5Set(real, "killWindow", 3.00)
-- call YDLocal5Set(integer, "killThreshold", 3)
-- call YDLocal5Set(unit, "effectSource", gg_unit_hfoo_0001)
-- call STES_Trigger("OnMultiKill")
-- 
-- ==========================================================================================
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local YDUserDataClear = ____require_result_0.YDUserDataClear
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local GroupAddGroup = ____require_result_3.GroupAddGroup
local groupMonitors = {}
local groupUnitMap = __TS__New(Map)
local finalDamageListenerRegistered = false
local damageModifierRegistered = false
local ____require_result_4 = require("系统.01．单位系统.04．多杀检测系统.04．成功回调")
local onMultiKillSuccess = ____require_result_4.onMultiKillSuccess
local function getGameTime(self)
    local ____G_5 = _G
    local getServerTime = ____G_5.getServerTime
    return getServerTime(nil) / 1000
end
local function getUnitId(self, unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return jass.GetHandleId(unit) or 0
end
local function killAllInGroup(self, instance)
    if instance.killGroup == nil then
        return
    end
    local group = instance.killGroup
    local unit = jass.FirstOfGroup(group)
    while unit ~= nil do
        jass.GroupRemoveUnit(group, unit)
        groupUnitMap:delete(getUnitId(nil, unit))
        jass.KillUnit(unit)
        unit = jass.FirstOfGroup(group)
    end
    if instance.isOwnKillGroup then
        jass.DestroyGroup(group)
    end
    instance.killGroup = nil
    onMultiKillSuccess(nil, instance)
end
local function removeGroupMonitor(self, instance)
    if instance.killGroup ~= nil then
        local unit = jass.FirstOfGroup(instance.killGroup)
        while unit ~= nil do
            groupUnitMap:delete(getUnitId(nil, unit))
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
local function _____5904_7406_591A_6740_81F4_547D_8BA1_6570(self, instance, targetUnit, damage)
    local isFatal = damage >= jass.GetUnitState(targetUnit, jass.UNIT_STATE_LIFE)
    if not isFatal then
        return false
    end
    local now = getGameTime(nil)
    if instance.firstHitTime > 0 then
        local timeElapsed = now - instance.firstHitTime
        if timeElapsed > instance.killWindow then
            instance.hitCount = 0
            instance.firstHitTime = now
            instance.lastHitUnit = nil
        end
    end
    if instance.lastHitUnit == targetUnit then
        return false
    end
    if instance.firstHitTime == 0 then
        instance.firstHitTime = now
    end
    instance.hitCount = instance.hitCount + 1
    instance.lastHitUnit = targetUnit
    return instance.hitCount >= instance.killThreshold
end
local function onMultiKillDamageModifier(context)
    local targetUnit = context.target
    local instance = groupUnitMap:get(getUnitId(nil, targetUnit))
    if instance == nil then
        return context.currentDamage
    end
    if context.attacker == nil or context.attacker == 0 then
        return context.currentDamage
    end
    local thresholdReached = _____5904_7406_591A_6740_81F4_547D_8BA1_6570(nil, instance, targetUnit, context.currentDamage)
    if thresholdReached then
        instance.pendingFinish = true
        instance.pendingTarget = targetUnit
        return context.currentDamage
    end
    return 0
end
local function onUnitDamage(targetUnit, sourceUnit, damage, _snapshot)
    local instance = groupUnitMap:get(getUnitId(nil, targetUnit))
    if instance == nil then
        return
    end
    if sourceUnit == nil or sourceUnit == 0 then
        return
    end
    if not (damage > 0) then
        return
    end
    if instance.pendingFinish ~= true then
        return
    end
    if instance.pendingTarget ~= targetUnit then
        return
    end
    instance.pendingFinish = false
    instance.pendingTarget = nil
    killAllInGroup(nil, instance)
    removeGroupMonitor(nil, instance)
end
function ____exports.startMultiKillMonitor(self, config)
    if not MULTI_KILL_SYSTEM_ENABLED then
        return
    end
    if config.killGroup == nil or config.killGroup == 0 then
        return
    end
    local killThreshold = config.killThreshold or 3
    local killWindow = config.killWindow or 3
    local existingIdx = __TS__ArrayFindIndex(
        groupMonitors,
        function(____, m) return m.effectSource == config.effectSource end
    )
    if existingIdx >= 0 then
        removeGroupMonitor(nil, groupMonitors[existingIdx + 1])
    end
    local ____config_effectSource_10 = config.effectSource
    local ____config_killGroup_11 = config.killGroup
    local ____config_diyEvent_6 = config.diyEvent
    if ____config_diyEvent_6 == nil then
        ____config_diyEvent_6 = false
    end
    local ____temp_12 = config.diyEventString or ""
    local ____config_finish_7 = config.finish
    if ____config_finish_7 == nil then
        ____config_finish_7 = false
    end
    local ____temp_13 = config.effectID or 0
    local ____temp_14 = config.healAmount or 0
    local ____config_healTarget_8 = config.healTarget
    if ____config_healTarget_8 == nil then
        ____config_healTarget_8 = nil
    end
    local ____config_healSource_9 = config.healSource
    if ____config_healSource_9 == nil then
        ____config_healSource_9 = nil
    end
    local instance = {
        effectSource = ____config_effectSource_10,
        killGroup = ____config_killGroup_11,
        isOwnKillGroup = false,
        killThreshold = killThreshold,
        killWindow = killWindow,
        hitCount = 0,
        firstHitTime = 0,
        lastHitUnit = nil,
        diyEvent = ____config_diyEvent_6,
        diyEventString = ____temp_12,
        finish = ____config_finish_7,
        effectID = ____temp_13,
        healAmount = ____temp_14,
        healTarget = ____config_healTarget_8,
        healSource = ____config_healSource_9,
        pendingFinish = false,
        pendingTarget = nil
    }
    local tempGroup = jass.CreateGroup()
    GroupAddGroup(nil, instance.killGroup, tempGroup)
    local unit = jass.FirstOfGroup(tempGroup)
    while unit ~= nil do
        groupUnitMap:set(
            getUnitId(nil, unit),
            instance
        )
        jass.GroupRemoveUnit(tempGroup, unit)
        unit = jass.FirstOfGroup(tempGroup)
    end
    jass.DestroyGroup(tempGroup)
    groupMonitors[#groupMonitors + 1] = instance
    if not finalDamageListenerRegistered then
        registerAppliedFinalDamageListener(onUnitDamage)
        finalDamageListenerRegistered = true
    end
    if not damageModifierRegistered then
        registerDamageModifier(onMultiKillDamageModifier, -100000)
        damageModifierRegistered = true
    end
end
---
-- @param effectSource 启动监控时传入的锚点单位（通常为 JASS 侧隐藏单位）
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
    groupUnitMap:set(
        getUnitId(nil, unit),
        instance
    )
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
    groupUnitMap:delete(getUnitId(nil, unit))
end
function ____exports.isMultiKillMonitored(self, unit)
    return groupUnitMap:has(getUnitId(nil, unit))
end
function ____exports.getMultiKillMonitorCount(self)
    return #groupMonitors
end
return ____exports
