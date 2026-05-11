/** @noSelfInFile */
/**
 * TS 原生弹幕 - 实例注册表
 */

import type { 原生弹幕内部实例 } from "./00．类型";

export const 原生弹幕实例表: Record<number, 原生弹幕内部实例 | undefined> = {};
export const 单位到原生弹幕ID: Record<number, number | undefined> = {};
export const 原生弹幕ID列表: number[] = [];

let 下一个原生弹幕ID = 0;

export function 分配原生弹幕ID(this: void): number {
  下一个原生弹幕ID += 1;
  return 下一个原生弹幕ID;
}

export function 获取原生弹幕实例(this: void, 弹幕ID: number): 原生弹幕内部实例 | undefined {
  return 原生弹幕实例表[弹幕ID];
}

export function 注册原生弹幕实例(this: void, 实例: 原生弹幕内部实例, 弹幕单位句柄ID: number): void {
  原生弹幕实例表[实例.id] = 实例;
  单位到原生弹幕ID[弹幕单位句柄ID] = 实例.id;
  原生弹幕ID列表.push(实例.id);
}

export function 移除原生弹幕实例(this: void, 弹幕ID: number, 弹幕单位句柄ID: number): void {
  delete 原生弹幕实例表[弹幕ID];
  if (弹幕单位句柄ID > 0) {
    delete 单位到原生弹幕ID[弹幕单位句柄ID];
  }

  for (let i = 原生弹幕ID列表.length - 1; i >= 0; i--) {
    if (原生弹幕ID列表[i] === 弹幕ID) {
      原生弹幕ID列表.splice(i, 1);
      break;
    }
  }
}
