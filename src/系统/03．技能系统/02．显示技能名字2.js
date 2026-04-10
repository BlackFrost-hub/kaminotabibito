/**
 * 显示技能名字系统2
 *
 * 功能：当单位发动技能效果时触发
 * 事件：EVENT_PLAYER_UNIT_SPELL_EFFECT（发动技能效果）
 */
const jass = require("jass.common");
const { TriggerRegisterAnyUnitEventBJ } = require("lib.扩展函数.BJ函数.index");
/**
 * 发动技能效果的触发动作
 */
function onSpellEffect() {
    const unit = jass.GetTriggerUnit();
    const abilityId = jass.GetSpellAbilityId();
    // TODO: 具体效果待实现
}
/**
 * 初始化
 */
export function initShowSkillName2() {
    const trig = jass.CreateTrigger();
    TriggerRegisterAnyUnitEventBJ(trig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT);
    jass.TriggerAddAction(trig, onSpellEffect);
}
