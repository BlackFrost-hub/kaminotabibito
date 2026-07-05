/** @noSelfInFile */
/**
 * 动态技能文本 - 属性计算
 *
 * 这里只保留当前动态文本白名单实际会用到的属性读取。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetHeroStr = jass.GetHeroStr as (hero: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (hero: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (hero: any, includeBonuses: boolean) => number;
const GetUnitState = jass.GetUnitState as (unit: any, whichState: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, whichState: number) => number;
const ConvertUnitState = jass.ConvertUnitState as (index: number) => number;
const { getRealAttr } = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getRealAttr: (unit: any, attrName: string, defaultValue: number) => number;
};

import type { 属性类型 } from "./01．公式配置";

/**
 * 根据属性类型获取英雄属性值。
 */
export function 获取属性值(this: void, unit: any, 属性: 属性类型): number {
  switch (属性) {
    case "力量":
      return GetHeroStr(unit, true);
    case "敏捷":
      return GetHeroAgi(unit, true);
    case "智力":
      return GetHeroInt(unit, true);
    case "攻击力":
      return GetUnitStateJapi(unit, ConvertUnitState(0x15));
    case "护甲":
      return GetUnitStateJapi(unit, ConvertUnitState(0x20));
    case "当前生命值":
      return GetUnitState(unit, jass.UNIT_STATE_LIFE);
    case "生命值":
      return GetUnitState(unit, jass.UNIT_STATE_LIFE);
    case "最大生命值":
      return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE);
    case "当前魔法值":
      return GetUnitState(unit, jass.UNIT_STATE_MANA);
    case "魔法值":
      return GetUnitState(unit, jass.UNIT_STATE_MANA);
    case "最大魔法值":
      return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
    case "主动技能伤害":
      return getRealAttr(unit, "主动技能伤害", 0);
    case "独立技能伤害":
      return getRealAttr(unit, "独立技能伤害", 0) + getRealAttr(unit, "主动技能伤害", 0);
    case "装备伤害":
      return getRealAttr(unit, "装备伤害", 0);
    case "攻击特效伤害":
      return getRealAttr(unit, "攻击特效伤害", 0);
    case "普攻强化伤害":
      return getRealAttr(unit, "普攻强化伤害", 0);
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
