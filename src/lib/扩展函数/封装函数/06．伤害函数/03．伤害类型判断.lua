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
function ____exports.isMagicDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_FIRE) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_COLD) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_LIGHTNING) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_POISON) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_DISEASE) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_SLOW_POISON) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_ACID) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_DIVINE) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_MAGIC) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_PLANT) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_SHADOW_STRIKE)
end
function ____exports.isEnhancedDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_ENHANCED)
end
function ____exports.isTrueDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_MIND)
end
function ____exports.isNormalAttack(self)
    local isAttackOrRanged = YDWEIsEventAttackDamage(nil) or YDWEIsEventRangedDamage(nil)
    local isSkillDamage = YDWEIsEventAttackType(nil, jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and not isSkillDamage
end
function ____exports.isSkillAttack(self)
    local isAttackOrRanged = YDWEIsEventAttackDamage(nil) or YDWEIsEventRangedDamage(nil)
    local isSkillDamage = YDWEIsEventAttackType(nil, jass.ATTACK_TYPE_NORMAL)
    return isAttackOrRanged and isSkillDamage
end
function ____exports.isSkillDamage(self)
    local isAttackOrRanged = YDWEIsEventAttackDamage(nil) or YDWEIsEventRangedDamage(nil)
    local isSkillDamage = YDWEIsEventAttackType(nil, jass.ATTACK_TYPE_NORMAL)
    return not isAttackOrRanged and isSkillDamage
end
function ____exports.isPhysicalDamage(self)
    return YDWEIsEventPhysicalDamage(nil) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_NORMAL)
end
function ____exports.isMetalDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_SLOW_POISON) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_POISON) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_ACID) or YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_DISEASE)
end
function ____exports.isWoodDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_PLANT)
end
function ____exports.isWaterDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_COLD)
end
function ____exports.isFireDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_FIRE)
end
function ____exports.isThunderDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_LIGHTNING)
end
function ____exports.isLightDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_DIVINE)
end
function ____exports.isDarkDamage(self)
    return YDWEIsEventDamageType(nil, jass.DAMAGE_TYPE_SHADOW_STRIKE)
end
return ____exports
