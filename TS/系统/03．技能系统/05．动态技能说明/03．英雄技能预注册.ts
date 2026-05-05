const jass = require("jass.common") as any;
const {
  EXGetUnitAbilityByIndex,
  EXGetAbilityId,
  getObjectProperty,
  ObjectType,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXGetUnitAbilityByIndex: (u: any, index: number) => any;
  EXGetAbilityId: (abil: any) => number;
  getObjectProperty: (objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
};

import { DYNAMIC_SKILL_TIP_ENABLED } from "./00．常量定义";
import { registerDynamicSkillTip, refreshAllSkillTips, ABILITY_DATA_UBERTIP } from "./01．核心功能";

const ITEM_SKILL_MIN = 852008;
const ITEM_SKILL_MAX = 852013;

const registeredSkills = new Set<string>();
let periodicCallbackId: number | null = null;

function isItemSkillByOrder(unit: any): boolean {
  if (!unit) return false;

  const currentOrder = jass.GetUnitCurrentOrder(unit);
  if (!currentOrder) return false;

  return currentOrder >= ITEM_SKILL_MIN && currentOrder <= ITEM_SKILL_MAX;
}

function getSkillKey(unit: any, abilityId: number): string {
  return `${jass.GetHandleId(unit)}_${abilityId}`;
}

function getSkillTemplate(unit: any, abilityId: number, level: number): string | null {
  if (!unit || !abilityId || level <= 0) return null;

  const researchUbertip = getObjectProperty(ObjectType.ABILITY, abilityId, "Researchubertip");
  if (researchUbertip == null || researchUbertip === "") return null;

  return researchUbertip;
}

function registerOneSkillTemplate(unit: any, abilityId: number, level: number): void {
  if (!unit || !abilityId || level <= 0) return;

  const skillKey = getSkillKey(unit, abilityId);
  if (registeredSkills.has(skillKey)) return;

  const template = getSkillTemplate(unit, abilityId, level);
  if (!template) return;

  const success = registerDynamicSkillTip(unit, abilityId, template, level, ABILITY_DATA_UBERTIP);
  if (success) {
    registeredSkills.add(skillKey);
  }
}

function registerExistingHeroSkills(unit: any): void {
  if (!unit || unit === 0) return;

  for (let i = 0; i <= 15; i++) {
    const ability = EXGetUnitAbilityByIndex(unit, i);
    if (!ability) continue;

    const abilityId = EXGetAbilityId(ability);
    if (!abilityId) continue;

    const level = jass.GetUnitAbilityLevel(unit, abilityId);
    if (level <= 0) continue;

    registerOneSkillTemplate(unit, abilityId, level);
  }
}

function onSpellEffect(castingUnit: any, spellAbilityId: number): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;
  if (isItemSkillByOrder(castingUnit)) return;

  const currentLevel = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
  if (currentLevel <= 0) return;

  registerOneSkillTemplate(castingUnit, spellAbilityId, currentLevel);
}

function onPeriodicRefresh(): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;
  refreshAllSkillTips();
}

export function initHeroSkillPreregistration(): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;

  const { registerSpellEffectListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
    registerSpellEffectListener: (callback: (castingUnit: any, spellAbilityId: number) => void) => void;
  };
  registerSpellEffectListener(onSpellEffect);

  const { addPeriodicCallback } = globalThis as unknown as {
    addPeriodicCallback: (intervalMs: number, callback: () => void) => number;
  };
  periodicCallbackId = addPeriodicCallback(2000, onPeriodicRefresh);
}

export function onHeroRegisteredPreregistration(this: void, whichPlayer: any, whichHero: any): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;
  if (!whichPlayer || whichPlayer === 0 || !whichHero || whichHero === 0) return;
  registerExistingHeroSkills(whichHero);
}

export {};
