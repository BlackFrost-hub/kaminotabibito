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
____exports["是否为使用物品"] = function(_____7269_54C1, _____7269_54C1_7C7B_578BID)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 or _____7269_54C1_7C7B_578BID == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____7269_54C1_7C7B_578BID
end
____exports["单位持有物品"] = function(_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____7269_54C1_7C7B_578BID == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____7269_54C1_7C7B_578BID) == true
end
____exports["获取单位指定物品"] = function(_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    return GetItemOfTypeFromUnitBJ(_____5355_4F4D, _____7269_54C1_7C7B_578BID)
end
____exports["获取物品次数"] = function(_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    local item = ____exports["获取单位指定物品"](_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    if item == nil or item == 0 then
        return 0
    end
    return GetItemCharges(item)
end
____exports["设置物品次数"] = function(_____5355_4F4D, _____7269_54C1_7C7B_578BID, _____6B21_6570)
    local item = ____exports["获取单位指定物品"](_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    if item == nil or item == 0 then
        return
    end
    SetItemCharges(item, _____6B21_6570)
end
____exports["增加物品次数"] = function(_____5355_4F4D, _____7269_54C1_7C7B_578BID, _____6B21_6570, _____6700_5927_503C)
    local current = ____exports["获取物品次数"](_____5355_4F4D, _____7269_54C1_7C7B_578BID)
    local next = current + _____6B21_6570
    if next > _____6700_5927_503C then
        next = _____6700_5927_503C
    end
    ____exports["设置物品次数"](_____5355_4F4D, _____7269_54C1_7C7B_578BID, next)
end
____exports["单位存活"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true and GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) > 0.405
end
____exports["单位是英雄"] = function(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and IsUnitType(_____5355_4F4D, UNIT_TYPE_HERO) == true
end
____exports["单位可作为敌人目标"] = function(_____5355_4F4D)
    if not ____exports["单位存活"](_____5355_4F4D) then
        return false
    end
    if IsUnitType(_____5355_4F4D, UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(_____5355_4F4D, UNIT_TYPE_ANCIENT) then
        return false
    end
    return true
end
____exports["取句柄ID"] = function(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
end
____exports["取玩家ID"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return -1
    end
    return GetPlayerId(GetOwningPlayer(_____5355_4F4D))
end
return ____exports
