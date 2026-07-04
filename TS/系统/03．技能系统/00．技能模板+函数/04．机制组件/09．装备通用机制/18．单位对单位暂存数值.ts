/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 单位对单位暂存数值控制器 {
  readonly 名称: string;
  写入(this: void, source: any, target: any, 值: number, 持续秒?: number): void;
  读取(this: void, source: any, target: any): number | undefined;
  消耗(this: void, source: any, target: any): number | undefined;
  清空(this: void): void;
}

interface 单位对单位暂存数值记录 {
  值: number;
  到期: number;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取键(this: void, source: any, target: any): string {
  const sourceId = 取单位ID(source);
  const targetId = 取单位ID(target);
  if (sourceId === 0 || targetId === 0) return "";
  return sourceId + ":" + targetId;
}

export function 创建单位对单位暂存数值(this: void, 名称: string): 单位对单位暂存数值控制器 {
  let 表: Record<string, 单位对单位暂存数值记录 | undefined> = {};

  function 读取记录(this: void, source: any, target: any): 单位对单位暂存数值记录 | undefined {
    const key = 取键(source, target);
    if (key === "") return undefined;
    const record = 表[key];
    if (record == null) return undefined;
    if (record.到期 >= getServerTime()) return record;
    delete 表[key];
    return undefined;
  }

  return {
    名称,
    写入: function 写入(this: void, source: any, target: any, 值: number, 持续秒?: number): void {
      const key = 取键(source, target);
      const duration = 持续秒 ?? 2;
      if (key === "" || !(duration > 0)) return;
      表[key] = { 值, 到期: getServerTime() + duration * 1000 };
    },
    读取: function 读取(this: void, source: any, target: any): number | undefined {
      return 读取记录(source, target)?.值;
    },
    消耗: function 消耗(this: void, source: any, target: any): number | undefined {
      const key = 取键(source, target);
      if (key === "") return undefined;
      const record = 读取记录(source, target);
      if (record == null) return undefined;
      delete 表[key];
      return record.值;
    },
    清空: function 清空(this: void): void {
      表 = {};
    },
  };
}

export {};
