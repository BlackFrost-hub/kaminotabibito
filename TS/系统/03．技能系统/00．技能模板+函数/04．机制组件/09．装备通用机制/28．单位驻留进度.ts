/** @noSelfInFile */

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

interface 单位驻留记录 {
  X: number;
  Y: number;
  进度: number;
}

export interface 单位驻留进度控制器 {
  readonly 名称: string;
  采样(this: void, unit: any, 增量?: number): number;
  读取(this: void, unit: any): number;
  清空(this: void, unit?: any): void;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 创建单位驻留进度(this: void, 名称: string, 允许位移距离: number): 单位驻留进度控制器 {
  let 记录表: Record<number, 单位驻留记录 | undefined> = {};
  const 有效位移距离 = 允许位移距离 > 0 ? 允许位移距离 : 0;
  const 位移距离平方 = 有效位移距离 * 有效位移距离;

  return {
    名称,
    采样: function 采样(this: void, unit: any, 增量: number = 1): number {
      const id = 取单位ID(unit);
      if (id === 0) return 0;
      const x = GetUnitX(unit);
      const y = GetUnitY(unit);
      let 记录 = 记录表[id];
      if (记录 == null || (x - 记录.X) * (x - 记录.X) + (y - 记录.Y) * (y - 记录.Y) > 位移距离平方) {
        记录 = { X: x, Y: y, 进度: 0 };
        记录表[id] = 记录;
      }
      记录.进度 += 增量;
      return 记录.进度;
    },
    读取: function 读取(this: void, unit: any): number {
      return 记录表[取单位ID(unit)]?.进度 ?? 0;
    },
    清空: function 清空(this: void, unit?: any): void {
      if (unit == null) {
        记录表 = {};
        return;
      }
      delete 记录表[取单位ID(unit)];
    },
  };
}

export {};
