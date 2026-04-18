﻿﻿/**
 * 属性读取模块
 *
 * 功能：从单位/玩家读取属性值，应用玩家上限
 *
 * 重要：YDUserData 的属性名必须使用中文（STAT_CONFIG.name），不能使用英文key
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { STAT_LIMITS, ENEMY_STAT_LIMITS, BREAKABLE_LIMITS } = require("系统.04．伤害系统.00．伤害计算.00．伤害常量") as {
  STAT_LIMITS: Record<string, { max: number; min: number }>;
  ENEMY_STAT_LIMITS: Record<string, { max: number; min: number }>;
  BREAKABLE_LIMITS: Record<string, string>;
};
const { YDWEGetUnitArmor } = require("lib.扩展函数.YDWE函数.06．护甲获取") as {
  YDWEGetUnitArmor: (unit: any) => number;
};
const { isPlayerUnit: isPlayerUnitBase } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  isPlayerUnit: (unit: any) => boolean;
};

//=============================================================================
// 一、玩家判定
//=============================================================================

/**
 * 判断单位是否为玩家英雄
 * 玩家0-7为人类玩家，每个玩家只有一个英雄
 */
export function isPlayerUnit(unit: any): boolean {
  return isPlayerUnitBase(unit);
}

/**
 * 获取单位所属玩家ID
 */
export function getPlayerId(unit: any): number {
  if (unit == null) return -1;
  const owner = jass.GetOwningPlayer(unit);
  if (owner == null) return -1;
  return jass.GetPlayerId(owner);
}

//=============================================================================
// 二、属性读取函数
//=============================================================================

/**
 * 读取单位属性（优先单位属性，其次玩家属性）
 *
 * @param unit 目标单位
 * @param attrName 属性名（中文，如 "魔抗"、"物理伤害"）
 * @param valueType 值类型 "real" | "integer" | "boolean"
 * @param defaultValue 默认值
 */
export function getUnitAttr(
  unit: any,
  attrName: string,
  valueType: "real" | "integer" | "boolean",
  defaultValue: number | boolean = 0
): number | boolean {
  if (unit == null) return defaultValue;

  // 先尝试读取单位属性
  const unitValue = YDUserDataGet("unit", unit, attrName, valueType);

  // 如果单位有属性值，直接返回
  if (valueType === "real" || valueType === "integer") {
    const numValue = Number(unitValue);
    if (numValue !== 0) return numValue;
  } else if (valueType === "boolean") {
    if (unitValue === true || unitValue === 1) return true;
    if (unitValue === false || unitValue === 0) return false;
  }

  // 单位没有该属性，尝试读取玩家属性
  const player = jass.GetOwningPlayer(unit);
  if (player != null) {
    const playerValue = YDUserDataGet("player", player, attrName, valueType);
    if (valueType === "real" || valueType === "integer") {
      const numValue = Number(playerValue);
      if (numValue !== 0) return numValue;
    } else if (valueType === "boolean") {
      if (playerValue === true || playerValue === 1) return true;
    }
  }

  return defaultValue;
}

/**
 * 读取实数属性
 */
export function getRealAttr(unit: any, attrName: string, defaultValue: number = 0): number {
  return Number(getUnitAttr(unit, attrName, "real", defaultValue));
}

/**
 * 读取布尔属性
 */
export function getBoolAttr(unit: any, attrName: string, defaultValue: boolean = false): boolean {
  const value = getUnitAttr(unit, attrName, "boolean", defaultValue);
  return value === true || value === 1;
}

//=============================================================================
// 三、带上限的属性读取
//=============================================================================

/**
 * 读取属性并应用玩家上下限
 *
 * @param unit 目标单位
 * @param attrName 属性名（中文）
 * @param isPlayer 是否为玩家单位
 */
export function getRealAttrWithLimit(
  unit: any,
  attrName: string,
  isPlayer: boolean
): number {
  let value = getRealAttr(unit, attrName, 0);

  const limit = isPlayer ? STAT_LIMITS[attrName] : ENEMY_STAT_LIMITS[attrName];
  if (limit === undefined) return value;

  // 玩家可突破上限检查
  if (isPlayer) {
    const breakAttr = (BREAKABLE_LIMITS as Record<string, string>)[attrName];
    if (breakAttr != null) {
      const breakValue = getRealAttr(unit, breakAttr, 0);
      if (breakValue > 0) {
        if (value > breakValue) value = breakValue;
        if (value < limit.min) value = limit.min;
        return value;
      }
    }
  }

  if (value > limit.max) value = limit.max;
  if (value < limit.min) value = limit.min;

  return value;
}

//=============================================================================
// 四、常用属性读取快捷函数
//=============================================================================

/** 读取攻击者的伤害加成属性 */
export function getAttackerDamageBonus(attacker: any): number {
  return getRealAttr(attacker, "伤害%", 0);
}

/** 读取受击者的伤害减少% */
export function getTargetDamageReduction(target: any, isPlayer: boolean): number {
  return getRealAttrWithLimit(target, "伤害减少%", isPlayer);
}

/** 读取受击者的魔抗（应用上限） */
export function getTargetMagicResist(target: any, isPlayer: boolean): number {
  return getRealAttrWithLimit(target, "魔抗", isPlayer);
}

/** 读取受击者的物理抗性（应用上限） */
export function getTargetPhysResist(target: any, isPlayer: boolean): number {
  return getRealAttrWithLimit(target, "物理抗性", isPlayer);
}

/** 读取攻击者的护甲穿透 */
export function getAttackerArmorPierce(attacker: any): number {
  return getRealAttr(attacker, "护甲穿透", 0);
}

/** 读取攻击者的魔法穿透 */
export function getAttackerMagicPierce(attacker: any): number {
  return getRealAttr(attacker, "魔法穿透", 0);
}

/** 读取受击者护甲 */
export function getTargetArmor(target: any): number {
  return YDWEGetUnitArmor(target);
}

//=============================================================================
// 五、布尔属性快捷函数
//=============================================================================

/** 是否免疫伤害 */
export function isImmuneDamage(unit: any): boolean {
  return getBoolAttr(unit, "免疫伤害", false);
}

/** 是否免疫普攻 */
export function isImmuneNormalAttack(unit: any): boolean {
  return getBoolAttr(unit, "免疫普攻", false);
}

/** 是否减伤关闭 */
export function isDamageReduceDisabled(unit: any): boolean {
  return getBoolAttr(unit, "减伤关闭", false);
}

/** 是否无视护甲 */
export function isIgnoreArmor(attacker: any): boolean {
  return getBoolAttr(attacker, "无视护甲", false);
}

/** 是否无视魔抗 */
export function isIgnoreMagicResist(attacker: any): boolean {
  return getBoolAttr(attacker, "无视魔抗", false);
}

/** 是否伤害吸魔突破 */
export function canBreakManaStealLimit(unit: any): boolean {
  return getBoolAttr(unit, "伤害吸魔突破", false);
}

export {};
