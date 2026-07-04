/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取当前魔法, 取最大魔法, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const jass = require("jass.common") as any;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

type 斯尔法袍结算记录 = {
  目标: any;
  每跳扣魔: number;
  剩余次数: number;
};

const 斯尔法袍结算列表: 斯尔法袍结算记录[] = [];
let 已启动斯尔法袍驱动 = false;

function 结束斯尔法袍结算(this: void, 记录: 斯尔法袍结算记录, 索引: number): void {
  SetUnitState(记录.目标, UNIT_STATE_MANA, 1);
  斯尔法袍结算列表.splice(索引, 1);
}

function on斯尔法袍Tick(this: void): void {
  for (let i = 斯尔法袍结算列表.length - 1; i >= 0; i--) {
    const 记录 = 斯尔法袍结算列表[i];
    if (记录 == null || 记录.目标 == null || 记录.目标 === 0) {
      斯尔法袍结算列表.splice(i, 1);
      continue;
    }
    if (记录.剩余次数 <= 0) {
      结束斯尔法袍结算(记录, i);
      continue;
    }
    执行物品治疗(记录.目标, 记录.目标, 记录.每跳扣魔 * 1.2, "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl");
    const 当前魔法 = 取当前魔法(记录.目标);
    const 下次魔法 = 当前魔法 - 记录.每跳扣魔;
    SetUnitState(记录.目标, UNIT_STATE_MANA, 下次魔法 > 1 ? 下次魔法 : 1);
    记录.剩余次数--;
    if (记录.剩余次数 <= 0) {
      结束斯尔法袍结算(记录, i);
    }
  }
}

function 确保注册(this: void): void {
  if (已启动斯尔法袍驱动) return;
  已启动斯尔法袍驱动 = true;
  addPeriodicCallback(20, on斯尔法袍Tick);
}

export function 处理斯尔法袍伤害修正(this: void, context: any): number {
  const target = context.target;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.斯尔法袍)) return context.currentDamage;
  if (context.currentDamage < 取当前生命(target)) return context.currentDamage;
  if (取当前魔法(target) <= 取最大魔法(target) * 0.2) return context.currentDamage;
  const 冷却键 = 取装备冷却键(target, "斯尔法袍", "伤害事件装备");
  if (装备冷却中(冷却键)) return context.currentDamage;
  进入装备冷却(冷却键, 60);
  开始无敌帧(target, 0.5);
  确保注册();
  const 当前魔法 = 取当前魔法(target);
  const 每跳扣魔 = 当前魔法 * 0.04;
  斯尔法袍结算列表.push({
    目标: target,
    每跳扣魔,
    剩余次数: 25,
  });
  return 0;
}

export {};
