/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { getObjectPropertyReal, ObjectType } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  getObjectPropertyReal: (this: void, objectType: number, objectId: number | string, property: string) => number;
  ObjectType: { UNIT: number };
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { startHot } = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果") as {
  startHot: (this: void, target: any, source: any, tickHP: number, tickMP: number, duration: number, intervalOrOptions?: number | any, extraOptions?: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitLevel = jass.GetUnitLevel as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const IsUnitRace = jass.IsUnitRace as (unit: any, race: any) => boolean;
const IsHeroUnitId = jass.IsHeroUnitId as (unitId: number) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const RACE_DEMON = jass.RACE_DEMON as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 汭冥血杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 汭冥血杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为汭冥血杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 汭冥血杖物品ID;
}

function 目标可献祭(this: void, 目标单位: any, 等级上限: number): boolean {
  if (目标单位 == null || 目标单位 === 0) return false;
  if (IsUnitRace(目标单位, RACE_DEMON)) return false;
  if (IsHeroUnitId(GetUnitTypeId(目标单位))) return false;
  return GetUnitLevel(目标单位) <= 等级上限;
}

function 汭冥血杖结束条件恒真(this: void, _目标单位: any): boolean {
  return true;
}

function 施加汭冥血杖恢复(this: void, 施法单位: any, 生命恢复值: number, 魔法恢复值: number): void {
  registerManualBuff(施法单位, 汭冥血杖配置.BuffID, 汭冥血杖配置.恢复持续时间, 生命恢复值, {
    sourceName: GetUnitName(施法单位),
    iconOverride: 汭冥血杖配置.图标路径,
    effectModelOverride: 汭冥血杖配置.恢复特效路径,
  });
  startHot(施法单位, 施法单位, 生命恢复值, 魔法恢复值, 汭冥血杖配置.恢复持续时间, 汭冥血杖配置.恢复间隔, {
    结束条件检测: 汭冥血杖结束条件恒真,
    特效: {
      特效路径: 汭冥血杖配置.恢复特效路径,
      特效挂点: 汭冥血杖配置.恢复特效挂点,
      是否绑定单位: true,
      特效键: 汭冥血杖配置.恢复特效键,
    },
  });
}

export function 执行汭冥血杖献祭(this: void, 上下文: 物品技能事件上下文, 是否强化: boolean): void {
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 等级上限 = 是否强化 ? 汭冥血杖配置.强化等级上限 : 汭冥血杖配置.普通等级上限;
  if (!目标可献祭(目标单位, 等级上限)) return;

  const 目标最大生命 = GetUnitState(目标单位, UNIT_STATE_MAX_LIFE);
  const 生命恢复值 = 目标最大生命 * (是否强化 ? 汭冥血杖配置.强化生命恢复比例 : 汭冥血杖配置.普通生命恢复比例);
  const 魔法恢复值 = 是否强化 ? GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 汭冥血杖配置.强化魔法恢复比例 : 0;
  const 目标X = GetUnitX(目标单位);
  const 目标Y = GetUnitY(目标单位);

  const 特效 = createUnitEffect(目标单位, 汭冥血杖配置.特效挂点, 汭冥血杖配置.特效路径, 汭冥血杖配置.特效持续时间, "汭冥血杖");
  if (特效 != null && 特效 !== 0) {
    EXSetEffectSize(特效, getObjectPropertyReal(ObjectType.UNIT, GetUnitTypeId(目标单位), "modelScale"));
  }

  const 敌人列表 = 获取坐标范围敌人(施法单位, 目标X, 目标Y, 汭冥血杖配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 施法单位)) continue;
    UnitDamageTarget(施法单位, 敌人, 目标最大生命 * 汭冥血杖配置.伤害生命系数, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
  }

  KillUnit(目标单位);
  施加汭冥血杖恢复(施法单位, 生命恢复值, 魔法恢复值);
}

export function 处理汭冥血杖使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为汭冥血杖(上下文.物品)) return;
  执行汭冥血杖献祭(上下文, false);
}

export {};
