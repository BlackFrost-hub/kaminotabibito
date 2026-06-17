/** @noSelfInFile */

const jass = require("jass.common") as any;

const Rect = jass.Rect as (minx: number, miny: number, maxx: number, maxy: number) => any;
const RemoveRect = jass.RemoveRect as (whichRect: any) => void;

const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rectHandle: any, whichUnit: any) => boolean;
};

export interface 动态矩形区域配置 {
  ID?: string;
  名称?: string;
  左: number;
  右: number;
  下: number;
  上: number;
}

export interface 动态矩形区域 {
  配置: 动态矩形区域配置;
  矩形: any;
  中心X: number;
  中心Y: number;
}

export interface 动态矩形区域组 {
  名称: string;
  区域列表: 动态矩形区域[];
}

export function 创建动态矩形区域组(this: void, 名称: string, 配置列表: 动态矩形区域配置[]): 动态矩形区域组 {
  const 区域列表: 动态矩形区域[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    区域列表.push({
      配置,
      矩形: Rect(配置.左, 配置.下, 配置.右, 配置.上),
      中心X: (配置.左 + 配置.右) / 2,
      中心Y: (配置.下 + 配置.上) / 2,
    });
  }
  return { 名称, 区域列表 };
}

export function 销毁动态矩形区域组(this: void, 区域组: 动态矩形区域组 | undefined): void {
  if (区域组 == null) return;
  const 区域列表 = 区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    const 区域 = 区域列表[i];
    if (区域.矩形 != null && 区域.矩形 !== 0) {
      RemoveRect(区域.矩形);
      区域.矩形 = null;
    }
  }
}

export function 单位所在动态矩形区域(
  this: void,
  单位: any,
  区域组: 动态矩形区域组 | undefined,
): 动态矩形区域 | undefined {
  if (单位 == null || 单位 === 0 || 区域组 == null) return undefined;
  const 区域列表 = 区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    const 区域 = 区域列表[i];
    if (区域.矩形 != null && 区域.矩形 !== 0 && RectContainsUnit(区域.矩形, 单位)) {
      return 区域;
    }
  }
  return undefined;
}

export function 单位是否在动态矩形区域组内(this: void, 单位: any, 区域组: 动态矩形区域组 | undefined): boolean {
  return 单位所在动态矩形区域(单位, 区域组) != null;
}

export function 点是否在动态矩形配置内(this: void, x: number, y: number, 配置: 动态矩形区域配置): boolean {
  return x >= 配置.左 && x <= 配置.右 && y >= 配置.下 && y <= 配置.上;
}

export function 统计动态矩形区域内单位数量(
  this: void,
  区域: 动态矩形区域,
  单位列表: any[],
): number {
  if (区域 == null || 区域.矩形 == null || 区域.矩形 === 0) return 0;
  let 数量 = 0;
  for (let i = 0; i < 单位列表.length; i++) {
    const 单位 = 单位列表[i];
    if (单位 != null && 单位 !== 0 && RectContainsUnit(区域.矩形, 单位)) {
      数量++;
    }
  }
  return 数量;
}

export function 取动态矩形区域中心(this: void, 区域: 动态矩形区域): { x: number; y: number } {
  return { x: 区域.中心X, y: 区域.中心Y };
}
