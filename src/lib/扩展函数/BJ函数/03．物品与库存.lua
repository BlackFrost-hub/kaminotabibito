--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
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
function ____exports.RemoveItemFromStockBJ(self, itemId, whichUnit)
    if type(jass.RemoveItemFromStock) == "function" then
        jass.RemoveItemFromStock(whichUnit, itemId)
    end
end
function ____exports.AddItemToStockBJ(self, itemId, whichUnit, currentStock, stockMax)
    if type(jass.AddItemToStock) == "function" then
        jass.AddItemToStock(whichUnit, itemId, currentStock, stockMax)
    end
end
return ____exports
