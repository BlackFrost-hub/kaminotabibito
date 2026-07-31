local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 伤害类型转换层。
-- 
-- 默认转换只改本次伤害事件的计算快照；需要改变原生伤害类型时，转换器
-- 返回 reapplyDamage，由主流程先将原事件归零，再按原始伤害值重提交一次。
-- rawAttackType/rawDamageType/rawWeaponType 始终保留，供原始伤害语义和攻击效果使用。
local jass = require("jass.common")
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_DISEASE = jass.DAMAGE_TYPE_DISEASE
local DAMAGE_TYPE_SLOW_POISON = jass.DAMAGE_TYPE_SLOW_POISON
local DAMAGE_TYPE_ACID = jass.DAMAGE_TYPE_ACID
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local DAMAGE_TYPE_SONIC = jass.DAMAGE_TYPE_SONIC
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local conversions = {}
local nextConversionId = 1
local function sortConversions()
    __TS__ArraySort(
        conversions,
        function(self, a, b)
            if a.priority ~= b.priority then
                return b.priority - a.priority
            end
            return a.id - b.id
        end
    )
end
local function _____6E05_7A7A_5C5E_6027_4F24_5BB3_6807_8BB0(context)
    context.isMetalDamage = false
    context.isWoodDamage = false
    context.isWaterDamage = false
    context.isFireDamage = false
    context.isThunderDamage = false
    context.isLightDamage = false
    context.isDarkDamage = false
end
local function _____6839_636E_4F24_5BB3_7C7B_578B_91CD_7B97_6807_8BB0(context)
    local damageType = context.effectiveDamageType
    if damageType == nil or damageType == 0 then
        return
    end
    context.isPhysicalDamage = false
    context.isMagicDamage = false
    context.isEnhancedDamage = false
    context.isTrueDamage = false
    _____6E05_7A7A_5C5E_6027_4F24_5BB3_6807_8BB0(context)
    if damageType == DAMAGE_TYPE_NORMAL then
        context.isPhysicalDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_ENHANCED then
        context.isEnhancedDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_MIND then
        context.isTrueDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_SLOW_POISON or damageType == DAMAGE_TYPE_POISON or damageType == DAMAGE_TYPE_ACID or damageType == DAMAGE_TYPE_DISEASE then
        context.isMagicDamage = true
        context.isMetalDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_PLANT then
        context.isMagicDamage = true
        context.isWoodDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_COLD then
        context.isMagicDamage = true
        context.isWaterDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_FIRE then
        context.isMagicDamage = true
        context.isFireDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_LIGHTNING then
        context.isMagicDamage = true
        context.isThunderDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_DIVINE then
        context.isMagicDamage = true
        context.isLightDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_SHADOW_STRIKE then
        context.isMagicDamage = true
        context.isDarkDamage = true
        return
    end
    if damageType == DAMAGE_TYPE_MAGIC or damageType == DAMAGE_TYPE_SONIC then
        context.isMagicDamage = true
    end
    if damageType == DAMAGE_TYPE_UNIVERSAL then
        context.isPhysicalDamage = false
        context.isMagicDamage = false
    end
end
local function _____5E94_7528_8F6C_6362_7ED3_679C(context, result)
    local ____temp_0
    if result.effectiveDamageType ~= nil then
        ____temp_0 = result.effectiveDamageType
    else
        ____temp_0 = result.damageType
    end
    local damageType = ____temp_0
    local hasDamageType = damageType ~= nil
    if result.effectiveAttackType ~= nil then
        context.effectiveAttackType = result.effectiveAttackType
    elseif result.attackType ~= nil then
        context.effectiveAttackType = result.attackType
    end
    if result.effectiveWeaponType ~= nil then
        context.effectiveWeaponType = result.effectiveWeaponType
    elseif result.weaponType ~= nil then
        context.effectiveWeaponType = result.weaponType
    end
    if hasDamageType then
        context.effectiveDamageType = damageType
        _____6839_636E_4F24_5BB3_7C7B_578B_91CD_7B97_6807_8BB0(context)
    end
    if result.isPhysicalDamage ~= nil then
        context.isPhysicalDamage = result.isPhysicalDamage
    end
    if result.isMagicDamage ~= nil then
        context.isMagicDamage = result.isMagicDamage
    end
    if result.isEnhancedDamage ~= nil then
        context.isEnhancedDamage = result.isEnhancedDamage
    end
    if result.isTrueDamage ~= nil then
        context.isTrueDamage = result.isTrueDamage
    end
    if result.isNormalAttack ~= nil then
        context.isNormalAttack = result.isNormalAttack
    end
    if result.isRangedAttack ~= nil then
        context.isRangedAttack = result.isRangedAttack
    end
    if result.isSkillAttack ~= nil then
        context.isSkillAttack = result.isSkillAttack
    end
    if result.isSkillDamage ~= nil then
        context.isSkillDamage = result.isSkillDamage
    end
    if result.isWrappedSkillDamage ~= nil then
        context.isWrappedSkillDamage = result.isWrappedSkillDamage
    end
    if result.isEquipmentSkillDamage ~= nil then
        context.isEquipmentSkillDamage = result.isEquipmentSkillDamage
    end
    if result.isNonEquipmentSkillDamage ~= nil then
        context.isNonEquipmentSkillDamage = result.isNonEquipmentSkillDamage
    end
    if result.isIndependentSkillDamage ~= nil then
        context.isIndependentSkillDamage = result.isIndependentSkillDamage
    end
    if result.isSingleTargetSkillDamage ~= nil then
        context.isSingleTargetSkillDamage = result.isSingleTargetSkillDamage
    end
    if result.isAoeSkillDamage ~= nil then
        context.isAoeSkillDamage = result.isAoeSkillDamage
    end
    if result.isDamageTransfer ~= nil then
        context.isDamageTransfer = result.isDamageTransfer
    end
    if result.isMetalDamage ~= nil then
        context.isMetalDamage = result.isMetalDamage
    end
    if result.isWoodDamage ~= nil then
        context.isWoodDamage = result.isWoodDamage
    end
    if result.isWaterDamage ~= nil then
        context.isWaterDamage = result.isWaterDamage
    end
    if result.isFireDamage ~= nil then
        context.isFireDamage = result.isFireDamage
    end
    if result.isThunderDamage ~= nil then
        context.isThunderDamage = result.isThunderDamage
    end
    if result.isLightDamage ~= nil then
        context.isLightDamage = result.isLightDamage
    end
    if result.isDarkDamage ~= nil then
        context.isDarkDamage = result.isDarkDamage
    end
    if result.reapplyDamage ~= nil then
        context.reapplyDamage = result.reapplyDamage
    end
end
function ____exports.registerDamageTypeConversion(callback, priority)
    if priority == nil then
        priority = 0
    end
    if callback == nil then
        return 0
    end
    local id = nextConversionId
    nextConversionId = nextConversionId + 1
    conversions[#conversions + 1] = {id = id, priority = priority, callback = callback}
    sortConversions()
    return id
end
function ____exports.unregisterDamageTypeConversion(id)
    do
        local i = 0
        while i < #conversions do
            do
                if conversions[i + 1].id ~= id then
                    goto __continue53
                end
                __TS__ArraySplice(conversions, i, 1)
                return true
            end
            ::__continue53::
            i = i + 1
        end
    end
    return false
end
function ____exports.applyDamageTypeConversions(context)
    do
        local i = 0
        while i < #conversions do
            do
                local entry = conversions[i + 1]
                if entry == nil or entry.callback == nil then
                    goto __continue57
                end
                local result = entry.callback(context)
                if result ~= nil then
                    _____5E94_7528_8F6C_6362_7ED3_679C(context, result)
                end
            end
            ::__continue57::
            i = i + 1
        end
    end
    return context
end
function ____exports.getDamageTypeConversionCount()
    return #conversions
end
return ____exports
