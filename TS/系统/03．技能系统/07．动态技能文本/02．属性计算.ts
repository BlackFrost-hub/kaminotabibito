/** @noSelfInFile */
/**
 * 动态技能文本 - 属性计算
 *
 * 这里只保留当前动态文本白名单实际会用到的属性读取。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const 调试输出模块 = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (module: string, ...args: any[]) => void;
};
const { debugLogForce } = 调试输出模块;

const GetHeroStr = jass.GetHeroStr as (hero: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (hero: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (hero: any, includeBonuses: boolean) => number;
const GetUnitState = jass.GetUnitState as (unit: any, whichState: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, whichState: number) => number;
const ConvertUnitState = jass.ConvertUnitState as (index: number) => number;

import type { 属性类型 } from "./01．公式配置";

const MODULE_NAME = "动态技能文本";

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
    case "生命值":
      return GetUnitState(unit, jass.UNIT_STATE_LIFE);
    case "最大生命值":
      return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE);
    case "魔法值":
      return GetUnitState(unit, jass.UNIT_STATE_MANA);
    case "最大魔法值":
      return GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
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
  const 结果 = 属性值 * 倍率;
  if (属性 === "最大生命值" || 属性 === "最大魔法值") {
    debugLogForce(MODULE_NAME, "公式计算", "属性=", 属性, "倍率=", 倍率字符串, "属性值=", 属性值, "结果=", 结果);
  }
  return 结果;
}
