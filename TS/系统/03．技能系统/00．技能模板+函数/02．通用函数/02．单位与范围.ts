/**
 * 通用函数 - 单位与范围便捷入口
 *
 * 说明：
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 友军相关 4 个判断保留在技能侧包装层，避免继续依赖已恢复为 git 最新版的 lib 导出集合。
 */

const jass = require("jass.common") as any;

export {
  createUnitWithOptions,
  getPlayerFirstHero,
} from "../../../../lib/扩展函数/自定义扩展函数/00．单位相关";

export {
  getUnitsInRangeOfUnit,
  getUnitsInRange,
  getEnemyUnitsInRangeOfUnit,
  getEnemyUnitsInRange,
} from "../../../../lib/扩展函数/自定义扩展函数/01．选取中心范围";

export {
  isValidUnit,
  isUnitEnemy,
  isValidEnemyUnit,
  isNotUsingInventoryItem,
} from "../../../../lib/扩展函数/自定义扩展函数/02．条件判断函数";

import {
  createUnitWithOptions,
  getPlayerFirstHero,
} from "../../../../lib/扩展函数/自定义扩展函数/00．单位相关";

import {
  getUnitsInRangeOfUnit,
  getUnitsInRange,
  getEnemyUnitsInRangeOfUnit,
  getEnemyUnitsInRange,
} from "../../../../lib/扩展函数/自定义扩展函数/01．选取中心范围";

import {
  isValidUnit,
  isUnitEnemy,
  isValidEnemyUnit,
  isNotUsingInventoryItem,
} from "../../../../lib/扩展函数/自定义扩展函数/02．条件判断函数";

export function isSameUnit(a: any, b: any): boolean {
  return a != null && a !== 0 && b != null && b !== 0 && a === b;
}

export function isUnitAlly(targetUnit: any, sourceUnit: any): boolean {
  if (targetUnit == null || targetUnit === 0) return false;
  if (sourceUnit == null || sourceUnit === 0) return false;
  return jass.IsPlayerAlly(jass.GetOwningPlayer(targetUnit), jass.GetOwningPlayer(sourceUnit)) === true;
}

export function isValidAllyUnit(targetUnit: any, sourceUnit: any): boolean {
  return isValidUnit(targetUnit) && isUnitAlly(targetUnit, sourceUnit);
}

export function isValidAllyUnitExcludeSelf(targetUnit: any, sourceUnit: any): boolean {
  return isValidAllyUnit(targetUnit, sourceUnit) && !isSameUnit(targetUnit, sourceUnit);
}

export const 创建单位并设置参数 = createUnitWithOptions;
export const 获取玩家首个英雄 = getPlayerFirstHero;

export const 获取单位周围单位 = getUnitsInRangeOfUnit;
export const 获取坐标范围单位 = getUnitsInRange;
export const 获取单位周围敌人 = getEnemyUnitsInRangeOfUnit;
export const 获取坐标范围敌人 = getEnemyUnitsInRange;

export const 单位是否有效 = isValidUnit;
export const 是否同一单位 = isSameUnit;
export const 单位是否友军 = isUnitAlly;
export const 单位是否有效且友军 = isValidAllyUnit;
export const 单位是否有效友军且排除自身 = isValidAllyUnitExcludeSelf;
export const 单位是否敌对 = isUnitEnemy;
export const 单位是否有效且敌对 = isValidEnemyUnit;
export const 单位当前是否未在用物品 = isNotUsingInventoryItem;
