/** @noSelfInFile */

const jass = require("jass.common") as any;

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 单位数量状态清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 单位数量状态监听参数 {
  名称?: string;
  单位列表?: any[];
  读取单位列表?: (this: void) => any[];
  监听间隔毫秒?: number;
  清理篮子?: 单位数量状态清理篮子;
  过滤单位?: (this: void, 单位: any) => boolean;
  on数量变化?: (this: void, 当前数量: number, 上次数量: number) => void;
  on刷新?: (this: void, 当前数量: number) => void;
}

export interface 单位数量状态监听控制器 {
  readonly 名称: string;
  刷新(): number;
  读取当前数量(): number;
  停止(): void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 读取列表(this: void, 参数: 单位数量状态监听参数): any[] {
  if (参数.读取单位列表 != null) return 参数.读取单位列表();
  return 参数.单位列表 ?? [];
}

function 统计数量(this: void, 参数: 单位数量状态监听参数): number {
  const 列表 = 读取列表(参数);
  let 数量 = 0;
  for (let i = 0; i < 列表.length; i++) {
    const 单位 = 列表[i];
    if (!单位有效(单位)) continue;
    if (参数.过滤单位 != null && !参数.过滤单位(单位)) continue;
    数量 += 1;
  }
  return 数量;
}

class 单位数量状态监听控制器实现 implements 单位数量状态监听控制器 {
  readonly 名称: string;
  private 参数: 单位数量状态监听参数;
  private 当前数量 = -1;
  private 周期回调ID = 0;
  private 已停止 = false;

  constructor(名称: string, 参数: 单位数量状态监听参数) {
    this.名称 = 名称;
    this.参数 = 参数;
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  刷新(): number {
    if (this.已停止) return this.当前数量;
    const 上次数量 = this.当前数量;
    const 当前数量 = 统计数量(this.参数);
    this.当前数量 = 当前数量;
    if (this.参数.on刷新 != null) this.参数.on刷新(当前数量);
    if (上次数量 !== -1 && 当前数量 !== 上次数量 && this.参数.on数量变化 != null) {
      this.参数.on数量变化(当前数量, 上次数量);
    }
    return 当前数量;
  }

  读取当前数量(): number {
    return this.当前数量 < 0 ? 0 : this.当前数量;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
  }
}

export function 创建单位数量状态监听(this: void, 参数: 单位数量状态监听参数): 单位数量状态监听控制器 {
  const 名称 = 参数.名称 ?? "单位数量状态监听";
  const 控制器 = new 单位数量状态监听控制器实现(名称, 参数);
  控制器.刷新();
  const 间隔 = 参数.监听间隔毫秒 ?? 500;
  if (间隔 > 0) {
    const id = addPeriodicCallback(间隔, function 单位数量状态监听Tick(this: void): void {
      控制器.刷新();
    });
    控制器.设置周期回调ID(id);
    if (参数.清理篮子 != null) {
      if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期刷新`, id);
      else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止单位数量状态监听(this: void): void {
        控制器.停止();
      });
    }
  }
  return 控制器;
}
