/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取影骨莫特斯上下文, 获取或创建影骨莫特斯上下文, 设置影骨背刺准备, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y, 目标正面朝向来源, 取单位ID } from "./11．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 阴影穿梭技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.阴影穿梭);
let 已注册阴影穿梭 = false;
let 已注册背刺修正 = false;

const 待穿梭上下文: Record<number, 影骨莫特斯运行时上下文 | undefined> = {};

function on影骨背刺伤害修正(this: void, damageContext: any): number {
  const boss = damageContext.attacker;
  if (!单位有效(boss) || damageContext.isNormalAttack !== true || damageContext.isSkillAttack === true || damageContext.isSkillDamage === true) {
    return damageContext.currentDamage;
  }
  if (GetUnitTypeId(boss) !== 影骨单位类型ID) return damageContext.currentDamage;
  const context = 获取影骨莫特斯上下文(boss);
  if (context == null || !context.背刺准备) return damageContext.currentDamage;
  设置影骨背刺准备(context, false);
  const cfg = 影骨莫特斯数值与表现配置.阴影穿梭;
  let damage = damageContext.currentDamage * cfg.背刺伤害倍率;
  if (目标正面朝向来源(boss, damageContext.target, cfg.背刺角度)) damage *= cfg.正面减伤比例;
  if (单位有效(damageContext.target)) {
    const effect = AddSpecialEffectTarget(影骨莫特斯表现配置.背刺命中, damageContext.target, "chest");
    if (effect != null && effect !== 0) DestroyEffect(effect);
  }
  return damage;
}

function 确保影骨背刺修正(this: void): void {
  if (已注册背刺修正) return;
  已注册背刺修正 = true;
  registerDamageModifier(on影骨背刺伤害修正, 48);
}

function 影骨阴影穿梭完成(this: void): void {
  for (const key in 待穿梭上下文) {
    const context = 待穿梭上下文[key];
    if (context == null) continue;
    delete 待穿梭上下文[key];
    const boss = context.Boss单位;
    if (!单位有效(boss)) continue;
    const target = 获取Boss技能随机敌对英雄(boss);
    if (!单位有效(target)) {
      SetUnitInvulnerable(boss, false);
      SetUnitVertexColor(boss, 255, 255, 255, 255);
      continue;
    }
    const angle = GetRandomReal(0, 360);
    const distance = 影骨莫特斯数值与表现配置.阴影穿梭.出现距离;
    const x = 极坐标X(GetUnitX(target), distance, angle);
    const y = 极坐标Y(GetUnitY(target), distance, angle);
    AddSpecialEffect(影骨莫特斯表现配置.阴影穿梭落点, x, y);
    SetUnitX(boss, x);
    SetUnitY(boss, y);
    SetUnitInvulnerable(boss, false);
    SetUnitVertexColor(boss, 255, 255, 255, 255);
    设置影骨背刺准备(context, true);
    IssueTargetOrder(boss, "attackonce", target);
  }
}

function 释放影骨阴影穿梭(this: void, context: 影骨莫特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  播放影骨莫特斯台词(boss, "阴影穿梭");
  AddSpecialEffect(影骨莫特斯表现配置.阴影穿梭残影, GetUnitX(boss), GetUnitY(boss));
  SetUnitVertexColor(boss, 255, 255, 255, 80);
  SetUnitInvulnerable(boss, true);
  const id = 取单位ID(boss);
  if (id === 0) return;
  待穿梭上下文[id] = context;
  context.清理.登记延迟回调("影骨-阴影穿梭", addDelayedCallback(影骨莫特斯数值与表现配置.阴影穿梭.消失秒 * 1000, 影骨阴影穿梭完成));
}

function on影骨阴影穿梭施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 阴影穿梭技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context == null) return;
  释放影骨阴影穿梭(context);
}

export function 注册影骨莫特斯阴影穿梭(this: void): void {
  if (已注册阴影穿梭) return;
  已注册阴影穿梭 = true;
  确保影骨背刺修正();
  registerSpellEffectListener(on影骨阴影穿梭施法);
}
