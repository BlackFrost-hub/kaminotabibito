/** @noSelfInFile */
/**
 * 显示技能名字系统
 *
 * 功能：当单位施放技能时，在单位头顶显示技能名称的漂浮文字
 * 排除：机械单位、古树单位、使用物品（物品栏命令ID 852008-852013, 852622）
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const 浮字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index");
const 技能事件模块 = require("系统.00．核心系统.01．事件中心.08．技能事件中心");
const CreateFloatTextOnUnit = 浮字模块.CreateFloatTextOnUnit;
const registerSpellChannelListener = 技能事件模块.registerSpellChannelListener;
const ABILITY_DATA_TIP = 215;
const ITEM_USE_ORDER_IDS = new Set([
    852008, 852009, 852010, 852011, 852012, 852013, 852622,
]);
function getAbilityName(unit, abilityId, level) {
    const abil = japi.EXGetUnitAbility(unit, abilityId);
    if (!abil)
        return "";
    return japi.EXGetAbilityDataString(abil, level, ABILITY_DATA_TIP) || "";
}
function onSpellChannel(castingUnit, spellAbilityId) {
    if (typeof CreateFloatTextOnUnit !== "function")
        return;
    if (jass.IsUnitType(castingUnit, jass.UNIT_TYPE_MECHANICAL))
        return;
    if (jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT))
        return;
    const orderId = jass.GetUnitCurrentOrder(castingUnit);
    if (ITEM_USE_ORDER_IDS.has(orderId))
        return;
    const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
    const skillName = getAbilityName(castingUnit, spellAbilityId, level);
    if (!skillName)
        return;
    CreateFloatTextOnUnit(castingUnit, skillName, {
        size: 9,
        red: 255,
        green: 255,
        blue: 255,
        alpha: 0,
        duration: 1,
        speedX: 0,
        speedY: 0.04,
        height: 20,
    });
}
if (typeof registerSpellChannelListener === "function") {
    registerSpellChannelListener(onSpellChannel);
}
export {};
