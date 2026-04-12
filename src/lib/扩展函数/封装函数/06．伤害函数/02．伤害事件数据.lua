--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF = require("lib.扩展函数.封装函数.06．伤害函数.01．伤害事件常量")
local EVENT_DAMAGE_DATA_IS_PHYSICAL = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_IS_PHYSICAL
local EVENT_DAMAGE_DATA_IS_ATTACK = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_IS_ATTACK
local EVENT_DAMAGE_DATA_IS_RANGED = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_IS_RANGED
local EVENT_DAMAGE_DATA_DAMAGE_TYPE = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_DAMAGE_TYPE
local EVENT_DAMAGE_DATA_WEAPON_TYPE = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_WEAPON_TYPE
local EVENT_DAMAGE_DATA_ATTACK_TYPE = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5E38_91CF.EVENT_DAMAGE_DATA_ATTACK_TYPE
--- 伤害函数 - 伤害事件数据获取与设置
local japi = require("jass.japi")
function ____exports.EXGetEventDamageData(self, edd_type)
    return japi.EXGetEventDamageData(edd_type)
end
function ____exports.EXSetEventDamage(self, amount)
    return japi.EXSetEventDamage(amount)
end
function ____exports.YDWEIsEventPhysicalDamage(self)
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end
function ____exports.YDWEIsEventAttackDamage(self)
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end
function ____exports.YDWEIsEventRangedDamage(self)
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end
local jass = require("jass.common")
function ____exports.YDWEIsEventDamageType(self, damageType)
    return damageType == jass.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end
function ____exports.YDWEIsEventWeaponType(self, weaponType)
    return weaponType == jass.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end
function ____exports.YDWEIsEventAttackType(self, attackType)
    return attackType == jass.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end
function ____exports.YDWESetEventDamage(self, amount)
    return japi.EXSetEventDamage(amount)
end
return ____exports
