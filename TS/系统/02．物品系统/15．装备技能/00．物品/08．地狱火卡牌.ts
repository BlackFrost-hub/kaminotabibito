/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { 施加地狱火卡牌持续恢复 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．地狱火卡牌") as {
  施加地狱火卡牌持续恢复: (this: void, source: any, target: any, 参数: {
    BuffID: string;
    图标路径: string;
    特效路径: string;
    特效挂点: string;
    特效键: string;
    持续时间: number;
    间隔: number;
    每跳生命恢复: number;
  }) => void;
};

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 地狱火卡牌物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 地狱火卡牌配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为地狱火卡牌(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 地狱火卡牌物品ID;
}

function 计算每跳生命恢复(this: void, 单位: any): number {
  return GetUnitState(单位, UNIT_STATE_MAX_LIFE) * 地狱火卡牌配置.生命恢复百分比 + 地狱火卡牌配置.固定生命恢复;
}

export function 处理地狱火卡牌使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("09．地狱火卡牌", "进入", "处理地狱火卡牌使用");

  if (!是否为地狱火卡牌(上下文.物品)) return;

  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  施加地狱火卡牌持续恢复(施法单位, 施法单位, {
    BuffID: 地狱火卡牌配置.BuffID,
    图标路径: 地狱火卡牌配置.图标路径,
    特效路径: 地狱火卡牌配置.特效路径,
    特效挂点: 地狱火卡牌配置.特效挂点,
    特效键: 地狱火卡牌配置.特效键,
    持续时间: 地狱火卡牌配置.持续时间,
    间隔: 地狱火卡牌配置.间隔,
    每跳生命恢复: 计算每跳生命恢复(施法单位),
  });
}

export {};
