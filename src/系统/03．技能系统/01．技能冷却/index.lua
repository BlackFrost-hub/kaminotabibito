local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
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
do
    local ____export = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local _____68C0_67E5_51B7_5374_9ED1_540D_5355 = ____require_result_1.isBlacklistedSkill
local _____68C0_67E5_6392_9664_5355_4F4D = ____require_result_1.isExcludedUnit
local _____8BFB_53D6_51B7_5374_7F29_51CF = ____require_result_1.getCooldownReduction
local _____8BFB_53D6_51B7_5374_7F29_51CF_52A0_6210 = ____require_result_1.getCooldownReductionBonus
local _____5E94_7528_51B7_5374_4E0A_9650 = ____require_result_1.applyCooldownCap
local _____8BA1_7B97_5B9E_9645_51B7_5374 = ____require_result_1.calcActualCooldown
local _____8BBE_7F6E_6280_80FD_51B7_5374 = ____require_result_1.setAbilityCooldown
local _____8BFB_53D6_57FA_7840_51B7_5374 = ____require_result_1.getBaseCooldown
local ____require_result_2 = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理")
local _____5904_7406_7279_6B8A_6280_80FD_51B7_5374 = ____require_result_2.handleSpecialSkillCooldown
local ____require_result_3 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local INDEPENDENT_COOLDOWN_SKILLS = ____require_result_3.INDEPENDENT_COOLDOWN_SKILLS
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_4.stringToFourCC
local ____require_result_5 = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示")
local _____521D_59CB_5316QWERD_51B7_5374_663E_793A = ____require_result_5["初始化QWERD冷却显示"]
local function isBlacklistedSkill(abilityId)
    return _____68C0_67E5_51B7_5374_9ED1_540D_5355(abilityId)
end
local function isExcludedUnit(unit)
    return _____68C0_67E5_6392_9664_5355_4F4D(unit)
end
local function getCooldownReduction(unit)
    return _____8BFB_53D6_51B7_5374_7F29_51CF(unit)
end
local function getCooldownReductionBonus(unit)
    return _____8BFB_53D6_51B7_5374_7F29_51CF_52A0_6210(unit)
end
local function applyCooldownCap(reduction, abilityId, bonus)
    return _____5E94_7528_51B7_5374_4E0A_9650(reduction, abilityId, bonus)
end
local function calcActualCooldown(baseCooldown, reduction)
    return _____8BA1_7B97_5B9E_9645_51B7_5374(baseCooldown, reduction)
end
local function setAbilityCooldown(unit, abilityId, level, cooldown)
    _____8BBE_7F6E_6280_80FD_51B7_5374(unit, abilityId, level, cooldown)
end
local function getBaseCooldown(abilityId, level)
    return _____8BFB_53D6_57FA_7840_51B7_5374(abilityId, level)
end
local function handleSpecialSkillCooldown(unit, abilityId, reduction)
    return _____5904_7406_7279_6B8A_6280_80FD_51B7_5374(unit, abilityId, reduction)
end
local function _____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)
    if not _____914D_7F6E_952E_540D then
        return ""
    end
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or ""
end
local function onSpellEffectForCooldown(castingUnit, spellAbilityId)
    if isBlacklistedSkill(spellAbilityId) then
        return
    end
    if isExcludedUnit(castingUnit) then
        return
    end
    for ____, _____914D_7F6E_952E_540D in ipairs(INDEPENDENT_COOLDOWN_SKILLS) do
        if stringToFourCC(_____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)) == spellAbilityId then
            return
        end
    end
    local level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId)
    if level <= 0 then
        return
    end
    local baseCooldown = getBaseCooldown(spellAbilityId, level)
    if baseCooldown <= 0 then
        return
    end
    local reduction = getCooldownReduction(castingUnit)
    if reduction < 0.01 then
        return
    end
    local bonus = getCooldownReductionBonus(castingUnit)
    local cappedReduction = applyCooldownCap(reduction, spellAbilityId, bonus)
    local actualCooldown = calcActualCooldown(baseCooldown, cappedReduction)
    if handleSpecialSkillCooldown(castingUnit, spellAbilityId, cappedReduction) then
        return
    end
    setAbilityCooldown(castingUnit, spellAbilityId, level, actualCooldown)
end
registerSpellEffectListener(onSpellEffectForCooldown)
_____521D_59CB_5316QWERD_51B7_5374_663E_793A()
return ____exports
