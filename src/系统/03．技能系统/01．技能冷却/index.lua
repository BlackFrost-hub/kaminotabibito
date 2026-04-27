--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local isBlacklistedSkill = ____require_result_1.isBlacklistedSkill
local isExcludedUnit = ____require_result_1.isExcludedUnit
local getCooldownReduction = ____require_result_1.getCooldownReduction
local getCooldownReductionBonus = ____require_result_1.getCooldownReductionBonus
local applyCooldownCap = ____require_result_1.applyCooldownCap
local calcActualCooldown = ____require_result_1.calcActualCooldown
local setAbilityCooldown = ____require_result_1.setAbilityCooldown
local getBaseCooldown = ____require_result_1.getBaseCooldown
local ____require_result_2 = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理")
local handleSpecialSkillCooldown = ____require_result_2.handleSpecialSkillCooldown
local ____require_result_3 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local INDEPENDENT_COOLDOWN_SKILLS = ____require_result_3.INDEPENDENT_COOLDOWN_SKILLS
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_4.stringToFourCC
local function onSpellEffectForCooldown(self, castingUnit, spellAbilityId)
    if isBlacklistedSkill(nil, spellAbilityId) then
        return
    end
    if isExcludedUnit(nil, castingUnit) then
        return
    end
    for ____, idStr in ipairs(INDEPENDENT_COOLDOWN_SKILLS) do
        if stringToFourCC(nil, idStr) == spellAbilityId then
            return
        end
    end
    local reduction = getCooldownReduction(nil, castingUnit)
    if reduction < 0.001 then
        return
    end
    local bonus = getCooldownReductionBonus(nil, castingUnit)
    local cappedReduction = applyCooldownCap(nil, reduction, spellAbilityId, bonus)
    if handleSpecialSkillCooldown(nil, castingUnit, spellAbilityId, cappedReduction) then
        return
    end
    local level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId)
    if level <= 0 then
        return
    end
    local baseCooldown = getBaseCooldown(nil, spellAbilityId, level)
    if baseCooldown <= 0 then
        return
    end
    local actualCooldown = calcActualCooldown(nil, baseCooldown, cappedReduction)
    setAbilityCooldown(
        nil,
        castingUnit,
        spellAbilityId,
        level,
        actualCooldown
    )
end
registerSpellEffectListener(nil, onSpellEffectForCooldown)
return ____exports
