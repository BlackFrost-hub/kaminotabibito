local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyIntegerSafe = ____require_result_0.getObjectPropertyIntegerSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____6838_5FC3_662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_2["是玩家英雄组单位"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.01．英雄选择.00．英雄选择配置表")
local _____82F1_96C4_9009_62E9_914D_7F6E_8868 = ____require_result_3["英雄选择配置表"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local GetItemType = jass.GetItemType
local GetItemTypeId = jass.GetItemTypeId
local GetItemCharges = jass.GetItemCharges
local IsItemPowerup = jass.IsItemPowerup
local RemoveItem = jass.RemoveItem
local ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED
local ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE
local GetOwningPlayer = jass.GetOwningPlayer
local _____7269_7F16_7C7B_578B__7269_54C1 = 3
local _____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_5217_8868 = {
    "I01A",
    "I04U",
    "I09A",
    "I09L",
    "I09T",
    "I0HE"
}
local _____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_96C6_5408 = __TS__New(Set)
do
    local i = 0
    while i < #_____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_5217_8868 do
        _____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_96C6_5408:add(stringToFourCCSafe(_____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_5217_8868[i + 1]))
        i = i + 1
    end
end
local _____4E0D_8D70_5403_4E66_6B8B_7559_6E05_7406_7269_54C1ID = {
    [stringToFourCCSafe("I0FK")] = true,
    [stringToFourCCSafe("I0FL")] = true,
    [stringToFourCCSafe("I01A")] = true,
    [stringToFourCCSafe("I04U")] = true,
    [stringToFourCCSafe("I09A")] = true,
    [stringToFourCCSafe("I09L")] = true,
    [stringToFourCCSafe("I09T")] = true
}
____exports["是玩家英雄组单位"] = function(_____5355_4F4D)
    return _____6838_5FC3_662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5355_4F4D)
end
____exports["是玩家英雄或BB"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____6838_5FC3_662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____5355_4F4D) then
        return true
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return false
    end
    local BB = YDUserDataGetSafe("player", _____73A9_5BB6, _____82F1_96C4_9009_62E9_914D_7F6E_8868["记录玩家BB键"], "unit")
    return BB == _____5355_4F4D
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
____exports["是一次性打造壳类型ID"] = function(_____7269_54C1_7C7B_578BID)
    return _____4E00_6B21_6027_6253_9020_58F3_7269_54C1ID_96C6_5408:has(_____7269_54C1_7C7B_578BID)
end
____exports["是一次性打造壳"] = function(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return ____exports["是一次性打造壳类型ID"](GetItemTypeId(_____7269_54C1))
end
____exports["删除物品"] = function(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    RemoveItem(_____7269_54C1)
end
return ____exports
