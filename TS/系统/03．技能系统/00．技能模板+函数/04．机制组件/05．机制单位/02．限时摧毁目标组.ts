/** @noSelfInFile */

import { 创建可攻击机制单位, 可攻击机制单位参数, 可攻击机制单位实例 } from "./01．可攻击机制单位";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 限时摧毁目标组参数 {
  清理?: 机制清理篮子;
  名称: string;
  持续秒: number;
  目标列表: 可攻击机制单位参数[];
  Tick间隔毫秒?: number;
  on全部摧毁?: (this: void) => void;
  on超时?: (this: void, 剩余数量: number) => void;
  on结束?: (this: void, 是否成功: boolean, 剩余数量: number) => void;
}

export interface 限时摧毁目标组实例 {
  readonly 目标单位列表: 可攻击机制单位实例[];
  取剩余数量(): number;
  结束(是否成功: boolean): void;
}

const 限时摧毁目标组表: Record<number, 限时摧毁目标组实现 | undefined> = {};
let 限时摧毁目标组驱动ID = 0;
let 下一个限时摧毁目标组ID = 0;

function 确保限时摧毁目标组驱动(this: void, 间隔毫秒: number): void {
  if (限时摧毁目标组驱动ID !== 0) return;
  限时摧毁目标组驱动ID = addPeriodicCallback(间隔毫秒, on限时摧毁目标组Tick);
}

function 尝试停止限时摧毁目标组驱动(this: void): void {
  for (const key in 限时摧毁目标组表) {
    if (限时摧毁目标组表[key] != null) return;
  }
  if (限时摧毁目标组驱动ID !== 0) {
    removePeriodicCallback(限时摧毁目标组驱动ID);
    限时摧毁目标组驱动ID = 0;
  }
}

function on限时摧毁目标组Tick(this: void): void {
  const now = getServerTime();
  for (const key in 限时摧毁目标组表) {
    const 实例 = 限时摧毁目标组表[key];
    if (实例 != null) 实例.推进(now);
  }
}

class 限时摧毁目标组实现 implements 限时摧毁目标组实例 {
  readonly ID: number;
  readonly 目标单位列表: 可攻击机制单位实例[] = [];
  private 参数: 限时摧毁目标组参数;
  private 到期Ms: number;
  private 已结束 = false;

  constructor(参数: 限时摧毁目标组参数) {
    this.ID = ++下一个限时摧毁目标组ID;
    this.参数 = 参数;
    this.到期Ms = getServerTime() + 参数.持续秒 * 1000;
    限时摧毁目标组表[this.ID] = this;
    this.创建目标();
    确保限时摧毁目标组驱动(参数.Tick间隔毫秒 ?? 100);
  }

  取剩余数量(): number {
    let 数量 = 0;
    for (let i = 0; i < this.目标单位列表.length; i++) {
      if (this.目标单位列表[i].是否存活()) 数量++;
    }
    return 数量;
  }

  推进(now: number): void {
    if (this.已结束) return;
    const 剩余数量 = this.取剩余数量();
    if (剩余数量 <= 0) {
      if (this.参数.on全部摧毁 != null) this.参数.on全部摧毁();
      this.结束(true);
      return;
    }
    if (now >= this.到期Ms) {
      if (this.参数.on超时 != null) this.参数.on超时(剩余数量);
      this.结束(false);
    }
  }

  结束(是否成功: boolean): void {
    if (this.已结束) return;
    this.已结束 = true;
    delete 限时摧毁目标组表[this.ID];
    const 剩余数量 = this.取剩余数量();
    if (!是否成功) {
      for (let i = 0; i < this.目标单位列表.length; i++) {
        if (this.目标单位列表[i].是否存活()) this.目标单位列表[i].销毁();
      }
    }
    if (this.参数.on结束 != null) this.参数.on结束(是否成功, 剩余数量);
    尝试停止限时摧毁目标组驱动();
  }

  private 创建目标(): void {
    for (let i = 0; i < this.参数.目标列表.length; i++) {
      const 目标 = 创建可攻击机制单位(this.参数.目标列表[i]);
      if (目标 != null) this.目标单位列表.push(目标);
    }
  }
}

export function 创建限时摧毁目标组(this: void, 参数: 限时摧毁目标组参数): 限时摧毁目标组实例 {
  const 实例 = new 限时摧毁目标组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 限时摧毁目标组清理(this: void): void {
      实例.结束(false);
    });
  }
  return 实例;
}
