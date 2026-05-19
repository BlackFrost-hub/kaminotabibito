/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 施加易伤 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.02．易伤") as {
  施加易伤: (this: void, 来源单位: any, 目标单位: any, 参数: {
    持续时间: number;
    伤害增加百分比: number;
  }) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 指挥之剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 指挥之剑配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为指挥之剑(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  if (指挥之剑物品ID <= 0) return false;
  return GetItemTypeId(物品) === 指挥之剑物品ID;
}

export function 处理指挥之剑使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为指挥之剑(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (目标单位 == null || 目标单位 === 0) return;

  施加易伤(施法单位, 目标单位, {
    持续时间: 指挥之剑配置.持续时间,
    伤害增加百分比: 指挥之剑配置.易伤百分比,
  });
}

export {};
