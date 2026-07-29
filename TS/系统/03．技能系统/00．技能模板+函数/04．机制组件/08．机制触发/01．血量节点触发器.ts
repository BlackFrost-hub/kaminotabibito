/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

export interface 血量节点配置 {
  ID: string;
  百分比: number;
  on触发: (this: void, 单位: any, 当前百分比: number) => void;
}

export interface 血量节点触发器参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位: any;
  节点列表: 血量节点配置[];
  Tick间隔毫秒?: number;
  on单位失效?: (this: void, 单位: any) => void;
}

export interface 血量节点触发器 {
  停止(): void;
}

const 血量节点触发器表: Record<number, 血量节点触发器实现 | undefined> = {};
let 血量节点触发器驱动ID = 0;
let 下一个血量节点触发器ID = 0;

function 取生命百分比(this: void, 单位: any): number {
  const max = GetUnitStateJapi(单位, UNIT_STATE_MAX_LIFE);
  if (!(max > 0)) return 0;
  return GetUnitState(单位, UNIT_STATE_LIFE) / max;
}

function 确保血量节点触发器驱动(this: void, 间隔毫秒: number): void {
  if (血量节点触发器驱动ID !== 0) return;
  血量节点触发器驱动ID = addPeriodicCallback(间隔毫秒, on血量节点触发器Tick);
}

function 尝试停止血量节点触发器驱动(this: void): void {
  for (const key in 血量节点触发器表) {
    if (血量节点触发器表[key] != null) return;
  }
  if (血量节点触发器驱动ID !== 0) {
    removePeriodicCallback(血量节点触发器驱动ID);
    血量节点触发器驱动ID = 0;
  }
}

function on血量节点触发器Tick(this: void): void {
  for (const key in 血量节点触发器表) {
    const 实例 = 血量节点触发器表[key];
    if (实例 != null) 实例.推进();
  }
}

class 血量节点触发器实现 implements 血量节点触发器 {
  readonly ID: number;
  private 参数: 血量节点触发器参数;
  private 已触发表: Record<string, true | undefined> = {};
  private 已停止 = false;

  constructor(参数: 血量节点触发器参数) {
    this.ID = ++下一个血量节点触发器ID;
    this.参数 = 参数;
    血量节点触发器表[this.ID] = this;
    确保血量节点触发器驱动(参数.Tick间隔毫秒 ?? 100);
  }

  推进(): void {
    if (this.已停止) return;
    const 单位 = this.参数.单位;
    if (!isValidUnit(单位)) {
      if (this.参数.on单位失效 != null) this.参数.on单位失效(单位);
      this.停止();
      return;
    }
    const 当前百分比 = 取生命百分比(单位);
    const 节点列表 = this.参数.节点列表;
    for (let i = 0; i < 节点列表.length; i++) {
      const 节点 = 节点列表[i];
      if (this.已触发表[节点.ID] != null) continue;
      if (当前百分比 <= 节点.百分比) {
        this.已触发表[节点.ID] = true;
        节点.on触发(单位, 当前百分比);
      }
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 血量节点触发器表[this.ID];
    尝试停止血量节点触发器驱动();
  }
}

export function 创建血量节点触发器(this: void, 参数: 血量节点触发器参数): 血量节点触发器 {
  const 实例 = new 血量节点触发器实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 血量节点触发器清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}
