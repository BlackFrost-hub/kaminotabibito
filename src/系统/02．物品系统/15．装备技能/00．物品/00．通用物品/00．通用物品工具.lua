--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyIntegerSafe = ____require_result_0.getObjectPropertyIntegerSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_2["获取玩家英雄单位组"]
local _____6838_5FC3_662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_2["是玩家英雄组单位"]
local GetItemType = jass.GetItemType
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local GetHandleId = jass.GetHandleId
local IsItemPowerup = jass.IsItemPowerup
local RemoveItem = jass.RemoveItem
local ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED
local ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE
local _____7269_7F16_7C7B_578B__7269_54C1 = 3
local _____4E0D_8D70_5403_4E66_6B8B_7559_6E05_7406_7269_54C1ID = {
    [stringToFourCCSafe("I0FK")] = true,
    [stringToFourCCSafe("I0FL")] = true
}
____exports["是玩家英雄组单位"] = function(_____5355_4F4D)
    return _____6838_5FC3_662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5355_4F4D)
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
    local _____7269_54C1_7C7B_578BID = GetItemTypeId(_____7269_54C1)
    if _____4E0D_8D70_5403_4E66_6B8B_7559_6E05_7406_7269_54C1ID[_____7269_54C1_7C7B_578BID] == true then
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
    return getObjectPropertyIntegerSafe(_____7269_7F16_7C7B_578B__7269_54C1, _____7269_54C1_7C7B_578BID, "perishable") == 1
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
