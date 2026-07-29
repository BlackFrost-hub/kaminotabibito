local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
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
local KillUnit = jass.KillUnit
local RemoveUnit = jass.RemoveUnit
local Player = jass.Player
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local SetUnitStateJapi = japi.SetUnitState
____exports["Boss测试默认最大生命值"] = 999999
____exports["Boss测试固定步兵最大生命值"] = 99999999
____exports["Boss测试中立敌对玩家ID"] = 12
local ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
local ____Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B_5355_4F4DID = stringToFourCCSafe("Hmkg")
local _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175 = nil
local _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = nil
local ____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868 = {}
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
    _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175 = result
    return result
end
____exports["准备Boss测试固定山丘之王"] = function(unit, x, y, facing)
    if facing == nil then
        facing = 90
    end
    local result = unit
    local owner = Player(____exports["Boss测试中立敌对玩家ID"])
    if not ____exports["Boss测试单位存活"](result) or GetUnitTypeId(result) ~= ____Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B_5355_4F4DID or GetPlayerId(GetOwningPlayer(result)) ~= ____exports["Boss测试中立敌对玩家ID"] then
        if result ~= nil and result ~= 0 then
            _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(result)
            RemoveUnit(result)
        end
        result = CreateUnit(
            owner,
            ____Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B_5355_4F4DID,
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
    _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = result
    return result
end
____exports["创建Boss测试临时步兵"] = function(x, y, facing)
    if facing == nil then
        facing = 90
    end
    local unit = CreateUnit(
        Player(____exports["Boss测试中立敌对玩家ID"]),
        ____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID,
        x,
        y,
        facing
    )
    if not ____exports["Boss测试单位存活"](unit) then
        return nil
    end
    ____exports["设置Boss测试单位满血"](unit, ____exports["Boss测试固定步兵最大生命值"])
    _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
    ____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868[#____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868 + 1] = unit
    return unit
end
____exports["击杀最近Boss测试临时步兵"] = function()
    do
        local i = #____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868 - 1
        while i >= 0 do
            do
                local unit = ____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868[i + 1]
                if not ____exports["Boss测试单位存活"](unit) then
                    goto __continue19
                end
                _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
                KillUnit(unit)
                return unit
            end
            ::__continue19::
            i = i - 1
        end
    end
    return nil
end
____exports["清理Boss测试临时步兵"] = function()
    do
        local i = #____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868 - 1
        while i >= 0 do
            do
                local unit = ____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868[i + 1]
                __TS__ArraySplice(____Boss_6D4B_8BD5_4E34_65F6_6B65_5175_5217_8868, i, 1)
                if unit == nil or unit == 0 then
                    goto __continue23
                end
                _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
                RemoveUnit(unit)
            end
            ::__continue23::
            i = i - 1
        end
    end
end
local function _____67E5_627E_573A_4E0ABoss_6D4B_8BD5_56FA_5B9A_5355_4F4D(unitTypeId)
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(
        group,
        Player(____exports["Boss测试中立敌对玩家ID"]),
        nil
    )
    local result = nil
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if ____exports["Boss测试单位存活"](unit) and GetUnitTypeId(unit) == unitTypeId then
            result = unit
            break
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
____exports["获取Boss测试伤害来源单位"] = function()
    if ____exports["Boss测试单位存活"](_____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175) then
        return _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175
    end
    if ____exports["Boss测试单位存活"](_____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B) then
        return _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B
    end
    local infantry = _____67E5_627E_573A_4E0ABoss_6D4B_8BD5_56FA_5B9A_5355_4F4D(____Boss_6D4B_8BD5_56FA_5B9A_6B65_5175_5355_4F4DID)
    if ____exports["Boss测试单位存活"](infantry) then
        _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175 = infantry
        return infantry
    end
    local mountainKing = _____67E5_627E_573A_4E0ABoss_6D4B_8BD5_56FA_5B9A_5355_4F4D(____Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B_5355_4F4DID)
    if ____exports["Boss测试单位存活"](mountainKing) then
        _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = mountainKing
        return mountainKing
    end
    return nil
end
____exports["移除Boss测试单位"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    if unit == _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175 then
        _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_6B65_5175 = nil
    end
    if unit == _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B then
        _____5F53_524DBoss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = nil
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
