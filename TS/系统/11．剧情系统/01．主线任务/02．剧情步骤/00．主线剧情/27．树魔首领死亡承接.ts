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
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { AddItemToStockBJ } = require("lib.扩展函数.BJ函数.03．物品与库存") as {
  AddItemToStockBJ: (this: void, whichItemId: number, whichUnit: any, currentStock: number, stockMax: number) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 树魔首领死亡承接剧情片段 } from "../02．第二章/27．树魔首领死亡承接";

const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;

let pendingTreantDeathUnit: any = undefined;
let pendingTreantDeathX: number | undefined;
let pendingTreantDeathY: number | undefined;

export function 执行树魔首领死亡前置(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;

  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 28);
  pendingTreantDeathUnit = dyingUnit;
  pendingTreantDeathX = GetUnitX(dyingUnit);
  pendingTreantDeathY = GetUnitY(dyingUnit);
}

export function 执行树魔首领死亡奖励(this: void): void {
  const x = pendingTreantDeathX;
  const y = pendingTreantDeathY;
  if (x == null || y == null) return;

  const 宝箱类型ID = stringToFourCCSafe("e070");
  if (宝箱类型ID > 0) {
    const 宝箱 = CreateUnit(Player(jass.PLAYER_NEUTRAL_PASSIVE as number), 宝箱类型ID, x, y, 0);
    if (宝箱 != null && 宝箱 !== 0) {
      const 物品A = stringToFourCCSafe("I0C3");
      const 物品B = stringToFourCCSafe("I0C5");
      const 物品C = stringToFourCCSafe("I0C7");
      if (物品A > 0) AddItemToStockBJ(物品A, 宝箱, 1, 1);
      if (物品B > 0) AddItemToStockBJ(物品B, 宝箱, 1, 1);
      if (物品C > 0) AddItemToStockBJ(物品C, 宝箱, 1, 1);
    }
  }

  const 魔法信件类型ID = stringToFourCCSafe(按名字反查物品ID("魔法信件"));
  if (魔法信件类型ID > 0) {
    CreateItem(魔法信件类型ID, x, y);
  }

  YDUserDataClearSafe("string", "Boss", "树魔首领", "unit");
  if (pendingTreantDeathUnit != null && pendingTreantDeathUnit !== 0) {
    YDUserDataClearTable("unit", pendingTreantDeathUnit);
  }

  pendingTreantDeathUnit = undefined;
  pendingTreantDeathX = undefined;
  pendingTreantDeathY = undefined;
}

function 执行树魔首领死亡后返城(this: void): void {}

export const 树魔首领死亡承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_树魔首领死亡前置": 执行树魔首领死亡前置,
  "SW01死亡事件_树魔首领死亡奖励": 执行树魔首领死亡奖励,
  "JLC精灵城_树魔首领死亡后返城": 执行树魔首领死亡后返城,
};
