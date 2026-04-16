--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E = require("lib.扩展函数.封装函数.06．伤害函数.02．伤害事件数据")
local YDWEIsEventDamageType = ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E.YDWEIsEventDamageType
local YDWEIsEventAttackDamage = ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E.YDWEIsEventAttackDamage
local YDWEIsEventRangedDamage = ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E.YDWEIsEventRangedDamage
local YDWEIsEventPhysicalDamage = ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E.YDWEIsEventPhysicalDamage
local YDWEIsEventAttackType = ____02_FF0E_4F24_5BB3_4E8B_4EF6_6570_636E.YDWEIsEventAttackType
--- 伤害函数 - 伤害类型判断
local jass = require("jass.common")
function ____exports.isMagicDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_ACID) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE)
end
function ____exports.isEnhancedDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_ENHANCED)
end
function ____exports.isTrueDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_MIND)
end
function ____exports.isNormalAttack()
    local isAttackOrRanged = YDWEIsEventAttackDamage() or YDWEIsEventRangedDamage()
    local isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and not isSkillDamage
end
function ____exports.isSkillAttack()
    local isAttackOrRanged = YDWEIsEventAttackDamage() or YDWEIsEventRangedDamage()
    local isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and isSkillDamage
end
function ____exports.isSkillDamage()
    local isAttackOrRanged = YDWEIsEventAttackDamage() or YDWEIsEventRangedDamage()
    local isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL)
    return not isAttackOrRanged and isSkillDamage
end
function ____exports.isPhysicalDamage()
    return YDWEIsEventPhysicalDamage() or YDWEIsEventDamageType(jass.DAMAGE_TYPE_NORMAL)
end
function ____exports.isMetalDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_ACID) or YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE)
end
function ____exports.isWoodDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT)
end
function ____exports.isWaterDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD)
end
function ____exports.isFireDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE)
end
function ____exports.isThunderDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING)
end
function ____exports.isLightDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE)
end
function ____exports.isDarkDamage()
    return YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE)
end
return ____exports
