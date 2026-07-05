/** @noSelfInFile */
/**
 * 冲锋路径区域结算模板
 *
 * 用于“先冲锋到终点，再沿起点 -> 终点的路径区域统一结算一次伤害”的技能。
 * 不修改击退系统底层，只通过开始/结束回调做组合。
 */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
};

const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 获取条形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域") as {
  获取条形区域单位: (this: void, 参数: {
    起点X: number;
    起点Y: number;
    终点X: number;
    终点Y: number;
    宽度: number;
    单位筛选?: (this: void, 单位: any) => boolean;
    包含边界?: boolean;
  }) => any[];
};

const { 获取胶囊区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域") as {
  获取胶囊区域单位: (this: void, 参数: {
    起点X: number;
    起点Y: number;
    终点X: number;
    终点Y: number;
    宽度: number;
    单位筛选?: (this: void, 单位: any) => boolean;
    包含边界?: boolean;
  }) => any[];
};

import type { 冲锋参数, 位移结束原因 } from "./击退系统";

export interface 冲锋路径区域结算参数 {
  宽度: number;
  伤害值: number;
  区域形状?: "条形" | "胶囊";
  影响目标?: "敌方" | "友方" | "全部";
  允许命中自己?: boolean;
  包含边界?: boolean;
  仅完成时结算?: boolean;
  伤害来源?: any;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  来源类型?: "单位技能" | "Boss技能" | "召唤物技能" | "其他";
  技能ID?: number;
  技能实例ID?: number;
  技能标签?: string;
  参与技能伤害加成?: boolean;
  单位筛选?: (this: void, 移动单位: any, 目标单位: any, 位移ID: number, 原因: 位移结束原因) => boolean;
  命中回调?: (this: void, 移动单位: any, 目标单位: any, 位移ID: number, 原因: 位移结束原因) => void;
}

interface 路径结算上下文 {
  单位: any;
  起点X: number;
  起点Y: number;
  位移参数原结束回调?: (this: void, 单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any) => void;
  结算参数: 冲锋路径区域结算参数;
}

const 路径结算上下文表: Record<number, 路径结算上下文 | undefined> = {};

function 释放路径结算上下文(位移ID: number): 路径结算上下文 | undefined {
  const 上下文 = 路径结算上下文表[位移ID];
  delete 路径结算上下文表[位移ID];
  return 上下文;
}

function 执行位移原结束回调(
  回调: (this: void, 单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any) => void,
  单位: any,
  原因: 位移结束原因,
  位移ID: number,
  命中目标?: any
): void {
  回调(单位, 原因, 位移ID, 命中目标);
}

function 是否通过路径区域目标筛选(
  上下文: 路径结算上下文,
  目标单位: any,
  位移ID: number,
  原因: 位移结束原因
): boolean {
  if (目标单位 == null || 目标单位 === 0) {
    return false;
  }

  const 结算参数 = 上下文.结算参数;
  const 移动单位 = 上下文.单位;

  if (!结算参数.允许命中自己 && 目标单位 === 移动单位) {
    return false;
  }

  const 影响目标 = 结算参数.影响目标 ?? "敌方";
  if (影响目标 === "敌方" && !isUnitEnemy(目标单位, 移动单位)) {
    return false;
  }
  if (影响目标 === "友方" && !isUnitAlly(目标单位, 移动单位)) {
    return false;
  }

  const 单位筛选 = 结算参数.单位筛选;
  if (单位筛选 != null && !单位筛选(移动单位, 目标单位, 位移ID, 原因)) {
    return false;
  }

  return true;
}

function 结算路径区域伤害(
  上下文: 路径结算上下文,
  位移ID: number,
  原因: 位移结束原因
): void {
  const 结算参数 = 上下文.结算参数;
  if (结算参数.宽度 <= 0 || 结算参数.伤害值 <= 0) {
    return;
  }
  if ((结算参数.仅完成时结算 ?? true) && 原因 !== "完成") {
    return;
  }

  const 终点X = GetUnitX(上下文.单位);
  const 终点Y = GetUnitY(上下文.单位);
  const 区域形状 = 结算参数.区域形状 ?? "条形";

  const 单位列表 = 区域形状 === "胶囊"
    ? 获取胶囊区域单位({
      起点X: 上下文.起点X,
      起点Y: 上下文.起点Y,
      终点X,
      终点Y,
      宽度: 结算参数.宽度,
      包含边界: 结算参数.包含边界 ?? true,
    })
    : 获取条形区域单位({
      起点X: 上下文.起点X,
      起点Y: 上下文.起点Y,
      终点X,
      终点Y,
      宽度: 结算参数.宽度,
      包含边界: 结算参数.包含边界 ?? true,
    });

  const 伤害来源 = 结算参数.伤害来源 ?? 上下文.单位;
  const 攻击类型 = 结算参数.攻击类型 ?? ATTACK_TYPE_NORMAL;
  const 伤害类型 = 结算参数.伤害类型 ?? DAMAGE_TYPE_NORMAL;
  const 武器类型 = 结算参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS;

  for (const 目标单位 of 单位列表) {
    if (!是否通过路径区域目标筛选(上下文, 目标单位, 位移ID, 原因)) {
      continue;
    }

    造成AOE技能伤害({
      来源: 伤害来源,
      目标: 目标单位,
      伤害: 结算参数.伤害值,
      伤害类型,
      ranged: false,
      attackType: 攻击类型,
      weaponType: 武器类型,
      来源类型: 结算参数.来源类型 ?? "单位技能",
      技能ID: 结算参数.技能ID,
      技能实例ID: 结算参数.技能实例ID,
      标签: 结算参数.技能标签,
      参与技能伤害加成: 结算参数.参与技能伤害加成,
    });

    结算参数.命中回调?.(上下文.单位, 目标单位, 位移ID, 原因);
  }
}

function 冲锋路径区域结束回调(单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any): void {
  const 上下文 = 释放路径结算上下文(位移ID);
  if (!上下文) {
    return;
  }

  结算路径区域伤害(上下文, 位移ID, 原因);
  const 原结束回调 = 上下文.位移参数原结束回调;
  if (原结束回调 != null) {
    执行位移原结束回调(原结束回调, 单位, 原因, 位移ID, 命中目标);
  }
}

export function 开始冲锋并在结束时结算路径区域(
  单位: any,
  位移参数: 冲锋参数,
  结算参数: 冲锋路径区域结算参数
): number {
  const 起点X = GetUnitX(单位);
  const 起点Y = GetUnitY(单位);

  const 合并参数: 冲锋参数 = {
    ...位移参数,
    结束回调: 冲锋路径区域结束回调,
  };

  const 位移ID = 开始冲锋(单位, 合并参数);
  if (位移ID <= 0) {
    return 0;
  }

  路径结算上下文表[位移ID] = {
    单位,
    起点X,
    起点Y,
    位移参数原结束回调: 位移参数.结束回调,
    结算参数,
  };

  return 位移ID;
}

export {};
