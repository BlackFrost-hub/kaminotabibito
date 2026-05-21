--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local getObjectPropertyIntegerSafe = ____require_result_0.getObjectPropertyIntegerSafe
local GetItemType = jass.GetItemType
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local GetHandleId = jass.GetHandleId
local IsItemPowerup = jass.IsItemPowerup
local IsUnitInGroup = jass.IsUnitInGroup
local RemoveItem = jass.RemoveItem
local ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED
local ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE
local _____7269_7F16_7C7B_578B__7269_54C1 = 3
____exports["获取玩家英雄单位组"] = function()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
____exports["是玩家英雄组单位"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = ____exports["获取玩家英雄单位组"]()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return false
    end
    return IsUnitInGroup(_____5355_4F4D, _____73A9_5BB6_82F1_96C4_7EC4) == true
end
____exports["物品类型ID在列表中"] = function(_____7269_54C1_7C7B_578BID, _____5217_8868)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1] == _____7269_54C1_7C7B_578BID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["是可清理吃书残留"] = function(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    local _____7269_54C1_7C7B_578B = GetItemType(_____7269_54C1)
    local _____662F_5145_80FD = _____7269_54C1_7C7B_578B == ITEM_TYPE_CHARGED
    local _____662F_53EF_8D2D_4E70 = _____7269_54C1_7C7B_578B == ITEM_TYPE_PURCHASABLE
    if not _____662F_5145_80FD and not _____662F_53EF_8D2D_4E70 then
        return false
    end
    if GetItemCharges(_____7269_54C1) > 1 then
        return false
    end
    if IsItemPowerup(_____7269_54C1) ~= true then
        return false
    end
    return getObjectPropertyIntegerSafe(
        _____7269_7F16_7C7B_578B__7269_54C1,
        GetItemTypeId(_____7269_54C1),
        "perishable"
    ) == 1
end
____exports["删除物品"] = function(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    RemoveItem(_____7269_54C1)
end
____exports["取物品句柄ID"] = function(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return 0
    end
    return GetHandleId(_____7269_54C1) or 0
end
return ____exports
