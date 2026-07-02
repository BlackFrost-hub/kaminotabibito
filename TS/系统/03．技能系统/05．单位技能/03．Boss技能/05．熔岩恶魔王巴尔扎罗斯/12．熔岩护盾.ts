/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 创建血量节点触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index") as {
  创建血量节点触发器: (this: void, 参数: any) => any;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: any;
  查询单位标签护盾值: (this: void, unit: any, 标签: string) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, timeScale: number) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

let 熔岩护盾伤害修正已注册 = false;
const 近战反弹冷却表: Record<number, number> = {};
const 冰霜命中护盾时间表: Record<number, number> = {};

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 播放护盾短动作(this: void, boss: any): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
  addDelayedCallback(700, function 巴尔扎罗斯熔岩护盾恢复动作(this: void): void {
    if (!单位有效(boss)) return;
    SetUnitTimeScale(boss, 1);
  });
}

function 移除一层熔岩暴走(this: void, boss: any): void {
  const buffID = 巴尔扎罗斯单位技能配置.BuffID.熔岩暴走;
  const runtime = getBuffRuntime(boss, buffID);
  if (runtime == null) return;
  const stack = runtime.stack ?? 1;
  if (stack <= 1) {
    移除单位指定Buff(boss, buffID);
    return;
  }
  registerManualBuff(boss, buffID, runtime.remaining ?? 10, runtime.effect ?? 0, {
    stack: stack - 1,
    sourceName: "巴尔扎罗斯",
  });
}

function 创建熔岩护盾(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  const shieldValue = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * config.护盾Boss最大生命比例;
  const bossId = 取单位ID(boss);

  播放护盾短动作(boss);
  播放巴尔扎罗斯台词(boss, "熔岩护盾");
  创建单位坐标跟随特效(boss, config.特效路径, config.特效键, config.特效缩放, config.特效高度);
  registerManualBuff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔岩护盾, config.持续秒, shieldValue, {
    sourceName: "巴尔扎罗斯",
  });

  开始护盾(boss, {
    类型: 护盾类型.火,
    数值: shieldValue,
    持续时间: config.持续秒,
    来源单位: boss,
    标签: config.护盾标签,
    结束回调: function 巴尔扎罗斯熔岩护盾结束(this: void): void {
      销毁单位坐标跟随特效(boss, config.特效键);
      移除单位指定Buff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔岩护盾);
    },
    破碎回调: function 巴尔扎罗斯熔岩护盾破碎(this: void): void {
      const lastIce = 冰霜命中护盾时间表[bossId] ?? 0;
      if (lastIce > 0 && getServerTime() - lastIce <= 250) {
        移除一层熔岩暴走(boss);
      }
    },
  });
}

function 计算反弹伤害(this: void, boss: any, attacker: any): number {
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  return GetUnitState(attacker, UNIT_STATE_MAX_LIFE) * config.近战反弹来源最大生命比例
    + 读取单位攻击力(boss) * config.近战反弹Boss攻击力比例;
}

function 尝试安排近战反弹(this: void, boss: any, attacker: any): void {
  if (!单位有效(boss) || !单位有效(attacker)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  const attackerId = 取单位ID(attacker);
  if (attackerId === 0) return;
  const now = getServerTime();
  const nextAllowed = 近战反弹冷却表[attackerId] ?? 0;
  if (now < nextAllowed) return;
  近战反弹冷却表[attackerId] = now + config.近战反弹冷却秒 * 1000;
  addDelayedCallback(0, function 巴尔扎罗斯熔岩护盾反弹(this: void): void {
    if (!单位有效(boss) || !单位有效(attacker)) return;
    UnitDamageTarget(boss, attacker, 计算反弹伤害(boss, attacker), false, true, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
  });
}

function 巴尔扎罗斯熔岩护盾伤害修正(this: void, context: any): number {
  const boss = context.target;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  if (!单位有效(boss) || 查询单位标签护盾值(boss, config.护盾标签) <= 0) return context.currentDamage;
  if (context.isNormalAttack === true && context.isRangedAttack !== true && 单位有效(context.attacker)) {
    尝试安排近战反弹(boss, context.attacker);
  }
  if (context.isWaterDamage === true) {
    const bossId = 取单位ID(boss);
    if (bossId !== 0) 冰霜命中护盾时间表[bossId] = getServerTime();
    return context.currentDamage * config.冰霜护盾消耗倍率;
  }
  return context.currentDamage;
}

function 确保熔岩护盾伤害修正(this: void): void {
  if (熔岩护盾伤害修正已注册) return;
  熔岩护盾伤害修正已注册 = true;
  registerDamageModifier(巴尔扎罗斯熔岩护盾伤害修正, 110);
}

export function 初始化巴尔扎罗斯熔岩护盾节点(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.熔岩护盾节点已初始化) return;
  context.熔岩护盾节点已初始化 = true;
  确保熔岩护盾伤害修正();
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  创建血量节点触发器({
    清理: context.清理,
    名称: "巴尔扎罗斯-熔岩护盾血量节点",
    单位: context.Boss单位,
    节点列表: [
      { ID: "熔岩护盾-85", 百分比: config.触发生命比例[0], on触发: function 巴尔扎罗斯熔岩护盾85(this: void): void { 创建熔岩护盾(context); } },
      { ID: "熔岩护盾-55", 百分比: config.触发生命比例[1], on触发: function 巴尔扎罗斯熔岩护盾55(this: void): void { 创建熔岩护盾(context); } },
      { ID: "熔岩护盾-25", 百分比: config.触发生命比例[2], on触发: function 巴尔扎罗斯熔岩护盾25(this: void): void { 创建熔岩护盾(context); } },
    ],
  });
}

export function 注册巴尔扎罗斯熔岩护盾(this: void): void {
  确保熔岩护盾伤害修正();
}

export {};
