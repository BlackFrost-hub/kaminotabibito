/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import { 创建技能提示圈 } from "../../02．通用函数/16．技能提示圈工厂";

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 多波延迟AOE波次 {
  ID?: string;
  X: number;
  Y: number;
  半径: number;
  延迟秒: number;
  提示圈?: 技能提示圈配置 | false;
}

export interface 多波延迟AOE参数 {
  清理?: 机制清理篮子;
  名称: string;
  波次列表: 多波延迟AOE波次[];
  Tick间隔毫秒?: number;
  on预警?: (this: void, 波次: 多波延迟AOE波次, 序号: number) => void;
  on触发: (this: void, 波次: 多波延迟AOE波次, 序号: number) => void;
  on结束?: (this: void) => void;
}

export interface 多波延迟AOE实例 {
  停止(): void;
}

interface 运行波次 {
  波次: 多波延迟AOE波次;
  到期Ms: number;
  已触发: boolean;
}

const 多波延迟AOE表: Record<number, 多波延迟AOE实现 | undefined> = {};
let 多波延迟AOE驱动ID = 0;
let 下一个多波延迟AOEID = 0;

function 确保多波延迟AOE驱动(this: void, 间隔毫秒: number): void {
  if (多波延迟AOE驱动ID !== 0) return;
  多波延迟AOE驱动ID = addPeriodicCallback(间隔毫秒, on多波延迟AOETick);
}

function 尝试停止多波延迟AOE驱动(this: void): void {
  for (const key in 多波延迟AOE表) {
    if (多波延迟AOE表[key] != null) return;
  }
  if (多波延迟AOE驱动ID !== 0) {
    removePeriodicCallback(多波延迟AOE驱动ID);
    多波延迟AOE驱动ID = 0;
  }
}

function on多波延迟AOETick(this: void): void {
  const now = getServerTime();
  for (const key in 多波延迟AOE表) {
    const 实例 = 多波延迟AOE表[key];
    if (实例 != null) 实例.推进(now);
  }
}

class 多波延迟AOE实现 implements 多波延迟AOE实例 {
  readonly ID: number;
  private 参数: 多波延迟AOE参数;
  private 运行波次列表: 运行波次[] = [];
  private 已停止 = false;

  constructor(参数: 多波延迟AOE参数) {
    this.ID = ++下一个多波延迟AOEID;
    this.参数 = 参数;
    const now = getServerTime();
    for (let i = 0; i < 参数.波次列表.length; i++) {
      const 波次 = 参数.波次列表[i];
      this.运行波次列表.push({ 波次, 到期Ms: now + 波次.延迟秒 * 1000, 已触发: false });
      this.创建提示圈(波次);
      if (参数.on预警 != null) 参数.on预警(波次, i + 1);
    }
    多波延迟AOE表[this.ID] = this;
    确保多波延迟AOE驱动(参数.Tick间隔毫秒 ?? 50);
  }

  推进(now: number): void {
    if (this.已停止) return;
    let 全部触发 = true;
    for (let i = 0; i < this.运行波次列表.length; i++) {
      const 运行波次 = this.运行波次列表[i];
      if (运行波次.已触发) continue;
      全部触发 = false;
      if (now >= 运行波次.到期Ms) {
        运行波次.已触发 = true;
        this.参数.on触发(运行波次.波次, i + 1);
      }
    }
    if (全部触发) this.停止();
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 多波延迟AOE表[this.ID];
    if (this.参数.on结束 != null) this.参数.on结束();
    尝试停止多波延迟AOE驱动();
  }

  private 创建提示圈(波次: 多波延迟AOE波次): void {
    if (波次.提示圈 === false) return;
    创建技能提示圈({
      类型: "渐变圆形",
      X: 波次.X,
      Y: 波次.Y,
      半径: 波次.半径,
      持续时间: 波次.延迟秒,
      ...(波次.提示圈 ?? {}),
    });
  }
}

export function 创建多波延迟AOE(this: void, 参数: 多波延迟AOE参数): 多波延迟AOE实例 {
  const 实例 = new 多波延迟AOE实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 多波延迟AOE清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}
