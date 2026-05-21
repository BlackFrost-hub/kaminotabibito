/** @noSelfInFile */
/**
 * 技能冷却系统 - 统一导出和初始化入口
 */
export * from "./00．冷却常量";
export * from "./01．冷却缩减计算";
export * from "./02．特殊技能处理";
export * from "./03．QWERD冷却显示";
const jass = require("jass.common");
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心");
const { isBlacklistedSkill: 检查冷却黑名单, isExcludedUnit: 检查排除单位, getCooldownReduction: 读取冷却缩减, getCooldownReductionBonus: 读取冷却缩减加成, applyCooldownCap: 应用冷却上限, calcActualCooldown: 计算实际冷却, setAbilityCooldown: 设置技能冷却, getBaseCooldown: 读取基础冷却, } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算");
const { handleSpecialSkillCooldown: 处理特殊技能冷却, } = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理");
const { INDEPENDENT_COOLDOWN_SKILLS } = require("系统.03．技能系统.01．技能冷却.00．冷却常量");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { 初始化QWERD冷却显示, } = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示");
function isBlacklistedSkill(abilityId) {
    return 检查冷却黑名单(abilityId);
}
function isExcludedUnit(unit) {
    return 检查排除单位(unit);
}
function getCooldownReduction(unit) {
    return 读取冷却缩减(unit);
}
function getCooldownReductionBonus(unit) {
    return 读取冷却缩减加成(unit);
}
function applyCooldownCap(reduction, abilityId, bonus) {
    return 应用冷却上限(reduction, abilityId, bonus);
}
function calcActualCooldown(baseCooldown, reduction) {
    return 计算实际冷却(baseCooldown, reduction);
}
function setAbilityCooldown(unit, abilityId, level, cooldown) {
    设置技能冷却(unit, abilityId, level, cooldown);
}
function getBaseCooldown(abilityId, level) {
    return 读取基础冷却(abilityId, level);
}
function handleSpecialSkillCooldown(unit, abilityId, reduction) {
    return 处理特殊技能冷却(unit, abilityId, reduction);
}
function 提取内部ID(配置键名) {
    if (!配置键名)
        return "";
    const 片段列表 = 配置键名.split("|");
    return 片段列表[片段列表.length - 1] ?? "";
}
function onSpellEffectForCooldown(castingUnit, spellAbilityId) {
    if (isBlacklistedSkill(spellAbilityId))
        return;
    if (isExcludedUnit(castingUnit))
        return;
    for (const 配置键名 of INDEPENDENT_COOLDOWN_SKILLS) {
        if (stringToFourCC(提取内部ID(配置键名)) === spellAbilityId)
            return;
    }
    const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
    if (level <= 0)
        return;
    const baseCooldown = getBaseCooldown(spellAbilityId, level);
    if (baseCooldown <= 0)
        return;
    const reduction = getCooldownReduction(castingUnit);
    if (reduction < 0.01)
        return;
    const bonus = getCooldownReductionBonus(castingUnit);
    const cappedReduction = applyCooldownCap(reduction, spellAbilityId, bonus);
    const actualCooldown = calcActualCooldown(baseCooldown, cappedReduction);
    if (handleSpecialSkillCooldown(castingUnit, spellAbilityId, cappedReduction))
        return;
    setAbilityCooldown(castingUnit, spellAbilityId, level, actualCooldown);
}
registerSpellEffectListener(onSpellEffectForCooldown);
初始化QWERD冷却显示();
