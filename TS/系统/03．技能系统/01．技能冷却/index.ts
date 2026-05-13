/** @noSelfInFile */
/**
 * 技能冷却系统 - 统一导出和初始化入口
 */

export * from "./00．冷却常量";
export * from "./01．冷却缩减计算";
export * from "./02．特殊技能处理";
export * from "./03．QWERD冷却显示";

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const {
  isBlacklistedSkill: 检查冷却黑名单,
  isExcludedUnit: 检查排除单位,
  getCooldownReduction: 读取冷却缩减,
  getCooldownReductionBonus: 读取冷却缩减加成,
  applyCooldownCap: 应用冷却上限,
  calcActualCooldown: 计算实际冷却,
  setAbilityCooldown: 设置技能冷却,
  getBaseCooldown: 读取基础冷却,
} = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  isBlacklistedSkill: (this: void, abilityId: number) => boolean;
  isExcludedUnit: (this: void, unit: any) => boolean;
  getCooldownReduction: (this: void, unit: any) => number;
  getCooldownReductionBonus: (this: void, unit: any) => number;
  applyCooldownCap: (this: void, reduction: number, abilityId: number, bonus: number) => number;
  calcActualCooldown: (this: void, baseCooldown: number, reduction: number) => number;
  setAbilityCooldown: (this: void, unit: any, abilityId: number, level: number, cooldown: number) => void;
  getBaseCooldown: (this: void, abilityId: number, level: number) => number;
};
const {
  handleSpecialSkillCooldown: 处理特殊技能冷却,
} = require("系统.03．技能系统.01．技能冷却.02．特殊技能处理") as {
  handleSpecialSkillCooldown: (this: void, unit: any, abilityId: number, reduction: number) => boolean;
};
const { INDEPENDENT_COOLDOWN_SKILLS } = require("系统.03．技能系统.01．技能冷却.00．冷却常量") as {
  INDEPENDENT_COOLDOWN_SKILLS: string[];
};

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};

const {
  初始化QWERD冷却显示,
} = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示") as {
  初始化QWERD冷却显示: (this: void) => void;
};

function isBlacklistedSkill(this: void, abilityId: number): boolean {
  return 检查冷却黑名单(abilityId);
}

function isExcludedUnit(this: void, unit: any): boolean {
  return 检查排除单位(unit);
}

function getCooldownReduction(this: void, unit: any): number {
  return 读取冷却缩减(unit);
}

function getCooldownReductionBonus(this: void, unit: any): number {
  return 读取冷却缩减加成(unit);
}

function applyCooldownCap(this: void, reduction: number, abilityId: number, bonus: number): number {
  return 应用冷却上限(reduction, abilityId, bonus);
}

function calcActualCooldown(this: void, baseCooldown: number, reduction: number): number {
  return 计算实际冷却(baseCooldown, reduction);
}

function setAbilityCooldown(this: void, unit: any, abilityId: number, level: number, cooldown: number): void {
  设置技能冷却(unit, abilityId, level, cooldown);
}

function getBaseCooldown(this: void, abilityId: number, level: number): number {
  return 读取基础冷却(abilityId, level);
}

function handleSpecialSkillCooldown(this: void, unit: any, abilityId: number, reduction: number): boolean {
  return 处理特殊技能冷却(unit, abilityId, reduction);
}

function 提取内部ID(配置键名: string): string {
  if (!配置键名) return "";
  const 片段列表 = 配置键名.split("|");
  return 片段列表[片段列表.length - 1] ?? "";
}

function onSpellEffectForCooldown(this: void, castingUnit: any, spellAbilityId: number): void {
  if (isBlacklistedSkill(spellAbilityId)) return;
  if (isExcludedUnit(castingUnit)) return;

  for (const 配置键名 of INDEPENDENT_COOLDOWN_SKILLS) {
    if (stringToFourCC(提取内部ID(配置键名)) === spellAbilityId) return;
  }

  const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
  if (level <= 0) return;

  const baseCooldown = getBaseCooldown(spellAbilityId, level);
  if (baseCooldown <= 0) return;

  const reduction = getCooldownReduction(castingUnit);
  if (reduction < 0.01) return;

  const bonus = getCooldownReductionBonus(castingUnit);
  const cappedReduction = applyCooldownCap(reduction, spellAbilityId, bonus);
  const actualCooldown = calcActualCooldown(baseCooldown, cappedReduction);

  if (handleSpecialSkillCooldown(castingUnit, spellAbilityId, cappedReduction)) return;

  setAbilityCooldown(castingUnit, spellAbilityId, level, actualCooldown);
}

registerSpellEffectListener(onSpellEffectForCooldown);
初始化QWERD冷却显示();
