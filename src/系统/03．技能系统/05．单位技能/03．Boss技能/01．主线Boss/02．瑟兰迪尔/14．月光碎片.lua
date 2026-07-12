--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_1["施加移速提升Buff"]
local ____require_result_2 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlayReuse = ____require_result_2.Sound3DII_CooPlayReuse
local CreateItem = jass.CreateItem
local GetItemTypeId = jass.GetItemTypeId
local RemoveItem = jass.RemoveItem
local _____6708_5149_788E_7247_7269_54C1_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光碎片"]["物品ID"])
local _____6708_5149_788E_7247_5DF2_6CE8_518C = false
local function _____662F_6708_5149_788E_7247_7269_54C1(item)
    return item ~= nil and item ~= 0 and GetItemTypeId(item) == _____6708_5149_788E_7247_7269_54C1_7C7B_578BID
end
local function ____on_6708_5149_788E_7247_62FE_53D6(unit, item)
    if not _____662F_6708_5149_788E_7247_7269_54C1(item) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光碎片"]
    _____65BD_52A0_79FB_901F_63D0_5347Buff(unit, unit, {
        BuffID = config.BuffID,
        ["持续时间"] = config["持续秒"],
        ["基础移速百分比"] = config["基础移速百分比"],
        ["图标路径"] = config["图标"],
        ["特效路径"] = config["特效"]
    })
    RemoveItem(item)
end
____exports["创建瑟兰迪尔月光碎片"] = function(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光碎片"]
    Sound3DII_CooPlayReuse(
        config["破裂音效"],
        x,
        y,
        0,
        config["破裂音效裁断距离"]
    )
    return CreateItem(_____6708_5149_788E_7247_7269_54C1_7C7B_578BID, x, y)
end
____exports["注册瑟兰迪尔月光碎片"] = function()
    if _____6708_5149_788E_7247_5DF2_6CE8_518C then
        return
    end
    _____6708_5149_788E_7247_5DF2_6CE8_518C = true
    onItemPickup(____on_6708_5149_788E_7247_62FE_53D6)
end
return ____exports
