/** @noSelfInFile */

import { 单位存活, 取当前生命, 取最大生命 } from "./09．装备战斗判断";
import { 装备小特效 } from "./11．装备常量";
import { 施加临时属性效果 } from "./19．临时属性效果";

const jass = require("jass.common") as any;

const { getUnitsInRange, getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 开始护盾, 护盾类型 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number; 魔法: number; 物理: number };
};
const { 清除单位负面Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  清除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, player: any) => boolean;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, attach: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export function 扣除当前生命比例(this: void, unit: any, ratio: number): void {
  if (!单位存活(unit) || !(ratio > 0)) return;
  const life = 取当前生命(unit);
  const cost = life * ratio;
  SetUnitState(unit, UNIT_STATE_LIFE, life - cost > 1 ? life - cost : 1);
}

export function 造成装备伤害(this: void, source: any, target: any, amount: number, damageType: any, ranged: boolean = false, weaponType: any = WEAPON_TYPE_WHOKNOWS): void {
  if (!单位存活(source) || !单位存活(target) || !(amount > 0)) return;
  UnitDamageTarget(source, target, amount, false, ranged, ATTACK_TYPE_NORMAL, damageType, weaponType);
}

export function 恢复生命魔法(this: void, source: any, target: any, hp: number, mp: number = 0, 默认魔法特效: boolean = false): void {
  if (target == null || target === 0) return;
  doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: hp,
    HealManaAmount: mp,
    ItemHeal: true,
    HealEffect: hp > 0,
    UseDefaultHealEffect: hp > 0,
    ManaEffect: 默认魔法特效 || mp > 0,
    UseDefaultManaEffect: 默认魔法特效 || mp > 0,
    ManaShowText: mp > 0,
  });
}

export function 播放点特效(this: void, model: string, x: number, y: number, 持续秒: number = 1): void {
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  addDelayedCallback(持续秒 * 1000, function 销毁点特效(this: void): void {
    if (effect != null && effect !== 0) DestroyEffect(effect);
  });
}

export function 播放单位特效(this: void, model: string, unit: any, attach: string = "origin", 持续秒: number = 1): void {
  if (unit == null || unit === 0 || model === "") return;
  const effect = AddSpecialEffectTarget(model, unit, attach);
  addDelayedCallback(持续秒 * 1000, function 销毁单位特效(this: void): void {
    if (effect != null && effect !== 0) DestroyEffect(effect);
  });
}

export function 取范围友方(this: void, source: any, radius: number): any[] {
  const result: any[] = [];
  if (!单位存活(source)) return result;
  const owner = GetOwningPlayer(source);
  const units = getUnitsInRange(GetUnitX(source), GetUnitY(source), radius);
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (单位存活(unit) && IsUnitAlly(unit, owner) === true) result.push(unit);
  }
  return result;
}

export function 取范围敌人(this: void, source: any, target: any, radius: number): any[] {
  if (!单位存活(source) || target == null || target === 0) return [];
  return getEnemyUnitsInRange(source, GetUnitX(target), GetUnitY(target), radius);
}

export function 开始通用护盾(this: void, source: any, target: any, amount: number, duration: number, tag: string): void {
  if (!单位存活(target) || !(amount > 0)) return;
  开始护盾(target, {
    类型: 护盾类型.通用,
    数值: amount,
    持续时间: duration,
    来源单位: source,
    标签: tag,
    显示护盾条: true,
    可驱散: true,
  });
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
}

export function 临时玩家属性(this: void, unit: any, attr: string, delta: number, duration: number): void {
  if (unit == null || unit === 0 || delta === 0 || !(duration > 0)) return;
  施加临时属性效果(unit, duration * 1000, [{ 类型: "玩家属性", 属性名: attr, 数值: delta }]);
}

export function 临时治疗率(this: void, unit: any, delta: number, duration: number): void {
  临时玩家属性(unit, "技能治疗率", delta, duration);
}

export function 临时受到治疗率(this: void, unit: any, delta: number, duration: number): void {
  临时玩家属性(unit, "受到的治疗率", delta, duration);
}

export function 净化负面(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && 清除单位负面Buff(unit, true) > 0;
}

export function 短暂无敌(this: void, unit: any, 秒数: number): void {
  if (!单位存活(unit) || !(秒数 > 0)) return;
  SetUnitInvulnerable(unit, true);
  addDelayedCallback(秒数 * 1000, function 结束短暂无敌(this: void): void {
    if (unit != null && unit !== 0) SetUnitInvulnerable(unit, false);
  });
}

export {};
