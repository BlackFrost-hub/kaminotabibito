/** @noSelfInFile */

/**
 * 欧尔贝克 - 积攒计数状态
 *
 * W（积攒）期间记录“剩余普攻次数”，普攻命中时递减，归零后 W 提前结束。
 * 源 JASS：YDHT[unit].0x441F0510（初始 5，每次造成伤害 -1）。
 */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

const 积攒计数表: Record<number, number> = {};

export function 获取欧尔贝克积攒计数(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return 积攒计数表[GetHandleId(unit)] ?? 0;
}

export function 设置欧尔贝克积攒计数(this: void, unit: any, value: number): void {
  if (unit == null || unit === 0) return;
  if (value <= 0) {
    delete 积攒计数表[GetHandleId(unit)];
    return;
  }
  积攒计数表[GetHandleId(unit)] = value;
}

export function 消耗欧尔贝克积攒(this: void, unit: any): void {
  const current = 获取欧尔贝克积攒计数(unit);
  if (current <= 0) return;
  设置欧尔贝克积攒计数(unit, current - 1);
}

export {};
