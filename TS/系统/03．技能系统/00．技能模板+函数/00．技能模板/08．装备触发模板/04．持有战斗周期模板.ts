/** @noSelfInFile */

import { 创建单位战斗状态托管器 } from "../../04．机制组件/09．装备通用机制/19．单位战斗状态托管";

const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};

export interface 持有战斗周期事件 {
  单位: any;
  持有数量: number;
}

export interface 持有战斗周期获取事件 extends 持有战斗周期事件 {
  物品: any;
  前次数量: number;
}

export interface 持有战斗周期参数 {
  名称: string;
  物品类型ID: number;
  周期秒: number;
  主体类型?: "玩家英雄" | "Boss" | "普通单位";
  on获取?: (this: void, event: 持有战斗周期获取事件) => void;
  on丢弃?: (this: void, event: 持有战斗周期获取事件) => void;
  on周期: (this: void, event: 持有战斗周期事件) => void;
}

export interface 持有战斗周期控制器 {
  加入(this: void, unit: any): void;
  移除(this: void, unit: any): void;
}

export function 注册持有战斗周期模板(this: void, 参数: 持有战斗周期参数): 持有战斗周期控制器 | null {
  if (参数 == null || 参数.物品类型ID === 0 || 参数.周期秒 <= 0 || 参数.on周期 == null) return null;

  const 战斗状态 = 创建单位战斗状态托管器({
    名称: 参数.名称,
    主体类型: 参数.主体类型 ?? "玩家英雄",
    周期触发秒: 参数.周期秒,
    on周期触发: function on持有战斗周期触发(this: void, event): void {
      const unit = event.单位;
      const count = 获取单位当前持有指定物品数量(unit, 参数.物品类型ID);
      if (count <= 0) {
        战斗状态.移除(unit);
        return;
      }
      参数.on周期({ 单位: unit, 持有数量: count });
    },
  });

  function on获取(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
    if (currentCount > 0) 战斗状态.加入(unit);
    参数.on获取?.({ 单位: unit, 物品: item, 持有数量: currentCount, 前次数量: previousCount });
  }

  function on丢弃(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
    if (currentCount <= 0) 战斗状态.移除(unit);
    参数.on丢弃?.({ 单位: unit, 物品: item, 持有数量: currentCount, 前次数量: previousCount });
  }

  监听指定物品获取丢弃(参数.物品类型ID, on获取, on丢弃);
  return {
    加入: 战斗状态.加入,
    移除: 战斗状态.移除,
  };
}

export {};

