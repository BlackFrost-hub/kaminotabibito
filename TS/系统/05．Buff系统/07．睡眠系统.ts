/** @noSelfInFile */
/**
 * 睡眠系统
 *
 * 睡眠的底层控制走统一暂停占用；Buff 条仍使用 C016 的睡眠图标与睡眠头顶特效。
 */

const jass = require("jass.common") as any;
const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const {
  registerManualBuff,
  getBuffRuntime,
  移除单位指定Buff,
} = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { Sound3DII_UnitPlay } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_UnitPlay: (this: void, path: string, unit: any, cutoff: number, model?: any) => any;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const IsUnitType = jass.IsUnitType as (unit: any, whichType: any) => boolean;

export const 睡眠BuffID = "C016";
export const 睡眠图标路径 = "ReplaceableTextures\\CommandButtons\\BTNSleep.blp";
export const 睡眠特效路径 = "Abilities\\Spells\\Undead\\Sleep\\SleepTarget.mdl";
export const 睡眠特效挂点 = "overhead";
export const 睡眠默认音效路径 = "Abilities\\Spells\\Undead\\Sleep\\SleepBirth1.wav";
export const 睡眠默认音效裁断距离 = 1600;

export type 睡眠结束原因 = "到期" | "伤害打破" | "驱散" | "覆盖" | "手动";

export interface 睡眠参数 {
  来源单位?: any;
  目标单位: any;
  持续时间: number;
  伤害阈值?: number;
  保底时间?: number;
  来源名称?: string;
}

export interface 睡眠事件 {
  目标单位: any;
  目标单位ID: number;
  来源单位?: any;
  持续时间: number;
  保底时间: number;
  伤害阈值: number;
  已累计伤害: number;
  打破者?: any;
  打破伤害?: number;
  原因?: 睡眠结束原因;
}

type 睡眠监听 = (this: void, event: 睡眠事件) => void;

interface 睡眠状态 {
  目标单位: any;
  目标单位ID: number;
  来源单位?: any;
  开始时间毫秒: number;
  到期时间毫秒: number;
  保底到期毫秒: number;
  持续时间: number;
  保底时间: number;
  伤害阈值: number;
  已累计伤害: number;
  暂停来源: string;
  等待保底后打破: boolean;
  打破者?: any;
  打破伤害?: number;
}

const 睡眠状态表: Record<number, 睡眠状态 | undefined> = {};
const 睡眠目标ID列表: number[] = [];
const 睡眠结束原因表: Record<number, 睡眠结束原因 | undefined> = {};

const 被睡眠监听列表: 睡眠监听[] = [];
const 醒来监听列表: 睡眠监听[] = [];
const 睡眠打破监听列表: 睡眠监听[] = [];

let 已初始化 = false;
let 保底检查驱动已注册 = false;

function 取单位ID(unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位有效且存活(unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitType(unit, jass.UNIT_TYPE_DEAD) !== true;
}

function 取非负数(value: number | undefined, fallback: number): number {
  if (value == null || typeof value !== "number" || !isFinite(value)) return fallback;
  return value > 0 ? value : 0;
}

function 加入睡眠目标ID(id: number): void {
  for (let i = 0; i < 睡眠目标ID列表.length; i++) {
    if (睡眠目标ID列表[i] === id) return;
  }
  睡眠目标ID列表.push(id);
}

function 移除睡眠目标ID(id: number): void {
  for (let i = 0; i < 睡眠目标ID列表.length; i++) {
    if (睡眠目标ID列表[i] === id) {
      睡眠目标ID列表.splice(i, 1);
      return;
    }
  }
}

function 注册睡眠监听(list: 睡眠监听[], cb: 睡眠监听): void {
  if (cb == null) return;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === cb) return;
  }
  list.push(cb);
}

function 构建睡眠事件(状态: 睡眠状态, 原因?: 睡眠结束原因): 睡眠事件 {
  return {
    目标单位: 状态.目标单位,
    目标单位ID: 状态.目标单位ID,
    来源单位: 状态.来源单位,
    持续时间: 状态.持续时间,
    保底时间: 状态.保底时间,
    伤害阈值: 状态.伤害阈值,
    已累计伤害: 状态.已累计伤害,
    打破者: 状态.打破者,
    打破伤害: 状态.打破伤害,
    原因,
  };
}

function 通知睡眠监听(list: 睡眠监听[], event: 睡眠事件): void {
  for (let i = 0; i < list.length; i++) {
    list[i](event);
  }
}

function 取暂停来源(目标单位ID: number): string {
  return "SleepBuff:" + tostring(目标单位ID);
}

function 播放睡眠默认音效(unit: any): void {
  Sound3DII_UnitPlay(睡眠默认音效路径, unit, 睡眠默认音效裁断距离);
}

function 清除睡眠状态(状态: 睡眠状态, 原因: 睡眠结束原因): void {
  delete 睡眠状态表[状态.目标单位ID];
  delete 睡眠结束原因表[状态.目标单位ID];
  移除睡眠目标ID(状态.目标单位ID);
  移除单位暂停(状态.目标单位, 状态.暂停来源);

  const event = 构建睡眠事件(状态, 原因);
  if (原因 === "伤害打破") {
    通知睡眠监听(睡眠打破监听列表, event);
  }
  通知睡眠监听(醒来监听列表, event);
}

function on睡眠Buff移除(this: void, unit: any, _buffID: string, row: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  const 状态 = 睡眠状态表[id];
  if (状态 == null) return;
  const pending = 睡眠结束原因表[id];
  let 原因: 睡眠结束原因 = pending ?? "驱散";
  if (pending == null && row != null && typeof row.remaining === "number" && row.remaining <= 0) {
    原因 = "到期";
  }
  清除睡眠状态(状态, 原因);
}

function 尝试伤害打破睡眠(状态: 睡眠状态, attacker: any, damage: number): void {
  if (状态.伤害阈值 <= 0 || 状态.已累计伤害 < 状态.伤害阈值) return;
  const now = getServerTime();
  状态.打破者 = attacker;
  状态.打破伤害 = damage;
  if (now < 状态.保底到期毫秒) {
    状态.等待保底后打破 = true;
    确保保底检查驱动();
    return;
  }
  睡眠结束原因表[状态.目标单位ID] = "伤害打破";
  移除单位指定Buff(状态.目标单位, 睡眠BuffID);
}

function on睡眠最终伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (applied <= 0) return;
  const id = 取单位ID(target);
  if (id === 0) return;
  const 状态 = 睡眠状态表[id];
  if (状态 == null) return;
  状态.已累计伤害 = 状态.已累计伤害 + applied;
  尝试伤害打破睡眠(状态, attacker, applied);
}

function on睡眠保底检查(this: void): void {
  if (睡眠目标ID列表.length === 0) return;
  const now = getServerTime();
  let index = 0;
  while (index < 睡眠目标ID列表.length) {
    const id = 睡眠目标ID列表[index];
    const 状态 = 睡眠状态表[id];
    if (状态 == null) {
      睡眠目标ID列表.splice(index, 1);
      continue;
    }
    if (状态.等待保底后打破 && now >= 状态.保底到期毫秒 && 状态.已累计伤害 >= 状态.伤害阈值) {
      睡眠结束原因表[id] = "伤害打破";
      移除单位指定Buff(状态.目标单位, 睡眠BuffID);
      continue;
    }
    index++;
  }
}

function 确保保底检查驱动(): void {
  if (保底检查驱动已注册) return;
  保底检查驱动已注册 = true;
  addPeriodicCallback(50, on睡眠保底检查);
}

export function 初始化睡眠系统(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerAppliedFinalDamageListener(on睡眠最终伤害);
}

export function 注册任意单位被睡眠监听(this: void, cb: 睡眠监听): void {
  注册睡眠监听(被睡眠监听列表, cb);
}

export function 注册任意单位醒来监听(this: void, cb: 睡眠监听): void {
  注册睡眠监听(醒来监听列表, cb);
}

export function 注册任意单位睡眠被打破监听(this: void, cb: 睡眠监听): void {
  注册睡眠监听(睡眠打破监听列表, cb);
}

export function 单位正在睡眠(this: void, unit: any): boolean {
  const id = 取单位ID(unit);
  return id !== 0 && 睡眠状态表[id] != null;
}

export function 清除睡眠(this: void, unit: any, 原因: 睡眠结束原因 = "手动"): boolean {
  const id = 取单位ID(unit);
  if (id === 0) return false;
  const 状态 = 睡眠状态表[id];
  if (状态 == null) return false;
  睡眠结束原因表[id] = 原因;
  if (移除单位指定Buff(unit, 睡眠BuffID)) return true;
  清除睡眠状态(状态, 原因);
  return true;
}

export function 施加睡眠(this: void, 参数: 睡眠参数): boolean {
  初始化睡眠系统();
  if (参数 == null) return false;
  const 目标单位 = 参数.目标单位;
  if (!单位有效且存活(目标单位)) return false;
  const 持续时间 = 取非负数(参数.持续时间, 0);
  if (持续时间 <= 0) return false;
  const 目标单位ID = 取单位ID(目标单位);
  if (目标单位ID === 0) return false;

  if (睡眠状态表[目标单位ID] != null) {
    清除睡眠(目标单位, "覆盖");
  }

  const now = getServerTime();
  let 保底时间 = 取非负数(参数.保底时间, 0);
  if (保底时间 > 持续时间) 保底时间 = 持续时间;
  const 伤害阈值 = 取非负数(参数.伤害阈值, 1);
  const 暂停来源 = 取暂停来源(目标单位ID);
  const 状态: 睡眠状态 = {
    目标单位,
    目标单位ID,
    来源单位: 参数.来源单位,
    开始时间毫秒: now,
    到期时间毫秒: now + 持续时间 * 1000,
    保底到期毫秒: now + 保底时间 * 1000,
    持续时间,
    保底时间,
    伤害阈值,
    已累计伤害: 0,
    暂停来源,
    等待保底后打破: false,
  };
  睡眠状态表[目标单位ID] = 状态;
  加入睡眠目标ID(目标单位ID);

  const 来源名称 = 参数.来源名称 != null && 参数.来源名称 !== ""
    ? 参数.来源名称
    : (参数.来源单位 != null && 参数.来源单位 !== 0 ? GetUnitName(参数.来源单位) : "睡眠");

  registerManualBuff(目标单位, 睡眠BuffID, 持续时间, 伤害阈值, {
    sourceName: 来源名称,
    iconOverride: 睡眠图标路径,
    effectModelOverride: 睡眠特效路径,
    effectValue2: 保底时间,
    onRemove: on睡眠Buff移除,
    tickWhilePaused: true,
  });

  if (getBuffRuntime(目标单位, 睡眠BuffID) == null) {
    delete 睡眠状态表[目标单位ID];
    移除睡眠目标ID(目标单位ID);
    return false;
  }

  if (!添加单位暂停(目标单位, 暂停来源)) {
    睡眠结束原因表[目标单位ID] = "手动";
    移除单位指定Buff(目标单位, 睡眠BuffID);
    return false;
  }

  播放睡眠默认音效(目标单位);
  通知睡眠监听(被睡眠监听列表, 构建睡眠事件(状态));
  if (保底时间 > 0) 确保保底检查驱动();
  return true;
}

export {};
