/** @noSelfInFile */

import { 巴尔扎罗斯技能数值配置 } from "./02．数值与表现配置";
import { 清除巴尔扎罗斯灼热 } from "./16．灼热层数工具";
import { stringToFourCC } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const RemoveItem = jass.RemoveItem as (item: any) => void;

const 冷却水晶物品类型ID = stringToFourCC(巴尔扎罗斯技能数值配置.地核召唤.冷却水晶物品ID);
let 冷却水晶已注册 = false;

function 是冷却水晶物品(this: void, item: any): boolean {
  return item != null && item !== 0 && 冷却水晶物品类型ID !== 0 && GetItemTypeId(item) === 冷却水晶物品类型ID;
}

function on冷却水晶拾取(this: void, unit: any, item: any): void {
  if (!是冷却水晶物品(item)) return;
  清除巴尔扎罗斯灼热(unit);
  RemoveItem(item);
}

export function 注册巴尔扎罗斯冷却水晶(this: void): void {
  if (冷却水晶已注册) return;
  冷却水晶已注册 = true;
  onItemPickup(on冷却水晶拾取);
}
