local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型")
local _____7269_54C1_662F_5426_4E3B_6B66_5668 = ____require_result_3["物品是否主武器"]
local _____540C_6B65_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B = ____require_result_3["同步单位主武器攻击类型"]
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local IsUnitInGroup = jass.IsUnitInGroup
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____5F85_5237_65B0_5355_4F4D_8868 = {}
local _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C = false
local _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_5DF2_6392_961F = false
local function _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
local function _____83B7_53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if not IsUnitType(unit, UNIT_TYPE_HERO) then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == nil or _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == 0 then
        return false
    end
    return IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4) == true
end
local function _____6E05_7A7A_5F85_5237_65B0_5355_4F4D_8868()
    for key in pairs(_____5F85_5237_65B0_5355_4F4D_8868) do
        __TS__Delete(_____5F85_5237_65B0_5355_4F4D_8868, key)
    end
end
local function ____on_6279_91CF_5237_65B0_4E3B_6B66_5668_653B_51FB_7C7B_578B()
    _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_5DF2_6392_961F = false
    for key in pairs(_____5F85_5237_65B0_5355_4F4D_8868) do
        do
            local unit = _____5F85_5237_65B0_5355_4F4D_8868[key]
            if unit == nil or unit == 0 then
                goto __continue13
            end
            if not _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4(unit) then
                goto __continue13
            end
            _____540C_6B65_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
        end
        ::__continue13::
    end
    _____6E05_7A7A_5F85_5237_65B0_5355_4F4D_8868()
end
local function _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
    local unitId = _____83B7_53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    _____5F85_5237_65B0_5355_4F4D_8868[unitId] = unit
    if _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_5DF2_6392_961F then
        return
    end
    _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_5DF2_6392_961F = true
    addDelayedCallback(50, ____on_6279_91CF_5237_65B0_4E3B_6B66_5668_653B_51FB_7C7B_578B)
end
local function ____on_4E3B_6B66_5668_62FE_53D6(unit, item)
    if not _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4(unit) then
        return
    end
    if not _____7269_54C1_662F_5426_4E3B_6B66_5668(item) then
        return
    end
    _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
end
local function ____on_4E3B_6B66_5668_4E22_5F03(unit, item)
    if not _____5355_4F4D_5C5E_4E8E_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4(unit) then
        return
    end
    if not _____7269_54C1_662F_5426_4E3B_6B66_5668(item) then
        return
    end
    _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
end
____exports["初始化主武器攻击类型联动"] = function()
    if _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C = true
    onItemPickup(____on_4E3B_6B66_5668_62FE_53D6)
    onItemDrop(____on_4E3B_6B66_5668_4E22_5F03)
end
____exports["初始化主武器攻击类型联动"]()
return ____exports
