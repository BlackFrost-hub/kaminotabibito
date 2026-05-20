/** @noSelfInFile */
/**
 * 便捷短函数 - 武器类型
 */

const jass = require("jass.common") as any;

const { 获取玩家英雄配置, 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取玩家英雄配置: (this: void, heroRawcode: string) => Record<string, any> | null;
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { items } = require("系统.02．物品系统.01．装备数据") as {
  items: Record<string, Record<string, any>>;
};
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, four: number) => string;
};
const { Ir_SetUnitAttackType } = require("lib.扩展函数.封装函数.01．通用工具.04．单位工具") as {
  Ir_SetUnitAttackType: (this: void, unit: any, attackTypeId: number) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;

export type 武器类型 = "拳头" | "匕首" | "剑" | "弓箭" | "法杖" | "枪" | "斧锤" | "";
export type 英雄武器类型 = 武器类型;

const 武器类型到攻击类型编号: Record<string, number> = {
  "": 0,
  "拳头": 0,
  "剑": 1,
  "枪": 2,
  "斧锤": 3,
  "法杖": 4,
  "匕首": 5,
  "弓箭": 6,
};

function 获取物品原始ID字符串(this: void, itemTypeId: number): string {
  if (itemTypeId === 0) return "";
  return fourCCToString(itemTypeId) || "";
}

function 获取物品数据(this: void, itemTypeId: number): Record<string, any> | null {
  const rawcode = 获取物品原始ID字符串(itemTypeId);
  if (rawcode === "") return null;
  return items[rawcode] ?? null;
}

export function 获取玩家英雄配置武器类型(this: void, heroRawcode: string): 英雄武器类型 {
  const 配置 = 获取玩家英雄配置(heroRawcode);
  if (配置 == null) return "";
  return (配置.weaponType as 英雄武器类型) ?? "";
}

export function 获取单位玩家英雄武器类型(this: void, unit: any): 英雄武器类型 {
  const 配置 = 获取单位玩家英雄配置(unit);
  if (配置 == null) return "";
  return (配置.weaponType as 英雄武器类型) ?? "";
}

export function 单位武器类型是否(this: void, unit: any, type: 武器类型): boolean {
  if (type === "") return false;
  return 获取单位玩家英雄武器类型(unit) === type;
}

export function 获取武器类型攻击类型编号(this: void, type: 武器类型): number {
  return 武器类型到攻击类型编号[type] ?? 0;
}

export function 物品类型ID是否主武器(this: void, itemTypeId: number): boolean {
  const 数据 = 获取物品数据(itemTypeId);
  if (数据 == null) return false;
  return 数据.type === "主武器";
}

export function 物品是否主武器(this: void, item: any): boolean {
  if (item == null || item === 0) return false;
  return 物品类型ID是否主武器(GetItemTypeId(item));
}

export function 获取物品类型ID武器类型(this: void, itemTypeId: number): 武器类型 {
  const 数据 = 获取物品数据(itemTypeId);
  if (数据 == null) return "";
  return (数据.weaponType as 武器类型) ?? "";
}

export function 获取物品武器类型(this: void, item: any): 武器类型 {
  if (item == null || item === 0) return "";
  return 获取物品类型ID武器类型(GetItemTypeId(item));
}

export function 获取单位当前主武器类型(this: void, unit: any): 武器类型 {
  if (unit == null || unit === 0) return "";
  for (let slot = 0; slot < 6; slot++) {
    const item = UnitItemInSlot(unit, slot);
    if (item == null || item === 0) continue;
    if (!物品是否主武器(item)) continue;
    return 获取物品武器类型(item);
  }
  return "";
}

export function 获取单位最终武器类型(this: void, unit: any): 武器类型 {
  const 主武器类型 = 获取单位当前主武器类型(unit);
  if (主武器类型 !== "") return 主武器类型;
  return 获取单位玩家英雄武器类型(unit);
}

export function 获取单位最终攻击类型编号(this: void, unit: any): number {
  return 获取武器类型攻击类型编号(获取单位最终武器类型(unit));
}

export function 同步单位主武器攻击类型(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const 攻击类型编号 = 获取单位最终攻击类型编号(unit);
  if (攻击类型编号 <= 0) return false;
  Ir_SetUnitAttackType(unit, 攻击类型编号);
  return true;
}

export {
  获取玩家英雄配置武器类型 as 获取英雄配置武器类型,
  获取单位玩家英雄武器类型 as 获取单位英雄武器类型,
};

export {};
