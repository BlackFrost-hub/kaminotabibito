/** @noSelfInFile */
/**
 * 装备采集 - 通用运行时
 *
 * 采集物品由创建方登记“物品实例 + 刷新区域”，本模块只负责：
 * - 被采摘后按配置延迟，在原区域随机位置补回一份；
 * - 地面上的采集物品按配置周期随机换点；
 * - 同一物品 ID 可以同时存在于多个区域，不再依赖物品 ID 反查唯一区域。
 */

const jass = require("jass.common") as any;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { 采集配置列表 } = require("系统.02．物品系统.17．装备采集.00．公共.01．配置表") as {
  采集配置列表: import("./00．公共/01．配置表").采集配置项[];
};
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetRectMinX = jass.GetRectMinX as (this: void, whichRect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (this: void, whichRect: any) => number;
const GetRectMinY = jass.GetRectMinY as (this: void, whichRect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (this: void, whichRect: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const SetItemPosition = jass.SetItemPosition as (this: void, item: any, x: number, y: number) => void;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;

type 采集物品状态 = "地面" | "携带";

interface 采集物品运行时记录 {
  物品: any;
  物品类型ID: number;
  刷新区域名称: string;
  采摘刷新延迟毫秒: number;
  随机换点间隔毫秒: number;
  状态: 采集物品状态;
  下次随机换点时间: number;
  刷新任务ID?: number;
}

let 采集配置索引表: Record<number, import("./00．公共/01．配置表").采集配置项> | undefined;
const 采集物品记录表: Record<number, 采集物品运行时记录 | undefined> = {};
const 采集物品记录列表: 采集物品运行时记录[] = [];
let 已初始化装备采集 = false;

function 构建采集配置索引表(this: void): Record<number, import("./00．公共/01．配置表").采集配置项> {
  const 索引表: Record<number, import("./00．公共/01．配置表").采集配置项> = {};
  for (let i = 0; i < 采集配置列表.length; i++) {
    const 配置 = 采集配置列表[i];
    if (配置.物品ID > 0) 索引表[配置.物品ID] = 配置;
  }
  return 索引表;
}

function 获取采集配置(this: void, 物品类型ID: number): import("./00．公共/01．配置表").采集配置项 | undefined {
  if (采集配置索引表 == null) 采集配置索引表 = 构建采集配置索引表();
  return 采集配置索引表[物品类型ID];
}

function 获取采集物品记录(this: void, 物品: any): 采集物品运行时记录 | undefined {
  if (物品 == null || 物品 === 0) return undefined;
  const 句柄ID = GetHandleId(物品);
  if (句柄ID <= 0) return undefined;
  return 采集物品记录表[句柄ID];
}

function 删除采集物品记录(this: void, 记录: 采集物品运行时记录): void {
  const 句柄ID = GetHandleId(记录.物品);
  if (句柄ID > 0 && 采集物品记录表[句柄ID] === 记录) {
    delete 采集物品记录表[句柄ID];
  }
  for (let i = 0; i < 采集物品记录列表.length; i++) {
    if (采集物品记录列表[i] !== 记录) continue;
    采集物品记录列表.splice(i, 1);
    return;
  }
}

function 取消采集物品刷新任务(this: void, 记录: 采集物品运行时记录): void {
  if (记录.刷新任务ID == null) return;
  removeDelayedCallback(记录.刷新任务ID);
  记录.刷新任务ID = undefined;
}

function 获取区域随机坐标(this: void, 区域名称: string): { X: number; Y: number } | undefined {
  const 区域 = 获取矩形区域(区域名称);
  if (区域 == null || 区域 === 0) return undefined;
  return {
    X: GetRandomReal(GetRectMinX(区域), GetRectMaxX(区域)),
    Y: GetRandomReal(GetRectMinY(区域), GetRectMaxY(区域)),
  };
}

function 生成采集物品记录(
  this: void,
  物品: any,
  物品类型ID: number,
  刷新区域名称: string,
): 采集物品运行时记录 | undefined {
  const 配置 = 获取采集配置(物品类型ID);
  if (配置 == null || 物品 == null || 物品 === 0 || 刷新区域名称 === "") return undefined;

  const 采摘刷新延迟毫秒 = 配置.采摘刷新延迟秒 > 0 ? 配置.采摘刷新延迟秒 * 1000 : 0;
  const 随机换点间隔毫秒 = 配置.随机换点间隔秒 > 0 ? 配置.随机换点间隔秒 * 1000 : 0;
  return {
    物品,
    物品类型ID,
    刷新区域名称,
    采摘刷新延迟毫秒,
    随机换点间隔毫秒,
    状态: "地面",
    下次随机换点时间: getServerTime() + 随机换点间隔毫秒,
  };
}

/** 创建方在物品落地后调用；区域由创建方提供，因此同一物品 ID 可跨多个区域复用。 */
export function 登记采集物品实例(this: void, 物品: any, 物品类型ID: number, 刷新区域名称: string): boolean {
  const 新记录 = 生成采集物品记录(物品, 物品类型ID, 刷新区域名称);
  if (新记录 == null) return false;

  const 句柄ID = GetHandleId(物品);
  const 旧记录 = 采集物品记录表[句柄ID];
  if (旧记录 != null) {
    取消采集物品刷新任务(旧记录);
    删除采集物品记录(旧记录);
  }

  采集物品记录表[句柄ID] = 新记录;
  采集物品记录列表.push(新记录);
  return true;
}

function 创建并登记采集物品(this: void, 物品类型ID: number, 刷新区域名称: string): any {
  const 坐标 = 获取区域随机坐标(刷新区域名称);
  if (坐标 == null) return undefined;
  const 物品 = 创建物品并注册排泄监听(物品类型ID, 坐标.X, 坐标.Y);
  if (物品 == null || 物品 === 0) return undefined;
  登记采集物品实例(物品, 物品类型ID, 刷新区域名称);
  return 物品;
}

function 处理采集物品拾取(this: void, _单位: any, 物品: any): void {
  const 记录 = 获取采集物品记录(物品);
  if (记录 == null) return;
  取消采集物品刷新任务(记录);
  记录.状态 = "携带";
  记录.刷新任务ID = addDelayedCallback(记录.采摘刷新延迟毫秒, on采集物品刷新到期, 记录);
}

function 处理采集物品丢弃(this: void, _单位: any, 物品: any): void {
  const 记录 = 获取采集物品记录(物品);
  if (记录 == null || 记录.状态 !== "携带") return;
  取消采集物品刷新任务(记录);
  记录.状态 = "地面";
  记录.下次随机换点时间 = getServerTime() + 记录.随机换点间隔毫秒;
}

function on采集物品刷新到期(this: void, 变量?: any): void {
  const 记录 = 变量 as 采集物品运行时记录 | undefined;
  if (记录 == null || 记录.状态 !== "携带") return;
  记录.刷新任务ID = undefined;
  const 物品类型ID = 记录.物品类型ID;
  const 刷新区域名称 = 记录.刷新区域名称;
  删除采集物品记录(记录);
  创建并登记采集物品(物品类型ID, 刷新区域名称);
}

function on采集物品随机换点Tick(this: void): void {
  const 当前时间 = getServerTime();
  for (let i = 0; i < 采集物品记录列表.length; i++) {
    const 记录 = 采集物品记录列表[i];
    if (记录.状态 !== "地面" || 记录.随机换点间隔毫秒 <= 0 || 当前时间 < 记录.下次随机换点时间) continue;

    const 坐标 = 获取区域随机坐标(记录.刷新区域名称);
    if (坐标 != null) SetItemPosition(记录.物品, 坐标.X, 坐标.Y);
    记录.下次随机换点时间 = 当前时间 + 记录.随机换点间隔毫秒;
  }
}

export function 初始化装备采集(this: void): void {
  if (已初始化装备采集 || 采集配置列表.length <= 0) return;
  已初始化装备采集 = true;
  onItemPickup(处理采集物品拾取);
  onItemDrop(处理采集物品丢弃);
  addPeriodicCallback(1000, on采集物品随机换点Tick);
}

初始化装备采集();

export {};
