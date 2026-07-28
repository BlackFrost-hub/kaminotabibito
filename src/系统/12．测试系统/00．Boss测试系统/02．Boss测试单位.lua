--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_2.X_FixUnitStandingSafe
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_3["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_3["注销Boss技能测试目标"]
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitType = jass.IsUnitType
local SetUnitState = jass.SetUnitState
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local CreateUnit = jass.CreateUnit
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local RemoveUnit = jass.RemoveUnit
local Player = jass.Player
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local SetUnitStateJapi = japi.SetUnitState
____exports["Boss测试默认最大生命值"] = 999999
____exports["Boss测试固定步兵最大生命值"] = 99999
____exports["Boss测试中立敌对玩家ID"] = 12
local ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
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
____exports["准备Boss测试固定步兵"] = function(unit, x, y, facing)
    if facing == nil then
        facing = 90
    end
    local result = unit
    local owner = Player(____exports["Boss测试中立敌对玩家ID"])
    if not ____exports["Boss测试单位存活"](result) or GetUnitTypeId(result) ~= ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID or GetPlayerId(GetOwningPlayer(result)) ~= ____exports["Boss测试中立敌对玩家ID"] then
        if result ~= nil and result ~= 0 then
            _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(result)
            RemoveUnit(result)
        end
        result = CreateUnit(
            owner,
            ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID,
            x,
            y,
            facing
        )
    end
    if not ____exports["Boss测试单位存活"](result) then
        return nil
    end
    SetUnitPosition(result, x, y)
    SetUnitFacing(result, facing)
    ____exports["设置Boss测试单位满血"](result, ____exports["Boss测试固定步兵最大生命值"])
    X_FixUnitStandingSafe(result)
    _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(result)
    return result
end
____exports["移除Boss测试单位"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
    RemoveUnit(unit)
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
