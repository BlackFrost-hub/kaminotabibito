/** @noSelfInFile */

const jass = require("jass.common") as any;

const Rect = jass.Rect as (minx: number, miny: number, maxx: number, maxy: number) => any;
const RemoveRect = jass.RemoveRect as (whichRect: any) => void;
const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rectHandle: any, whichUnit: any) => boolean;
};

export interface 米亚矩形区域配置 {
  名称: string;
  左: number;
  右: number;
  下: number;
  上: number;
}

export interface 米亚安全域运行时矩形 {
  配置: 米亚矩形区域配置;
  矩形: any;
  中心X: number;
  中心Y: number;
}

export const 米亚安全域配置表: 米亚矩形区域配置[] = [
  { 名称: "安全域1", 左: 12672, 右: 13056, 下: -7104, 上: -6720 },
  { 名称: "安全域2", 左: 12096, 右: 12480, 下: -8064, 上: -7680 },
  { 名称: "安全域3", 左: 12928, 右: 13312, 下: -8704, 上: -8320 },
  { 名称: "安全域4", 左: 13824, 右: 14208, 下: -7232, 上: -6848 },
];

export const 米亚平台中心配置: 米亚矩形区域配置 = {
  名称: "平台中心",
  左: 12736,
  右: 13408,
  下: -8000,
  上: -7360,
};

export const 米亚平台中心X = (米亚平台中心配置.左 + 米亚平台中心配置.右) / 2;
export const 米亚平台中心Y = (米亚平台中心配置.下 + 米亚平台中心配置.上) / 2;

export function 创建米亚安全域矩形组(this: void): 米亚安全域运行时矩形[] {
  const result: 米亚安全域运行时矩形[] = [];
  for (let i = 0; i < 米亚安全域配置表.length; i++) {
    const config = 米亚安全域配置表[i];
    result.push({
      配置: config,
      矩形: Rect(config.左, config.下, config.右, config.上),
      中心X: (config.左 + config.右) / 2,
      中心Y: (config.下 + config.上) / 2,
    });
  }
  return result;
}

export function 清理米亚安全域矩形组(this: void, rects: 米亚安全域运行时矩形[] | undefined): void {
  if (rects == null) return;
  for (let i = 0; i < rects.length; i++) {
    const rect = rects[i].矩形;
    if (rect != null && rect !== 0) {
      RemoveRect(rect);
      rects[i].矩形 = null;
    }
  }
}

export function 米亚点在矩形配置内(this: void, x: number, y: number, rect: 米亚矩形区域配置): boolean {
  return x >= rect.左 && x <= rect.右 && y >= rect.下 && y <= rect.上;
}

export function 米亚单位在安全域内(this: void, unit: any, rects: 米亚安全域运行时矩形[]): boolean {
  if (unit == null || unit === 0) return false;
  for (let i = 0; i < rects.length; i++) {
    const rect = rects[i].矩形;
    if (rect != null && rect !== 0 && RectContainsUnit(rect, unit)) return true;
  }
  return false;
}

export function 取米亚单位所在安全域(this: void, unit: any, rects: 米亚安全域运行时矩形[]): 米亚安全域运行时矩形 | undefined {
  if (unit == null || unit === 0) return undefined;
  for (let i = 0; i < rects.length; i++) {
    const rect = rects[i].矩形;
    if (rect != null && rect !== 0 && RectContainsUnit(rect, unit)) return rects[i];
  }
  return undefined;
}
