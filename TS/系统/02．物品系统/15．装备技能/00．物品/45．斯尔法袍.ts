/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取当前魔法, 取最大魔法, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加周期效果, 注册周期效果处理, 取当前毫秒, 单位冷却中, 设置单位冷却, type 周期效果记录 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const jass = require("jass.common") as any;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

let 已注册 = false;

function 斯尔法袍周期(this: void, 记录: 周期效果记录): void {
  执行物品治疗(记录.目标, 记录.目标, 记录.数值 * 1.2, "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl");
}

function 确保注册(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册周期效果处理("斯尔法袍", 斯尔法袍周期);
}

export function 处理斯尔法袍伤害修正(this: void, context: any): number {
  const target = context.target;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.斯尔法袍)) return context.currentDamage;
  if (context.currentDamage < 取当前生命(target)) return context.currentDamage;
  if (取当前魔法(target) <= 取最大魔法(target) * 0.2) return context.currentDamage;
  const 冷却键 = "斯尔法袍:" + String(GetHandleId(target));
  if (单位冷却中(冷却键)) return context.currentDamage;
  设置单位冷却(冷却键, 60);
  开始无敌帧(target, 0.5);
  确保注册();
  const 当前魔法 = 取当前魔法(target);
  const 每跳扣魔 = 当前魔法 * 0.04;
  const 当前 = 取当前毫秒();
  添加周期效果({
    类型: "斯尔法袍",
    来源: target,
    目标: target,
    数值: 每跳扣魔,
    结束时间: 当前 + 500,
    下次时间: 当前 + 20,
    间隔毫秒: 20,
  });
  SetUnitState(target, UNIT_STATE_MANA, 1);
  return 0;
}

export {};
