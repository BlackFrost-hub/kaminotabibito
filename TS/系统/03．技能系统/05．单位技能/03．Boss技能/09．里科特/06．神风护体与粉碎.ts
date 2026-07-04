/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import {
  获取或创建里科特上下文,
  获取全部里科特上下文,
  增加里科特神风印记,
  取里科特神风印记,
  清除里科特神风印记,
  type 里科特运行时上下文,
} from "./01．运行时上下文";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC } from "./13．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.07．里科特") as {
  里科特BuffID: { 神风印记: string; 神风护体: string };
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 神风护体技能ID = stringToFourCC(里科特数值与表现配置.神风护体.技能槽位);
let 已注册 = false;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取里科特上下文ByBoss(this: void, boss: any): 里科特运行时上下文 | undefined {
  const contexts = 获取全部里科特上下文();
  for (let i = 0; i < contexts.length; i++) {
    if (contexts[i].Boss单位 === boss) return contexts[i];
  }
  return undefined;
}

function 播放限时目标特效(this: void, target: any, model: string, attach: string, duration: number): void {
  if (!单位有效(target) || model === "") return;
  const effect = AddSpecialEffectTarget(model, target, attach);
  addDelayedCallback(duration * 1000, function 里科特神风目标特效销毁(this: void): void {
    DestroyEffect(effect);
  });
}

function 播放限时点特效(this: void, model: string, x: number, y: number, duration: number): void {
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  addDelayedCallback(duration * 1000, function 里科特神风点特效销毁(this: void): void {
    DestroyEffect(effect);
  });
}

function 设置神风护体层数(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  context.神风护体层数 = cfg.基础层数;
  registerManualBuff(context.Boss单位, 里科特BuffID.神风护体, cfg.持续秒, cfg.基础层数, {
    stack: cfg.基础层数,
    sourceName: "里科特-神风护体",
  });
  播放限时目标特效(context.Boss单位, cfg.护体特效路径, "origin", cfg.持续秒);
}

function 更新神风护体层数Buff(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  if (context.神风护体层数 <= 0) {
    移除单位指定Buff(context.Boss单位, 里科特BuffID.神风护体);
    return;
  }
  registerManualBuff(context.Boss单位, 里科特BuffID.神风护体, cfg.持续秒, context.神风护体层数, {
    stack: context.神风护体层数,
    sourceName: "里科特-神风护体",
  });
}

function 记录神风印记(this: void, context: 里科特运行时上下文, attacker: any): void {
  if (!单位有效(attacker)) return;
  const cfg = 里科特数值与表现配置.神风护体;
  const stack = 增加里科特神风印记(context, attacker, 1);
  registerManualBuff(attacker, 里科特BuffID.神风印记, cfg.持续秒 + 0.5, stack, {
    stack,
    sourceName: "里科特-神风印记",
  });
}

function 结算单个神风粉碎(this: void, context: 里科特运行时上下文, target: any): void {
  if (!单位有效(target)) return;
  const stack = 取里科特神风印记(context, target);
  if (stack <= 0) return;
  const cfg = 里科特数值与表现配置.神风护体;
  const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  const damage = maxLife * cfg.粉碎每层最大生命比例 * stack;
  const stun = cfg.粉碎基础眩晕秒 + cfg.粉碎每层眩晕秒 * stack;
  UnitDamageTarget(context.Boss单位, target, damage, false, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
  施加眩晕(context.Boss单位, target, stun);
  播放限时点特效(cfg.粉碎特效路径, GetUnitX(target), GetUnitY(target), 1);
  清除里科特神风印记(context, target);
  移除单位指定Buff(target, 里科特BuffID.神风印记);
}

function 结算神风粉碎(this: void, context: 里科特运行时上下文): void {
  播放里科特台词(context.Boss单位, "粉碎");
  for (const key in context.神风印记表) {
    const stack = context.神风印记表[key];
    if (stack == null || stack <= 0) continue;
    const target = context.神风印记单位表[key];
    if (target != null) 结算单个神风粉碎(context, target);
  }
  context.神风印记表 = {};
  context.神风印记单位表 = {};
}

function 调度神风粉碎(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  const id = addDelayedCallback(cfg.持续秒 * 1000, function 里科特神风粉碎延迟结算(this: void): void {
    if (!单位有效(context.Boss单位)) return;
    context.神风护体层数 = 0;
    移除单位指定Buff(context.Boss单位, 里科特BuffID.神风护体);
    结算神风粉碎(context);
  });
  context.清理.登记延迟回调("里科特-神风粉碎", id);
}

function on里科特神风护体受伤修正(this: void, damageContext: any): number {
  const context = 取里科特上下文ByBoss(damageContext.target);
  if (context == null || context.神风护体层数 <= 0 || !单位有效(context.Boss单位)) return damageContext.currentDamage;
  context.神风护体层数 = context.神风护体层数 - 1;
  记录神风印记(context, damageContext.attacker);
  更新神风护体层数Buff(context);
  return damageContext.currentDamage * (1 - 里科特数值与表现配置.神风护体.受击减伤比例);
}

function on里科特神风护体施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 神风护体技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  播放里科特台词(castingUnit, "神风护体");
  设置神风护体层数(context);
  调度神风粉碎(context);
}

export function 注册里科特神风护体与粉碎(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "06．神风护体与粉碎",
    单位类型ID: 里科特单位类型ID,
    技能ID: 神风护体技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特神风护体施法(boss, 神风护体技能ID);
    },
  });
  registerDamageModifier(on里科特神风护体受伤修正, 70);
}
