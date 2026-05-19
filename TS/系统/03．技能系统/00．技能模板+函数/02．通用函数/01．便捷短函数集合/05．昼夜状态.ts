/** @noSelfInFile */
/**
 * 昼夜状态便捷函数
 *
 * 功能：获取当前游戏时间是白天还是黑天
 * 白天：6:00 - 18:00
 * 黑天：18:00 - 6:00
 */

const jass = require("jass.common") as any;

const GetTimeOfDay = jass.GetTimeOfDay as () => number;

/**
 * 获取当前游戏时间（小时）
 */
export function 获取游戏时间(this: void): number {
  return GetTimeOfDay();
}

/**
 * 判断是否为白天
 * 白天时间：6:00 - 18:00
 */
export function 是否白天(this: void): boolean {
  const time = GetTimeOfDay();
  return time >= 6.0 && time <= 18.0;
}

/**
 * 判断是否为黑天
 * 黑天时间：18:00 - 6:00
 */
export function 是否黑天(this: void): boolean {
  return !是否白天();
}

/**
 * 获取昼夜状态描述
 */
export function 获取昼夜状态(this: void): string {
  return 是否白天() ? "白天" : "黑天";
}

export {};
