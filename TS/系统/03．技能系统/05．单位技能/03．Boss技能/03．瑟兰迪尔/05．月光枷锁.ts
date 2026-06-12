/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 瑟兰迪尔单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数: number | { 持续时间: number }) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: {
    sourceName?: string;
    iconOverride?: string;
    effectModelOverride?: string;
  }) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const R2I = jass.R2I as (value: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const UnitDamageTarget = jass.UnitDamageTarget as (
  whichUnit: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;

const 瑟兰迪尔单位类型ID = stringToFourCC(瑟兰迪尔单位技能配置.单位ID);
const 月光枷锁技能ID = stringToFourCC(瑟兰迪尔数值与表现配置.月光枷锁.技能槽位);
let 月光枷锁已注册 = false;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 播放月光枷锁施法动作(this: void, caster: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  SetUnitTimeScale(caster, 1.5);
  SetUnitAnimationByIndex(caster, config.动画编号);
  addDelayedCallback(R2I(config.施法硬直秒 * 1000), function 重置月光枷锁施法动作(this: void): void {
    if (!单位有效(caster)) return;
    SetUnitTimeScale(caster, 1);
    SetUnitAnimationByIndex(caster, 0);
  });
}

function 播放月光枷锁特效(this: void, caster: any, target: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  const casterEffect = AddSpecialEffectTarget(config.飞行特效, caster, "weapon");
  if (casterEffect != null && casterEffect !== 0) {
    YDWETimerDestroyEffectSafe(0.8, casterEffect);
  }
  const targetEffect = AddSpecialEffectTarget(config.命中特效, target, "origin");
  if (targetEffect != null && targetEffect !== 0) {
    YDWETimerDestroyEffectSafe(config.定身秒, targetEffect);
  }
}

function 结算月光枷锁Tick伤害(this: void, caster: any, target: any, tickIndex: number): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  addDelayedCallback(R2I(config.Tick间隔秒 * tickIndex * 1000), function 月光枷锁Tick伤害回调(this: void): void {
    if (!单位有效(caster) || !单位有效(target)) return;
    UnitDamageTarget(
      caster,
      target,
      config.Tick伤害,
      false,
      false,
      jass.ATTACK_TYPE_NORMAL,
      jass.DAMAGE_TYPE_PLANT,
      jass.WEAPON_TYPE_WHOKNOWS
    );
  });
}

export function 释放瑟兰迪尔月光枷锁(this: void, _context: 瑟兰迪尔运行时上下文, _target: any): void {
  释放瑟兰迪尔月光枷锁效果(_context.Boss单位, _target);
}

export function 释放瑟兰迪尔月光枷锁效果(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  播放月光枷锁施法动作(caster);
  播放月光枷锁特效(caster, target);
  施加扩展控制(caster, target, "roots", { 持续时间: config.定身秒 });
  registerManualBuff(target, config.BuffID, config.定身秒, 0, {
    sourceName: GetUnitName(caster),
    iconOverride: "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
    effectModelOverride: config.命中特效,
  });
  for (let i = 1; i <= config.定身秒; i++) {
    结算月光枷锁Tick伤害(caster, target, i);
  }
}

function on瑟兰迪尔月光枷锁生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 月光枷锁技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 瑟兰迪尔单位类型ID) return;
  const target = GetSpellTargetUnit();
  释放瑟兰迪尔月光枷锁效果(castingUnit, target);
}

export function 注册瑟兰迪尔月光枷锁(this: void): void {
  if (月光枷锁已注册) return;
  月光枷锁已注册 = true;
  registerSpellEffectListener(on瑟兰迪尔月光枷锁生效);
}
