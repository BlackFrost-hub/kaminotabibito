local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 物品事件中心
-- 统一处理物品相关事件，减少触发器数量
-- 合并 EVENT_PLAYER_UNIT_PICKUP_ITEM / DROP_ITEM / USE_ITEM 事件
local jass = require("jass.common")
local GetTriggerUnit = jass.GetTriggerUnit
local GetManipulatedItem = jass.GetManipulatedItem
local GetHandleId = jass.GetHandleId
local CreateTrigger = jass.CreateTrigger
local DestroyTrigger = jass.DestroyTrigger
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local ITEM_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    13
}
local pickupListenerIds = {}
local dropListenerIds = {}
local useListenerIds = {}
local pickupListeners = {}
local dropListeners = {}
local useListeners = {}
local function _____521B_5EFA_7269_54C1_4E8B_4EF6_4E2D_5FC3_5B9E_4F8BID()
    local trigger = CreateTrigger()
    local id = trigger and GetHandleId(trigger) or 0
    if trigger then
        DestroyTrigger(trigger)
    end
    return "item-center-" .. tostring(id or 0)
end
local _____6A21_5757_5B9E_4F8BID = _____521B_5EFA_7269_54C1_4E8B_4EF6_4E2D_5FC3_5B9E_4F8BID()
local pickupTrigger = nil
local dropTrigger = nil
local useTrigger = nil
local listenerIdCounter = 0
--- 获取下一个监听器ID
local function getNextListenerId()
    listenerIdCounter = listenerIdCounter + 1
    return listenerIdCounter
end
local function _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_5355_4F4D()
    local context = playerUnitEvent["取当前玩家单位物品事件上下文"]()
    local ____temp_0
    if context ~= nil then
        ____temp_0 = context.triggerUnit
    else
        ____temp_0 = GetTriggerUnit()
    end
    return ____temp_0
end
local function _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_7269_54C1()
    local context = playerUnitEvent["取当前玩家单位物品事件上下文"]()
    local ____temp_1
    if context ~= nil then
        ____temp_1 = context.manipulatedItem
    else
        ____temp_1 = GetManipulatedItem()
    end
    return ____temp_1
end
--- 分发拾取事件到所有监听器
local function dispatchPickupEvent()
    local unit = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_5355_4F4D()
    local item = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_7269_54C1()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #pickupListeners do
            local callback = pickupListeners[i + 1]
            if callback ~= nil and callback ~= nil then
                callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 分发丢弃事件到所有监听器
local function dispatchDropEvent()
    local unit = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_5355_4F4D()
    local item = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_7269_54C1()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #dropListeners do
            local callback = dropListeners[i + 1]
            if callback ~= nil and callback ~= nil then
                callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 分发使用事件到所有监听器
local function dispatchUseEvent()
    local unit = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_5355_4F4D()
    local item = _____53D6_5F53_524D_7269_54C1_4E8B_4EF6_7269_54C1()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #useListeners do
            local callback = useListeners[i + 1]
            if callback ~= nil and callback ~= nil then
                callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 初始化拾取事件触发器
local function initPickupTrigger()
    if pickupTrigger ~= nil then
        return
    end
    pickupTrigger = jass.CreateTrigger()
    if pickupTrigger == nil or pickupTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(pickupTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_PICKUP_ITEM)
    jass.TriggerAddAction(pickupTrigger, dispatchPickupEvent)
end
--- 初始化丢弃事件触发器
local function initDropTrigger()
    if dropTrigger ~= nil then
        return
    end
    dropTrigger = jass.CreateTrigger()
    if dropTrigger == nil or dropTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(dropTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DROP_ITEM)
    jass.TriggerAddAction(dropTrigger, dispatchDropEvent)
end
--- 初始化使用事件触发器
local function initUseTrigger()
    if useTrigger ~= nil then
        return
    end
    useTrigger = jass.CreateTrigger()
    if useTrigger == nil or useTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(useTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM)
    jass.TriggerAddAction(useTrigger, dispatchUseEvent)
end
--- 注册物品拾取事件监听。
-- 监听器会复用统一的拾取总触发器，返回值是当前监听的内部 id。
function ____exports.onItemPickup(callback)
    initPickupTrigger()
    local id = getNextListenerId()
    pickupListenerIds[#pickupListenerIds + 1] = id
    pickupListeners[#pickupListeners + 1] = callback
    return id
end
--- 注册物品丢弃事件监听。
-- 监听器会复用统一的丢弃总触发器，返回值是当前监听的内部 id。
function ____exports.onItemDrop(callback)
    initDropTrigger()
    local id = getNextListenerId()
    dropListenerIds[#dropListenerIds + 1] = id
    dropListeners[#dropListeners + 1] = callback
    return id
end
--- 注册物品使用事件监听。
-- 监听器会复用统一的使用总触发器，返回值是当前监听的内部 id。
function ____exports.onItemUse(callback)
    initUseTrigger()
    local id = getNextListenerId()
    useListenerIds[#useListenerIds + 1] = id
    useListeners[#useListeners + 1] = callback
    return id
end
--- 取消注册物品拾取事件监听器
-- 
-- @param id 监听器ID
function ____exports.offItemPickup(id)
    do
        local i = 0
        while i < #pickupListenerIds do
            if pickupListenerIds[i + 1] == id then
                __TS__ArraySplice(pickupListenerIds, i, 1)
                __TS__ArraySplice(pickupListeners, i, 1)
                return
            end
            i = i + 1
        end
    end
end
--- 取消注册物品丢弃事件监听器
-- 
-- @param id 监听器ID
function ____exports.offItemDrop(id)
    do
        local i = 0
        while i < #dropListenerIds do
            if dropListenerIds[i + 1] == id then
                __TS__ArraySplice(dropListenerIds, i, 1)
                __TS__ArraySplice(dropListeners, i, 1)
                return
            end
            i = i + 1
        end
    end
end
--- 取消注册物品使用事件监听器
-- 
-- @param id 监听器ID
function ____exports.offItemUse(id)
    do
        local i = 0
        while i < #useListenerIds do
            if useListenerIds[i + 1] == id then
                __TS__ArraySplice(useListenerIds, i, 1)
                __TS__ArraySplice(useListeners, i, 1)
                return
            end
            i = i + 1
        end
    end
end
--- 返回当前三类物品事件的监听器数量，主要用于调试排查重复注册。
function ____exports.getListenerCounts()
    return {pickup = #pickupListeners, drop = #dropListeners, use = #useListeners}
end
return ____exports
