/** @noSelfInFile */

const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 物品是否主武器, 同步单位主武器攻击类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型") as {
  物品是否主武器: (this: void, item: any) => boolean;
  同步单位主武器攻击类型: (this: void, unit: any) => boolean;
};
const { 创建延迟去重批处理队列 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.26．延迟去重批处理队列") as {
  创建延迟去重批处理队列: <T>(this: void, 名称: string, 选项: { 延迟毫秒: number; 处理: (this: void, 上下文: T, key: string) => void }) => {
    加入: (this: void, key: number | string, 上下文: T) => void;
  };
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
import { 取单位ID } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/09．装备战斗判断";

let 已注册主武器攻击类型监听 = false;

const 主武器攻击类型刷新队列 = 创建延迟去重批处理队列<any>("主武器攻击类型刷新", {
  延迟毫秒: 50,
  处理: function on刷新主武器攻击类型(this: void, unit: any): void {
    if (unit == null || unit === 0) return;
    if (!是玩家英雄组单位(unit)) return;
    同步单位主武器攻击类型(unit);
  },
});

function 排队刷新单位主武器攻击类型(this: void, unit: any): void {
  const unitId = 取单位ID(unit);
  if (unitId === 0) return;
  主武器攻击类型刷新队列.加入(unitId, unit);
}

function on主武器拾取(this: void, unit: any, item: any): void {
  if (!是玩家英雄组单位(unit)) return;
  if (!物品是否主武器(item)) return;
  排队刷新单位主武器攻击类型(unit);
}

function on主武器丢弃(this: void, unit: any, item: any): void {
  if (!是玩家英雄组单位(unit)) return;
  if (!物品是否主武器(item)) return;
  排队刷新单位主武器攻击类型(unit);
}

export function 初始化主武器攻击类型联动(this: void): void {
  if (已注册主武器攻击类型监听) return;
  已注册主武器攻击类型监听 = true;
  onItemPickup(on主武器拾取);
  onItemDrop(on主武器丢弃);
}

初始化主武器攻击类型联动();

export {};
