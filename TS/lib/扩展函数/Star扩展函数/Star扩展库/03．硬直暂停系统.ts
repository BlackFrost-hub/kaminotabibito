/** @noSelfInFile */
/**
 * Star扩展库 - 硬直/暂停系统
 *
 * 来源于 SUSPEND.j，提供单位暂停控制功能。
 * 通过 EXPauseUnit(japi) 暂停单位，中心计时器驱动到期后自动恢复。
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
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

const PauseUnit = jass.PauseUnit as (u: any, flag: boolean) => void;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const EXPauseUnit = japi != null && typeof japi.EXPauseUnit === "function"
  ? japi.EXPauseUnit as (u: any, flag: boolean) => void
  : undefined;
const 单位暂停占用总表: Record<number, number | undefined> = {};
const 单位暂停占用来源表: Record<string, number | undefined> = {};

function hid(h: any): number {
  return GetHandleId(h) || 0;
}

function 设置底层暂停状态(u: any, 是否暂停: boolean): void {
  if (u == null || u === 0) return;

  if (EXPauseUnit != null) {
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

interface 硬直到期任务 {
  单位: any;
  单位ID: number;
  到期时间毫秒: number;
}

const 硬直到期任务列表: 硬直到期任务[] = [];
let 硬直到期驱动已注册 = false;

function 查找硬直到期任务索引(单位ID: number): number {
  for (let i = 0; i < 硬直到期任务列表.length; i++) {
    if (硬直到期任务列表[i].单位ID === 单位ID) return i;
  }
  return -1;
}

function on硬直到期驱动(this: void): void {
  if (硬直到期任务列表.length === 0) return;

  const 当前时间毫秒 = getServerTime();
  let 写入位置 = 0;
  for (let i = 0; i < 硬直到期任务列表.length; i++) {
    const 任务 = 硬直到期任务列表[i];
    if (当前时间毫秒 >= 任务.到期时间毫秒) {
      释放单位暂停占用(任务.单位, "GS_Suspend");
    } else {
      硬直到期任务列表[写入位置] = 任务;
      写入位置++;
    }
  }
  while (硬直到期任务列表.length > 写入位置) {
    硬直到期任务列表.pop();
  }
}

function 确保硬直到期驱动(): void {
  if (硬直到期驱动已注册) return;
  硬直到期驱动已注册 = true;
  addPeriodicCallback(10, on硬直到期驱动);
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
  if (uid === 0) return;
  const 到期时间毫秒 = getServerTime() + RMaxBJ(0, time) * 1000;
  const 任务索引 = 查找硬直到期任务索引(uid);
  if (任务索引 < 0) {
    申请单位暂停占用(u, "GS_Suspend");
    硬直到期任务列表.push({ 单位: u, 单位ID: uid, 到期时间毫秒 });
  } else {
    const 任务 = 硬直到期任务列表[任务索引];
    任务.单位 = u;
    任务.到期时间毫秒 = 到期时间毫秒;
  }
  确保硬直到期驱动();
}

/**
 * 检查单位是否处于暂停状态
 * @param u 目标单位
 * @returns 是否正在暂停中
 */
export function GS_IsUnitSuspending(u: any): boolean {
  if (u == null || u === 0) return false;

  return GS_LoadSuspend(u) > 0;
}

/** 获取单位剩余暂停时间（秒）。 */
export function GS_LoadSuspend(u: any): number {
  if (u == null || u === 0) return 0;

  const uid = hid(u);
  if (uid === 0) return 0;
  const 任务索引 = 查找硬直到期任务索引(uid);
  if (任务索引 < 0) return 0;
  return RMaxBJ(0, 硬直到期任务列表[任务索引].到期时间毫秒 - getServerTime()) * 0.001;
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
