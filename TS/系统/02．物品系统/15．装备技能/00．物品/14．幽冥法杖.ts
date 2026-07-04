/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { getObjectPropertyRealSafe, ObjectType } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
  ObjectType: { UNIT: number };
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 幽冥法杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 幽冥法杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为幽冥法杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 幽冥法杖物品ID;
}

export function 处理幽冥法杖使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("15．幽冥法杖", "进入", "处理幽冥法杖使用");

  if (!是否为幽冥法杖(上下文.物品)) return;
  const 目标单位 = 上下文.目标单位;
  if (目标单位 == null || 目标单位 === 0) return;

  if (GetUnitState(目标单位, UNIT_STATE_MAX_LIFE) * 幽冥法杖配置.斩杀生命比例 < GetUnitState(目标单位, UNIT_STATE_LIFE)) return;
  KillUnit(目标单位);
  const 特效 = createUnitEffect(目标单位, 幽冥法杖配置.特效挂点, 幽冥法杖配置.特效路径, 幽冥法杖配置.特效持续时间, "幽冥法杖");
  if (特效 != null && 特效 !== 0) {
    EXSetEffectSize(特效, getObjectPropertyRealSafe(ObjectType.UNIT, GetUnitTypeId(目标单位), "modelScale"));
  }
}

export {};
