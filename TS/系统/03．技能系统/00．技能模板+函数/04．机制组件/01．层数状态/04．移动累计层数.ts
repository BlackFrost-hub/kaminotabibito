/** @noSelfInFile */

import { 创建可配置层数状态, 可配置层数状态控制器, 可配置层数状态配置 } from "./01．可配置层数状态";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder as (whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const OrderId = jass.OrderId as (order: string) => number;
const R2I = jass.R2I as (value: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 攻击命令后备ID = 851983;
const 移动命令后备ID = 851971;
const 智能命令后备ID = 851986;

let 缓存攻击命令ID = 0;
let 缓存移动命令ID = 0;
let 缓存智能命令ID = 0;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 移动累计层数清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 移动累计层数参数 extends 可配置层数状态配置 {
  单位: any;
  名称?: string;
  每层距离: number;
  检查间隔毫秒?: number;
  最小计数位移?: number;
  保留余数?: boolean;
  清理篮子?: 移动累计层数清理篮子;
  判断允许累计?: (this: void, 单位: any) => boolean;
  on获得层数?: (this: void, 当前层数: number) => void;
}

export interface 移动累计层数控制器 {
  readonly 名称: string;
  读取当前层数(): number;
  读取累计距离(): number;
  刷新(): number;
  重置累计距离(): void;
  停止(): void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return SquareRoot(dx * dx + dy * dy);
}

function 取智能命令ID(this: void): number {
  if (缓存智能命令ID !== 0) return 缓存智能命令ID;
  const 命令ID = OrderId("smart");
  缓存智能命令ID = 命令ID !== 0 ? 命令ID : 智能命令后备ID;
  return 缓存智能命令ID;
}

function 取攻击命令ID(this: void): number {
  if (缓存攻击命令ID !== 0) return 缓存攻击命令ID;
  const 命令ID = OrderId("attack");
  缓存攻击命令ID = 命令ID !== 0 ? 命令ID : 攻击命令后备ID;
  return 缓存攻击命令ID;
}

function 取移动命令ID(this: void): number {
  if (缓存移动命令ID !== 0) return 缓存移动命令ID;
  const 命令ID = OrderId("move");
  缓存移动命令ID = 命令ID !== 0 ? 命令ID : 移动命令后备ID;
  return 缓存移动命令ID;
}

function 单位当前命令允许累计移动(this: void, 单位: any): boolean {
  const 当前命令ID = GetUnitCurrentOrder(单位);
  return 当前命令ID === 取智能命令ID()
    || 当前命令ID === 取攻击命令ID()
    || 当前命令ID === 取移动命令ID();
}

class 移动累计层数控制器实现 implements 移动累计层数控制器 {
  readonly 名称: string;
  private 参数: 移动累计层数参数;
  private 层数控制器: 可配置层数状态控制器;
  private 周期回调ID = 0;
  private 已停止 = false;
  private 上次X = 0;
  private 上次Y = 0;
  private 累计距离 = 0;

  constructor(名称: string, 参数: 移动累计层数参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.层数控制器 = 创建可配置层数状态(参数);
    if (单位有效(参数.单位)) {
      this.上次X = GetUnitX(参数.单位);
      this.上次Y = GetUnitY(参数.单位);
    }
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  读取当前层数(): number {
    return this.层数控制器.取层数(this.参数.单位);
  }

  读取累计距离(): number {
    return this.累计距离;
  }

  重置累计距离(): void {
    this.累计距离 = 0;
  }

  刷新(): number {
    if (this.已停止) return this.读取当前层数();
    const 单位 = this.参数.单位;
    if (!单位有效(单位)) {
      this.层数控制器.清空(单位, "单位失效");
      this.累计距离 = 0;
      return 0;
    }
    if (!单位当前命令允许累计移动(单位)) {
      this.上次X = GetUnitX(单位);
      this.上次Y = GetUnitY(单位);
      return this.读取当前层数();
    }
    if (this.参数.判断允许累计 != null && !this.参数.判断允许累计(单位)) {
      this.上次X = GetUnitX(单位);
      this.上次Y = GetUnitY(单位);
      return this.读取当前层数();
    }

    const 当前X = GetUnitX(单位);
    const 当前Y = GetUnitY(单位);
    const 位移 = 两点距离(this.上次X, this.上次Y, 当前X, 当前Y);
    this.上次X = 当前X;
    this.上次Y = 当前Y;

    const 最小计数位移 = this.参数.最小计数位移 ?? 1;
    if (位移 < 最小计数位移) return this.读取当前层数();

    this.累计距离 += 位移;
    if (this.累计距离 < this.参数.每层距离) return this.读取当前层数();

    const 获得层数 = R2I(this.累计距离 / this.参数.每层距离);
    const 当前层数 = this.层数控制器.增加(单位, 获得层数, "移动累计叠层");
    if (this.参数.保留余数 === false) this.累计距离 = 0;
    else this.累计距离 = this.累计距离 - 获得层数 * this.参数.每层距离;
    if (this.参数.on获得层数 != null) this.参数.on获得层数(当前层数);
    return 当前层数;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
    this.层数控制器.销毁();
  }
}

export function 创建移动累计层数(this: void, 参数: 移动累计层数参数): 移动累计层数控制器 {
  const 名称 = 参数.名称 ?? 参数.状态ID ?? "移动累计层数";
  const 控制器 = new 移动累计层数控制器实现(名称, 参数);
  const 间隔 = 参数.检查间隔毫秒 ?? 100;
  if (间隔 > 0) {
    const id = addPeriodicCallback(间隔, function 移动累计层数Tick(this: void): void {
      控制器.刷新();
    });
    控制器.设置周期回调ID(id);
    if (参数.清理篮子 != null) {
      if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期刷新`, id);
      else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止移动累计层数(this: void): void {
        控制器.停止();
      });
    }
  }
  return 控制器;
}
