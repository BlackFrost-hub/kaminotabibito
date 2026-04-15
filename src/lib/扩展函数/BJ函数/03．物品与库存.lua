--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____jglobals_bj_MAX_INVENTORY_0 = jglobals.bj_MAX_INVENTORY
if ____jglobals_bj_MAX_INVENTORY_0 == nil then
    ____jglobals_bj_MAX_INVENTORY_0 = 6
end
____exports.bj_MAX_INVENTORY = ____jglobals_bj_MAX_INVENTORY_0
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
        while index < ____exports.bj_MAX_INVENTORY do
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
        while index < ____exports.bj_MAX_INVENTORY do
            local indexItem = jass.UnitItemInSlot(whichUnit, index)
            if indexItem ~= nil and jass.GetItemTypeId(indexItem) == itemId then
                local charges = jass.GetItemCharges(indexItem)
                local ____temp_1
                if charges > 0 then
                    ____temp_1 = charges
                else
                    ____temp_1 = 1
                end
                totalCount = totalCount + ____temp_1
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
--- 获取物品位置（坐标）
-- 对应JASS: GetItemLoc
function ____exports.GetItemLoc(self, whichItem)
    if whichItem == nil or whichItem == 0 then
        return nil
    end
    if type(jass.GetItemX) == "function" and type(jass.GetItemY) == "function" then
        local x = jass.GetItemX(whichItem)
        local y = jass.GetItemY(whichItem)
        if type(jass.Location) == "function" then
            return jass.Location(x, y)
        end
    end
    return nil
end
--- 在指定位置创建物品
-- 对应JASS: CreateItemLoc
function ____exports.CreateItemLoc(self, itemId, loc)
    if loc == nil or loc == 0 then
        return nil
    end
    if type(jass.CreateItem) ~= "function" then
        return nil
    end
    local ____temp_2
    if type(jass.GetLocationX) == "function" then
        ____temp_2 = jass.GetLocationX(loc)
    else
        ____temp_2 = 0
    end
    local x = ____temp_2
    local ____temp_3
    if type(jass.GetLocationY) == "function" then
        ____temp_3 = jass.GetLocationY(loc)
    else
        ____temp_3 = 0
    end
    local y = ____temp_3
    return jass.CreateItem(itemId, x, y)
end
--- 设置物品位置
-- 对应JASS: SetItemPositionLoc
function ____exports.SetItemPositionLoc(self, whichItem, loc)
    if whichItem == nil or whichItem == 0 then
        return
    end
    if loc == nil or loc == 0 then
        return
    end
    if type(jass.SetItemPosition) ~= "function" then
        return
    end
    local ____temp_4
    if type(jass.GetLocationX) == "function" then
        ____temp_4 = jass.GetLocationX(loc)
    else
        ____temp_4 = 0
    end
    local x = ____temp_4
    local ____temp_5
    if type(jass.GetLocationY) == "function" then
        ____temp_5 = jass.GetLocationY(loc)
    else
        ____temp_5 = 0
    end
    local y = ____temp_5
    jass.SetItemPosition(whichItem, x, y)
end
--- 单位在指定坐标丢弃物品
-- 对应JASS: UnitDropItemPointLoc
function ____exports.UnitDropItemPointLoc(self, whichUnit, whichItem, loc)
    if whichUnit == nil or whichUnit == 0 then
        return false
    end
    if whichItem == nil or whichItem == 0 then
        return false
    end
    if loc == nil or loc == 0 then
        return false
    end
    if type(jass.UnitDropItemPoint) ~= "function" then
        return false
    end
    local ____temp_6
    if type(jass.GetLocationX) == "function" then
        ____temp_6 = jass.GetLocationX(loc)
    else
        ____temp_6 = 0
    end
    local x = ____temp_6
    local ____temp_7
    if type(jass.GetLocationY) == "function" then
        ____temp_7 = jass.GetLocationY(loc)
    else
        ____temp_7 = 0
    end
    local y = ____temp_7
    return jass.UnitDropItemPoint(whichUnit, whichItem, x, y)
end
--- 单位在指定坐标使用物品
-- 对应JASS: UnitUseItemPointLoc
function ____exports.UnitUseItemPointLoc(self, whichUnit, whichItem, loc)
    if whichUnit == nil or whichUnit == 0 then
        return false
    end
    if whichItem == nil or whichItem == 0 then
        return false
    end
    if loc == nil or loc == 0 then
        return false
    end
    if type(jass.UnitUseItemPoint) ~= "function" then
        return false
    end
    local ____temp_8
    if type(jass.GetLocationX) == "function" then
        ____temp_8 = jass.GetLocationX(loc)
    else
        ____temp_8 = 0
    end
    local x = ____temp_8
    local ____temp_9
    if type(jass.GetLocationY) == "function" then
        ____temp_9 = jass.GetLocationY(loc)
    else
        ____temp_9 = 0
    end
    local y = ____temp_9
    jass.UnitUseItemPoint(whichUnit, whichItem, x, y)
    return true
end
return ____exports
