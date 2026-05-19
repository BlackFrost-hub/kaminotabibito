/** @noSelfInFile */

import { 史莱姆粘液配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 监听指定物品获取丢弃 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
};
const { 增加物品次数 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.05．物品次数转移") as {
  增加物品次数: (this: void, unit: any, itemTypeId: number, count: number, maxValue: number) => void;
};
const jass = require("jass.common") as any;
const RemoveItem = jass.RemoveItem as (item: any) => void;

function on史莱姆粘液获得(this: void, unit: any, item: any): void {
  if (获得物品装备ID.史莱姆粘液瓶 === 0) return;
  增加物品次数(unit, 获得物品装备ID.史莱姆粘液瓶, 史莱姆粘液配置.增加次数, 史莱姆粘液配置.最大次数);
  if (item != null && item !== 0) {
    RemoveItem(item);
  }
}

function 初始化史莱姆粘液(this: void): void {
  if (获得物品装备ID.史莱姆粘液 === 0) return;
  监听指定物品获取丢弃(获得物品装备ID.史莱姆粘液, on史莱姆粘液获得);
}

初始化史莱姆粘液();

export {};
