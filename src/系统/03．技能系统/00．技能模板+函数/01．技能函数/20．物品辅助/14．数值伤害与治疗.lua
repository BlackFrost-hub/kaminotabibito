local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____12_FF0E_7269_54C1_4E0E_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.12．物品与单位")
local _____5355_4F4D_5B58_6D3B = ____12_FF0E_7269_54C1_4E0E_5355_4F4D["单位存活"]
local ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3 = ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF["造成装备技能伤害"]
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
local _____706B_628A_5355_4F4D_7C7B_578BID = stringToFourCCSafe("e0FT")
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
    if not _____5355_4F4D_5B58_6D3B(_____6765_6E90) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
        ["来源"] = _____6765_6E90,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["伤害形态"] = "单体"
    })
end
____exports["造成火焰伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not _____5355_4F4D_5B58_6D3B(_____6765_6E90) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
        ["来源"] = _____6765_6E90,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["伤害形态"] = "单体"
    })
end
____exports["造成暗影伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not _____5355_4F4D_5B58_6D3B(_____6765_6E90) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
        ["来源"] = _____6765_6E90,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["伤害形态"] = "单体"
    })
end
____exports["造成普通伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3)
    if not _____5355_4F4D_5B58_6D3B(_____6765_6E90) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
        ["来源"] = _____6765_6E90,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["伤害形态"] = "单体"
    })
end
____exports["造成精神自伤"] = function(_____5355_4F4D, _____4F24_5BB3)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or not (_____4F24_5BB3 > 0) then
        return
    end
    _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
        ["来源"] = _____5355_4F4D,
        ["目标"] = _____5355_4F4D,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_MIND,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["伤害形态"] = "单体"
    })
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
        HealEffect = _____751F_547D > 0,
        UseDefaultHealEffect = _____751F_547D > 0,
        HealEffectPath = nil,
        ManaEffect = _____9B54_6CD5 > 0,
        UseDefaultManaEffect = _____9B54_6CD5 > 0,
        ManaEffectPath = nil
    })
end
return ____exports
