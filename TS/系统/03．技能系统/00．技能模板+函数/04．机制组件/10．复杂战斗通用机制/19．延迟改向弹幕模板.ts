/** @noSelfInFile */

import type { 原生弹幕参数, 原生弹幕实例 } from "../../01．技能函数/01．弹幕/01．TS原生弹幕/00．类型";
import { 创建原生弹幕 } from "../../01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口";
import { 设置原生弹幕指定角度飞行 } from "../../01．技能函数/01．弹幕/01．TS原生弹幕/06．改向与反弹/00．弹幕改向";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 延迟改向弹幕上下文 {
  实例: 延迟改向弹幕实例;
  弹幕: 原生弹幕实例;
  弹幕ID: number;
  弹幕单位: any;
}

export interface 延迟改向弹幕参数 {
  名称?: string;
  清理?: 机制清理篮子;
  弹幕: 原生弹幕参数;
  改向延迟秒?: number;
  改向延迟毫秒?: number;
  改向角度?: number;
  取改向角度?: (this: void, 上下文: 延迟改向弹幕上下文) => number;
  新速度?: number;
  取新速度?: (this: void, 上下文: 延迟改向弹幕上下文) => number;
  自动改向?: boolean;
  清理时销毁弹幕?: boolean;
  on创建?: (this: void, 上下文: 延迟改向弹幕上下文) => void;
  on改向?: (this: void, 上下文: 延迟改向弹幕上下文) => void;
  on改向失败?: (this: void, 上下文: 延迟改向弹幕上下文) => void;
}

export interface 延迟改向弹幕实例 {
  readonly 弹幕: 原生弹幕实例;
  readonly 弹幕ID: number;
  readonly 弹幕单位: any;
  取消延迟改向(): void;
  立即改向(): boolean;
  销毁弹幕(): void;
}

export type Boss延迟改向弹幕上下文 = 延迟改向弹幕上下文;
export type Boss延迟改向弹幕参数 = 延迟改向弹幕参数;
export type Boss延迟改向弹幕实例 = 延迟改向弹幕实例;

function 取延迟毫秒(this: void, 参数: 延迟改向弹幕参数): number {
  if (参数.改向延迟毫秒 != null) return 参数.改向延迟毫秒;
  return (参数.改向延迟秒 ?? 0) * 1000;
}

function on延迟改向弹幕(this: void, variable?: any): void {
  const 实例 = variable as 延迟改向弹幕实现 | undefined;
  if (实例 != null) 实例.立即改向();
}

class 延迟改向弹幕实现 implements 延迟改向弹幕实例 {
  readonly 弹幕: 原生弹幕实例;
  readonly 弹幕ID: number;
  readonly 弹幕单位: any;
  private 参数: 延迟改向弹幕参数;
  private 延迟回调ID = 0;
  private 已改向 = false;
  private 已取消 = false;

  constructor(参数: 延迟改向弹幕参数) {
    this.参数 = 参数;
    this.弹幕 = 创建原生弹幕(参数.弹幕);
    this.弹幕ID = this.弹幕.弹幕ID;
    this.弹幕单位 = this.弹幕.弹幕单位;

    if (参数.on创建 != null) 参数.on创建(this.创建上下文());
    if (参数.自动改向 !== false) this.安排改向();
  }

  取消延迟改向(): void {
    if (this.延迟回调ID !== 0) {
      removeDelayedCallback(this.延迟回调ID);
      this.延迟回调ID = 0;
    }
    this.已取消 = true;
  }

  立即改向(): boolean {
    if (this.已取消 || this.已改向) return false;
    this.延迟回调ID = 0;

    const 上下文 = this.创建上下文();
    const angle = this.参数.取改向角度 != null ? this.参数.取改向角度(上下文) : this.参数.改向角度;
    if (angle == null) {
      if (this.参数.on改向失败 != null) this.参数.on改向失败(上下文);
      return false;
    }

    const speed = this.参数.取新速度 != null ? this.参数.取新速度(上下文) : this.参数.新速度;
    const ok = 设置原生弹幕指定角度飞行(this.弹幕ID, angle, speed);
    if (ok) {
      this.已改向 = true;
      if (this.参数.on改向 != null) this.参数.on改向(上下文);
    } else if (this.参数.on改向失败 != null) {
      this.参数.on改向失败(上下文);
    }
    return ok;
  }

  销毁弹幕(): void {
    this.取消延迟改向();
    this.弹幕.销毁("手动销毁");
  }

  private 安排改向(): void {
    const delay = 取延迟毫秒(this.参数);
    if (delay <= 0) {
      this.立即改向();
      return;
    }
    this.延迟回调ID = addDelayedCallback(delay, on延迟改向弹幕, this);
    if (this.参数.清理 != null) {
      this.参数.清理.登记延迟回调(this.参数.名称 ?? "延迟改向弹幕", this.延迟回调ID);
    }
  }

  private 创建上下文(): 延迟改向弹幕上下文 {
    return {
      实例: this,
      弹幕: this.弹幕,
      弹幕ID: this.弹幕ID,
      弹幕单位: this.弹幕单位,
    };
  }
}

export function 创建延迟改向弹幕(this: void, 参数: 延迟改向弹幕参数): 延迟改向弹幕实例 {
  const 实例 = new 延迟改向弹幕实现(参数);
  if (参数.清理 != null && 参数.清理时销毁弹幕 === true) {
    参数.清理.登记清理(参数.名称 ?? "延迟改向弹幕", function 延迟改向弹幕清理(this: void): void {
      实例.销毁弹幕();
    });
  }
  return 实例;
}

export function 创建Boss延迟改向弹幕(this: void, 参数: Boss延迟改向弹幕参数): Boss延迟改向弹幕实例 {
  return 创建延迟改向弹幕(参数);
}

export {};
