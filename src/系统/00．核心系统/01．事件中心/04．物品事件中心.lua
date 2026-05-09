local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 物品事件中心
-- 统一处理物品相关事件，减少触发器数量
-- 合并 EVENT_PLAYER_UNIT_PICKUP_ITEM / DROP_ITEM / USE_ITEM 事件
local jass = require("jass.common")
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
local pickupListeners = {}
local dropListeners = {}
local useListeners = {}
local pickupTrigger = nil
local dropTrigger = nil
local useTrigger = nil
local listenerIdCounter = 0
--- 获取下一个监听器ID
local function getNextListenerId(self)
    listenerIdCounter = listenerIdCounter + 1
    return listenerIdCounter
end
--- 分发拾取事件到所有监听器
local function dispatchPickupEvent(self)
    local unit = jass:GetTriggerUnit()
    local item = jass:GetManipulatedItem()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #pickupListeners do
            local listener = pickupListeners[i + 1]
            if listener ~= nil and listener ~= nil then
                listener:callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 分发丢弃事件到所有监听器
local function dispatchDropEvent(self)
    local unit = jass:GetTriggerUnit()
    local item = jass:GetManipulatedItem()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #dropListeners do
            local listener = dropListeners[i + 1]
            if listener ~= nil and listener ~= nil then
                listener:callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 分发使用事件到所有监听器
local function dispatchUseEvent(self)
    local unit = jass:GetTriggerUnit()
    local item = jass:GetManipulatedItem()
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    do
        local i = 0
        while i < #useListeners do
            local listener = useListeners[i + 1]
            if listener ~= nil and listener ~= nil then
                listener:callback(unit, item)
            end
            i = i + 1
        end
    end
end
--- 初始化拾取事件触发器
local function initPickupTrigger(self)
    if pickupTrigger ~= nil then
        return
    end
    pickupTrigger = jass:CreateTrigger()
    if pickupTrigger == nil or pickupTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(pickupTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_PICKUP_ITEM)
    jass:TriggerAddAction(pickupTrigger, dispatchPickupEvent)
end
--- 初始化丢弃事件触发器
local function initDropTrigger(self)
    if dropTrigger ~= nil then
        return
    end
    dropTrigger = jass:CreateTrigger()
    if dropTrigger == nil or dropTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(dropTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DROP_ITEM)
    jass:TriggerAddAction(dropTrigger, dispatchDropEvent)
end
--- 初始化使用事件触发器
local function initUseTrigger(self)
    if useTrigger ~= nil then
        return
    end
    useTrigger = jass:CreateTrigger()
    if useTrigger == nil or useTrigger == 0 then
        return
    end
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(useTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM)
    jass:TriggerAddAction(useTrigger, dispatchUseEvent)
end
--- 注册物品拾取事件监听。
-- 监听器会复用统一的拾取总触发器，返回值是当前监听的内部 id。
function ____exports.onItemPickup(self, callback)
    initPickupTrigger(nil)
    local id = getNextListenerId(nil)
    pickupListeners[#pickupListeners + 1] = {id = id, callback = callback}
    return id
end
--- 注册物品丢弃事件监听。
-- 监听器会复用统一的丢弃总触发器，返回值是当前监听的内部 id。
function ____exports.onItemDrop(self, callback)
    initDropTrigger(nil)
    local id = getNextListenerId(nil)
    dropListeners[#dropListeners + 1] = {id = id, callback = callback}
    return id
end
--- 注册物品使用事件监听。
-- 监听器会复用统一的使用总触发器，返回值是当前监听的内部 id。
function ____exports.onItemUse(self, callback)
    initUseTrigger(nil)
    local id = getNextListenerId(nil)
    useListeners[#useListeners + 1] = {id = id, callback = callback}
    return id
end
--- 取消注册物品拾取事件监听器
-- 
-- @param id 监听器ID
function ____exports.offItemPickup(self, id)
    do
        local i = 0
        while i < #pickupListeners do
            if pickupListeners[i + 1].id == id then
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
function ____exports.offItemDrop(self, id)
    do
        local i = 0
        while i < #dropListeners do
            if dropListeners[i + 1].id == id then
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
function ____exports.offItemUse(self, id)
    do
        local i = 0
        while i < #useListeners do
            if useListeners[i + 1].id == id then
                __TS__ArraySplice(useListeners, i, 1)
                return
            end
            i = i + 1
        end
    end
end
--- 返回当前三类物品事件的监听器数量，主要用于调试排查重复注册。
function ____exports.getListenerCounts(self)
    return {pickup = #pickupListeners, drop = #dropListeners, use = #useListeners}
end
return ____exports
