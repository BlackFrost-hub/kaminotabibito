/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 通用物品ID, 通用物品配置 } = require("./00．通用物品配置") as {
  通用物品ID: {
    合成打造列表: number[];
  };
  通用物品配置: {
    合成打造延迟毫秒: number;
  };
};
const { 删除物品, 物品类型ID在列表中, 取物品句柄ID } = require("./00．通用物品工具") as {
  删除物品: (this: void, 物品: any) => void;
  物品类型ID在列表中: (this: void, 物品类型ID: number, 列表: readonly number[]) => boolean;
  取物品句柄ID: (this: void, 物品: any) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;

const 延迟删除物品队列: any[] = [];

function on合成打造延迟删除(this: void): void {
  const 物品 = 延迟删除物品队列.shift();
  删除物品(物品);
}

export function 处理通用物品合成打造(this: void, _单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.合成打造列表.length <= 0) return;
  const 物品类型ID = GetItemTypeId(物品);
  if (!物品类型ID在列表中(物品类型ID, 通用物品ID.合成打造列表)) return;

  const 物品句柄ID = 取物品句柄ID(物品);
  if (物品句柄ID <= 0) return;
  延迟删除物品队列.push(物品);
  addDelayedCallback(通用物品配置.合成打造延迟毫秒, on合成打造延迟删除);
}

export {};
