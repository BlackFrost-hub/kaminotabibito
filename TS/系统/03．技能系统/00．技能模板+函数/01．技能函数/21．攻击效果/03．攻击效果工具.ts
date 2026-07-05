/** @noSelfInFile */

import type { 技能伤害来源类型, 技能伤害形态, 装备技能伤害类型 } from "../../../../04．伤害系统/08．技能伤害系统";

const jass = require("jass.common") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const {
  createTimedEffect,
  创建Dz绑定单位特效,
  销毁Dz绑定单位特效,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export interface 攻击效果伤害标记选项 {
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  伤害形态?: 技能伤害形态;
  物品ID?: number;
  物品实例?: any;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
  参与技能伤害加成?: boolean;
}

export interface 攻击效果延迟伤害参数 {
  延迟毫秒: number;
  来源单位: any;
  目标单位: any;
  伤害: number;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  伤害标记?: 攻击效果伤害标记选项;
  回调?: (this: void) => void;
}

export interface 攻击效果范围伤害参数 {
  来源单位: any;
  中心单位?: any;
  伤害: number;
  半径: number;
  是否敌军?: boolean;
  包含中心单位?: boolean;
  过滤器?: (this: void, unit: any) => boolean;
  命中回调?: (this: void, unit: any) => void;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  伤害标记?: 攻击效果伤害标记选项;
}

export function 攻击效果创建地面特效(
  this: void,
  modelPath: string,
  x: number,
  y: number,
  durationSec?: number,
  z?: number,
): any {
  if (!modelPath) return null;
  return createTimedEffect(modelPath, x, y, z ?? 0, durationSec);
}

export function 攻击效果创建绑定特效(
  this: void,
  unit: any,
  attachPoint: string,
  modelPath: string,
  effectKey?: string,
): any {
  if (unit == null || unit === 0 || !modelPath) return null;
  return 创建Dz绑定单位特效(unit, attachPoint, modelPath, effectKey);
}

export function 攻击效果销毁绑定特效(this: void, unit: any, effectKey?: string): void {
  if (unit == null || unit === 0) return;
  销毁Dz绑定单位特效(unit, effectKey);
}

export function 攻击效果延迟执行(this: void, 延迟毫秒: number, 回调: () => void): number {
  if (!(延迟毫秒 >= 0) || 回调 == null) return 0;
  return addDelayedCallback(延迟毫秒, 回调);
}

export function 攻击效果延迟伤害(this: void, 参数: 攻击效果延迟伤害参数): number {
  if (参数 == null || 参数.来源单位 == null || 参数.来源单位 === 0 || 参数.目标单位 == null || 参数.目标单位 === 0) {
    return 0;
  }
  if (!(参数.伤害 > 0)) return 0;

  return 攻击效果延迟执行(参数.延迟毫秒, function 攻击效果延迟伤害回调(this: void): void {
    const 标记 = 参数.伤害标记;
    造成技能伤害({
      来源: 参数.来源单位,
      目标: 参数.目标单位,
      伤害: 参数.伤害,
      attackType: 参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
      伤害类型: 参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
      weaponType: 参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
      来源类型: 标记?.来源类型 ?? 标记?.装备技能类型 ?? "装备被动",
      装备技能类型: 标记?.装备技能类型,
      伤害形态: 标记?.伤害形态 ?? "单体",
      物品ID: 标记?.物品ID,
      物品实例: 标记?.物品实例,
      技能ID: 标记?.技能ID,
      技能实例ID: 标记?.技能实例ID,
      标签: 标记?.标签,
      参与技能伤害加成: 标记?.参与技能伤害加成,
    });
    if (参数.回调 != null) {
      参数.回调();
    }
  });
}

export function 攻击效果获取范围单位(
  this: void,
  中心单位: any,
  半径: number,
  是否敌军 = true,
  包含中心单位 = false,
  过滤器?: (this: void, unit: any) => boolean,
): any[] {
  if (中心单位 == null || 中心单位 === 0 || !(半径 > 0)) return [];

  const x = GetUnitX(中心单位);
  const y = GetUnitY(中心单位);
  const 单位列表 = getUnitsInRange(x, y, 半径);
  const 结果: any[] = [];

  for (let i = 0; i < 单位列表.length; i++) {
    const unit = 单位列表[i];
    if (unit == null || unit === 0) continue;
    if (!包含中心单位 && unit === 中心单位) continue;
    if (是否敌军 && isUnitEnemy(unit, 中心单位) !== true) continue;
    if (过滤器 != null && 过滤器(unit) === false) continue;
    结果.push(unit);
  }

  return 结果;
}

export function 攻击效果范围伤害(this: void, 参数: 攻击效果范围伤害参数): void {
  if (参数 == null || 参数.来源单位 == null || 参数.来源单位 === 0 || !(参数.伤害 > 0) || !(参数.半径 > 0)) {
    return;
  }

  const 中心单位 = 参数.中心单位 ?? 参数.来源单位;
  const 单位列表 = 攻击效果获取范围单位(
    中心单位,
    参数.半径,
    参数.是否敌军 !== false,
    参数.包含中心单位 === true,
    参数.过滤器,
  );

  for (let i = 0; i < 单位列表.length; i++) {
    const unit = 单位列表[i];
    if (unit == null || unit === 0) continue;
    const 标记 = 参数.伤害标记;
    造成技能伤害({
      来源: 参数.来源单位,
      目标: unit,
      伤害: 参数.伤害,
      attackType: 参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
      伤害类型: 参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
      weaponType: 参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
      来源类型: 标记?.来源类型 ?? 标记?.装备技能类型 ?? "装备被动",
      装备技能类型: 标记?.装备技能类型,
      伤害形态: 标记?.伤害形态 ?? "AOE",
      物品ID: 标记?.物品ID,
      物品实例: 标记?.物品实例,
      技能ID: 标记?.技能ID,
      技能实例ID: 标记?.技能实例ID,
      标签: 标记?.标签,
      参与技能伤害加成: 标记?.参与技能伤害加成,
    });
    if (参数.命中回调 != null) {
      参数.命中回调(unit);
    }
  }
}

export {};
