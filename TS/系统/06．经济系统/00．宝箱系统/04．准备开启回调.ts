/** @noSelfInFile */

import type { ChestTypeConfig } from "./00．常量定义";

export type 宝箱准备开启回调 = (
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
) => void;

const callbacks: 宝箱准备开启回调[] = [];

export function 注册宝箱准备开启回调(this: void, callback: 宝箱准备开启回调): void {
  callbacks.push(callback);
}

export function 触发宝箱准备开启回调(
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
): void {
  for (const callback of callbacks) {
    callback(unit, target, progressBar, openTime, chestConfig, ownerUnit);
  }
}
