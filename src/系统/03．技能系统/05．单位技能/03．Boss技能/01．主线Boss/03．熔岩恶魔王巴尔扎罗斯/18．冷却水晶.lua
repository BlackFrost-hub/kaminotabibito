--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____6E05_9664_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["清除巴尔扎罗斯灼热"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local GetItemTypeId = jass.GetItemTypeId
local RemoveItem = jass.RemoveItem
local _____51B7_5374_6C34_6676_7269_54C1_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["地核召唤"]["冷却水晶物品ID"])
local _____51B7_5374_6C34_6676_5DF2_6CE8_518C = false
local function _____662F_51B7_5374_6C34_6676_7269_54C1(item)
    return item ~= nil and item ~= 0 and _____51B7_5374_6C34_6676_7269_54C1_7C7B_578BID ~= 0 and GetItemTypeId(item) == _____51B7_5374_6C34_6676_7269_54C1_7C7B_578BID
end
local function ____on_51B7_5374_6C34_6676_62FE_53D6(unit, item)
    if not _____662F_51B7_5374_6C34_6676_7269_54C1(item) then
        return
    end
    _____6E05_9664_5DF4_5C14_624E_7F57_65AF_707C_70ED(unit)
    RemoveItem(item)
end
____exports["注册巴尔扎罗斯冷却水晶"] = function()
    if _____51B7_5374_6C34_6676_5DF2_6CE8_518C then
        return
    end
    _____51B7_5374_6C34_6676_5DF2_6CE8_518C = true
    onItemPickup(____on_51B7_5374_6C34_6676_62FE_53D6)
end
return ____exports
