/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 造成装备伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 远古毒咒护符物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 远古毒咒护符配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为远古毒咒护符(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 远古毒咒护符物品ID;
}

export function 处理远古毒咒护符使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("11．远古毒咒护符", "进入", "处理远古毒咒护符使用");

  if (!是否为远古毒咒护符(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const x = GetUnitX(施法单位);
  const y = GetUnitY(施法单位);
  createTimedEffect(远古毒咒护符配置.特效路径, x, y, 0, 远古毒咒护符配置.特效持续时间);

  const 伤害值 = GetUnitState(施法单位, ConvertUnitState(0x15)) * 远古毒咒护符配置.力量系数;
  const 敌人列表 = 获取坐标范围敌人(施法单位, x, y, 远古毒咒护符配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 施法单位)) continue;
    造成装备伤害(施法单位, 敌人, 伤害值, DAMAGE_TYPE_POISON);
  }
}

export {};
