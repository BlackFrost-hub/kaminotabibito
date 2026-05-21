/** @noSelfInFile */
/**
 * 昼夜状态便捷函数
 *
 * 功能：获取当前游戏时间是白天还是黑天
 * 白天：6:00 - 18:00
 * 黑天：18:00 - 6:00
 */

const jass = require("jass.common") as any;
const GetFloatGameState = jass.GetFloatGameState as (whichState: any) => number;
const GAME_STATE_TIME_OF_DAY = jass.GAME_STATE_TIME_OF_DAY as any;

function 读取当前时间(this: void): number {
  if (GetFloatGameState == null || GAME_STATE_TIME_OF_DAY == null) {
    return 12.0;
  }
  return GetFloatGameState(GAME_STATE_TIME_OF_DAY);
}

/**
 * 获取当前游戏时间（小时）
 */
export function 获取游戏时间(this: void): number {
  return 读取当前时间();
}

/**
 * 判断是否为白天
 * 白天时间：6:00 - 18:00
 */
export function 是否白天(this: void): boolean {
  const time = 读取当前时间();
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
