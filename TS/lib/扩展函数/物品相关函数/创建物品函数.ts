/** @noSelfInFile */

const jass = require("jass.common") as any;

const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄") as {
  setLastCreatedItem: (this: void, item: any) => void;
};

const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const GetLocationX = jass.GetLocationX as (this: void, whichLocation: any) => number;
const GetLocationY = jass.GetLocationY as (this: void, whichLocation: any) => number;
const RemoveLocation = jass.RemoveLocation as (this: void, whichLocation: any) => void;

export function 创建物品并注册排泄监听(itemId: number, x: number, y: number): any {
  const item = CreateItem(itemId, x, y);
  if (item != null && item !== 0) {
    setLastCreatedItem(item);
  }
  return item;
}

export function 在点创建物品并注册排泄监听(itemId: number, whichLocation: any): any {
  if (whichLocation == null || whichLocation === 0) return null;
  return 创建物品并注册排泄监听(itemId, GetLocationX(whichLocation), GetLocationY(whichLocation));
}

export function 在点创建物品并注册排泄监听且删除点(itemId: number, whichLocation: any): any {
  if (whichLocation == null || whichLocation === 0) return null;
  const item = 创建物品并注册排泄监听(itemId, GetLocationX(whichLocation), GetLocationY(whichLocation));
  RemoveLocation(whichLocation);
  return item;
}

export function 注册物品排泄监听(item: any): any {
  if (item != null && item !== 0) {
    setLastCreatedItem(item);
  }
  return item;
}
