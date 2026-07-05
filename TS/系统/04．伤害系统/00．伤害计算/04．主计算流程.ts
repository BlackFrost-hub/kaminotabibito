/** @noSelfInFile */

/**
 * 伤害计算主流程
 *
 * 功能：整合所有模块，执行完整的伤害计算流程
 * 包含：免疫判定、护甲穿透、魔抗、属性伤害/抗性、专精、吸血吸魔
 * 末尾：`YDWESetEventDamage` 之后通知 `registerAppliedFinalDamageListener` 订阅者（原 `06．最终伤害桥接`）。
 */

const jass = require("jass.common") as any;
const {
  getRealAttr,
  getRealAttrWithLimit,
  isPlayerUnit,
  isImmuneDamage,
  isImmuneNormalAttack,
  isDamageReduceDisabled,
} = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getRealAttr: (unit: any, attrName: string, defaultValue: number) => number;
  getRealAttrWithLimit: (unit: any, attrName: string, isPlayer: boolean) => number;
  isPlayerUnit: (unit: any) => boolean;
  isImmuneDamage: (unit: any) => boolean;
  isImmuneNormalAttack: (unit: any) => boolean;
  isDamageReduceDisabled: (unit: any) => boolean;
};
const {
  applyArmorPenetration,
  applyMagicResist,
  getPhysicalDamageModifier,
  getSkillDamageModifier,
  getNormalAttackModifier,
  getMagicDamageModifier,
  getEnhancedDamageModifier,
  getFinalDamageBonus,
  getAntMasteryBonus,
  getBossMasteryBonus,
  getBossDmgPctBonus,
  getBossResistPct,
  getEliteDmgPctBonus,
  getEliteResistPct,
  getDemonDmgPctBonus,
  getDemonResistPct,
  getSummonDamageModifier,
  calcElementalDamageBonus,
  calcElementalResistReduction,
} = require("系统.04．伤害系统.00．伤害计算.02．伤害修正") as {
  applyArmorPenetration: (damage: number, target: any, attacker: any) => number;
  applyMagicResist: (damage: number, target: any, attacker: any) => number;
  getPhysicalDamageModifier: (attacker: any, target: any, isPlayer: boolean) => { addDamage: number; multiplier: number };
  getSkillDamageModifier: (attacker: any, target: any, isPlayer: boolean) => { addDamage: number; multiplier: number };
  getNormalAttackModifier: (attacker: any, target: any, isPlayer: boolean) => { addDamage: number; multiplier: number };
  getMagicDamageModifier: (attacker: any) => number;
  getEnhancedDamageModifier: (attacker: any) => number;
  getFinalDamageBonus: (attacker: any) => number;
  getAntMasteryBonus: (attacker: any, target: any) => number;
  getBossMasteryBonus: (attacker: any, target: any) => number;
  getBossDmgPctBonus: (attacker: any, target: any) => number;
  getBossResistPct: (target: any, attacker: any) => number;
  getEliteDmgPctBonus: (attacker: any, target: any) => number;
  getEliteResistPct: (target: any, attacker: any) => number;
  getDemonDmgPctBonus: (attacker: any, target: any) => number;
  getDemonResistPct: (target: any, attacker: any) => number;
  getSummonDamageModifier: (attacker: any, target: any, isPlayer: boolean) => { addDamage: number; multiplier: number };
  calcElementalDamageBonus: (attacker: any, damageAttr: string) => number;
  calcElementalResistReduction: (target: any, resistAttr: string, isPlayer: boolean) => number;
};
const { applyLifeAndManaSteal } = require("系统.04．伤害系统.00．伤害计算.03．吸血吸魔") as {
  applyLifeAndManaSteal: (attacker: any, damage: number, isMagic: boolean, isNormalAttack: boolean, showText: boolean) => void;
};
const { applyDamageModifiers } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  applyDamageModifiers: (this: void, context: {
    target: any;
    attacker: any;
    baseDamage: number;
    currentDamage: number;
    isPhysicalDamage: boolean;
    isMagicDamage: boolean;
    isEnhancedDamage: boolean;
    isTrueDamage: boolean;
    isMetalDamage?: boolean;
    isWoodDamage?: boolean;
    isWaterDamage?: boolean;
    isFireDamage?: boolean;
    isThunderDamage?: boolean;
    isLightDamage?: boolean;
    isDarkDamage?: boolean;
    rawDamageType?: any;
    isNormalAttack: boolean;
    isRangedAttack?: boolean;
    isSkillAttack: boolean;
    isSkillDamage: boolean;
    isWrappedSkillDamage?: boolean;
    isEquipmentSkillDamage?: boolean;
    isNonEquipmentSkillDamage?: boolean;
    skillDamageSourceKind?: string;
    equipmentSkillDamageKind?: string;
    itemTypeId?: number;
    itemHandle?: any;
    abilityId?: number;
    skillInstanceId?: number;
    skillDamageTag?: string;
    skillDamageShape?: string;
    isIndependentSkillDamage?: boolean;
    isSingleTargetSkillDamage?: boolean;
    isAoeSkillDamage?: boolean;
  }) => number;
};
const { 获取当前技能伤害上下文 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  获取当前技能伤害上下文: (this: void) => {
    isWrappedSkillDamage: boolean;
    isEquipmentSkillDamage: boolean;
    isNonEquipmentSkillDamage: boolean;
    sourceKind: string;
    equipmentSkillKind?: string;
    itemTypeId?: number;
    itemHandle?: any;
    abilityId?: number;
    skillInstanceId?: number;
    tag?: string;
    damageShape: string;
    isIndependentSkillDamage: boolean;
    isSingleTargetSkillDamage: boolean;
    isAoeSkillDamage: boolean;
    participatesInSkillDamageBonus: boolean;
  } | null;
};
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => any;
};
const ConvertDamageType = jass.ConvertDamageType as (value: number) => any;
const ConvertAttackType = jass.ConvertAttackType as (value: number) => any;
const ConvertWeaponType = jass.ConvertWeaponType as (value: number) => any;
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  EXGetEventDamageData: (edd_type: number) => number;
  EVENT_DAMAGE_DATA_IS_PHYSICAL: number;
  EVENT_DAMAGE_DATA_IS_ATTACK: number;
  EVENT_DAMAGE_DATA_IS_RANGED: number;
  EVENT_DAMAGE_DATA_DAMAGE_TYPE: number;
  EVENT_DAMAGE_DATA_ATTACK_TYPE: number;
  EVENT_DAMAGE_DATA_WEAPON_TYPE: number;
  isPhysicalDamage: () => boolean;
  isMagicDamage: () => boolean;
  isEnhancedDamage: () => boolean;
  isTrueDamage: () => boolean;
  isNormalAttack: () => boolean;
  isSkillAttack: () => boolean;
  isSkillDamage: () => boolean;
  isMetalDamage: () => boolean;
  isWoodDamage: () => boolean;
  isWaterDamage: () => boolean;
  isFireDamage: () => boolean;
  isThunderDamage: () => boolean;
  isLightDamage: () => boolean;
  isDarkDamage: () => boolean;
  YDWESetEventDamage: (amount: number) => boolean;
};
//=============================================================================
// 〇、最终伤害已应用回调（与 onDamageEvent 同文件）
//=============================================================================

export interface DamageTypeSnapshot {
  rawAttackType: any;
  rawDamageType: any;
  rawWeaponType: any;
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
  isMetalDamage: boolean;
  isWoodDamage: boolean;
  isWaterDamage: boolean;
  isFireDamage: boolean;
  isThunderDamage: boolean;
  isLightDamage: boolean;
  isDarkDamage: boolean;
}

export type AppliedFinalDamageListener = (target: any, attacker: any, applied: number, snapshot: DamageTypeSnapshot) => void;

const appliedFinalDamageListeners: AppliedFinalDamageListener[] = [];

export function 延后一帧执行伤害派生效果(this: void, callback: () => void): void {
  createDelayedCall(0.0, callback);
}

/** 在 `onDamageEvent` 完成 `YDWESetEventDamage`（或免疫置 0）后收到 `(target, attacker, applied)` */
export function registerAppliedFinalDamageListener(cb: AppliedFinalDamageListener): void {
  for (let i = 0; i < appliedFinalDamageListeners.length; i++) {
    if (appliedFinalDamageListeners[i] === cb) return;
  }
  appliedFinalDamageListeners.push(cb);
}

function notifyAppliedFinalDamageListeners(target: any, attacker: any, applied: number, snapshot: DamageTypeSnapshot): void {
  for (let i = 0; i < appliedFinalDamageListeners.length; i++) {
    const cb = appliedFinalDamageListeners[i];
    if (cb == null) continue;
    cb(target, attacker, applied, snapshot);
  }
}

function captureDamageTypeSnapshot(this: void): DamageTypeSnapshot {
  const skillContext = 获取当前技能伤害上下文();
  return {
    rawAttackType: ConvertAttackType(伤害函数.EXGetEventDamageData(伤害函数.EVENT_DAMAGE_DATA_ATTACK_TYPE)),
    rawDamageType: ConvertDamageType(伤害函数.EXGetEventDamageData(伤害函数.EVENT_DAMAGE_DATA_DAMAGE_TYPE)),
    rawWeaponType: ConvertWeaponType(伤害函数.EXGetEventDamageData(伤害函数.EVENT_DAMAGE_DATA_WEAPON_TYPE)),
    isPhysicalDamage: 伤害函数.isPhysicalDamage(),
    isMagicDamage: 伤害函数.isMagicDamage(),
    isEnhancedDamage: 伤害函数.isEnhancedDamage(),
    isTrueDamage: 伤害函数.isTrueDamage(),
    isNormalAttack: 伤害函数.isNormalAttack(),
    isRangedAttack: 伤害函数.EXGetEventDamageData(伤害函数.EVENT_DAMAGE_DATA_IS_RANGED) === 1,
    isSkillAttack: 伤害函数.isSkillAttack(),
    isSkillDamage: 伤害函数.isSkillDamage(),
    isWrappedSkillDamage: skillContext?.isWrappedSkillDamage === true,
    isEquipmentSkillDamage: skillContext?.isEquipmentSkillDamage === true,
    isNonEquipmentSkillDamage: skillContext?.isNonEquipmentSkillDamage === true,
    skillDamageSourceKind: skillContext?.sourceKind,
    equipmentSkillDamageKind: skillContext?.equipmentSkillKind,
    itemTypeId: skillContext?.itemTypeId,
    itemHandle: skillContext?.itemHandle,
    abilityId: skillContext?.abilityId,
    skillInstanceId: skillContext?.skillInstanceId,
    skillDamageTag: skillContext?.tag,
    skillDamageShape: skillContext?.damageShape ?? "未知",
    isIndependentSkillDamage: skillContext?.isIndependentSkillDamage === true,
    isSingleTargetSkillDamage: skillContext?.isSingleTargetSkillDamage === true,
    isAoeSkillDamage: skillContext?.isAoeSkillDamage === true,
    isMetalDamage: 伤害函数.isMetalDamage(),
    isWoodDamage: 伤害函数.isWoodDamage(),
    isWaterDamage: 伤害函数.isWaterDamage(),
    isFireDamage: 伤害函数.isFireDamage(),
    isThunderDamage: 伤害函数.isThunderDamage(),
    isLightDamage: 伤害函数.isLightDamage(),
    isDarkDamage: 伤害函数.isDarkDamage(),
  };
}

//=============================================================================
// 一、伤害计算结果
//=============================================================================

export interface DamageResult {
  /** 最终伤害值 */
  finalDamage: number;
  /** 是否被免疫 */
  immune: boolean;
  /** 免疫原因 */
  immuneReason?: string;
  /** 是否显示闪避 */
  showDodge: boolean;
}

//=============================================================================
// 二、免疫判定
//=============================================================================

/**
 * 检查是否免疫伤害
 */
function checkImmune(
  target: any,
  isNormalAtk: boolean
): { immune: boolean; reason?: string; showDodge: boolean } {
  // 免疫伤害（且未关闭减伤）
  if (isImmuneDamage(target) && !isDamageReduceDisabled(target)) {
    return { immune: true, reason: "免疫伤害", showDodge: false };
  }

  // 免疫普攻
  if (isNormalAtk && isImmuneNormalAttack(target)) {
    return { immune: true, reason: "闪避", showDodge: true };
  }

  return { immune: false, showDodge: false };
}

//=============================================================================
// 三、伤害计算主函数
//=============================================================================

/**
 * 计算最终伤害
 *
 * @param target 受击者
 * @param attacker 攻击者
 * @param baseDamage 基础伤害
 * @returns 伤害计算结果
 */
export function calculateDamage(
  target: any,
  attacker: any,
  baseDamage: number
): DamageResult {
  // 初始化
  let damage = baseDamage;
  const isPlayer = isPlayerUnit(target);
  const isNormalAtk = 伤害函数.isNormalAttack();
  const isPhysDmg = 伤害函数.isPhysicalDamage();
  const isMagicDmg = 伤害函数.isMagicDamage();
  const isEnhanceDmg = 伤害函数.isEnhancedDamage();
  const isTrueDmg = 伤害函数.isTrueDamage();
  const skillContext = 获取当前技能伤害上下文();
  const isWrappedSkillDmg = skillContext?.isWrappedSkillDamage === true && skillContext.participatesInSkillDamageBonus !== false;
  const isAnySkillDmg = 伤害函数.isSkillAttack() || 伤害函数.isSkillDamage() || isWrappedSkillDmg;

  // 真实伤害：跳过所有计算
  if (isTrueDmg) {
    return { finalDamage: damage, immune: false, showDodge: false };
  }

  // Step 1: 固定伤害减少/增加
  let dmgReduction = getRealAttr(target, "伤害减少", 0);
  if (isPhysDmg) dmgReduction += getRealAttr(target, "物理固伤减少", 0);
  if (isMagicDmg) dmgReduction += getRealAttr(target, "魔法固伤减少", 0);
  if (isAnySkillDmg) dmgReduction += getRealAttr(target, "技能固伤减少", 0);
  damage -= dmgReduction;
  const dmgIncrease = getRealAttr(attacker, "伤害增加", 0);
  damage += dmgIncrease;

  // 伤害过低
  if (damage < 0.1) {
    return { finalDamage: 0, immune: false, showDodge: false };
  }

  // Step 2: 免疫判定
  const immuneCheck = checkImmune(target, isNormalAtk);
  if (immuneCheck.immune) {
    return {
      finalDamage: 0,
      immune: true,
      immuneReason: immuneCheck.reason,
      showDodge: immuneCheck.showDodge,
    };
  }

  // 加法叠加的伤害加成
  let addDamage = 0;
  // 乘法叠加的伤害修正
  let finalMultiplier = 1;

  // Step 3: 护甲穿透（物理伤害）
  if (isPhysDmg) {
    damage = applyArmorPenetration(damage, target, attacker);
  }

  // Step 4: 魔抗计算（魔法伤害）
  if (isMagicDmg && !isPhysDmg && !isEnhanceDmg) {
    damage = applyMagicResist(damage, target, attacker);
  }

  // Step 5: 百分比伤害减少
  const dmgReductionPct = getRealAttr(target, "伤害减少%", 0);
  if (dmgReductionPct > 0) {
    finalMultiplier *= (1 - dmgReductionPct);
  }

  // Step 6: 百分比伤害提高
  const dmgBonus = getRealAttr(attacker, "伤害%", 0);
  if (dmgBonus >= 0) {
    addDamage += dmgBonus;
  } else {
    finalMultiplier *= (1 + dmgBonus);
  }

  // Step 7: 物理伤害修正
  if (isPhysDmg) {
    const physMod = getPhysicalDamageModifier(attacker, target, isPlayer);
    addDamage += physMod.addDamage;
    finalMultiplier *= physMod.multiplier;
  }

  // Step 8: 魔法伤害修正（装备「魔法伤害」等）
  // 不要求 !isPhysDmg：技能火焰等事件里 YDWE 可能同时标物理+火焰，isMagicDamage 已为 true，
  // 若再要求 !isPhysDmg 会漏掉本段，导致 50×(1+30%) 未生效。
  if (isMagicDmg && !isEnhanceDmg) {
    const magicDmg = getMagicDamageModifier(attacker);
    if (magicDmg >= 0) {
      addDamage += magicDmg;
    } else {
      finalMultiplier *= (1 + magicDmg);
    }
  }

  // Step 9: 强化伤害修正
  if (isEnhanceDmg) {
    const enhanceDmg = getEnhancedDamageModifier(attacker);
    if (enhanceDmg >= 0) {
      addDamage += enhanceDmg;
    } else {
      finalMultiplier *= (1 + enhanceDmg);
    }
  }

  // Step 10: 技能伤害修正
  if (isAnySkillDmg) {
    const skillMod = getSkillDamageModifier(attacker, target, isPlayer);
    addDamage += skillMod.addDamage;
    finalMultiplier *= skillMod.multiplier;
  }

  // Step 11-12: 普攻伤害修正
  if (isNormalAtk) {
    const atkMod = getNormalAttackModifier(attacker, target, isPlayer);
    addDamage += atkMod.addDamage;
    finalMultiplier *= atkMod.multiplier;

    // 魔法普攻伤害
    const magicAtkDmg = getRealAttr(attacker, "魔法普攻伤害", 0);
    addDamage += magicAtkDmg;
  }

  // Step 13: 属性伤害修正
  const elementalResult = applyElementalDamage(attacker, target, isPlayer);
  addDamage += elementalResult.addDamage;
  finalMultiplier *= elementalResult.multiplier;

  // Step 14: 召唤物伤害修正
  const summonMod = getSummonDamageModifier(attacker, target, isPlayer);
  addDamage += summonMod.addDamage;
  finalMultiplier *= summonMod.multiplier;

  // Step 15: 专精加成
  const antBonus = getAntMasteryBonus(attacker, target);
  const bossBonus = getBossMasteryBonus(attacker, target);
  if (antBonus >= 0) {
    addDamage += antBonus;
  } else {
    finalMultiplier *= (1 + antBonus);
  }
  if (bossBonus >= 0) {
    addDamage += bossBonus;
  } else {
    finalMultiplier *= (1 + bossBonus);
  }

  // Step 15b: 对Boss/精英/恶魔族伤害%加成（加法）
  const bossDmgPct = getBossDmgPctBonus(attacker, target);
  if (bossDmgPct >= 0) addDamage += bossDmgPct;
  else finalMultiplier *= (1 + bossDmgPct);

  const eliteDmgPct = getEliteDmgPctBonus(attacker, target);
  if (eliteDmgPct >= 0) addDamage += eliteDmgPct;
  else finalMultiplier *= (1 + eliteDmgPct);

  const demonDmgPct = getDemonDmgPctBonus(attacker, target);
  if (demonDmgPct >= 0) addDamage += demonDmgPct;
  else finalMultiplier *= (1 + demonDmgPct);

  // 受到Boss/精英/恶魔族伤害减少%（乘法乘区）
  const bossResist = getBossResistPct(target, attacker);
  finalMultiplier *= (1 - bossResist);

  const eliteResist = getEliteResistPct(target, attacker);
  finalMultiplier *= (1 - eliteResist);

  const demonResist = getDemonResistPct(target, attacker);
  finalMultiplier *= (1 - demonResist);

  // Step 16: 最终伤害加成
  const finalDmgBonus = getFinalDamageBonus(attacker);
  finalMultiplier *= (1 + finalDmgBonus);

  // Step 17: 结算伤害
  const finalDamage = damage * (1 + addDamage) * finalMultiplier;

  return { finalDamage, immune: false, showDodge: false };
}

//=============================================================================
// 四、属性伤害计算
//=============================================================================

/**
 * 应用属性伤害/抗性修正
 */
function applyElementalDamage(
  attacker: any,
  target: any,
  isPlayer: boolean
): { addDamage: number; multiplier: number } {
  let addDamage = 0;
  let multiplier = 1;

  // 金属性
  if (伤害函数.isMetalDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "金属性伤害");
    const resist = getRealAttrWithLimit(target, "金属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 木属性
  if (伤害函数.isWoodDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "木属性伤害");
    const resist = getRealAttrWithLimit(target, "木属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 水属性
  if (伤害函数.isWaterDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "水属性伤害");
    const resist = getRealAttrWithLimit(target, "水属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 火属性
  if (伤害函数.isFireDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "火属性伤害");
    const resist = getRealAttrWithLimit(target, "火属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 雷属性
  if (伤害函数.isThunderDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "雷属性伤害");
    const resist = getRealAttrWithLimit(target, "雷属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 光属性
  if (伤害函数.isLightDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "光属性伤害");
    const resist = getRealAttrWithLimit(target, "光属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  // 暗属性
  if (伤害函数.isDarkDamage()) {
    const dmg = calcElementalDamageBonus(attacker, "暗属性伤害");
    const resist = getRealAttrWithLimit(target, "暗属性抗性", isPlayer);
    if (dmg >= 0) addDamage += dmg;
    else multiplier *= (1 + dmg);
    multiplier *= (1 - resist);
  }

  return { addDamage, multiplier };
}

//=============================================================================
// 五、伤害事件处理
//=============================================================================

/**
 * 处理伤害事件
 * 在伤害回调中调用
 */
export function onDamageEvent(
  target: any,
  attacker: any,
  baseDamage: number
): void {
  if (target == null || baseDamage < 0.1) return;
  const snapshot = captureDamageTypeSnapshot();

  // 计算最终伤害
  const result = calculateDamage(target, attacker, baseDamage);

  // 免疫
  if (result.immune) {
    伤害函数.YDWESetEventDamage(0);
    notifyAppliedFinalDamageListeners(target, attacker, 0, snapshot);
    // 显示闪避（可选）
    if (result.showDodge) {
      // TODO: 显示闪避漂浮文字
    }
    return;
  }

  let finalDamage = result.finalDamage;
  if (finalDamage > 0) {
    finalDamage = applyDamageModifiers({
      target,
      attacker,
      baseDamage,
      currentDamage: finalDamage,
      isPhysicalDamage: snapshot.isPhysicalDamage,
      isMagicDamage: snapshot.isMagicDamage,
      isEnhancedDamage: snapshot.isEnhancedDamage,
      isTrueDamage: snapshot.isTrueDamage,
      isMetalDamage: snapshot.isMetalDamage,
      isWoodDamage: snapshot.isWoodDamage,
      isWaterDamage: snapshot.isWaterDamage,
      isFireDamage: snapshot.isFireDamage,
      isThunderDamage: snapshot.isThunderDamage,
      isLightDamage: snapshot.isLightDamage,
      isDarkDamage: snapshot.isDarkDamage,
      rawDamageType: snapshot.rawDamageType,
      isNormalAttack: snapshot.isNormalAttack,
      isRangedAttack: snapshot.isRangedAttack,
      isSkillAttack: snapshot.isSkillAttack,
      isSkillDamage: snapshot.isSkillDamage,
      isWrappedSkillDamage: snapshot.isWrappedSkillDamage,
      isEquipmentSkillDamage: snapshot.isEquipmentSkillDamage,
      isNonEquipmentSkillDamage: snapshot.isNonEquipmentSkillDamage,
      skillDamageSourceKind: snapshot.skillDamageSourceKind,
      equipmentSkillDamageKind: snapshot.equipmentSkillDamageKind,
      itemTypeId: snapshot.itemTypeId,
      itemHandle: snapshot.itemHandle,
      abilityId: snapshot.abilityId,
      skillInstanceId: snapshot.skillInstanceId,
      skillDamageTag: snapshot.skillDamageTag,
      skillDamageShape: snapshot.skillDamageShape,
      isIndependentSkillDamage: snapshot.isIndependentSkillDamage,
      isSingleTargetSkillDamage: snapshot.isSingleTargetSkillDamage,
      isAoeSkillDamage: snapshot.isAoeSkillDamage,
    });
  }

  // 设置最终伤害
  if (finalDamage !== baseDamage) {
    伤害函数.YDWESetEventDamage(finalDamage);
  }
  notifyAppliedFinalDamageListeners(target, attacker, finalDamage, snapshot);

  // 吸血吸魔
  applyLifeAndManaSteal(attacker, finalDamage, snapshot.isMagicDamage, snapshot.isNormalAttack, true);
}

export {};
