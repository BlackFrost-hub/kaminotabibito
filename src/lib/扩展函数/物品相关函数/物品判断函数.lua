--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
____exports["物品是否存在"] = function(item)
    return item ~= nil and item ~= 0
end
function ____exports.UnitHasItemOfTypeBJ(whichUnit, itemTypeId)
    if not whichUnit then
        return false
    end
    do
        local slot = 0
        while slot < 6 do
            local item = jass:UnitItemInSlot(whichUnit, slot)
            if item and jass:GetItemTypeId(item) == itemTypeId then
                return true
            end
            slot = slot + 1
        end
    end
    return false
end
function ____exports.UnitGetItemByTypeId(whichUnit, itemTypeId)
    if not whichUnit then
        return nil
    end
    do
        local slot = 0
        while slot < 6 do
            local item = jass:UnitItemInSlot(whichUnit, slot)
            if item and jass:GetItemTypeId(item) == itemTypeId then
                return item
            end
            slot = slot + 1
        end
    end
    return nil
end
function ____exports.GetInventoryIndexOfItemTypeBJ(whichUnit, itemId)
    if not whichUnit then
        return 0
    end
    do
        local i = 0
        while i < 6 do
            local item = jass:UnitItemInSlot(whichUnit, i)
            if item and jass:GetItemTypeId(item) == itemId then
                return i + 1
            end
            i = i + 1
        end
    end
    return 0
end
function ____exports.GetItemOfTypeFromUnitBJ(whichUnit, itemId)
    local index = ____exports.GetInventoryIndexOfItemTypeBJ(whichUnit, itemId)
    if index == 0 then
        return nil
    end
    return jass:UnitItemInSlot(whichUnit, index - 1)
end
function ____exports.GetItemTypeTotalCountByChargesBJ(whichUnit, itemId)
    if not whichUnit then
        return 0
    end
    local total = 0
    do
        local i = 0
        while i < 6 do
            do
                local item = jass:UnitItemInSlot(whichUnit, i)
                if not item then
                    goto __continue23
                end
                if jass:GetItemTypeId(item) ~= itemId then
                    goto __continue23
                end
                local ch = jass:GetItemCharges(item)
                total = total + (ch > 0 and ch or 1)
            end
            ::__continue23::
            i = i + 1
        end
    end
    return total
end
function ____exports.ConsumeItemTypeCountByChargesBJ(whichUnit, itemId, needCount)
    if not whichUnit or itemId == 0 or needCount <= 0 then
        return false
    end
    local total = ____exports.GetItemTypeTotalCountByChargesBJ(whichUnit, itemId)
    if total < needCount then
        return false
    end
    local remain = needCount
    do
        local i = 0
        while i < 6 do
            do
                if remain <= 0 then
                    break
                end
                local item = jass:UnitItemInSlot(whichUnit, i)
                if not item then
                    goto __continue30
                end
                if jass:GetItemTypeId(item) ~= itemId then
                    goto __continue30
                end
                local ch = jass:GetItemCharges(item)
                if ch > 0 then
                    if ch > remain then
                        jass:SetItemCharges(item, ch - remain)
                        remain = 0
                    else
                        remain = remain - ch
                        jass:RemoveItem(item)
                    end
                else
                    remain = remain - 1
                    jass:RemoveItem(item)
                end
            end
            ::__continue30::
            i = i + 1
        end
    end
    return remain <= 0
end
function ____exports.TryGiveItemToUnitBJ(targetUnit, item)
    if not targetUnit or not item then
        return false
    end
    local ok = jass:UnitAddItem(targetUnit, item)
    return ok == true or ok == 1
end
function ____exports.ReturnItemToHeroOrDropBJ(item, fromUnit, hero)
    if not item or not fromUnit or not hero then
        return "failed"
    end
    if ____exports.TryGiveItemToUnitBJ(hero, item) then
        return "added"
    end
    jass:UnitRemoveItem(fromUnit, item)
    local x = jass:GetUnitX(hero)
    local y = jass:GetUnitY(hero)
    jass:SetItemPosition(item, x, y)
    return "dropped"
end
return ____exports
