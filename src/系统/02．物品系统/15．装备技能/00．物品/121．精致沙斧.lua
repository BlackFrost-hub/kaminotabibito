--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____53D6_5355_4F4DX = ____require_result_3["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_3["取单位Y"]
local _____83B7_53D6_8303_56F4_53CB_519B = ____require_result_3["获取范围友军"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断")
local _____662F_5426_82F1_96C4_5355_4F4D = ____require_result_4["是否英雄单位"]
local _____7CBE_81F4_6C99_65A7_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("精致沙斧"))
local _____641C_7D22_534A_5F84 = 800
local _____6BCF_540D_53CB_519B_51CF_4F24 = 0.03
local function _____7EDF_8BA1_8303_56F4_53CB_65B9_82F1_96C4_6570_91CF(target)
    local allies = _____83B7_53D6_8303_56F4_53CB_519B(
        target,
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target),
        _____641C_7D22_534A_5F84
    )
    local count = 0
    do
        local i = 0
        while i < #allies do
            do
                local unit = allies[i + 1]
                if unit == nil or unit == 0 or unit == target then
                    goto __continue4
                end
                if _____662F_5426_82F1_96C4_5355_4F4D(unit) ~= true then
                    goto __continue4
                end
                count = count + 1
            end
            ::__continue4::
            i = i + 1
        end
    end
    return count
end
____exports["处理精致沙斧伤害修正"] = function(context, _____5F53_524D_4F24_5BB3)
    if _____7CBE_81F4_6C99_65A7_7269_54C1ID == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if context == nil or context.target == nil or context.target == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.target, _____7CBE_81F4_6C99_65A7_7269_54C1ID) then
        return _____5F53_524D_4F24_5BB3
    end
    local _____53CB_519B_82F1_96C4_6570_91CF = _____7EDF_8BA1_8303_56F4_53CB_65B9_82F1_96C4_6570_91CF(context.target)
    if not (_____53CB_519B_82F1_96C4_6570_91CF > 0) then
        return _____5F53_524D_4F24_5BB3
    end
    return _____5F53_524D_4F24_5BB3 * (1 - _____6BCF_540D_53CB_519B_51CF_4F24 * _____53CB_519B_82F1_96C4_6570_91CF)
end
return ____exports
