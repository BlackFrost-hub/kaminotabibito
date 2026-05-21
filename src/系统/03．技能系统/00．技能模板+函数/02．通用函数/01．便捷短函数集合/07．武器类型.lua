--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 便捷短函数 - 武器类型
local jass = require("jass.common")
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_914D_7F6E = ____require_result_0["获取玩家英雄配置"]
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E = ____require_result_0["获取单位玩家英雄配置"]
local ____require_result_1 = require("系统.02．物品系统.01．装备数据")
local items = ____require_result_1.items
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local fourCCToString = ____require_result_2.fourCCToString
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.04．单位工具")
local Ir_SetUnitAttackType = ____require_result_3.Ir_SetUnitAttackType
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
local _____6B66_5668_7C7B_578B_5230_653B_51FB_7C7B_578B_7F16_53F7 = {
    [""] = 0,
    ["拳头"] = 0,
    ["剑"] = 1,
    ["枪"] = 2,
    ["斧锤"] = 3,
    ["法杖"] = 4,
    ["匕首"] = 5,
    ["弓箭"] = 6
}
local function _____83B7_53D6_7269_54C1_539F_59CBID_5B57_7B26_4E32(itemTypeId)
    if itemTypeId == 0 then
        return ""
    end
    return fourCCToString(itemTypeId) or ""
end
local function _____83B7_53D6_7269_54C1_6570_636E(itemTypeId)
    local rawcode = _____83B7_53D6_7269_54C1_539F_59CBID_5B57_7B26_4E32(itemTypeId)
    if rawcode == "" then
        return nil
    end
    return items[rawcode] or nil
end
____exports["获取玩家英雄配置武器类型"] = function(heroRawcode)
    local _____914D_7F6E = _____83B7_53D6_73A9_5BB6_82F1_96C4_914D_7F6E(heroRawcode)
    if _____914D_7F6E == nil then
        return ""
    end
    return _____914D_7F6E.weaponType or ""
end
____exports["获取单位玩家英雄武器类型"] = function(unit)
    local _____914D_7F6E = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E(unit)
    if _____914D_7F6E == nil then
        return ""
    end
    return _____914D_7F6E.weaponType or ""
end
____exports["单位武器类型是否"] = function(unit, ____type)
    if ____type == "" then
        return false
    end
    return ____exports["获取单位玩家英雄武器类型"](unit) == ____type
end
____exports["获取武器类型攻击类型编号"] = function(____type)
    return _____6B66_5668_7C7B_578B_5230_653B_51FB_7C7B_578B_7F16_53F7[____type] or 0
end
____exports["物品类型ID是否主武器"] = function(itemTypeId)
    local _____6570_636E = _____83B7_53D6_7269_54C1_6570_636E(itemTypeId)
    if _____6570_636E == nil then
        return false
    end
    return _____6570_636E.type == "主武器"
end
____exports["物品是否主武器"] = function(item)
    if item == nil or item == 0 then
        return false
    end
    return ____exports["物品类型ID是否主武器"](GetItemTypeId(item))
end
____exports["获取物品类型ID武器类型"] = function(itemTypeId)
    local _____6570_636E = _____83B7_53D6_7269_54C1_6570_636E(itemTypeId)
    if _____6570_636E == nil then
        return ""
    end
    return _____6570_636E.weaponType or ""
end
____exports["获取物品武器类型"] = function(item)
    if item == nil or item == 0 then
        return ""
    end
    return ____exports["获取物品类型ID武器类型"](GetItemTypeId(item))
end
____exports["获取单位当前主武器类型"] = function(unit)
    if unit == nil or unit == 0 then
        return ""
    end
    do
        local slot = 0
        while slot < 6 do
            do
                local item = UnitItemInSlot(unit, slot)
                if item == nil or item == 0 then
                    goto __continue24
                end
                if not ____exports["物品是否主武器"](item) then
                    goto __continue24
                end
                return ____exports["获取物品武器类型"](item)
            end
            ::__continue24::
            slot = slot + 1
        end
    end
    return ""
end
____exports["获取单位最终武器类型"] = function(unit)
    local _____4E3B_6B66_5668_7C7B_578B = ____exports["获取单位当前主武器类型"](unit)
    if _____4E3B_6B66_5668_7C7B_578B ~= "" then
        return _____4E3B_6B66_5668_7C7B_578B
    end
    return ____exports["获取单位玩家英雄武器类型"](unit)
end
____exports["获取单位最终攻击类型编号"] = function(unit)
    return ____exports["获取武器类型攻击类型编号"](____exports["获取单位最终武器类型"](unit))
end
____exports["同步单位主武器攻击类型"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____653B_51FB_7C7B_578B_7F16_53F7 = ____exports["获取单位最终攻击类型编号"](unit)
    if _____653B_51FB_7C7B_578B_7F16_53F7 <= 0 then
        return false
    end
    Ir_SetUnitAttackType(unit, _____653B_51FB_7C7B_578B_7F16_53F7)
    return true
end
____exports["获取英雄配置武器类型"] = ____exports["获取玩家英雄配置武器类型"]
____exports["获取单位英雄武器类型"] = ____exports["获取单位玩家英雄武器类型"]
return ____exports
