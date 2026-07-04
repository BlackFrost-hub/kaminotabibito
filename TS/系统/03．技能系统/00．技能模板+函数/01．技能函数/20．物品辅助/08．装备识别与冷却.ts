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
const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};
const { 监听指定物品获取丢弃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (this: void, itemTypeId: number, 获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void, 丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 装备物品ID缓存: Record<string, number | undefined> = {};
const 装备冷却表: Record<string, number | undefined> = {};

export function 取装备物品ID(this: void, 装备名: string): number {
  const cached = 装备物品ID缓存[装备名];
  if (cached != null) return cached;
  const id = stringToFourCCSafe(按名字反查物品ID(装备名));
  装备物品ID缓存[装备名] = id;
  return id;
}

export function 单位持有装备(this: void, unit: any, 装备名: string): boolean {
  if (unit == null || unit === 0) return false;
  const itemId = 取装备物品ID(装备名);
  return itemId !== 0 && UnitHasItemOfTypeBJ(unit, itemId) === true;
}

export function 取装备冷却键(this: void, unit: any, tag: string, 前缀: string = "装备"): string {
  if (unit == null || unit === 0 || tag === "") return "";
  return 前缀 + ":" + tag + ":" + String(GetHandleId(unit));
}

export function 取单位对单位冷却键(this: void, source: any, target: any, tag: string, 前缀: string = "装备单位对单位"): string {
  if (source == null || source === 0 || target == null || target === 0 || tag === "") return "";
  return 前缀 + ":" + tag + ":" + String(GetHandleId(source)) + ":" + String(GetHandleId(target));
}

export function 装备冷却就绪(this: void, key: string): boolean {
  return key !== "" && (装备冷却表[key] ?? 0) <= getServerTime();
}

export function 装备冷却中(this: void, key: string): boolean {
  return key === "" || (装备冷却表[key] ?? 0) > getServerTime();
}

export function 进入装备冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  装备冷却表[key] = getServerTime() + 秒数 * 1000;
}

export function 装备概率通过(this: void, unit: any, chance: number): boolean {
  return chance >= 1 || (chance > 0 && 装备触发概率通过(chance, unit) === true);
}

export function 取第二章后段Boss战利品ID(this: void, 装备名: string): number {
  return 取装备物品ID(装备名);
}

export function 单位持有第二章后段Boss战利品(this: void, unit: any, 装备名: string): boolean {
  return 单位持有装备(unit, 装备名);
}

export function 取冷却键(this: void, unit: any, tag: string): string {
  return 取装备冷却键(unit, tag, "第二章后段Boss战利品");
}

export function 冷却就绪(this: void, key: string): boolean {
  return 装备冷却就绪(key);
}

export function 进入冷却(this: void, key: string, 秒数: number): void {
  进入装备冷却(key, 秒数);
}

export function 概率通过(this: void, unit: any, chance: number): boolean {
  return 装备概率通过(unit, chance);
}

export function 监听装备丢弃清理(this: void, 装备名: string, 清理回调: (this: void, unit: any) => void): void {
  const itemId = 取装备物品ID(装备名);
  if (itemId === 0) return;
  监听指定物品获取丢弃(itemId, undefined, function on装备丢弃清理(this: void, unit: any): void {
    清理回调(unit);
  });
}

export {};
