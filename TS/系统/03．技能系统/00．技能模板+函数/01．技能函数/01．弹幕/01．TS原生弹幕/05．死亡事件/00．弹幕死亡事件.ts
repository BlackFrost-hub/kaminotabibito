/** @noSelfInFile */
/**
 * TS 原生弹幕 - 弹幕单位死亡事件
 *
 * 职责：接入全局单位死亡事件中心，捕获“弹幕单位被外部击杀”的场景，
 * 提供带击杀者的 on被击落 回调，再走统一生命周期收尾。
 */

import { 取句柄ID } from "../01．共享";
import { 获取原生弹幕实例, 单位到原生弹幕ID } from "../02．注册表";
import { 结束原生弹幕实例 } from "../04．驱动/index";

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

let 已注册弹幕死亡监听 = false;

function on弹幕单位死亡(this: void, 死亡单位: any, 击杀者: any): void {
  const 弹幕ID = 单位到原生弹幕ID[取句柄ID(死亡单位)] ?? 0;
  if (弹幕ID <= 0) return;

  const 实例 = 获取原生弹幕实例(弹幕ID);
  if (实例 == null || 实例.已结束) return;

  const 回调 = 实例.参数.on被击落;
  if (回调 != null) {
    回调(击杀者 ?? null, 弹幕ID);
  }

  结束原生弹幕实例(实例, "单位死亡");
}

export function 确保弹幕死亡事件监听(this: void): void {
  if (已注册弹幕死亡监听) return;
  已注册弹幕死亡监听 = true;
  registerDeathListener(on弹幕单位死亡);
}

