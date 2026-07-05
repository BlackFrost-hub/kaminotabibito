/** @noSelfInFile */

const jass = require("jass.common") as any;
const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const ydweModule = require("lib.扩展函数.YDWE函数.index") as {
  YDWEGetItemDataString: (this: void, self: any, itemcode: number, dataType: number) => string;
  getObjectProperty: (this: void, self: any, objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number; ITEM: number };
};
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, fourcc: number) => string;
};

export const ObjectType = ydweModule.ObjectType;

const rawYDWEGetItemDataString = ydweModule.YDWEGetItemDataString;
const rawGetObjectProperty = ydweModule.getObjectProperty;
const 添加周期回调 = centerTimer.addPeriodicCallback;
const 取服务器时间 = centerTimer.getServerTime;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const 物品提示缓存过期毫秒 = 300000;
const 物品提示缓存清理间隔毫秒 = 5000;

function 取物编查询ID(this: void, objectType: number, objectId: number | string): number | string {
  if (objectType === ObjectType.ITEM && typeof objectId === "number") return fourCCToString(objectId);
  return objectId;
}

let 物编字符串缓存: Record<string, string | undefined> = {};
let 物品数据字符串缓存: Record<string, string | undefined> = {};
let 物编字符串缓存访问时间: Record<string, number | undefined> = {};
let 物品数据字符串缓存访问时间: Record<string, number | undefined> = {};
let 物编字符串缓存键列表: string[] = [];
let 物品数据字符串缓存键列表: string[] = [];
let 物品提示缓存清理TickID = 0;

function 取物编缓存键(this: void, objectType: number, objectId: number | string, property: string): string {
  return objectType + ":" + tostring(objectId) + ":" + property;
}

function 取物品数据缓存键(this: void, itemKey: number | string, dataType: number): string {
  return tostring(itemKey) + ":" + dataType;
}

export function 清空物品提示读取缓存(this: void): void {
  物编字符串缓存 = {};
  物品数据字符串缓存 = {};
  物编字符串缓存访问时间 = {};
  物品数据字符串缓存访问时间 = {};
  物编字符串缓存键列表 = [];
  物品数据字符串缓存键列表 = [];
}

function 记录物编缓存访问(this: void, 缓存键: string): void {
  if (物编字符串缓存访问时间[缓存键] === undefined) {
    物编字符串缓存键列表.push(缓存键);
  }
  物编字符串缓存访问时间[缓存键] = 取服务器时间();
}

function 记录物品数据缓存访问(this: void, 缓存键: string): void {
  if (物品数据字符串缓存访问时间[缓存键] === undefined) {
    物品数据字符串缓存键列表.push(缓存键);
  }
  物品数据字符串缓存访问时间[缓存键] = 取服务器时间();
}

function 清理物编过期缓存(this: void, 当前时间: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 物编字符串缓存键列表.length; i++) {
    const 缓存键 = 物编字符串缓存键列表[i];
    const 最后访问 = 物编字符串缓存访问时间[缓存键];
    if (最后访问 !== undefined && 当前时间 - 最后访问 < 物品提示缓存过期毫秒) {
      物编字符串缓存键列表[writeIndex] = 缓存键;
      writeIndex++;
    } else {
      delete 物编字符串缓存[缓存键];
      delete 物编字符串缓存访问时间[缓存键];
    }
  }
  物编字符串缓存键列表.length = writeIndex;
}

function 清理物品数据过期缓存(this: void, 当前时间: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 物品数据字符串缓存键列表.length; i++) {
    const 缓存键 = 物品数据字符串缓存键列表[i];
    const 最后访问 = 物品数据字符串缓存访问时间[缓存键];
    if (最后访问 !== undefined && 当前时间 - 最后访问 < 物品提示缓存过期毫秒) {
      物品数据字符串缓存键列表[writeIndex] = 缓存键;
      writeIndex++;
    } else {
      delete 物品数据字符串缓存[缓存键];
      delete 物品数据字符串缓存访问时间[缓存键];
    }
  }
  物品数据字符串缓存键列表.length = writeIndex;
}

function 执行物品提示缓存过期清理(this: void): void {
  const 当前时间 = 取服务器时间();
  清理物编过期缓存(当前时间);
  清理物品数据过期缓存(当前时间);
}

export function 确保物品提示缓存清理Tick(this: void): void {
  if (物品提示缓存清理TickID !== 0) return;
  物品提示缓存清理TickID = 添加周期回调(物品提示缓存清理间隔毫秒, 执行物品提示缓存过期清理);
}

let 待读物编类型 = 0;
let 待读物编ID: number | string = 0;
let 待读物编属性 = "";
let 读取物编结果 = "";

function 执行读取物编字符串(this: any): void {
  读取物编结果 = rawGetObjectProperty(undefined as any, 待读物编类型, 待读物编ID, 待读物编属性) || "";
}

export function 安全取物编字符串(this: void, objectType: number, objectId: number | string, property: string): string {
  const 查询ID = 取物编查询ID(objectType, objectId);
  const 缓存键 = 取物编缓存键(objectType, 查询ID, property);
  const 已缓存 = 物编字符串缓存[缓存键];
  if (已缓存 !== undefined) {
    记录物编缓存访问(缓存键);
    return 已缓存;
  }

  待读物编类型 = objectType;
  待读物编ID = 查询ID;
  待读物编属性 = property;
  读取物编结果 = "";
  const ok = pcall(执行读取物编字符串) as unknown as boolean;
  if (ok === true) {
    const 结果 = 读取物编结果 || "";
    物编字符串缓存[缓存键] = 结果;
    记录物编缓存访问(缓存键);
    return 结果;
  }
  return "";
}

export function 安全取物编整数(this: void, objectType: number, objectId: number | string, property: string): number {
  const value = parseInt(安全取物编字符串(objectType, objectId, property));
  return value || 0;
}

let 待读物品数据ID = 0;
let 待读物品数据类型 = 0;
let 读取物品数据结果 = "";

function 执行读取物品数据字符串(this: any): void {
  读取物品数据结果 = rawYDWEGetItemDataString(undefined as any, 待读物品数据ID, 待读物品数据类型) || "";
}

function 安全取物品数据字符串(this: void, itemTypeId: number, dataType: number, 缓存物品键?: number | string): string {
  const 缓存键 = 取物品数据缓存键(缓存物品键 ?? ("type:" + itemTypeId), dataType);
  const 已缓存 = 物品数据字符串缓存[缓存键];
  if (已缓存 !== undefined && 已缓存 !== "") {
    记录物品数据缓存访问(缓存键);
    return 已缓存;
  }

  待读物品数据ID = itemTypeId;
  待读物品数据类型 = dataType;
  读取物品数据结果 = "";
  const ok = pcall(执行读取物品数据字符串) as unknown as boolean;
  if (ok === true) {
    const 结果 = 读取物品数据结果 || "";
    if (结果 !== "") {
      物品数据字符串缓存[缓存键] = 结果;
      记录物品数据缓存访问(缓存键);
    }
    return 结果;
  }
  return "";
}

export function 安全取物品实例数据字符串(this: void, item: any, itemTypeId: number, dataType: number): string {
  if (item == null || item === 0) return 安全取物品数据字符串(itemTypeId, dataType);
  const 实例缓存键 = 取物品数据缓存键(GetHandleId(item), dataType);
  const 已缓存 = 物品数据字符串缓存[实例缓存键];
  if (已缓存 !== undefined && 已缓存 !== "") {
    记录物品数据缓存访问(实例缓存键);
    return 已缓存;
  }
  const 类型物遍文本 = 安全取物品数据字符串(itemTypeId, dataType);
  if (类型物遍文本 !== "") {
    物品数据字符串缓存[实例缓存键] = 类型物遍文本;
    记录物品数据缓存访问(实例缓存键);
  }
  return 类型物遍文本;
}

export {};
