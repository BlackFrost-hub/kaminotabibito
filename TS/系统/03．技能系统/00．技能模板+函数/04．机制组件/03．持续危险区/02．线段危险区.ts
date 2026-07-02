/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import { 创建技能提示圈 } from "../../02．通用函数/16．技能提示圈工厂";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

export interface 线段危险区参数 {
  清理?: 机制清理篮子;
  名称: string;
  起点X: number;
  起点Y: number;
  方向角: number;
  长度: number;
  宽度: number;
  持续秒: number;
  Tick间隔毫秒?: number;
  周期秒?: number;
  单位列表: (this: void) => any[];
  提示圈?: 技能提示圈配置 | false;
  on进入?: (this: void, 单位: any) => void;
  on离开?: (this: void, 单位: any) => void;
  on穿越?: (this: void, 单位: any) => void;
  on周期?: (this: void, 单位: any) => void;
  on结束?: (this: void) => void;
}

export interface 线段危险区实例 {
  停止(): void;
}

interface 单位线段状态 {
  在内部: boolean;
  下次周期Ms: number;
}

const 线段危险区表: Record<number, 线段危险区实现 | undefined> = {};
let 线段危险区驱动ID = 0;
let 下一个线段危险区ID = 0;

function 绝对值(this: void, value: number): number {
  return value >= 0 ? value : -value;
}

function 确保线段危险区驱动(this: void, 间隔毫秒: number): void {
  if (线段危险区驱动ID !== 0) return;
  线段危险区驱动ID = addPeriodicCallback(间隔毫秒, on线段危险区Tick);
}

function 尝试停止线段危险区驱动(this: void): void {
  for (const key in 线段危险区表) {
    if (线段危险区表[key] != null) return;
  }
  if (线段危险区驱动ID !== 0) {
    removePeriodicCallback(线段危险区驱动ID);
    线段危险区驱动ID = 0;
  }
}

function on线段危险区Tick(this: void): void {
  const now = getServerTime();
  for (const key in 线段危险区表) {
    const 实例 = 线段危险区表[key];
    if (实例 != null) 实例.推进(now);
  }
}

class 线段危险区实现 implements 线段危险区实例 {
  readonly ID: number;
  private 参数: 线段危险区参数;
  private 到期Ms: number;
  private 单位状态表: Record<number, 单位线段状态 | undefined> = {};
  private 前向X: number;
  private 前向Y: number;
  private 右向X: number;
  private 右向Y: number;
  private 已停止 = false;

  constructor(参数: 线段危险区参数) {
    this.ID = ++下一个线段危险区ID;
    this.参数 = 参数;
    this.到期Ms = getServerTime() + 参数.持续秒 * 1000;
    this.前向X = CosBJ(参数.方向角);
    this.前向Y = SinBJ(参数.方向角);
    this.右向X = CosBJ(参数.方向角 - 90);
    this.右向Y = SinBJ(参数.方向角 - 90);
    线段危险区表[this.ID] = this;
    this.创建提示圈();
    确保线段危险区驱动(参数.Tick间隔毫秒 ?? 100);
  }

  推进(now: number): void {
    if (this.已停止) return;
    if (now >= this.到期Ms) {
      this.停止();
      return;
    }
    const 单位列表 = this.参数.单位列表();
    for (let i = 0; i < 单位列表.length; i++) {
      const 单位 = 单位列表[i];
      if (!isValidUnit(单位)) continue;
      this.推进单位(now, 单位);
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 线段危险区表[this.ID];
    if (this.参数.on结束 != null) this.参数.on结束();
    尝试停止线段危险区驱动();
  }

  private 推进单位(now: number, 单位: any): void {
    const id = jass.GetHandleId(单位);
    const 当前在内部 = this.是否在内部(GetUnitX(单位), GetUnitY(单位));
    let 状态 = this.单位状态表[id];
    if (状态 == null) {
      状态 = { 在内部: false, 下次周期Ms: 0 };
      this.单位状态表[id] = 状态;
    }
    if (当前在内部 && !状态.在内部) {
      状态.在内部 = true;
      状态.下次周期Ms = now;
      if (this.参数.on进入 != null) this.参数.on进入(单位);
      if (this.参数.on穿越 != null) this.参数.on穿越(单位);
    } else if (!当前在内部 && 状态.在内部) {
      状态.在内部 = false;
      if (this.参数.on离开 != null) this.参数.on离开(单位);
    }
    if (当前在内部 && this.参数.on周期 != null && now >= 状态.下次周期Ms) {
      this.参数.on周期(单位);
      状态.下次周期Ms = now + (this.参数.周期秒 ?? 1) * 1000;
    }
  }

  private 是否在内部(x: number, y: number): boolean {
    const dx = x - this.参数.起点X;
    const dy = y - this.参数.起点Y;
    const 前向距离 = dx * this.前向X + dy * this.前向Y;
    if (前向距离 < 0 || 前向距离 > this.参数.长度) return false;
    const 横向距离 = dx * this.右向X + dy * this.右向Y;
    return 绝对值(横向距离) <= this.参数.宽度 * 0.5;
  }

  private 创建提示圈(): void {
    if (this.参数.提示圈 === false) return;
    const 中心X = this.参数.起点X + this.前向X * (this.参数.长度 * 0.5);
    const 中心Y = this.参数.起点Y + this.前向Y * (this.参数.长度 * 0.5);
    创建技能提示圈({
      类型: "矩形",
      X: 中心X,
      Y: 中心Y,
      宽度: this.参数.宽度,
      长度: this.参数.长度,
      朝向: this.参数.方向角,
      持续时间: this.参数.持续秒,
      ...(this.参数.提示圈 ?? {}),
    });
  }
}

export function 创建线段危险区(this: void, 参数: 线段危险区参数): 线段危险区实例 {
  const 实例 = new 线段危险区实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 线段危险区清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}
