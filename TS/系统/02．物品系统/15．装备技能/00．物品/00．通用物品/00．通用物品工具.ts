/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe, getObjectPropertyIntegerSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  getObjectPropertyIntegerSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};

const GetItemType = jass.GetItemType as (item: any) => any;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsItemPowerup = jass.IsItemPowerup as (item: any) => boolean;
const IsUnitInGroup = jass.IsUnitInGroup as (unit: any, whichGroup: any) => boolean;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED as any;
const ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE as any;

const 物编类型_物品 = 3;

export function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

export function 是玩家英雄组单位(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  const 玩家英雄组 = 获取玩家英雄单位组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return false;
  return IsUnitInGroup(单位, 玩家英雄组) === true;
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
  const 物品类型 = GetItemType(物品);
  const 是充能 = 物品类型 === ITEM_TYPE_CHARGED;
  const 是可购买 = 物品类型 === ITEM_TYPE_PURCHASABLE;
  if (!是充能 && !是可购买) return false;
  if (GetItemCharges(物品) > 1) return false;
  if (IsItemPowerup(物品) !== true) return false;
  return getObjectPropertyIntegerSafe(物编类型_物品, GetItemTypeId(物品), "perishable") === 1;
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
