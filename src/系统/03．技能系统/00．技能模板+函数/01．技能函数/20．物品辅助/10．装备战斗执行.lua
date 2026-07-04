--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_88C5_5907_6218_6597_5224_65AD = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断")
local _____5355_4F4D_5B58_6D3B = ____09_FF0E_88C5_5907_6218_6597_5224_65AD["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____09_FF0E_88C5_5907_6218_6597_5224_65AD["取当前生命"]
local ____11_FF0E_88C5_5907_5E38_91CF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.11．装备常量")
local _____88C5_5907_5C0F_7279_6548 = ____11_FF0E_88C5_5907_5E38_91CF["装备小特效"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local getEnemyUnitsInRange = ____require_result_0.getEnemyUnitsInRange
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_3["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_3["护盾类型"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6E05_9664_5355_4F4D_8D1F_9762Buff = ____require_result_4["清除单位负面Buff"]
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local SetUnitState = jass.SetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UnitDamageTarget = jass.UnitDamageTarget
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
____exports["扣除当前生命比例"] = function(unit, ratio)
    if not _____5355_4F4D_5B58_6D3B(unit) or not (ratio > 0) then
        return
    end
    local life = _____53D6_5F53_524D_751F_547D(unit)
    local cost = life * ratio
    SetUnitState(unit, UNIT_STATE_LIFE, life - cost > 1 and life - cost or 1)
end
____exports["造成装备伤害"] = function(source, target, amount, damageType, ranged, weaponType)
    if ranged == nil then
        ranged = false
    end
    if weaponType == nil then
        weaponType = WEAPON_TYPE_WHOKNOWS
    end
    if not _____5355_4F4D_5B58_6D3B(source) or not _____5355_4F4D_5B58_6D3B(target) or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        ranged,
        ATTACK_TYPE_NORMAL,
        damageType,
        weaponType
    )
end
____exports["恢复生命魔法"] = function(source, target, hp, mp, _____9ED8_8BA4_9B54_6CD5_7279_6548)
    if mp == nil then
        mp = 0
    end
    if _____9ED8_8BA4_9B54_6CD5_7279_6548 == nil then
        _____9ED8_8BA4_9B54_6CD5_7279_6548 = false
    end
    if target == nil or target == 0 then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = hp,
        HealManaAmount = mp,
        ItemHeal = true,
        HealEffect = hp > 0,
        UseDefaultHealEffect = hp > 0,
        ManaEffect = _____9ED8_8BA4_9B54_6CD5_7279_6548 or mp > 0,
        UseDefaultManaEffect = _____9ED8_8BA4_9B54_6CD5_7279_6548 or mp > 0,
        ManaShowText = mp > 0
    })
end
____exports["播放点特效"] = function(model, x, y, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    addDelayedCallback(
        _____6301_7EED_79D2 * 1000,
        function()
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
        end
    )
end
____exports["播放单位特效"] = function(model, unit, attach, _____6301_7EED_79D2)
    if attach == nil then
        attach = "origin"
    end
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if unit == nil or unit == 0 or model == "" then
        return
    end
    local effect = AddSpecialEffectTarget(model, unit, attach)
    addDelayedCallback(
        _____6301_7EED_79D2 * 1000,
        function()
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
        end
    )
end
____exports["取范围友方"] = function(source, radius)
    local result = {}
    if not _____5355_4F4D_5B58_6D3B(source) then
        return result
    end
    local owner = GetOwningPlayer(source)
    local units = getUnitsInRange(
        GetUnitX(source),
        GetUnitY(source),
        radius
    )
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            if _____5355_4F4D_5B58_6D3B(unit) and IsUnitAlly(unit, owner) == true then
                result[#result + 1] = unit
            end
            i = i + 1
        end
    end
    return result
end
____exports["取范围敌人"] = function(source, target, radius)
    if not _____5355_4F4D_5B58_6D3B(source) or target == nil or target == 0 then
        return {}
    end
    return getEnemyUnitsInRange(
        source,
        GetUnitX(target),
        GetUnitY(target),
        radius
    )
end
____exports["开始通用护盾"] = function(source, target, amount, duration, tag)
    if not _____5355_4F4D_5B58_6D3B(target) or not (amount > 0) then
        return
    end
    _____5F00_59CB_62A4_76FE(target, {
        ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
        ["数值"] = amount,
        ["持续时间"] = duration,
        ["来源单位"] = source,
        ["标签"] = tag,
        ["显示护盾条"] = true,
        ["可驱散"] = true
    })
    ____exports["播放单位特效"](_____88C5_5907_5C0F_7279_6548["护盾闪光"], target, "origin", 0.8)
end
____exports["临时玩家属性"] = function(unit, attr, delta, duration)
    if unit == nil or unit == 0 or delta == 0 or not (duration > 0) then
        return
    end
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, duration * 1000, {{["类型"] = "玩家属性", ["属性名"] = attr, ["数值"] = delta}})
end
____exports["临时治疗率"] = function(unit, delta, duration)
    ____exports["临时玩家属性"](unit, "技能治疗率", delta, duration)
end
____exports["临时受到治疗率"] = function(unit, delta, duration)
    ____exports["临时玩家属性"](unit, "受到的治疗率", delta, duration)
end
____exports["净化负面"] = function(unit)
    return unit ~= nil and unit ~= 0 and _____6E05_9664_5355_4F4D_8D1F_9762Buff(unit, true) > 0
end
____exports["短暂无敌"] = function(unit, _____79D2_6570)
    if not _____5355_4F4D_5B58_6D3B(unit) or not (_____79D2_6570 > 0) then
        return
    end
    SetUnitInvulnerable(unit, true)
    addDelayedCallback(
        _____79D2_6570 * 1000,
        function()
            if unit ~= nil and unit ~= 0 then
                SetUnitInvulnerable(unit, false)
            end
        end
    )
end
return ____exports
