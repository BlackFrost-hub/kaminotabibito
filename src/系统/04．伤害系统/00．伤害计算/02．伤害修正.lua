--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害修正计算模块
-- 
-- 功能：护甲穿透、魔抗、属性伤害/抗性等修正计算
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local getRealAttr = ____require_result_0.getRealAttr
local getRealAttrWithLimit = ____require_result_0.getRealAttrWithLimit
local getAttackerArmorPierce = ____require_result_0.getAttackerArmorPierce
local getAttackerMagicPierce = ____require_result_0.getAttackerMagicPierce
local getTargetArmor = ____require_result_0.getTargetArmor
local isIgnoreArmor = ____require_result_0.isIgnoreArmor
local isIgnoreMagicResist = ____require_result_0.isIgnoreMagicResist
local isPlayerUnit = ____require_result_0.isPlayerUnit
local ____require_result_1 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local calcArmorReduction = ____require_result_1.calcArmorReduction
local calcPiercedArmorReduction = ____require_result_1.calcPiercedArmorReduction
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local OperatorRealMultiply = ____require_result_2.OperatorRealMultiply
local OperatorResistReduction = ____require_result_2.OperatorResistReduction
local createValueHolder = ____require_result_2.createValueHolder
--- 应用护甲穿透修正伤害
-- 
-- @param damage 原始伤害
-- @param target 受击者
-- @param attacker 攻击者
function ____exports.applyArmorPenetration(self, damage, target, attacker)
    local originalArmor = getTargetArmor(nil, target)
    if originalArmor <= 0 then
        return damage
    end
    local armorPierce = getAttackerArmorPierce(nil, attacker)
    local ignoreArmor = isIgnoreArmor(nil, attacker)
    local originalReduction = calcArmorReduction(originalArmor)
    local piercedReduction = calcPiercedArmorReduction(originalArmor, armorPierce, ignoreArmor)
    local baseDamage = damage / (1 - originalReduction)
    return baseDamage * (1 - piercedReduction)
end
--- 应用魔抗修正伤害
-- 
-- @param damage 原始伤害
-- @param target 受击者
-- @param attacker 攻击者
function ____exports.applyMagicResist(self, damage, target, attacker)
    local isPlayer = isPlayerUnit(nil, target)
    local magicResist = getRealAttrWithLimit(nil, target, "魔抗", isPlayer)
    if magicResist < 0 then
        return damage * (1 - magicResist)
    end
    local ignoreMagicResist = isIgnoreMagicResist(nil, attacker)
    if ignoreMagicResist then
        return damage
    end
    local magicPierce = getAttackerMagicPierce(nil, attacker)
    if magicPierce > 0 then
        magicResist = magicResist * (1 - magicPierce)
    end
    return damage * (1 - magicResist)
end
--- 属性伤害类型配置
local ELEMENTAL_DAMAGE_CONFIG = {
    {damageAttr = "金属性伤害", resistAttr = "金属性抗性", checkFunc = "isMetalDamage"},
    {damageAttr = "木属性伤害", resistAttr = "木属性抗性", checkFunc = "isWoodDamage"},
    {damageAttr = "水属性伤害", resistAttr = "水属性抗性", checkFunc = "isWaterDamage"},
    {damageAttr = "火属性伤害", resistAttr = "火属性抗性", checkFunc = "isFireDamage"},
    {damageAttr = "雷属性伤害", resistAttr = "雷属性抗性", checkFunc = "isThunderDamage"},
    {damageAttr = "光属性伤害", resistAttr = "光属性抗性", checkFunc = "isLightDamage"},
    {damageAttr = "暗属性伤害", resistAttr = "暗属性抗性", checkFunc = "isDarkDamage"}
}
--- 计算属性伤害加成
-- 
-- @param attacker 攻击者
-- @param damageAttr 伤害属性名
-- @returns 加法叠加的伤害加成
function ____exports.calcElementalDamageBonus(self, attacker, damageAttr)
    return getRealAttr(nil, attacker, damageAttr, 0)
end
--- 计算属性抗性减伤
-- 
-- @param target 受击者
-- @param resistAttr 抗性属性名
-- @param isPlayer 是否为玩家
-- @returns 乘法叠加的减伤比例
function ____exports.calcElementalResistReduction(self, target, resistAttr, isPlayer)
    local resist = getRealAttrWithLimit(nil, target, resistAttr, isPlayer)
    return 1 - resist
end
--- 获取物理伤害修正
function ____exports.getPhysicalDamageModifier(self, attacker, target, isPlayer)
    local physDmg = getRealAttr(nil, attacker, "物理伤害", 0)
    local physResist = getRealAttrWithLimit(nil, target, "物理抗性", isPlayer)
    local addDamage = createValueHolder(0)
    local multiplier = createValueHolder(1 - physResist)
    OperatorRealMultiply(physDmg, addDamage, multiplier)
    return {addDamage = addDamage.value, multiplier = multiplier.value}
end
--- 获取技能伤害修正
function ____exports.getSkillDamageModifier(self, attacker, target, isPlayer)
    local skillDmg = getRealAttr(nil, attacker, "技能伤害", 0)
    local skillResist = getRealAttr(nil, target, "技能抗性", 0)
    local addDamage = createValueHolder(0)
    local multiplier = createValueHolder(1 - skillResist)
    OperatorRealMultiply(skillDmg, addDamage, multiplier)
    return {addDamage = addDamage.value, multiplier = multiplier.value}
end
--- 获取普攻伤害修正
function ____exports.getNormalAttackModifier(self, attacker, target, isPlayer)
    local atkDmg = getRealAttr(nil, attacker, "普攻伤害", 0)
    local atkResist = getRealAttr(nil, target, "普攻抗性", 0)
    local addDamage = createValueHolder(0)
    local multiplier = createValueHolder(1 - atkResist)
    OperatorRealMultiply(atkDmg, addDamage, multiplier)
    return {addDamage = addDamage.value, multiplier = multiplier.value}
end
--- 获取魔法伤害修正
function ____exports.getMagicDamageModifier(self, attacker)
    local magicDmg = getRealAttr(nil, attacker, "魔法伤害", 0)
    return magicDmg
end
--- 获取强化伤害修正
function ____exports.getEnhancedDamageModifier(self, attacker)
    local enhanceDmg = getRealAttr(nil, attacker, "强化伤害", 0)
    return enhanceDmg
end
--- 获取最终伤害加成
function ____exports.getFinalDamageBonus(self, attacker)
    return getRealAttr(nil, attacker, "最终伤害%", 0)
end
--- 获取蝼蚁专精加成
-- 条件：目标非英雄且非恶魔种族
function ____exports.getAntMasteryBonus(self, attacker, target)
    local isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(target) == jass.RACE_DEMON
    if isHero or isDemon then
        return 0
    end
    return getRealAttr(nil, attacker, "蝼蚁专精", 0)
end
--- 获取Boss专精加成
-- 条件：目标是英雄或恶魔种族
function ____exports.getBossMasteryBonus(self, attacker, target)
    local isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(target) == jass.RACE_DEMON
    if not isHero and not isDemon then
        return 0
    end
    return getRealAttr(nil, attacker, "Boss专精", 0)
end
--- 获取对Boss伤害%加成（攻击者属性）
-- 目标为英雄或恶魔时生效
function ____exports.getBossDmgPctBonus(self, attacker, target)
    if attacker == nil or target == nil then
        return 0
    end
    local isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(target) == jass.RACE_DEMON
    if not isHero and not isDemon then
        return 0
    end
    return getRealAttr(nil, attacker, "提高对Boss伤害%", 0)
end
--- 获取受到Boss伤害减少%（目标属性）
-- 攻击者为英雄或恶魔时生效
function ____exports.getBossResistPct(self, target, attacker)
    if target == nil or attacker == nil then
        return 0
    end
    local isHero = jass.IsUnitType(attacker, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(attacker) == jass.RACE_DEMON
    if not isHero and not isDemon then
        return 0
    end
    return getRealAttr(nil, target, "受到Boss伤害减少%", 0)
end
--- 获取对精英伤害%加成（攻击者属性）
-- 目标为精英（恶魔或英雄）时生效
function ____exports.getEliteDmgPctBonus(self, attacker, target)
    if attacker == nil or target == nil then
        return 0
    end
    local isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(target) == jass.RACE_DEMON
    if not isHero and not isDemon then
        return 0
    end
    return getRealAttr(nil, attacker, "提高对精英伤害%", 0)
end
--- 获取受到精英伤害减少%（目标属性）
-- 攻击者为精英（恶魔或英雄）时生效
function ____exports.getEliteResistPct(self, target, attacker)
    if target == nil or attacker == nil then
        return 0
    end
    local isHero = jass.IsUnitType(attacker, jass.UNIT_TYPE_HERO)
    local isDemon = jass.GetUnitRace(attacker) == jass.RACE_DEMON
    if not isHero and not isDemon then
        return 0
    end
    return getRealAttr(nil, target, "受到精英伤害减少%", 0)
end
--- 获取对恶魔族伤害%加成（攻击者属性）
-- 目标为恶魔种族时生效
function ____exports.getDemonDmgPctBonus(self, attacker, target)
    if attacker == nil or target == nil then
        return 0
    end
    if jass.GetUnitRace(target) ~= jass.RACE_DEMON then
        return 0
    end
    return getRealAttr(nil, attacker, "提高对恶魔族伤害%", 0)
end
--- ��取受到恶魔族伤害减少%（目标属性）
-- 攻击者为恶魔种族时生效
function ____exports.getDemonResistPct(self, target, attacker)
    if target == nil or attacker == nil then
        return 0
    end
    if jass.GetUnitRace(attacker) ~= jass.RACE_DEMON then
        return 0
    end
    return getRealAttr(nil, target, "受到恶魔族伤害减少%", 0)
end
--- 检查单位是否为召唤物
function ____exports.isSummonedUnit(self, unit)
    return jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED)
end
--- 获取召唤物伤害修正
function ____exports.getSummonDamageModifier(self, attacker, target, isPlayer)
    if not ____exports.isSummonedUnit(nil, attacker) then
        return {addDamage = 0, multiplier = 1}
    end
    local summonDmg = getRealAttr(nil, attacker, "召唤物伤害", 0)
    local summonResist = getRealAttr(nil, target, "召唤物抗性", 0)
    local addDamage = createValueHolder(0)
    local multiplier = createValueHolder(1 - summonResist)
    OperatorRealMultiply(summonDmg, addDamage, multiplier)
    return {addDamage = addDamage.value, multiplier = multiplier.value}
end
return ____exports
