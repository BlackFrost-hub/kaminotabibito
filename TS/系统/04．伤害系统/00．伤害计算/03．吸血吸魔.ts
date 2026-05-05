/** @noSelfInFile */
/**
 * 吸血与吸魔系统
 *
 * 功能：伤害吸血、魔法吸血、普攻吸血、伤害吸魔
 * 包含漂浮文字显示
 *
 * 特殊处理：马甲单位（UNIT_TYPE_ANCIENT）造成的伤害，吸血/吸魔给玩家英雄
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const {
  getRealAttr,
  getRealAttrWithLimit,
  isPlayerUnit,
  canBreakManaStealLimit,
} = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getRealAttr: (unit: any, attrName: string, defaultValue: number) => number;
  getRealAttrWithLimit: (unit: any, attrName: string, isPlayer: boolean) => number;
  isPlayerUnit: (unit: any) => boolean;
  canBreakManaStealLimit: (unit: any) => boolean;
};
const { STAT_LIMITS, ENEMY_STAT_LIMITS } = require("系统.04．伤害系统.00．伤害计算.00．伤害常量") as {
  STAT_LIMITS: Record<string, { max: number; min: number }>;
  ENEMY_STAT_LIMITS: Record<string, { max: number; min: number }>;
};
const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options: any) => any;
};
const CreateFloatTextOnUnit = 漂浮文字模块.CreateFloatTextOnUnit as
  | ((this: void, unit: any, text: string, options: any) => any)
  | undefined;
const { isAncientUnit, formatNumber, forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  isAncientUnit: (unit: any) => boolean;
  formatNumber: (num: number) => string;
  forEachUnitInGroup: (group: any, action: (unit: any) => void) => void;
};

//=============================================================================
// 一、吸血上限常量（统一使用 STAT_LIMITS）
//=============================================================================

//=============================================================================
// 二、马甲单位处理
//=============================================================================

/**
 * 获取玩家英雄组
 * 存储位置：YDUserDataGet("string", "玩家英雄", "单位组", "group")
 */
export function getPlayerHeroGroup(): any {
  try {
    return YDUserDataGet("string", "玩家英雄", "单位组", "group");
  } catch (_e) {
    return null;
  }
}

/**
 * 获取马甲单位所属玩家的英雄
 * 遍历玩家英雄组，找到属于同一玩家的英雄
 */
export function getHeroForAncientUnit(ancientUnit: any): any {
  if (ancientUnit == null) return null;

  const owner = jass.GetOwningPlayer(ancientUnit);
  if (owner == null) return null;

  const heroGroup = getPlayerHeroGroup();
  if (heroGroup == null) return null;

  let foundHero: any = null;

  forEachUnitInGroup(heroGroup, (enumUnit: any) => {
    if (enumUnit != null && jass.GetOwningPlayer(enumUnit) === owner) {
      if (jass.IsUnitType(enumUnit, jass.UNIT_TYPE_HERO)) {
        foundHero = enumUnit;
      }
    }
  });

  return foundHero;
}

/**
 * 获取吸血/吸魔的实际受益单位
 * - 普通单位：返回自身
 * - 马甲单位：返回所属玩家的英雄
 */
export function getStealBeneficiary(source: any): any {
  if (source == null) return null;

  // 马甲单位：找玩家英雄
  if (isAncientUnit(source)) {
    return getHeroForAncientUnit(source);
  }

  // 普通单位：返回自身
  return source;
}

//=============================================================================
// 二、吸血计算
//=============================================================================

/**
 * 计算伤害吸血
 *
 * @param attacker 攻击者
 * @param isPlayer 是否为玩家
 * @returns 吸血百分比
 */
export function calcLifeSteal(attacker: any, isPlayer: boolean): number {
  let lifeSteal = getRealAttr(attacker, "伤害吸血", 0);

  const limit = isPlayer ? STAT_LIMITS["伤害吸血"] : ENEMY_STAT_LIMITS["伤害吸血"];
  if (limit !== undefined) {
    if (isPlayer && lifeSteal > limit.max) {
      const breakLimit = getRealAttr(attacker, "伤害吸血上限", 0);
      lifeSteal = breakLimit > 0
        ? (lifeSteal < breakLimit ? lifeSteal : breakLimit)
        : limit.max;
    } else if (lifeSteal > limit.max) {
      lifeSteal = limit.max;
    }
    if (lifeSteal < limit.min) lifeSteal = limit.min;
  }

  return lifeSteal;
}

/**
 * 计算魔法伤害吸血
 *
 * @param attacker 攻击者
 * @param isPlayer 是否为玩家
 * @returns 吸血百分比
 */
export function calcMagicLifeSteal(attacker: any, isPlayer: boolean): number {
  let magicLifeSteal = getRealAttr(attacker, "魔法伤害吸血", 0);

  const limit = isPlayer ? STAT_LIMITS["魔法伤害吸血"] : ENEMY_STAT_LIMITS["魔法伤害吸血"];
  if (limit !== undefined) {
    if (magicLifeSteal > limit.max) magicLifeSteal = limit.max;
    if (magicLifeSteal < limit.min) magicLifeSteal = limit.min;
  }

  return magicLifeSteal;
}

/**
 * 计算普攻伤害吸血
 *
 * @param attacker 攻击者
 * @param isPlayer 是否为玩家
 * @returns 吸血百分比
 */
export function calcNormalAttackLifeSteal(attacker: any, isPlayer: boolean): number {
  let atkLifeSteal = getRealAttr(attacker, "普攻伤害吸血", 0);

  const limit = isPlayer ? STAT_LIMITS["普攻伤害吸血"] : ENEMY_STAT_LIMITS["普攻伤害吸血"];
  if (limit !== undefined) {
    if (atkLifeSteal > limit.max) atkLifeSteal = limit.max;
    if (atkLifeSteal < limit.min) atkLifeSteal = limit.min;
  }

  return atkLifeSteal;
}

/**
 * 计算总吸血百分比
 *
 * @param attacker 攻击者
 * @param isPlayer 是否为玩家
 * @param isMagic 是否魔法伤害
 * @param isNormalAttack 是否普攻
 */
export function calcTotalLifeSteal(
  attacker: any,
  isPlayer: boolean,
  isMagic: boolean,
  isNormalAttack: boolean
): number {
  let total = calcLifeSteal(attacker, isPlayer);

  // 魔法伤害吸血
  if (isMagic) {
    total += calcMagicLifeSteal(attacker, isPlayer);
  }

  // 普攻吸血
  if (isNormalAttack) {
    total += calcNormalAttackLifeSteal(attacker, isPlayer);
  }

  return total;
}

//=============================================================================
// 三、吸血回复计算
//=============================================================================

/**
 * 计算吸血回复值
 *
 * @param attacker 攻击者
 * @param damage 最终伤害
 * @param isMagic 是否魔法伤害
 * @param isNormalAttack 是否普攻
 * @returns 回复值
 */
export function calcLifeStealHeal(
  attacker: any,
  damage: number,
  isMagic: boolean,
  isNormalAttack: boolean
): number {
  const isPlayer = isPlayerUnit(attacker);
  const lifeStealPercent = calcTotalLifeSteal(attacker, isPlayer, isMagic, isNormalAttack);

  if (lifeStealPercent <= 0) return 0;

  // 基础回复值
  let heal = damage * lifeStealPercent;

  // 应用受到的治疗率
  const healReceived = getRealAttr(attacker, "受到的治疗率", 0);
  if (healReceived !== 0) {
    heal *= (1 + healReceived);
  }

  return heal;
}

/**
 * 执行吸血回复
 *
 * @param attacker 攻击者
 * @param heal 回复值
 * @param showText 是否显示漂浮文字
 */
export function applyLifeSteal(
  attacker: any,
  heal: number,
  showText: boolean = true
): void {
  if (heal <= 0 || attacker == null) return;

  // 获取当前生命
  const currentLife = jass.GetUnitState(attacker, jass.UNIT_STATE_LIFE);
  const maxLife = jass.GetUnitState(attacker, jass.UNIT_STATE_MAX_LIFE);

  // 不能超过最大生命
  const lifeGap = maxLife - currentLife;
  const actualHeal = heal < lifeGap ? heal : lifeGap;
  if (actualHeal <= 0) return;

  // 回复生命
  jass.SetUnitState(attacker, jass.UNIT_STATE_LIFE, currentLife + actualHeal);

  // 显示漂浮文字
  if (showText) {
    showLifeStealText(attacker, actualHeal);
  }
}

//=============================================================================
// 四、伤害吸魔
//=============================================================================

/**
 * 计算伤害吸魔
 *
 * @param attacker 攻击者
 * @param damage 最终伤害
 * @returns 吸魔值
 */
export function calcManaSteal(attacker: any, damage: number): number {
  if (!jass.IsUnitType(attacker, jass.UNIT_TYPE_HERO)) return 0;

  const isPlayer = isPlayerUnit(attacker);
  let manaStealPercent = getRealAttr(attacker, "伤害吸魔", 0);

  if (manaStealPercent <= 0) return 0;

  const limit = isPlayer ? STAT_LIMITS["伤害吸魔"] : ENEMY_STAT_LIMITS["伤害吸魔"];
  if (limit !== undefined) {
    if (isPlayer && manaStealPercent > limit.max && !canBreakManaStealLimit(attacker)) {
      manaStealPercent = limit.max;
    } else if (manaStealPercent > limit.max) {
      manaStealPercent = limit.max;
    }
    if (manaStealPercent < limit.min) manaStealPercent = limit.min;
  }

  return damage * manaStealPercent;
}

/**
 * 执行伤害吸魔
 *
 * @param attacker 攻击者
 * @param mana 回复值
 * @param showText 是否显示漂浮文字
 */
export function applyManaSteal(
  attacker: any,
  mana: number,
  showText: boolean = true
): void {
  if (mana <= 0 || attacker == null) return;

  // 获取当前魔法
  const currentMana = jass.GetUnitState(attacker, jass.UNIT_STATE_MANA);
  const maxMana = jass.GetUnitState(attacker, jass.UNIT_STATE_MAX_MANA);

  // 不能超过最大魔法
  const manaGap = maxMana - currentMana;
  const actualMana = mana < manaGap ? mana : manaGap;
  if (actualMana <= 0) return;

  // 回复魔法
  jass.SetUnitState(attacker, jass.UNIT_STATE_MANA, currentMana + actualMana);

  // 显示漂浮文字
  if (showText) {
    showManaStealText(attacker, actualMana);
  }
}

//=============================================================================
// 五、漂浮文字显示
//=============================================================================

/** 吸血漂浮文字颜色（绿色） */
const LIFE_STEAL_TEXT_COLOR = { red: 0, green: 255, blue: 0, alpha: 0 };

/** 吸魔漂浮文字颜色（蓝色） */
const MANA_STEAL_TEXT_COLOR = { red: 0, green: 150, blue: 255, alpha: 0 };

/**
 * 显示吸血漂浮文字
 */
function showLifeStealText(this: void, unit: any, heal: number): void {
  if (typeof CreateFloatTextOnUnit !== "function") return;
  const text = "+" + formatNumber(heal);
  CreateFloatTextOnUnit(unit, text, {
    size: 10,
    red: LIFE_STEAL_TEXT_COLOR.red,
    green: LIFE_STEAL_TEXT_COLOR.green,
    blue: LIFE_STEAL_TEXT_COLOR.blue,
    alpha: LIFE_STEAL_TEXT_COLOR.alpha,
    duration: 1.5,
    speedY: 0.03,
    height: 0.5,
  });
}

/**
 * 显示吸魔漂浮文字
 */
function showManaStealText(this: void, unit: any, mana: number): void {
  if (typeof CreateFloatTextOnUnit !== "function") return;
  const text = "+" + formatNumber(mana);
  CreateFloatTextOnUnit(unit, text, {
    size: 10,
    red: MANA_STEAL_TEXT_COLOR.red,
    green: MANA_STEAL_TEXT_COLOR.green,
    blue: MANA_STEAL_TEXT_COLOR.blue,
    alpha: MANA_STEAL_TEXT_COLOR.alpha,
    duration: 1.5,
    speedY: 0.03,
    height: 0.3,
  });
}

//=============================================================================
// 六、统一吸血吸魔接口
//=============================================================================

/**
 * 执行吸血和吸魔
 *
 * @param attacker 攻击者（可能是马甲单位）
 * @param damage 最终伤害
 * @param isMagic 是否魔法伤害
 * @param isNormalAttack 是否普攻
 * @param showText 是否显示漂浮文字
 */
export function applyLifeAndManaSteal(
  attacker: any,
  damage: number,
  isMagic: boolean,
  isNormalAttack: boolean,
  showText: boolean = true
): void {
  // 获取实际受益单位（马甲单位 -> 玩家英雄）
  const beneficiary = getStealBeneficiary(attacker);
  if (beneficiary == null) return;

  // 吸血
  const heal = calcLifeStealHeal(beneficiary, damage, isMagic, isNormalAttack);
  if (heal > 0) {
    applyLifeSteal(beneficiary, heal, showText);
  }

  // 吸魔
  const mana = calcManaSteal(beneficiary, damage);
  if (mana > 0) {
    applyManaSteal(beneficiary, mana, showText);
  }
}

export {};
