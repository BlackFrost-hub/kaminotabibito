/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 造成装备伤害, 播放单位特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;
const { 减少生命值, 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, 最低保留生命?: number) => number;
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 祭祀之杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 祭祀之杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为祭祀之杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 祭祀之杖物品ID;
}

export function 处理祭祀之杖使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("14．祭祀之杖", "进入", "处理祭祀之杖使用");

  if (!是否为祭祀之杖(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;
  const 目标单位 = 上下文.目标单位;
  if (目标单位 == null || 目标单位 === 0) return;

  减少魔法值(施法单位, 祭祀之杖配置.魔法消耗, true, false);
  减少生命值(施法单位, 祭祀之杖配置.生命消耗, true, true, 祭祀之杖配置.生命消耗特效路径, 1);
  创建单位绑定闪电({
    效果代码: 祭祀之杖配置.闪电代码,
    起点单位: 施法单位,
    终点单位: 目标单位,
    持续时间: 祭祀之杖配置.闪电持续时间,
  });
  播放单位特效(祭祀之杖配置.特效路径, 目标单位, "origin", 祭祀之杖配置.特效持续时间);
  造成装备伤害(施法单位, 目标单位, 祭祀之杖配置.伤害值, DAMAGE_TYPE_MAGIC, true, undefined, { 伤害形态: "单体" });
}

export {};
