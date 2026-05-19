/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取最大生命, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 获得物品装备ID, 豺狼皮甲配置 } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 调整玩家属性 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
};

type 豺狼皮甲状态 = {
  当前模式: "生命恢复" | "伤害减少%" | null;
  当前层数: number;
};

const 豺狼皮甲状态表: Record<number, 豺狼皮甲状态 | undefined> = {};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取或创建豺狼皮甲状态(this: void, unit: any): 豺狼皮甲状态 {
  const id = 取单位ID(unit);
  const state = 豺狼皮甲状态表[id];
  if (state != null) return state;
  const nextState: 豺狼皮甲状态 = { 当前模式: null, 当前层数: 0 };
  豺狼皮甲状态表[id] = nextState;
  return nextState;
}

function 移除旧模式属性(this: void, unit: any, state: 豺狼皮甲状态): void {
  if (state.当前层数 <= 0 || state.当前模式 == null) return;
  if (state.当前模式 === "生命恢复") {
    调整玩家属性(unit, "生命恢复", -豺狼皮甲配置.生命恢复增加 * state.当前层数);
  } else {
    调整玩家属性(unit, "伤害减少%", -豺狼皮甲配置.伤害减少增加 * state.当前层数);
  }
}

function 应用新模式属性(this: void, unit: any, state: 豺狼皮甲状态, mode: "生命恢复" | "伤害减少%", count: number): void {
  if (count <= 0) {
    state.当前模式 = null;
    state.当前层数 = 0;
    return;
  }
  if (mode === "生命恢复") {
    调整玩家属性(unit, "生命恢复", 豺狼皮甲配置.生命恢复增加 * count);
  } else {
    调整玩家属性(unit, "伤害减少%", 豺狼皮甲配置.伤害减少增加 * count);
  }
  state.当前模式 = mode;
  state.当前层数 = count;
}

function 同步豺狼皮甲状态(this: void, unit: any, currentCount: number): void {
  const state = 取或创建豺狼皮甲状态(unit);
  const shouldUseRegen = 取当前生命(unit) >= 取最大生命(unit) * 豺狼皮甲配置.高生命阈值;
  const nextMode: "生命恢复" | "伤害减少%" = shouldUseRegen ? "生命恢复" : "伤害减少%";
  if (state.当前模式 === nextMode && state.当前层数 === currentCount) return;
  移除旧模式属性(unit, state);
  应用新模式属性(unit, state, nextMode, currentCount);
}

function 清理豺狼皮甲状态(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  const state = 豺狼皮甲状态表[id];
  if (state != null) {
    移除旧模式属性(unit, state);
  }
  delete 豺狼皮甲状态表[id];
}

function on豺狼皮甲周期(this: void, unit: any, currentCount: number): void {
  if (currentCount <= 0) {
    清理豺狼皮甲状态(unit);
    return;
  }
  同步豺狼皮甲状态(unit, currentCount);
}

function on豺狼皮甲丢弃(this: void, unit: any): void {
  清理豺狼皮甲状态(unit);
}

function 初始化豺狼皮甲持有效果(this: void): void {
  if (获得物品装备ID.豺狼皮甲 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.豺狼皮甲,
    间隔毫秒: 豺狼皮甲配置.检查间隔毫秒,
    周期回调: on豺狼皮甲周期,
    丢弃回调: on豺狼皮甲丢弃,
  });
}

export function 处理豺狼皮甲受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.豺狼皮甲)) return;
  if (取当前生命(ctx.target) >= 取最大生命(ctx.target) * 0.7) return;
  执行物品治疗(ctx.target, ctx.target, ctx.applied * 0.1, undefined);
}

初始化豺狼皮甲持有效果();

export {};
