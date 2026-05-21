/** @noSelfInFile */

const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 是玩家英雄组单位 } = require("./00．通用物品工具") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { 处理通用物品吃书清理 } = require("./01．吃书清理") as {
  处理通用物品吃书清理: (this: void, 单位: any, 物品: any) => void;
};
const { 处理通用物品获取特效 } = require("./02．获取特效") as {
  处理通用物品获取特效: (this: void, 单位: any, 物品: any) => void;
};
const { 处理通用物品合成打造 } = require("./03．合成打造") as {
  处理通用物品合成打造: (this: void, 单位: any, 物品: any) => void;
};
const { 处理通用物品领取技能 } = require("./04．领取技能") as {
  处理通用物品领取技能: (this: void, 单位: any, 物品: any) => void;
};
const { 处理万浴熔灵传送门 } = require("./01．传送集合") as {
  处理万浴熔灵传送门: (this: void, 单位: any, 物品: any) => void;
};

let 已初始化通用物品拾取 = false;

function on通用物品拾取(this: void, 单位: any, 物品: any): void {
  if (!是玩家英雄组单位(单位)) return;
  处理通用物品吃书清理(单位, 物品);
  处理通用物品获取特效(单位, 物品);
  处理通用物品合成打造(单位, 物品);
  处理万浴熔灵传送门(单位, 物品);
  处理通用物品领取技能(单位, 物品);
}

function 初始化通用物品(this: void): void {
  if (已初始化通用物品拾取) return;
  已初始化通用物品拾取 = true;
  onItemPickup(on通用物品拾取);
}

初始化通用物品();

export * from "./01．吃书清理";
export * from "./02．获取特效";
export * from "./03．合成打造";
export * from "./04．领取技能";
export * from "./01．传送集合";
