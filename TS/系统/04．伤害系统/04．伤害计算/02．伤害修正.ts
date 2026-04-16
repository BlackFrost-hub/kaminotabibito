/**
 * 伤害修正计算模块
 *
 * 功能：护甲穿透、魔抗、属性伤害/抗性等修正计算
 */

const jass = require("jass.common") as any;
const {
  getRealAttr,
  getRealAttrWithLimit,
  getAttackerArmorPierce,
  getAttackerMagicPierce,
  getTargetArmor,
  isIgnoreArmor,
  isIgnoreMagicResist,
  isPlayerUnit,
} = require("系统.04．伤害系统.04．伤害计算.01．属性读取") as {
  getRealAttr: (unit: any, attrName: string, defaultValue: number) => number;
  getRealAttrWithLimit: (unit: any, attrName: string, isPlayer: boolean) => number;
  getAttackerArmorPierce: (attacker: any) => number;
  getAttackerMagicPierce: (attacker: any) => number;
  getTargetArmor: (target: any) => number;
  isIgnoreArmor: (attacker: any) => boolean;
  isIgnoreMagicResist: (attacker: any) => boolean;
  isPlayerUnit: (unit: any) => boolean;
};
const {
  calcArmorReduction,
  calcPiercedArmorReduction,
} = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  calcArmorReduction: (armor: number) => number;
  calcPiercedArmorReduction: (armor: number, pierce: number, ignore: boolean) => number;
};
const {
  OperatorRealMultiply,
  OperatorResistReduction,
  createValueHolder,
} = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  OperatorRealMultiply: (value: number, addValue: { value: number }, multiplier: { value: number }) => void;
  OperatorResistReduction: (resist: number, multiplier: { value: number }) => void;
  createValueHolder: (initialValue: number) => { value: number };
};

//=============================================================================
// 一、护甲穿透计算
//=============================================================================

/**
 * 应用护甲穿透修正伤害
 *
 * @param damage 原始伤害
 * @param target 受击者
 * @param attacker 攻击者
 */
export function applyArmorPenetration(
  damage: number,
  target: any,
  attacker: any
): number {
  const originalArmor = getTargetArmor(target);
  if (originalArmor <= 0) return damage;

  const armorPierce = getAttackerArmorPierce(attacker);
  const ignoreArmor = isIgnoreArmor(attacker);

  // 计算原始减伤比例
  const originalReduction = calcArmorReduction(originalArmor);
  // 计算穿透后减伤比例
  const piercedReduction = calcPiercedArmorReduction(originalArmor, armorPierce, ignoreArmor);

  // 反算原始伤害，再应用穿透后减伤
  const baseDamage = damage / (1 - originalReduction);
  return baseDamage * (1 - piercedReduction);
}

//=============================================================================
// 二、魔抗计算
//=============================================================================

/**
 * 应用魔抗修正伤害
 *
 * @param damage 原始伤害
 * @param target 受击者
 * @param attacker 攻击者
 */
export function applyMagicResist(
  damage: number,
  target: any,
  attacker: any
): number {
  const isPlayer = isPlayerUnit(target);
  let magicResist = getRealAttrWithLimit(target, "魔抗", isPlayer);

  // 负魔抗：增加受到的伤害
  if (magicResist < 0) {
    return damage * (1 - magicResist);
  }

  // 正魔抗：检查无视魔抗和魔法穿透
  const ignoreMagicResist = isIgnoreMagicResist(attacker);
  if (ignoreMagicResist) {
    return damage;
  }

  const magicPierce = getAttackerMagicPierce(attacker);
  if (magicPierce > 0) {
    magicResist = magicResist * (1 - magicPierce);
  }

  return damage * (1 - magicResist);
}

//=============================================================================
// 三、属性伤害/抗性计算
//=============================================================================

/**
 * 属性伤害类型配置
 */
const ELEMENTAL_DAMAGE_CONFIG = [
  { damageAttr: "金属性伤害", resistAttr: "金属性抗性", checkFunc: "isMetalDamage" },
  { damageAttr: "木属性伤害", resistAttr: "木属性抗性", checkFunc: "isWoodDamage" },
  { damageAttr: "水属性伤害", resistAttr: "水属性抗性", checkFunc: "isWaterDamage" },
  { damageAttr: "火属性伤害", resistAttr: "火属性抗性", checkFunc: "isFireDamage" },
  { damageAttr: "雷属性伤害", resistAttr: "雷属性抗性", checkFunc: "isThunderDamage" },
  { damageAttr: "光属性伤害", resistAttr: "光属性抗性", checkFunc: "isLightDamage" },
  { damageAttr: "暗属性伤害", resistAttr: "暗属性抗性", checkFunc: "isDarkDamage" },
];

/**
 * 计算属性伤害加成
 *
 * @param attacker 攻击者
 * @param damageAttr 伤害属性名
 * @returns 加法叠加的伤害加成
 */
export function calcElementalDamageBonus(attacker: any, damageAttr: string): number {
  return getRealAttr(attacker, damageAttr, 0);
}

/**
 * 计算属性抗性减伤
 *
 * @param target 受击者
 * @param resistAttr 抗性属性名
 * @param isPlayer 是否为玩家
 * @returns 乘法叠加的减伤比例
 */
export function calcElementalResistReduction(
  target: any,
  resistAttr: string,
  isPlayer: boolean
): number {
  const resist = getRealAttrWithLimit(target, resistAttr, isPlayer);
  return 1 - resist;
}

//=============================================================================
// 四、伤害类型修正计算
//=============================================================================

/**
 * 获取物理伤害修正
 */
export function getPhysicalDamageModifier(attacker: any, target: any, isPlayer: boolean): {
  addDamage: number;
  multiplier: number;
} {
  const physDmg = getRealAttr(attacker, "物理伤害", 0);
  const physResist = getRealAttrWithLimit(target, "物理抗性", isPlayer);

  const addDamage = createValueHolder(0);
  const multiplier = createValueHolder(1 - physResist);

  OperatorRealMultiply(physDmg, addDamage, multiplier);

  return { addDamage: addDamage.value, multiplier: multiplier.value };
}

/**
 * 获取技能伤害修正
 */
export function getSkillDamageModifier(attacker: any, target: any, isPlayer: boolean): {
  addDamage: number;
  multiplier: number;
} {
  const skillDmg = getRealAttr(attacker, "技能伤害", 0);
  const skillResist = getRealAttr(target, "技能抗性", 0);

  const addDamage = createValueHolder(0);
  const multiplier = createValueHolder(1 - skillResist);

  OperatorRealMultiply(skillDmg, addDamage, multiplier);

  return { addDamage: addDamage.value, multiplier: multiplier.value };
}

/**
 * 获取普攻伤害修正
 */
export function getNormalAttackModifier(attacker: any, target: any, isPlayer: boolean): {
  addDamage: number;
  multiplier: number;
} {
  const atkDmg = getRealAttr(attacker, "普攻伤害", 0);
  const atkResist = getRealAttr(target, "普攻抗性", 0);

  const addDamage = createValueHolder(0);
  const multiplier = createValueHolder(1 - atkResist);

  OperatorRealMultiply(atkDmg, addDamage, multiplier);

  return { addDamage: addDamage.value, multiplier: multiplier.value };
}

/**
 * 获取魔法伤害修正
 */
export function getMagicDamageModifier(attacker: any): number {
  const magicDmg = getRealAttr(attacker, "魔法伤害", 0);
  // 调试输出
  if (attacker && magicDmg !== 0) {
    const j = require("jass.common") as any;
    try {
      const owner = j.GetOwningPlayer(attacker);
      if (owner) {
        j.DisplayTimedTextToPlayer(owner, 0, 0, 5, "|cffff0000[调试]|r getMagicDamageModifier: magicDmg=" + magicDmg);
      }
    } catch (_e) {
      // 忽略错误
    }
  }
  return magicDmg; // 加法叠加
}

/**
 * 获取强化伤害修正
 */
export function getEnhancedDamageModifier(attacker: any): number {
  const enhanceDmg = getRealAttr(attacker, "强化伤害", 0);
  return enhanceDmg; // 加法叠加
}

/**
 * 获取最终伤害加成
 */
export function getFinalDamageBonus(attacker: any): number {
  return getRealAttr(attacker, "最终伤害%", 0);
}

//=============================================================================
// 五、专精加成
//=============================================================================

/**
 * 获取蝼蚁专精加成
 * 条件：目标非英雄且非恶魔种族
 */
export function getAntMasteryBonus(attacker: any, target: any): number {
  // 检查目标是否为英雄
  const isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO);
  // 检查目标是否为恶魔种族
  const isDemon = jass.GetUnitRace(target) === jass.RACE_DEMON;

  // 目标是英雄或恶魔，不生效
  if (isHero || isDemon) return 0;

  return getRealAttr(attacker, "蝼蚁专精", 0);
}

/**
 * 获取Boss专精加成
 * 条件：目标是英雄或恶魔种族
 */
export function getBossMasteryBonus(attacker: any, target: any): number {
  // 检查目标是否为英雄
  const isHero = jass.IsUnitType(target, jass.UNIT_TYPE_HERO);
  // 检查目标是否为恶魔种族
  const isDemon = jass.GetUnitRace(target) === jass.RACE_DEMON;

  // 目标不是英雄也不是恶魔，不生效
  if (!isHero && !isDemon) return 0;

  return getRealAttr(attacker, "Boss专精", 0);
}

//=============================================================================
// 六、召唤物伤害修正
//=============================================================================

/**
 * 检查单位是否为召唤物
 */
export function isSummonedUnit(unit: any): boolean {
  return jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED);
}

/**
 * 获取召唤物伤害修正
 */
export function getSummonDamageModifier(attacker: any, target: any, isPlayer: boolean): {
  addDamage: number;
  multiplier: number;
} {
  // 攻击者不是召唤物，不生效
  if (!isSummonedUnit(attacker)) {
    return { addDamage: 0, multiplier: 1 };
  }

  const summonDmg = getRealAttr(attacker, "召唤物伤害", 0);
  const summonResist = getRealAttr(target, "召唤物抗性", 0);

  const addDamage = createValueHolder(0);
  const multiplier = createValueHolder(1 - summonResist);

  OperatorRealMultiply(summonDmg, addDamage, multiplier);

  return { addDamage: addDamage.value, multiplier: multiplier.value };
}

export {};
