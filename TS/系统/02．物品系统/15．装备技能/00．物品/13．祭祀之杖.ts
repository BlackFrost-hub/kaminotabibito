/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

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
  SetUnitState(施法单位, UNIT_STATE_LIFE, GetUnitState(施法单位, UNIT_STATE_LIFE) - 祭祀之杖配置.生命消耗);
}

export {};
