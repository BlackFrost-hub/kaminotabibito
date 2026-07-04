/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 单位时限数值控制器 {
  readonly 名称: string;
  写入(this: void, unit: any, 值: number, 持续秒: number): void;
  读取(this: void, unit: any): number | undefined;
  存在(this: void, unit: any): boolean;
  消耗(this: void, unit: any): number | undefined;
  清空(this: void, unit?: any): void;
}

interface 单位时限数值记录 {
  值: number;
  到期: number;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 创建单位时限数值(this: void, 名称: string): 单位时限数值控制器 {
  let 表: Record<number, 单位时限数值记录 | undefined> = {};

  function 读取记录(this: void, unit: any): 单位时限数值记录 | undefined {
    const id = 取单位ID(unit);
    if (id === 0) return undefined;
    const 记录 = 表[id];
    if (记录 == null) return undefined;
    if (记录.到期 >= getServerTime()) return 记录;
    delete 表[id];
    return undefined;
  }

  return {
    名称,
    写入: function 写入(this: void, unit: any, 值: number, 持续秒: number): void {
      const id = 取单位ID(unit);
      if (id === 0 || !(持续秒 > 0)) return;
      表[id] = { 值, 到期: getServerTime() + 持续秒 * 1000 };
    },
    读取: function 读取(this: void, unit: any): number | undefined {
      return 读取记录(unit)?.值;
    },
    存在: function 存在(this: void, unit: any): boolean {
      return 读取记录(unit) != null;
    },
    消耗: function 消耗(this: void, unit: any): number | undefined {
      const id = 取单位ID(unit);
      if (id === 0) return undefined;
      const 记录 = 读取记录(unit);
      if (记录 == null) return undefined;
      delete 表[id];
      return 记录.值;
    },
    清空: function 清空(this: void, unit?: any): void {
      if (unit == null) {
        表 = {};
        return;
      }
      delete 表[取单位ID(unit)];
    },
  };
}

export {};
