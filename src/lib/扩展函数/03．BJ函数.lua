--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- BJ扩展函数
-- 注册任意玩家单位事件的便捷封装
local jass = require("jass.common")
local MAX_PLAYER_SLOTS = 16
--- 为所有玩家注册单位事件（等同于TriggerRegisterAnyUnitEventBJ）
-- 
-- @param trig 触发器
-- @param whichEvent 玩家单位事件类型（如 EVENT_UNIT_USE_ITEM ）
function ____exports.TriggerRegisterAnyUnitEventBJ(self, trig, whichEvent)
    do
        local index = 0
        while index < MAX_PLAYER_SLOTS do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trig,
                    jass.Player(index),
                    whichEvent,
                    nil
                )
            end
            index = index + 1
        end
    end
end
--- 获取单位的当前命令ID
-- 
-- @param unit 单位
-- @returns 命令ID，如果获取失败返回0
function ____exports.GetUnitCurrentOrder(self, unit)
    if type(jass.GetUnitCurrentOrder) == "function" then
        return jass.GetUnitCurrentOrder(unit)
    end
    return 0
end
--- 将命令ID转换为4字符字符串（反向解析FourCC）
-- 
-- @param orderId 命令ID
-- @returns 4字符字符串
function ____exports.OrderIdToString(self, orderId)
    local c1 = orderId % 256
    local c2 = math.floor(orderId / 256) % 256
    local c3 = math.floor(orderId / 256 / 256) % 256
    local c4 = math.floor(orderId / 256 / 256 / 256) % 256
    return string.char(c1, c2, c3, c4)
end
--- 获取当前触发事件的技能ID
-- 
-- @returns 技能ID，如果获取失败返回0
function ____exports.GetSpellAbilityId(self)
    if type(jass.GetSpellAbilityId) == "function" then
        return jass.GetSpellAbilityId()
    end
    return 0
end
--- 从单位商店中移除物品
-- 
-- @param itemId 物品ID
-- @param whichUnit 商店单位
function ____exports.RemoveItemFromStockBJ(self, itemId, whichUnit)
    if type(jass.RemoveItemFromStock) == "function" then
        jass.RemoveItemFromStock(whichUnit, itemId)
    end
end
--- 最后创建的特效（对应 bj_lastCreatedEffect）
____exports.lastCreatedEffect = nil
--- 在目标单位/物品的指定绑定点创建特效
-- 
-- @param attachPointName 绑定点名称（如 "origin", "overhead", "chest" 等）
-- @param targetWidget 目标单位或物品
-- @param modelName 特效模型路径
-- @returns 特效句柄
function ____exports.AddSpecialEffectTargetUnitBJ(self, attachPointName, targetWidget, modelName)
    if type(jass.AddSpecialEffectTarget) == "function" then
        ____exports.lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName)
        return ____exports.lastCreatedEffect
    end
    return nil
end
local bj_MAX_INVENTORY = 6
function ____exports.GetInventoryIndexOfItemTypeBJ(self, whichUnit, itemId)
    do
        local index = 0
        while index < bj_MAX_INVENTORY do
            local indexItem = jass.UnitItemInSlot(whichUnit, index)
            if indexItem ~= nil and jass.GetItemTypeId(indexItem) == itemId then
                return index
            end
            index = index + 1
        end
    end
    return -1
end
function ____exports.GetItemOfTypeFromUnitBJ(self, whichUnit, itemId)
    local index = ____exports.GetInventoryIndexOfItemTypeBJ(nil, whichUnit, itemId)
    if index < 0 then
        return nil
    end
    return jass.UnitItemInSlot(whichUnit, index)
end
function ____exports.GetItemTypeCountInUnitBJ(self, whichUnit, itemId)
    local totalCount = 0
    do
        local index = 0
        while index < bj_MAX_INVENTORY do
            local indexItem = jass.UnitItemInSlot(whichUnit, index)
            if indexItem ~= nil and jass.GetItemTypeId(indexItem) == itemId then
                local charges = jass.GetItemCharges(indexItem)
                local ____temp_0
                if charges > 0 then
                    ____temp_0 = charges
                else
                    ____temp_0 = 1
                end
                totalCount = totalCount + ____temp_0
            end
            index = index + 1
        end
    end
    return totalCount
end
function ____exports.RemoveItemTypeFromUnitBJ(self, whichUnit, itemId, count)
    local removedCount = 0
    while removedCount < count do
        local item = ____exports.GetItemOfTypeFromUnitBJ(nil, whichUnit, itemId)
        if item == nil then
            break
        end
        local charges = jass.GetItemCharges(item)
        if charges > 1 then
            local needRemove = count - removedCount
            if charges > needRemove then
                jass.SetItemCharges(item, charges - needRemove)
                removedCount = removedCount + needRemove
                break
            else
                removedCount = removedCount + charges
                jass.RemoveItem(item)
            end
        else
            removedCount = removedCount + 1
            jass.RemoveItem(item)
        end
    end
    return removedCount
end
return ____exports
