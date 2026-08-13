local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 单位指令事件中心
-- 
-- 统一拦截三种单位指令事件，供嘲讽等系统订阅：
-- - EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER   (指定目标指令)
-- - EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER    (指定点指令)
-- - EVENT_PLAYER_UNIT_ISSUED_ORDER          (无目标/立即指令)
local jass = require("jass.common")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.ORDER_EVENT_PLAYER_IDS = {
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
local targetOrderListeners = {}
local pointOrderListeners = {}
local immediateOrderListeners = {}
local targetInitialized = false
local pointInitialized = false
local immediateInitialized = false
local GetTriggerUnit = jass.GetTriggerUnit
local GetIssuedOrderId = jass.GetIssuedOrderId
local GetOrderTargetUnit = jass.GetOrderTargetUnit
local GetOrderTargetItem = jass.GetOrderTargetItem
local GetOrderTargetDestructable = jass.GetOrderTargetDestructable
local GetOrderPointX = jass.GetOrderPointX
local GetOrderPointY = jass.GetOrderPointY
local function hasListener(list, callback)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == callback then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function dispatchTargetOrder()
    local unit = GetTriggerUnit()
    if unit == nil or unit == 0 then
        return
    end
    local orderId = GetIssuedOrderId()
    local targetUnit = GetOrderTargetUnit()
    local targetItem = GetOrderTargetItem()
    local targetDestructable = GetOrderTargetDestructable()
    do
        local i = 0
        while i < #targetOrderListeners do
            local cb = targetOrderListeners[i + 1]
            if cb ~= nil then
                cb(
                    unit,
                    orderId,
                    targetUnit,
                    targetItem,
                    targetDestructable
                )
            end
            i = i + 1
        end
    end
end
local function dispatchPointOrder()
    local unit = GetTriggerUnit()
    if unit == nil or unit == 0 then
        return
    end
    local orderId = GetIssuedOrderId()
    local x = GetOrderPointX()
    local y = GetOrderPointY()
    do
        local i = 0
        while i < #pointOrderListeners do
            local cb = pointOrderListeners[i + 1]
            if cb ~= nil then
                cb(unit, orderId, x, y)
            end
            i = i + 1
        end
    end
end
local function dispatchImmediateOrder()
    local unit = GetTriggerUnit()
    if unit == nil or unit == 0 then
        return
    end
    local orderId = GetIssuedOrderId()
    do
        local i = 0
        while i < #immediateOrderListeners do
            local cb = immediateOrderListeners[i + 1]
            if cb ~= nil then
                cb(unit, orderId)
            end
            i = i + 1
        end
    end
end
local function initTargetOrderEvent()
    if targetInitialized then
        return
    end
    targetInitialized = true
    local trig = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ____exports.ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    jass:TriggerAddAction(trig, dispatchTargetOrder)
end
local function initPointOrderEvent()
    if pointInitialized then
        return
    end
    pointInitialized = true
    local trig = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ____exports.ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    jass:TriggerAddAction(trig, dispatchPointOrder)
end
local function initImmediateOrderEvent()
    if immediateInitialized then
        return
    end
    immediateInitialized = true
    local trig = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ____exports.ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_ORDER)
    jass:TriggerAddAction(trig, dispatchImmediateOrder)
end
function ____exports.registerTargetOrderListener(callback)
    if type(callback) ~= "function" then
        return
    end
    initTargetOrderEvent()
    if not hasListener(targetOrderListeners, callback) then
        targetOrderListeners[#targetOrderListeners + 1] = callback
    end
end
function ____exports.unregisterTargetOrderListener(callback)
    local index = __TS__ArrayIndexOf(targetOrderListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(targetOrderListeners, index, 1)
    end
end
function ____exports.registerPointOrderListener(callback)
    if type(callback) ~= "function" then
        return
    end
    initPointOrderEvent()
    if not hasListener(pointOrderListeners, callback) then
        pointOrderListeners[#pointOrderListeners + 1] = callback
    end
end
function ____exports.unregisterPointOrderListener(callback)
    local index = __TS__ArrayIndexOf(pointOrderListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(pointOrderListeners, index, 1)
    end
end
function ____exports.registerImmediateOrderListener(callback)
    if type(callback) ~= "function" then
        return
    end
    initImmediateOrderEvent()
    if not hasListener(immediateOrderListeners, callback) then
        immediateOrderListeners[#immediateOrderListeners + 1] = callback
    end
end
function ____exports.unregisterImmediateOrderListener(callback)
    local index = __TS__ArrayIndexOf(immediateOrderListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(immediateOrderListeners, index, 1)
    end
end
return ____exports
