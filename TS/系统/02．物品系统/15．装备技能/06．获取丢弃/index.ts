/** @noSelfInFile */

const 获取丢弃监听模块 = require("./01．获取丢弃监听") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
  单位当前是否持有指定物品: (this: void, unit: any, itemTypeId: number) => boolean;
};

export function 监听指定物品获取丢弃(this: void, itemTypeId: number, 获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void, 丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void): void {
  获取丢弃监听模块.监听指定物品获取丢弃(itemTypeId, 获取回调, 丢弃回调);
}

export const 获取单位当前持有指定物品数量 = 获取丢弃监听模块.获取单位当前持有指定物品数量;
export const 单位当前是否持有指定物品 = 获取丢弃监听模块.单位当前是否持有指定物品;
