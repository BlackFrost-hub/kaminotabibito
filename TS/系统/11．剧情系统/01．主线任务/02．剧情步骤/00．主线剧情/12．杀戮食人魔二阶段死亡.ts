/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { AddItemToStockBJ } = require("lib.扩展函数.BJ函数.03．物品与库存") as {
  AddItemToStockBJ: (this: void, whichItemId: number, whichUnit: any, currentStock: number, stockMax: number) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 杀戮食人魔死亡剧情片段 } from "../01．第一章/12．杀戮食人魔二阶段死亡";

const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

let 待处理杀戮食人魔尸体: any = null;
let 待处理杀戮食人魔X = 0;
let 待处理杀戮食人魔Y = 0;

function 创建食人魔头颅(this: void, x: number, y: number): void {
  const itemTypeId = stringToFourCCSafe(按名字反查物品ID("食人魔头颅")) || stringToFourCCSafe("I0D4");
  if (itemTypeId > 0) {
    CreateItem(itemTypeId, x, y);
  }
}

function 创建选择宝箱(this: void, x: number, y: number): void {
  const chestTypeId = stringToFourCCSafe(按名字反查总单位ID("宝箱")) || stringToFourCCSafe("e070");
  if (!(chestTypeId > 0)) return;
  const chest = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), chestTypeId, x, y, 0);
  if (chest == null || chest === 0) return;
  AddItemToStockBJ(stringToFourCCSafe("I0D1"), chest, 1, 1);
  AddItemToStockBJ(stringToFourCCSafe("I089"), chest, 1, 1);
  AddItemToStockBJ(stringToFourCCSafe("I0D3"), chest, 1, 1);
}

export function 执行杀戮食人魔死亡前置(this: void): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  待处理杀戮食人魔尸体 = dyingUnit;
  待处理杀戮食人魔X = GetUnitX(dyingUnit);
  待处理杀戮食人魔Y = GetUnitY(dyingUnit);
}

export function 执行杀戮食人魔死亡奖励(this: void): void {
  const dyingUnit = 待处理杀戮食人魔尸体;
  if (dyingUnit == null || dyingUnit === 0) return;
  const x = 待处理杀戮食人魔X;
  const y = 待处理杀戮食人魔Y;

  YDUserDataClearSafe("string", "Boss", "杀戮食人魔", "unit");
  YDUserDataClearTable("unit", dyingUnit);
  创建食人魔头颅(x, y);
  创建选择宝箱(x, y);
  待处理杀戮食人魔尸体 = null;
  待处理杀戮食人魔X = 0;
  待处理杀戮食人魔Y = 0;
}

export const 杀戮食人魔二阶段死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_杀戮食人魔死亡前置": 执行杀戮食人魔死亡前置,
  "SW01死亡事件_杀戮食人魔死亡奖励": 执行杀戮食人魔死亡奖励,
};
