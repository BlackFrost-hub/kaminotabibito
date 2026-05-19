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
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local HEAL_SYSTEM_ENABLED = ____require_result_0.HEAL_SYSTEM_ENABLED
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local fireShowDamageEvent = ____require_result_1.fireShowDamageEvent
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
    if not HEAL_SYSTEM_ENABLED then
        return 0
    end
    if target == nil or target == 0 then
        return 0
    end
    if amount <= 0 then
        return 0
    end
    if IsUnitType(target, UNIT_TYPE_DEAD) == true then
        return 0
    end
    local currentLife = GetUnitStateJass(target, UNIT_STATE_LIFE)
    local safeMinLife = _____6700_4F4E_4FDD_7559_751F_547D > 0 and _____6700_4F4E_4FDD_7559_751F_547D or 0
    if currentLife <= safeMinLife then
        return 0
    end
    local maxReduce = currentLife - safeMinLife
    local actualReduce = amount < maxReduce and amount or maxReduce
    if actualReduce <= 0 then
        return 0
    end
    SetUnitStateJass(target, UNIT_STATE_LIFE, currentLife - actualReduce)
    if showEffect and effectPath ~= nil and effectPath ~= "" then
        local effect = AddSpecialEffectTarget(effectPath, target, "origin")
        if effect ~= nil and effect ~= 0 then
            DestroyEffect(effect)
        end
    end
    if showText then
        fireShowDamageEvent(
            target,
            actualReduce,
            255,
            0,
            0
        )
    end
    return actualReduce
end
return ____exports
