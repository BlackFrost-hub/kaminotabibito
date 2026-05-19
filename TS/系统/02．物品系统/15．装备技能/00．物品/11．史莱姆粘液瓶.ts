/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff") as {
  快速减速Buff: (this: void, source: any, target: any, attackSpeedReduction: number, moveSpeedReduction: number, duration: number) => void;
};
const { 增加物品次数 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.05．物品次数转移") as {
  增加物品次数: (this: void, unit: any, itemTypeId: number, count: number, maxValue: number) => void;
};
const { 监听指定物品获取丢弃 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    onGain?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    onLose?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
};

const jass = require("jass.common") as any;

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const RemoveItem = jass.RemoveItem as (item: any) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 史莱姆粘液瓶物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 史莱姆粘液瓶配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 获得物品装备ID, 史莱姆粘液配置 } from "../07．获得物品/00．公共/00．获得物品配置表";

function 是否为史莱姆粘液瓶(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 史莱姆粘液瓶物品ID;
}

function on获得史莱姆粘液(this: void, unit: any, item: any): void {
  if (获得物品装备ID.史莱姆粘液瓶 === 0) return;
  增加物品次数(unit, 获得物品装备ID.史莱姆粘液瓶, 史莱姆粘液配置.增加次数, 史莱姆粘液配置.最大次数);
  if (item != null && item !== 0) {
    RemoveItem(item);
  }
}

function 初始化史莱姆粘液拾取效果(this: void): void {
  if (获得物品装备ID.史莱姆粘液 === 0) return;
  监听指定物品获取丢弃(获得物品装备ID.史莱姆粘液, on获得史莱姆粘液);
}

export function 处理史莱姆粘液瓶使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("12．史莱姆粘液瓶", "进入", "处理史莱姆粘液瓶使用");

  if (!是否为史莱姆粘液瓶(上下文.物品)) return;
  if (上下文.目标单位 == null || 上下文.目标单位 === 0) return;
  快速减速Buff(
    上下文.施法单位,
    上下文.目标单位,
    史莱姆粘液瓶配置.攻速减幅,
    史莱姆粘液瓶配置.移速减幅,
    史莱姆粘液瓶配置.持续时间,
  );
}

初始化史莱姆粘液拾取效果();

export {};
