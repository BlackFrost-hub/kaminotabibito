/** @noSelfInFile */
/**
 * Star扩展库 - 硬直/暂停系统
 *
 * 来源于 SUSPEND.j，提供单位暂停控制功能。
 * 通过 EXPauseUnit(japi) 暂停单位，计时器到期后自动恢复。
 * 支持暂停时间累加、减少、取最大值等操作。
 *
 * 公开接口：
 *   GS_Suspend(u, time)          - 暂停单位一段时间
 *   GS_IsUnitSuspending(u)       - 检查单位是否处于暂停状态
 *   GS_LoadSuspend(u)            - 获取单位剩余暂停时间
 *   GS_UnitSuspend(u, i, r)      - 修改暂停时间（0=增加，1=减少，2=取最大值）
 */

const jass = require("jass.common") as any;
const { RMaxBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  RMaxBJ: (this: void, a: number, b: number) => number;
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

const HS_S = jass.InitHashtable();
const PauseUnit = jass.PauseUnit as (u: any, flag: boolean) => void;
const 单位暂停占用总表: Record<number, number | undefined> = {};
const 单位暂停占用来源表: Record<string, number | undefined> = {};

function hid(h: any): number {
  return (jass.GetHandleId(h) as number) || 0;
}

function 设置底层暂停状态(u: any, 是否暂停: boolean): void {
  if (u == null || u === 0) return;

  if (japi != null && typeof japi.EXPauseUnit === "function") {
    const EXPauseUnit = japi.EXPauseUnit as (u: any, flag: boolean) => void;
    EXPauseUnit(u, 是否暂停);
    return;
  }

  PauseUnit(u, 是否暂停);
}

function 生成暂停来源键(单位ID: number, 来源: string): string {
  return `${单位ID}:${来源}`;
}

export function 申请单位暂停占用(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;

  const 单位ID = hid(u);
  if (单位ID === 0) return false;

  const 来源键 = 生成暂停来源键(单位ID, 来源);
  const 原来源计数 = 单位暂停占用来源表[来源键] ?? 0;
  单位暂停占用来源表[来源键] = 原来源计数 + 1;

  if (原来源计数 > 0) {
    return true;
  }

  const 原总计数 = 单位暂停占用总表[单位ID] ?? 0;
  单位暂停占用总表[单位ID] = 原总计数 + 1;
  if (原总计数 <= 0) {
    设置底层暂停状态(u, true);
  }
  return true;
}

export function 释放单位暂停占用(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;

  const 单位ID = hid(u);
  if (单位ID === 0) return false;

  const 来源键 = 生成暂停来源键(单位ID, 来源);
  const 原来源计数 = 单位暂停占用来源表[来源键] ?? 0;
  if (原来源计数 <= 0) return false;

  if (原来源计数 <= 1) {
    delete 单位暂停占用来源表[来源键];
  } else {
    单位暂停占用来源表[来源键] = 原来源计数 - 1;
  }

  const 原总计数 = 单位暂停占用总表[单位ID] ?? 0;
  if (原总计数 <= 1) {
    delete 单位暂停占用总表[单位ID];
    设置底层暂停状态(u, false);
  } else {
    单位暂停占用总表[单位ID] = 原总计数 - 1;
  }
  return true;
}

export function 单位是否存在暂停占用(u: any): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  return (单位暂停占用总表[单位ID] ?? 0) > 0;
}

export function 单位是否存在其他暂停占用(u: any, 自身来源: string): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;

  const 总计数 = 单位暂停占用总表[单位ID] ?? 0;
  if (总计数 <= 0) return false;

  const 自身来源计数 = 自身来源 != null && 自身来源 !== ""
    ? (单位暂停占用来源表[生成暂停来源键(单位ID, 自身来源)] ?? 0)
    : 0;

  return 总计数 > 自身来源计数;
}

function onHardStraightTimerExpire(this: void): void {
  const expiredTimer = jass.GetExpiredTimer();
  const tid = hid(expiredTimer);
  const savedUnit = jass.LoadUnitHandle(HS_S, tid, 1);

  if (savedUnit != null && savedUnit !== 0) {
    释放单位暂停占用(savedUnit, "GS_Suspend");
  }

  jass.FlushChildHashtable(HS_S, tid);
  if (savedUnit != null && savedUnit !== 0) {
    jass.FlushChildHashtable(HS_S, hid(savedUnit));
  }
  safeDestroyTimer(expiredTimer);
}

/**
 * 暂停单位一段时间
 * 若单位已在暂停中，会重置暂停时间
 * @param u 目标单位
 * @param time 暂停时间（秒）
 */
export function GS_Suspend(u: any, time: number): void {
  if (u == null || u === 0) return;

  const uid = hid(u);
  let T: any = jass.LoadTimerHandle(HS_S, uid, 1);

  const remaining = T != null ? jass.TimerGetRemaining(T) : 0;

  if (T == null || remaining === 0) {
    T = jass.CreateTimer();
    if (T == null) return;

    申请单位暂停占用(u, "GS_Suspend");
    jass.SaveUnitHandle(HS_S, hid(T), 1, u);
    jass.SaveTimerHandle(HS_S, uid, 1, T);
  }

  safeTimerStart(T, time, false, onHardStraightTimerExpire);
}

/**
 * 检查单位是否处于暂停状态
 * @param u 目标单位
 * @returns 是否正在暂停中
 */
export function GS_IsUnitSuspending(u: any): boolean {
  if (u == null || u === 0) return false;

  const T = jass.LoadTimerHandle(HS_S, hid(u), 1);
  if (T == null) return false;

  const remaining = jass.TimerGetRemaining(T);
  return remaining !== 0;
}

/**
 * 获取单位剩余暂停时间
 * @param u 目标单位
 * @returns 剩余暂停时间（秒）
 */
export function GS_LoadSuspend(u: any): number {
  if (u == null || u === 0) return 0;

  const T = jass.LoadTimerHandle(HS_S, hid(u), 1);
  if (T == null) return 0;

  const remaining = jass.TimerGetRemaining(T);
  return remaining || 0;
}

/**
 * 修改单位暂停时间
 * @param u 目标单位
 * @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
 * @param r 时间值（秒）
 */
export function GS_UnitSuspend(u: any, i: number, r: number): void {
  if (u == null || u === 0) return;

  const currentRemain = GS_LoadSuspend(u);

  if (i === 0) {
    GS_Suspend(u, currentRemain + r);
  } else if (i === 1) {
    GS_Suspend(u, RMaxBJ(0, currentRemain - r));
  } else if (i === 2) {
    GS_Suspend(u, RMaxBJ(currentRemain, r));
  }
}

export {};
