--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_1.isUnitEnemy
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_3["减少生命值"]
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_3["减少魔法值"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_4.SGSS_SetState
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断")
local _____662F_5426_7CBE_82F1_5355_4F4D = ____require_result_5["是否精英单位"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff")
local _____5FEB_901F_51CF_901FBuff = ____require_result_6["快速减速Buff"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_7["施加扩展控制"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统")
local _____5F00_59CB_539F_5730_51FB_98DE = ____require_result_8["开始原地击飞"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local IsUnitType = jass.IsUnitType
local GetHeroStr = jass.GetHeroStr
local UnitDamageTarget = jass.UnitDamageTarget
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local EXSetEffectSize = japi.EXSetEffectSize
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ____jass_DAMAGE_TYPE_DIVINE_9 = jass.DAMAGE_TYPE_DIVINE
if ____jass_DAMAGE_TYPE_DIVINE_9 == nil then
    ____jass_DAMAGE_TYPE_DIVINE_9 = jass.DAMAGE_TYPE_UNIVERSAL
end
local DAMAGE_TYPE_DIVINE = ____jass_DAMAGE_TYPE_DIVINE_9
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
____exports["配置型单位有效存活"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
____exports["配置型单位是精英目标"] = function(unit)
    if not ____exports["配置型单位有效存活"](unit) then
        return false
    end
    return _____662F_5426_7CBE_82F1_5355_4F4D(unit) == true
end
____exports["配置型取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["配置型取单位Y"] = function(unit)
    return GetUnitY(unit)
end
____exports["配置型取当前生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
____exports["配置型取最大生命"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
end
____exports["配置型取最大魔法"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
end
____exports["配置型取攻击力"] = function(unit)
    return GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    )
end
____exports["配置型取力量"] = function(unit)
    if not ____exports["配置型单位有效存活"](unit) or IsUnitType(unit, UNIT_TYPE_HERO) ~= true then
        return 0
    end
    return GetHeroStr(unit, true)
end
____exports["解析配置型攻击效果伤害类型"] = function(_____7C7B_578B)
    if _____7C7B_578B == "火焰" then
        return DAMAGE_TYPE_FIRE
    end
    if _____7C7B_578B == "毒素" then
        return DAMAGE_TYPE_POISON
    end
    if _____7C7B_578B == "暗影" then
        return DAMAGE_TYPE_SHADOW_STRIKE
    end
    if _____7C7B_578B == "神圣" then
        return DAMAGE_TYPE_DIVINE
    end
    if _____7C7B_578B == "强化" then
        return DAMAGE_TYPE_ENHANCED
    end
    if _____7C7B_578B == "通用" then
        return DAMAGE_TYPE_UNIVERSAL
    end
    return DAMAGE_TYPE_NORMAL
end
____exports["配置型攻击效果造成伤害"] = function(source, target, amount, _____7C7B_578B)
    if not ____exports["配置型单位有效存活"](source) or not ____exports["配置型单位有效存活"](target) or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        ____exports["解析配置型攻击效果伤害类型"](_____7C7B_578B),
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["配置型攻击效果治疗生命魔法"] = function(source, target, lifeAmount, manaAmount)
    if manaAmount == nil then
        manaAmount = 0
    end
    if not ____exports["配置型单位有效存活"](target) then
        return
    end
    if not (lifeAmount > 0) and not (manaAmount > 0) then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = lifeAmount > 0 and lifeAmount or 0,
        HealManaAmount = manaAmount > 0 and manaAmount or 0,
        ItemHeal = true,
        HealEffect = lifeAmount > 0,
        ManaEffect = manaAmount > 0,
        ManaShowText = manaAmount > 0
    })
end
____exports["配置型攻击效果减少生命魔法"] = function(target, lifeAmount, manaAmount)
    if not ____exports["配置型单位有效存活"](target) then
        return
    end
    if lifeAmount > 0 then
        _____51CF_5C11_751F_547D_503C(
            target,
            lifeAmount,
            true,
            true,
            nil,
            1
        )
    end
    if manaAmount > 0 then
        _____51CF_5C11_9B54_6CD5_503C(target, manaAmount, true, true)
    end
end
____exports["配置型获取敌方范围单位"] = function(source, center, radius, includeCenter)
    if includeCenter == nil then
        includeCenter = false
    end
    if not ____exports["配置型单位有效存活"](source) or not ____exports["配置型单位有效存活"](center) or not (radius > 0) then
        return {}
    end
    local list = getUnitsInRange(
        ____exports["配置型取单位X"](center),
        ____exports["配置型取单位Y"](center),
        radius
    )
    local result = {}
    do
        local i = 0
        while i < #list do
            do
                local unit = list[i + 1]
                if not ____exports["配置型单位有效存活"](unit) then
                    goto __continue33
                end
                if not includeCenter and unit == center then
                    goto __continue33
                end
                if isUnitEnemy(unit, source) ~= true then
                    goto __continue33
                end
                result[#result + 1] = unit
            end
            ::__continue33::
            i = i + 1
        end
    end
    return result
end
____exports["配置型播放目标特效"] = function(target, model, attach)
    if attach == nil then
        attach = "origin"
    end
    if not ____exports["配置型单位有效存活"](target) or model == "" then
        return
    end
    local effect = AddSpecialEffectTarget(model, target, attach)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["配置型播放单位坐标特效"] = function(target, model, scale)
    if not ____exports["配置型单位有效存活"](target) or model == "" then
        return
    end
    local effect = AddSpecialEffect(
        model,
        GetUnitX(target),
        GetUnitY(target)
    )
    if effect == nil or effect == 0 then
        return
    end
    if scale ~= nil and scale > 0 then
        EXSetEffectSize(effect, scale)
    end
    DestroyEffect(effect)
end
____exports["配置型施加减速"] = function(source, target, amount, duration)
    if not (amount > 0) or not (duration > 0) then
        return
    end
    _____5FEB_901F_51CF_901FBuff(
        source,
        target,
        amount,
        amount,
        duration
    )
end
____exports["配置型施加眩晕"] = function(source, target, duration)
    if not (duration > 0) then
        return
    end
    _____65BD_52A0_6269_5C55_63A7_5236(source, target, "stun", {["持续时间"] = duration})
end
____exports["配置型施加击飞"] = function(source, target, duration)
    if not (duration > 0) then
        return
    end
    _____5F00_59CB_539F_5730_51FB_98DE(target, {
        ["持续时间"] = duration,
        ["主单位"] = source,
        ["主单位死亡时中断"] = true,
        ["暂停单位"] = true,
        ["中断已有跳跃"] = true
    })
end
____exports["配置型临时修改攻速"] = function(unit, value)
    if not ____exports["配置型单位有效存活"](unit) or value == 0 then
        return
    end
    SGSS_SetState(unit, 10, value)
end
return ____exports
