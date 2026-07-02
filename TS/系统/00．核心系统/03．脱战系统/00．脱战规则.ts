/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const C = require("系统.00．核心系统.00．玩家系统.00．常量") as {
  YD_ATTR_PLAYER_HERO_UNIT: string;
};
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;

export type 脱战主体类型 = "玩家英雄" | "Boss" | "普通单位";

export const 脱战开关 = true;
export const 玩家英雄脱战时间秒 = 18.0;
export const Boss脱战时间秒 = 10.0;
export const 普通单位脱战时间秒 = 玩家英雄脱战时间秒;
export const 脱战移速技能ID = 0x41303142; // A01B
export const 脱战BuffID = 0x42303031; // B001
export const 脱战伤害阈值比例 = 0.012;

export function 取脱战时间秒(this: void, 主体类型: 脱战主体类型): number {
  if (主体类型 === "Boss") return Boss脱战时间秒;
  if (主体类型 === "普通单位") return 普通单位脱战时间秒;
  return 玩家英雄脱战时间秒;
}

export function 判断单位是否当前Boss(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const boss = g.udg_Boss;
  if (boss != null && boss !== 0 && unit === boss) return true;
  return false;
}

export function 判断单位是否注册玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (GetUnitTypeId(unit) === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return YDUserDataGet("player", owner, C.YD_ATTR_PLAYER_HERO_UNIT, "unit") === unit;
}

export function 取单位默认脱战主体类型(this: void, unit: any): 脱战主体类型 {
  if (判断单位是否当前Boss(unit)) return "Boss";
  if (unit == null || unit === 0) return "普通单位";
  if (GetUnitTypeId(unit) === 0) return "普通单位";
  if (判断单位是否注册玩家英雄(unit)) return "玩家英雄";
  return "普通单位";
}

export function 取单位默认脱战时间秒(this: void, unit: any, 指定主体类型?: 脱战主体类型): number {
  return 取脱战时间秒(指定主体类型 ?? 取单位默认脱战主体类型(unit));
}
