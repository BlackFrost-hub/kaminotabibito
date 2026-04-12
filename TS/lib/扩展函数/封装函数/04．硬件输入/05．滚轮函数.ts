/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 滚轮函数
 *
 * 与 04．键盘函数 相同：勿用 japiFn 取出再调用，否则 TSTL 会编成 f(nil, ...) 导致参数错位、注册失败（errjhw 371 等）。
 */

const japi = require("jass.japi") as any;

import { createTriggerOrNull } from "./02．内部工具";

// -------------------- 滚轮 --------------------

export function getWheelDelta(): number {
  if (typeof japi.DzGetWheelDelta !== "function") return 0;
  return japi.DzGetWheelDelta();
}

export function registerMouseWheel(sync: boolean, action: () => void): any {
  const trig = createTriggerOrNull();
  if (!trig) return null;
  if (typeof japi.DzTriggerRegisterMouseWheelEventByCode !== "function") return null;
  japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action);
  return trig;
}
