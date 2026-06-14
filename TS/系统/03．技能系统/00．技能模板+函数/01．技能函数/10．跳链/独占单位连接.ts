/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export interface 独占单位连接参数 {
  来源单位: any;
  连接单位: any;
  候选目标列表: (this: void) => any[];
  已占用目标?: any[];
  持续秒: number;
  重试间隔秒?: number;
  连接半径?: number;
  闪电类型: string;
  闪电起点高度偏移?: number;
  闪电终点高度偏移?: number;
  闪电颜色?: { r: number; g: number; b: number; a: number };
  Tick间隔秒?: number;
  on连接成功?: (this: void, 连接单位: any, 目标单位: any) => void;
  on距离超出?: (this: void, 来源单位: any, 连接单位: any, 目标单位: any) => void;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 距离平方(this: void, a: any, b: any): number {
  const dx = GetUnitX(a) - GetUnitX(b);
  const dy = GetUnitY(a) - GetUnitY(b);
  return dx * dx + dy * dy;
}

function 单位在列表中(this: void, unit: any, list: any[] | undefined): boolean {
  if (list == null) return false;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === unit) return true;
  }
  return false;
}

function 选择未占用目标(this: void, 参数: 独占单位连接参数): any {
  const 取候选 = 参数.候选目标列表;
  const targets = 取候选();
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (单位有效(target) && !单位在列表中(target, 参数.已占用目标)) return target;
  }
  return null;
}

function 启动连接Tick(this: void, 参数: 独占单位连接参数, target: any): void {
  if (参数.Tick间隔秒 == null || !(参数.Tick间隔秒 > 0)) return;
  if (参数.on距离超出 == null || 参数.连接半径 == null || !(参数.连接半径 > 0)) return;
  const radius2 = 参数.连接半径 * 参数.连接半径;
  const tickMs = 参数.Tick间隔秒 * 1000;
  const timerId = addPeriodicCallback(tickMs, function 独占单位连接Tick(this: void): void {
    if (!单位有效(参数.来源单位) || !单位有效(参数.连接单位) || !单位有效(target)) {
      removePeriodicCallback(timerId);
      return;
    }
    if (距离平方(参数.连接单位, target) > radius2) {
      const on距离超出 = 参数.on距离超出;
      if (on距离超出 != null) on距离超出(参数.来源单位, 参数.连接单位, target);
    }
  });

  addDelayedCallback(参数.持续秒 * 1000, function 独占单位连接停止Tick(this: void): void {
    removePeriodicCallback(timerId);
  });
}

export function 启动独占单位连接(this: void, 参数: 独占单位连接参数): boolean {
  if (!单位有效(参数.来源单位) || !单位有效(参数.连接单位) || 参数.持续秒 <= 0) return false;
  let 已绑定 = false;
  let 已经过期 = false;
  let retryTimerId = 0;

  function 尝试连接目标(this: void): void {
    if (已绑定 || 已经过期) return;
    if (!单位有效(参数.来源单位) || !单位有效(参数.连接单位)) {
      已经过期 = true;
      if (retryTimerId !== 0) removePeriodicCallback(retryTimerId);
      return;
    }
    const target = 选择未占用目标(参数);
    if (!单位有效(target)) return;
    已绑定 = true;
    if (参数.已占用目标 != null) 参数.已占用目标.push(target);
    if (retryTimerId !== 0) removePeriodicCallback(retryTimerId);
    创建单位绑定闪电({
      效果代码: 参数.闪电类型,
      起点单位: 参数.连接单位,
      终点单位: target,
      持续时间: 参数.持续秒,
      起点高度偏移: 参数.闪电起点高度偏移,
      终点高度偏移: 参数.闪电终点高度偏移,
      任一死亡时销毁: true,
      颜色: 参数.闪电颜色,
    });
    启动连接Tick(参数, target);
    const on连接成功 = 参数.on连接成功;
    if (on连接成功 != null) on连接成功(参数.连接单位, target);
  }

  尝试连接目标();
  if (!已绑定 && 参数.重试间隔秒 != null && 参数.重试间隔秒 > 0) {
    retryTimerId = addPeriodicCallback(参数.重试间隔秒 * 1000, 尝试连接目标);
  }

  addDelayedCallback(参数.持续秒 * 1000, function 独占单位连接过期(this: void): void {
    已经过期 = true;
    if (retryTimerId !== 0) removePeriodicCallback(retryTimerId);
  });
  return 已绑定;
}
