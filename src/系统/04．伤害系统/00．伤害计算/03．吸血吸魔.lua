--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local showLifeStealText, showManaStealText, CreateFloatTextOnUnit, formatNumber, LIFE_STEAL_TEXT_COLOR, MANA_STEAL_TEXT_COLOR
function showLifeStealText(unit, heal)
    if type(CreateFloatTextOnUnit) ~= "function" then
        return
    end
    local text = "+" .. formatNumber(nil, heal)
    CreateFloatTextOnUnit(unit, text, {
        size = 10,
        red = LIFE_STEAL_TEXT_COLOR.red,
        green = LIFE_STEAL_TEXT_COLOR.green,
        blue = LIFE_STEAL_TEXT_COLOR.blue,
        alpha = LIFE_STEAL_TEXT_COLOR.alpha,
        duration = 1.5,
        speedY = 0.03,
        height = 0.5
    })
end
function showManaStealText(unit, mana)
    if type(CreateFloatTextOnUnit) ~= "function" then
        return
    end
    local text = "+" .. formatNumber(nil, mana)
    CreateFloatTextOnUnit(unit, text, {
        size = 10,
        red = MANA_STEAL_TEXT_COLOR.red,
        green = MANA_STEAL_TEXT_COLOR.green,
        blue = MANA_STEAL_TEXT_COLOR.blue,
        alpha = MANA_STEAL_TEXT_COLOR.alpha,
        duration = 1.5,
        speedY = 0.03,
        height = 0.3
    })
end
--- 吸血与吸魔系统
-- 
-- 功能：伤害吸血、魔法吸血、普攻吸血、伤害吸魔
-- 包含漂浮文字显示
-- 
-- 特殊处理：马甲单位（UNIT_TYPE_ANCIENT）造成的伤害，吸血/吸魔给玩家英雄
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local getRealAttr = ____require_result_1.getRealAttr
local getRealAttrWithLimit = ____require_result_1.getRealAttrWithLimit
local isPlayerUnit = ____require_result_1.isPlayerUnit
local canBreakManaStealLimit = ____require_result_1.canBreakManaStealLimit
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.00．伤害常量")
local STAT_LIMITS = ____require_result_2.STAT_LIMITS
local ENEMY_STAT_LIMITS = ____require_result_2.ENEMY_STAT_LIMITS
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
CreateFloatTextOnUnit = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextOnUnit
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local isAncientUnit = ____require_result_3.isAncientUnit
formatNumber = ____require_result_3.formatNumber
local forEachUnitInGroup = ____require_result_3.forEachUnitInGroup
--- 获取玩家英雄组
-- 存储位置：YDUserDataGet("string", "玩家英雄", "单位组", "group")
function ____exports.getPlayerHeroGroup()
    do
        local function ____catch(_e)
            return true, nil
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            return true, YDUserDataGet(
                nil,
                "string",
                "玩家英雄",
                "单位组",
                "group"
            )
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
--- 获取马甲单位所属玩家的英雄
-- 遍历玩家英雄组，找到属于同一玩家的英雄
function ____exports.getHeroForAncientUnit(ancientUnit)
    if ancientUnit == nil then
        return nil
    end
    local owner = jass:GetOwningPlayer(ancientUnit)
    if owner == nil then
        return nil
    end
    local heroGroup = ____exports.getPlayerHeroGroup()
    if heroGroup == nil then
        return nil
    end
    local foundHero = nil
    forEachUnitInGroup(
        nil,
        heroGroup,
        function(enumUnit)
            if enumUnit ~= nil and jass:GetOwningPlayer(enumUnit) == owner then
                if jass:IsUnitType(enumUnit, jass.UNIT_TYPE_HERO) then
                    foundHero = enumUnit
                end
            end
        end
    )
    return foundHero
end
--- 获取吸血/吸魔的实际受益单位
-- - 普通单位：返回自身
-- - 马甲单位：返回所属玩家的英雄
function ____exports.getStealBeneficiary(source)
    if source == nil then
        return nil
    end
    if isAncientUnit(nil, source) then
        return ____exports.getHeroForAncientUnit(source)
    end
    return source
end
--- 计算伤害吸血
-- 
-- @param attacker 攻击者
-- @param isPlayer 是否为玩家
-- @returns 吸血百分比
function ____exports.calcLifeSteal(attacker, isPlayer)
    local lifeSteal = getRealAttr(nil, attacker, "伤害吸血", 0)
    local limit = isPlayer and STAT_LIMITS["伤害吸血"] or ENEMY_STAT_LIMITS["伤害吸血"]
    if limit ~= nil then
        if isPlayer and lifeSteal > limit.max then
            local breakLimit = getRealAttr(nil, attacker, "伤害吸血上限", 0)
            lifeSteal = breakLimit > 0 and (lifeSteal < breakLimit and lifeSteal or breakLimit) or limit.max
        elseif lifeSteal > limit.max then
            lifeSteal = limit.max
        end
        if lifeSteal < limit.min then
            lifeSteal = limit.min
        end
    end
    return lifeSteal
end
--- 计算魔法伤害吸血
-- 
-- @param attacker 攻击者
-- @param isPlayer 是否为玩家
-- @returns 吸血百分比
function ____exports.calcMagicLifeSteal(attacker, isPlayer)
    local magicLifeSteal = getRealAttr(nil, attacker, "魔法伤害吸血", 0)
    local limit = isPlayer and STAT_LIMITS["魔法伤害吸血"] or ENEMY_STAT_LIMITS["魔法伤害吸血"]
    if limit ~= nil then
        if magicLifeSteal > limit.max then
            magicLifeSteal = limit.max
        end
        if magicLifeSteal < limit.min then
            magicLifeSteal = limit.min
        end
    end
    return magicLifeSteal
end
--- 计算普攻伤害吸血
-- 
-- @param attacker 攻击者
-- @param isPlayer 是否为玩家
-- @returns 吸血百分比
function ____exports.calcNormalAttackLifeSteal(attacker, isPlayer)
    local atkLifeSteal = getRealAttr(nil, attacker, "普攻伤害吸血", 0)
    local limit = isPlayer and STAT_LIMITS["普攻伤害吸血"] or ENEMY_STAT_LIMITS["普攻伤害吸血"]
    if limit ~= nil then
        if atkLifeSteal > limit.max then
            atkLifeSteal = limit.max
        end
        if atkLifeSteal < limit.min then
            atkLifeSteal = limit.min
        end
    end
    return atkLifeSteal
end
--- 计算总吸血百分比
-- 
-- @param attacker 攻击者
-- @param isPlayer 是否为玩家
-- @param isMagic 是否魔法伤害
-- @param isNormalAttack 是否普攻
function ____exports.calcTotalLifeSteal(attacker, isPlayer, isMagic, isNormalAttack)
    local total = ____exports.calcLifeSteal(attacker, isPlayer)
    if isMagic then
        total = total + ____exports.calcMagicLifeSteal(attacker, isPlayer)
    end
    if isNormalAttack then
        total = total + ____exports.calcNormalAttackLifeSteal(attacker, isPlayer)
    end
    return total
end
--- 计算吸血回复值
-- 
-- @param attacker 攻击者
-- @param damage 最终伤害
-- @param isMagic 是否魔法伤害
-- @param isNormalAttack 是否普攻
-- @returns 回复值
function ____exports.calcLifeStealHeal(attacker, damage, isMagic, isNormalAttack)
    local isPlayer = isPlayerUnit(nil, attacker)
    local lifeStealPercent = ____exports.calcTotalLifeSteal(attacker, isPlayer, isMagic, isNormalAttack)
    if lifeStealPercent <= 0 then
        return 0
    end
    local heal = damage * lifeStealPercent
    local healReceived = getRealAttr(nil, attacker, "受到的治疗率", 0)
    if healReceived ~= 0 then
        heal = heal * (1 + healReceived)
    end
    return heal
end
--- 执行吸血回复
-- 
-- @param attacker 攻击者
-- @param heal 回复值
-- @param showText 是否显示漂浮文字
function ____exports.applyLifeSteal(attacker, heal, showText)
    if showText == nil then
        showText = true
    end
    if heal <= 0 or attacker == nil then
        return
    end
    local currentLife = jass:GetUnitState(attacker, jass.UNIT_STATE_LIFE)
    local maxLife = jass:GetUnitState(attacker, jass.UNIT_STATE_MAX_LIFE)
    local lifeGap = maxLife - currentLife
    local actualHeal = heal < lifeGap and heal or lifeGap
    if actualHeal <= 0 then
        return
    end
    jass:SetUnitState(attacker, jass.UNIT_STATE_LIFE, currentLife + actualHeal)
    if showText then
        showLifeStealText(attacker, actualHeal)
    end
end
--- 计算伤害吸魔
-- 
-- @param attacker 攻击者
-- @param damage 最终伤害
-- @returns 吸魔值
function ____exports.calcManaSteal(attacker, damage)
    if not jass:IsUnitType(attacker, jass.UNIT_TYPE_HERO) then
        return 0
    end
    local isPlayer = isPlayerUnit(nil, attacker)
    local manaStealPercent = getRealAttr(nil, attacker, "伤害吸魔", 0)
    if manaStealPercent <= 0 then
        return 0
    end
    local limit = isPlayer and STAT_LIMITS["伤害吸魔"] or ENEMY_STAT_LIMITS["伤害吸魔"]
    if limit ~= nil then
        if isPlayer and manaStealPercent > limit.max and not canBreakManaStealLimit(nil, attacker) then
            manaStealPercent = limit.max
        elseif manaStealPercent > limit.max then
            manaStealPercent = limit.max
        end
        if manaStealPercent < limit.min then
            manaStealPercent = limit.min
        end
    end
    return damage * manaStealPercent
end
--- 执行伤害吸魔
-- 
-- @param attacker 攻击者
-- @param mana 回复值
-- @param showText 是否显示漂浮文字
function ____exports.applyManaSteal(attacker, mana, showText)
    if showText == nil then
        showText = true
    end
    if mana <= 0 or attacker == nil then
        return
    end
    local currentMana = jass:GetUnitState(attacker, jass.UNIT_STATE_MANA)
    local maxMana = jass:GetUnitState(attacker, jass.UNIT_STATE_MAX_MANA)
    local manaGap = maxMana - currentMana
    local actualMana = mana < manaGap and mana or manaGap
    if actualMana <= 0 then
        return
    end
    jass:SetUnitState(attacker, jass.UNIT_STATE_MANA, currentMana + actualMana)
    if showText then
        showManaStealText(attacker, actualMana)
    end
end
LIFE_STEAL_TEXT_COLOR = {red = 0, green = 255, blue = 0, alpha = 0}
MANA_STEAL_TEXT_COLOR = {red = 0, green = 150, blue = 255, alpha = 0}
--- 执行吸血和吸魔
-- 
-- @param attacker 攻击者（可能是马甲单位）
-- @param damage 最终伤害
-- @param isMagic 是否魔法伤害
-- @param isNormalAttack 是否普攻
-- @param showText 是否显示漂浮文字
function ____exports.applyLifeAndManaSteal(attacker, damage, isMagic, isNormalAttack, showText)
    if showText == nil then
        showText = true
    end
    local beneficiary = ____exports.getStealBeneficiary(attacker)
    if beneficiary == nil then
        return
    end
    local heal = ____exports.calcLifeStealHeal(beneficiary, damage, isMagic, isNormalAttack)
    if heal > 0 then
        ____exports.applyLifeSteal(beneficiary, heal, showText)
    end
    local mana = ____exports.calcManaSteal(beneficiary, damage)
    if mana > 0 then
        ____exports.applyManaSteal(beneficiary, mana, showText)
    end
end
return ____exports
