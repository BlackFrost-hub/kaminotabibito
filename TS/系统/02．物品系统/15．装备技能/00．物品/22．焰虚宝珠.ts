/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { 清除单位负面Buff合集 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  清除单位负面Buff合集: (this: void, unit: any) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx as (unit: any, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 焰虚宝珠物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 焰虚宝珠配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为焰虚宝珠(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 焰虚宝珠物品ID;
}

export function 处理焰虚宝珠使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("23．焰虚宝珠", "进入", "处理焰虚宝珠使用");

  if (!是否为焰虚宝珠(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 特效 = createUnitEffect(施法单位, 焰虚宝珠配置.特效挂点, 焰虚宝珠配置.特效路径, 焰虚宝珠配置.特效持续时间, "焰虚宝珠");
  if (特效 != null && 特效 !== 0) {
    EXSetEffectSize(特效, 焰虚宝珠配置.特效大小);
  }
  UnitRemoveBuffsEx(目标单位, false, true, false, false, false, false, true);
  清除单位负面Buff合集(目标单位);
}

export {};
