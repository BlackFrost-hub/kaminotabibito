/** @noSelfInFile */

import type { ChestTypeConfig } from "./00．常量定义";

export type 宝箱开启完成回调 = (
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
) => void;

const callbacks: 宝箱开启完成回调[] = [];

function 安全执行回调(this: void, callback: 宝箱开启完成回调, unit: any, target: any, progressBar: any, openTime: number, chestConfig: ChestTypeConfig | undefined, ownerUnit?: any): void {
  try {
    callback(unit, target, progressBar, openTime, chestConfig, ownerUnit);
  } catch (_err) {
  }
}

export function 注册宝箱开启完成回调(this: void, callback: 宝箱开启完成回调): void {
  if (typeof callback !== "function") return;
  callbacks.push(callback);
}

export function 触发宝箱开启完成回调(
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
): void {
  if (callbacks.length === 0) return;
  const current = callbacks.slice();
  for (let i = 0; i < current.length; i++) {
    安全执行回调(current[i], unit, target, progressBar, openTime, chestConfig, ownerUnit);
  }
}
