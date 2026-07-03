/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface Boss周期机制调度器参数<T> {
  名称: string;
  清理?: 机制清理篮子;
  间隔毫秒: number;
  取上下文列表: (this: void) => T[];
  执行: (this: void, context: T, nowMs: number) => void;
  可执行?: (this: void, context: T, nowMs: number) => boolean;
  取当前时间?: (this: void) => number;
  自动启动?: boolean;
}

export interface Boss周期机制调度器 {
  启动(): void;
  停止(): void;
  是否运行中(): boolean;
}

function onBoss周期机制调度器Tick(this: void, variable?: any): void {
  const 实例 = variable as Boss周期机制调度器实现<any> | undefined;
  if (实例 != null) 实例.执行Tick();
}

class Boss周期机制调度器实现<T> implements Boss周期机制调度器 {
  private 参数: Boss周期机制调度器参数<T>;
  private 回调ID = 0;

  constructor(参数: Boss周期机制调度器参数<T>) {
    this.参数 = 参数;
  }

  启动(): void {
    if (this.回调ID !== 0) return;
    this.回调ID = addPeriodicCallback(this.参数.间隔毫秒, onBoss周期机制调度器Tick, this);
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

export function 创建Boss周期机制调度器<T>(this: void, 参数: Boss周期机制调度器参数<T>): Boss周期机制调度器 {
  const 实例 = new Boss周期机制调度器实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function Boss周期机制调度器清理(this: void): void {
      实例.停止();
    });
  }
  if (参数.自动启动 !== false) 实例.启动();
  return 实例;
}

export {};
