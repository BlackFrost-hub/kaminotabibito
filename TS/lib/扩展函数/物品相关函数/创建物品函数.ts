/** @noSelfInFile */

const jass = require("jass.common") as any;

const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄") as {
  setLastCreatedItem: (this: void, item: any) => void;
};

const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const UnitAddItem = jass.UnitAddItem as (this: void, unit: any, item: any) => boolean | number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const RemoveItem = jass.RemoveItem as (this: void, item: any) => void;
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

function 是有效物品句柄(this: void, item: any): boolean {
  return item != null && item !== 0;
}

/**
 * 把已有物品直接放入单位物品栏。
 * 雪月引擎的 UnitAddItem 会触发原生拾取事件（已验证），装备属性拾取结算由此自然完成；
 * 此处禁止再手动分发拾取事件，否则装备属性会重复结算（双加）。
 * 仅用于"新获得物品"场景；背包间转移调用会重复结算属性。
 */
export function 给予单位物品(this: void, unit: any, item: any): boolean {
  if (unit == null || unit === 0 || !是有效物品句柄(item)) return false;
  const ok = UnitAddItem(unit, item);
  return ok === true || ok === 1;
}

/**
 * 创建物品并直接放入单位物品栏，成功时按拾取语义分发物品拾取事件。
 * 返回物品句柄；物品栏已满时返回 0（物品未创建消耗，由引擎销毁）。
 */
export function 创建物品并给予单位(this: void, unit: any, itemId: number): any {
  if (unit == null || unit === 0 || !(itemId > 0)) return 0;
  const item = 创建物品并注册排泄监听(itemId, GetUnitX(unit), GetUnitY(unit));
  if (!是有效物品句柄(item)) return 0;
  if (给予单位物品(unit, item)) return item;
  RemoveItem(item);
  return 0;
}
