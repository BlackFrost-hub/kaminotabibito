/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  GetItemOfTypeFromUnitBJ: (this: void, whichUnit: any, itemId: number) => any | null;
};

const GetHeroLevel = jass.GetHeroLevel as (unit: any) => number;
const GetHeroStr = jass.GetHeroStr as (unit: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (unit: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (unit: any, includeBonuses: boolean) => number;
const SetHeroStr = jass.SetHeroStr as (unit: any, value: number, permanent: boolean) => void;
const SetHeroAgi = jass.SetHeroAgi as (unit: any, value: number, permanent: boolean) => void;
const SetHeroInt = jass.SetHeroInt as (unit: any, value: number, permanent: boolean) => void;
const SetItemDroppable = jass.SetItemDroppable as (item: any, flag: boolean) => void;
import type { 物品升级规则 } from "../09．物品升级/00．类型定义";

export const 生命之吻装备名 = "生命之吻";
export const 生命之吻物品类型ID = stringToFourCCSafe(按名字反查物品ID(生命之吻装备名));
export const 生命之吻每两级全属性 = 3;
export const 生命之吻可丢弃等级间隔 = 20;

function 获取生命之吻物品(this: void, 单位: any): any | null {
  if (单位 == null || 单位 === 0) return null;
  if (生命之吻物品类型ID === 0) return null;
  return GetItemOfTypeFromUnitBJ(单位, 生命之吻物品类型ID);
}

export function 单位是否持有生命之吻(this: void, 单位: any): boolean {
  return 获取生命之吻物品(单位) != null;
}

export function 同步生命之吻可丢弃状态(this: void, 单位: any): void {
  const 物品 = 获取生命之吻物品(单位);
  if (物品 == null || 物品 === 0) return;
  const 当前等级 = GetHeroLevel(单位) || 0;
  const 可丢弃 = 当前等级 > 0 && 当前等级 % 生命之吻可丢弃等级间隔 === 0;
  SetItemDroppable(物品, 可丢弃);
}

export function 处理生命之吻升级效果(this: void, 单位: any): void {
  if (!单位是否持有生命之吻(单位)) return;

  const 当前等级 = GetHeroLevel(单位) || 0;
  if (当前等级 > 0 && 当前等级 % 2 === 0) {
    SetHeroStr(单位, GetHeroStr(单位, false) + 生命之吻每两级全属性, false);
    SetHeroAgi(单位, GetHeroAgi(单位, false) + 生命之吻每两级全属性, false);
    SetHeroInt(单位, GetHeroInt(单位, false) + 生命之吻每两级全属性, false);
  }

  同步生命之吻可丢弃状态(单位);
}

export const 生命之吻升级规则: 物品升级规则 = {
  装备名: 生命之吻装备名,
  物品类型ID: 生命之吻物品类型ID,
  处理升级: 处理生命之吻升级效果,
  处理拾取: 同步生命之吻可丢弃状态,
};

export {};
