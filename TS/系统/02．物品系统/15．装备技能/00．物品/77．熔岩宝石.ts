/** @noSelfInFile */

import { 熔岩宝石配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (this: void, itemTypeId: number, 获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void, 丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { 创建战斗状态触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.07．战斗状态触发器") as {
  创建战斗状态触发器: (this: void, 参数: {
    名称?: string;
    单位: any;
    主体类型?: "玩家英雄" | "Boss" | "普通单位";
    周期触发秒?: number;
    on周期触发?: (this: void, event: { 单位: any }) => void;
  }) => { 停止: (this: void) => void };
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 造成火焰伤害, 取最大生命, 播放点特效, 取单位X, 取单位Y, 单位存活 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  造成火焰伤害: (this: void, source: any, target: any, damage: number) => void;
  取最大生命: (this: void, unit: any) => number;
  播放点特效: (this: void, modelPath: string, x: number, y: number) => void;
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

const 熔岩宝石战斗状态表: Record<number, { 停止: (this: void) => void } | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function on熔岩宝石获得(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
  if (currentCount > 1 && previousCount > 0) {
    if (item != null && item !== 0) {
      RemoveItem(item);
    }
    DisplayTimedTextToPlayer(GetOwningPlayer(unit), 0, 0, 10, 熔岩宝石配置.重复佩戴提示);
  }
  if (currentCount > 0) 加入熔岩宝石战斗状态(unit);
}

function on熔岩宝石失去(this: void, unit: any, _item: any, currentCount: number, _previousCount: number): void {
  if (currentCount <= 0) 移除熔岩宝石战斗状态(unit);
}

function on熔岩宝石脉冲(this: void, unit: any, target: any): void {
  const damage = 熔岩宝石配置.固定火焰伤害 + 取最大生命(unit) * 熔岩宝石配置.最大生命火焰伤害比例;
  造成火焰伤害(unit, target, damage);
  播放点特效(熔岩宝石配置.特效路径, 取单位X(target), 取单位Y(target));
}

function on熔岩宝石战斗周期(this: void, event: { 单位: any }): void {
  const unit = event.单位;
  const currentCount = 获取单位当前持有指定物品数量(unit, 获得物品装备ID.熔岩宝石);
  if (currentCount <= 0) return;
  if (!单位存活(unit)) return;
  const targets = getUnitsInRange(取单位X(unit), 取单位Y(unit), 熔岩宝石配置.作用范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (target == null || target === 0 || target === unit) continue;
    if (!单位存活(target)) continue;
    on熔岩宝石脉冲(unit, target);
  }
}

function 加入熔岩宝石战斗状态(this: void, unit: any): void {
  const unitId = 取单位ID(unit);
  if (unitId === 0 || 熔岩宝石战斗状态表[unitId] != null) return;
  熔岩宝石战斗状态表[unitId] = 创建战斗状态触发器({
    名称: "熔岩宝石",
    单位: unit,
    主体类型: "玩家英雄",
    周期触发秒: 熔岩宝石配置.间隔毫秒 / 1000,
    on周期触发: on熔岩宝石战斗周期,
  });
}

function 移除熔岩宝石战斗状态(this: void, unit: any): void {
  const unitId = 取单位ID(unit);
  if (unitId === 0) return;
  const 控制器 = 熔岩宝石战斗状态表[unitId];
  if (控制器 != null) {
    控制器.停止();
    delete 熔岩宝石战斗状态表[unitId];
  }
}

function 初始化熔岩宝石(this: void): void {
  if (获得物品装备ID.熔岩宝石 === 0) return;
  监听指定物品获取丢弃(获得物品装备ID.熔岩宝石, on熔岩宝石获得, on熔岩宝石失去);
}

初始化熔岩宝石();

export {};
