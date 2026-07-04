/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export interface 刷新型周期目标效果上下文 {
  key: string;
  来源单位: any;
  目标单位: any;
  当前时间毫秒: number;
}

export interface 刷新型周期目标效果参数 {
  key前缀: string;
  来源单位: any;
  目标单位: any;
  持续毫秒: number;
  间隔毫秒: number;
  检查间隔毫秒?: number;
  刷新时重置下次周期?: boolean;
  有效性检查?: (this: void, 上下文: 刷新型周期目标效果上下文) => boolean;
  on周期: (this: void, 上下文: 刷新型周期目标效果上下文) => void;
}

interface 刷新型周期目标效果记录 {
  key: string;
  来源单位: any;
  目标单位: any;
  expireTime: number;
  nextTickTime: number;
  intervalMs: number;
  有效性检查?: (this: void, 上下文: 刷新型周期目标效果上下文) => boolean;
  on周期: (this: void, 上下文: 刷新型周期目标效果上下文) => void;
}

const 周期目标效果记录列表: 刷新型周期目标效果记录[] = [];
let 周期目标效果驱动ID = 0;
let 周期目标效果检查间隔毫秒 = 100;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位有效存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 生成周期目标效果key(this: void, 参数: 刷新型周期目标效果参数): string {
  const 来源ID = 取单位句柄ID(参数.来源单位);
  const 目标ID = 取单位句柄ID(参数.目标单位);
  if (来源ID === 0 || 目标ID === 0) return "";
  return 参数.key前缀 + ":" + 来源ID + ":" + 目标ID;
}

function 构建上下文(this: void, 记录: 刷新型周期目标效果记录, now: number): 刷新型周期目标效果上下文 {
  return {
    key: 记录.key,
    来源单位: 记录.来源单位,
    目标单位: 记录.目标单位,
    当前时间毫秒: now,
  };
}

function 记录仍有效(this: void, 记录: 刷新型周期目标效果记录, now: number): boolean {
  if (now >= 记录.expireTime) return false;
  if (!单位有效存活(记录.来源单位) || !单位有效存活(记录.目标单位)) return false;
  if (记录.有效性检查 == null) return true;
  return 记录.有效性检查(构建上下文(记录, now));
}

function on刷新型周期目标效果Tick(this: void): void {
  const now = getServerTime();
  let write = 0;
  for (let i = 0; i < 周期目标效果记录列表.length; i++) {
    const 记录 = 周期目标效果记录列表[i];
    if (记录 == null || !记录仍有效(记录, now)) continue;
    if (now >= 记录.nextTickTime) {
      记录.on周期(构建上下文(记录, now));
      记录.nextTickTime = now + 记录.intervalMs;
    }
    周期目标效果记录列表[write] = 记录;
    write++;
  }
  while (周期目标效果记录列表.length > write) 周期目标效果记录列表.pop();
  if (周期目标效果记录列表.length <= 0 && 周期目标效果驱动ID !== 0) {
    removePeriodicCallback(周期目标效果驱动ID);
    周期目标效果驱动ID = 0;
  }
}

function 确保刷新型周期目标效果驱动(this: void, 检查间隔毫秒: number): void {
  if (周期目标效果驱动ID !== 0) return;
  周期目标效果检查间隔毫秒 = 检查间隔毫秒 > 0 ? 检查间隔毫秒 : 100;
  周期目标效果驱动ID = addPeriodicCallback(周期目标效果检查间隔毫秒, on刷新型周期目标效果Tick);
}

export function 施加或刷新周期目标效果(this: void, 参数: 刷新型周期目标效果参数): void {
  if (参数 == null || 参数.on周期 == null) return;
  if (参数.持续毫秒 <= 0 || 参数.间隔毫秒 <= 0) return;
  if (!单位有效存活(参数.来源单位) || !单位有效存活(参数.目标单位)) return;
  const key = 生成周期目标效果key(参数);
  if (key === "") return;

  const now = getServerTime();
  const expireTime = now + 参数.持续毫秒;
  for (let i = 0; i < 周期目标效果记录列表.length; i++) {
    const 记录 = 周期目标效果记录列表[i];
    if (记录 == null || 记录.key !== key) continue;
    记录.expireTime = expireTime;
    记录.intervalMs = 参数.间隔毫秒;
    记录.有效性检查 = 参数.有效性检查;
    记录.on周期 = 参数.on周期;
    if (参数.刷新时重置下次周期 === true) {
      记录.nextTickTime = now + 参数.间隔毫秒;
    }
    确保刷新型周期目标效果驱动(参数.检查间隔毫秒 ?? 周期目标效果检查间隔毫秒);
    return;
  }

  周期目标效果记录列表.push({
    key,
    来源单位: 参数.来源单位,
    目标单位: 参数.目标单位,
    expireTime,
    nextTickTime: now + 参数.间隔毫秒,
    intervalMs: 参数.间隔毫秒,
    有效性检查: 参数.有效性检查,
    on周期: 参数.on周期,
  });
  确保刷新型周期目标效果驱动(参数.检查间隔毫秒 ?? 100);
}

