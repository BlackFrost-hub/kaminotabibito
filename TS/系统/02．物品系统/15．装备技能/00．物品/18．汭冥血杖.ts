/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { getObjectPropertyRealSafe, ObjectType } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
  ObjectType: { UNIT: number };
};
const { 施加持续恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法") as {
  施加持续恢复生命魔法: (this: void, source: any, target: any, 参数: {
    BuffID: string;
    图标路径: string;
    特效路径: string;
    特效挂点: string;
    特效键: string;
    持续时间: number;
    间隔: number;
    每跳生命恢复: number;
    每跳魔法恢复: number;
  }) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitLevel = jass.GetUnitLevel as (unit: any) => number;
const IsUnitRace = jass.IsUnitRace as (unit: any, race: any) => boolean;
const IsHeroUnitId = jass.IsHeroUnitId as (unitId: number) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const RACE_DEMON = jass.RACE_DEMON as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
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

function 施加汭冥血杖恢复(this: void, 施法单位: any, 生命恢复值: number, 魔法恢复值: number): void {
  施加持续恢复生命魔法(施法单位, 施法单位, {
    BuffID: 汭冥血杖配置.BuffID,
    图标路径: 汭冥血杖配置.图标路径,
    特效路径: 汭冥血杖配置.恢复特效路径,
    特效挂点: 汭冥血杖配置.恢复特效挂点,
    特效键: 汭冥血杖配置.恢复特效键,
    持续时间: 汭冥血杖配置.恢复持续时间,
    间隔: 汭冥血杖配置.恢复间隔,
    每跳生命恢复: 生命恢复值,
    每跳魔法恢复: 魔法恢复值,
  });
}

export function 执行汭冥血杖献祭(this: void, 上下文: 物品技能事件上下文, 是否强化: boolean): void {
  主动物品调试日志("19．汭冥血杖", "进入", "执行汭冥血杖献祭");

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
    EXSetEffectSize(特效, getObjectPropertyRealSafe(ObjectType.UNIT, GetUnitTypeId(目标单位), "modelScale"));
  }

  const 敌人列表 = 获取坐标范围敌人(施法单位, 目标X, 目标Y, 汭冥血杖配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 施法单位)) continue;
    造成装备伤害(施法单位, 敌人, 目标最大生命 * 汭冥血杖配置.伤害生命系数, DAMAGE_TYPE_MAGIC, true);
  }

  KillUnit(目标单位);
  施加汭冥血杖恢复(施法单位, 生命恢复值, 魔法恢复值);
}

export function 处理汭冥血杖使用(this: void, 上下文: 物品技能事件上下文): void {  主动物品调试日志("19．汭冥血杖", "进入", "处理汭冥血杖使用");

  if (!是否为汭冥血杖(上下文.物品)) return;
  执行汭冥血杖献祭(上下文, false);
}

export {};
