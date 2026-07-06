--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local GetUnitStateJapi = japi.GetUnitState
____exports["单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["是技能伤害"] = function(snapshot)
    return snapshot ~= nil and snapshot.isEquipmentSkillDamage ~= true and (snapshot.isSkillDamage == true or snapshot.isSkillAttack == true or snapshot.isWrappedSkillDamage == true)
end
____exports["是任意封装技能伤害"] = function(snapshot)
    return snapshot ~= nil and (snapshot.isSkillDamage == true or snapshot.isSkillAttack == true or snapshot.isWrappedSkillDamage == true)
end
____exports["是AOE技能伤害"] = function(snapshot)
    return snapshot ~= nil and snapshot.isAoeSkillDamage == true
end
____exports["是单体技能伤害"] = function(snapshot)
    return snapshot ~= nil and snapshot.isSingleTargetSkillDamage == true
end
____exports["是指定形态技能伤害"] = function(snapshot, _____5F62_6001)
    if _____5F62_6001 == "AOE" then
        return ____exports["是AOE技能伤害"](snapshot)
    end
    return ____exports["是单体技能伤害"](snapshot)
end
____exports["是纯普攻"] = function(snapshot)
    return snapshot ~= nil and snapshot.isNormalAttack == true and snapshot.isSkillDamage ~= true and snapshot.isSkillAttack ~= true and snapshot.isWrappedSkillDamage ~= true
end
____exports["是元素伤害"] = function(snapshot, damageType)
    return snapshot ~= nil and snapshot.rawDamageType == damageType
end
____exports["取单位ID"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["取当前生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
____exports["取最大生命"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) or GetUnitState(unit, UNIT_STATE_MAX_LIFE) or 0
end
____exports["取攻击力"] = function(unit)
    return GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    ) or 0
end
____exports["是敌对单位"] = function(source, target)
    return source ~= nil and source ~= 0 and target ~= nil and target ~= 0 and IsUnitEnemy(
        target,
        GetOwningPlayer(source)
    ) == true
end
____exports["取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["取单位Y"] = function(unit)
    return GetUnitY(unit)
end
return ____exports
