--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local UnitItemInSlot = jass.UnitItemInSlot
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local GetHandleId = jass.GetHandleId
local R2I = jass.R2I
local _____5355_4F4D_7269_54C1_7D2F_4F24_6B8B_7559_8868 = {}
local function _____751F_6210_7D2F_4F24_952E(unit, itemTypeId)
    return (tostring(GetHandleId(unit)) .. ":") .. tostring(itemTypeId)
end
____exports["获取单位指定装备"] = function(unit, itemTypeId)
    if unit == nil or unit == 0 or itemTypeId == 0 then
        return nil
    end
    do
        local slot = 0
        while slot < 6 do
            local item = UnitItemInSlot(unit, slot)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == itemTypeId then
                return item
            end
            slot = slot + 1
        end
    end
    return nil
end
--- 根据受到的伤害，按比例累计指定装备的物品次数。
-- 
-- @param unit 目标单位
-- @param 装备名 装备数据中的 name
-- @param 受到伤害 本次受到的伤害值
-- @param 比例 多少点伤害提升 1 次数，默认 1
-- @param 阈值 次数超过该值时返回 true，默认 0
-- @returns 是否超过阈值
____exports["单位物品累伤次数"] = function(unit, _____88C5_5907_540D, _____53D7_5230_4F24_5BB3, _____6BD4_4F8B, _____9608_503C, _____9009_9879)
    if _____6BD4_4F8B == nil then
        _____6BD4_4F8B = 1
    end
    if _____9608_503C == nil then
        _____9608_503C = 0
    end
    if unit == nil or unit == 0 then
        return false
    end
    if _____53D7_5230_4F24_5BB3 <= 0 then
        return false
    end
    if _____6BD4_4F8B <= 0 then
        return false
    end
    if (_____9009_9879 and _____9009_9879["是否在CD中"]) == true then
        return false
    end
    local itemId = resolveItemIdByName(_____88C5_5907_540D)
    if itemId == nil then
        return false
    end
    local itemTypeId = stringToFourCCSafe(itemId)
    if itemTypeId == 0 then
        return false
    end
    local item = ____exports["获取单位指定装备"](unit, itemTypeId)
    if item == nil then
        return false
    end
    local key = _____751F_6210_7D2F_4F24_952E(unit, itemTypeId)
    local currentRemain = _____5355_4F4D_7269_54C1_7D2F_4F24_6B8B_7559_8868[key] or 0
    local total = currentRemain + _____53D7_5230_4F24_5BB3
    local addCount = R2I(total / _____6BD4_4F8B)
    local _____8FBE_5230_9608_503C_540E_91CD_7F6E = (_____9009_9879 and _____9009_9879["达到阈值后重置"]) ~= false
    local nextCharges = GetItemCharges(item) + addCount
    local _____547D_4E2D_9608_503C = _____9608_503C > 0 and nextCharges >= _____9608_503C
    if addCount > 0 then
        if _____547D_4E2D_9608_503C and _____8FBE_5230_9608_503C_540E_91CD_7F6E then
            SetItemCharges(item, 1)
        else
            SetItemCharges(item, nextCharges)
        end
    end
    _____5355_4F4D_7269_54C1_7D2F_4F24_6B8B_7559_8868[key] = total - addCount * _____6BD4_4F8B
    return _____547D_4E2D_9608_503C
end
____exports.ItemDamageStackByDamage = ____exports["单位物品累伤次数"]
return ____exports
