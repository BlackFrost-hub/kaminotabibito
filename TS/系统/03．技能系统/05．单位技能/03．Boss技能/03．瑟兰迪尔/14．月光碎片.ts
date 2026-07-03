/** @noSelfInFile */

import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { stringToFourCC } from "../../../00．技能模板+函数/02．通用函数/19．Boss公共工具";

const jass = require("jass.common") as any;
const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 施加移速提升Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升") as {
  施加移速提升Buff: (this: void, 来源单位: any, 目标单位: any, 参数: {
    BuffID?: string;
    持续时间: number;
    基础移速百分比?: number;
    图标路径?: string;
    特效路径?: string;
  }) => boolean;
};

const CreateItem = jass.CreateItem as (itemId: number, x: number, y: number) => any;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const RemoveItem = jass.RemoveItem as (item: any) => void;

const 月光碎片物品类型ID = stringToFourCC(瑟兰迪尔数值与表现配置.月光碎片.物品ID);
let 月光碎片已注册 = false;

function 是月光碎片物品(this: void, item: any): boolean {
  return item != null && item !== 0 && GetItemTypeId(item) === 月光碎片物品类型ID;
}

function on月光碎片拾取(this: void, unit: any, item: any): void {
  if (!是月光碎片物品(item)) return;
  const config = 瑟兰迪尔数值与表现配置.月光碎片;
  施加移速提升Buff(unit, unit, {
    BuffID: config.BuffID,
    持续时间: config.持续秒,
    基础移速百分比: config.基础移速百分比,
    图标路径: config.图标,
    特效路径: config.特效,
  });
  RemoveItem(item);
}

export function 创建瑟兰迪尔月光碎片(this: void, x: number, y: number): any {
  return CreateItem(月光碎片物品类型ID, x, y);
}

export function 注册瑟兰迪尔月光碎片(this: void): void {
  if (月光碎片已注册) return;
  月光碎片已注册 = true;
  onItemPickup(on月光碎片拾取);
}
