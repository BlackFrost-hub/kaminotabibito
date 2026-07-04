/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 创建延迟批处理队列 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.25．延迟批处理队列") as {
  创建延迟批处理队列: <T>(this: void, 名称: string, 选项: { 延迟毫秒: number; 处理: (this: void, 上下文: T) => void }) => {
    加入: (this: void, 上下文: T) => void;
  };
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

const 合成打造延迟删除队列 = 创建延迟批处理队列<any>("通用物品合成打造延迟删除", {
  延迟毫秒: 通用物品配置.合成打造延迟毫秒,
  处理: function on合成打造延迟删除(this: void, 物品: any): void {
    删除物品(物品);
  },
});

export function 处理通用物品合成打造(this: void, _单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.合成打造列表.length <= 0) return;
  const 物品类型ID = GetItemTypeId(物品);
  if (!物品类型ID在列表中(物品类型ID, 通用物品ID.合成打造列表)) return;

  const 物品句柄ID = 取物品句柄ID(物品);
  if (物品句柄ID <= 0) return;
  合成打造延迟删除队列.加入(物品);
}

export {};
