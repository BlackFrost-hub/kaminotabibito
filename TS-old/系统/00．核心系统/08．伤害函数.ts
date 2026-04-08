const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

export const EVENT_DAMAGE_DATA_VAILD = 0;
export const EVENT_DAMAGE_DATA_IS_PHYSICAL = 1;
export const EVENT_DAMAGE_DATA_IS_ATTACK = 2;
export const EVENT_DAMAGE_DATA_IS_RANGED = 3;
export const EVENT_DAMAGE_DATA_DAMAGE_TYPE = 4;
export const EVENT_DAMAGE_DATA_WEAPON_TYPE = 5;
export const EVENT_DAMAGE_DATA_ATTACK_TYPE = 6;

export function EXGetEventDamageData(edd_type: number): number {
  return japi.EXGetEventDamageData(edd_type);
}

export function EXSetEventDamage(amount: number): boolean {
  return japi.EXSetEventDamage(amount);
}

export function YDWEIsEventPhysicalDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL);
}

export function YDWEIsEventAttackDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK);
}

export function YDWEIsEventRangedDamage(): boolean {
  return 0 !== japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED);
}

export function YDWEIsEventDamageType(damageType: any): boolean {
  return damageType === jass.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE));
}

export function YDWEIsEventWeaponType(weaponType: any): boolean {
  return weaponType === jass.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE));
}

export function YDWEIsEventAttackType(attackType: any): boolean {
  return attackType === jass.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE));
}

export function YDWESetEventDamage(amount: number): boolean {
  return japi.EXSetEventDamage(amount);
}

// 判断是否是魔法伤害
export function isMagicDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_MAGIC) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE);
}

// 判断是否是强化伤害（在魔兽争霸3里，这个伤害类型默认无视敌人的护甲和魔抗）
export function isEnhancedDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_ENHANCED);
}

// 判断是否是真实伤害（精神伤害，比强化伤害更强，参考LoL里的真实伤害）
export function isTrueDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_MIND);
}

// 判断是否是普通攻击
export function isNormalAttack(): boolean {
  const isAttackOrRanged = YDWEIsEventAttackDamage() || YDWEIsEventRangedDamage();
  const isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL);
  return isAttackOrRanged && !isSkillDamage;
}

// 判断是否是技能攻击
export function isSkillAttack(): boolean {
  const isAttackOrRanged = YDWEIsEventAttackDamage() || YDWEIsEventRangedDamage();
  const isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL);
  return isAttackOrRanged && isSkillDamage;
}

// 判断是否是技能伤害
export function isSkillDamage(): boolean {
  const isAttackOrRanged = YDWEIsEventAttackDamage() || YDWEIsEventRangedDamage();
  const isSkillDamage = YDWEIsEventAttackType(jass.ATTACK_TYPE_NORMAL);
  return !isAttackOrRanged && isSkillDamage;
}

// 判断是否是物理伤害（包括普通伤害类型和物理伤害标记）
export function isPhysicalDamage(): boolean {
  return YDWEIsEventPhysicalDamage() || YDWEIsEventDamageType(jass.DAMAGE_TYPE_NORMAL);
}
