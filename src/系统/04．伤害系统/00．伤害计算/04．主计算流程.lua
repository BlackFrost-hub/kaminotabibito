--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local applyElementalDamage, getRealAttrWithLimit, calcElementalDamageBonus, _____4F24_5BB3_51FD_6570
function applyElementalDamage(attacker, target, isPlayer)
    local addDamage = 0
    local multiplier = 1
    if _____4F24_5BB3_51FD_6570.isMetalDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "金属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "金属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isWoodDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "木属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "木属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isWaterDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "水属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "水属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isFireDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "火属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "火属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isThunderDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "雷属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "雷属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isLightDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "光属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "光属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if _____4F24_5BB3_51FD_6570.isDarkDamage() then
        local dmg = calcElementalDamageBonus(nil, attacker, "暗属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "暗属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    return {addDamage = addDamage, multiplier = multiplier}
end
--- 伤害计算主流程
-- 
-- 功能：整合所有模块，执行完整的伤害计算流程
-- 包含：免疫判定、护甲穿透、魔抗、属性伤害/抗性、专精、吸血吸魔
-- 末尾：`YDWESetEventDamage` 之后通知 `registerAppliedFinalDamageListener` 订阅者（原 `06．最终伤害桥接`）。
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local getRealAttr = ____require_result_0.getRealAttr
getRealAttrWithLimit = ____require_result_0.getRealAttrWithLimit
local isPlayerUnit = ____require_result_0.isPlayerUnit
local isImmuneDamage = ____require_result_0.isImmuneDamage
local isImmuneNormalAttack = ____require_result_0.isImmuneNormalAttack
local isDamageReduceDisabled = ____require_result_0.isDamageReduceDisabled
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.02．伤害修正")
local applyArmorPenetration = ____require_result_1.applyArmorPenetration
local applyMagicResist = ____require_result_1.applyMagicResist
local getPhysicalDamageModifier = ____require_result_1.getPhysicalDamageModifier
local getSkillDamageModifier = ____require_result_1.getSkillDamageModifier
local getNormalAttackModifier = ____require_result_1.getNormalAttackModifier
local getMagicDamageModifier = ____require_result_1.getMagicDamageModifier
local getEnhancedDamageModifier = ____require_result_1.getEnhancedDamageModifier
local getFinalDamageBonus = ____require_result_1.getFinalDamageBonus
local getAntMasteryBonus = ____require_result_1.getAntMasteryBonus
local getBossMasteryBonus = ____require_result_1.getBossMasteryBonus
local getSummonDamageModifier = ____require_result_1.getSummonDamageModifier
calcElementalDamageBonus = ____require_result_1.calcElementalDamageBonus
local calcElementalResistReduction = ____require_result_1.calcElementalResistReduction
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.03．吸血吸魔")
local applyLifeAndManaSteal = ____require_result_2.applyLifeAndManaSteal
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local applyDamageModifiers = ____require_result_3.applyDamageModifiers
_____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local appliedFinalDamageListeners = {}
--- 在 `onDamageEvent` 完成 `YDWESetEventDamage`（或免疫置 0）后收到 `(target, attacker, applied)`
function ____exports.registerAppliedFinalDamageListener(cb)
    appliedFinalDamageListeners[#appliedFinalDamageListeners + 1] = cb
end
local function notifyAppliedFinalDamageListeners(target, attacker, applied)
    do
        local i = 0
        while i < #appliedFinalDamageListeners do
            do
                local cb = appliedFinalDamageListeners[i + 1]
                if cb == nil then
                    goto __continue5
                end
                pcall(function () return cb(target, attacker, applied) end
                )
            end
            ::__continue5::
            i = i + 1
        end
    end
end
--- 检查是否免疫伤害
local function checkImmune(target, isNormalAtk)
    if isImmuneDamage(nil, target) and not isDamageReduceDisabled(nil, target) then
        return {immune = true, reason = "免疫伤害", showDodge = false}
    end
    if isNormalAtk and isImmuneNormalAttack(nil, target) then
        return {immune = true, reason = "闪避", showDodge = true}
    end
    return {immune = false, showDodge = false}
end
--- 计算最终伤害
-- 
-- @param target 受击者
-- @param attacker 攻击者
-- @param baseDamage 基础伤害
-- @returns 伤害计算结果
function ____exports.calculateDamage(target, attacker, baseDamage)
    local damage = baseDamage
    local isPlayer = isPlayerUnit(nil, target)
    local isNormalAtk = _____4F24_5BB3_51FD_6570.isNormalAttack()
    local isPhysDmg = _____4F24_5BB3_51FD_6570.isPhysicalDamage()
    local isMagicDmg = _____4F24_5BB3_51FD_6570.isMagicDamage()
    local isEnhanceDmg = _____4F24_5BB3_51FD_6570.isEnhancedDamage()
    local isTrueDmg = _____4F24_5BB3_51FD_6570.isTrueDamage()
    if isTrueDmg then
        return {finalDamage = damage, immune = false, showDodge = false}
    end
    local dmgReduction = getRealAttr(nil, target, "伤害减少", 0)
    damage = damage - dmgReduction
    local dmgIncrease = getRealAttr(nil, attacker, "伤害增加", 0)
    damage = damage + dmgIncrease
    if damage < 0.1 then
        return {finalDamage = 0, immune = false, showDodge = false}
    end
    local immuneCheck = checkImmune(target, isNormalAtk)
    if immuneCheck.immune then
        return {finalDamage = 0, immune = true, immuneReason = immuneCheck.reason, showDodge = immuneCheck.showDodge}
    end
    local addDamage = 0
    local finalMultiplier = 1
    if isPhysDmg then
        damage = applyArmorPenetration(nil, damage, target, attacker)
    end
    if isMagicDmg and not isPhysDmg and not isEnhanceDmg then
        damage = applyMagicResist(nil, damage, target, attacker)
    end
    local dmgReductionPct = getRealAttr(nil, target, "伤害减少%", 0)
    if dmgReductionPct > 0 then
        finalMultiplier = finalMultiplier * (1 - dmgReductionPct)
    end
    local dmgBonus = getRealAttr(nil, attacker, "伤害%", 0)
    if dmgBonus >= 0 then
        addDamage = addDamage + dmgBonus
    else
        finalMultiplier = finalMultiplier * (1 + dmgBonus)
    end
    if isPhysDmg then
        local physMod = getPhysicalDamageModifier(nil, attacker, target, isPlayer)
        addDamage = addDamage + physMod.addDamage
        finalMultiplier = finalMultiplier * physMod.multiplier
        local physReduce = getRealAttr(nil, target, "受到物伤减少", 0)
        damage = damage - physReduce
    end
    if isMagicDmg and not isEnhanceDmg then
        local magicDmg = getMagicDamageModifier(nil, attacker)
        if magicDmg >= 0 then
            addDamage = addDamage + magicDmg
        else
            finalMultiplier = finalMultiplier * (1 + magicDmg)
        end
    end
    if isEnhanceDmg then
        local enhanceDmg = getEnhancedDamageModifier(nil, attacker)
        if enhanceDmg >= 0 then
            addDamage = addDamage + enhanceDmg
        else
            finalMultiplier = finalMultiplier * (1 + enhanceDmg)
        end
    end
    if _____4F24_5BB3_51FD_6570.isSkillAttack() or _____4F24_5BB3_51FD_6570.isSkillDamage() then
        local skillMod = getSkillDamageModifier(nil, attacker, target, isPlayer)
        addDamage = addDamage + skillMod.addDamage
        finalMultiplier = finalMultiplier * skillMod.multiplier
        local spellReduce = getRealAttr(nil, target, "受到技伤减少", 0)
        damage = damage - spellReduce
    end
    if isNormalAtk then
        local atkMod = getNormalAttackModifier(nil, attacker, target, isPlayer)
        addDamage = addDamage + atkMod.addDamage
        finalMultiplier = finalMultiplier * atkMod.multiplier
        local magicAtkDmg = getRealAttr(nil, attacker, "魔法普攻伤害", 0)
        addDamage = addDamage + magicAtkDmg
    end
    local elementalResult = applyElementalDamage(attacker, target, isPlayer)
    addDamage = addDamage + elementalResult.addDamage
    finalMultiplier = finalMultiplier * elementalResult.multiplier
    local summonMod = getSummonDamageModifier(nil, attacker, target, isPlayer)
    addDamage = addDamage + summonMod.addDamage
    finalMultiplier = finalMultiplier * summonMod.multiplier
    local antBonus = getAntMasteryBonus(nil, attacker, target)
    local bossBonus = getBossMasteryBonus(nil, attacker, target)
    if antBonus >= 0 then
        addDamage = addDamage + antBonus
    else
        finalMultiplier = finalMultiplier * (1 + antBonus)
    end
    if bossBonus >= 0 then
        addDamage = addDamage + bossBonus
    else
        finalMultiplier = finalMultiplier * (1 + bossBonus)
    end
    local finalDmgBonus = getFinalDamageBonus(nil, attacker)
    finalMultiplier = finalMultiplier * (1 + finalDmgBonus)
    local finalDamage = damage * (1 + addDamage) * finalMultiplier
    return {finalDamage = finalDamage, immune = false, showDodge = false}
end
--- 处理伤害事件
-- 在伤害回调中调用
function ____exports.onDamageEvent(target, attacker, baseDamage)
    if target == nil or baseDamage < 0.1 then
        return
    end
    local result = ____exports.calculateDamage(target, attacker, baseDamage)
    if result.immune then
        _____4F24_5BB3_51FD_6570.YDWESetEventDamage(0)
        notifyAppliedFinalDamageListeners(target, attacker, 0)
        if result.showDodge then
        end
        return
    end
    local finalDamage = result.finalDamage
    if finalDamage > 0 then
        finalDamage = applyDamageModifiers(
            nil,
            {
                target = target,
                attacker = attacker,
                baseDamage = baseDamage,
                currentDamage = finalDamage,
                isPhysicalDamage = _____4F24_5BB3_51FD_6570.isPhysicalDamage(),
                isMagicDamage = _____4F24_5BB3_51FD_6570.isMagicDamage(),
                isEnhancedDamage = _____4F24_5BB3_51FD_6570.isEnhancedDamage(),
                isTrueDamage = _____4F24_5BB3_51FD_6570.isTrueDamage(),
                isNormalAttack = _____4F24_5BB3_51FD_6570.isNormalAttack(),
                isSkillAttack = _____4F24_5BB3_51FD_6570.isSkillAttack(),
                isSkillDamage = _____4F24_5BB3_51FD_6570.isSkillDamage()
            }
        )
    end
    if finalDamage ~= baseDamage then
        _____4F24_5BB3_51FD_6570.YDWESetEventDamage(finalDamage)
    end
    notifyAppliedFinalDamageListeners(target, attacker, finalDamage)
    local isMagic = _____4F24_5BB3_51FD_6570.isMagicDamage()
    local isNormalAtk = _____4F24_5BB3_51FD_6570.isNormalAttack()
    applyLifeAndManaSteal(
        nil,
        attacker,
        finalDamage,
        isMagic,
        isNormalAtk,
        true
    )
end
return ____exports
