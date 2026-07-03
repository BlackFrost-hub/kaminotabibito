/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;

const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 召唤物组状态参数 {
  清理?: 机制清理篮子;
  名称: string;
  全灭延迟秒?: number;
  全灭后保留死亡记录?: boolean;
  on数量变化?: (this: void, 存活数量: number, 总登记数量: number) => void;
  on单位死亡?: (this: void, 单位: any, 击杀者: any, 组: 召唤物组状态) => void;
  on全部死亡?: (this: void, 组: 召唤物组状态) => void;
}

export interface 召唤物组状态 {
  登记(单位: any): void;
  移除(单位: any, 是否删除单位?: boolean): void;
  取存活数量(): number;
  取总登记数量(): number;
  取单位列表(): any[];
  清空(是否删除单位?: boolean): void;
  销毁(): void;
}

const 召唤物组表: Record<number, 召唤物组状态实现 | undefined> = {};
let 已注册死亡监听 = false;

function 确保死亡监听(this: void): void {
  if (已注册死亡监听) return;
  已注册死亡监听 = true;
  registerDeathListener(on召唤物死亡);
}

function 尝试停止死亡监听(this: void): void {
  for (const key in 召唤物组表) {
    if (召唤物组表[key] != null) return;
  }
  if (!已注册死亡监听) return;
  unregisterDeathListener(on召唤物死亡);
  已注册死亡监听 = false;
}

function on召唤物死亡(this: void, dyingUnit: any, killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  const id = GetHandleId(dyingUnit);
  for (const key in 召唤物组表) {
    const 组 = 召唤物组表[key];
    if (组 != null && 组.包含ID(id)) 组.处理死亡(dyingUnit, killingUnit);
  }
}

class 召唤物组状态实现 implements 召唤物组状态 {
  readonly ID: number;
  private 参数: 召唤物组状态参数;
  private 单位列表: any[] = [];
  private 死亡表: Record<number, true | undefined> = {};
  private 全灭延迟ID = 0;
  private 已销毁 = false;

  constructor(ID: number, 参数: 召唤物组状态参数) {
    this.ID = ID;
    this.参数 = 参数;
    召唤物组表[ID] = this;
    确保死亡监听();
  }

  登记(单位: any): void {
    if (this.已销毁 || 单位 == null || 单位 === 0) return;
    this.单位列表.push(单位);
    this.死亡表[GetHandleId(单位)] = undefined;
    this.广播数量变化();
  }

  移除(单位: any, 是否删除单位: boolean = false): void {
    if (单位 == null || 单位 === 0) return;
    const id = GetHandleId(单位);
    for (let i = this.单位列表.length - 1; i >= 0; i--) {
      if (GetHandleId(this.单位列表[i]) === id) this.单位列表.splice(i, 1);
    }
    delete this.死亡表[id];
    if (是否删除单位) RemoveUnit(单位);
    this.广播数量变化();
  }

  取存活数量(): number {
    let count = 0;
    for (let i = 0; i < this.单位列表.length; i++) {
      const unit = this.单位列表[i];
      if (unit != null && unit !== 0 && this.死亡表[GetHandleId(unit)] == null) count++;
    }
    return count;
  }

  取总登记数量(): number {
    return this.单位列表.length;
  }

  取单位列表(): any[] {
    const result: any[] = [];
    for (let i = 0; i < this.单位列表.length; i++) result.push(this.单位列表[i]);
    return result;
  }

  清空(是否删除单位: boolean = false): void {
    if (this.全灭延迟ID !== 0) {
      removeDelayedCallback(this.全灭延迟ID);
      this.全灭延迟ID = 0;
    }
    if (是否删除单位) {
      for (let i = 0; i < this.单位列表.length; i++) {
        const unit = this.单位列表[i];
        if (unit != null && unit !== 0) RemoveUnit(unit);
      }
    }
    this.单位列表 = [];
    this.死亡表 = {};
    this.广播数量变化();
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    this.清空(false);
    delete 召唤物组表[this.ID];
    尝试停止死亡监听();
  }

  包含ID(id: number): boolean {
    for (let i = 0; i < this.单位列表.length; i++) {
      if (GetHandleId(this.单位列表[i]) === id) return true;
    }
    return false;
  }

  处理死亡(单位: any, 击杀者: any): void {
    const id = GetHandleId(单位);
    if (this.死亡表[id] === true) return;
    this.死亡表[id] = true;
    if (this.参数.on单位死亡 != null) this.参数.on单位死亡(单位, 击杀者, this);
    this.广播数量变化();
    if (this.取存活数量() <= 0) this.调度全灭();
  }

  private 调度全灭(): void {
    if (this.全灭延迟ID !== 0) return;
    const self = this;
    const delay = (this.参数.全灭延迟秒 ?? 0) * 1000;
    this.全灭延迟ID = addDelayedCallback(delay, function 召唤物组全灭(this: void): void {
      self.全灭延迟ID = 0;
      if (self.取存活数量() > 0) return;
      if (self.参数.on全部死亡 != null) self.参数.on全部死亡(self);
      if (self.参数.全灭后保留死亡记录 !== true) self.清空(false);
    });
  }

  private 广播数量变化(): void {
    if (this.参数.on数量变化 != null) this.参数.on数量变化(this.取存活数量(), this.单位列表.length);
  }
}

let 下一个召唤物组ID = 0;

export function 创建召唤物组状态(this: void, 参数: 召唤物组状态参数): 召唤物组状态 {
  const 实例 = new 召唤物组状态实现(++下一个召唤物组ID, 参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 召唤物组状态清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
