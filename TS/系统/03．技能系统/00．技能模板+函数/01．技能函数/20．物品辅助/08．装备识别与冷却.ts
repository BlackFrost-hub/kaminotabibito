/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ, GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
  GetItemOfTypeFromUnitBJ: (this: void, whichUnit: any, itemId: number) => any | null;
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
const { 显示物品栏物品冷却, 设置物品栏物品冷却 } = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示") as {
  显示物品栏物品冷却: (this: void, hero: any, item: any, durationMs: number) => void;
  设置物品栏物品冷却: (this: void, hero: any, item: any, durationMs: number) => void;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const 设置技能冷却时间 = platformAbilityAction.技能_设置技能冷却时间;

const 装备物品ID缓存: Record<string, number | undefined> = {};
const 装备冷却表: Record<string, number | undefined> = {};
const 装备冷却显示持有者表: Record<string, Record<string, any> | undefined> = {};
const 装备冷却显示监听已注册: Record<string, boolean | undefined> = {};
const 装备物品显示冷却键表: Record<string, 物品显示冷却键记录 | undefined> = {};

export type 装备冷却键集合 = string | string[];
export type 装备冷却键类型 = "独有" | "公共" | "其他" | "主动";
export type 物品CD范围 = "全部" | "被动" | "独有" | "公共" | "其他" | "主动";
export type 主动技能ID集合 = number | string | Array<number | string>;

interface 物品显示冷却键记录 {
  独有: string[];
  公共: string[];
  其他: string[];
  主动: string[];
}

export interface 设置物品CD参数 {
  unit: any;
  item?: any | null;
  装备名?: string;
  秒数?: number;
  毫秒?: number;
  范围?: 物品CD范围;
  独有冷却键?: 装备冷却键集合;
  公共冷却键?: 装备冷却键集合;
  其他冷却键?: 装备冷却键集合;
  主动技能ID?: 主动技能ID集合;
  主动最大冷却秒数?: number;
  主动最大冷却毫秒?: number;
  同步UI?: boolean;
}

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
  const 持有 = itemId !== 0 && UnitHasItemOfTypeBJ(unit, itemId) === true;
  if (持有) 记录装备冷却显示持有者(unit, 装备名);
  return 持有;
}

export function 获取单位装备物品(this: void, unit: any, 装备名: string): any | null {
  if (unit == null || unit === 0) return null;
  const itemId = 取装备物品ID(装备名);
  if (itemId === 0) return null;
  return GetItemOfTypeFromUnitBJ(unit, itemId);
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

export function 取装备冷却剩余毫秒(this: void, key: string): number {
  if (key === "") return 0;
  const remaining = (装备冷却表[key] ?? 0) - getServerTime();
  return remaining > 0 ? remaining : 0;
}

function 取冷却键集合最大剩余毫秒(this: void, 冷却键: 装备冷却键集合 | undefined): number {
  if (冷却键 == null) return 0;
  if (typeof 冷却键 === "string") return 取装备冷却剩余毫秒(冷却键);

  let maxRemaining = 0;
  for (let i = 0; i < 冷却键.length; i++) {
    const remaining = 取装备冷却剩余毫秒(冷却键[i]);
    if (remaining > maxRemaining) maxRemaining = remaining;
  }
  return maxRemaining;
}

function 合并冷却键(this: void, 主冷却键: string, 相关冷却键?: 装备冷却键集合): string[] {
  const result: string[] = [];
  if (主冷却键 !== "") result.push(主冷却键);
  if (相关冷却键 == null) return result;
  if (typeof 相关冷却键 === "string") {
    if (相关冷却键 !== "" && 相关冷却键 !== 主冷却键) result.push(相关冷却键);
    return result;
  }
  for (let i = 0; i < 相关冷却键.length; i++) {
    const key = 相关冷却键[i];
    if (key !== "" && key !== 主冷却键) result.push(key);
  }
  return result;
}

function 添加冷却键到列表(this: void, list: string[], key: string): void {
  if (key === "") return;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === key) return;
  }
  list.push(key);
}

function 添加冷却键集合到列表(this: void, list: string[], 冷却键: 装备冷却键集合 | undefined): void {
  if (冷却键 == null) return;
  if (typeof 冷却键 === "string") {
    添加冷却键到列表(list, 冷却键);
    return;
  }
  for (let i = 0; i < 冷却键.length; i++) {
    添加冷却键到列表(list, 冷却键[i]);
  }
}

function 取物品显示冷却键ID(this: void, item: any): string {
  if (item == null || item === 0) return "";
  return String(GetHandleId(item));
}

function 创建物品显示冷却键记录(this: void): 物品显示冷却键记录 {
  return { 独有: [], 公共: [], 其他: [], 主动: [] };
}

function 取物品显示冷却键记录(this: void, item: any): 物品显示冷却键记录 | null {
  const itemKey = 取物品显示冷却键ID(item);
  if (itemKey === "") return null;
  let record = 装备物品显示冷却键表[itemKey];
  if (record == null) {
    record = 创建物品显示冷却键记录();
    装备物品显示冷却键表[itemKey] = record;
  }
  return record;
}

function 取物品显示冷却键列表(this: void, record: 物品显示冷却键记录, 类型: 装备冷却键类型): string[] {
  if (类型 === "独有") return record.独有;
  if (类型 === "公共") return record.公共;
  if (类型 === "主动") return record.主动;
  return record.其他;
}

function 记录物品显示冷却键(this: void, item: any, 冷却键: 装备冷却键集合, 类型: 装备冷却键类型 = "其他"): void {
  const record = 取物品显示冷却键记录(item);
  if (record == null) return;
  添加冷却键集合到列表(取物品显示冷却键列表(record, 类型), 冷却键);
}

function 合并物品全部已知冷却键(this: void, item: any, 冷却键?: 装备冷却键集合): string[] {
  const result: string[] = [];
  添加冷却键集合到列表(result, 冷却键);
  const itemKey = 取物品显示冷却键ID(item);
  const record = itemKey !== "" ? 装备物品显示冷却键表[itemKey] : undefined;
  if (record != null) {
    添加冷却键集合到列表(result, record.独有);
    添加冷却键集合到列表(result, record.公共);
    添加冷却键集合到列表(result, record.其他);
    添加冷却键集合到列表(result, record.主动);
  }
  return result;
}

export function 取装备显示冷却剩余(this: void, hero: any, item: any, 冷却键: 装备冷却键集合): number {
  if (hero == null || hero === 0 || item == null || item === 0) return 0;
  return 取冷却键集合最大剩余毫秒(合并物品全部已知冷却键(item, 冷却键));
}

function 取装备冷却显示持有者(this: void, 装备名: string): Record<string, any> {
  let holders = 装备冷却显示持有者表[装备名];
  if (holders == null) {
    holders = {};
    装备冷却显示持有者表[装备名] = holders;
  }
  return holders;
}

function 记录装备冷却显示持有者(this: void, unit: any, 装备名: string): void {
  if (unit == null || unit === 0 || 装备名 === "") return;
  取装备冷却显示持有者(装备名)[GetHandleId(unit)] = unit;
}

function 移除装备冷却显示持有者(this: void, unit: any, 装备名: string): void {
  if (unit == null || unit === 0 || 装备名 === "") return;
  const holders = 装备冷却显示持有者表[装备名];
  if (holders == null) return;
  delete holders[GetHandleId(unit)];
}

export function 注册装备冷却显示持有者追踪(this: void, 装备名: string): void {
  if (装备名 === "" || 装备冷却显示监听已注册[装备名] === true) return;
  const itemId = 取装备物品ID(装备名);
  if (itemId === 0) return;
  装备冷却显示监听已注册[装备名] = true;
  监听指定物品获取丢弃(
    itemId,
    function on装备冷却显示获取(this: void, unit: any): void {
      记录装备冷却显示持有者(unit, 装备名);
    },
    function on装备冷却显示丢弃(this: void, unit: any, _item: any, currentCount: number): void {
      if (currentCount <= 0) 移除装备冷却显示持有者(unit, 装备名);
    },
  );
}

export function 显示单位装备冷却(this: void, unit: any, 装备名: string, 冷却键: 装备冷却键集合, 类型: 装备冷却键类型 = "其他"): void {
  if (unit == null || unit === 0 || 装备名 === "") return;
  const item = 获取单位装备物品(unit, 装备名);
  if (item == null || item === 0) return;
  记录物品显示冷却键(item, 冷却键, 类型);
  const remaining = 取装备显示冷却剩余(unit, item, 冷却键);
  if (remaining > 0) 显示物品栏物品冷却(unit, item, remaining);
}

export function 显示所有持有者装备冷却(this: void, 装备名: string, 冷却键: 装备冷却键集合, 类型: 装备冷却键类型 = "公共"): void {
  if (装备名 === "") return;
  注册装备冷却显示持有者追踪(装备名);
  const holders = 装备冷却显示持有者表[装备名];
  if (holders == null) return;
  for (const id in holders) {
    显示单位装备冷却(holders[id], 装备名, 冷却键, 类型);
  }
}

export function 进入装备冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  装备冷却表[key] = getServerTime() + 秒数 * 1000;
}

export function 进入装备冷却并显示(this: void, key: string, 秒数: number, unit: any, 装备名: string, 相关冷却键?: 装备冷却键集合): void {
  进入装备冷却(key, 秒数);
  if (key === "" || !(秒数 > 0)) return;
  显示单位装备冷却(unit, 装备名, 合并冷却键(key, 相关冷却键), "独有");
}

export function 进入装备公共冷却并显示(this: void, key: string, 秒数: number, 装备名: string, 相关冷却键?: 装备冷却键集合): void {
  进入装备冷却(key, 秒数);
  if (key === "" || !(秒数 > 0)) return;
  显示所有持有者装备冷却(装备名, 合并冷却键(key, 相关冷却键), "公共");
}

export function 设置装备冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  if (!(秒数 > 0)) {
    delete 装备冷却表[key];
    return;
  }
  装备冷却表[key] = getServerTime() + 秒数 * 1000;
}

export function 刷新装备冷却(this: void, key: string): void {
  设置装备冷却(key, 0);
}

function 设置装备冷却毫秒(this: void, key: string, 毫秒: number): void {
  设置装备冷却(key, 毫秒 / 1000);
}

function 取设置物品CD毫秒(this: void, 参数: 设置物品CD参数): number {
  if (参数.毫秒 != null) return 参数.毫秒;
  if (参数.秒数 != null) return 参数.秒数 * 1000;
  return 0;
}

function 取主动最大冷却秒数(this: void, 参数: 设置物品CD参数, 当前冷却秒数: number): number {
  if (参数.主动最大冷却毫秒 != null && 参数.主动最大冷却毫秒 > 0) return 参数.主动最大冷却毫秒 / 1000;
  if (参数.主动最大冷却秒数 != null && 参数.主动最大冷却秒数 > 0) return 参数.主动最大冷却秒数;
  if (当前冷却秒数 > 0) return 当前冷却秒数;
  return 1;
}

function 获取参数物品(this: void, 参数: 设置物品CD参数): any | null {
  if (参数.item != null && 参数.item !== 0) return 参数.item;
  if (参数.装备名 == null || 参数.装备名 === "") return null;
  return 获取单位装备物品(参数.unit, 参数.装备名);
}

function 范围包含主动(this: void, 范围: 物品CD范围): boolean {
  return 范围 === "全部" || 范围 === "主动";
}

function 范围包含独有(this: void, 范围: 物品CD范围): boolean {
  return 范围 === "全部" || 范围 === "被动" || 范围 === "独有";
}

function 范围包含公共(this: void, 范围: 物品CD范围): boolean {
  return 范围 === "全部" || 范围 === "被动" || 范围 === "公共";
}

function 范围包含其他(this: void, 范围: 物品CD范围): boolean {
  return 范围 === "全部" || 范围 === "被动" || 范围 === "其他";
}

function 取物品主动冷却键(this: void, item: any): string {
  const itemKey = 取物品显示冷却键ID(item);
  return itemKey === "" ? "" : "物品主动:" + itemKey;
}

function 规范化主动技能ID列表(this: void, 主动技能ID: 主动技能ID集合 | undefined): number[] {
  const result: number[] = [];
  if (主动技能ID == null) return result;
  if (typeof 主动技能ID === "number") {
    if (主动技能ID !== 0) result.push(主动技能ID);
    return result;
  }
  if (typeof 主动技能ID === "string") {
    const id = stringToFourCCSafe(主动技能ID);
    if (id !== 0) result.push(id);
    return result;
  }
  for (let i = 0; i < 主动技能ID.length; i++) {
    const raw = 主动技能ID[i];
    const id = typeof raw === "number" ? raw : stringToFourCCSafe(raw);
    if (id !== 0) result.push(id);
  }
  return result;
}

function 取范围内物品冷却键(this: void, item: any, 范围: 物品CD范围): string[] {
  const result: string[] = [];
  const record = 取物品显示冷却键记录(item);
  if (record == null) return result;
  if (范围包含独有(范围)) 添加冷却键集合到列表(result, record.独有);
  if (范围包含公共(范围)) 添加冷却键集合到列表(result, record.公共);
  if (范围包含其他(范围)) 添加冷却键集合到列表(result, record.其他);
  if (范围包含主动(范围)) 添加冷却键集合到列表(result, record.主动);
  return result;
}

function 记录参数冷却键(this: void, item: any, 参数: 设置物品CD参数): void {
  if (参数.独有冷却键 != null) 记录物品显示冷却键(item, 参数.独有冷却键, "独有");
  if (参数.公共冷却键 != null) 记录物品显示冷却键(item, 参数.公共冷却键, "公共");
  if (参数.其他冷却键 != null) 记录物品显示冷却键(item, 参数.其他冷却键, "其他");
}

function 同步物品CD显示(this: void, unit: any, item: any): void {
  if (unit == null || unit === 0 || item == null || item === 0) return;
  const remaining = 取冷却键集合最大剩余毫秒(合并物品全部已知冷却键(item));
  设置物品栏物品冷却(unit, item, remaining);
}

export function 设置物品CD(this: void, 参数: 设置物品CD参数): number {
  const unit = 参数.unit;
  const item = 获取参数物品(参数);
  if (unit == null || unit === 0 || item == null || item === 0) return 0;

  const 范围 = 参数.范围 ?? "全部";
  const durationMs = 取设置物品CD毫秒(参数);
  const durationSec = durationMs > 0 ? durationMs / 1000 : 0;
  let count = 0;

  记录参数冷却键(item, 参数);

  if (范围包含主动(范围)) {
    const activeMaxSec = 取主动最大冷却秒数(参数, durationSec);
    const activeKey = 取物品主动冷却键(item);
    if (activeKey !== "") {
      记录物品显示冷却键(item, activeKey, "主动");
    }
    const abilityIds = 规范化主动技能ID列表(参数.主动技能ID);
    for (let i = 0; i < abilityIds.length; i++) {
      if (设置技能冷却时间(unit, abilityIds[i], durationSec, activeMaxSec)) count++;
    }
  }

  const keys = 取范围内物品冷却键(item, 范围);
  for (let i = 0; i < keys.length; i++) {
    设置装备冷却毫秒(keys[i], durationMs);
    count++;
  }

  if (参数.同步UI !== false) 同步物品CD显示(unit, item);
  return count;
}

export function 刷新物品CD(this: void, 参数: 设置物品CD参数): number {
  const oldMs = 参数.毫秒;
  const oldSec = 参数.秒数;
  参数.毫秒 = 0;
  参数.秒数 = undefined;
  const result = 设置物品CD(参数);
  参数.毫秒 = oldMs;
  参数.秒数 = oldSec;
  return result;
}

export function 设置物品冷却(this: void, 参数: 设置物品CD参数): number {
  return 设置物品CD(参数);
}

export function 刷新物品冷却(this: void, 参数: 设置物品CD参数): number {
  return 刷新物品CD(参数);
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

export function 进入冷却并显示(this: void, key: string, 秒数: number, unit: any, 装备名: string, 相关冷却键?: 装备冷却键集合): void {
  进入装备冷却并显示(key, 秒数, unit, 装备名, 相关冷却键);
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
