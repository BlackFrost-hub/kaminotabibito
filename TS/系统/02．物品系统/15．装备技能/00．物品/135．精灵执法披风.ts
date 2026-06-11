/** @noSelfInFile */

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 常规BuffID } = require("系统.05．Buff系统.03．Buff表.00．Buff登记") as {
  常规BuffID: { 精灵执法披风_秩序领域: string };
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 精灵执法披风配置 = {
  物品名: "精灵执法披风",
  范围: 300,
  周期毫秒: 500,
  攻速降低: -0.15,
  攻速属性ID: 10,
  BuffID: 常规BuffID.精灵执法披风_秩序领域,
  Buff持续时间: 1,
} as const;

const 精灵执法披风物品ID = stringToFourCCSafe(resolveItemIdByName(精灵执法披风配置.物品名));
const 精灵执法披风持有者列表: any[] = [];
const 精灵执法披风持有者表: Record<number, any | undefined> = {};
const 精灵执法披风影响层数表: Record<number, number | undefined> = {};
const 精灵执法披风影响单位表: Record<number, any | undefined> = {};
const 精灵执法披风来源名称表: Record<number, string | undefined> = {};

let 已初始化精灵执法披风 = false;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 加入精灵执法披风持有者(this: void, unit: any): void {
  const unitId = 取单位ID(unit);
  if (unitId === 0 || 精灵执法披风持有者表[unitId] != null) return;
  精灵执法披风持有者表[unitId] = unit;
  精灵执法披风持有者列表.push(unit);
}

function 移除精灵执法披风持有者(this: void, unit: any): void {
  const unitId = 取单位ID(unit);
  if (unitId === 0) return;
  delete 精灵执法披风持有者表[unitId];
  for (let i = 精灵执法披风持有者列表.length - 1; i >= 0; i--) {
    if (取单位ID(精灵执法披风持有者列表[i]) === unitId) {
      精灵执法披风持有者列表.splice(i, 1);
    }
  }
}

function on获得精灵执法披风(this: void, unit: any, _item: any, currentCount: number, _previousCount: number): void {
  if (currentCount > 0) 加入精灵执法披风持有者(unit);
}

function on失去精灵执法披风(this: void, unit: any, _item: any, currentCount: number, _previousCount: number): void {
  if (currentCount <= 0) 移除精灵执法披风持有者(unit);
}

function 记录精灵执法披风影响(this: void, next: Record<number, number | undefined>, source: any, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  next[id] = (next[id] ?? 0) + 1;
  精灵执法披风影响单位表[id] = unit;
  if (精灵执法披风来源名称表[id] == null && source != null && source !== 0) {
    精灵执法披风来源名称表[id] = "『精灵执法披风』「" + GetUnitName(source) + "」";
  }
}

function 调整精灵执法披风影响层数(this: void, unit: any, delta: number): void {
  if (delta === 0 || unit == null || unit === 0) return;
  SGSS_SetState(unit, 精灵执法披风配置.攻速属性ID, 精灵执法披风配置.攻速降低 * delta);
}

function 同步精灵执法披风影响(this: void, next: Record<number, number | undefined>): void {
  for (const id in 精灵执法披风影响层数表) {
    if (next[id] == null) next[id] = 0;
  }
  for (const id in next) {
    const oldCount = 精灵执法披风影响层数表[id] ?? 0;
    const newCount = next[id] ?? 0;
    if (oldCount !== newCount) {
      调整精灵执法披风影响层数(精灵执法披风影响单位表[id], newCount - oldCount);
    }
    if (newCount > 0) {
      精灵执法披风影响层数表[id] = newCount;
      registerManualBuff(精灵执法披风影响单位表[id], 精灵执法披风配置.BuffID, 精灵执法披风配置.Buff持续时间, 15, {
        sourceName: 精灵执法披风来源名称表[id],
      });
    } else {
      移除单位指定Buff(精灵执法披风影响单位表[id], 精灵执法披风配置.BuffID);
      delete 精灵执法披风影响层数表[id];
      delete 精灵执法披风影响单位表[id];
      delete 精灵执法披风来源名称表[id];
    }
  }
}

function on精灵执法披风周期(this: void): void {
  const next: Record<number, number | undefined> = {};
  for (const id in 精灵执法披风来源名称表) {
    delete 精灵执法披风来源名称表[id];
  }
  for (let i = 精灵执法披风持有者列表.length - 1; i >= 0; i--) {
    const holder = 精灵执法披风持有者列表[i];
    if (!单位存活(holder) || 获取单位当前持有指定物品数量(holder, 精灵执法披风物品ID) <= 0) {
      移除精灵执法披风持有者(holder);
      continue;
    }
    const targets = getUnitsInRange(GetUnitX(holder), GetUnitY(holder), 精灵执法披风配置.范围);
    for (let j = 0; j < targets.length; j++) {
      const target = targets[j];
      if (!单位存活(target)) continue;
      if (isUnitEnemy(target, holder) !== true) continue;
      记录精灵执法披风影响(next, holder, target);
    }
  }
  同步精灵执法披风影响(next);
}

export function 初始化精灵执法披风效果(this: void): void {
  if (已初始化精灵执法披风) return;
  已初始化精灵执法披风 = true;
  if (精灵执法披风物品ID === 0) return;
  监听指定物品获取丢弃(精灵执法披风物品ID, on获得精灵执法披风, on失去精灵执法披风);
  addPeriodicCallback(精灵执法披风配置.周期毫秒, on精灵执法披风周期);
}

初始化精灵执法披风效果();

export {};
