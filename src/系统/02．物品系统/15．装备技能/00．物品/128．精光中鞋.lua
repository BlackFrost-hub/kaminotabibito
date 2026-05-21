--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritRateModifier = ____require_result_0.registerCritRateModifier
local ____require_result_1 = require("系统.04．伤害系统.04．命中系统.01．命中核心")
local _____8BFB_53D6_6B63_5411_547D_4E2D_7387_504F_79FB = ____require_result_1["读取正向命中率偏移"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_2.resolveItemIdByName
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_4.UnitHasItemOfTypeBJ
local _____7CBE_5149_4E2D_978B_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("精光中鞋"))
local function _____7CBE_5149_4E2D_978B_66B4_51FB_7387_4FEE_6B63(context)
    if _____7CBE_5149_4E2D_978B_7269_54C1ID == 0 then
        return context["暴击率"]
    end
    if not UnitHasItemOfTypeBJ(context["暴击归属单位"], _____7CBE_5149_4E2D_978B_7269_54C1ID) then
        return context["暴击率"]
    end
    return context["暴击率"] + _____8BFB_53D6_6B63_5411_547D_4E2D_7387_504F_79FB(context["暴击归属单位"])
end
____exports["init精光中鞋暴击"] = function()
    registerCritRateModifier(_____7CBE_5149_4E2D_978B_66B4_51FB_7387_4FEE_6B63)
end
____exports["init精光中鞋暴击"]()
return ____exports
