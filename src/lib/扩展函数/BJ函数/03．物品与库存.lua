--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local bj_MAX_INVENTORY = 6
--- 默认当前库存（常见填表：1）
____exports.bj_STOCK_DEFAULT_CURRENT = 1
--- 默认最大库存（单格单件上架时常用 1）
____exports.bj_STOCK_DEFAULT_MAX = 1
--- 获取单位物品栏物品（1-based索引）
-- 对应JASS: UnitItemInSlotBJ
-- 将0-based转换为1-based索引
function ____exports.UnitItemInSlotBJ(self, whichUnit, itemSlot)
    return jass.UnitItemInSlot(whichUnit, itemSlot - 1)
end
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
--- 对齐 Blizzard.j：
-- function RemoveItemFromStockBJ takes integer itemId, unit whichUnit returns nothing
--     call RemoveItemFromStock(whichUnit, itemId)
-- endfunction
function ____exports.RemoveItemFromStockBJ(self, itemId, whichUnit)
    if type(jass.RemoveItemFromStock) == "function" then
        jass.RemoveItemFromStock(whichUnit, itemId)
    end
end
--- 对齐 Blizzard.j：
-- function AddItemToStockBJ takes integer itemId, unit whichUnit, integer currentStock, integer stockMax returns nothing
--     call AddItemToStock(whichUnit, itemId, currentStock, stockMax)
-- endfunction
function ____exports.AddItemToStockBJ(self, itemId, whichUnit, currentStock, stockMax)
    if type(jass.AddItemToStock) == "function" then
        jass.AddItemToStock(whichUnit, itemId, currentStock, stockMax)
    end
end
--- 对齐 Blizzard.j：
-- function AddUnitToStockBJ takes integer unitId, unit whichUnit, integer currentStock, integer stockMax returns nothing
--     call AddUnitToStock(whichUnit, unitId, currentStock, stockMax)
-- endfunction
function ____exports.AddUnitToStockBJ(self, unitId, whichUnit, currentStock, stockMax)
    if type(jass.AddUnitToStock) == "function" then
        jass.AddUnitToStock(whichUnit, unitId, currentStock, stockMax)
    end
end
--- 对齐 Blizzard.j：
-- function RemoveUnitFromStockBJ takes integer unitId, unit whichUnit returns nothing
--     call RemoveUnitFromStock(whichUnit, unitId)
-- endfunction
function ____exports.RemoveUnitFromStockBJ(self, unitId, whichUnit)
    if type(jass.RemoveUnitFromStock) == "function" then
        jass.RemoveUnitFromStock(whichUnit, unitId)
    end
end
return ____exports
