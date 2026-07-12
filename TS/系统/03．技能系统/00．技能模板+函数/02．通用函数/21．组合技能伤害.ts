/** @noSelfInFile */

import { 读取单位攻击力 } from "./19．战斗公共工具";

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export interface 组合技能伤害参数 {
  来源攻击力比例?: number;
  来源最大生命比例?: number;
  来源当前生命比例?: number;
  来源已损生命比例?: number;
  目标最大生命比例?: number;
  目标当前生命比例?: number;
  目标已损生命比例?: number;
  固定值?: number;
  总倍率?: number;
  最小值?: number;
  最大值?: number;
}

function 取当前生命(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitState(unit, UNIT_STATE_LIFE);
  return value > 0 ? value : 0;
}

function 取最大生命(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  return value > 0 ? value : 0;
}

function 取已损生命(this: void, unit: any): number {
  const value = 取最大生命(unit) - 取当前生命(unit);
  return value > 0 ? value : 0;
}

export function 计算组合技能伤害(this: void, 来源: any, 目标: any, 参数: 组合技能伤害参数): number {
  let damage = 参数.固定值 ?? 0;
  damage += 读取单位攻击力(来源) * (参数.来源攻击力比例 ?? 0);
  damage += 取最大生命(来源) * (参数.来源最大生命比例 ?? 0);
  damage += 取当前生命(来源) * (参数.来源当前生命比例 ?? 0);
  damage += 取已损生命(来源) * (参数.来源已损生命比例 ?? 0);
  damage += 取最大生命(目标) * (参数.目标最大生命比例 ?? 0);
  damage += 取当前生命(目标) * (参数.目标当前生命比例 ?? 0);
  damage += 取已损生命(目标) * (参数.目标已损生命比例 ?? 0);
  damage *= 参数.总倍率 ?? 1;
  if (参数.最小值 != null && damage < 参数.最小值) damage = 参数.最小值;
  if (参数.最大值 != null && damage > 参数.最大值) damage = 参数.最大值;
  return damage > 0 ? damage : 0;
}

