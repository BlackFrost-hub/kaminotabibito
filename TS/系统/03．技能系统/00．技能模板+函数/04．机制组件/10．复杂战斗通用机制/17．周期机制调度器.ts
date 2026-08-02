/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const 中心计时器最小周期毫秒 = 10;

export interface 周期机制调度器参数<T> {
  名称: string;
  清理?: 机制清理篮子;
  间隔毫秒: number;
  取上下文列表: (this: void) => T[];
  执行: (this: void, context: T, nowMs: number) => void;
  可执行?: (this: void, context: T, nowMs: number) => boolean;
  取当前时间?: (this: void) => number;
  自动启动?: boolean;
}

export interface 周期机制调度器 {
  启动(): void;
  停止(): void;
  是否运行中(): boolean;
}

export interface 自适应共享周期驱动参数 {
  名称: string;
  最大检查间隔毫秒: number;
  取建议检查间隔毫秒: (this: void, nowMs: number) => number;
  onTick: (this: void, nowMs: number) => void;
}

export interface 自适应共享周期驱动 {
  刷新(): void;
  停止(): void;
  是否运行中(): boolean;
  读取当前检查间隔毫秒(): number;
}

function on周期机制调度器Tick(this: void, variable?: any): void {
  const 实例 = variable as 周期机制调度器实现<any> | undefined;
  if (实例 != null) 实例.执行Tick();
}

function on自适应共享周期驱动Tick(this: void, variable?: any): void {
  const 实例 = variable as 自适应共享周期驱动实现 | undefined;
  if (实例 != null) 实例.执行Tick();
}

class 周期机制调度器实现<T> implements 周期机制调度器 {
  private 参数: 周期机制调度器参数<T>;
  private 回调ID = 0;

  constructor(参数: 周期机制调度器参数<T>) {
    this.参数 = 参数;
  }

  启动(): void {
    if (this.回调ID !== 0) return;
    this.回调ID = addPeriodicCallback(this.参数.间隔毫秒, on周期机制调度器Tick, this);
  }

  停止(): void {
    if (this.回调ID === 0) return;
    removePeriodicCallback(this.回调ID);
    this.回调ID = 0;
  }

  是否运行中(): boolean {
    return this.回调ID !== 0;
  }

  执行Tick(): void {
    const nowMs = this.参数.取当前时间 != null ? this.参数.取当前时间() : 0;
    const contexts = this.参数.取上下文列表();
    for (let i = 0; i < contexts.length; i++) {
      const context = contexts[i];
      if (context == null) continue;
      if (this.参数.可执行 != null && !this.参数.可执行(context, nowMs)) continue;
      this.参数.执行(context, nowMs);
    }
  }
}

class 自适应共享周期驱动实现 implements 自适应共享周期驱动 {
  private 参数: 自适应共享周期驱动参数;
  private 回调ID = 0;
  private 当前检查间隔毫秒 = 0;

  constructor(参数: 自适应共享周期驱动参数) {
    this.参数 = 参数;
  }

  刷新(): void {
    const 建议间隔 = this.参数.取建议检查间隔毫秒(getServerTime());
    if (!(建议间隔 > 0)) {
      this.停止();
      return;
    }
    let 最大间隔 = this.参数.最大检查间隔毫秒;
    if (最大间隔 < 中心计时器最小周期毫秒) 最大间隔 = 中心计时器最小周期毫秒;
    let 新间隔 = 建议间隔 < 最大间隔 ? 建议间隔 : 最大间隔;
    if (新间隔 < 中心计时器最小周期毫秒) 新间隔 = 中心计时器最小周期毫秒;
    if (this.回调ID !== 0 && this.当前检查间隔毫秒 === 新间隔) return;
    if (this.回调ID !== 0) removePeriodicCallback(this.回调ID);
    this.当前检查间隔毫秒 = 新间隔;
    this.回调ID = addPeriodicCallback(新间隔, on自适应共享周期驱动Tick, this);
  }

  停止(): void {
    if (this.回调ID !== 0) removePeriodicCallback(this.回调ID);
    this.回调ID = 0;
    this.当前检查间隔毫秒 = 0;
  }

  是否运行中(): boolean {
    return this.回调ID !== 0;
  }

  读取当前检查间隔毫秒(): number {
    return this.当前检查间隔毫秒;
  }

  执行Tick(): void {
    if (this.回调ID === 0) return;
    this.参数.onTick(getServerTime());
    this.刷新();
  }
}

export function 创建周期机制调度器<T>(this: void, 参数: 周期机制调度器参数<T>): 周期机制调度器 {
  const 实例 = new 周期机制调度器实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 周期机制调度器清理(this: void): void {
      实例.停止();
    });
  }
  if (参数.自动启动 !== false) 实例.启动();
  return 实例;
}

export function 创建自适应共享周期驱动(this: void, 参数: 自适应共享周期驱动参数): 自适应共享周期驱动 {
  return new 自适应共享周期驱动实现(参数);
}

export {};
