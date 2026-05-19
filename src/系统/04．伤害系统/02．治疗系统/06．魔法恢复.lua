--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57, jass
function _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, amount, color)
    if target == nil or amount == 0 then
        return
    end
    local x = jass.GetUnitX(target)
    local y = jass.GetUnitY(target)
    local z = jass.GetUnitFlyHeight(target) + 100
    local text = tostring(jass.R2I(amount + 0.5)
    )
    local eff = jass.CreateTextTag()
    if eff == nil then
        return
    end
    jass.SetTextTagText(eff, text, 0.024)
    jass.SetTextTagPos(eff, x, y, z)
    jass.SetTextTagColor(
        eff,
        color["红"],
        color["绿"],
        color["蓝"],
        255
    )
    jass.SetTextTagVelocity(eff, 0, 0.035)
    jass.SetTextTagFadepoint(eff, 1)
    jass.SetTextTagDuration(eff, 1)
    jass.ShowTextTag(eff, true)
    local g = _G
    if g.__textTagCount == nil then
        g.__textTagCount = 0
    end
    g.__textTagCount = g.__textTagCount + 1
    local count = g.__textTagCount
    local timer = jass.CreateTimer()
    jass.TimerStart(
        timer,
        1,
        false,
        function()
            jass.DestroyTextTag(eff)
            jass.DestroyTimer(timer)
        end
    )
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_0.STES_FireWithParams
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local restoreMana = ____require_result_1.restoreMana
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
--- 系统开关
local MANA_REGEN_SYSTEM_ENABLED = true
--- 魔法恢复特效路径
local DEFAULT_MANA_HEAL_EFFECT_PATH = "Abilities\\Spells\\Items\\AIta\\AItaTarget.mdl"
--- 魔法减少特效路径
local DEFAULT_MANA_DRAIN_EFFECT_PATH = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"
--- 魔法增加/减少专用函数
-- 
-- @param target 目标单位
-- @param amount 增加量（正数为增加，负数为减少）
-- @param showText 是否显示魔法漂浮字（默认 true）
-- @param showManaEffect 是否播放特效（默认 true）
-- @returns 实际变化量
____exports["魔法增减"] = function(target, amount, showText, showManaEffect)
    if showText == nil then
        showText = true
    end
    if showManaEffect == nil then
        showManaEffect = true
    end
    if not MANA_REGEN_SYSTEM_ENABLED then
        return 0
    end
    if target == nil or target == 0 then
        return 0
    end
    if IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return 0
    end
    if amount == 0 then
        return 0
    end
    local curMana = GetUnitState(target, UNIT_STATE_MANA)
    if amount > 0 then
        local maxMana = GetUnitState(target, jass.UNIT_STATE_MAX_MANA)
        local missingMana = maxMana - curMana
        local actualMana = amount < missingMana and amount or missingMana
        if actualMana <= 0 then
            return 0
        end
        SetUnitState(target, UNIT_STATE_MANA, curMana + actualMana)
        if showManaEffect then
            local eff = AddSpecialEffectTarget(DEFAULT_MANA_HEAL_EFFECT_PATH, target, "origin")
            if eff ~= nil then
                DestroyEffect(eff)
            end
        end
        if showText then
            _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, actualMana, {["红"] = 0, ["绿"] = 100, ["蓝"] = 255})
        end
        return actualMana
    else
        local decreaseAmount = -amount
        local actualDecrease = decreaseAmount < curMana and decreaseAmount or curMana
        if actualDecrease <= 0 then
            return 0
        end
        SetUnitState(target, UNIT_STATE_MANA, curMana - actualDecrease)
        if showManaEffect then
            local eff = AddSpecialEffectTarget(DEFAULT_MANA_DRAIN_EFFECT_PATH, target, "origin")
            if eff ~= nil then
                DestroyEffect(eff)
            end
        end
        if showText then
            _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, -actualDecrease, {["红"] = 150, ["绿"] = 50, ["蓝"] = 255})
        end
        return -actualDecrease
    end
end
--- 执行魔法恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param showText 是否显示魔法漂浮字（默认 true）
-- @param showManaEffect 是否播放魔法恢复特效（默认 false）
-- @returns 实际恢复量
function ____exports.doManaRegen(target, amount, showText, showManaEffect)
    if showText == nil then
        showText = true
    end
    if showManaEffect == nil then
        showManaEffect = false
    end
    if not MANA_REGEN_SYSTEM_ENABLED then
        return 0
    end
    return restoreMana(
        target,
        amount,
        showManaEffect,
        nil,
        showText
    )
end
--- 触发 STES "恢复魔法事件"
-- 供Lua/JASS端调用，JASS端监听器会执行实际恢复
function ____exports.fireManaRegenEvent(target, amount, source)
    STES_FireWithParams("恢复魔法事件", {{type = "real", name = "HealAmount", value = amount}, {type = "unit", name = "HealTarget", value = target}, {type = "unit", name = "HealSource", value = source}})
end
return ____exports
