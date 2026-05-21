/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;

export const 幸运值属性名 = "幸运值";

function 限制概率(this: void, value: number): number {
  if (value <= 0) return 0;
  if (value >= 1) return 1;
  return value;
}

export function 取玩家幸运值(this: void, 玩家: any): number {
  if (玩家 == null || 玩家 === 0) return 0;
  return Number(YDUserDataGetSafe("player", 玩家, 幸运值属性名, "real")) || 0;
}

export function 设置玩家幸运值(this: void, 玩家: any, 幸运值: number): void {
  if (玩家 == null || 玩家 === 0) return;
  YDUserDataSetSafe("player", 玩家, 幸运值属性名, "real", 幸运值);
}

export function 增加玩家幸运值(this: void, 玩家: any, 增量: number): void {
  if (玩家 == null || 玩家 === 0) return;
  设置玩家幸运值(玩家, 取玩家幸运值(玩家) + 增量);
}

export function 按玩家幸运修正概率(this: void, 原始概率: number, 玩家: any): number {
  if (!(原始概率 > 0)) return 0;
  const 幸运值 = 取玩家幸运值(玩家);
  return 限制概率(原始概率 * (1 + 幸运值));
}

export function 按单位所属玩家幸运修正概率(this: void, 原始概率: number, 单位: any): number {
  if (单位 == null || 单位 === 0) return 限制概率(原始概率);
  return 按玩家幸运修正概率(原始概率, GetOwningPlayer(单位));
}

export function 玩家幸运概率通过(this: void, 原始概率: number, 玩家: any): boolean {
  const 最终概率 = 按玩家幸运修正概率(原始概率, 玩家);
  if (最终概率 >= 1) return true;
  if (最终概率 <= 0) return false;
  return GetRandomReal(0, 1) <= 最终概率;
}

export function 单位幸运概率通过(this: void, 原始概率: number, 单位: any): boolean {
  const 最终概率 = 按单位所属玩家幸运修正概率(原始概率, 单位);
  if (最终概率 >= 1) return true;
  if (最终概率 <= 0) return false;
  return GetRandomReal(0, 1) <= 最终概率;
}

export function 装备触发概率修正(this: void, 原始概率: number, 触发单位: any): number {
  return 按单位所属玩家幸运修正概率(原始概率, 触发单位);
}

export function 装备触发概率通过(this: void, 原始概率: number, 触发单位: any): boolean {
  return 单位幸运概率通过(原始概率, 触发单位);
}

export {};
