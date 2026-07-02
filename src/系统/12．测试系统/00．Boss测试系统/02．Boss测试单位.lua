--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitType = jass.IsUnitType
local SetUnitState = jass.SetUnitState
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local SetUnitStateJapi = japi.SetUnitState
____exports["Boss测试默认最大生命值"] = 999999
____exports["Boss测试单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
____exports["Boss测试单位是存活英雄"] = function(unit)
    return ____exports["Boss测试单位存活"](unit) and IsUnitType(unit, UNIT_TYPE_HERO) == true
end
____exports["Boss测试单位属于玩家"] = function(unit, player)
    return ____exports["Boss测试单位存活"](unit) and GetPlayerId(GetOwningPlayer(unit)) == GetPlayerId(player)
end
____exports["设置Boss测试单位满血"] = function(unit, _____6700_5927_751F_547D_503C)
    if unit == nil or unit == 0 then
        return
    end
    local hp = _____6700_5927_751F_547D_503C or ____exports["Boss测试默认最大生命值"]
    SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, hp)
    SetUnitState(unit, UNIT_STATE_LIFE, hp)
end
____exports["获取Boss测试玩家基准英雄"] = function(player)
    local presetArchmage = globals.gg_unit_Hamg_0002
    if ____exports["Boss测试单位是存活英雄"](presetArchmage) then
        return presetArchmage
    end
    local registeredHero = getRegisteredPlayerHero(player)
    if ____exports["Boss测试单位是存活英雄"](registeredHero) then
        return registeredHero
    end
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(group, player, nil)
    local result = nil
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if ____exports["Boss测试单位是存活英雄"](unit) then
            result = unit
            break
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
return ____exports
