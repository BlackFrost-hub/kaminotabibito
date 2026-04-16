/**
 * 显示技能名字系统2
 *
 * 功能：当单位发动技能效果时触发
 * 事件：SPELL_EFFECT（发动技能效果）
 */

const { registerSpellEffectListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
  registerSpellEffectListener: (cb: (castingUnit: any, spellAbilityId: number) => void) => void;
};

function onSpellEffect(castingUnit: any, spellAbilityId: number): void {
  // TODO: 具体效果待实现
}

registerSpellEffectListener(onSpellEffect);

export {};
