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
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local _____9B54_6CD5_6D88_8017_8FD4_8FD8_6A21_5757 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____7279_6B8A_5355_4F4D_6D88_8017_6A21_5757 = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗")
local function handleManaRefund(unit, abilityId)
    return _____9B54_6CD5_6D88_8017_8FD4_8FD8_6A21_5757.handleManaRefund(_____9B54_6CD5_6D88_8017_8FD4_8FD8_6A21_5757, unit, abilityId)
end
local function calcTotalManaCost(unit, abilityId, level)
    return _____9B54_6CD5_6D88_8017_8FD4_8FD8_6A21_5757.calcTotalManaCost(_____9B54_6CD5_6D88_8017_8FD4_8FD8_6A21_5757, unit, abilityId, level)
end
local function isEdwardUnit(unit)
    return _____7279_6B8A_5355_4F4D_6D88_8017_6A21_5757.isEdwardUnit(_____7279_6B8A_5355_4F4D_6D88_8017_6A21_5757, unit)
end
local function handleEdwardPassiveCost(unit, manaCost)
    _____7279_6B8A_5355_4F4D_6D88_8017_6A21_5757.handleEdwardPassiveCost(_____7279_6B8A_5355_4F4D_6D88_8017_6A21_5757, unit, manaCost)
end
local function onSpellEffectForCost(castingUnit, spellAbilityId)
    handleManaRefund(castingUnit, spellAbilityId)
    if isEdwardUnit(castingUnit) then
        local level = jass:GetUnitAbilityLevel(castingUnit, spellAbilityId)
        local manaCost = calcTotalManaCost(castingUnit, spellAbilityId, level)
        if manaCost > 0 then
            handleEdwardPassiveCost(castingUnit, manaCost)
        end
    end
end
registerSpellEffectListener(onSpellEffectForCost)
local ____self_1 = require("系统.03．技能系统.02．技能消耗.03．QWERD魔法消耗显示")
____self_1["初始化QWERD魔法消耗显示"](____self_1)
return ____exports
