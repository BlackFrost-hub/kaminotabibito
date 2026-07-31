/** @noSelfInFile */

/**
 * 伤害类型转换层。
 *
 * 默认转换只改本次伤害事件的计算快照；需要改变原生伤害类型时，转换器
 * 返回 reapplyDamage，由主流程先将原事件归零，再按原始伤害值重提交一次。
 * rawAttackType/rawDamageType/rawWeaponType 始终保留，供原始伤害语义和攻击效果使用。
 */

const jass = require("jass.common") as any;

const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const DAMAGE_TYPE_DISEASE = jass.DAMAGE_TYPE_DISEASE as any;
const DAMAGE_TYPE_SLOW_POISON = jass.DAMAGE_TYPE_SLOW_POISON as any;
const DAMAGE_TYPE_ACID = jass.DAMAGE_TYPE_ACID as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_SONIC = jass.DAMAGE_TYPE_SONIC as any;
const DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL as any;

export interface DamageTypeConversionContext {
  target: any;
  attacker: any;
  originalAttacker?: any;
  baseDamage: number;
  rawAttackType: any;
  rawDamageType: any;
  rawWeaponType: any;
  effectiveAttackType: any;
  effectiveDamageType: any;
  effectiveWeaponType: any;
  isPhysicalDamage: boolean;
  isMagicDamage: boolean;
  isEnhancedDamage: boolean;
  isTrueDamage: boolean;
  isNormalAttack: boolean;
  isRangedAttack: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
  isWrappedSkillDamage: boolean;
  isEquipmentSkillDamage: boolean;
  isNonEquipmentSkillDamage: boolean;
  skillDamageSourceKind?: string;
  equipmentSkillDamageKind?: string;
  itemTypeId?: number;
  itemHandle?: any;
  abilityId?: number;
  skillInstanceId?: number;
  skillDamageTag?: string;
  skillDamageShape: string;
  isIndependentSkillDamage: boolean;
  isSingleTargetSkillDamage: boolean;
  isAoeSkillDamage: boolean;
  isDamageTransfer: boolean;
  isMetalDamage: boolean;
  isWoodDamage: boolean;
  isWaterDamage: boolean;
  isFireDamage: boolean;
  isThunderDamage: boolean;
  isLightDamage: boolean;
  isDarkDamage: boolean;
  reapplyDamage?: DamageTypeReapplyRequest;
}

export interface DamageTypeReapplyRequest {
  damageType: any;
  attack?: boolean;
  ranged?: boolean;
  attackType?: any;
  weaponType?: any;
}

export interface DamageTypeConversionResult {
  /** 伤害类型别名；设置后会自动重算物理/魔法/强化/真实和五行标记。 */
  damageType?: any;
  effectiveDamageType?: any;
  attackType?: any;
  weaponType?: any;
  effectiveAttackType?: any;
  effectiveWeaponType?: any;
  isPhysicalDamage?: boolean;
  isMagicDamage?: boolean;
  isEnhancedDamage?: boolean;
  isTrueDamage?: boolean;
  isNormalAttack?: boolean;
  isRangedAttack?: boolean;
  isSkillAttack?: boolean;
  isSkillDamage?: boolean;
  isWrappedSkillDamage?: boolean;
  isEquipmentSkillDamage?: boolean;
  isNonEquipmentSkillDamage?: boolean;
  isIndependentSkillDamage?: boolean;
  isSingleTargetSkillDamage?: boolean;
  isAoeSkillDamage?: boolean;
  isDamageTransfer?: boolean;
  isMetalDamage?: boolean;
  isWoodDamage?: boolean;
  isWaterDamage?: boolean;
  isFireDamage?: boolean;
  isThunderDamage?: boolean;
  isLightDamage?: boolean;
  isDarkDamage?: boolean;
  reapplyDamage?: DamageTypeReapplyRequest;
}

export type DamageTypeConversion = (this: void, context: DamageTypeConversionContext) => DamageTypeConversionResult | void;

interface DamageTypeConversionEntry {
  id: number;
  priority: number;
  callback: DamageTypeConversion;
}

const conversions: DamageTypeConversionEntry[] = [];
let nextConversionId = 1;

function sortConversions(this: void): void {
  conversions.sort(function sortDamageTypeConversions(a: DamageTypeConversionEntry, b: DamageTypeConversionEntry): number {
    if (a.priority !== b.priority) return b.priority - a.priority;
    return a.id - b.id;
  });
}

function 清空属性伤害标记(this: void, context: DamageTypeConversionContext): void {
  context.isMetalDamage = false;
  context.isWoodDamage = false;
  context.isWaterDamage = false;
  context.isFireDamage = false;
  context.isThunderDamage = false;
  context.isLightDamage = false;
  context.isDarkDamage = false;
}

function 根据伤害类型重算标记(this: void, context: DamageTypeConversionContext): void {
  const damageType = context.effectiveDamageType;
  if (damageType == null || damageType === 0) return;

  context.isPhysicalDamage = false;
  context.isMagicDamage = false;
  context.isEnhancedDamage = false;
  context.isTrueDamage = false;
  清空属性伤害标记(context);

  if (damageType === DAMAGE_TYPE_NORMAL) {
    context.isPhysicalDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_ENHANCED) {
    context.isEnhancedDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_MIND) {
    context.isTrueDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_SLOW_POISON || damageType === DAMAGE_TYPE_POISON || damageType === DAMAGE_TYPE_ACID || damageType === DAMAGE_TYPE_DISEASE) {
    context.isMagicDamage = true;
    context.isMetalDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_PLANT) {
    context.isMagicDamage = true;
    context.isWoodDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_COLD) {
    context.isMagicDamage = true;
    context.isWaterDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_FIRE) {
    context.isMagicDamage = true;
    context.isFireDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_LIGHTNING) {
    context.isMagicDamage = true;
    context.isThunderDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_DIVINE) {
    context.isMagicDamage = true;
    context.isLightDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_SHADOW_STRIKE) {
    context.isMagicDamage = true;
    context.isDarkDamage = true;
    return;
  }
  if (damageType === DAMAGE_TYPE_MAGIC || damageType === DAMAGE_TYPE_SONIC) {
    context.isMagicDamage = true;
  }
  if (damageType === DAMAGE_TYPE_UNIVERSAL) {
    context.isPhysicalDamage = false;
    context.isMagicDamage = false;
  }
}

function 应用转换结果(this: void, context: DamageTypeConversionContext, result: DamageTypeConversionResult): void {
  const damageType = result.effectiveDamageType !== undefined ? result.effectiveDamageType : result.damageType;
  const hasDamageType = damageType !== undefined;
  if (result.effectiveAttackType !== undefined) context.effectiveAttackType = result.effectiveAttackType;
  else if (result.attackType !== undefined) context.effectiveAttackType = result.attackType;
  if (result.effectiveWeaponType !== undefined) context.effectiveWeaponType = result.effectiveWeaponType;
  else if (result.weaponType !== undefined) context.effectiveWeaponType = result.weaponType;
  if (hasDamageType) {
    context.effectiveDamageType = damageType;
    根据伤害类型重算标记(context);
  }

  if (result.isPhysicalDamage !== undefined) context.isPhysicalDamage = result.isPhysicalDamage;
  if (result.isMagicDamage !== undefined) context.isMagicDamage = result.isMagicDamage;
  if (result.isEnhancedDamage !== undefined) context.isEnhancedDamage = result.isEnhancedDamage;
  if (result.isTrueDamage !== undefined) context.isTrueDamage = result.isTrueDamage;
  if (result.isNormalAttack !== undefined) context.isNormalAttack = result.isNormalAttack;
  if (result.isRangedAttack !== undefined) context.isRangedAttack = result.isRangedAttack;
  if (result.isSkillAttack !== undefined) context.isSkillAttack = result.isSkillAttack;
  if (result.isSkillDamage !== undefined) context.isSkillDamage = result.isSkillDamage;
  if (result.isWrappedSkillDamage !== undefined) context.isWrappedSkillDamage = result.isWrappedSkillDamage;
  if (result.isEquipmentSkillDamage !== undefined) context.isEquipmentSkillDamage = result.isEquipmentSkillDamage;
  if (result.isNonEquipmentSkillDamage !== undefined) context.isNonEquipmentSkillDamage = result.isNonEquipmentSkillDamage;
  if (result.isIndependentSkillDamage !== undefined) context.isIndependentSkillDamage = result.isIndependentSkillDamage;
  if (result.isSingleTargetSkillDamage !== undefined) context.isSingleTargetSkillDamage = result.isSingleTargetSkillDamage;
  if (result.isAoeSkillDamage !== undefined) context.isAoeSkillDamage = result.isAoeSkillDamage;
  if (result.isDamageTransfer !== undefined) context.isDamageTransfer = result.isDamageTransfer;
  if (result.isMetalDamage !== undefined) context.isMetalDamage = result.isMetalDamage;
  if (result.isWoodDamage !== undefined) context.isWoodDamage = result.isWoodDamage;
  if (result.isWaterDamage !== undefined) context.isWaterDamage = result.isWaterDamage;
  if (result.isFireDamage !== undefined) context.isFireDamage = result.isFireDamage;
  if (result.isThunderDamage !== undefined) context.isThunderDamage = result.isThunderDamage;
  if (result.isLightDamage !== undefined) context.isLightDamage = result.isLightDamage;
  if (result.isDarkDamage !== undefined) context.isDarkDamage = result.isDarkDamage;
  if (result.reapplyDamage != null) context.reapplyDamage = result.reapplyDamage;
}

export function registerDamageTypeConversion(this: void, callback: DamageTypeConversion, priority: number = 0): number {
  if (callback == null) return 0;
  const id = nextConversionId;
  nextConversionId = nextConversionId + 1;
  conversions.push({ id, priority, callback });
  sortConversions();
  return id;
}

export function unregisterDamageTypeConversion(this: void, id: number): boolean {
  for (let i = 0; i < conversions.length; i++) {
    if (conversions[i].id !== id) continue;
    conversions.splice(i, 1);
    return true;
  }
  return false;
}

export function applyDamageTypeConversions(this: void, context: DamageTypeConversionContext): DamageTypeConversionContext {
  for (let i = 0; i < conversions.length; i++) {
    const entry = conversions[i];
    if (entry == null || entry.callback == null) continue;
    const result = entry.callback(context);
    if (result != null) 应用转换结果(context, result);
  }
  return context;
}

export function getDamageTypeConversionCount(this: void): number {
  return conversions.length;
}

export {};
