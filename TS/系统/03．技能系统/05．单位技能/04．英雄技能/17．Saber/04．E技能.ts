/** @noSelfInFile */
// Saber E：魔力放出（A0DG）状态 + 普攻附加魔法伤害。
// 源 JASS 真源：主要技能.j 1826-1853/2378-2401；E开启后的效果.j 4-25。
// 攻击力 +25% 走 临时调整攻击（SGSS 增量）；状态走 TS Buff + Saber状态表双轨（W 联动查询状态表）。
// 源按未暂停时间约 8 秒结束（暂停期间计数不推进），本实现保留该口径。

import { Saber技能配置 } from "./00．配置";
import { SaberBuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/08．Saber";
import {
  Saber开启E,
  Saber关闭E,
  Saber是否E开启,
  读取SaberE攻击加成值,
} from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (this: void, unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    intervalSeconds?: number,
  ) => void;
};
const { registerManualBuff, 移除单位指定Buff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
};
const { createUnitEffect, destroyUnitEffect, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitPaused = jass.IsUnitPaused as (this: void, unit: any) => boolean;
const GetSpellAbilityId = jass.GetSpellAbilityId as (this: void) => number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 配置 = Saber技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const E类型ID = stringToFourCC(配置.E.技能ID);
const E武器特效键 = "Saber-E-武器强化";

// ---------------------------------------------------------------------------
// E 状态运行时
// ---------------------------------------------------------------------------

interface E运行时 {
  caster: any;
  周期回调ID: number;
  计数: number;
  攻击加成值: number;
  已启动: boolean;
}

const E运行时表: Record<number, E运行时> = {};

/** 结束 E：撤销攻击力加成、销毁武器特效、移除 Buff、关闭状态。所有结束路径共用。 */
function 结束SaberE状态(this: void, caster: any): void {
  if (caster == null || caster === 0) return;
  const runtime = E运行时表[GetHandleId(caster)];
  Saber关闭E(caster);
  移除单位指定Buff(caster, SaberBuffID.魔力放出);
  destroyUnitEffect(caster, E武器特效键);
  if (runtime == null) return;
  if (runtime.周期回调ID !== 0) removePeriodicCallback(runtime.周期回调ID);
  runtime.周期回调ID = 0;
  if (runtime.攻击加成值 !== 0) {
    临时调整攻击(caster, -runtime.攻击加成值);
    runtime.攻击加成值 = 0;
  }
  runtime.已启动 = false;
  delete E运行时表[GetHandleId(caster)];
}

/** W 地面 E 联动消耗入口：立即结束魔力放出。 */
export function 消耗SaberE(this: void, caster: any): void {
  if (!Saber是否E开启(caster)) return;
  结束SaberE状态(caster);
}

export { Saber是否E开启 };

function 推进E周期(this: void, variable?: any): void {
  const runtime = variable as E运行时 | undefined;
  if (runtime == null) return;
  const caster = runtime.caster;

  // 源：死亡 / 计数到 32 / Buff 被驱散 → 结束
  if (caster == null || caster === 0 || !单位存活(caster) || runtime.计数 >= 配置.E.最大计数) {
    结束SaberE状态(caster);
    return;
  }
  if (!Saber是否E开启(caster) || getBuffRuntime(caster, SaberBuffID.魔力放出) == null) {
    结束SaberE状态(caster);
    return;
  }

  // 源：暂停期间计数不推进（E 生命周期按未暂停时间结算）
  if (!IsUnitPaused(caster)) {
    runtime.计数 += 1;
  }
  createTimedUnitEffect(caster, 配置.E.周期特效.挂点, 配置.E.周期特效.模型路径, 配置.E.周期特效.持续秒);
}

// ---------------------------------------------------------------------------
// E 施法入口
// ---------------------------------------------------------------------------

interface E上下文 {
  施法者: any;
}

const E上下文表: Record<number, E上下文> = {};

function 获取或创建E上下文(this: void, caster: any): E上下文 {
  const id = GetHandleId(caster);
  let record = E上下文表[id];
  if (record == null) {
    record = { 施法者: caster };
    E上下文表[id] = record;
  }
  return record;
}

function 释放E技能(this: void, _context: E上下文, caster: any, _技能实例ID?: number): void {
  if (!单位存活(caster)) return;

  // 重复释放：先结束旧状态再重新开启（攻击力加成按新快照重算）
  if (Saber是否E开启(caster)) {
    结束SaberE状态(caster);
  }

  const 加成 = 读取单位攻击力(caster) * 配置.E.攻击力加成比例;
  临时调整攻击(caster, 加成);
  Saber开启E(caster, 加成);
  registerManualBuff(caster, SaberBuffID.魔力放出, 配置.E.持续秒, 配置.E.攻击力加成比例, {
    来源: caster,
    标签: "Saber-E-魔力放出",
  });
  createUnitEffect(caster, 配置.E.武器特效.挂点, 配置.E.武器特效.模型路径, undefined, E武器特效键);

  const runtime: E运行时 = {
    caster,
    周期回调ID: 0,
    计数: 0,
    攻击加成值: 加成,
    已启动: true,
  };
  E运行时表[GetHandleId(caster)] = runtime;
  runtime.周期回调ID = addPeriodicCallback(
    Math.round(配置.E.周期间隔秒 * 1000),
    推进E周期 as unknown as (this: void, variable?: any) => void,
    runtime,
  );
}

// ---------------------------------------------------------------------------
// 普攻附加魔法伤害（E开启后的效果.j）
// ---------------------------------------------------------------------------

function 处理E普攻附加伤害(
  this: void,
  target: any,
  damage: number,
  _damageType: number,
  _fromDotTickBatch?: boolean,
  source?: any,
  isNormalAttack?: boolean,
): void {
  if (source == null || source === 0) return;
  if (!isNormalAttack) return;
  if (GetUnitTypeId(source) !== 英雄单位类型ID) return;
  if (!单位存活(source)) return;
  if (!Saber是否E开启(source)) return;
  if (target == null || target === 0 || !单位存活(target)) return;
  if (damage <= 0) return;

  // 追加当前攻击事件伤害×25% 魔法伤害；来源类型为普攻强化，不会再次触发本回调
  造成单体技能伤害({
    来源: source,
    目标: target,
    伤害: damage * 配置.E.普攻附加.伤害比例,
    伤害类型: DAMAGE_TYPE_MAGIC,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "普攻强化",
    标签: "Saber-E-普攻附加",
    技能ID: E类型ID,
  });
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let E死亡监听已注册 = false;

function E单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  if (Saber是否E开启(dyingUnit) || E运行时表[GetHandleId(dyingUnit)] != null) {
    结束SaberE状态(dyingUnit);
  }
}

export function 注册SaberE(this: void): void {
  注册单位技能壳监听({
    名称: "Saber-魔力放出（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.E.技能ID,
    获取或创建上下文: 获取或创建E上下文,
    释放技能: 释放E技能,
    创建独立技能实例: false,
  });
  registerDamageCallback(处理E普攻附加伤害);
  if (!E死亡监听已注册) {
    E死亡监听已注册 = true;
    registerDeathListener(E单位死亡清理);
  }
}

注册SaberE();

void GetSpellAbilityId;
void 读取SaberE攻击加成值;

export {};
