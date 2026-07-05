/** @noSelfInFile */

import { ObjectType, 安全取物品实例数据字符串, 安全取物编字符串, 安全取物编整数 } from "./02．物品提示读取缓存";

const jass = require("jass.common") as any;
const dynamicTextCore = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑") as {
  渲染动态文本: (this: void, unit: any, tip: string, options?: { appendAltHint?: boolean; preserveFormula?: boolean }) => string;
};

const 渲染动态文本 = dynamicTextCore.渲染动态文本;
const GetItemName = jass.GetItemName as (whichItem: any) => string;
const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (whichUnit: any, itemSlot: number) => any;

export interface 物品提示内容 {
  name: string;
  dynamicText: string;
  manaCost?: number;
  sellGold?: number;
  sellable?: boolean;
  activeUsable?: boolean;
  activeUseHotkey?: string;
}

function 取物品主动蓝耗(this: void, itemTypeId: number): number {
  const abilityList = 安全取物编字符串(ObjectType.ITEM, itemTypeId, "abilList") || "";
  if (abilityList === "") return 0;
  const firstAbility = (abilityList.split(",")[0] || "").trim();
  if (firstAbility === "") return 0;
  return 安全取物编整数(ObjectType.ABILITY, firstAbility, "Cost");
}

function 物品有主动技能(this: void, itemTypeId: number): boolean {
  const abilityList = 安全取物编字符串(ObjectType.ITEM, itemTypeId, "abilList") || "";
  return (abilityList.split(",")[0] || "").trim() !== "";
}

function 取物品槽位小键盘(this: void, slot: number): string {
  if (slot === 0) return "7";
  if (slot === 1) return "8";
  if (slot === 2) return "4";
  if (slot === 3) return "5";
  if (slot === 4) return "1";
  if (slot === 5) return "2";
  return "";
}

function 取物品当前小键盘快捷键(this: void, hero: any, item: any): string {
  if (hero == null || hero === 0 || item == null || item === 0) return "";
  for (let slot = 0; slot < 6; slot++) {
    if (UnitItemInSlot(hero, slot) === item) return 取物品槽位小键盘(slot);
  }
  return "";
}

export function 构建物品提示内容(this: void, item: any, hero?: any): 物品提示内容 | null {
  if (item == null || item === 0) return null;
  const itemTypeId = GetItemTypeId(item);
  if (itemTypeId === 0) return null;

  const name = GetItemName(item) || "";
  const rawText = 安全取物品实例数据字符串(item, itemTypeId, 3) || "";
  const dynamicText = hero != null && hero !== 0 ? 渲染动态文本(hero, rawText, { appendAltHint: false, preserveFormula: true }) : rawText;
  const manaCost = 取物品主动蓝耗(itemTypeId);
  const activeUsable = 物品有主动技能(itemTypeId);
  const activeUseHotkey = activeUsable ? 取物品当前小键盘快捷键(hero, item) : "";
  const goldCost = 安全取物编整数(ObjectType.ITEM, itemTypeId, "goldcost");
  const sellableFlag = 安全取物编整数(ObjectType.ITEM, itemTypeId, "sellable");
  const pawnableFlag = 安全取物编整数(ObjectType.ITEM, itemTypeId, "pawnable");
  const canSell = goldCost > 0 && (sellableFlag > 0 || pawnableFlag > 0);

  return {
    name,
    dynamicText,
    manaCost,
    sellGold: canSell ? goldCost * 0.5 : 0,
    sellable: canSell,
    activeUsable,
    activeUseHotkey,
  };
}

export {};
