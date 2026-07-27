/** @noSelfInFile */

import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { 施加持续恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法") as {
  施加持续恢复生命魔法: (this: void, source: any, target: any, 参数: {
    BuffID: string;
    图标路径: string;
    特效路径: string;
    特效挂点: string;
    特效键: string;
    持续时间: number;
    间隔: number;
    每跳生命恢复: number;
    每跳魔法恢复: number;
    效果来源名称?: string;
    效果来源类型?: "装备" | "技能";
  }) => void;
};

import { 地狱火卡牌物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 地狱火卡牌配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为地狱火卡牌(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return jass.GetItemTypeId(物品) === 地狱火卡牌物品ID;
}

function 计算每跳生命恢复(this: void, 单位: any): number {
  return GetUnitState(单位, UNIT_STATE_MAX_LIFE) * 地狱火卡牌配置.生命恢复百分比 + 地狱火卡牌配置.固定生命恢复;
}

function 计算每跳魔法恢复(this: void, 单位: any): number {
  return 计算每跳生命恢复(单位) * 地狱火卡牌配置.魔法恢复比例;
}

export function 处理地狱火卡牌施法(this: void, 施法单位: any): void {
  主动物品调试日志("地狱火卡牌", "处理施法入口", "施法单位:", 施法单位);
  if (施法单位 == null || 施法单位 === 0) {
    主动物品调试日志("地狱火卡牌", "提前返回: 施法单位为空");
    return;
  }
  const 每跳生命恢复 = 计算每跳生命恢复(施法单位);
  const 每跳魔法恢复 = 计算每跳魔法恢复(施法单位);
  主动物品调试日志("地狱火卡牌", "计算恢复值", "每跳生命恢复:", 每跳生命恢复, "每跳魔法恢复:", 每跳魔法恢复);
  施加持续恢复生命魔法(施法单位, 施法单位, {
    BuffID: 地狱火卡牌配置.BuffID,
    图标路径: 地狱火卡牌配置.图标路径,
    特效路径: 地狱火卡牌配置.特效路径,
    特效挂点: 地狱火卡牌配置.特效挂点,
    特效键: 地狱火卡牌配置.特效键,
    持续时间: 地狱火卡牌配置.持续时间,
    间隔: 地狱火卡牌配置.间隔,
    每跳生命恢复: 每跳生命恢复,
    每跳魔法恢复: 每跳魔法恢复,
    效果来源名称: "地狱火卡牌",
    效果来源类型: "装备",
  });
  主动物品调试日志("地狱火卡牌", "施加恢复完成");
}

export function 处理地狱火卡牌使用(this: void, 上下文: any): void {
  主动物品调试日志("地狱火卡牌", "使用入口", "物品:", 上下文.物品, "施法单位:", 上下文.施法单位);
  if (!是否为地狱火卡牌(上下文.物品)) {
    主动物品调试日志("地狱火卡牌", "提前返回: 不是地狱火卡牌");
    return;
  }
  主动物品调试日志("地狱火卡牌", "确认为地狱火卡牌，准备施法");
  处理地狱火卡牌施法(上下文.施法单位);
}

export {};
