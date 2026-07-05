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

interface 窗口事件计数记录 {
  时间毫秒: number;
}

interface 窗口事件计数状态 {
  记录: 窗口事件计数记录[];
}

export interface 单位窗口累计值控制器 {
  readonly 名称: string;
  增加(unit: any, 数值: number): number;
  读取(unit: any): number;
  清空(unit?: any): void;
}

export interface 窗口事件计数器控制器 {
  readonly 名称: string;
  增加(key: string, 窗口秒: number, 触发后清空?: boolean, 触发阈值?: number): number;
  读取(key: string, 窗口秒?: number): number;
  撤销最近一次(key: string): number;
  清空(key?: string): void;
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

class 窗口事件计数器实现 implements 窗口事件计数器控制器 {
  readonly 名称: string;
  private 状态表: Record<string, 窗口事件计数状态 | undefined> = {};

  constructor(名称: string) {
    this.名称 = 名称;
  }

  增加(key: string, 窗口秒: number, 触发后清空: boolean = false, 触发阈值: number = 0): number {
    if (key === "") return 0;
    const now = getServerTime();
    const 状态 = this.取或建状态(key);
    状态.记录.push({ 时间毫秒: now });
    this.清理过期记录(状态, now, 窗口秒);
    const 当前次数 = 状态.记录.length;
    if (触发后清空 && 触发阈值 > 0 && 当前次数 >= 触发阈值) {
      delete this.状态表[key];
    }
    return 当前次数;
  }

  读取(key: string, 窗口秒: number = 0): number {
    if (key === "") return 0;
    const 状态 = this.状态表[key];
    if (状态 == null) return 0;
    this.清理过期记录(状态, getServerTime(), 窗口秒);
    return 状态.记录.length;
  }

  撤销最近一次(key: string): number {
    if (key === "") return 0;
    const 状态 = this.状态表[key];
    if (状态 == null) return 0;
    状态.记录.pop();
    const 当前次数 = 状态.记录.length;
    if (当前次数 <= 0) delete this.状态表[key];
    return 当前次数;
  }

  清空(key?: string): void {
    if (key == null) {
      this.状态表 = {};
      return;
    }
    delete this.状态表[key];
  }

  private 取或建状态(key: string): 窗口事件计数状态 {
    let 状态 = this.状态表[key];
    if (状态 == null) {
      状态 = { 记录: [] };
      this.状态表[key] = 状态;
    }
    return 状态;
  }

  private 清理过期记录(状态: 窗口事件计数状态, now: number, 窗口秒: number): void {
    if (!(窗口秒 > 0)) return;
    const 最早毫秒 = now - 窗口秒 * 1000;
    for (let i = 状态.记录.length - 1; i >= 0; i--) {
      if (状态.记录[i].时间毫秒 >= 最早毫秒) continue;
      状态.记录.splice(i, 1);
    }
  }
}

export function 创建窗口事件计数器(this: void, 名称: string): 窗口事件计数器控制器 {
  return new 窗口事件计数器实现(名称);
}

export {};
