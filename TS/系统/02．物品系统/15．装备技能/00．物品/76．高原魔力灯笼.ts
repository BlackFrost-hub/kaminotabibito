/** @noSelfInFile */

import { 高原魔力灯笼配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 是否白天 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态") as {
  是否白天: (this: void) => boolean;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 获取范围友军, 取单位X, 取单位Y, 取最大生命, 执行治疗, 调整玩家属性 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  获取范围友军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  取最大生命: (this: void, unit: any) => number;
  执行治疗: (this: void, source: any, target: any, heal: number, mana?: number) => void;
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

type 高原魔力灯笼状态 = {
  当前伤害减少层数: number;
};

const 高原魔力灯笼状态表: Record<number, 高原魔力灯笼状态 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取或创建高原魔力灯笼状态(this: void, unit: any): 高原魔力灯笼状态 {
  const id = 取单位ID(unit);
  const state = 高原魔力灯笼状态表[id];
  if (state != null) return state;
  const nextState: 高原魔力灯笼状态 = { 当前伤害减少层数: 0 };
  高原魔力灯笼状态表[id] = nextState;
  return nextState;
}

function 同步夜晚减伤(this: void, unit: any, currentCount: number): void {
  const state = 取或创建高原魔力灯笼状态(unit);
  const nextCount = 是否白天() ? 0 : currentCount;
  if (state.当前伤害减少层数 === nextCount) return;
  if (state.当前伤害减少层数 > 0) {
    调整玩家属性(unit, "伤害减少%", -高原魔力灯笼配置.夜晚伤害减少增加 * state.当前伤害减少层数);
  }
  if (nextCount > 0) {
    调整玩家属性(unit, "伤害减少%", 高原魔力灯笼配置.夜晚伤害减少增加 * nextCount);
  }
  state.当前伤害减少层数 = nextCount;
}

function 清理高原魔力灯笼状态(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  const state = 高原魔力灯笼状态表[id];
  if (state != null && state.当前伤害减少层数 > 0) {
    调整玩家属性(unit, "伤害减少%", -高原魔力灯笼配置.夜晚伤害减少增加 * state.当前伤害减少层数);
  }
  delete 高原魔力灯笼状态表[id];
}

function on高原魔力灯笼周期(this: void, unit: any, currentCount: number): void {
  const manaCost = GetUnitState(unit, UNIT_STATE_MAX_MANA) * 高原魔力灯笼配置.最大魔法消耗比例 * currentCount;
  减少魔法值(unit, manaCost, true, false);
  同步夜晚减伤(unit, currentCount);
  if (!是否白天()) return;
  const allies = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), 高原魔力灯笼配置.白天治疗半径);
  for (let i = 0; i < allies.length; i++) {
    const ally = allies[i];
    执行治疗(unit, ally, 取最大生命(ally) * 高原魔力灯笼配置.白天治疗最大生命比例, 0);
  }
}

function on高原魔力灯笼丢弃(this: void, unit: any): void {
  清理高原魔力灯笼状态(unit);
}

function 初始化高原魔力灯笼(this: void): void {
  if (获得物品装备ID.高原魔力灯笼 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.高原魔力灯笼,
    间隔毫秒: 高原魔力灯笼配置.间隔毫秒,
    周期回调: on高原魔力灯笼周期,
    丢弃回调: on高原魔力灯笼丢弃,
  });
}

初始化高原魔力灯笼();

export {};
