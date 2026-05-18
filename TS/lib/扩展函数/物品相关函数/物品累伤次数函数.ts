/** @noSelfInFile */
const jass = require("jass.common") as any;
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const UnitItemInSlot = jass.UnitItemInSlot as (whichUnit: any, slot: number) => any;
const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetItemCharges = jass.GetItemCharges as (whichItem: any) => number;
const SetItemCharges = jass.SetItemCharges as (whichItem: any, charges: number) => void;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const R2I = jass.R2I as (value: number) => number;

const 单位物品累伤残留表: Record<string, number> = {};

function 生成累伤键(this: void, unit: any, itemTypeId: number): string {
  return String(GetHandleId(unit)) + ":" + String(itemTypeId);
}

function 查找单位指定装备(this: void, unit: any, itemTypeId: number): any | null {
  if (unit == null || unit === 0 || itemTypeId === 0) return null;
  for (let slot = 0; slot < 6; slot++) {
    const item = UnitItemInSlot(unit, slot);
    if (item != null && item !== 0 && GetItemTypeId(item) === itemTypeId) {
      return item;
    }
  }
  return null;
}

/**
 * 根据受到的伤害，按比例累计指定装备的物品次数。
 * @param unit 目标单位
 * @param 装备名 装备数据中的 name
 * @param 受到伤害 本次受到的伤害值
 * @param 比例 多少点伤害提升 1 次数，默认 1
 * @param 阈值 次数超过该值时返回 true，默认 0
 * @returns 是否超过阈值
 */
export function 单位物品累伤次数(
  this: void,
  unit: any,
  装备名: string,
  受到伤害: number,
  比例: number = 1,
  阈值: number = 0,
): boolean {
  if (unit == null || unit === 0) return false;
  if (受到伤害 <= 0) return false;
  if (比例 <= 0) return false;

  const itemId = resolveItemIdByName(装备名);
  if (itemId == null) return false;

  const itemTypeId = stringToFourCCSafe(itemId);
  if (itemTypeId === 0) return false;

  const item = 查找单位指定装备(unit, itemTypeId);
  if (item == null) return false;

  const key = 生成累伤键(unit, itemTypeId);
  const currentRemain = 单位物品累伤残留表[key] ?? 0;
  const total = currentRemain + 受到伤害;
  const addCount = R2I(total / 比例);

  if (addCount > 0) {
    const currentCharges = GetItemCharges(item);
    SetItemCharges(item, currentCharges + addCount);
  }

  单位物品累伤残留表[key] = total - addCount * 比例;
  return GetItemCharges(item) > 阈值;
}

export const ItemDamageStackByDamage = 单位物品累伤次数;

export {};
