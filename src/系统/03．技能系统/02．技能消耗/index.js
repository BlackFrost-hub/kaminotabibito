/** @noSelfInFile */
/**
 * 技能消耗系统 - 统一导出和初始化入口
 */
export * from "./00．消耗常量";
export * from "./01．魔法消耗返还";
export * from "./02．特殊单位消耗";
export * from "./03．QWERD魔法消耗显示";
const jass = require("jass.common");
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心");
const 魔法消耗返还模块 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还");
const 特殊单位消耗模块 = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗");
function handleManaRefund(unit, abilityId) {
    return 魔法消耗返还模块["handleManaRefund"](unit, abilityId);
}
function calcTotalManaCost(unit, abilityId, level) {
    return 魔法消耗返还模块["calcTotalManaCost"](unit, abilityId, level);
}
function isEdwardUnit(unit) {
    return 特殊单位消耗模块["isEdwardUnit"](unit);
}
function handleEdwardPassiveCost(unit, manaCost) {
    特殊单位消耗模块["handleEdwardPassiveCost"](unit, manaCost);
}
function onSpellEffectForCost(castingUnit, spellAbilityId) {
    handleManaRefund(castingUnit, spellAbilityId);
    if (isEdwardUnit(castingUnit)) {
        const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
        const manaCost = calcTotalManaCost(castingUnit, spellAbilityId, level);
        if (manaCost > 0) {
            handleEdwardPassiveCost(castingUnit, manaCost);
        }
    }
}
registerSpellEffectListener(onSpellEffectForCost);
require("系统.03．技能系统.02．技能消耗.03．QWERD魔法消耗显示").初始化QWERD魔法消耗显示();
