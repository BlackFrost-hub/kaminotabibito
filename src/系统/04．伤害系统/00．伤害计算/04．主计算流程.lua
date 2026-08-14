local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local applyElementalDamage, getRealAttrWithLimit, calcElementalDamageBonus
function applyElementalDamage(attacker, target, isPlayer, snapshot)
    local addDamage = 0
    local multiplier = 1
    if snapshot.isMetalDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "金属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "金属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isWoodDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "木属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "木属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isWaterDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "水属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "水属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isFireDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "火属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "火属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isThunderDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "雷属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "雷属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isLightDamage then
        local dmg = calcElementalDamageBonus(nil, attacker, "光属性伤害")
        local resist = getRealAttrWithLimit(nil, target, "光属性抗性", isPlayer)
        if dmg >= 0 then
            addDamage = addDamage + dmg
        else
            multiplier = multiplier * (1 + dmg)
        end
        multiplier = multiplier * (1 - resist)
    end
    if snapshot.isDarkDamage then
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
local getActiveSkillDamageModifier = ____require_result_1.getActiveSkillDamageModifier
local getEquipmentSkillDamageModifier = ____require_result_1.getEquipmentSkillDamageModifier
local getNormalAttackModifier = ____require_result_1.getNormalAttackModifier
local getMagicDamageModifier = ____require_result_1.getMagicDamageModifier
local getEnhancedDamageModifier = ____require_result_1.getEnhancedDamageModifier
local getFinalDamageBonus = ____require_result_1.getFinalDamageBonus
local getAntMasteryBonus = ____require_result_1.getAntMasteryBonus
local getBossMasteryBonus = ____require_result_1.getBossMasteryBonus
local getBossDmgPctBonus = ____require_result_1.getBossDmgPctBonus
local getBossResistPct = ____require_result_1.getBossResistPct
local getEliteDmgPctBonus = ____require_result_1.getEliteDmgPctBonus
local getEliteResistPct = ____require_result_1.getEliteResistPct
local getDemonDmgPctBonus = ____require_result_1.getDemonDmgPctBonus
local getDemonResistPct = ____require_result_1.getDemonResistPct
local getSummonDamageModifier = ____require_result_1.getSummonDamageModifier
calcElementalDamageBonus = ____require_result_1.calcElementalDamageBonus
local calcElementalResistReduction = ____require_result_1.calcElementalResistReduction
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.03．吸血吸魔")
local applyLifeAndManaSteal = ____require_result_2.applyLifeAndManaSteal
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local applyDamageModifiers = ____require_result_3.applyDamageModifiers
local applyDamageBaseModifiers = ____require_result_3.applyDamageBaseModifiers
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.07．伤害类型转换")
local applyDamageTypeConversions = ____require_result_4.applyDamageTypeConversions
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____83B7_53D6_5F53_524D_6280_80FD_4F24_5BB3_4E0A_4E0B_6587 = ____require_result_5["获取当前技能伤害上下文"]
local ____require_result_6 = require("系统.04．伤害系统.04．伤害映射")
local _____83B7_53D6_4F24_5BB3_5F52_5C5E_5355_4F4D = ____require_result_6["获取伤害归属单位"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_7.createDelayedCall
local ConvertDamageType = jass.ConvertDamageType
local ConvertAttackType = jass.ConvertAttackType
local ConvertWeaponType = jass.ConvertWeaponType
local UnitDamageTarget = jass.UnitDamageTarget
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local appliedFinalDamageListeners = {}
local appliedFinalDamagePostListeners = {}
____exports["延后一帧执行伤害派生效果"] = function(callback)
    createDelayedCall(0, callback)
end
--- 在 `onDamageEvent` 完成 `YDWESetEventDamage`（或免疫置 0）后收到 `(target, attacker, applied)`
function ____exports.registerAppliedFinalDamageListener(cb)
    do
        local i = 0
        while i < #appliedFinalDamageListeners do
            if appliedFinalDamageListeners[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    appliedFinalDamageListeners[#appliedFinalDamageListeners + 1] = cb
end
--- 在普通最终伤害监听全部完成后派发；此时引擎尚未实际扣除本次生命。
function ____exports.registerAppliedFinalDamagePostListener(cb)
    do
        local i = 0
        while i < #appliedFinalDamagePostListeners do
            if appliedFinalDamagePostListeners[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    appliedFinalDamagePostListeners[#appliedFinalDamagePostListeners + 1] = cb
end
local function notifyAppliedFinalDamageListeners(target, attacker, applied, snapshot)
    do
        local i = 0
        while i < #appliedFinalDamageListeners do
            do
                local cb = appliedFinalDamageListeners[i + 1]
                if cb == nil then
                    goto __continue13
                end
                cb(target, attacker, applied, snapshot)
            end
            ::__continue13::
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #appliedFinalDamagePostListeners do
            do
                local cb = appliedFinalDamagePostListeners[i + 1]
                if cb == nil then
                    goto __continue16
                end
                cb(target, attacker, applied, snapshot)
            end
            ::__continue16::
            i = i + 1
        end
    end
end
local function captureDamageTypeSnapshot()
    local skillContext = _____83B7_53D6_5F53_524D_6280_80FD_4F24_5BB3_4E0A_4E0B_6587()
    local rawAttackType = ConvertAttackType(_____4F24_5BB3_51FD_6570.EXGetEventDamageData(_____4F24_5BB3_51FD_6570.EVENT_DAMAGE_DATA_ATTACK_TYPE))
    local rawDamageType = ConvertDamageType(_____4F24_5BB3_51FD_6570.EXGetEventDamageData(_____4F24_5BB3_51FD_6570.EVENT_DAMAGE_DATA_DAMAGE_TYPE))
    local rawWeaponType = ConvertWeaponType(_____4F24_5BB3_51FD_6570.EXGetEventDamageData(_____4F24_5BB3_51FD_6570.EVENT_DAMAGE_DATA_WEAPON_TYPE))
    return {
        rawAttackType = rawAttackType,
        rawDamageType = rawDamageType,
        rawWeaponType = rawWeaponType,
        effectiveAttackType = rawAttackType,
        effectiveDamageType = rawDamageType,
        effectiveWeaponType = rawWeaponType,
        isPhysicalDamage = _____4F24_5BB3_51FD_6570.isPhysicalDamage(),
        isMagicDamage = _____4F24_5BB3_51FD_6570.isMagicDamage(),
        isEnhancedDamage = _____4F24_5BB3_51FD_6570.isEnhancedDamage(),
        isTrueDamage = _____4F24_5BB3_51FD_6570.isTrueDamage(),
        isNormalAttack = _____4F24_5BB3_51FD_6570.isNormalAttack(),
        isRangedAttack = _____4F24_5BB3_51FD_6570.EXGetEventDamageData(_____4F24_5BB3_51FD_6570.EVENT_DAMAGE_DATA_IS_RANGED) == 1,
        isSkillAttack = _____4F24_5BB3_51FD_6570.isSkillAttack(),
        isSkillDamage = _____4F24_5BB3_51FD_6570.isSkillDamage(),
        isWrappedSkillDamage = (skillContext and skillContext.isWrappedSkillDamage) == true,
        isEquipmentSkillDamage = (skillContext and skillContext.isEquipmentSkillDamage) == true,
        isNonEquipmentSkillDamage = (skillContext and skillContext.isNonEquipmentSkillDamage) == true,
        skillDamageSourceKind = skillContext and skillContext.sourceKind,
        equipmentSkillDamageKind = skillContext and skillContext.equipmentSkillKind,
        itemTypeId = skillContext and skillContext.itemTypeId,
        itemHandle = skillContext and skillContext.itemHandle,
        abilityId = skillContext and skillContext.abilityId,
        skillInstanceId = skillContext and skillContext.skillInstanceId,
        skillDamageTag = skillContext and skillContext.tag,
        skillDamageShape = skillContext and skillContext.damageShape or "未知",
        isIndependentSkillDamage = (skillContext and skillContext.isIndependentSkillDamage) == true,
        isSingleTargetSkillDamage = (skillContext and skillContext.isSingleTargetSkillDamage) == true,
        isAoeSkillDamage = (skillContext and skillContext.isAoeSkillDamage) == true,
        isDamageTransfer = (skillContext and skillContext.isDamageTransfer) == true,
        isMetalDamage = _____4F24_5BB3_51FD_6570.isMetalDamage(),
        isWoodDamage = _____4F24_5BB3_51FD_6570.isWoodDamage(),
        isWaterDamage = _____4F24_5BB3_51FD_6570.isWaterDamage(),
        isFireDamage = _____4F24_5BB3_51FD_6570.isFireDamage(),
        isThunderDamage = _____4F24_5BB3_51FD_6570.isThunderDamage(),
        isLightDamage = _____4F24_5BB3_51FD_6570.isLightDamage(),
        isDarkDamage = _____4F24_5BB3_51FD_6570.isDarkDamage()
    }
end
local function _____91CD_65B0_63D0_4EA4_8F6C_6362_4F24_5BB3(source, target, amount, request, defaultAttack, defaultRanged, defaultAttackType, defaultWeaponType)
    if source == nil or source == 0 or target == nil or target == 0 or request == nil or request.damageType == nil or not (amount > 0) then
        return
    end
    local ____array_42 = __TS__SparseArrayNew(source, target, amount)
    local ____temp_38
    if request.attack ~= nil then
        ____temp_38 = request.attack
    else
        ____temp_38 = defaultAttack
    end
    __TS__SparseArrayPush(____array_42, ____temp_38)
    local ____temp_39
    if request.ranged ~= nil then
        ____temp_39 = request.ranged
    else
        ____temp_39 = defaultRanged
    end
    __TS__SparseArrayPush(____array_42, ____temp_39)
    local ____temp_40
    if request.attackType ~= nil then
        ____temp_40 = request.attackType
    else
        ____temp_40 = defaultAttackType
    end
    __TS__SparseArrayPush(____array_42, ____temp_40, request.damageType)
    local ____temp_41
    if request.weaponType ~= nil then
        ____temp_41 = request.weaponType
    else
        ____temp_41 = defaultWeaponType
    end
    __TS__SparseArrayPush(____array_42, ____temp_41)
    UnitDamageTarget(__TS__SparseArraySpread(____array_42))
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
function ____exports.calculateDamage(target, attacker, baseDamage, originalAttacker, damageSnapshot)
    local damage = baseDamage
    local ____temp_43
    if originalAttacker ~= nil and originalAttacker ~= 0 then
        ____temp_43 = originalAttacker
    else
        ____temp_43 = attacker
    end
    local rawAttacker = ____temp_43
    local snapshot = damageSnapshot or captureDamageTypeSnapshot()
    local isPlayer = isPlayerUnit(nil, target)
    local isNormalAtk = snapshot.isNormalAttack
    local isPhysDmg = snapshot.isPhysicalDamage
    local isMagicDmg = snapshot.isMagicDamage
    local isEnhanceDmg = snapshot.isEnhancedDamage
    local isTrueDmg = snapshot.isTrueDamage
    local skillContext = _____83B7_53D6_5F53_524D_6280_80FD_4F24_5BB3_4E0A_4E0B_6587()
    local isWrappedSkillDmg = snapshot.isWrappedSkillDamage == true and (skillContext and skillContext.participatesInSkillDamageBonus) ~= false
    local isAnySkillDmg = snapshot.isSkillAttack or snapshot.isSkillDamage or isWrappedSkillDmg
    if isTrueDmg then
        return {finalDamage = damage, immune = false, showDodge = false, calculatedBaseDamage = damage}
    end
    local immuneCheck = checkImmune(target, isNormalAtk)
    if immuneCheck.immune then
        return {
            finalDamage = 0,
            immune = true,
            immuneReason = immuneCheck.reason,
            showDodge = immuneCheck.showDodge,
            calculatedBaseDamage = baseDamage
        }
    end
    local baseContext = {
        target = target,
        attacker = attacker,
        originalAttacker = rawAttacker,
        baseDamage = baseDamage,
        currentDamage = damage,
        rawAttackType = snapshot.rawAttackType,
        rawDamageType = snapshot.rawDamageType,
        rawWeaponType = snapshot.rawWeaponType,
        effectiveAttackType = snapshot.effectiveAttackType,
        effectiveDamageType = snapshot.effectiveDamageType,
        effectiveWeaponType = snapshot.effectiveWeaponType,
        isPhysicalDamage = snapshot.isPhysicalDamage,
        isMagicDamage = snapshot.isMagicDamage,
        isEnhancedDamage = snapshot.isEnhancedDamage,
        isTrueDamage = snapshot.isTrueDamage,
        isMetalDamage = snapshot.isMetalDamage,
        isWoodDamage = snapshot.isWoodDamage,
        isWaterDamage = snapshot.isWaterDamage,
        isFireDamage = snapshot.isFireDamage,
        isThunderDamage = snapshot.isThunderDamage,
        isLightDamage = snapshot.isLightDamage,
        isDarkDamage = snapshot.isDarkDamage,
        isNormalAttack = snapshot.isNormalAttack,
        isRangedAttack = snapshot.isRangedAttack,
        isSkillAttack = snapshot.isSkillAttack,
        isSkillDamage = snapshot.isSkillDamage,
        isWrappedSkillDamage = snapshot.isWrappedSkillDamage,
        isEquipmentSkillDamage = snapshot.isEquipmentSkillDamage,
        isNonEquipmentSkillDamage = snapshot.isNonEquipmentSkillDamage,
        skillDamageSourceKind = snapshot.skillDamageSourceKind,
        equipmentSkillDamageKind = snapshot.equipmentSkillDamageKind,
        itemTypeId = snapshot.itemTypeId,
        itemHandle = snapshot.itemHandle,
        abilityId = snapshot.abilityId,
        skillInstanceId = snapshot.skillInstanceId,
        skillDamageTag = snapshot.skillDamageTag,
        skillDamageShape = snapshot.skillDamageShape,
        isIndependentSkillDamage = snapshot.isIndependentSkillDamage,
        isSingleTargetSkillDamage = snapshot.isSingleTargetSkillDamage,
        isAoeSkillDamage = snapshot.isAoeSkillDamage,
        isDamageTransfer = snapshot.isDamageTransfer
    }
    damage = applyDamageBaseModifiers(baseContext)
    baseContext.currentDamage = damage
    if damage < 0.1 then
        return {finalDamage = 0, immune = false, showDodge = false, calculatedBaseDamage = damage}
    end
    local dmgReduction = getRealAttr(nil, target, "伤害减少", 0)
    if isPhysDmg then
        dmgReduction = dmgReduction + getRealAttr(nil, target, "物理固伤减少", 0)
    end
    if isMagicDmg then
        dmgReduction = dmgReduction + getRealAttr(nil, target, "魔法固伤减少", 0)
    end
    if isAnySkillDmg then
        dmgReduction = dmgReduction + getRealAttr(nil, target, "技能固伤减少", 0)
    end
    damage = damage - dmgReduction
    local dmgIncrease = getRealAttr(nil, attacker, "伤害增加", 0)
    damage = damage + dmgIncrease
    if damage < 0.1 then
        return {finalDamage = 0, immune = false, showDodge = false, calculatedBaseDamage = baseContext.currentDamage}
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
    if isAnySkillDmg then
        local skillMod = getSkillDamageModifier(nil, attacker, target, isPlayer)
        addDamage = addDamage + skillMod.addDamage
        finalMultiplier = finalMultiplier * skillMod.multiplier
    end
    if (skillContext and skillContext.isIndependentSkillDamage) == true then
        local activeSkillMod = getActiveSkillDamageModifier(nil, attacker)
        addDamage = addDamage + activeSkillMod.addDamage
        finalMultiplier = finalMultiplier * activeSkillMod.multiplier
    end
    if (skillContext and skillContext.isEquipmentSkillDamage) == true then
        local equipmentSkillMod = getEquipmentSkillDamageModifier(nil, attacker, skillContext.equipmentSkillKind)
        addDamage = addDamage + equipmentSkillMod.addDamage
        finalMultiplier = finalMultiplier * equipmentSkillMod.multiplier
    end
    if isNormalAtk then
        local atkMod = getNormalAttackModifier(nil, attacker, target, isPlayer)
        addDamage = addDamage + atkMod.addDamage
        finalMultiplier = finalMultiplier * atkMod.multiplier
        local magicAtkDmg = getRealAttr(nil, attacker, "魔法普攻伤害", 0)
        addDamage = addDamage + magicAtkDmg
    end
    local elementalResult = applyElementalDamage(attacker, target, isPlayer, snapshot)
    addDamage = addDamage + elementalResult.addDamage
    finalMultiplier = finalMultiplier * elementalResult.multiplier
    local summonMod = getSummonDamageModifier(
        nil,
        rawAttacker,
        target,
        isPlayer,
        attacker
    )
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
    local bossDmgPct = getBossDmgPctBonus(nil, attacker, target)
    if bossDmgPct >= 0 then
        addDamage = addDamage + bossDmgPct
    else
        finalMultiplier = finalMultiplier * (1 + bossDmgPct)
    end
    local eliteDmgPct = getEliteDmgPctBonus(nil, attacker, target)
    if eliteDmgPct >= 0 then
        addDamage = addDamage + eliteDmgPct
    else
        finalMultiplier = finalMultiplier * (1 + eliteDmgPct)
    end
    local demonDmgPct = getDemonDmgPctBonus(nil, attacker, target)
    if demonDmgPct >= 0 then
        addDamage = addDamage + demonDmgPct
    else
        finalMultiplier = finalMultiplier * (1 + demonDmgPct)
    end
    local bossResist = getBossResistPct(nil, target, attacker)
    finalMultiplier = finalMultiplier * (1 - bossResist)
    local eliteResist = getEliteResistPct(nil, target, attacker)
    finalMultiplier = finalMultiplier * (1 - eliteResist)
    local demonResist = getDemonResistPct(nil, target, attacker)
    finalMultiplier = finalMultiplier * (1 - demonResist)
    local finalDmgBonus = getFinalDamageBonus(nil, attacker)
    finalMultiplier = finalMultiplier * (1 + finalDmgBonus)
    local finalDamage = damage * (1 + addDamage) * finalMultiplier
    return {finalDamage = finalDamage, immune = false, showDodge = false, calculatedBaseDamage = baseContext.currentDamage}
end
--- 处理伤害事件
-- 在伤害回调中调用
function ____exports.onDamageEvent(target, attacker, baseDamage)
    if target == nil or baseDamage < 0.1 then
        return
    end
    local snapshot = captureDamageTypeSnapshot()
    local originalAttacker = attacker
    local mappedAttacker = _____83B7_53D6_4F24_5BB3_5F52_5C5E_5355_4F4D(attacker, target)
    snapshot.originalAttacker = originalAttacker
    snapshot.mappedAttacker = mappedAttacker
    attacker = mappedAttacker
    local conversionContext = __TS__ObjectAssign({target = target, attacker = attacker, originalAttacker = originalAttacker, baseDamage = baseDamage}, snapshot)
    applyDamageTypeConversions(conversionContext)
    if conversionContext.reapplyDamage ~= nil then
        _____4F24_5BB3_51FD_6570.YDWESetEventDamage(0)
        local ____91CD_65B0_63D0_4EA4_8F6C_6362_4F24_5BB3_51 = _____91CD_65B0_63D0_4EA4_8F6C_6362_4F24_5BB3
        local ____temp_50
        if originalAttacker ~= nil and originalAttacker ~= 0 then
            ____temp_50 = originalAttacker
        else
            ____temp_50 = attacker
        end
        ____91CD_65B0_63D0_4EA4_8F6C_6362_4F24_5BB3_51(
            ____temp_50,
            target,
            baseDamage,
            conversionContext.reapplyDamage,
            snapshot.isNormalAttack,
            snapshot.isRangedAttack,
            snapshot.rawAttackType,
            snapshot.rawWeaponType
        )
        return
    end
    snapshot.effectiveAttackType = conversionContext.effectiveAttackType
    snapshot.effectiveDamageType = conversionContext.effectiveDamageType
    snapshot.effectiveWeaponType = conversionContext.effectiveWeaponType
    snapshot.isPhysicalDamage = conversionContext.isPhysicalDamage
    snapshot.isMagicDamage = conversionContext.isMagicDamage
    snapshot.isEnhancedDamage = conversionContext.isEnhancedDamage
    snapshot.isTrueDamage = conversionContext.isTrueDamage
    snapshot.isNormalAttack = conversionContext.isNormalAttack
    snapshot.isRangedAttack = conversionContext.isRangedAttack
    snapshot.isSkillAttack = conversionContext.isSkillAttack
    snapshot.isSkillDamage = conversionContext.isSkillDamage
    snapshot.isWrappedSkillDamage = conversionContext.isWrappedSkillDamage
    snapshot.isEquipmentSkillDamage = conversionContext.isEquipmentSkillDamage
    snapshot.isNonEquipmentSkillDamage = conversionContext.isNonEquipmentSkillDamage
    snapshot.isIndependentSkillDamage = conversionContext.isIndependentSkillDamage
    snapshot.isSingleTargetSkillDamage = conversionContext.isSingleTargetSkillDamage
    snapshot.isAoeSkillDamage = conversionContext.isAoeSkillDamage
    snapshot.isDamageTransfer = conversionContext.isDamageTransfer
    snapshot.isMetalDamage = conversionContext.isMetalDamage
    snapshot.isWoodDamage = conversionContext.isWoodDamage
    snapshot.isWaterDamage = conversionContext.isWaterDamage
    snapshot.isFireDamage = conversionContext.isFireDamage
    snapshot.isThunderDamage = conversionContext.isThunderDamage
    snapshot.isLightDamage = conversionContext.isLightDamage
    snapshot.isDarkDamage = conversionContext.isDarkDamage
    local result = ____exports.calculateDamage(
        target,
        attacker,
        baseDamage,
        originalAttacker,
        snapshot
    )
    if result.immune then
        _____4F24_5BB3_51FD_6570.YDWESetEventDamage(0)
        notifyAppliedFinalDamageListeners(target, attacker, 0, snapshot)
        if result.showDodge then
        end
        return
    end
    local finalDamage = result.finalDamage
    if finalDamage > 0 then
        finalDamage = applyDamageModifiers({
            target = target,
            attacker = attacker,
            originalAttacker = originalAttacker,
            baseDamage = result.calculatedBaseDamage,
            currentDamage = finalDamage,
            rawAttackType = snapshot.rawAttackType,
            rawWeaponType = snapshot.rawWeaponType,
            effectiveAttackType = snapshot.effectiveAttackType,
            effectiveDamageType = snapshot.effectiveDamageType,
            effectiveWeaponType = snapshot.effectiveWeaponType,
            isPhysicalDamage = snapshot.isPhysicalDamage,
            isMagicDamage = snapshot.isMagicDamage,
            isEnhancedDamage = snapshot.isEnhancedDamage,
            isTrueDamage = snapshot.isTrueDamage,
            isMetalDamage = snapshot.isMetalDamage,
            isWoodDamage = snapshot.isWoodDamage,
            isWaterDamage = snapshot.isWaterDamage,
            isFireDamage = snapshot.isFireDamage,
            isThunderDamage = snapshot.isThunderDamage,
            isLightDamage = snapshot.isLightDamage,
            isDarkDamage = snapshot.isDarkDamage,
            rawDamageType = snapshot.rawDamageType,
            isNormalAttack = snapshot.isNormalAttack,
            isRangedAttack = snapshot.isRangedAttack,
            isSkillAttack = snapshot.isSkillAttack,
            isSkillDamage = snapshot.isSkillDamage,
            isWrappedSkillDamage = snapshot.isWrappedSkillDamage,
            isEquipmentSkillDamage = snapshot.isEquipmentSkillDamage,
            isNonEquipmentSkillDamage = snapshot.isNonEquipmentSkillDamage,
            skillDamageSourceKind = snapshot.skillDamageSourceKind,
            equipmentSkillDamageKind = snapshot.equipmentSkillDamageKind,
            itemTypeId = snapshot.itemTypeId,
            itemHandle = snapshot.itemHandle,
            abilityId = snapshot.abilityId,
            skillInstanceId = snapshot.skillInstanceId,
            skillDamageTag = snapshot.skillDamageTag,
            skillDamageShape = snapshot.skillDamageShape,
            isIndependentSkillDamage = snapshot.isIndependentSkillDamage,
            isSingleTargetSkillDamage = snapshot.isSingleTargetSkillDamage,
            isAoeSkillDamage = snapshot.isAoeSkillDamage,
            isDamageTransfer = snapshot.isDamageTransfer
        })
    end
    if finalDamage ~= baseDamage then
        _____4F24_5BB3_51FD_6570.YDWESetEventDamage(finalDamage)
    end
    notifyAppliedFinalDamageListeners(target, attacker, finalDamage, snapshot)
    applyLifeAndManaSteal(
        nil,
        attacker,
        finalDamage,
        snapshot.isMagicDamage,
        snapshot.isNormalAttack,
        true
    )
end
return ____exports
