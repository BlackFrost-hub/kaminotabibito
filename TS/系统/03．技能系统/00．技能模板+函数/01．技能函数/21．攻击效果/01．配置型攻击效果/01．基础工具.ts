/** @noSelfInFile */

import type { 配置型攻击效果伤害类型 } from "./00．类型定义";
import type { 技能伤害形态, 装备技能伤害类型 } from "../../../../../04．伤害系统/08．技能伤害系统";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 减少生命值, 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, lowestLife?: number) => number;
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 是否精英单位 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断") as {
  是否精英单位: (this: void, unit: any) => boolean;
};
const { 快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff") as {
  快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params: any) => number;
};
const { 开始原地击飞 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统") as {
  开始原地击飞: (this: void, unit: any, params: any) => number;
};
const { 造成装备技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成装备技能伤害: (this: void, 参数: any) => boolean;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (value: number) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetHeroStr = jass.GetHeroStr as (unit: any, includeBonuses: boolean) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const DAMAGE_TYPE_SLOW_POISON = jass.DAMAGE_TYPE_SLOW_POISON as any;
const DAMAGE_TYPE_ACID = jass.DAMAGE_TYPE_ACID as any;
const DAMAGE_TYPE_DISEASE = jass.DAMAGE_TYPE_DISEASE as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const DAMAGE_TYPE_SONIC = jass.DAMAGE_TYPE_SONIC as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_DIVINE = (jass.DAMAGE_TYPE_DIVINE ?? jass.DAMAGE_TYPE_UNIVERSAL) as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export interface 配置型攻击效果伤害标记 {
  伤害形态?: 技能伤害形态;
  装备技能类型?: 装备技能伤害类型;
  标签?: string;
  参与技能伤害加成?: boolean;
}

export function 配置型单位有效存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

export function 配置型单位是精英目标(this: void, unit: any): boolean {
  if (!配置型单位有效存活(unit)) return false;
  return 是否精英单位(unit) === true;
}

export function 配置型取单位X(this: void, unit: any): number {
  return GetUnitX(unit);
}

export function 配置型取单位Y(this: void, unit: any): number {
  return GetUnitY(unit);
}

export function 配置型取当前生命(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_LIFE);
}

export function 配置型取最大生命(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE);
}

export function 配置型取最大魔法(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
}

export function 配置型取攻击力(this: void, unit: any): number {
  return GetUnitStateJapi(unit, ConvertUnitState(0x15));
}

export function 配置型取力量(this: void, unit: any): number {
  if (!配置型单位有效存活(unit) || IsUnitType(unit, UNIT_TYPE_HERO) !== true) return 0;
  return GetHeroStr(unit, true);
}

export function 解析配置型攻击效果伤害类型(this: void, 类型?: 配置型攻击效果伤害类型 | any): any {
  if (类型 != null && typeof 类型 !== "string") return 类型;
  if (类型 === "精神") return DAMAGE_TYPE_MIND;
  if (类型 === "魔法") return DAMAGE_TYPE_MAGIC;
  if (类型 === "火焰" || 类型 === "火") return DAMAGE_TYPE_FIRE;
  if (类型 === "水" || 类型 === "冰") return DAMAGE_TYPE_COLD;
  if (类型 === "雷") return DAMAGE_TYPE_LIGHTNING;
  if (类型 === "毒素" || 类型 === "毒" || 类型 === "金") return DAMAGE_TYPE_POISON;
  if (类型 === "缓毒") return DAMAGE_TYPE_SLOW_POISON;
  if (类型 === "酸") return DAMAGE_TYPE_ACID;
  if (类型 === "疾病") return DAMAGE_TYPE_DISEASE;
  if (类型 === "风" || 类型 === "木") return DAMAGE_TYPE_PLANT;
  if (类型 === "暗影" || 类型 === "暗") return DAMAGE_TYPE_SHADOW_STRIKE;
  if (类型 === "神圣" || 类型 === "光") return DAMAGE_TYPE_DIVINE;
  if (类型 === "音速") return DAMAGE_TYPE_SONIC;
  if (类型 === "强化") return DAMAGE_TYPE_ENHANCED;
  if (类型 === "通用") return DAMAGE_TYPE_UNIVERSAL;
  return DAMAGE_TYPE_NORMAL;
}

export function 配置型攻击效果造成伤害(this: void, source: any, target: any, amount: number, 类型?: 配置型攻击效果伤害类型, 标记?: 配置型攻击效果伤害标记): void {
  if (!配置型单位有效存活(source) || !配置型单位有效存活(target) || !(amount > 0)) return;
  造成装备技能伤害({
    来源: source,
    目标: target,
    伤害: amount,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: 解析配置型攻击效果伤害类型(类型),
    weaponType: WEAPON_TYPE_WHOKNOWS,
    装备技能类型: 标记?.装备技能类型 ?? "攻击特效",
    伤害形态: 标记?.伤害形态 ?? "单体",
    标签: 标记?.标签,
    参与技能伤害加成: 标记?.参与技能伤害加成,
  });
}

export function 配置型攻击效果治疗生命魔法(this: void, source: any, target: any, lifeAmount: number, manaAmount: number = 0): void {
  if (!配置型单位有效存活(target)) return;
  if (!(lifeAmount > 0) && !(manaAmount > 0)) return;
  doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: lifeAmount > 0 ? lifeAmount : 0,
    HealManaAmount: manaAmount > 0 ? manaAmount : 0,
    ItemHeal: true,
    HealEffect: lifeAmount > 0,
    ManaEffect: manaAmount > 0,
    ManaShowText: manaAmount > 0,
  });
}

export function 配置型攻击效果减少生命魔法(this: void, target: any, lifeAmount: number, manaAmount: number): void {
  if (!配置型单位有效存活(target)) return;
  if (lifeAmount > 0) 减少生命值(target, lifeAmount, true, true, undefined, 1);
  if (manaAmount > 0) 减少魔法值(target, manaAmount, true, true);
}

export function 配置型获取敌方范围单位(this: void, source: any, center: any, radius: number, includeCenter: boolean = false): any[] {
  if (!配置型单位有效存活(source) || !配置型单位有效存活(center) || !(radius > 0)) return [];
  const list = getUnitsInRange(配置型取单位X(center), 配置型取单位Y(center), radius);
  const result: any[] = [];
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    if (!配置型单位有效存活(unit)) continue;
    if (!includeCenter && unit === center) continue;
    if (isUnitEnemy(unit, source) !== true) continue;
    result.push(unit);
  }
  return result;
}

export function 配置型播放目标特效(this: void, target: any, model: string, attach: string = "origin"): void {
  if (!配置型单位有效存活(target) || model === "") return;
  const effect = AddSpecialEffectTarget(model, target, attach);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export function 配置型播放单位坐标特效(this: void, target: any, model: string, scale?: number): void {
  if (!配置型单位有效存活(target) || model === "") return;
  const effect = AddSpecialEffect(model, GetUnitX(target), GetUnitY(target));
  if (effect == null || effect === 0) return;
  if (scale != null && scale > 0) {
    EXSetEffectSize(effect, scale);
  }
  DestroyEffect(effect);
}

export function 配置型施加减速(this: void, source: any, target: any, amount: number, duration: number): void {
  if (!(amount > 0) || !(duration > 0)) return;
  快速减速Buff(source, target, amount, amount, duration);
}

export function 配置型施加眩晕(this: void, source: any, target: any, duration: number): void {
  if (!(duration > 0)) return;
  施加扩展控制(source, target, "stun", { 持续时间: duration });
}

export function 配置型施加击飞(this: void, source: any, target: any, duration: number): void {
  if (!(duration > 0)) return;
  开始原地击飞(target, {
    持续时间: duration,
    主单位: source,
    主单位死亡时中断: true,
    暂停单位: true,
    中断已有跳跃: true,
  });
}

export function 配置型临时修改攻速(this: void, unit: any, value: number): void {
  if (!配置型单位有效存活(unit) || value === 0) return;
  SGSS_SetState(unit, 10, value);
}

export {};
