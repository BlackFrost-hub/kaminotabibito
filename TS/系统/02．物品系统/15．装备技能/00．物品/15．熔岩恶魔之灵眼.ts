/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 熔岩恶魔之灵眼物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 熔岩恶魔之灵眼配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 命中率字段 = "命中率";

function 是否为熔岩恶魔之灵眼(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 熔岩恶魔之灵眼物品ID;
}

export function 处理熔岩恶魔之灵眼使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("16．熔岩恶魔之灵眼", "进入", "处理熔岩恶魔之灵眼使用");

  if (!是否为熔岩恶魔之灵眼(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.魔力之焰闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
  创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.死亡之指闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
  减少魔法值(施法单位, GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.魔法消耗比例, true, false);
  createUnitEffect(目标单位, 熔岩恶魔之灵眼配置.特效挂点, 熔岩恶魔之灵眼配置.特效路径, 熔岩恶魔之灵眼配置.特效持续时间, "熔岩恶魔之灵眼");
  施加临时属性效果(目标单位, 熔岩恶魔之灵眼配置.命中率恢复延迟 * 1000, [{ 类型: "单位属性", 属性名: 命中率字段, 数值: -熔岩恶魔之灵眼配置.命中率削减 }]);
  造成装备伤害(施法单位, 目标单位, GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.伤害魔法系数, DAMAGE_TYPE_SHADOW_STRIKE, true, undefined, { 伤害形态: "单体" });
}

export {};
