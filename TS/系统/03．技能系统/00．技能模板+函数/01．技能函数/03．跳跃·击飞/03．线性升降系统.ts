/** @noSelfInFile */

import {
  TICK_INTERVAL,
  CENTER_TIMER_TICKS,
  GetHandleId,
  GetUnitFlyHeight,
  SetUnitFlyHeight,
  添加单位暂停,
  移除单位暂停,
  确保单位可设置飞行高度,
  单位存活,
  限制进度,
} from "./01．跳跃系统/00．共享";

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  offTick10ms: (this: void, callback: (this: void) => void) => void;
};

export type 线性升降结束原因 = "完成" | "中断" | "死亡" | "主单位死亡";
export type 线性升降结束回调 = (this: void, 单位: any, 原因: 线性升降结束原因, 升降ID: number) => void;

export interface 线性升降参数 {
  持续时间: number;
  /** 相对当前飞行高度的变化量；正数升空，负数下降。 */
  高度变化: number;
  暂停单位?: boolean;
  主单位?: any;
  主单位死亡时中断?: boolean;
  结束回调?: 线性升降结束回调;
}

interface 线性升降实例 {
  id: number;
  listIndex: number;
  单位: any;
  单位ID: number;
  主单位?: any;
  主单位死亡时中断: boolean;
  持续时间: number;
  已运行时间: number;
  起始高度: number;
  目标高度: number;
  暂停单位: boolean;
  暂停来源: string;
  结束回调?: 线性升降结束回调;
}

const 活动线性升降列表: 线性升降实例[] = [];
const 线性升降映射: Record<number, 线性升降实例 | undefined> = {};
const 单位当前线性升降: Record<number, number | undefined> = {};
let 下一个线性升降ID = 0;
let 已注册Tick = false;
let tick计数 = 0;

function 取单位ID(this: void, 单位: any): number {
  return (单位 != null && 单位 !== 0 ? GetHandleId(单位) : 0) || 0;
}

function 分配线性升降ID(this: void): number {
  下一个线性升降ID += 1;
  return 下一个线性升降ID;
}

function 注册Tick(this: void): void {
  if (已注册Tick) return;
  已注册Tick = true;
  onTick10ms(on线性升降Tick);
}

function 尝试注销Tick(this: void): void {
  if (!已注册Tick || 活动线性升降列表.length !== 0) return;
  已注册Tick = false;
  tick计数 = 0;
  offTick10ms(on线性升降Tick);
}

function 移除实例(this: void, 实例: 线性升降实例): void {
  delete 线性升降映射[实例.id];
  if (单位当前线性升降[实例.单位ID] === 实例.id) delete 单位当前线性升降[实例.单位ID];
  const lastIndex = 活动线性升降列表.length - 1;
  if (实例.listIndex !== lastIndex) {
    const last = 活动线性升降列表[lastIndex];
    活动线性升降列表[实例.listIndex] = last;
    last.listIndex = 实例.listIndex;
  }
  活动线性升降列表.pop();
  尝试注销Tick();
}

function 结束实例(this: void, 实例: 线性升降实例, 原因: 线性升降结束原因): void {
  if (线性升降映射[实例.id] !== 实例) return;
  if (原因 === "完成" && 实例.单位 != null && 实例.单位 !== 0) {
    SetUnitFlyHeight(实例.单位, 实例.目标高度, 0);
  }
  if (实例.暂停单位) 移除单位暂停(实例.单位, 实例.暂停来源);
  const callback = 实例.结束回调;
  移除实例(实例);
  if (callback != null) callback(实例.单位, 原因, 实例.id);
}

function on线性升降Tick(this: void): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;
  const 本Tick实例ID: number[] = [];
  for (let i = 0; i < 活动线性升降列表.length; i++) 本Tick实例ID.push(活动线性升降列表[i].id);
  for (let i = 0; i < 本Tick实例ID.length; i++) {
    const 实例 = 线性升降映射[本Tick实例ID[i]];
    if (实例 == null) continue;
    if (!单位存活(实例.单位)) {
      结束实例(实例, "死亡");
      continue;
    }
    if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
      结束实例(实例, "主单位死亡");
      continue;
    }
    实例.已运行时间 += TICK_INTERVAL;
    const progress = 限制进度(实例.已运行时间 / 实例.持续时间);
    SetUnitFlyHeight(实例.单位, 实例.起始高度 + (实例.目标高度 - 实例.起始高度) * progress, 0);
    if (progress >= 1) {
      结束实例(实例, "完成");
      continue;
    }
  }
}

export function 开始线性升降(this: void, 单位: any, 参数: 线性升降参数): number {
  if (!单位存活(单位) || 参数.持续时间 <= 0) return 0;
  const 单位ID = 取单位ID(单位);
  if (单位ID <= 0) return 0;
  停止单位线性升降(单位, "中断");
  确保单位可设置飞行高度(单位);
  const id = 分配线性升降ID();
  const 起始高度 = GetUnitFlyHeight(单位);
  const 实例: 线性升降实例 = {
    id,
    listIndex: 活动线性升降列表.length,
    单位,
    单位ID,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    持续时间: 参数.持续时间,
    已运行时间: 0,
    起始高度,
    目标高度: 起始高度 + 参数.高度变化,
    暂停单位: 参数.暂停单位 === true,
    暂停来源: `线性升降系统:${id}`,
    结束回调: 参数.结束回调,
  };
  线性升降映射[id] = 实例;
  单位当前线性升降[单位ID] = id;
  活动线性升降列表.push(实例);
  if (实例.暂停单位) 添加单位暂停(单位, 实例.暂停来源);
  注册Tick();
  return id;
}

export function 停止线性升降(this: void, id: number, 原因: 线性升降结束原因 = "中断"): boolean {
  const 实例 = 线性升降映射[id];
  if (实例 == null) return false;
  结束实例(实例, 原因);
  return true;
}

export function 停止单位线性升降(this: void, 单位: any, 原因: 线性升降结束原因 = "中断"): boolean {
  const id = 单位当前线性升降[取单位ID(单位)] ?? 0;
  return id > 0 ? 停止线性升降(id, 原因) : false;
}

export function 单位是否正在线性升降(this: void, 单位: any): boolean {
  const id = 单位当前线性升降[取单位ID(单位)] ?? 0;
  return id > 0 && 线性升降映射[id] != null;
}
