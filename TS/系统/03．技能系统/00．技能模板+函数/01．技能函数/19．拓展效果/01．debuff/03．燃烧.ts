/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: {
      sourceName?: string;
      iconOverride?: string;
      effectModelOverride?: string;
      effectValue2?: number;
      onRemove?: (this: void, unit: any, buffID: string, row: { effect: number }) => void;
    }
  ) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { syncDotBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  syncDotBuff: (
    this: void,
    typeId: string,
    target: any,
    state: { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null
  ) => void;
};
const { getUnitBurn, dealBurnDamage } = require("系统.04．伤害系统.02．dot伤害") as {
  getUnitBurn: (this: void, unit: any) => { effect: number; remaining: number } | null;
  dealBurnDamage: (this: void, source: any, target: any, amount: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 燃烧DOT类型 = "burn";
const 燃烧BUFFID = "D002";
const 燃烧默认图标 = "BuffIcon\\DotRanShao.blp";
const 燃烧默认特效 = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl";

type 燃烧持续模式 = "刷新" | "叠加" | "独立";

export interface 燃烧效果参数 {
  持续时间: number;
  每秒伤害: number;
  持续模式?: 燃烧持续模式;
  图标路径?: string;
  特效路径?: string;
  特效挂点?: string;
  特效持续时间?: number;
  来源名称?: string;
  BuffID?: string;
  最大持续时间?: number;
  只刷新更强?: boolean;
}

interface 独立燃烧记录 {
  source: any;
  target: any;
  buffID: string;
  damagePerSecond: number;
  sourceName?: string;
  iconPath: string;
  effectPath: string;
  effectAttachPoint: string;
  effectDuration: number;
}

const 独立燃烧表: Record<string, 独立燃烧记录 | undefined> = {};
let 独立燃烧回调ID = 0;
let 独立燃烧序号 = 0;

function 取字符串(this: void, value: string | undefined, fallback: string): string {
  return value != null && value !== "" ? value : fallback;
}

function 取数值(this: void, value: number | undefined, fallback: number): number {
  return typeof value === "number" && isFinite(value) && value > 0 ? value : fallback;
}

function 取较大值(this: void, a: number, b: number): number {
  return a >= b ? a : b;
}

function 目标存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 播放附着特效(this: void, target: any, modelPath: string, attachPoint: string, duration: number): void {
  if (target == null || target === 0) return;
  if (modelPath === "") return;
  const effect = AddSpecialEffectTarget(modelPath, target, attachPoint !== "" ? attachPoint : "origin");
  if (effect != null && effect !== 0) {
    YDWETimerDestroyEffectSafe(duration > 0 ? duration : 0.75, effect);
  }
}

function 生成独立燃烧BuffID(this: void, target: any): string {
  独立燃烧序号 += 1;
  return `burn-instance-${GetHandleId(target)}-${独立燃烧序号}`;
}

function 确保独立燃烧驱动(this: void): void {
  if (独立燃烧回调ID !== 0) return;
  独立燃烧回调ID = addPeriodicCallback(1000, on独立燃烧Tick);
}

function 尝试停止独立燃烧驱动(this: void): void {
  for (const key in 独立燃烧表) {
    if (独立燃烧表[key] != null) return;
  }
  if (独立燃烧回调ID !== 0) {
    removePeriodicCallback(独立燃烧回调ID);
    独立燃烧回调ID = 0;
  }
}

function on独立燃烧移除(this: void, _unit: any, buffID: string): void {
  delete 独立燃烧表[buffID];
  尝试停止独立燃烧驱动();
}

function on独立燃烧Tick(this: void): void {
  let active = 0;
  for (const buffID in 独立燃烧表) {
    const record = 独立燃烧表[buffID];
    if (record == null) continue;
    active += 1;

    const runtime = getBuffRuntime(record.target, record.buffID);
    if (runtime == null || runtime.remaining <= 0) {
      delete 独立燃烧表[buffID];
      continue;
    }
    if (!目标存活(record.target)) continue;
    dealBurnDamage(record.source, record.target, record.damagePerSecond);
  }
  if (active === 0) 尝试停止独立燃烧驱动();
}

function 应用共享燃烧(this: void, source: any, target: any, 参数: 燃烧效果参数): boolean {
  const current = getUnitBurn(target);
  const duration = 取数值(参数.持续时间, 0);
  const damage = 取数值(参数.每秒伤害, 0);
  if (!(duration > 0) || !(damage > 0)) return false;

  let remaining = duration;
  let effect = damage;
  if (current != null) {
    if ((参数.持续模式 ?? "刷新") === "叠加") {
      remaining = current.remaining + duration;
    }
    effect = 取较大值(current.effect, effect);
  }
  if (参数.最大持续时间 != null && 参数.最大持续时间 > 0 && remaining > 参数.最大持续时间) {
    remaining = 参数.最大持续时间;
  }
  syncDotBuff(燃烧DOT类型, target, {
    effect,
    remaining,
    sourceName: 取字符串(参数.来源名称, GetUnitName(source)),
    _dotParsedDuration: remaining,
  });
  播放附着特效(target, 取字符串(参数.特效路径, 燃烧默认特效), 取字符串(参数.特效挂点, "origin"), 取数值(参数.特效持续时间, 0.75));
  return true;
}

function 应用独立燃烧(this: void, source: any, target: any, 参数: 燃烧效果参数): boolean {
  const duration = 取数值(参数.持续时间, 0);
  const damage = 取数值(参数.每秒伤害, 0);
  if (!(duration > 0) || !(damage > 0)) return false;

  const buffID = 取字符串(参数.BuffID, 生成独立燃烧BuffID(target));
  独立燃烧表[buffID] = {
    source,
    target,
    buffID,
    damagePerSecond: damage,
    sourceName: 取字符串(参数.来源名称, GetUnitName(source)),
    iconPath: 取字符串(参数.图标路径, 燃烧默认图标),
    effectPath: 取字符串(参数.特效路径, 燃烧默认特效),
    effectAttachPoint: 取字符串(参数.特效挂点, "origin"),
    effectDuration: 取数值(参数.特效持续时间, 0.75),
  };
  registerManualBuff(target, buffID, duration, damage, {
    sourceName: 独立燃烧表[buffID]!.sourceName,
    iconOverride: 独立燃烧表[buffID]!.iconPath,
    effectModelOverride: 独立燃烧表[buffID]!.effectPath,
    onRemove: on独立燃烧移除,
  });
  播放附着特效(target, 独立燃烧表[buffID]!.effectPath, 独立燃烧表[buffID]!.effectAttachPoint, 独立燃烧表[buffID]!.effectDuration);
  确保独立燃烧驱动();
  return true;
}

export function 施加燃烧效果(this: void, source: any, target: any, 参数: 燃烧效果参数): boolean {
  if (source == null || source === 0) return false;
  if (target == null || target === 0) return false;
  if (参数 == null) return false;

  const mode = 参数.持续模式 ?? "刷新";
  if (mode === "独立") return 应用独立燃烧(source, target, 参数);
  return 应用共享燃烧(source, target, 参数);
}

export {};
