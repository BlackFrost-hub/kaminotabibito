--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritRateModifier = ____require_result_0.registerCritRateModifier
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_1.resolveItemIdByName
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_3.UnitHasItemOfTypeBJ
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____68EE_9B54_8FDE_5F29_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("森魔连弩"))
local function _____76EE_6807_751F_547D_6BD4_4F8B_9AD8_4E8E_516B_6210(target)
    local _____6700_5927_751F_547D = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    if _____6700_5927_751F_547D <= 0 then
        return false
    end
    return GetUnitState(target, UNIT_STATE_LIFE) > _____6700_5927_751F_547D * 0.8
end
local function _____68EE_9B54_8FDE_5F29_66B4_51FB_7387_4FEE_6B63(context)
    if _____68EE_9B54_8FDE_5F29_7269_54C1ID == 0 then
        return context["暴击率"]
    end
    if context.isNormalAttack ~= true or context.isRangedAttack ~= true then
        return context["暴击率"]
    end
    if not _____76EE_6807_751F_547D_6BD4_4F8B_9AD8_4E8E_516B_6210(context.target) then
        return context["暴击率"]
    end
    if not UnitHasItemOfTypeBJ(context["暴击归属单位"], _____68EE_9B54_8FDE_5F29_7269_54C1ID) then
        return context["暴击率"]
    end
    return 1
end
____exports["init森魔连弩暴击"] = function()
    registerCritRateModifier(_____68EE_9B54_8FDE_5F29_66B4_51FB_7387_4FEE_6B63)
end
____exports["init森魔连弩暴击"]()
return ____exports
