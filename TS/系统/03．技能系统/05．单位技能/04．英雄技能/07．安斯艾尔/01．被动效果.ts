/** @noSelfInFile */

import { 安斯艾尔单位技能配置 } from "./00．配置";
import { 安斯艾尔BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/16．安斯艾尔";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: (this: void) => void) => any;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration: number) => any;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, name: string, delta: number) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 扩散伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害") as {
  扩散伤害: (this: void, params: any) => void;
};
const { registerAppliedFinalDamageListener, 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
  延后一帧执行伤害派生效果: (this: void, callback: (this: void) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const GetHandleId = jass.GetHandleId as (unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetWidgetLife = jass.GetWidgetLife as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const 安斯艾尔单位类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.单位类型ID);
const 被动技能类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.被动技能ID);
const Q技能类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.Q技能ID);
const E技能类型ID = stringToFourCCSafe(安斯艾尔单位技能配置.E技能ID);

interface 圣光附魔记录 {
  单位: any;
  代数: number;
  剩余次数: number;
  吸血已添加: boolean;
}

const 圣光附魔缓存: Record<number, 圣光附魔记录 | undefined> = {};

function 是安斯艾尔(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 安斯艾尔单位类型ID;
}

function 清除圣光附魔(this: void, id: number, record: 圣光附魔记录): void {
  if (圣光附魔缓存[id] !== record) return;
  if (record.吸血已添加) 调整玩家属性(record.单位, "普攻伤害吸血", -安斯艾尔单位技能配置.Q.普攻吸血增加);
  移除单位指定Buff(record.单位, 安斯艾尔BuffID.圣光附魔);
  delete 圣光附魔缓存[id];
}

export function 激活安斯艾尔圣光附魔(this: void, unit: any): void {
  if (!是安斯艾尔(unit)) return;
  const id = GetHandleId(unit);
  let record = 圣光附魔缓存[id];
  if (record == null || record.单位 !== unit) {
    record = { 单位: unit, 代数: 0, 剩余次数: 0, 吸血已添加: false };
    圣光附魔缓存[id] = record;
  }
  record.代数 += 1;
  record.剩余次数 = 安斯艾尔单位技能配置.Q.附魔次数;
  if (!record.吸血已添加) {
    record.吸血已添加 = true;
    调整玩家属性(unit, "普攻伤害吸血", 安斯艾尔单位技能配置.Q.普攻吸血增加);
  }
  registerManualBuff(unit, 安斯艾尔BuffID.圣光附魔, 安斯艾尔单位技能配置.Q.持续秒, 0, {
    sourceUnit: unit,
    sourceName: "圣光附魔",
  });
  const generation = record.代数;
  function on圣光附魔到期(this: void): void {
    const current = 圣光附魔缓存[id];
    if (current == null || current !== record || current.代数 !== generation) return;
    清除圣光附魔(id, current);
  }
  createDelayedCall(安斯艾尔单位技能配置.Q.持续秒, on圣光附魔到期);
}

function 创建安斯艾尔追加伤害(this: void, source: any, target: any, damage: number, damageType: any, abilityId: number, tag: string, effectPath: string): void {
  function on执行追加伤害(this: void): void {
    if (!单位存活(source) || !单位存活(target)) return;
    造成单体技能伤害({
      来源: source,
      目标: target,
      伤害: damage,
      伤害类型: damageType,
      来源类型: "单位技能",
      技能ID: abilityId,
      参与技能伤害加成: true,
      标签: tag,
    });
    createTimedUnitEffect(target, 安斯艾尔单位技能配置.Q.特效挂点, effectPath, 安斯艾尔单位技能配置.Q.特效持续秒);
  }
  延后一帧执行伤害派生效果(on执行追加伤害);
}

function 尝试触发一骑当先(this: void, attacker: any, target: any): void {
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0) || GetWidgetLife(target) + 0.01 < maxLife) return;
  const cfg = 安斯艾尔单位技能配置.被动;
  const damage = maxLife * cfg.目标最大生命比例 + 读取单位攻击力(attacker) * cfg.攻击力倍率;
  创建安斯艾尔追加伤害(attacker, target, damage, DAMAGE_TYPE_DIVINE, 被动技能类型ID, "安斯艾尔-一骑当先", cfg.伤害特效);
}

function 尝试消耗圣光附魔(this: void, attacker: any, target: any): void {
  const id = GetHandleId(attacker);
  const record = 圣光附魔缓存[id];
  if (record == null || record.单位 !== attacker || record.剩余次数 <= 0) return;
  record.剩余次数 -= 1;
  const level = GetUnitAbilityLevel(attacker, Q技能类型ID);
  const cfg = 安斯艾尔单位技能配置.Q;
  const damage = 读取单位攻击力(attacker) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);
  const element = GetRandomInt(1, 3);
  if (element === 1) {
    创建安斯艾尔追加伤害(attacker, target, damage, DAMAGE_TYPE_DIVINE, Q技能类型ID, "安斯艾尔-圣光附魔-光", cfg.光属性特效);
  } else if (element === 2) {
    创建安斯艾尔追加伤害(attacker, target, damage, DAMAGE_TYPE_LIGHTNING, Q技能类型ID, "安斯艾尔-圣光附魔-雷", cfg.雷属性特效);
  } else {
    创建安斯艾尔追加伤害(attacker, target, damage, DAMAGE_TYPE_FIRE, Q技能类型ID, "安斯艾尔-圣光附魔-火", cfg.火属性特效);
  }
}

function 尝试触发扩散攻击(this: void, attacker: any, target: any, applied: number, snapshot: any): void {
  const level = GetUnitAbilityLevel(attacker, E技能类型ID);
  if (!(level > 0)) return;
  const cfg = 安斯艾尔单位技能配置.E;
  const spreadRatio = cfg.基础扩散比例 + cfg.每级扩散比例 * level;
  function on执行安斯艾尔扩散伤害(this: void): void {
    // 扩散属于原普攻的派生伤害，必须脱离当前最终伤害回调后再提交。
    const attackerAlive = 单位存活(attacker);
    const targetValid = target != null && target !== 0;
    if (!attackerAlive || !targetValid) return;
    扩散伤害({
      来源单位: attacker,
      主目标: target,
      伤害值: applied,
      扩散半径: cfg.扩散半径,
      扩散百分比: spreadRatio,
      是否包含主目标: false,
      攻击类型: snapshot?.effectiveAttackType ?? jass.ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      武器类型: snapshot?.effectiveWeaponType ?? null,
      来源类型: "普攻强化",
      技能ID: E技能类型ID,
      技能标签: "安斯艾尔-扩散攻击",
      参与技能伤害加成: false,
    });
  }
  延后一帧执行伤害派生效果(on执行安斯艾尔扩散伤害);
}

function on安斯艾尔普通攻击结算(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!是安斯艾尔(attacker)) return;
  if (!(applied > 0)) return;
  if (snapshot?.isNormalAttack !== true || snapshot?.isWrappedSkillDamage === true || snapshot?.originalAttacker !== attacker) return;
  尝试触发一骑当先(attacker, target);
  尝试消耗圣光附魔(attacker, target);
  尝试触发扩散攻击(attacker, target, applied, snapshot);
}

export function 注册安斯艾尔被动(this: void): void {
  registerAppliedFinalDamageListener(on安斯艾尔普通攻击结算);
}

注册安斯艾尔被动();
