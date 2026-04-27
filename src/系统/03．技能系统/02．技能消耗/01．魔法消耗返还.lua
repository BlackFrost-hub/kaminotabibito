--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 魔法消耗返还模块
-- 
-- 功能：暗夜精灵族技能施放后返还部分魔法
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDWEGetUnitAbilityDataInteger = ____require_result_0.YDWEGetUnitAbilityDataInteger
local YDWEGetUnitAbilityDataReal = ____require_result_0.YDWEGetUnitAbilityDataReal
local getObjectProperty = ____require_result_0.getObjectProperty
local ObjectType = ____require_result_0.ObjectType
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.00．消耗常量")
local PERCENT_COST_THRESHOLD = ____require_result_1.PERCENT_COST_THRESHOLD
--- 检查技能是否为暗夜精灵族
function ____exports.isNightElfAbility(self, abilityId)
    local race = getObjectProperty(nil, ObjectType.ABILITY, abilityId, "race")
    return race == "nightelf"
end
--- 获取技能固定消耗
function ____exports.getAbilityManaCost(self, unit, abilityId, level)
    return YDWEGetUnitAbilityDataInteger(
        nil,
        unit,
        abilityId,
        level,
        104
    )
end
--- 获取技能百分比消耗
function ____exports.getAbilityPercentCost(self, unit, abilityId, level)
    return YDWEGetUnitAbilityDataReal(
        nil,
        unit,
        abilityId,
        level,
        102
    )
end
--- 计算技能总消耗
function ____exports.calcTotalManaCost(self, unit, abilityId, level)
    local fixedCost = ____exports.getAbilityManaCost(nil, unit, abilityId, level)
    local percentCost = ____exports.getAbilityPercentCost(nil, unit, abilityId, level)
    if percentCost >= PERCENT_COST_THRESHOLD then
        return -1
    end
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    return fixedCost + maxMana * percentCost
end
--- 获取魔法消耗减少属性
function ____exports.getManaCostReduction(self, unit)
    local player = jass.GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        "魔法消耗减少",
        "real"
    )
end
--- 执行魔法返还
function ____exports.applyManaRefund(self, unit, manaCost)
    local reduction = ____exports.getManaCostReduction(nil, unit)
    if reduction < 0.01 then
        return
    end
    local refund = manaCost * reduction
    local currentMana = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    local manaGap = maxMana - currentMana
    local actualRefund = refund < manaGap and refund or manaGap
    if actualRefund <= 0 then
        return
    end
    jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRefund)
end
--- 处理暗夜精灵族技能消耗返还
-- 
-- @param unit 施法单位
-- @param abilityId 技能ID
-- @returns 是否执行了返还
function ____exports.handleManaRefund(self, unit, abilityId)
    if not ____exports.isNightElfAbility(nil, abilityId) then
        return false
    end
    local level = jass.GetUnitAbilityLevel(unit, abilityId)
    local manaCost = ____exports.calcTotalManaCost(nil, unit, abilityId, level)
    if manaCost < 0 then
        return false
    end
    ____exports.applyManaRefund(nil, unit, manaCost)
    return true
end
return ____exports
