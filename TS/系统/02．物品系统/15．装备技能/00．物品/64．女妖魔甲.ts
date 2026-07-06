/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 变更资源值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  变更资源值: (this: void, target: any, amount: number, resourceType: "life" | "mana", showText?: boolean, showEffect?: boolean, effectPath?: string, lowestValue?: number) => number;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位持有物品, 取当前生命, 取当前魔法, 取最大魔法 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const GetHandleId = jass.GetHandleId as (unit: any) => number;

type 女妖魔甲结算状态 = {
  单位: any;
  到期时间: number;
};

const 女妖魔甲待结算表: Record<number, 女妖魔甲结算状态 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 压低女妖魔甲资源(this: void, unit: any): void {
  const lifeReduce = 取当前生命(unit) - 1;
  if (lifeReduce > 0) 变更资源值(unit, -lifeReduce, "life", true, false, undefined, 1);
  const manaReduce = 取当前魔法(unit) - 1;
  if (manaReduce > 0) 变更资源值(unit, -manaReduce, "mana", true, false, undefined, 1);
}

function on女妖魔甲主动结束(this: void): void {
  const now = getServerTime();
  for (const key in 女妖魔甲待结算表) {
    const id = Number(key) || 0;
    const state = 女妖魔甲待结算表[id];
    if (state == null || now < state.到期时间) continue;
    delete 女妖魔甲待结算表[id];
    压低女妖魔甲资源(state.单位);
  }
}

export function 处理女妖魔甲使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.女妖魔甲)) return;
  const unit = ctx.施法单位;
  const cfg = 物品使用数值配置.女妖魔甲;
  施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "玩家属性", 属性名: "魔法伤害", 数值: cfg.魔法伤害提升 }]);
  registerManualBuff(unit, 常规BuffID.女妖魔甲_完全免疫, cfg.持续毫秒 / 1000, cfg.魔法伤害提升 * 100, {
    sourceName: "女妖魔甲",
  });
  const unitId = 取单位ID(unit);
  if (unitId === 0) return;
  女妖魔甲待结算表[unitId] = { 单位: unit, 到期时间: getServerTime() + cfg.持续毫秒 };
  addDelayedCallback(cfg.持续毫秒, on女妖魔甲主动结束);
}

export function 处理女妖魔甲伤害修正(this: void, context: any): number {
  const target = context.target;
  if (target == null || target === 0) return context.currentDamage;
  if (!单位持有物品(target, 物品使用装备ID.女妖魔甲)) return context.currentDamage;
  const maxMana = 取最大魔法(target);
  if (!(maxMana > 0)) return context.currentDamage;
  const threshold = maxMana * 物品使用数值配置.女妖魔甲.免疫最大魔法比例;
  return context.currentDamage < threshold ? 0 : context.currentDamage;
}

export {};
