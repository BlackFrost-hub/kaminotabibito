local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 宝箱系统 - 事件注册
-- 
-- 功能：
-- 1. 监听单位发布目标命令事件（EVENT_UNIT_ISSUED_TARGET_ORDER）
-- 2. 当目标为可破坏物时，检查是否为可交互目标
-- 3. 如果是，调用核心功能处理
-- 
-- 注册方式：通过玩家英雄注册联动，在英雄登记时自动注册命令事件
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local createDelayedCall = ____require_result_0.createDelayedCall
local GetTriggerUnit = jass.GetTriggerUnit
local GetOrderTargetDestructable = jass.GetOrderTargetDestructable
local GetDestructableTypeId = jass.GetDestructableTypeId
local GetHandleId = jass.GetHandleId
local ____require_result_1 = require("系统.06．经济系统.00．宝箱系统.03．宝箱核心")
local onUnitTargetInteractable = ____require_result_1.onUnitTargetInteractable
local onUnitTargetChestPointOrder = ____require_result_1.onUnitTargetChestPointOrder
local onUnitTargetChestImmediateOrder = ____require_result_1.onUnitTargetChestImmediateOrder
local isInteractable = ____require_result_1.isInteractable
local ____require_result_2 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local _____5B9D_7BB1_7CFB_7EDF_5F00_5173 = ____require_result_2["宝箱系统开关"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_3.YDLocal5Get
local helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local orderEventCenter = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local EVENT_UNIT_ISSUED_TARGET_ORDER = 19
local REG_GUARD = "__syzl_chestSystem_registered"
local TRIG_KEY = "__syzl_chestSystem_trig"
local ATTEMPT_KEY = "__syzl_chestSystem_attempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local GLOBAL_ORDER_GUARD = "__syzl_chestSystem_global_target_listener"
--- STES事件名：单位发布目标命令
local STES_EVENT_UNIT_TARGET_ORDER = "单位发布目标命令"
local _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4 = __TS__New(Set)
--- 处理单位发布目标命令事件
local function onUnitIssuedTargetOrder()
    local unit = GetTriggerUnit()
    if unit == nil or unit == 0 then
        return
    end
    local target = GetOrderTargetDestructable()
    if target == nil or target == 0 then
        return
    end
    local targetType = GetDestructableTypeId(target)
    local _____53EF_4EA4_4E92 = isInteractable(targetType)
    if not _____53EF_4EA4_4E92 then
        return
    end
    onUnitTargetInteractable(unit, target)
end
local function onGlobalTargetOrder(unit, orderId, _targetUnit, _targetItem, targetDestructable)
    if unit == nil or unit == 0 or targetDestructable == nil or targetDestructable == 0 then
        return
    end
    local unitId = GetHandleId(unit)
    local targetType = GetDestructableTypeId(targetDestructable)
    local _____5DF2_767B_8BB0 = _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId)
    local _____53EF_4EA4_4E92 = isInteractable(targetType)
    if not _____5DF2_767B_8BB0 or not _____53EF_4EA4_4E92 then
        return
    end
    onUnitTargetInteractable(unit, targetDestructable)
end
local function onGlobalPointOrder(unit, _orderId, x, y)
    if unit == nil or unit == 0 then
        return
    end
    local unitId = jass:GetHandleId(unit)
    if not _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId) then
        return
    end
    onUnitTargetChestPointOrder(unit, x, y)
end
local function onGlobalImmediateOrder(unit, orderId)
    if unit == nil or unit == 0 then
        return
    end
    local unitId = jass:GetHandleId(unit)
    if not _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId) then
        return
    end
    onUnitTargetChestImmediateOrder(unit, orderId)
end
local function jassStesHashtable()
    local candidates = {jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT}
    do
        local i = 0
        while i < #candidates do
            local ____table = candidates[i + 1]
            if ____table ~= nil and ____table ~= 0 then
                return ____table
            end
            i = i + 1
        end
    end
    return nil
end
local function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    return jass:LoadInteger(
        ht,
        jass:StringHash(eventName),
        helper:ydlStes_skeyIndex(nil)
    )
end
local function scheduleRetry(fn)
    createDelayedCall(RETRY_SEC, fn)
end
--- 注册单位目标命令事件监听
local function tryRegisterTargetOrderStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass:CreateTrigger()
        jass:TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    helper:ydlStes_registerAfterGetTable(nil, g[TRIG_KEY], STES_EVENT_UNIT_TARGET_ORDER)
    local count = countOnJassStesTable(STES_EVENT_UNIT_TARGET_ORDER)
    local attempt = (g[ATTEMPT_KEY] or 0) + 1
    g[ATTEMPT_KEY] = attempt
    if count >= 1 or attempt >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        tryRegisterTargetOrderStes()
    end)
end
local function ensureGlobalTargetOrderListener()
    local g = _G
    if g[GLOBAL_ORDER_GUARD] then
        return
    end
    g[GLOBAL_ORDER_GUARD] = true
    orderEventCenter.registerTargetOrderListener(onGlobalTargetOrder)
    orderEventCenter.registerPointOrderListener(onGlobalPointOrder)
    orderEventCenter.registerImmediateOrderListener(onGlobalImmediateOrder)
end
--- 为英雄注册目标命令事件
-- 当英雄被登记时调用
function ____exports.registerChestSystemHero(hero)
    if not _____5B9D_7BB1_7CFB_7EDF_5F00_5173 then
        return
    end
    if not hero then
        return
    end
    local heroId = GetHandleId(hero)
    _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:add(heroId)
    ensureGlobalTargetOrderListener()
    local g = _G
    if g[TRIG_KEY] == nil then
        local trig = jass:CreateTrigger()
        jass:TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    local ev = jass:ConvertUnitEvent(EVENT_UNIT_ISSUED_TARGET_ORDER)
    unitSpecificEventCenter.registerUnitEventTrigger(g[TRIG_KEY], hero, ev)
end
--- 初始化宝箱系统
function ____exports.initChestSystem()
    if not _____5B9D_7BB1_7CFB_7EDF_5F00_5173 then
        return
    end
    ensureGlobalTargetOrderListener()
    tryRegisterTargetOrderStes()
end
____exports.STES_EVENT_UNIT_TARGET_ORDER = STES_EVENT_UNIT_TARGET_ORDER
return ____exports
