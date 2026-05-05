local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
local DYNAMIC_SKILL_TIP_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.DYNAMIC_SKILL_TIP_ENABLED
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
local registerDynamicSkillTip = ____01_FF0E_6838_5FC3_529F_80FD.registerDynamicSkillTip
local refreshAllSkillTips = ____01_FF0E_6838_5FC3_529F_80FD.refreshAllSkillTips
local ABILITY_DATA_UBERTIP = ____01_FF0E_6838_5FC3_529F_80FD.ABILITY_DATA_UBERTIP
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local EXGetUnitAbilityByIndex = ____require_result_0.EXGetUnitAbilityByIndex
local EXGetAbilityId = ____require_result_0.EXGetAbilityId
local getObjectProperty = ____require_result_0.getObjectProperty
local ObjectType = ____require_result_0.ObjectType
local ITEM_SKILL_MIN = 852008
local ITEM_SKILL_MAX = 852013
local registeredSkills = __TS__New(Set)
local periodicCallbackId = nil
local function isItemSkillByOrder(self, unit)
    if not unit then
        return false
    end
    local currentOrder = jass.GetUnitCurrentOrder(unit)
    if not currentOrder then
        return false
    end
    return currentOrder >= ITEM_SKILL_MIN and currentOrder <= ITEM_SKILL_MAX
end
local function getSkillKey(self, unit, abilityId)
    return (tostring(jass.GetHandleId(unit)) .. "_") .. tostring(abilityId)
end
local function getSkillTemplate(self, unit, abilityId, level)
    if not unit or not abilityId or level <= 0 then
        return nil
    end
    local researchUbertip = getObjectProperty(nil, ObjectType.ABILITY, abilityId, "Researchubertip")
    if researchUbertip == nil or researchUbertip == "" then
        return nil
    end
    return researchUbertip
end
local function registerOneSkillTemplate(self, unit, abilityId, level)
    if not unit or not abilityId or level <= 0 then
        return
    end
    local skillKey = getSkillKey(nil, unit, abilityId)
    if registeredSkills:has(skillKey) then
        return
    end
    local template = getSkillTemplate(nil, unit, abilityId, level)
    if not template then
        return
    end
    local success = registerDynamicSkillTip(
        nil,
        unit,
        abilityId,
        template,
        level,
        ABILITY_DATA_UBERTIP
    )
    if success then
        registeredSkills:add(skillKey)
    end
end
local function registerExistingHeroSkills(self, unit)
    if not unit or unit == 0 then
        return
    end
    do
        local i = 0
        while i <= 15 do
            do
                local ability = EXGetUnitAbilityByIndex(nil, unit, i)
                if not ability then
                    goto __continue17
                end
                local abilityId = EXGetAbilityId(nil, ability)
                if not abilityId then
                    goto __continue17
                end
                local level = jass.GetUnitAbilityLevel(unit, abilityId)
                if level <= 0 then
                    goto __continue17
                end
                registerOneSkillTemplate(nil, unit, abilityId, level)
            end
            ::__continue17::
            i = i + 1
        end
    end
end
local function onSpellEffect(self, castingUnit, spellAbilityId)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    if isItemSkillByOrder(nil, castingUnit) then
        return
    end
    local currentLevel = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId)
    if currentLevel <= 0 then
        return
    end
    registerOneSkillTemplate(nil, castingUnit, spellAbilityId, currentLevel)
end
local function onPeriodicRefresh(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    refreshAllSkillTips(nil)
end
function ____exports.initHeroSkillPreregistration(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    local ____require_result_1 = require("系统.03．技能系统.00．技能事件.01．核心功能")
    local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
    registerSpellEffectListener(nil, onSpellEffect)
    local ____G_2 = _G
    local addPeriodicCallback = ____G_2.addPeriodicCallback
    periodicCallbackId = addPeriodicCallback(nil, 2000, onPeriodicRefresh)
end
function ____exports.onHeroRegisteredPreregistration(whichPlayer, whichHero)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    if not whichPlayer or whichPlayer == 0 or not whichHero or whichHero == 0 then
        return
    end
    registerExistingHeroSkills(nil, whichHero)
end
return ____exports
