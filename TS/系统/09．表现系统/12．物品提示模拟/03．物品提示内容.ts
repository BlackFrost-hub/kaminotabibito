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

function 去除颜色控制码(this: void, text: string): string {
  let result = "";
  let index = 0;
  while (index < text.length) {
    const prefix = text.substring(index, index + 2);
    if (prefix === "|r") {
      index += 2;
      continue;
    }
    if (prefix === "|c" && index + 10 <= text.length) {
      index += 10;
      continue;
    }
    result += text.charAt(index);
    index++;
  }
  return result;
}

function 是否纯控制码行(this: void, text: string): boolean {
  return 去除颜色控制码(text).trim() === "";
}

function 清理物品提示正文(this: void, text: string): string {
  if (text === "") return "";
  const 原文以颜色结束 = text.length >= 2 && text.substring(text.length - 2) === "|r";
  const lines = text.split("|n");
  const cleaned: string[] = [];
  for (let i = 0; i < lines.length; i++) {
    if (是否纯控制码行(lines[i])) continue;
    cleaned.push(lines[i]);
  }
  let result = cleaned.join("|n");
  if (原文以颜色结束 && result !== "" && result.substring(result.length - 2) !== "|r") {
    result += "|r";
  }
  return result;
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
  const renderedText = hero != null && hero !== 0 ? 渲染动态文本(hero, rawText, { appendAltHint: false, preserveFormula: true }) : rawText;
  const cleanedDynamicText = 清理物品提示正文(renderedText);
  const dynamicText = cleanedDynamicText === ""
    ? "这是物品提示模拟系统测试"
    : "这是物品提示模拟系统测试|n" + cleanedDynamicText;
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
