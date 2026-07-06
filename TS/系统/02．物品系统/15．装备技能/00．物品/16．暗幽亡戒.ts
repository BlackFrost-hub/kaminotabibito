/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const { 减少魔法值, 增加魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
  增加魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 暗幽亡戒物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 暗幽亡戒配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为暗幽亡戒(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 暗幽亡戒物品ID;
}

export function 处理暗幽亡戒使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("17．暗幽亡戒", "进入", "处理暗幽亡戒使用");

  if (!是否为暗幽亡戒(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 转移值 = GetUnitState(施法单位, UNIT_STATE_MANA) * 暗幽亡戒配置.魔法转移比例;
  const 实际转移值 = -减少魔法值(施法单位, 转移值, true, false);
  if (!(实际转移值 > 0)) return;
  增加魔法值(目标单位, 实际转移值, true, false);
  createUnitEffect(目标单位, 暗幽亡戒配置.特效挂点, 暗幽亡戒配置.特效路径, 暗幽亡戒配置.特效持续时间, "暗幽亡戒");
}

export {};
