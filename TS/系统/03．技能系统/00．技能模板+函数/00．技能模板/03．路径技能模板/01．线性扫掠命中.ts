/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

export interface 线性扫掠命中回调上下文 {
  实例ID: number;
  施法单位: any;
  当前X: number;
  当前Y: number;
  方向弧度: number;
  当前次数: number;
}

export interface 线性扫掠命中参数 {
  施法单位: any;
  起点X: number;
  起点Y: number;
  方向弧度: number;
  周期秒: number;
  最大次数: number;
  每次距离: number;
  作用范围: number;
  同目标只命中一次?: boolean;
  目标筛选?: (this: void, 目标: any, 上下文: 线性扫掠命中回调上下文) => boolean;
  on步进?: (this: void, 上下文: 线性扫掠命中回调上下文) => void;
  on命中?: (this: void, 目标: any, 上下文: 线性扫掠命中回调上下文) => void;
  on结束?: (this: void, 实例ID: number) => void;
}

export interface 线性扫掠命中实例 {
  readonly 实例ID: number;
  销毁(): void;
}

let 下一个线性扫掠命中实例ID = 0;

class 线性扫掠命中实现 implements 线性扫掠命中实例 {
  readonly 实例ID: number;
  private readonly 参数: 线性扫掠命中参数;
  private 当前X: number;
  private 当前Y: number;
  private 当前次数 = 0;
  private timerID = 0;
  private 已销毁 = false;
  private readonly 已命中: Record<number, boolean | undefined> = {};

  constructor(实例ID: number, 参数: 线性扫掠命中参数) {
    this.实例ID = 实例ID;
    this.参数 = 参数;
    this.当前X = 参数.起点X;
    this.当前Y = 参数.起点Y;
  }

  启动(): void {
    if (this.已销毁) return;
    if (this.参数.施法单位 == null || this.参数.施法单位 === 0) return;
    if (this.参数.最大次数 <= 0 || this.参数.周期秒 <= 0) return;
    this.timerID = addPeriodicCallback(this.参数.周期秒 * 1000, on线性扫掠命中Tick, this);
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    if (this.timerID !== 0) {
      removePeriodicCallback(this.timerID);
      this.timerID = 0;
    }
    this.参数.on结束?.(this.实例ID);
  }

  推进Tick(): void {
    if (this.已销毁) return;
    this.当前次数 += 1;
    this.当前X += Cos(this.参数.方向弧度) * this.参数.每次距离;
    this.当前Y += Sin(this.参数.方向弧度) * this.参数.每次距离;

    const 回调上下文: 线性扫掠命中回调上下文 = {
      实例ID: this.实例ID,
      施法单位: this.参数.施法单位,
      当前X: this.当前X,
      当前Y: this.当前Y,
      方向弧度: this.参数.方向弧度,
      当前次数: this.当前次数,
    };

    this.参数.on步进?.(回调上下文);
    this.处理命中(回调上下文);

    if (this.当前次数 >= this.参数.最大次数) {
      this.销毁();
    }
  }

  private 处理命中(上下文: 线性扫掠命中回调上下文): void {
    if (this.参数.作用范围 <= 0) return;
    const 敌人列表 = 获取坐标范围敌人(this.参数.施法单位, 上下文.当前X, 上下文.当前Y, this.参数.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
      const 目标 = 敌人列表[i];
      if (!this.是否可命中(目标, 上下文)) continue;
      if ((this.参数.同目标只命中一次 ?? true) && this.是否已经命中(目标)) continue;
      this.标记已命中(目标);
      this.参数.on命中?.(目标, 上下文);
    }
  }

  private 是否可命中(目标: any, 上下文: 线性扫掠命中回调上下文): boolean {
    if (!单位是否有效且敌对(目标, this.参数.施法单位)) return false;
    if (this.参数.目标筛选 == null) return true;
    return this.参数.目标筛选(目标, 上下文);
  }

  private 是否已经命中(目标: any): boolean {
    const 目标ID = GetHandleId(目标);
    return this.已命中[目标ID] === true;
  }

  private 标记已命中(目标: any): void {
    const 目标ID = GetHandleId(目标);
    this.已命中[目标ID] = true;
  }
}

function on线性扫掠命中Tick(this: void, variable?: any): void {
  const 实例 = variable as 线性扫掠命中实现 | undefined;
  if (实例 != null) 实例.推进Tick();
}

export function 创建线性扫掠命中(参数: 线性扫掠命中参数): 线性扫掠命中实例 {
  const 实例 = new 线性扫掠命中实现(++下一个线性扫掠命中实例ID, 参数);
  实例.启动();
  return 实例;
}
