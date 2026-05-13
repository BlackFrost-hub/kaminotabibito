/** @noSelfInFile */
/**
 * 重伤系统 - 核心功能
 *
 * 1. 玩家1-4的单位从装备读取重伤值（取最高），走YDUserData
 * 2. 造成伤害时，给被伤害的单位添加buffUI重伤（C021），每次造成伤害刷新持续时间
 * 3. 重伤减少目标受到的治疗效果
 */

const jass = require("jass.common") as any;

import {
  重伤系统开关,
  重伤上限,
  重伤下限,
  重伤BuffID,
  重伤效果系数,
  重伤默认持续时间,
} from "./00．常量定义";

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerHealCallback: (this: void, cb: (source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};

const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: { sourceName?: string }
  ) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;

function 读取YD用户数据(this: void, tableType: string, tableKey: any, attr: string, valueType: string): any {
  return YDUserDataGetSafe(tableType, tableKey, attr, valueType);
}

/** 限制重伤值在有效范围内 */
function 限制重伤值(value: number): number {
  if (value < 重伤下限) return 重伤下限;
  if (value > 重伤上限) return 重伤上限;
  return value;
}

/** 获取单位装备重伤值（所属玩家0-4的单位从玩家读取，其他从单位读取） */
function 获取装备重伤值(unit: any): number {
  if (unit == null || unit === 0) return 0;
  const owner = GetOwningPlayer(unit);
  const playerId = GetPlayerId(owner);
  if (playerId >= 0 && playerId <= 3) {
    const v = 读取YD用户数据("player", owner, "重伤", "real");
    return typeof v === "number" ? 限制重伤值(v) : 0;
  }
  const v = 读取YD用户数据("unit", unit, "重伤", "real");
  return typeof v === "number" ? 限制重伤值(v) : 0;
}

/** 获取单位当前受到的重伤值（从buff系统读取） */
export function 获取单位重伤(unit: any): number {
  if (unit == null || unit === 0) return 0;
  const buffRuntime = getBuffRuntime(unit, 重伤BuffID);
  if (buffRuntime == null) return 0;
  return 限制重伤值(buffRuntime.effect);
}

/**
 * 给单位施加重伤（buff方式）
 * @param unit 目标单位
 * @param 重伤值 0-1，如 0.5 = 治疗效果减半
 * @param 持续时间 秒，默认3秒
 */
export function 施加重伤(unit: any, 重伤值: number, 持续时间: number = 重伤默认持续时间, source?: any): void {
  if (unit == null || unit === 0) return;
  if (持续时间 <= 0) return;
  const 最终值 = 限制重伤值(重伤值);
  if (最终值 <= 0) return;
  const sourceName = source != null && source !== 0 ? jass.GetUnitName(source) : undefined;
  registerManualBuff(unit, 重伤BuffID, 持续时间, 最终值 * 重伤效果系数, {
    sourceName: typeof sourceName === "string" && sourceName !== "" ? sourceName : undefined,
  });
}

/** 移除单位重伤 */
export function 移除单位重伤(unit: any): void {
  if (unit == null || unit === 0) return;
  移除单位指定Buff(unit, 重伤BuffID);
}

/** 计算重伤后的治疗量 */
function 计算重伤治疗量(source: any, target: any, amount: number): number {
  if (!重伤系统开关) return amount;
  if (amount <= 0) return 0;
  const wound = 获取单位重伤(target);
  if (wound <= 0) return amount;
  return amount * (1 - wound);
}

/** 伤害事件回调：来源有装备重伤时，给目标施加重伤 */
function on伤害事件(...args: any[]): void {
  if (!重伤系统开关) return;

  // 伤害事件可能传 self 作为第一个参数，需要兼容
  let target: any, source: any;
  if (args.length >= 6) {
    // 带 self: nil, target, damage, damageType, fromDotTick, source
    target = args[1];
    source = args[5];
  } else {
    // 不带 self: target, damage, damageType, fromDotTick, source
    target = args[0];
    source = args[4];
  }

  if (source == null || source === 0) return;
  if (target == null || target === 0) return;

  const 装备重伤 = 获取装备重伤值(source);
  if (装备重伤 <= 0) return;

  施加重伤(target, 装备重伤, 重伤默认持续时间, source);
}

/** 注册重伤回调到治疗系统和伤害事件 */
export function initWoundSystem(): void {
  if (!重伤系统开关) return;
  registerHealCallback(计算重伤治疗量);

  // 伤害事件注册：显式传 damageEventModule 作为 self，避免 self 错位
  const damageEventModule = require("系统.04．伤害系统.01．伤害事件") as any;
  const regCb = damageEventModule.registerDamageCallback;
  regCb(damageEventModule, on伤害事件, 0);
}

export {};
