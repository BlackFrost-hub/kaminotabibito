/** @noSelfInFile */

const jass = require("jass.common") as any;

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 持续条件清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 持续条件刷新事件 {
  当前持续毫秒: number;
  是否满足条件: boolean;
  是否已触发: boolean;
}

export interface 持续条件触发参数 {
  名称?: string;
  单位?: any;
  需求持续毫秒: number;
  检查间隔毫秒?: number;
  脱离后重置?: boolean;
  清理篮子?: 持续条件清理篮子;
  判断条件: (this: void) => boolean;
  on满足?: (this: void, 持续毫秒: number) => void;
  on中断?: (this: void, 已持续毫秒: number) => void;
  on刷新?: (this: void, 事件: 持续条件刷新事件) => void;
}

export interface 持续条件触发控制器 {
  readonly 名称: string;
  刷新(): number;
  读取当前持续毫秒(): number;
  是否已触发(): boolean;
  重置(原因?: string): void;
  停止(): void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

class 持续条件触发控制器实现 implements 持续条件触发控制器 {
  readonly 名称: string;
  private 参数: 持续条件触发参数;
  private 周期回调ID = 0;
  private 已停止 = false;
  private 当前持续毫秒 = 0;
  private 上次开始毫秒 = 0;
  private 已触发 = false;

  constructor(名称: string, 参数: 持续条件触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  刷新(): number {
    if (this.已停止) return this.当前持续毫秒;
    if (this.参数.单位 != null && !单位有效(this.参数.单位)) {
      this.重置("单位失效");
      return 0;
    }

    const now = getServerTime();
    const 满足条件 = this.参数.判断条件();
    if (!满足条件) {
      if (this.当前持续毫秒 > 0 && this.参数.on中断 != null) {
        this.参数.on中断(this.当前持续毫秒);
      }
      if (this.参数.脱离后重置 !== false) {
        this.当前持续毫秒 = 0;
        this.上次开始毫秒 = 0;
        this.已触发 = false;
      }
      this.触发刷新(false);
      return this.当前持续毫秒;
    }

    if (this.上次开始毫秒 <= 0) this.上次开始毫秒 = now;
    this.当前持续毫秒 = now - this.上次开始毫秒;
    if (!this.已触发 && this.当前持续毫秒 >= this.参数.需求持续毫秒) {
      this.已触发 = true;
      if (this.参数.on满足 != null) this.参数.on满足(this.当前持续毫秒);
    }
    this.触发刷新(true);
    return this.当前持续毫秒;
  }

  读取当前持续毫秒(): number {
    return this.当前持续毫秒;
  }

  是否已触发(): boolean {
    return this.已触发;
  }

  重置(_原因: string = "重置"): void {
    this.当前持续毫秒 = 0;
    this.上次开始毫秒 = 0;
    this.已触发 = false;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
  }

  private 触发刷新(是否满足条件: boolean): void {
    if (this.参数.on刷新 == null) return;
    this.参数.on刷新({
      当前持续毫秒: this.当前持续毫秒,
      是否满足条件,
      是否已触发: this.已触发,
    });
  }
}

export function 创建持续条件触发器(this: void, 参数: 持续条件触发参数): 持续条件触发控制器 {
  const 名称 = 参数.名称 ?? "持续条件触发器";
  const 控制器 = new 持续条件触发控制器实现(名称, 参数);
  控制器.刷新();
  const 间隔 = 参数.检查间隔毫秒 ?? 100;
  if (间隔 > 0) {
    const id = addPeriodicCallback(间隔, function 持续条件触发器Tick(this: void): void {
      控制器.刷新();
    });
    控制器.设置周期回调ID(id);
    if (参数.清理篮子 != null) {
      if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期刷新`, id);
      else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止持续条件触发器(this: void): void {
        控制器.停止();
      });
    }
  }
  return 控制器;
}
