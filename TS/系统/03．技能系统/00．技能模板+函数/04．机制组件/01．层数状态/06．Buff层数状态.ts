/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import {
  创建可配置层数状态,
  type 可配置层数状态配置,
  type 可配置层数状态控制器,
  type 层数变化事件,
} from "./01．可配置层数状态";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

export interface Buff层数状态参数 {
  名称: string;
  清理?: 机制清理篮子;
  层数配置: 可配置层数状态配置;
  BuffID: string;
  Buff持续秒: number | ((this: void, 单位: any, 层数: number) => number);
  取Buff显示值?: (this: void, 单位: any, 层数: number) => number;
  取Buff附加参数?: (this: void, 单位: any, 层数: number) => any;
  归零移除Buff?: boolean;
}

export interface Buff层数状态控制器 extends 可配置层数状态控制器 {
  刷新Buff(单位: any): void;
}

function 取持续秒(this: void, 参数: Buff层数状态参数, 单位: any, 层数: number): number {
  return typeof 参数.Buff持续秒 === "number" ? 参数.Buff持续秒 : 参数.Buff持续秒(单位, 层数);
}

function 同步Buff(this: void, 参数: Buff层数状态参数, 单位: any, 层数: number): void {
  if (单位 == null || 单位 === 0) return;
  if (层数 <= 0) {
    if (参数.归零移除Buff !== false) 移除单位指定Buff(单位, 参数.BuffID);
    return;
  }
  const duration = 取持续秒(参数, 单位, 层数);
  if (duration <= 0) return;
  const effectValue = 参数.取Buff显示值 == null ? 层数 : 参数.取Buff显示值(单位, 层数);
  const extras = 参数.取Buff附加参数 == null ? undefined : 参数.取Buff附加参数(单位, 层数);
  registerManualBuff(单位, 参数.BuffID, duration, effectValue, extras);
}

class Buff层数状态实现 implements Buff层数状态控制器 {
  readonly 配置: 可配置层数状态配置;
  private 参数: Buff层数状态参数;
  private 基础控制器: 可配置层数状态控制器;

  constructor(参数: Buff层数状态参数) {
    this.参数 = 参数;
    const 原始层数变化 = 参数.层数配置.on层数变化;
    this.配置 = {
      ...参数.层数配置,
      on层数变化: function onBuff层数变化(this: void, 事件: 层数变化事件): void {
        if (原始层数变化 != null) 原始层数变化(事件);
        同步Buff(参数, 事件.单位, 事件.新层数);
      },
    };
    this.基础控制器 = 创建可配置层数状态(this.配置);
  }

  增加(单位: any, 层数: number = 1, 原因: string = "增加"): number {
    return this.设置(单位, this.取层数(单位) + 层数, 原因);
  }

  设置(单位: any, 层数: number, 原因: string = "设置"): number {
    const old = this.基础控制器.取层数(单位);
    const next = this.基础控制器.设置(单位, 层数, 原因);
    if (old === next && next > 0) 同步Buff(this.参数, 单位, next);
    return next;
  }

  减少(单位: any, 层数: number = 1, 原因: string = "减少"): number {
    return this.设置(单位, this.取层数(单位) - 层数, 原因);
  }

  清空(单位: any, 原因: string = "清空"): void {
    this.基础控制器.清空(单位, 原因);
  }

  取层数(单位: any): number {
    return this.基础控制器.取层数(单位);
  }

  刷新Buff(单位: any): void {
    同步Buff(this.参数, 单位, this.基础控制器.取层数(单位));
  }

  销毁(): void {
    this.基础控制器.销毁();
  }
}

export function 创建Buff层数状态(this: void, 参数: Buff层数状态参数): Buff层数状态控制器 {
  const 实例 = new Buff层数状态实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-Buff层数状态", function Buff层数状态清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}

