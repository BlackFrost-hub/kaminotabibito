local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_0.UnitHasItemOfTypeBJ
local GetItemOfTypeFromUnitBJ = ____require_result_0.GetItemOfTypeFromUnitBJ
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_4.doHeal
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local SFB_setBuff = ____require_result_5.SFB_setBuff
local SFB_setSlow = ____require_result_5.SFB_setSlow
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6E05_9664_5355_4F4D_8D1F_9762Buff = ____require_result_6["清除单位负面Buff"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = ____require_result_7["开始击退"]
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_8.addPeriodicCallback
local getServerTime = ____require_result_8.getServerTime
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local GetItemTypeId = jass.GetItemTypeId
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local IsUnitType = jass.IsUnitType
local IsUnitAlly = jass.IsUnitAlly
local GetHeroStr = jass.GetHeroStr
local GetHeroAgi = jass.GetHeroAgi
local GetHeroInt = jass.GetHeroInt
local AddHeroXP = jass.AddHeroXP
local ModifyHeroStat = jass.ModifyHeroStat
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local IsPointBlighted = jass.IsPointBlighted
local SetItemCharges = jass.SetItemCharges
local GetItemCharges = jass.GetItemCharges
local UnitApplyTimedLife = jass.UnitApplyTimedLife
local SetUnitScale = jass.SetUnitScale
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitFacing = jass.SetUnitFacing
local IssueTargetOrder = jass.IssueTargetOrder
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local DestroyGroup = jass.DestroyGroup
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local ConvertUnitState = jass.ConvertUnitState
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local bj_HEROSTAT_INT = jass.bj_HEROSTAT_INT
local bj_MODIFYMETHOD_ADD = jass.bj_MODIFYMETHOD_ADD
local GetUnitStateJapi = japi.GetUnitState
local DzSetUnitModel = japi.DzSetUnitModel
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local _____706B_628A_5355_4F4D_7C7B_578BID = stringToFourCCSafe("e00D")
local _____9650_65F6_751F_547DBuffID = stringToFourCCSafe("BHwe")
local _____5F85_9500_6BC1_7279_6548_5217_8868 = {}
local _____5DF2_6CE8_518C_7279_6548_9500_6BC1_9A71_52A8 = false
local function _____5904_7406_5F85_9500_6BC1_7279_6548()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    do
        local i = #_____5F85_9500_6BC1_7279_6548_5217_8868 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____5F85_9500_6BC1_7279_6548_5217_8868[i + 1]
                if _____5F53_524D_65F6_95F4 < _____8BB0_5F55["到期时间"] then
                    goto __continue4
                end
                DestroyEffect(_____8BB0_5F55["句柄"])
                __TS__ArraySplice(_____5F85_9500_6BC1_7279_6548_5217_8868, i, 1)
            end
            ::__continue4::
            i = i - 1
        end
    end
end
local function _____5B89_6392_7279_6548_9500_6BC1(effect, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if effect == nil or effect == 0 then
        return
    end
    if not _____5DF2_6CE8_518C_7279_6548_9500_6BC1_9A71_52A8 then
        _____5DF2_6CE8_518C_7279_6548_9500_6BC1_9A71_52A8 = true
        addPeriodicCallback(100, _____5904_7406_5F85_9500_6BC1_7279_6548)
    end
    _____5F85_9500_6BC1_7279_6548_5217_8868[#_____5F85_9500_6BC1_7279_6548_5217_8868 + 1] = {
        ["句柄"] = effect,
        ["到期时间"] = getServerTime() + _____6301_7EED_79D2 * 1000
    }
end
____exports["获取范围敌人"] = function(_____6765_6E90, x, y, _____534A_5F84)
    return getEnemyUnitsInRange(_____6765_6E90, x, y, _____534A_5F84)
end
____exports["获取范围友军"] = function(_____6765_6E90, x, y, _____534A_5F84)
    local all = getUnitsInRange(x, y, _____534A_5F84)
    local result = {}
    local owner = GetOwningPlayer(_____6765_6E90)
    for ____, unit in ipairs(all) do
        if unit ~= nil and unit ~= 0 and IsUnitAlly(unit, owner) then
            result[#result + 1] = unit
        end
    end
    return result
end
____exports["获取范围尸体"] = function(x, y, _____534A_5F84)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        _____534A_5F84,
        nil
    )
    local result = {}
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        if IsUnitType(unit, UNIT_TYPE_DEAD) == true and IsUnitType(unit, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(unit, UNIT_TYPE_ANCIENT) ~= true and GetUnitFlyHeight(unit) <= 999999 then
            result[#result + 1] = unit
        end
        GroupRemoveUnit(group, unit)
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return result
end
____exports["取单位X"] = function(_____5355_4F4D)
    return GetUnitX(_____5355_4F4D)
end
____exports["取单位Y"] = function(_____5355_4F4D)
    return GetUnitY(_____5355_4F4D)
end
____exports["计算两点距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
____exports["计算两点角度"] = function(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG
end
____exports["限制目标点距离"] = function(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y, _____6700_5927_8DDD_79BB)
    local angle = ____exports["计算两点角度"](_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    local distance = ____exports["计算两点距离"](_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    if distance <= _____6700_5927_8DDD_79BB then
        return {x = _____76EE_6807X, y = _____76EE_6807Y, angle = angle}
    end
    local rad = angle * bj_DEGTORAD
    return {
        x = _____8D77_70B9X + Cos(rad) * _____6700_5927_8DDD_79BB,
        y = _____8D77_70B9Y + Sin(rad) * _____6700_5927_8DDD_79BB,
        angle = angle
    }
end
return ____exports
