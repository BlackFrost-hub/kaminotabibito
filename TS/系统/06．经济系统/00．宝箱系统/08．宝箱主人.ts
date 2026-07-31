/** @noSelfInFile */

import type { ChestTypeConfig } from "./00．常量定义";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetDestructableX = jass.GetDestructableX as (whichDestructable: any) => number;
const GetDestructableY = jass.GetDestructableY as (whichDestructable: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 调试模块 = "宝箱系统-主人搜索";

function stringToFourCC(this: void, s: string): number {
  const a = s.length > 0 ? s.charCodeAt(0) : 0;
  const b = s.length > 1 ? s.charCodeAt(1) : 0;
  const c = s.length > 2 ? s.charCodeAt(2) : 0;
  const d = s.length > 3 ? s.charCodeAt(3) : 0;
  return a * 16777216 + b * 65536 + c * 256 + d;
}

export type 宝箱主人搜索阶段 = "准备开启" | "开启完成";

function 取搜索半径(this: void, 配置: ChestTypeConfig, 阶段: 宝箱主人搜索阶段): number {
  const 主人配置 = 配置.主人配置;
  if (!主人配置) return 0;
  return 阶段 === "准备开启" ? 主人配置.准备开启搜索半径 : 主人配置.开启完成搜索半径;
}

export function 查找宝箱主人(this: void, 配置: ChestTypeConfig | undefined, 参考宝箱: any, 阶段: 宝箱主人搜索阶段): any | undefined {
  if (!配置?.主人配置 || 参考宝箱 == null || 参考宝箱 === 0) {
    debugLogForce(调试模块, "搜索跳过", "stage=", 阶段, "hasConfig=", 配置 != null, "hasOwnerConfig=", 配置?.主人配置 != null, "hasChest=", 参考宝箱 != null && 参考宝箱 !== 0);
    return undefined;
  }

  const 搜索半径 = 取搜索半径(配置, 阶段);
  if (搜索半径 <= 0) {
    debugLogForce(调试模块, "搜索跳过", "stage=", 阶段, "chest=", GetHandleId(参考宝箱), "radius=", 搜索半径);
    return undefined;
  }

  const 目标单位类型 = stringToFourCC(配置.主人配置.单位类型);
  const 参考x = GetDestructableX(参考宝箱);
  const 参考y = GetDestructableY(参考宝箱);

  let 最近单位: any | undefined;
  let 最近距离平方 = 0;
  let 类型命中数 = 0;
  const 单位列表 = getUnitsInRange(参考x, 参考y, 搜索半径);
  for (let i = 0; i < 单位列表.length; i++) {
    const 枚举单位 = 单位列表[i];
    if (GetUnitTypeId(枚举单位) !== 目标单位类型) continue;
    类型命中数 = 类型命中数 + 1;

    const dx = GetUnitX(枚举单位) - 参考x;
    const dy = GetUnitY(枚举单位) - 参考y;
    const 距离平方 = dx * dx + dy * dy;
    if (!最近单位 || 距离平方 < 最近距离平方) {
      最近单位 = 枚举单位;
      最近距离平方 = 距离平方;
    }
  }
  debugLogForce(
    调试模块,
    "搜索结果",
    "stage=",
    阶段,
    "chest=",
    GetHandleId(参考宝箱),
    "chestType=",
    配置.destructableType,
    "expectedOwnerType=",
    配置.主人配置.单位类型,
    "radius=",
    搜索半径,
    "candidateCount=",
    单位列表.length,
    "typeMatches=",
    类型命中数,
    "owner=",
    最近单位 != null ? GetHandleId(最近单位) : 0,
    "distanceSq=",
    最近距离平方,
  );
  return 最近单位;
}

export { 查找宝箱主人 as resolveChestOwner };
