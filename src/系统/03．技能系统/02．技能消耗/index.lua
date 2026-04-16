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
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local handleManaRefund = ____require_result_1.handleManaRefund
local calcTotalManaCost = ____require_result_1.calcTotalManaCost
local ____require_result_2 = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗")
local isEdwardUnit = ____require_result_2.isEdwardUnit
local handleEdwardPassiveCost = ____require_result_2.handleEdwardPassiveCost
local function onSpellEffectForCost(self, castingUnit, spellAbilityId)
    handleManaRefund(nil, castingUnit, spellAbilityId)
    if isEdwardUnit(nil, castingUnit) then
        local level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId)
        local manaCost = calcTotalManaCost(nil, castingUnit, spellAbilityId, level)
        if manaCost > 0 then
            handleEdwardPassiveCost(nil, castingUnit, manaCost)
        end
    end
end
registerSpellEffectListener(nil, onSpellEffectForCost)
return ____exports
