--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitStateJass = jass.GetUnitState
local SetUnitStateJass = jass.SetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local HEAL_SYSTEM_ENABLED = ____require_result_0.HEAL_SYSTEM_ENABLED
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local fireShowDamageEvent = ____require_result_1.fireShowDamageEvent
local _____9ED8_8BA4_751F_547D_51CF_5C11_7279_6548_8DEF_5F84 = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl"
local _____9ED8_8BA4_9B54_6CD5_6062_590D_7279_6548_8DEF_5F84 = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
local _____9ED8_8BA4_9B54_6CD5_51CF_5C11_7279_6548_8DEF_5F84 = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"
local function _____53D6_7EDD_5BF9_503C(value)
    return value < 0 and -value or value
end
local function _____83B7_53D6_5F53_524D_503C(target, resourceType)
    if resourceType == "life" then
        return GetUnitStateJass(target, UNIT_STATE_LIFE)
    end
    return GetUnitStateJass(target, UNIT_STATE_MANA)
end
local function _____83B7_53D6_6700_5927_503C(target, resourceType)
    if resourceType == "life" then
        return GetUnitStateJass(target, UNIT_STATE_MAX_LIFE)
    end
    return GetUnitStateJass(target, UNIT_STATE_MAX_MANA)
end
local function _____8BBE_7F6E_5F53_524D_503C(target, resourceType, value)
    if resourceType == "life" then
        SetUnitStateJass(target, UNIT_STATE_LIFE, value)
        return
    end
    SetUnitStateJass(target, UNIT_STATE_MANA, value)
end
local function _____64AD_653E_7279_6548(target, resourceType, amount, effectPath, showEffect)
    if showEffect == nil then
        showEffect = false
    end
    if not showEffect or target == nil or target == 0 then
        return
    end
    local path = effectPath ~= nil and effectPath ~= "" and effectPath or (resourceType == "mana" and (amount >= 0 and _____9ED8_8BA4_9B54_6CD5_6062_590D_7279_6548_8DEF_5F84 or _____9ED8_8BA4_9B54_6CD5_51CF_5C11_7279_6548_8DEF_5F84) or (amount < 0 and _____9ED8_8BA4_751F_547D_51CF_5C11_7279_6548_8DEF_5F84 or ""))
    if path == nil or path == "" then
        return
    end
    local effect = AddSpecialEffectTarget(path, target, "origin")
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
local function _____663E_793A_6570_503C(target, amount, resourceType, showText)
    if showText == nil then
        showText = true
    end
    if not showText or target == nil or target == 0 or amount == 0 then
        return
    end
    if resourceType == "life" then
        if amount >= 0 then
            fireShowDamageEvent(
                target,
                amount,
                0,
                255,
                0
            )
            return
        end
        fireShowDamageEvent(
            target,
            -amount,
            255,
            0,
            0
        )
        return
    end
    if amount >= 0 then
        fireShowDamageEvent(
            target,
            amount,
            0,
            100,
            255
        )
        return
    end
    fireShowDamageEvent(
        target,
        -amount,
        150,
        50,
        255
    )
end
____exports["变更资源值"] = function(target, amount, resourceType, showText, showEffect, effectPath, lowestValue)
    if showText == nil then
        showText = true
    end
    if showEffect == nil then
        showEffect = false
    end
    if lowestValue == nil then
        lowestValue = 0
    end
    if not HEAL_SYSTEM_ENABLED then
        return 0
    end
    if target == nil or target == 0 then
        return 0
    end
    if amount == 0 then
        return 0
    end
    if IsUnitType(target, UNIT_TYPE_DEAD) == true then
        return 0
    end
    local currentValue = _____83B7_53D6_5F53_524D_503C(target, resourceType)
    local maxValue = _____83B7_53D6_6700_5927_503C(target, resourceType)
    local safeMinValue = lowestValue > 0 and lowestValue or 0
    local actualDelta = 0
    if amount > 0 then
        local missingValue = maxValue - currentValue
        actualDelta = amount < missingValue and amount or missingValue
    else
        local maxReduce = currentValue - safeMinValue
        local reduceAmount = -amount
        local actualReduce = reduceAmount < maxReduce and reduceAmount or maxReduce
        actualDelta = -actualReduce
    end
    if actualDelta == 0 then
        return 0
    end
    _____8BBE_7F6E_5F53_524D_503C(target, resourceType, currentValue + actualDelta)
    _____64AD_653E_7279_6548(
        target,
        resourceType,
        actualDelta,
        effectPath,
        showEffect
    )
    _____663E_793A_6570_503C(target, actualDelta, resourceType, showText)
    return actualDelta
end
____exports["减少生命值"] = function(target, amount, showText, showEffect, effectPath, _____6700_4F4E_4FDD_7559_751F_547D)
    if showText == nil then
        showText = true
    end
    if showEffect == nil then
        showEffect = false
    end
    if _____6700_4F4E_4FDD_7559_751F_547D == nil then
        _____6700_4F4E_4FDD_7559_751F_547D = 1
    end
    return ____exports["变更资源值"](
        target,
        -_____53D6_7EDD_5BF9_503C(amount),
        "life",
        showText,
        showEffect,
        effectPath,
        _____6700_4F4E_4FDD_7559_751F_547D
    )
end
____exports["减少魔法值"] = function(target, amount, showText, showEffect, effectPath)
    if showText == nil then
        showText = true
    end
    if showEffect == nil then
        showEffect = false
    end
    return ____exports["变更资源值"](
        target,
        -_____53D6_7EDD_5BF9_503C(amount),
        "mana",
        showText,
        showEffect,
        effectPath,
        0
    )
end
____exports["增加生命值"] = function(target, amount, showText, showEffect, effectPath)
    if showText == nil then
        showText = true
    end
    if showEffect == nil then
        showEffect = false
    end
    return ____exports["变更资源值"](
        target,
        _____53D6_7EDD_5BF9_503C(amount),
        "life",
        showText,
        showEffect,
        effectPath,
        0
    )
end
____exports["增加魔法值"] = function(target, amount, showText, showEffect, effectPath)
    if showText == nil then
        showText = true
    end
    if showEffect == nil then
        showEffect = false
    end
    return ____exports["变更资源值"](
        target,
        _____53D6_7EDD_5BF9_503C(amount),
        "mana",
        showText,
        showEffect,
        effectPath,
        0
    )
end
return ____exports
