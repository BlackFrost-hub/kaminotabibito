/** @noSelfInFile */

/**
 * 伤害函数 - 伤害类型判断
 */

const jass = require("jass.common") as any;
import {
  YDWEIsEventDamageType,
  YDWEIsEventAttackDamage,
  YDWEIsEventRangedDamage,
  YDWEIsEventPhysicalDamage,
  YDWEIsEventAttackType,
} from "./02．伤害事件数据";

// 判断是否是魔法伤害
export function isMagicDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_ACID) ||
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

//=============================================================================
// 属性伤害判断（用于伤害计算系统）
//=============================================================================

// 判断是否是金属性伤害（毒/酸/缓毒/疾病）
export function isMetalDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_SLOW_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_POISON) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_ACID) ||
    YDWEIsEventDamageType(jass.DAMAGE_TYPE_DISEASE);
}

// 判断是否是木属性伤害（植物）
export function isWoodDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_PLANT);
}

// 判断是否是水属性伤害（寒冷）
export function isWaterDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_COLD);
}

// 判断是否是火属性伤害（火焰）
export function isFireDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_FIRE);
}

// 判断是否是雷属性伤害（闪电）
export function isThunderDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_LIGHTNING);
}

// 判断是否是光属性伤害（神圣）
export function isLightDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_DIVINE);
}

// 判断是否是暗属性伤害（暗影突袭）
export function isDarkDamage(): boolean {
  return YDWEIsEventDamageType(jass.DAMAGE_TYPE_SHADOW_STRIKE);
}
