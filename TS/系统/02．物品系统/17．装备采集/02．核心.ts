/** @noSelfInFile */
/**
 * 装备采集 - 核心
 *
 * 功能：监听配置表中定义的采集物品，丢弃/拾取后在指定区域延迟刷新。
 * 扩展：只需在配置表追加条目，无需改核心逻辑。
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
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetRectMinX = jass.GetRectMinX as (this: void, whichRect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (this: void, whichRect: any) => number;
const GetRectMinY = jass.GetRectMinY as (this: void, whichRect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (this: void, whichRect: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;

function 取物品类型ID(this: void, 物品: any): number {
  if (物品 == null || 物品 === 0) return 0;
  return GetItemTypeId(物品);
}

let 采集配置索引表: Record<number, import("./00．公共/01．配置表").采集配置项> | null = null;

function 构建配置索引表(this: void): Record<number, import("./00．公共/01．配置表").采集配置项> {
  const 表: Record<number, import("./00．公共/01．配置表").采集配置项> = {};
  for (let i = 0; i < 采集配置列表.length; i++) {
    const 配置 = 采集配置列表[i];
    if (配置.物品ID !== 0) {
      表[配置.物品ID] = 配置;
    }
  }
  return 表;
}

function 取采集配置(this: void, 物品ID: number): import("./00．公共/01．配置表").采集配置项 | undefined {
  if (采集配置索引表 == null) {
    采集配置索引表 = 构建配置索引表();
  }
  return 采集配置索引表[物品ID];
}

function 获取区域rect(this: void, rect名: string): any {
  return 获取矩形区域(rect名);
}

function 在区域随机位置刷新采集物品(this: void, 物品ID: number, rect名: string): void {
  const rect = 获取区域rect(rect名);
  if (rect == null || rect === 0) return;

  const minX = GetRectMinX(rect);
  const maxX = GetRectMaxX(rect);
  const minY = GetRectMinY(rect);
  const maxY = GetRectMaxY(rect);

  const x = GetRandomReal(minX, maxX);
  const y = GetRandomReal(minY, maxY);
  创建物品并注册排泄监听(物品ID, x, y);
}

function 处理采集物品拾取(this: void, 单位: any, 物品: any): void {
  const 物品ID = 取物品类型ID(物品);
  const 配置 = 取采集配置(物品ID);
  if (配置 == null) return;
  addDelayedCallback(配置.刷新延迟秒 * 1000, () => 在区域随机位置刷新采集物品(物品ID, 配置.刷新区域名称));
}

function 处理采集物品丢弃(this: void, 单位: any, 物品: any): void {
  const 物品ID = 取物品类型ID(物品);
  const 配置 = 取采集配置(物品ID);
  if (配置 == null) return;
  addDelayedCallback(配置.刷新延迟秒 * 1000, () => 在区域随机位置刷新采集物品(物品ID, 配置.刷新区域名称));
}

export function 初始化装备采集(this: void): void {
  if (采集配置列表.length === 0) return;
  onItemPickup(处理采集物品拾取);
  onItemDrop(处理采集物品丢弃);
}

初始化装备采集();

export {};
