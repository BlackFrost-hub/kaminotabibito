--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
____exports.EVENT_DAMAGE_DATA_VAILD = 0
____exports.EVENT_DAMAGE_DATA_IS_PHYSICAL = 1
____exports.EVENT_DAMAGE_DATA_IS_ATTACK = 2
____exports.EVENT_DAMAGE_DATA_IS_RANGED = 3
____exports.EVENT_DAMAGE_DATA_DAMAGE_TYPE = 4
____exports.EVENT_DAMAGE_DATA_WEAPON_TYPE = 5
____exports.EVENT_DAMAGE_DATA_ATTACK_TYPE = 6
function ____exports.EXGetEventDamageData(edd_type)
    return japi.EXGetEventDamageData(edd_type)
end
function ____exports.EXSetEventDamage(amount)
    return japi.EXSetEventDamage(amount)
end
function ____exports.YDWEIsEventPhysicalDamage()
    return 0 ~= japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_IS_PHYSICAL)
end
function ____exports.YDWEIsEventAttackDamage()
    return 0 ~= japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_IS_ATTACK)
end
function ____exports.YDWEIsEventRangedDamage()
    return 0 ~= japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_IS_RANGED)
end
function ____exports.YDWEIsEventDamageType(damageType)
    return damageType == jass.ConvertDamageType(japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end
function ____exports.YDWEIsEventWeaponType(weaponType)
    return weaponType == jass.ConvertWeaponType(japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_WEAPON_TYPE))
end
function ____exports.YDWEIsEventAttackType(attackType)
    return attackType == jass.ConvertAttackType(japi.EXGetEventDamageData(____exports.EVENT_DAMAGE_DATA_ATTACK_TYPE))
end
function ____exports.YDWESetEventDamage(amount)
    return japi.EXSetEventDamage(amount)
end
function ____exports.isMagicDamage()
    return ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT) or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE)
end
function ____exports.isEnhancedDamage()
    return ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_ENHANCED)
end
function ____exports.isTrueDamage()
    return ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_MIND)
end
function ____exports.isNormalAttack()
    local isAttackOrRanged = ____exports.YDWEIsEventAttackDamage() or ____exports.YDWEIsEventRangedDamage()
    local isSkillDamage = ____exports.YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and not isSkillDamage
end
function ____exports.isSkillAttack()
    local isAttackOrRanged = ____exports.YDWEIsEventAttackDamage() or ____exports.YDWEIsEventRangedDamage()
    local isSkillDamage = ____exports.YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and isSkillDamage
end
function ____exports.isSkillDamage()
    local isAttackOrRanged = ____exports.YDWEIsEventAttackDamage() or ____exports.YDWEIsEventRangedDamage()
    local isSkillDamage = ____exports.YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return not isAttackOrRanged and isSkillDamage
end
function ____exports.isPhysicalDamage()
    return ____exports.YDWEIsEventPhysicalDamage() or ____exports.YDWEIsEventDamageType(jass.DAMAGE_TYPE_NORMAL)
end
return ____exports
