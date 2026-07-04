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
const { 创建线性扫掠命中 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.03．路径技能模板.index") as {
  创建线性扫掠命中: (this: void, 参数: any) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 史诗远古魔刃物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 史诗远古魔刃配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为史诗远古魔刃(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 史诗远古魔刃物品ID;
}

export function 处理史诗远古魔刃使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("22．史诗远古魔刃", "进入", "处理史诗远古魔刃使用");

  if (!是否为史诗远古魔刃(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 起点X = GetUnitX(施法单位);
  const 起点Y = GetUnitY(施法单位);
  创建线性扫掠命中({
    施法单位,
    起点X,
    起点Y,
    方向弧度: Atan2(上下文.目标Y - 起点Y, 上下文.目标X - 起点X),
    周期秒: 史诗远古魔刃配置.周期,
    最大次数: 史诗远古魔刃配置.最大次数,
    每次距离: 史诗远古魔刃配置.每次距离,
    作用范围: 史诗远古魔刃配置.作用范围,
    on步进: (扫掠上下文: any) => {
      createTimedEffect(史诗远古魔刃配置.特效路径, 扫掠上下文.当前X, 扫掠上下文.当前Y, 0, 史诗远古魔刃配置.特效持续时间);
    },
    on命中: (敌人: any, 扫掠上下文: any) => {
      const 伤害值 = GetUnitState(扫掠上下文.施法单位, ConvertUnitState(0x15)) * 史诗远古魔刃配置.力量系数;
      造成装备伤害(扫掠上下文.施法单位, 敌人, 伤害值, DAMAGE_TYPE_NORMAL);
      施加扩展控制(扫掠上下文.施法单位, 敌人, "stun", { 持续时间: 史诗远古魔刃配置.眩晕时间 });
    },
  });
}

export {};
