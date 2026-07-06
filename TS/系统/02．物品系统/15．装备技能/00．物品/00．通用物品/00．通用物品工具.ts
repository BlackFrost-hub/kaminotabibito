/** @noSelfInFile */

const jass = require("jass.common") as any;
const { getObjectPropertyIntegerSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyIntegerSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 获取玩家英雄单位组, 是玩家英雄组单位: 核心是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};

const GetItemType = jass.GetItemType as (item: any) => any;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsItemPowerup = jass.IsItemPowerup as (item: any) => boolean;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED as any;
const ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE as any;

const 物编类型_物品 = 3;
const 不走吃书残留清理物品ID: Record<number, true> = {
  [stringToFourCCSafe("I0FK")]: true,
  [stringToFourCCSafe("I0FL")]: true,
};

export function 是玩家英雄组单位(this: void, 单位: any): boolean {
  return 核心是玩家英雄组单位(单位);
}

export function 物品类型ID在列表中(this: void, 物品类型ID: number, 列表: readonly number[]): boolean {
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i] === 物品类型ID) {
      return true;
    }
  }
  return false;
}

export function 是可清理吃书残留(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  const 物品类型ID = GetItemTypeId(物品);
  if (不走吃书残留清理物品ID[物品类型ID] === true) return false;
  const 物品类型 = GetItemType(物品);
  const 是充能 = 物品类型 === ITEM_TYPE_CHARGED;
  const 是可购买 = 物品类型 === ITEM_TYPE_PURCHASABLE;
  if (!是充能 && !是可购买) return false;
  if (GetItemCharges(物品) > 1) return false;
  if (IsItemPowerup(物品) !== true) return false;
  return getObjectPropertyIntegerSafe(物编类型_物品, 物品类型ID, "perishable") === 1;
}

export function 删除物品(this: void, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  RemoveItem(物品);
}

export function 取物品句柄ID(this: void, 物品: any): number {
  if (物品 == null || 物品 === 0) return 0;
  return GetHandleId(物品) || 0;
}

export {};
