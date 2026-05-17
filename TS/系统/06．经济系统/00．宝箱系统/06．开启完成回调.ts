/** @noSelfInFile */

import type { ChestTypeConfig } from "./00．常量定义";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export type 宝箱开启完成回调 = (
  this: void,
  unit: any,
  target: any,
  progressBar: any,
  openTime: number,
  chestConfig: ChestTypeConfig | undefined,
  ownerUnit?: any,
) => void;

const 调试模块 = "宝箱完成回调";
const callbacks: 宝箱开启完成回调[] = [];

function 安全执行回调(this: void, callback: 宝箱开启完成回调, unit: any, target: any, progressBar: any, openTime: number, chestConfig: ChestTypeConfig | undefined, ownerUnit?: any): void {
  try {
    callback(unit, target, progressBar, openTime, chestConfig, ownerUnit);
  } catch (err) {
    debugLogForce(调试模块, "回调执行失败", "err=", err);
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
