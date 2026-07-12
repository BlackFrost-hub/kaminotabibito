local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____12_FF0E_7269_54C1_4E0E_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.12．物品与单位")
local _____5355_4F4D_5B58_6D3B = ____12_FF0E_7269_54C1_4E0E_5355_4F4D["单位存活"]
local _____5355_4F4D_662F_82F1_96C4 = ____12_FF0E_7269_54C1_4E0E_5355_4F4D["单位是英雄"]
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
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_8["创建单位并登记排泄安全"]
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
local SetHeroInt = jass.SetHeroInt
local AddHeroXP = jass.AddHeroXP
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
local GetUnitStateJapi = japi.GetUnitState
local DzSetUnitModel = japi.DzSetUnitModel
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local _____706B_628A_5355_4F4D_7C7B_578BID = stringToFourCCSafe("e0FT")
local _____9650_65F6_751F_547DBuffID = stringToFourCCSafe("BHwe")
local _____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C = 0.000001
____exports["临时调整攻击"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 1, _____6570_503C)
end
____exports["临时调整护甲"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 2, _____6570_503C)
end
____exports["临时调整攻速"] = function(_____5355_4F4D, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, 10, _____6570_503C)
end
____exports["调整状态ID属性"] = function(_____5355_4F4D, _____5C5E_6027ID, _____6570_503C)
    SGSS_SetState(_____5355_4F4D, _____5C5E_6027ID, _____6570_503C)
end
____exports["调整玩家属性"] = function(_____5355_4F4D, _____5C5E_6027_540D, _____589E_91CF)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local owner = GetOwningPlayer(_____5355_4F4D)
    local oldValue = __TS__Number(YDUserDataGetSafe("player", owner, _____5C5E_6027_540D, "real")) or 0
    local newValue = oldValue + _____589E_91CF
    if newValue < _____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C and newValue > -_____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C then
        newValue = 0
    end
    YDUserDataSetSafe(
        "player",
        owner,
        _____5C5E_6027_540D,
        "real",
        newValue
    )
end
____exports["调整单位属性"] = function(_____5355_4F4D, _____5C5E_6027_540D, _____589E_91CF)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local oldValue = __TS__Number(YDUserDataGetSafe("unit", _____5355_4F4D, _____5C5E_6027_540D, "real")) or 0
    local newValue = oldValue + _____589E_91CF
    if newValue < _____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C and newValue > -_____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C then
        newValue = 0
    end
    YDUserDataSetSafe(
        "unit",
        _____5355_4F4D,
        _____5C5E_6027_540D,
        "real",
        newValue
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
    if not _____5355_4F4D_662F_82F1_96C4(_____82F1_96C4) then
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
    SetHeroInt(
        _____82F1_96C4,
        GetHeroInt(_____82F1_96C4, false) + _____667A_529B,
        true
    )
end
____exports["击退远离来源"] = function(_____6765_6E90, _____76EE_6807, _____8DDD_79BB, _____6301_7EED_65F6_95F4)
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
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
return ____exports
