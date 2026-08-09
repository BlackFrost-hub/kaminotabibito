/** @noSelfInFile */

const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 是玩家英雄或BB } = require("./00．通用物品工具") as {
  是玩家英雄或BB: (this: void, 单位: any) => boolean;
};
const { 处理通用物品吃书清理 } = require("./01．吃书清理") as {
  处理通用物品吃书清理: (this: void, 单位: any, 物品: any) => void;
};
const { 处理通用物品获取特效 } = require("./02．获取特效") as {
  处理通用物品获取特效: (this: void, 单位: any, 物品: any) => void;
};
const { 处理通用物品合成打造, 处理一次性打造壳合成, 是一次性打造壳 } = require("./03．合成打造") as {
  处理通用物品合成打造: (this: void, 单位: any, 物品: any) => void;
  处理一次性打造壳合成: (this: void, 单位: any, 物品类型ID: number) => void;
  是一次性打造壳: (this: void, 物品: any) => boolean;
};
const { 处理通用物品领取技能 } = require("./04．领取技能") as {
  处理通用物品领取技能: (this: void, 单位: any, 物品: any) => void;
};
const { 处理万浴熔灵传送门 } = require("./01．传送集合") as {
  处理万浴熔灵传送门: (this: void, 单位: any, 物品: any) => void;
};

let 已初始化通用物品拾取 = false;
const 打造壳背包稳定等待毫秒 = 400;
const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (this: void, 物品: any) => number;

interface 延迟打造壳上下文 {
  单位: any;
  物品类型ID: number;
}

function on通用物品拾取(this: void, 单位: any, 物品: any): void {
  if (!是玩家英雄或BB(单位)) return;
  处理通用物品吃书清理(单位, 物品);
  处理通用物品获取特效(单位, 物品);
  处理通用物品合成打造(单位, 物品);
  处理万浴熔灵传送门(单位, 物品);
  处理通用物品领取技能(单位, 物品);
}

function 执行延迟打造壳合成(this: void, 上下文?: 延迟打造壳上下文): void {
  if (上下文 == null) return;
  处理一次性打造壳合成(上下文.单位, 上下文.物品类型ID);
}

function on一次性打造壳丢弃(this: void, 单位: any, 物品: any): void {
  if (!是玩家英雄或BB(单位) || !是一次性打造壳(物品)) return;
  const 上下文: 延迟打造壳上下文 = { 单位, 物品类型ID: GetItemTypeId(物品) };
  addDelayedCallback(打造壳背包稳定等待毫秒, 执行延迟打造壳合成, 上下文);
}

function 初始化通用物品(this: void): void {
  if (已初始化通用物品拾取) return;
  已初始化通用物品拾取 = true;
  onItemPickup(on通用物品拾取);
  onItemDrop(on一次性打造壳丢弃);
}

初始化通用物品();

export * from "./01．吃书清理";
export * from "./02．获取特效";
export * from "./03．合成打造";
export * from "./04．领取技能";
export * from "./01．传送集合";
