/** @noSelfInFile */

import type { ChestTypeConfig } from "./00．常量定义";

export type 宝箱开启中回调 = (
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  elapsed: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
) => void;

const callbacks: 宝箱开启中回调[] = [];

export function 注册宝箱开启中回调(this: void, callback: 宝箱开启中回调): void {
  callbacks.push(callback);
}

export function 触发宝箱开启中回调(
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  elapsed: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
): void {
  for (const callback of callbacks) {
    callback(unit, target, progressBar, openTime, elapsed, chestConfig, ownerUnit);
  }
}
