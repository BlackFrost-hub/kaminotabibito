/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前生命, 取当前魔法, 取最大魔法, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 启动计数周期执行 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/10．周期执行模板";

const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const jass = require("jass.common") as any;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

type 斯尔法袍结算记录 = {
  目标: any;
  每跳扣魔: number;
};

function 结束斯尔法袍结算(this: void, 记录: 斯尔法袍结算记录): void {
  if (记录.目标 == null || 记录.目标 === 0) return;
  SetUnitState(记录.目标, UNIT_STATE_MANA, 1);
}

function on斯尔法袍Tick(this: void, 记录: 斯尔法袍结算记录): boolean | void {
  if (记录 == null || 记录.目标 == null || 记录.目标 === 0) return false;
  执行物品治疗(记录.目标, 记录.目标, 记录.每跳扣魔 * 1.2, "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl");
  const 当前魔法 = 取当前魔法(记录.目标);
  const 下次魔法 = 当前魔法 - 记录.每跳扣魔;
  SetUnitState(记录.目标, UNIT_STATE_MANA, 下次魔法 > 1 ? 下次魔法 : 1);
}

export function 处理斯尔法袍伤害修正(this: void, context: any): number {
  const target = context.target;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.斯尔法袍)) return context.currentDamage;
  if (context.currentDamage < 取当前生命(target)) return context.currentDamage;
  if (取当前魔法(target) <= 取最大魔法(target) * 0.2) return context.currentDamage;
  const 冷却键 = 取装备冷却键(target, "斯尔法袍", "伤害事件装备");
  if (装备冷却中(冷却键)) return context.currentDamage;
  进入装备冷却并显示(冷却键, 60, target, "斯尔法袍");
  开始无敌帧(target, 0.5);
  const 当前魔法 = 取当前魔法(target);
  const 每跳扣魔 = 当前魔法 * 0.04;
  const 记录: 斯尔法袍结算记录 = {
    目标: target,
    每跳扣魔,
  };
  启动计数周期执行({
    间隔毫秒: 20,
    最大次数: 25,
    on周期: function on斯尔法袍周期执行(this: void): boolean | void {
      return on斯尔法袍Tick(记录);
    },
    on完成: function on斯尔法袍周期完成(this: void): void {
      结束斯尔法袍结算(记录);
    },
  });
  return 0;
}

export {};
