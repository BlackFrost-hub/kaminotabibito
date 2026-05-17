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
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local ____require_result_2 = require("系统.06．经济系统.00．宝箱系统.03．宝箱核心")
local onUnitTargetInteractable = ____require_result_2.onUnitTargetInteractable
local onUnitTargetChestPointOrder = ____require_result_2.onUnitTargetChestPointOrder
local onUnitTargetChestImmediateOrder = ____require_result_2.onUnitTargetChestImmediateOrder
local isInteractable = ____require_result_2.isInteractable
local ____require_result_3 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local _____5B9D_7BB1_7CFB_7EDF_5F00_5173 = ____require_result_3["宝箱系统开关"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_4.YDLocal5Get
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
local _____8C03_8BD5_6A21_5757 = "宝箱系统-注册"
--- STES事件名：单位发布目标命令
local STES_EVENT_UNIT_TARGET_ORDER = "单位发布目标命令"
local _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4 = __TS__New(Set)
--- 处理单位发布目标命令事件
local function onUnitIssuedTargetOrder()
    local unit = jass.GetTriggerUnit()
    if not unit then
        return
    end
    local target = jass.GetOrderTargetDestructable()
    if not target then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "单位特定目标命令: 无 destructable 目标",
            "unit=",
            jass.GetHandleId(unit),
            "orderId=",
            jass.GetIssuedOrderId()
        )
        return
    end
    local targetType = jass.GetDestructableTypeId(target)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "单位特定目标命令命中",
        "unit=",
        jass.GetHandleId(unit),
        "target=",
        jass.GetHandleId(target),
        "type=",
        targetType,
        "orderId=",
        jass.GetIssuedOrderId()
    )
    if not isInteractable(targetType) then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "单位特定目标命令: 目标不是宝箱/木桶",
            "target=",
            jass.GetHandleId(target),
            "type=",
            targetType
        )
        return
    end
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "单位特定目标命令: 进入宝箱交互",
        "unit=",
        jass.GetHandleId(unit),
        "target=",
        jass.GetHandleId(target)
    )
    onUnitTargetInteractable(unit, target)
end
local function onGlobalTargetOrder(unit, _orderId, _targetUnit, _targetItem, targetDestructable)
    if unit == nil or unit == 0 or targetDestructable == nil or targetDestructable == 0 then
        if unit ~= nil and unit ~= 0 then
            debugLogForce(
                _____8C03_8BD5_6A21_5757,
                "全局目标命令: 无 destructable 目标",
                "unit=",
                jass.GetHandleId(unit),
                "orderId=",
                _orderId
            )
        end
        return
    end
    local unitId = jass.GetHandleId(unit)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "全局目标命令命中",
        "unit=",
        unitId,
        "target=",
        jass.GetHandleId(targetDestructable),
        "type=",
        jass.GetDestructableTypeId(targetDestructable),
        "orderId=",
        _orderId,
        "已登记=",
        _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId)
    )
    if not _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId) then
        return
    end
    local targetType = jass.GetDestructableTypeId(targetDestructable)
    if not isInteractable(targetType) then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "全局目标命令: 目标不是宝箱/木桶",
            "target=",
            jass.GetHandleId(targetDestructable),
            "type=",
            targetType
        )
        return
    end
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "全局目标命令: 进入宝箱交互",
        "unit=",
        unitId,
        "target=",
        jass.GetHandleId(targetDestructable)
    )
    onUnitTargetInteractable(unit, targetDestructable)
end
local function onGlobalPointOrder(unit, _orderId, x, y)
    if unit == nil or unit == 0 then
        return
    end
    local unitId = jass.GetHandleId(unit)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "全局点地命令命中",
        "unit=",
        unitId,
        "x=",
        x,
        "y=",
        y,
        "已登记=",
        _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId)
    )
    if not _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId) then
        return
    end
    onUnitTargetChestPointOrder(unit, x, y)
end
local function onGlobalImmediateOrder(unit, orderId)
    if unit == nil or unit == 0 then
        return
    end
    local unitId = jass.GetHandleId(unit)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "全局即时命令命中",
        "unit=",
        unitId,
        "orderId=",
        orderId,
        "已登记=",
        _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:has(unitId)
    )
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
    return jass.LoadInteger(
        ht,
        jass.StringHash(eventName),
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
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    helper:ydlStes_registerAfterGetTable(nil, g[TRIG_KEY], STES_EVENT_UNIT_TARGET_ORDER)
    local count = countOnJassStesTable(STES_EVENT_UNIT_TARGET_ORDER)
    local attempt = (g[ATTEMPT_KEY] or 0) + 1
    g[ATTEMPT_KEY] = attempt
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "尝试注册 STES 目标命令监听",
        "count=",
        count,
        "attempt=",
        attempt
    )
    if count >= 1 or attempt >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "STES 注册结束",
            "count=",
            count,
            "attempt=",
            attempt,
            "guard=",
            true
        )
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
    debugLogForce(_____8C03_8BD5_6A21_5757, "注册全局目标命令监听")
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
    _____5DF2_6CE8_518C_5B9D_7BB1_82F1_96C4:add(jass.GetHandleId(hero))
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "登记宝箱英雄",
        "unit=",
        jass.GetHandleId(hero),
        "owner=",
        jass.GetPlayerId(jass.GetOwningPlayer(hero))
    )
    ensureGlobalTargetOrderListener()
    local g = _G
    if g[TRIG_KEY] == nil then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    local ev = jass.ConvertUnitEvent(EVENT_UNIT_ISSUED_TARGET_ORDER)
    unitSpecificEventCenter.registerUnitEventTrigger(g[TRIG_KEY], hero, ev)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "注册单位特定目标命令监听",
        "unit=",
        jass.GetHandleId(hero),
        "event=",
        EVENT_UNIT_ISSUED_TARGET_ORDER
    )
end
--- 初始化宝箱系统
function ____exports.initChestSystem()
    if not _____5B9D_7BB1_7CFB_7EDF_5F00_5173 then
        return
    end
    debugLogForce(_____8C03_8BD5_6A21_5757, "初始化宝箱系统")
    ensureGlobalTargetOrderListener()
    tryRegisterTargetOrderStes()
end
____exports.STES_EVENT_UNIT_TARGET_ORDER = STES_EVENT_UNIT_TARGET_ORDER
return ____exports
