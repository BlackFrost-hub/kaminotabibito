/** @noSelfInFile */

import { 熔岩宝石配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    获取回调?: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 监听指定物品获取丢弃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (this: void, itemTypeId: number, 获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void, 丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void) => void;
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
const RemoveItem = jass.RemoveItem as (item: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

function on熔岩宝石获得(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
  if (currentCount <= 1 || previousCount <= 0) return;
  if (item != null && item !== 0) {
    RemoveItem(item);
  }
  DisplayTimedTextToPlayer(GetOwningPlayer(unit), 0, 0, 10, 熔岩宝石配置.重复佩戴提示);
}

function on熔岩宝石脉冲(this: void, unit: any, target: any): void {
  const damage = 熔岩宝石配置.固定火焰伤害 + 取最大生命(unit) * 熔岩宝石配置.最大生命火焰伤害比例;
  造成火焰伤害(unit, target, damage);
  播放点特效(熔岩宝石配置.特效路径, 取单位X(target), 取单位Y(target));
}

function on熔岩宝石周期(this: void, unit: any, currentCount: number): void {
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

function 初始化熔岩宝石(this: void): void {
  if (获得物品装备ID.熔岩宝石 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.熔岩宝石,
    间隔毫秒: 熔岩宝石配置.间隔毫秒,
    周期回调: on熔岩宝石周期,
  });
  监听指定物品获取丢弃(获得物品装备ID.熔岩宝石, on熔岩宝石获得);
}

初始化熔岩宝石();

export {};
