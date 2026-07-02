/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 默认闪电效果代码 } from "../../02．通用函数/17．闪电效果代码";

const jass = require("jass.common") as any;

const AddLightningEx = jass.AddLightningEx as (codeName: string, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => any;
const MoveLightningEx = jass.MoveLightningEx as (whichLightning: any, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => boolean;
const DestroyLightning = jass.DestroyLightning as (whichLightning: any) => boolean;
const SetLightningColor = jass.SetLightningColor as (whichLightning: any, r: number, g: number, b: number, a: number) => void;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (u: any) => number;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

export interface 持续单位连线参数 {
  清理?: 机制清理篮子;
  名称: string;
  起点单位: any;
  终点单位: any;
  闪电代码?: string;
  持续秒?: number;
  起点高度?: number;
  终点高度?: number;
  断开距离?: number;
  Tick间隔毫秒?: number;
  颜色?: { r: number; g: number; b: number; a: number };
  on断开?: (this: void, 原因: string) => void;
  on周期?: (this: void, 起点单位: any, 终点单位: any) => void;
}

export interface 持续单位连线实例 {
  readonly 闪电: any;
  停止(this: void, 原因?: string): void;
}

const 持续单位连线表: Record<number, 持续单位连线实现 | undefined> = {};
let 持续单位连线驱动ID = 0;
let 下一个持续单位连线ID = 0;

function 距离平方(this: void, a: any, b: any): number {
  const dx = GetUnitX(a) - GetUnitX(b);
  const dy = GetUnitY(a) - GetUnitY(b);
  return dx * dx + dy * dy;
}

function 取单位Z(this: void, 单位: any, 高度: number): number {
  return GetUnitFlyHeight(单位) + 高度;
}

function 确保持续单位连线驱动(this: void, 间隔毫秒: number): void {
  if (持续单位连线驱动ID !== 0) return;
  持续单位连线驱动ID = addPeriodicCallback(间隔毫秒, on持续单位连线Tick);
}

function 尝试停止持续单位连线驱动(this: void): void {
  for (const key in 持续单位连线表) {
    if (持续单位连线表[key] != null) return;
  }
  if (持续单位连线驱动ID !== 0) {
    removePeriodicCallback(持续单位连线驱动ID);
    持续单位连线驱动ID = 0;
  }
}

function on持续单位连线Tick(this: void): void {
  const now = getServerTime();
  for (const key in 持续单位连线表) {
    const 实例 = 持续单位连线表[key];
    if (实例 != null) 实例.推进(now);
  }
}

class 持续单位连线实现 implements 持续单位连线实例 {
  readonly ID: number;
  readonly 闪电: any;
  private 参数: 持续单位连线参数;
  private 到期Ms: number;
  private 已停止 = false;

  constructor(闪电: any, 参数: 持续单位连线参数) {
    this.ID = ++下一个持续单位连线ID;
    this.闪电 = 闪电;
    this.参数 = 参数;
    this.到期Ms = 参数.持续秒 == null || 参数.持续秒 <= 0 ? 0 : getServerTime() + 参数.持续秒 * 1000;
    持续单位连线表[this.ID] = this;
    确保持续单位连线驱动(参数.Tick间隔毫秒 ?? 30);
  }

  推进(now: number): void {
    if (this.已停止) return;
    const 起点 = this.参数.起点单位;
    const 终点 = this.参数.终点单位;
    if (!isValidUnit(起点) || !isValidUnit(终点)) {
      this.停止("单位失效");
      return;
    }
    if (this.到期Ms > 0 && now >= this.到期Ms) {
      this.停止("持续时间结束");
      return;
    }
    const 断开距离 = this.参数.断开距离;
    if (断开距离 != null && 断开距离 > 0 && 距离平方(起点, 终点) > 断开距离 * 断开距离) {
      this.停止("距离断开");
      return;
    }
    MoveLightningEx(
      this.闪电,
      false,
      GetUnitX(起点),
      GetUnitY(起点),
      取单位Z(起点, this.参数.起点高度 ?? 60),
      GetUnitX(终点),
      GetUnitY(终点),
      取单位Z(终点, this.参数.终点高度 ?? 60),
    );
    if (this.参数.on周期 != null) this.参数.on周期(起点, 终点);
  }

  停止(原因: string = "手动停止"): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 持续单位连线表[this.ID];
    if (this.闪电 != null && this.闪电 !== 0) DestroyLightning(this.闪电);
    if (this.参数.on断开 != null) this.参数.on断开(原因);
    尝试停止持续单位连线驱动();
  }
}

export function 创建持续单位连线(this: void, 参数: 持续单位连线参数): 持续单位连线实例 | undefined {
  const 起点 = 参数.起点单位;
  const 终点 = 参数.终点单位;
  if (!isValidUnit(起点) || !isValidUnit(终点)) return undefined;
  const 闪电 = AddLightningEx(
    参数.闪电代码 ?? 默认闪电效果代码,
    false,
    GetUnitX(起点),
    GetUnitY(起点),
    取单位Z(起点, 参数.起点高度 ?? 60),
    GetUnitX(终点),
    GetUnitY(终点),
    取单位Z(终点, 参数.终点高度 ?? 60),
  );
  if (闪电 == null || 闪电 === 0) return undefined;
  if (参数.颜色 != null) SetLightningColor(闪电, 参数.颜色.r, 参数.颜色.g, 参数.颜色.b, 参数.颜色.a);
  const 实例 = new 持续单位连线实现(闪电, 参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 持续单位连线清理(this: void): void {
      实例.停止("机制清理");
    });
  }
  return 实例;
}

