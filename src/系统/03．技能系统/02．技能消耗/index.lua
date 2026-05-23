--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.02．技能消耗.00．消耗常量")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．技能消耗.03．QWERD魔法消耗显示")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local jass = require("jass.common")
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017Raw = ____require_result_1["计算最终魔法消耗"]
local ____require_result_2 = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗")
local isEdwardUnitRaw = ____require_result_2.isEdwardUnit
local handleEdwardPassiveCostRaw = ____require_result_2.handleEdwardPassiveCost
local ____require_result_3 = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步")
local _____521D_59CB_5316_539F_751F_9B54_6CD5_6D88_8017_540C_6B65 = ____require_result_3["初始化原生魔法消耗同步"]
local ____require_result_4 = require("系统.03．技能系统.02．技能消耗.03．QWERD魔法消耗显示")
local _____521D_59CB_5316QWERD_9B54_6CD5_6D88_8017_663E_793A = ____require_result_4["初始化QWERD魔法消耗显示"]
local function _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(unit, abilityId, level)
    return _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017Raw(unit, abilityId, level)
end
local function isEdwardUnit(unit)
    return isEdwardUnitRaw(unit)
end
local function handleEdwardPassiveCost(unit, manaCost)
    handleEdwardPassiveCostRaw(unit, manaCost)
end
local function onSpellEffectForCost(castingUnit, spellAbilityId)
    if isEdwardUnit(castingUnit) then
        local level = GetUnitAbilityLevel(castingUnit, spellAbilityId)
        local manaCost = _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(castingUnit, spellAbilityId, level)
        if manaCost > 0 then
            handleEdwardPassiveCost(castingUnit, manaCost)
        end
    end
end
registerSpellEffectListener(onSpellEffectForCost)
_____521D_59CB_5316_539F_751F_9B54_6CD5_6D88_8017_540C_6B65()
_____521D_59CB_5316QWERD_9B54_6CD5_6D88_8017_663E_793A()
return ____exports
