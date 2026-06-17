--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
____exports["获取同类伤害类型"] = function(snapshot)
    if snapshot == nil then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = DAMAGE_TYPE_NORMAL, ["武器类型"] = nil}
    end
    if snapshot.rawDamageType ~= nil then
        local ____snapshot_rawAttackType_0 = snapshot.rawAttackType
        if ____snapshot_rawAttackType_0 == nil then
            ____snapshot_rawAttackType_0 = ATTACK_TYPE_NORMAL
        end
        local ____snapshot_rawDamageType_2 = snapshot.rawDamageType
        local ____snapshot_rawWeaponType_1 = snapshot.rawWeaponType
        if ____snapshot_rawWeaponType_1 == nil then
            ____snapshot_rawWeaponType_1 = nil
        end
        return {["攻击类型"] = ____snapshot_rawAttackType_0, ["伤害类型"] = ____snapshot_rawDamageType_2, ["武器类型"] = ____snapshot_rawWeaponType_1}
    end
    if snapshot.isTrueDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_MIND, ["武器类型"] = nil}
    end
    if snapshot.isEnhancedDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_ENHANCED, ["武器类型"] = nil}
    end
    if snapshot.isPhysicalDamage == true or snapshot.isNormalAttack == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = DAMAGE_TYPE_NORMAL, ["武器类型"] = nil}
    end
    if snapshot.isFireDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_FIRE, ["武器类型"] = nil}
    end
    if snapshot.isThunderDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_LIGHTNING, ["武器类型"] = nil}
    end
    if snapshot.isLightDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE, ["武器类型"] = nil}
    end
    if snapshot.isDarkDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_SHADOW_STRIKE, ["武器类型"] = nil}
    end
    if snapshot.isWoodDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_PLANT, ["武器类型"] = nil}
    end
    if snapshot.isWaterDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_COLD, ["武器类型"] = nil}
    end
    if snapshot.isMetalDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_POISON, ["武器类型"] = nil}
    end
    if snapshot.isSkillAttack == true or snapshot.isSkillDamage == true or snapshot.isMagicDamage == true then
        return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC, ["武器类型"] = nil}
    end
    return {["攻击类型"] = ATTACK_TYPE_NORMAL, ["伤害类型"] = DAMAGE_TYPE_NORMAL, ["武器类型"] = nil}
end
return ____exports
