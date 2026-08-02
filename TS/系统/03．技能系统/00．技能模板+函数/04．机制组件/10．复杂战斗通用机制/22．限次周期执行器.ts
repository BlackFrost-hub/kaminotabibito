/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 限次周期执行器参数<T> {
  名称: string;
  间隔毫秒: number;
  最大执行次数: number;
  变量?: T;
  清理?: 机制清理篮子;
  onTick: (this: void, 执行次数: number, 变量?: T) => boolean | void;
}

export interface 限次周期执行器实例 {
  停止(): void;
  是否运行中(): boolean;
  读取执行次数(): number;
}

export interface 周期行为参数<T> {
  名称: string;
  间隔毫秒: number;
  变量?: T;
  清理?: 机制清理篮子;
  onTick: (this: void, 执行次数: number, 变量?: T) => boolean | void;
}

export interface 周期行为实例 {
  停止(): void;
  是否运行中(): boolean;
  读取执行次数(): number;
}

function on限次周期执行器Tick(this: void, variable?: any): void {
  const 实例 = variable as 限次周期执行器实现<any> | undefined;
  if (实例 != null) 实例.执行Tick();
}

function on周期行为Tick(this: void, variable?: any): void {
  const 实例 = variable as 周期行为实现<any> | undefined;
  if (实例 != null) 实例.执行Tick();
}

class 限次周期执行器实现<T> implements 限次周期执行器实例 {
  private readonly 参数: 限次周期执行器参数<T>;
  private readonly 最大执行次数: number;
  private 回调ID = 0;
  private 执行次数 = 0;

  constructor(参数: 限次周期执行器参数<T>) {
    this.参数 = 参数;
    this.最大执行次数 = 参数.最大执行次数 > 0 ? 参数.最大执行次数 : 0;
    if (this.最大执行次数 > 0 && 参数.间隔毫秒 > 0) {
      this.回调ID = addPeriodicCallback(参数.间隔毫秒, on限次周期执行器Tick, this);
    }
  }

  停止(): void {
    if (this.回调ID === 0) return;
    removePeriodicCallback(this.回调ID);
    this.回调ID = 0;
  }

  是否运行中(): boolean {
    return this.回调ID !== 0;
  }

  读取执行次数(): number {
    return this.执行次数;
  }

  执行Tick(): void {
    if (this.回调ID === 0 || this.执行次数 >= this.最大执行次数) {
      this.停止();
      return;
    }
    this.执行次数 = this.执行次数 + 1;
    const 继续执行 = this.参数.onTick(this.执行次数, this.参数.变量);
    if (继续执行 === false || this.执行次数 >= this.最大执行次数) this.停止();
  }
}

class 周期行为实现<T> implements 周期行为实例 {
  private readonly 参数: 周期行为参数<T>;
  private 回调ID = 0;
  private 执行次数 = 0;

  constructor(参数: 周期行为参数<T>) {
    this.参数 = 参数;
    if (参数.间隔毫秒 > 0) this.回调ID = addPeriodicCallback(参数.间隔毫秒, on周期行为Tick, this);
  }

  停止(): void {
    if (this.回调ID === 0) return;
    removePeriodicCallback(this.回调ID);
    this.回调ID = 0;
  }

  是否运行中(): boolean {
    return this.回调ID !== 0;
  }

  读取执行次数(): number {
    return this.执行次数;
  }

  执行Tick(): void {
    if (this.回调ID === 0) return;
    this.执行次数 = this.执行次数 + 1;
    if (this.参数.onTick(this.执行次数, this.参数.变量) === false) this.停止();
  }
}

export function 创建限次周期执行器<T>(this: void, 参数: 限次周期执行器参数<T>): 限次周期执行器实例 {
  const 实例 = new 限次周期执行器实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 限次周期执行器清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}

export function 创建周期行为<T>(this: void, 参数: 周期行为参数<T>): 周期行为实例 {
  const 实例 = new 周期行为实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 周期行为清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}

export {};
