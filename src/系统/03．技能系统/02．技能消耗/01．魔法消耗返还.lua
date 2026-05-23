--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 魔法消耗计算模块
-- 
-- 功能：读取物编原始消耗，并计算写入单个单位技能实例的最终魔法消耗
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDWEGetUnitAbilityDataInteger = ____require_result_0.YDWEGetUnitAbilityDataInteger
local YDWEGetUnitAbilityDataReal = ____require_result_0.YDWEGetUnitAbilityDataReal
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.00．消耗常量")
local PERCENT_COST_THRESHOLD = ____require_result_1.PERCENT_COST_THRESHOLD
--- 获取技能固定消耗
function ____exports.getAbilityManaCost(unit, abilityId, level)
    return YDWEGetUnitAbilityDataInteger(
        nil,
        unit,
        abilityId,
        level,
        104
    )
end
--- 获取技能百分比消耗
function ____exports.getAbilityPercentCost(unit, abilityId, level)
    return YDWEGetUnitAbilityDataReal(
        nil,
        unit,
        abilityId,
        level,
        102
    )
end
--- 计算技能总消耗
function ____exports.calcTotalManaCost(unit, abilityId, level)
    local fixedCost = ____exports.getAbilityManaCost(unit, abilityId, level)
    local percentCost = ____exports.getAbilityPercentCost(unit, abilityId, level)
    if percentCost >= PERCENT_COST_THRESHOLD then
        return -1
    end
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    return fixedCost + maxMana * percentCost
end
--- 获取魔法消耗属性
function ____exports.getManaCostReduction(unit)
    local player = jass.GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        "魔法消耗",
        "real"
    )
end
--- 计算写入原生技能实例的最终魔法消耗。
-- 固定蓝耗读取物编原值；百分比蓝耗按当前最大魔法计算；最后套用技能消耗减少。
____exports["计算最终魔法消耗"] = function(unit, abilityId, level)
    local totalCost = ____exports.calcTotalManaCost(unit, abilityId, level)
    local baseCost = totalCost > 0 and totalCost or ____exports.getAbilityManaCost(unit, abilityId, level)
    if not (baseCost > 0) then
        return -1
    end
    local reduction = ____exports.getManaCostReduction(unit)
    local reductionRatio = reduction < 0 and -reduction or reduction
    if reductionRatio >= 1 then
        return 0
    end
    local finalCost = baseCost * (1 - reductionRatio)
    return finalCost > 0 and finalCost or 0
end
return ____exports
