/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 单位时限标记控制器 {
  readonly 名称: string;
  标记(unit: any, 持续秒: number): void;
  存在(unit: any): boolean;
  消耗(unit: any): boolean;
  清空(unit?: any): void;
}

class 单位时限标记实现 implements 单位时限标记控制器 {
  readonly 名称: string;
  private 到期表: Record<number, number | undefined> = {};

  constructor(名称: string) {
    this.名称 = 名称;
  }

  标记(unit: any, 持续秒: number): void {
    const id = this.取单位ID(unit);
    if (id === 0 || !(持续秒 > 0)) return;
    this.到期表[id] = getServerTime() + 持续秒 * 1000;
  }

  存在(unit: any): boolean {
    const id = this.取单位ID(unit);
    if (id === 0) return false;
    const expire = this.到期表[id] ?? 0;
    if (expire >= getServerTime()) return true;
    delete this.到期表[id];
    return false;
  }

  消耗(unit: any): boolean {
    if (!this.存在(unit)) return false;
    delete this.到期表[this.取单位ID(unit)];
    return true;
  }

  清空(unit?: any): void {
    if (unit == null) {
      this.到期表 = {};
      return;
    }
    delete this.到期表[this.取单位ID(unit)];
  }

  private 取单位ID(unit: any): number {
    if (unit == null || unit === 0) return 0;
    return GetHandleId(unit) || 0;
  }
}

export function 创建单位时限标记(this: void, 名称: string): 单位时限标记控制器 {
  return new 单位时限标记实现(名称);
}

export {};
