/**
 * TS 原生弹幕 - 实例注册表
 */

import type { 原生弹幕内部实例 } from "./00．类型";

export const 原生弹幕实例表: Record<number, 原生弹幕内部实例 | undefined> = {};
export const 单位到原生弹幕ID: Record<number, number | undefined> = {};

let 下一个原生弹幕ID = 0;

export function 分配原生弹幕ID(this: void): number {
  下一个原生弹幕ID += 1;
  return 下一个原生弹幕ID;
}

export function 获取原生弹幕实例(this: void, 弹幕ID: number): 原生弹幕内部实例 | undefined {
  return 原生弹幕实例表[弹幕ID];
}

