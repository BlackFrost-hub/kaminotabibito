/**
 * 技能冷却系统 - 统一导出和初始化入口
 */

export * from "./00．冷却常量";
export * from "./01．冷却缩减计算";
export * from "./02．特殊技能处理";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerSpellEffectListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
  registerSpellEffectListener: (cb: (castingUnit: any, spellAbilityId: number) => void) => void;
};

const { isBlacklistedSkill, isExcludedUnit, getCooldownReduction, getCooldownReductionBonus, applyCooldownCap, calcActualCooldown, setAbilityCooldown } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  isBlacklistedSkill: (abilityId: number) => boolean;
  isExcludedUnit: (unit: any) => boolean;
  getCooldownReduction: (unit: any) => number;
  getCooldownReductionBonus: (unit: any) => number;
  applyCooldownCap: (reduction: number, abilityId: number, bonus: number) => number;
  calcActualCooldown: (baseCooldown: number, reduction: number) => number;
  setAbilityCooldown: (unit: any, abilityId: number, level: number, cooldown: number) => void;
};

const { handleSpecialSkillCooldown } = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理") as {
  handleSpecialSkillCooldown: (unit: any, abilityId: number, reduction: number) => boolean;
};

const { INDEPENDENT_COOLDOWN_SKILLS } = require("系统.03．技能系统.01．技能冷却.00．冷却常量") as {
  INDEPENDENT_COOLDOWN_SKILLS: string[];
};

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};

function onSpellEffectForCooldown(castingUnit: any, spellAbilityId: number): void {
  if (isBlacklistedSkill(spellAbilityId)) return;
  if (isExcludedUnit(castingUnit)) return;

  for (const idStr of INDEPENDENT_COOLDOWN_SKILLS) {
    if (stringToFourCC(idStr) === spellAbilityId) return;
  }

  const reduction = getCooldownReduction(castingUnit);
  if (reduction < 0.001) return;

  const bonus = getCooldownReductionBonus(castingUnit);
  const cappedReduction = applyCooldownCap(reduction, spellAbilityId, bonus);

  if (handleSpecialSkillCooldown(castingUnit, spellAbilityId, cappedReduction)) return;

  const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
  if (level <= 0) return;

  const baseCooldown = japi.YDWEGetObjectPropertyReal(
    japi.YDWE_OBJECT_TYPE_ABILITY,
    spellAbilityId,
    "Cool" + level
  );
  if (baseCooldown <= 0) return;

  const actualCooldown = calcActualCooldown(baseCooldown, cappedReduction);
  setAbilityCooldown(castingUnit, spellAbilityId, level, actualCooldown);
}

registerSpellEffectListener(onSpellEffectForCooldown);
