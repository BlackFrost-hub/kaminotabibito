/** @noSelfInFile */

import { 创建技能提示圈, 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 点名预警执行结果 {
  目标: any;
  锁定X: number;
  锁定Y: number;
}

export interface 点名预警执行器参数 {
  清理?: 机制清理篮子;
  名称: string;
  目标?: any;
  锁定X?: number;
  锁定Y?: number;
  取坐标?: (this: void, 目标: any) => { X: number; Y: number };
  延迟秒: number;
  /** 默认锁定点名瞬间坐标；false 表示结算时读取目标实时坐标。 */
  锁定坐标?: boolean;
  提示圈?: 技能提示圈配置 | false | ((this: void, 结果: 点名预警执行结果) => 技能提示圈配置 | false);
  on锁定?: (this: void, 结果: 点名预警执行结果) => void;
  on结算: (this: void, 结果: 点名预警执行结果) => void;
  on取消?: (this: void) => void;
}

export interface 点名预警执行器 {
  取消(): void;
}

class 点名预警执行器实现 implements 点名预警执行器 {
  private 参数: 点名预警执行器参数;
  private 延迟ID = 0;
  private 已取消 = false;
  private 结果: 点名预警执行结果;

  constructor(参数: 点名预警执行器参数) {
    this.参数 = 参数;
    const 初始坐标 = this.读取坐标();
    this.结果 = {
      目标: 参数.目标,
      锁定X: 初始坐标.X,
      锁定Y: 初始坐标.Y,
    };
    if (参数.on锁定 != null) 参数.on锁定(this.结果);
    this.创建提示圈();
    const self = this;
    this.延迟ID = addDelayedCallback(参数.延迟秒 * 1000, function 点名预警延迟结算(this: void): void {
      self.结算();
    });
  }

  取消(): void {
    if (this.已取消) return;
    this.已取消 = true;
    if (this.延迟ID !== 0) {
      removeDelayedCallback(this.延迟ID);
      this.延迟ID = 0;
    }
    if (this.参数.on取消 != null) this.参数.on取消();
  }

  private 结算(): void {
    if (this.已取消) return;
    this.已取消 = true;
    this.延迟ID = 0;
    if (this.参数.锁定坐标 === false) {
      const 当前坐标 = this.读取坐标();
      this.结果.锁定X = 当前坐标.X;
      this.结果.锁定Y = 当前坐标.Y;
    }
    this.参数.on结算(this.结果);
  }

  private 读取坐标(): { X: number; Y: number } {
    if (this.参数.取坐标 != null) return this.参数.取坐标(this.参数.目标);
    if (this.参数.锁定X != null && this.参数.锁定Y != null) {
      return { X: this.参数.锁定X, Y: this.参数.锁定Y };
    }
    if (this.参数.目标 != null && this.参数.目标 !== 0) {
      return { X: GetUnitX(this.参数.目标), Y: GetUnitY(this.参数.目标) };
    }
    return { X: 0, Y: 0 };
  }

  private 创建提示圈(): void {
    const 提示圈 = this.参数.提示圈;
    if (提示圈 === false || 提示圈 == null) return;
    const 配置 = typeof 提示圈 === "function" ? 提示圈(this.结果) : 提示圈;
    if (配置 === false) return;
    创建技能提示圈({
      ...配置,
      X: 配置.X ?? 配置.x ?? this.结果.锁定X,
      Y: 配置.Y ?? 配置.y ?? this.结果.锁定Y,
      持续时间: 配置.持续时间 ?? this.参数.延迟秒,
    });
  }
}

export function 创建点名预警执行器(this: void, 参数: 点名预警执行器参数): 点名预警执行器 {
  const 执行器 = new 点名预警执行器实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 点名预警执行器清理(this: void): void {
      执行器.取消();
    });
  }
  return 执行器;
}
