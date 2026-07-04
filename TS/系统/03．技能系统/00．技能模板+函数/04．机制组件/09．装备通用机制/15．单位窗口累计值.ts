/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

interface 单位窗口累计记录 {
  数值: number;
  结束时间: number;
}

export interface 单位窗口累计值控制器 {
  readonly 名称: string;
  增加(unit: any, 数值: number): number;
  读取(unit: any): number;
  清空(unit?: any): void;
}

class 单位窗口累计值实现 implements 单位窗口累计值控制器 {
  readonly 名称: string;
  private readonly 窗口毫秒: number;
  private 记录表: Record<number, 单位窗口累计记录 | undefined> = {};

  constructor(名称: string, 窗口秒: number) {
    this.名称 = 名称;
    this.窗口毫秒 = 窗口秒 * 1000;
  }

  增加(unit: any, 数值: number): number {
    const id = this.取单位ID(unit);
    if (id === 0 || !(数值 > 0)) return 0;
    const now = getServerTime();
    let 记录 = this.记录表[id];
    if (记录 == null || now >= 记录.结束时间) {
      记录 = { 数值: 0, 结束时间: now + this.窗口毫秒 };
      this.记录表[id] = 记录;
    }
    记录.数值 += 数值;
    return 记录.数值;
  }

  读取(unit: any): number {
    const id = this.取单位ID(unit);
    if (id === 0) return 0;
    const 记录 = this.记录表[id];
    if (记录 == null) return 0;
    if (getServerTime() < 记录.结束时间) return 记录.数值;
    delete this.记录表[id];
    return 0;
  }

  清空(unit?: any): void {
    if (unit == null) {
      this.记录表 = {};
      return;
    }
    delete this.记录表[this.取单位ID(unit)];
  }

  private 取单位ID(unit: any): number {
    if (unit == null || unit === 0) return 0;
    return GetHandleId(unit) || 0;
  }
}

export function 创建单位窗口累计值(this: void, 名称: string, 窗口秒: number): 单位窗口累计值控制器 {
  return new 单位窗口累计值实现(名称, 窗口秒);
}

export {};
