/** @noSelfInFile */
// 塞拉斯被动：远程普攻属性附加（源 被动效果，配合Q.j）。
// 触发：H014 的普通攻击命中 500 码以外的非玩家拥有敌方目标，且存在火/冰/雷攻击标记。
// 效果：0.12 秒后在被击目标位置（审计：JASS 真源为受击者坐标）350 范围内追加
// 「攻击者当前魔法值 × 40%」对应元素伤害，并消费标记。追加伤害走统一封装，
// 来源类型为「普攻强化」而非普通攻击，天然不会再次触发本被动；灼烧周期伤害同理。

import { 塞拉斯技能配置 } from "./00．配置";
import { 塞拉斯BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/06．塞拉斯";
import { 消费塞拉斯攻击标记, 塞拉斯拥有任意攻击标记 } from "./01．状态表";

const jass = require("jass.common") as any;

const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (this: void, unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    intervalSeconds?: number,
  ) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军, 在坐标播放特效 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};
const { 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (this: void, unit: any, player: any) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

const 配置 = 塞拉斯技能配置;
const 被动配置 = 配置.被动;
const 英雄单位类型ID = 配置.单位类型ID;

interface 被动追加载荷 {
  caster: any;
  目标X: number;
  目标Y: number;
  火: boolean;
  冰: boolean;
  雷: boolean;
}

function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 过滤被动追加标的(this: void, 敌军列表: any[]): any[] {
  const result: any[] = [];
  for (let i = 0; i < 敌军列表.length; i++) {
    const u = 敌军列表[i];
    if (u == null || u === 0) continue;
    if (IsUnitType(u, UNIT_TYPE_ANCIENT) || IsUnitType(u, UNIT_TYPE_MECHANICAL) || IsUnitType(u, UNIT_TYPE_STRUCTURE)) continue;
    result.push(u);
  }
  return result;
}

function 执行被动追加伤害(this: void, variable?: any): void {
  const payload = variable as 被动追加载荷 | undefined;
  if (payload == null) return;
  const caster = payload.caster;
  if (caster == null || caster === 0 || GetUnitTypeId(caster) !== 英雄单位类型ID) return;

  // 元素特效在施法载荷坐标播放（源 JASS 于受击目标位置）
  if (payload.火) {
    在坐标播放特效(被动配置.火焰特效.模型路径, payload.目标X, payload.目标Y, 0, 被动配置.火焰特效.缩放, 被动配置.火焰特效.持续秒);
  } else if (payload.雷) {
    在坐标播放特效(被动配置.雷击特效.模型路径, payload.目标X, payload.目标Y, 0, 被动配置.雷击特效.缩放, 被动配置.雷击特效.持续秒);
  } else if (payload.冰) {
    在坐标播放特效(被动配置.冰冻特效.模型路径, payload.目标X, payload.目标Y, 0, 被动配置.冰冻特效.缩放, 被动配置.冰冻特效.持续秒);
  } else {
    return;
  }

  // 伤害在结算时读取攻击者当前魔法值（源 JASS 于延迟结算时读取）
  const 伤害 = GetUnitState(caster, UNIT_STATE_MANA) * 被动配置.当前魔法值伤害比例;
  if (!(伤害 > 0)) return;

  // 伤害元素优先级 火 > 雷 > 冰（源 JASS 分支顺序）
  const 伤害类型 = payload.火 ? jass.DAMAGE_TYPE_FIRE : payload.雷 ? jass.DAMAGE_TYPE_LIGHTNING : jass.DAMAGE_TYPE_COLD;
  const 敌军列表 = 过滤被动追加标的(获取范围敌军(caster, payload.目标X, payload.目标Y, 被动配置.附加伤害范围));
  if (敌军列表.length === 0) return;

  造成批量AOE技能伤害({
    来源: caster,
    目标列表: 敌军列表,
    伤害: 伤害,
    伤害类型: 伤害类型,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "普攻强化",
    标签: "塞拉斯-被动附加",
  });
}

function 处理塞拉斯普攻附加(
  this: void,
  unit: any,
  _damage: number,
  _damageType: number,
  _fromDotTickBatch?: boolean,
  source?: any,
  isNormalAttack?: boolean,
): void {
  if (!isNormalAttack) return;
  if (unit == null || unit === 0 || source == null || source === 0) return;
  if (GetUnitTypeId(source) !== 英雄单位类型ID) return;

  const sourceOwner = GetOwningPlayer(source);
  if (sourceOwner == null || sourceOwner === 0) return;
  // 目标为敌方，且不是玩家拥有单位（源 JASS 条件）
  if (IsUnitAlly(unit, sourceOwner)) return;
  if (IsUnitOwnedByPlayer(unit, sourceOwner)) return;

  // 距离至少 500
  const 距离 = 两点距离(GetUnitX(unit), GetUnitY(unit), GetUnitX(source), GetUnitY(source));
  if (距离 < 被动配置.触发距离) return;

  // 必须已使用过火/冰/雷普通魔法且标记仍在
  if (!塞拉斯拥有任意攻击标记(source)) return;

  // 消费标记（同步）并移除对应 Buff 图标
  const marks = 消费塞拉斯攻击标记(source);
  if (!marks.火 && !marks.冰 && !marks.雷) return;
  移除单位指定Buff(source, 塞拉斯BuffID.火焰附加攻击);
  移除单位指定Buff(source, 塞拉斯BuffID.冰冻附加攻击);
  移除单位指定Buff(source, 塞拉斯BuffID.雷击附加攻击);

  // 快照被击目标位置（审计：JASS 真源为受击者坐标，非施法者坐标）
  const payload: 被动追加载荷 = {
    caster: source,
    目标X: GetUnitX(unit),
    目标Y: GetUnitY(unit),
    火: marks.火,
    冰: marks.冰,
    雷: marks.雷,
  };
  addDelayedCallback(被动配置.延迟秒 * 1000, 执行被动追加伤害, payload);
}

export function 注册塞拉斯普攻附加被动(this: void): void {
  registerDamageCallback(处理塞拉斯普攻附加);
}

注册塞拉斯普攻附加被动();

export const 塞拉斯普攻附加被动状态 = {
  已完成设计: true,
  已完成实现: true,
  触发: "H014 普攻、目标非玩家拥有敌方、距离≥500、存在元素标记",
  效果: "0.12秒后受击位置350范围，当前魔法值×40%元素伤害，防递归（普攻强化来源）",
} as const;
