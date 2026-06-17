/** @noSelfInFile */

const jass = require("jass.common") as any;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;

export interface 同类伤害类型映射 {
  攻击类型: any;
  伤害类型: any;
  武器类型: any;
}

export function 获取同类伤害类型(this: void, snapshot: any): 同类伤害类型映射 {
  if (snapshot == null) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, 武器类型: null };
  }
  if (snapshot.rawDamageType != null) {
    return {
      攻击类型: snapshot.rawAttackType ?? ATTACK_TYPE_NORMAL,
      伤害类型: snapshot.rawDamageType,
      武器类型: snapshot.rawWeaponType ?? null,
    };
  }

  if (snapshot.isTrueDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_MIND, 武器类型: null };
  }
  if (snapshot.isEnhancedDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_ENHANCED, 武器类型: null };
  }
  if (snapshot.isPhysicalDamage === true || snapshot.isNormalAttack === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, 武器类型: null };
  }
  if (snapshot.isFireDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_FIRE, 武器类型: null };
  }
  if (snapshot.isThunderDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_LIGHTNING, 武器类型: null };
  }
  if (snapshot.isLightDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_DIVINE, 武器类型: null };
  }
  if (snapshot.isDarkDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_SHADOW_STRIKE, 武器类型: null };
  }
  if (snapshot.isWoodDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_PLANT, 武器类型: null };
  }
  if (snapshot.isWaterDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_COLD, 武器类型: null };
  }
  if (snapshot.isMetalDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_POISON, 武器类型: null };
  }
  if (snapshot.isSkillAttack === true || snapshot.isSkillDamage === true || snapshot.isMagicDamage === true) {
    return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: jass.DAMAGE_TYPE_MAGIC, 武器类型: null };
  }

  return { 攻击类型: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, 武器类型: null };
}

export {};

