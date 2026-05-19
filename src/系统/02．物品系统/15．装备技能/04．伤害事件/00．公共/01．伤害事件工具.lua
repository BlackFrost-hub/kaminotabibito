--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_0.UnitHasItemOfTypeBJ
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_1.doHeal
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local IsUnitType = jass.IsUnitType
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local GetRandomReal = jass.GetRandomReal
local ConvertUnitState = jass.ConvertUnitState
____exports["伤害事件攻击类型"] = {["普通"] = jass.ATTACK_TYPE_NORMAL, ["混乱"] = jass.ATTACK_TYPE_CHAOS}
____exports["伤害事件伤害类型"] = {
    ["普通"] = jass.DAMAGE_TYPE_NORMAL,
    ["强化"] = jass.DAMAGE_TYPE_ENHANCED,
    ["火焰"] = jass.DAMAGE_TYPE_FIRE,
    ["冰冷"] = jass.DAMAGE_TYPE_COLD,
    ["闪电"] = jass.DAMAGE_TYPE_LIGHTNING,
    ["毒素"] = jass.DAMAGE_TYPE_POISON,
    ["暗影突袭"] = jass.DAMAGE_TYPE_SHADOW_STRIKE,
    ["精神"] = jass.DAMAGE_TYPE_MIND,
    ["通用"] = jass.DAMAGE_TYPE_UNIVERSAL
}
____exports["伤害事件武器类型"] = jass.WEAPON_TYPE_WHOKNOWS
____exports["单位有效存活"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_DEAD) ~= true
end
____exports["单位持有伤害事件装备"] = function(_____5355_4F4D, _____7269_54C1ID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____7269_54C1ID == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____7269_54C1ID) == true
end
____exports["取当前生命"] = function(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, jass.UNIT_STATE_LIFE)
end
____exports["取当前魔法"] = function(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, jass.UNIT_STATE_MANA)
end
____exports["取最大生命"] = function(_____5355_4F4D)
    return GetUnitStateJapi(_____5355_4F4D, jass.UNIT_STATE_MAX_LIFE)
end
____exports["取最大魔法"] = function(_____5355_4F4D)
    return GetUnitStateJapi(_____5355_4F4D, jass.UNIT_STATE_MAX_MANA)
end
____exports["取单位攻击力"] = function(_____5355_4F4D)
    return GetUnitStateJapi(
        _____5355_4F4D,
        ConvertUnitState(21)
    )
end
____exports["取单位护甲"] = function(_____5355_4F4D)
    return GetUnitStateJapi(
        _____5355_4F4D,
        ConvertUnitState(32)
    )
end
____exports["造成伤害事件伤害"] = function(_____6765_6E90, _____76EE_6807, _____4F24_5BB3, _____4F24_5BB3_7C7B_578B)
    if not ____exports["单位有效存活"](_____6765_6E90) or not ____exports["单位有效存活"](_____76EE_6807) or not (_____4F24_5BB3 > 0) then
        return
    end
    UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        false,
        false,
        ____exports["伤害事件攻击类型"]["普通"],
        _____4F24_5BB3_7C7B_578B,
        ____exports["伤害事件武器类型"]
    )
end
____exports["执行物品治疗"] = function(_____6765_6E90, _____76EE_6807, _____751F_547D_503C, _____7279_6548_8DEF_5F84, _____9B54_6CD5_503C, _____9B54_6CD5_7279_6548_8DEF_5F84)
    if _____9B54_6CD5_503C == nil then
        _____9B54_6CD5_503C = 0
    end
    doHeal({
        HealSource = _____6765_6E90,
        HealTarget = _____76EE_6807,
        HealAmount = _____751F_547D_503C,
        HealManaAmount = _____9B54_6CD5_503C,
        ItemHeal = true,
        HealEffect = _____7279_6548_8DEF_5F84 ~= nil and _____7279_6548_8DEF_5F84 ~= "",
        HealEffectPath = _____7279_6548_8DEF_5F84,
        ManaEffect = _____9B54_6CD5_7279_6548_8DEF_5F84 ~= nil and _____9B54_6CD5_7279_6548_8DEF_5F84 ~= "",
        ManaEffectPath = _____9B54_6CD5_7279_6548_8DEF_5F84
    })
end
____exports["播放点特效"] = function(_____6A21_578B, x, y)
    if _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffect(_____6A21_578B, x, y)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["播放单位特效"] = function(_____5355_4F4D, _____6A21_578B, _____6302_70B9)
    if _____6302_70B9 == nil then
        _____6302_70B9 = "origin"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffectTarget(_____6A21_578B, _____5355_4F4D, _____6302_70B9)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["取单位X"] = function(_____5355_4F4D)
    return GetUnitX(_____5355_4F4D)
end
____exports["取单位Y"] = function(_____5355_4F4D)
    return GetUnitY(_____5355_4F4D)
end
____exports["取单位名称"] = function(_____5355_4F4D)
    return GetUnitName(_____5355_4F4D)
end
____exports["随机实数"] = function(_____6700_5C0F_503C, _____6700_5927_503C)
    return GetRandomReal(_____6700_5C0F_503C, _____6700_5927_503C)
end
____exports["是指定伤害类型"] = function(snapshot, _____7C7B_578B)
    return snapshot ~= nil and snapshot.rawDamageType == _____7C7B_578B
end
return ____exports
