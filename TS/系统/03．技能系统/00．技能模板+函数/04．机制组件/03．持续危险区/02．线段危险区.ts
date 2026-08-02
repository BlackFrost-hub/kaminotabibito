/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import { 创建技能提示圈 } from "../../02．通用函数/16．技能提示圈工厂";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

export interface 线段危险区参数 {
  清理?: 机制清理篮子;
  名称: string;
  起点X: number;
  起点Y: number;
  方向角: number;
  长度: number;
  宽度: number;
  持续秒: number;
  Tick间隔毫秒?: number;
  周期秒?: number;
  /** 传给单位列表与生命周期回调的业务上下文。 */
  变量?: any;
  /** 真正跨过线段中心线的最小触发间隔。 */
  穿越防抖秒?: number;
  单位列表: (this: void, 变量?: any) => any[];
  /** 仅配置提示表现；坐标始终强制使用线段危险区的真实起点，不能覆盖为模型中点。 */
  提示圈?: 技能提示圈配置 | false;
  on进入?: (this: void, 单位: any, 变量?: any) => void;
  on离开?: (this: void, 单位: any, 变量?: any) => void;
  on穿越?: (this: void, 单位: any, 变量?: any) => void;
  on周期?: (this: void, 单位: any, 变量?: any) => void;
  on结束?: (this: void) => void;
}

export interface 线段危险区实例 {
  停止(): void;
}

interface 单位线段状态 {
  在内部: boolean;
  下次周期Ms: number;
  已采样: boolean;
  上次前向距离: number;
  上次侧向符号: number;
  下次穿越Ms: number;
}

function 绝对值(this: void, value: number): number {
  return value >= 0 ? value : -value;
}

function 前向距离在范围内(this: void, value: number, 长度: number): boolean {
  return value >= 0 && value <= 长度;
}

class 线段危险区实现 implements 线段危险区实例 {
  private 参数: 线段危险区参数;
  private 到期Ms: number;
  private 单位状态表: Record<number, 单位线段状态 | undefined> = {};
  private 前向X: number;
  private 前向Y: number;
  private 右向X: number;
  private 右向Y: number;
  private Tick回调ID = 0;
  private 已停止 = false;

  constructor(参数: 线段危险区参数) {
    this.参数 = 参数;
    this.到期Ms = getServerTime() + 参数.持续秒 * 1000;
    this.前向X = CosBJ(参数.方向角);
    this.前向Y = SinBJ(参数.方向角);
    this.右向X = CosBJ(参数.方向角 - 90);
    this.右向Y = SinBJ(参数.方向角 - 90);
    this.创建提示圈();
    this.Tick回调ID = addPeriodicCallback(参数.Tick间隔毫秒 ?? 100, on线段危险区Tick, this);
  }

  推进(now: number): void {
    if (this.已停止) return;
    if (now >= this.到期Ms) {
      this.停止();
      return;
    }
    const 单位列表 = this.参数.单位列表(this.参数.变量);
    for (let i = 0; i < 单位列表.length; i++) {
      const 单位 = 单位列表[i];
      if (!isValidUnit(单位)) continue;
      this.推进单位(now, 单位);
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.Tick回调ID !== 0) {
      removePeriodicCallback(this.Tick回调ID);
      this.Tick回调ID = 0;
    }
    if (this.参数.on结束 != null) this.参数.on结束();
  }

  private 推进单位(now: number, 单位: any): void {
    const id = jass.GetHandleId(单位);
    const dx = GetUnitX(单位) - this.参数.起点X;
    const dy = GetUnitY(单位) - this.参数.起点Y;
    const 前向距离 = dx * this.前向X + dy * this.前向Y;
    const 横向距离 = dx * this.右向X + dy * this.右向Y;
    const 当前在内部 = this.是否在内部(GetUnitX(单位), GetUnitY(单位));
    let 状态 = this.单位状态表[id];
    if (状态 == null) {
      状态 = {
        在内部: false,
        下次周期Ms: 0,
        已采样: false,
        上次前向距离: 前向距离,
        上次侧向符号: 0,
        下次穿越Ms: 0,
      };
      this.单位状态表[id] = 状态;
    }
    const 当前侧向符号 = 横向距离 < 0 ? -1 : (横向距离 > 0 ? 1 : 0);
    const 真正跨线 = 状态.已采样
      && 当前侧向符号 !== 0
      && 状态.上次侧向符号 !== 0
      && 当前侧向符号 !== 状态.上次侧向符号
      && 前向距离在范围内(状态.上次前向距离, this.参数.长度)
      && 前向距离在范围内(前向距离, this.参数.长度)
      && now >= 状态.下次穿越Ms;
    状态.已采样 = true;
    状态.上次前向距离 = 前向距离;
    if (当前侧向符号 !== 0) 状态.上次侧向符号 = 当前侧向符号;
    if (当前在内部 && !状态.在内部) {
      状态.在内部 = true;
      状态.下次周期Ms = now;
      if (this.参数.on进入 != null) this.参数.on进入(单位, this.参数.变量);
    } else if (!当前在内部 && 状态.在内部) {
      状态.在内部 = false;
      if (this.参数.on离开 != null) this.参数.on离开(单位, this.参数.变量);
    }
    if (真正跨线) {
      状态.下次穿越Ms = now + (this.参数.穿越防抖秒 ?? 0) * 1000;
      if (this.参数.on穿越 != null) this.参数.on穿越(单位, this.参数.变量);
    }
    if (当前在内部 && this.参数.on周期 != null && now >= 状态.下次周期Ms) {
      this.参数.on周期(单位, this.参数.变量);
      状态.下次周期Ms = now + (this.参数.周期秒 ?? 1) * 1000;
    }
  }

  private 是否在内部(x: number, y: number): boolean {
    const dx = x - this.参数.起点X;
    const dy = y - this.参数.起点Y;
    const 前向距离 = dx * this.前向X + dy * this.前向Y;
    if (前向距离 < 0 || 前向距离 > this.参数.长度) return false;
    const 横向距离 = dx * this.右向X + dy * this.右向Y;
    return 绝对值(横向距离) <= this.参数.宽度 * 0.5;
  }

  private 创建提示圈(): void {
    if (this.参数.提示圈 === false) return;
    创建技能提示圈({
      类型: "矩形",
      宽度: this.参数.宽度,
      长度: this.参数.长度,
      朝向: this.参数.方向角,
      持续时间: this.参数.持续秒,
      ...(this.参数.提示圈 ?? {}),
      X: this.参数.起点X,
      Y: this.参数.起点Y,
    });
  }
}

function on线段危险区Tick(this: void, variable?: any): void {
  const 实例 = variable as 线段危险区实现 | undefined;
  if (实例 != null) 实例.推进(getServerTime());
}

export function 创建线段危险区(this: void, 参数: 线段危险区参数): 线段危险区实例 {
  const 实例 = new 线段危险区实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 线段危险区清理(this: void): void {
      实例.停止();
    });
  }
  return 实例;
}
