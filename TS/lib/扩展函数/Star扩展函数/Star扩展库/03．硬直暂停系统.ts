/** @noSelfInFile */
/**
 * Star扩展库 - 硬直/暂停系统
 *
 * 来源于 SUSPEND.j，提供单位暂停控制功能。
 * 优先通过 EXPauseUnit(japi) 暂停单位，缺失时回退到 PauseUnit；两者统一由来源管理池调度。
 * 只有 EXPauseUnit 自带引用计数语义，PauseUnit 本身不要求调用次数配平。
 * 支持暂停时间累加、减少、取最大值等操作。
 *
 * 业务统一接口（参数顺序统一为：单位、来源、时间）：
 *   添加单位暂停(u, 来源)
 *   移除单位暂停(u, 来源)
 *   设置单位暂停时间(u, 来源, 秒)
 *   增加单位暂停时间(u, 来源, 秒)
 *   减少单位暂停时间(u, 来源, 秒)
 *   单位是否暂停(u)
 *   获取单位暂停剩余时间(u, 来源)
 * GS_* 与申请/释放占用系列仅保留给旧代码兼容，新业务不要继续使用。
 */

const jass = require("jass.common") as any;
const { RMaxBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  RMaxBJ: (this: void, a: number, b: number) => number;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

const PauseUnit = jass.PauseUnit as (u: any, flag: boolean) => void;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const EXPauseUnit = japi != null && typeof japi.EXPauseUnit === "function"
  ? japi.EXPauseUnit as (u: any, flag: boolean) => void
  : undefined;
const 单位暂停占用总表: Record<number, number | undefined> = {};
const 单位暂停占用来源表: Record<string, number | undefined> = {};
const 单位暂停占用单位表: Record<number, any> = {};
const 单位暂停来源列表表: Record<number, string[] | undefined> = {};

export interface 单位暂停事件 {
  单位: any;
  单位ID: number;
  来源: string;
  来源计数: number;
  总计数: number;
}

export interface 单位暂停占用变化事件 extends 单位暂停事件 {
  操作: "申请" | "释放";
}

export interface 单位暂停快照 {
  单位: any;
  单位ID: number;
  总计数: number;
  来源列表: string[];
}

export type 单位暂停事件监听 = (this: void, event: 单位暂停事件) => void;
export type 单位暂停占用变化监听 = (this: void, event: 单位暂停占用变化事件) => void;

const 任意单位被暂停监听列表: 单位暂停事件监听[] = [];
const 任意单位取消暂停监听列表: 单位暂停事件监听[] = [];
const 单位暂停占用变化监听列表: 单位暂停占用变化监听[] = [];

function hid(h: any): number {
  return GetHandleId(h) || 0;
}

function 注册暂停事件监听(list: 单位暂停事件监听[], cb: 单位暂停事件监听): void {
  if (cb == null) return;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === cb) return;
  }
  list.push(cb);
}

function 注册暂停占用变化监听(cb: 单位暂停占用变化监听): void {
  if (cb == null) return;
  for (let i = 0; i < 单位暂停占用变化监听列表.length; i++) {
    if (单位暂停占用变化监听列表[i] === cb) return;
  }
  单位暂停占用变化监听列表.push(cb);
}

function 通知暂停事件(list: 单位暂停事件监听[], event: 单位暂停事件): void {
  for (let i = 0; i < list.length; i++) {
    list[i](event);
  }
}

function 通知暂停占用变化(event: 单位暂停占用变化事件): void {
  for (let i = 0; i < 单位暂停占用变化监听列表.length; i++) {
    单位暂停占用变化监听列表[i](event);
  }
}

function 设置底层暂停状态(u: any, 是否暂停: boolean): void {
  if (u == null || u === 0) return;

  // EXPauseUnit 自带计数语义，只能在管理池总占用 0↔1 时成对调用，禁止周期性重复补写 true。
  // PauseUnit 本身没有这项计数要求；这里只是让两种底层 API 共用同一套来源管理。
  if (EXPauseUnit != null) {
    EXPauseUnit(u, 是否暂停);
    return;
  }

  PauseUnit(u, 是否暂停);
}

function 生成暂停来源键(单位ID: number, 来源: string): string {
  return `${单位ID}:${来源}`;
}

function 加入单位暂停来源(单位ID: number, 来源: string): void {
  let list = 单位暂停来源列表表[单位ID];
  if (list == null) {
    list = [];
    单位暂停来源列表表[单位ID] = list;
  }
  for (let i = 0; i < list.length; i++) {
    if (list[i] === 来源) return;
  }
  list.push(来源);
}

function 移除单位暂停来源(单位ID: number, 来源: string): void {
  const list = 单位暂停来源列表表[单位ID];
  if (list == null) return;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === 来源) {
      list.splice(i, 1);
      break;
    }
  }
  if (list.length <= 0) delete 单位暂停来源列表表[单位ID];
}

function 复制单位暂停来源列表(单位ID: number): string[] {
  const list = 单位暂停来源列表表[单位ID];
  const out: string[] = [];
  if (list == null) return out;
  for (let i = 0; i < list.length; i++) {
    out.push(list[i]);
  }
  return out;
}

let 清理单位暂停来源定时任务: (this: void, 单位ID: number, 来源: string) => void = function (_单位ID: number, _来源: string): void {};

export function 申请单位暂停占用(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;

  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  单位暂停占用单位表[单位ID] = u;

  const 来源键 = 生成暂停来源键(单位ID, 来源);
  const 原来源计数 = 单位暂停占用来源表[来源键] ?? 0;
  const 新来源计数 = 原来源计数 + 1;
  单位暂停占用来源表[来源键] = 新来源计数;

  if (原来源计数 > 0) {
    通知暂停占用变化({ 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 单位暂停占用总表[单位ID] ?? 0, 操作: "申请" });
    return true;
  }

  加入单位暂停来源(单位ID, 来源);
  const 原总计数 = 单位暂停占用总表[单位ID] ?? 0;
  const 新总计数 = 原总计数 + 1;
  单位暂停占用总表[单位ID] = 新总计数;
  通知暂停占用变化({ 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 新总计数, 操作: "申请" });
  if (原总计数 <= 0) {
    设置底层暂停状态(u, true);
    通知暂停事件(任意单位被暂停监听列表, { 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 新总计数 });
  }
  return true;
}

export function 释放单位暂停占用(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;

  const 单位ID = hid(u);
  if (单位ID === 0) return false;

  const 来源键 = 生成暂停来源键(单位ID, 来源);
  const 原来源计数 = 单位暂停占用来源表[来源键] ?? 0;
  if (原来源计数 <= 0) return false;

  let 新来源计数 = 原来源计数 - 1;
  if (原来源计数 <= 1) {
    delete 单位暂停占用来源表[来源键];
    新来源计数 = 0;
    移除单位暂停来源(单位ID, 来源);
  } else {
    单位暂停占用来源表[来源键] = 新来源计数;
    通知暂停占用变化({ 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 单位暂停占用总表[单位ID] ?? 0, 操作: "释放" });
    return true;
  }

  const 原总计数 = 单位暂停占用总表[单位ID] ?? 0;
  let 新总计数 = 原总计数;
  if (原总计数 <= 1) {
    新总计数 = 0;
    delete 单位暂停占用总表[单位ID];
    设置底层暂停状态(u, false);
    通知暂停占用变化({ 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 新总计数, 操作: "释放" });
    通知暂停事件(任意单位取消暂停监听列表, { 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 新总计数 });
    delete 单位暂停占用单位表[单位ID];
    delete 单位暂停来源列表表[单位ID];
  } else {
    新总计数 = 原总计数 - 1;
    单位暂停占用总表[单位ID] = 新总计数;
    通知暂停占用变化({ 单位: u, 单位ID, 来源, 来源计数: 新来源计数, 总计数: 新总计数, 操作: "释放" });
  }
  return true;
}

export function 释放单位暂停来源全部(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  清理单位暂停来源定时任务(单位ID, 来源);
  let changed = false;
  while (获取单位暂停来源计数(u, 来源) > 0) {
    if (!释放单位暂停占用(u, 来源)) break;
    changed = true;
  }
  return changed;
}

export function 申请单位暂停独立占用(u: any, 来源: string): boolean {
  if (获取单位暂停来源计数(u, 来源) > 0) return true;
  return 申请单位暂停占用(u, 来源);
}

export function 设置单位暂停独立占用(u: any, 来源: string, 是否暂停: boolean): boolean {
  return 是否暂停 ? 申请单位暂停独立占用(u, 来源) : 释放单位暂停来源全部(u, 来源);
}

export function 清除单位全部暂停占用(u: any): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  const 来源列表 = 复制单位暂停来源列表(单位ID);
  let changed = false;
  for (let i = 0; i < 来源列表.length; i++) {
    if (释放单位暂停来源全部(u, 来源列表[i])) changed = true;
  }
  return changed;
}

export function 单位是否存在暂停占用(u: any): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  return (单位暂停占用总表[单位ID] ?? 0) > 0;
}

export function 单位是否存在其他暂停占用(u: any, 自身来源: string): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;

  const 总计数 = 单位暂停占用总表[单位ID] ?? 0;
  if (总计数 <= 0) return false;

  const 自身来源存在 = 自身来源 != null && 自身来源 !== ""
    && (单位暂停占用来源表[生成暂停来源键(单位ID, 自身来源)] ?? 0) > 0;

  return 总计数 > (自身来源存在 ? 1 : 0);
}

export function 获取单位暂停占用总数(u: any): number {
  if (u == null || u === 0) return 0;
  const 单位ID = hid(u);
  if (单位ID === 0) return 0;
  return 单位暂停占用总表[单位ID] ?? 0;
}

export function 获取单位暂停来源计数(u: any, 来源: string): number {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return 0;
  const 单位ID = hid(u);
  if (单位ID === 0) return 0;
  return 单位暂停占用来源表[生成暂停来源键(单位ID, 来源)] ?? 0;
}

export function 获取单位暂停来源列表(u: any): string[] {
  if (u == null || u === 0) return [];
  const 单位ID = hid(u);
  if (单位ID === 0) return [];
  return 复制单位暂停来源列表(单位ID);
}

export function 获取单位暂停快照(u: any): 单位暂停快照 {
  if (u == null || u === 0) {
    return { 单位: u, 单位ID: 0, 总计数: 0, 来源列表: [] };
  }
  const 单位ID = hid(u);
  if (单位ID === 0) {
    return { 单位: u, 单位ID: 0, 总计数: 0, 来源列表: [] };
  }
  return {
    单位: u,
    单位ID,
    总计数: 单位暂停占用总表[单位ID] ?? 0,
    来源列表: 复制单位暂停来源列表(单位ID),
  };
}

export function 刷新单位暂停底层状态(u: any): boolean {
  if (u == null || u === 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  // 兼容旧接口：EXPauseUnit 是引用计数 API，不能通过重复写入当前状态来“刷新”，这里只返回管理池状态。
  return (单位暂停占用总表[单位ID] ?? 0) > 0;
}

export function 注册任意单位被暂停监听(cb: 单位暂停事件监听): void {
  注册暂停事件监听(任意单位被暂停监听列表, cb);
}

export function 注册任意单位取消暂停监听(cb: 单位暂停事件监听): void {
  注册暂停事件监听(任意单位取消暂停监听列表, cb);
}

export function 注册单位暂停占用变化监听(cb: 单位暂停占用变化监听): void {
  注册暂停占用变化监听(cb);
}

export type 单位暂停定时模式 = "刷新" | "叠加" | "取最大";

interface 暂停来源到期任务 {
  单位: any;
  单位ID: number;
  来源: string;
  到期时间毫秒: number;
}

const 暂停来源到期任务列表: 暂停来源到期任务[] = [];
let 暂停来源到期驱动已注册 = false;

function 查找暂停来源到期任务索引(单位ID: number, 来源: string): number {
  for (let i = 0; i < 暂停来源到期任务列表.length; i++) {
    const 任务 = 暂停来源到期任务列表[i];
    if (任务.单位ID === 单位ID && 任务.来源 === 来源) return i;
  }
  return -1;
}

清理单位暂停来源定时任务 = function (单位ID: number, 来源: string): void {
  const 任务索引 = 查找暂停来源到期任务索引(单位ID, 来源);
  if (任务索引 >= 0) 暂停来源到期任务列表.splice(任务索引, 1);
};

function on暂停来源到期驱动(this: void): void {
  if (暂停来源到期任务列表.length === 0) return;

  const 当前时间毫秒 = getServerTime();
  let 写入位置 = 0;
  for (let i = 0; i < 暂停来源到期任务列表.length; i++) {
    const 任务 = 暂停来源到期任务列表[i];
    if (当前时间毫秒 >= 任务.到期时间毫秒) {
      while (获取单位暂停来源计数(任务.单位, 任务.来源) > 0) {
        if (!释放单位暂停占用(任务.单位, 任务.来源)) break;
      }
    } else {
      暂停来源到期任务列表[写入位置] = 任务;
      写入位置++;
    }
  }
  while (暂停来源到期任务列表.length > 写入位置) {
    暂停来源到期任务列表.pop();
  }
}

function 确保暂停来源到期驱动(): void {
  if (暂停来源到期驱动已注册) return;
  暂停来源到期驱动已注册 = true;
  addPeriodicCallback(10, on暂停来源到期驱动);
}

export function 申请单位暂停占用定时(u: any, 来源: string, 持续时间: number, 模式?: 单位暂停定时模式): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  if (持续时间 <= 0) {
    清理单位暂停来源定时任务(单位ID, 来源);
    return 释放单位暂停占用(u, 来源);
  }

  const 当前时间毫秒 = getServerTime();
  const 持续毫秒 = 持续时间 * 1000;
  const 任务索引 = 查找暂停来源到期任务索引(单位ID, 来源);
  const 当前模式 = 模式 ?? "刷新";
  if (任务索引 < 0) {
    const ok = 申请单位暂停独立占用(u, 来源);
    if (!ok) return false;
    暂停来源到期任务列表.push({ 单位: u, 单位ID, 来源, 到期时间毫秒: 当前时间毫秒 + 持续毫秒 });
    确保暂停来源到期驱动();
    return true;
  }

  const 任务 = 暂停来源到期任务列表[任务索引];
  任务.单位 = u;
  if (当前模式 === "叠加") {
    任务.到期时间毫秒 = RMaxBJ(当前时间毫秒, 任务.到期时间毫秒) + 持续毫秒;
  } else if (当前模式 === "取最大") {
    任务.到期时间毫秒 = RMaxBJ(任务.到期时间毫秒, 当前时间毫秒 + 持续毫秒);
  } else {
    任务.到期时间毫秒 = 当前时间毫秒 + 持续毫秒;
  }
  确保暂停来源到期驱动();
  return true;
}

export function 取消单位暂停占用定时(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  const 任务索引 = 查找暂停来源到期任务索引(单位ID, 来源);
  if (任务索引 >= 0) 暂停来源到期任务列表.splice(任务索引, 1);
  return 释放单位暂停来源全部(u, 来源);
}

/**
 * 业务层暂停接口：所有调用都必须传稳定且唯一的来源名。
 * 外部业务不要直接调用 EXPauseUnit / PauseUnit：前者需要配平计数，后者仅纳入同一管理入口。
 */
export function 添加单位暂停(u: any, 来源: string): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  清理单位暂停来源定时任务(单位ID, 来源);
  return 申请单位暂停独立占用(u, 来源);
}

export function 移除单位暂停(u: any, 来源: string): boolean {
  return 释放单位暂停来源全部(u, 来源);
}

export function 单位是否暂停(u: any): boolean {
  return 单位是否存在暂停占用(u);
}

export function 设置单位暂停时间(u: any, 来源: string, 持续时间: number): boolean {
  if (持续时间 <= 0) return 移除单位暂停(u, 来源);
  return 申请单位暂停占用定时(u, 来源, 持续时间, "刷新");
}

export function 增加单位暂停时间(u: any, 来源: string, 增加时间: number): boolean {
  if (增加时间 <= 0) return false;
  return 申请单位暂停占用定时(u, 来源, 增加时间, "叠加");
}

export function 减少单位暂停时间(u: any, 来源: string, 减少时间: number): boolean {
  if (u == null || u === 0 || 来源 == null || 来源 === "" || 减少时间 <= 0) return false;
  const 单位ID = hid(u);
  if (单位ID === 0) return false;
  const 任务索引 = 查找暂停来源到期任务索引(单位ID, 来源);
  if (任务索引 < 0) return false;

  const 任务 = 暂停来源到期任务列表[任务索引];
  任务.到期时间毫秒 -= 减少时间 * 1000;
  if (任务.到期时间毫秒 > getServerTime()) return true;

  暂停来源到期任务列表.splice(任务索引, 1);
  return 释放单位暂停来源全部(u, 来源);
}

export function 获取单位暂停剩余时间(u: any, 来源: string): number {
  if (u == null || u === 0 || 来源 == null || 来源 === "") return 0;
  const 单位ID = hid(u);
  if (单位ID === 0) return 0;
  const 任务索引 = 查找暂停来源到期任务索引(单位ID, 来源);
  if (任务索引 < 0) return 0;
  return RMaxBJ(0, 暂停来源到期任务列表[任务索引].到期时间毫秒 - getServerTime()) * 0.001;
}

/**
 * 暂停单位一段时间
 * 若单位已在暂停中，会重置暂停时间
 * @param u 目标单位
 * @param time 暂停时间（秒）
 */
export function GS_Suspend(u: any, time: number): void {
  设置单位暂停时间(u, "GS_Suspend", time);
}

/**
 * 检查单位是否处于暂停状态
 * @param u 目标单位
 * @returns 是否正在暂停中
 */
export function GS_IsUnitSuspending(u: any): boolean {
  if (u == null || u === 0) return false;

  return GS_LoadSuspend(u) > 0;
}

/** 获取单位剩余暂停时间（秒）。 */
export function GS_LoadSuspend(u: any): number {
  return 获取单位暂停剩余时间(u, "GS_Suspend");
}

/**
 * 修改单位暂停时间
 * @param u 目标单位
 * @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
 * @param r 时间值（秒）
 */
export function GS_UnitSuspend(u: any, i: number, r: number): void {
  if (u == null || u === 0) return;
  if (i === 0) {
    增加单位暂停时间(u, "GS_Suspend", r);
  } else if (i === 1) {
    减少单位暂停时间(u, "GS_Suspend", r);
  } else if (i === 2 && r > 0) {
    申请单位暂停占用定时(u, "GS_Suspend", r, "取最大");
  }
}

export {};
