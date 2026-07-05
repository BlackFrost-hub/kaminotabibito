/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params?: any) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 先祖之狱杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 先祖之狱杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 延迟执行双单位动作 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

function 是否为先祖之狱杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 先祖之狱杖物品ID;
}

function 执行先祖延迟伤害(this: void, 施法单位: any, 目标单位: any): void {
  造成装备伤害(施法单位, 目标单位, GetUnitState(目标单位, UNIT_STATE_MAX_LIFE) * 先祖之狱杖配置.伤害生命比例, DAMAGE_TYPE_SHADOW_STRIKE, true, undefined, { 伤害形态: "单体" });
}

function 启动先祖延迟伤害(this: void, 施法单位: any, 目标单位: any): void {
  延迟执行双单位动作(施法单位, 目标单位, 先祖之狱杖配置.延迟伤害时间 * 1000, 执行先祖延迟伤害);
}

export function 处理先祖之狱杖使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("24．先祖之狱杖", "进入", "处理先祖之狱杖使用");

  if (!是否为先祖之狱杖(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  createTimedEffect(先祖之狱杖配置.特效路径, GetUnitX(目标单位), GetUnitY(目标单位), 0, 先祖之狱杖配置.特效持续时间);
  施加扩展控制(施法单位, 目标单位, "stun", { 持续时间: 先祖之狱杖配置.眩晕时间 });
  启动先祖延迟伤害(施法单位, 目标单位);
}

export {};
