/** @noSelfInFile */

import {
  创建动态矩形区域组,
  动态矩形区域,
  动态矩形区域配置,
  动态矩形区域组,
  单位所在动态矩形区域,
  单位是否在动态矩形区域组内,
  点是否在动态矩形配置内,
  销毁动态矩形区域组,
} from "../../../00．技能模板+函数/04．机制组件/02．战斗区域";

export type 米亚矩形区域配置 = 动态矩形区域配置;
export type 米亚安全域运行时矩形 = 动态矩形区域;
export type 米亚安全域运行时矩形组 = 动态矩形区域组;

export const 米亚默认安全域配置表: 米亚矩形区域配置[] = [
  { ID: "safe-1", 名称: "安全域1", 左: 12672, 右: 13056, 下: -7104, 上: -6720 },
  { ID: "safe-2", 名称: "安全域2", 左: 12096, 右: 12480, 下: -8064, 上: -7680 },
  { ID: "safe-3", 名称: "安全域3", 左: 12928, 右: 13312, 下: -8704, 上: -8320 },
  { ID: "safe-4", 名称: "安全域4", 左: 13824, 右: 14208, 下: -7232, 上: -6848 },
];

export const 米亚默认平台中心配置: 米亚矩形区域配置 = {
  ID: "platform-center",
  名称: "平台中心",
  左: 12736,
  右: 13408,
  下: -8000,
  上: -7360,
};

export let 米亚安全域配置表: 米亚矩形区域配置[] = 米亚默认安全域配置表;
export let 米亚平台中心配置: 米亚矩形区域配置 = 米亚默认平台中心配置;

export function 设置米亚场地配置(this: void, 安全域配置表: 米亚矩形区域配置[], 平台中心配置: 米亚矩形区域配置): void {
  米亚安全域配置表 = 安全域配置表;
  米亚平台中心配置 = 平台中心配置;
}

export function 重置米亚场地配置(this: void): void {
  米亚安全域配置表 = 米亚默认安全域配置表;
  米亚平台中心配置 = 米亚默认平台中心配置;
}

export function 取米亚平台中心配置(this: void): 米亚矩形区域配置 {
  return 米亚平台中心配置;
}

export function 取米亚平台中心X(this: void): number {
  return (米亚平台中心配置.左 + 米亚平台中心配置.右) / 2;
}

export function 取米亚平台中心Y(this: void): number {
  return (米亚平台中心配置.下 + 米亚平台中心配置.上) / 2;
}

export function 创建米亚安全域矩形组(this: void): 米亚安全域运行时矩形组 {
  return 创建动态矩形区域组("米亚安全域", 米亚安全域配置表);
}

export function 清理米亚安全域矩形组(this: void, 区域组: 米亚安全域运行时矩形组 | undefined): void {
  销毁动态矩形区域组(区域组);
}

export function 米亚点在矩形配置内(this: void, x: number, y: number, rect: 米亚矩形区域配置): boolean {
  return 点是否在动态矩形配置内(x, y, rect);
}

export function 米亚单位在安全域内(this: void, unit: any, 区域组: 米亚安全域运行时矩形组 | undefined): boolean {
  return 单位是否在动态矩形区域组内(unit, 区域组);
}

export function 取米亚单位所在安全域(
  this: void,
  unit: any,
  区域组: 米亚安全域运行时矩形组 | undefined,
): 米亚安全域运行时矩形 | undefined {
  return 单位所在动态矩形区域(unit, 区域组);
}
