/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 第三章主线Boss战利品ID缓存: Record<string, number | undefined> = {};
const 第三章主线Boss战利品冷却表: Record<string, number | undefined> = {};

export const 第三章主线Boss战利品装备名 = {
  地核熔炉之心: "地核熔炉之心",
  锻造者手套: "锻造者手套",
  冰焰宝珠: "冰焰宝珠",
  怨火核心碎片: "怨火核心碎片",
  永恒轮回法典: "永恒轮回法典",
} as const;

export function 取第三章主线Boss战利品物品ID(this: void, 装备名: string): number {
  const cached = 第三章主线Boss战利品ID缓存[装备名];
  if (cached != null) return cached;
  const rawId = 按名字反查物品ID(装备名);
  const id = stringToFourCCSafe(rawId);
  第三章主线Boss战利品ID缓存[装备名] = id;
  return id;
}

export function 单位持有第三章主线Boss战利品(this: void, unit: any, 装备名: string): boolean {
  if (unit == null || unit === 0) return false;
  const itemId = 取第三章主线Boss战利品物品ID(装备名);
  if (itemId === 0) return false;
  return UnitHasItemOfTypeBJ(unit, itemId) === true;
}

export function 取第三章主线Boss战利品冷却键(this: void, unit: any, tag: string): string {
  if (unit == null || unit === 0) return "";
  return tag + ":" + String(GetHandleId(unit));
}

export function 第三章主线Boss战利品冷却中(this: void, key: string): boolean {
  if (key === "") return true;
  return (第三章主线Boss战利品冷却表[key] ?? 0) > getServerTime();
}

export function 设置第三章主线Boss战利品冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  第三章主线Boss战利品冷却表[key] = getServerTime() + 秒数 * 1000;
}

export function 是技能伤害快照(this: void, snapshot: any): boolean {
  return snapshot != null && (snapshot.isSkillAttack === true || snapshot.isSkillDamage === true);
}

export {};
