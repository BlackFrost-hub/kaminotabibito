/** @noSelfInFile */
/**
 * 动态技能文本 - 属性计算
 *
 * 根据属性类型获取英雄的属性值，并计算公式结果
 */

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, whichState: number) => number;
const GetHeroInt = jass.GetHeroInt as (hero: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (hero: any, includeBonuses: boolean) => number;
const GetHeroStr = jass.GetHeroStr as (hero: any, includeBonuses: boolean) => number;

const UNIT_STATE_ATTACK = 21;
const UNIT_STATE_MAX_LIFE = 21;
const UNIT_STATE_LIFE = 35;

import type { 属性类型 } from "./01．公式配置";

function 获取攻击力(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_ATTACK);
}

function 获取最大生命值(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_MAX_LIFE);
}

function 获取当前生命值(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_LIFE);
}

function 获取智力(this: void, unit: any): number {
  return GetHeroInt(unit, true);
}

function 获取敏捷(this: void, unit: any): number {
  return GetHeroAgi(unit, true);
}

function 获取力量(this: void, unit: any): number {
  return GetHeroStr(unit, true);
}

/**
 * 根据属性类型获取英雄属性值
 */
export function 获取属性值(this: void, unit: any, 属性: 属性类型): number {
  switch (属性) {
    case "攻击力":
      return 获取攻击力(unit);
    case "最大生命值":
      return 获取最大生命值(unit);
    case "当前生命值":
      return 获取当前生命值(unit);
    case "智力":
      return 获取智力(unit);
    case "敏捷":
      return 获取敏捷(unit);
    case "力量":
      return 获取力量(unit);
    default:
      return 0;
  }
}

/**
 * 解析倍率字符串，例如 "3" -> 3, "50%" -> 0.5
 */
export function 解析倍率(this: void, 倍率字符串: string): number {
  if (倍率字符串.indexOf("%") >= 0) {
    const 数值 = parseFloat(倍率字符串.replace("%", ""));
    return 数值 / 100;
  }
  return parseFloat(倍率字符串);
}

/**
 * 计算公式结果：属性值 × 倍率
 */
export function 计算公式伤害(this: void, unit: any, 属性: 属性类型, 倍率字符串: string): number {
  const 属性值 = 获取属性值(unit, 属性);
  const 倍率 = 解析倍率(倍率字符串);
  return 属性值 * 倍率;
}
