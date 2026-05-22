local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Number = ____lualib.__TS__Number
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
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4 = ____require_result_9["创建单位并登记排泄"]
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
local UnitDamageTarget = jass.UnitDamageTarget
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
____exports["取句柄ID"] = function(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
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
____exports["取当前生命"] = function(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
end
____exports["取当前魔法"] = function(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, UNIT_STATE_MANA)
end
____exports["取最大生命"] = function(_____5355_4F4D)
    return GetUnitStateJapi(_____5355_4F4D, UNIT_STATE_MAX_LIFE)
end
____exports["取最大魔法"] = function(_____5355_4F4D)
    return GetUnitStateJapi(_____5355_4F4D, UNIT_STATE_MAX_MANA)
end
____exports["取单位攻击"] = function(_____5355_4F4D)
    return GetUnitStateJapi(
        _____5355_4F4D,
        ConvertUnitState(21)
    )
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
____exports["设置生命"] = function(_____5355_4F4D, _____6570_503C)
    SetUnitState(_____5355_4F4D, UNIT_STATE_LIFE, _____6570_503C)
end
____exports["设置魔法"] = function(_____5355_4F4D, _____6570_503C)
    SetUnitState(_____5355_4F4D, UNIT_STATE_MANA, _____6570_503C)
end
____exports["调整生命"] = function(_____5355_4F4D, _____6570_503C)
    SetUnitState(
        _____5355_4F4D,
        UNIT_STATE_LIFE,
        GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) + _____6570_503C
    )
end
____exports["调整魔法"] = function(_____5355_4F4D, _____6570_503C)
    SetUnitState(
        _____5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____5355_4F4D, UNIT_STATE_MANA) + _____6570_503C
    )
end
____exports["造成强化伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not ____exports["单位存活"](_____6765_6E90) or not ____exports["单位存活"](_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_ENHANCED,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["造成火焰伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not ____exports["单位存活"](_____6765_6E90) or not ____exports["单位存活"](_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_FIRE,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["造成暗影伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not ____exports["单位存活"](_____6765_6E90) or not ____exports["单位存活"](_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_SHADOW_STRIKE,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["造成普通伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not ____exports["单位存活"](_____6765_6E90) or not ____exports["单位存活"](_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["造成精神自伤"] = function(_____5355_4F4D, _____4F24_5BB3)
    if not ____exports["单位存活"](_____5355_4F4D) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____5355_4F4D,
        _____5355_4F4D,
        _____4F24_5BB3,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_MIND,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["执行治疗"] = function(_____6765_6E90, _____76EE_6807, _____751F_547D, _____9B54_6CD5)
    if _____9B54_6CD5 == nil then
        _____9B54_6CD5 = 0
    end
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    doHeal({
        HealSource = _____6765_6E90,
        HealTarget = _____76EE_6807,
        HealAmount = _____751F_547D,
        HealManaAmount = _____9B54_6CD5,
        ItemHeal = true,
        HealEffect = false,
        UseDefaultHealEffect = false,
        HealEffectPath = nil,
        ManaEffect = false,
        UseDefaultManaEffect = false,
        ManaEffectPath = nil
    })
end
____exports["播放点特效"] = function(_____6A21_578B, x, y, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffect(_____6A21_578B, x, y)
    _____5B89_6392_7279_6548_9500_6BC1(effect, _____6301_7EED_79D2)
end
____exports["播放单位特效"] = function(_____6A21_578B, _____5355_4F4D, _____6302_70B9, _____6301_7EED_79D2)
    if _____6302_70B9 == nil then
        _____6302_70B9 = "origin"
    end
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffectTarget(_____6A21_578B, _____5355_4F4D, _____6302_70B9)
    _____5B89_6392_7279_6548_9500_6BC1(effect, _____6301_7EED_79D2)
end
____exports["施加眩晕"] = function(_____6765_6E90, _____76EE_6807, _____6301_7EED_65F6_95F4)
    SFB_setBuff(_____6765_6E90, _____76EE_6807, 0, _____6301_7EED_65F6_95F4)
end
____exports["施加减速"] = function(_____6765_6E90, _____76EE_6807, _____964D_4F4E_6BD4_4F8B, _____6301_7EED_65F6_95F4)
    SFB_setSlow(
        _____6765_6E90,
        _____76EE_6807,
        _____964D_4F4E_6BD4_4F8B,
        _____964D_4F4E_6BD4_4F8B,
        _____6301_7EED_65F6_95F4
    )
end
____exports["清除负面Buff"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_8D1F_9762Buff(_____5355_4F4D, false)
end
____exports["临时调整攻击"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 1, _____6570_503C)
end
____exports["临时调整护甲"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 2, _____6570_503C)
end
____exports["临时调整攻速"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 10, _____6570_503C)
end
____exports["调整玩家属性"] = function(_____5355_4F4D, _____5C5E_6027_540D, _____589E_91CF)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local owner = GetOwningPlayer(_____5355_4F4D)
    local oldValue = __TS__Number(YDUserDataGetSafe("player", owner, _____5C5E_6027_540D, "real")) or 0
    YDUserDataSetSafe(
        "player",
        owner,
        _____5C5E_6027_540D,
        "real",
        oldValue + _____589E_91CF
    )
end
____exports["调整单位属性"] = function(_____5355_4F4D, _____5C5E_6027_540D, _____589E_91CF)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local oldValue = __TS__Number(YDUserDataGetSafe("unit", _____5355_4F4D, _____5C5E_6027_540D, "real")) or 0
    YDUserDataSetSafe(
        "unit",
        _____5355_4F4D,
        _____5C5E_6027_540D,
        "real",
        oldValue + _____589E_91CF
    )
end
____exports["读取玩家属性"] = function(_____5355_4F4D, _____5C5E_6027_540D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe(
        "player",
        GetOwningPlayer(_____5355_4F4D),
        _____5C5E_6027_540D,
        "real"
    )) or 0
end
____exports["读取单位属性"] = function(_____5355_4F4D, _____5C5E_6027_540D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", _____5355_4F4D, _____5C5E_6027_540D, "real")) or 0
end
____exports["英雄主属性是智力"] = function(_____82F1_96C4)
    if not ____exports["单位是英雄"](_____82F1_96C4) then
        return false
    end
    local intValue = GetHeroInt(_____82F1_96C4, false)
    return intValue > GetHeroStr(_____82F1_96C4, false) and intValue > GetHeroAgi(_____82F1_96C4, false)
end
____exports["增加英雄经验与智力"] = function(_____82F1_96C4, _____6B21_6570, _____6BCF_6B21_7ECF_9A8C, _____667A_529B)
    do
        local i = 0
        while i < _____6B21_6570 do
            AddHeroXP(_____82F1_96C4, _____6BCF_6B21_7ECF_9A8C, true)
            i = i + 1
        end
    end
    ModifyHeroStat(bj_HEROSTAT_INT, _____82F1_96C4, bj_MODIFYMETHOD_ADD, _____667A_529B)
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
____exports["单位所在点是荒芜"] = function(_____5355_4F4D)
    return IsPointBlighted(
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    ) == true
end
____exports["击退远离来源"] = function(_____6765_6E90, _____76EE_6807, _____8DDD_79BB, _____6301_7EED_65F6_95F4)
    if not ____exports["单位存活"](_____76EE_6807) then
        return
    end
    _____5F00_59CB_51FB_9000(_____76EE_6807, {
        ["来源单位"] = _____6765_6E90,
        ["距离"] = _____8DDD_79BB,
        ["持续时间"] = _____6301_7EED_65F6_95F4,
        ["检查地形"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true
    })
end
____exports["拉向来源"] = function(_____6765_6E90, _____76EE_6807, _____8DDD_79BB, _____6301_7EED_65F6_95F4)
    local tx = GetUnitX(_____76EE_6807)
    local ty = GetUnitY(_____76EE_6807)
    local sx = GetUnitX(_____6765_6E90)
    local sy = GetUnitY(_____6765_6E90)
    _____5F00_59CB_51FB_9000(_____76EE_6807, {
        ["来源X"] = tx * 2 - sx,
        ["来源Y"] = ty * 2 - sy,
        ["距离"] = _____8DDD_79BB,
        ["持续时间"] = _____6301_7EED_65F6_95F4,
        ["检查地形"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true
    })
end
____exports["命令攻击来源"] = function(_____76EE_6807, _____6765_6E90)
    IssueTargetOrder(_____76EE_6807, "attack", _____6765_6E90)
end
____exports["取玩家ID"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return -1
    end
    return GetPlayerId(GetOwningPlayer(_____5355_4F4D))
end
____exports["创建火把单位"] = function(_____6765_6E90, x, y, face, _____6A21_578B, _____6301_7EED_65F6_95F4)
    if _____706B_628A_5355_4F4D_7C7B_578BID == 0 then
        return
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4(
        GetOwningPlayer(_____6765_6E90),
        _____706B_628A_5355_4F4D_7C7B_578BID,
        x,
        y,
        face
    )
    if unit == nil or unit == 0 then
        return
    end
    DzSetUnitModel(unit, _____6A21_578B)
    SetUnitScale(unit, 1, 1, 1)
    SetUnitInvulnerable(unit, true)
    SetUnitFacing(_____6765_6E90, face)
    UnitApplyTimedLife(unit, _____9650_65F6_751F_547DBuffID, _____6301_7EED_65F6_95F4)
end
return ____exports
