/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const { 开始纯跳链 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.纯跳链系统") as {
  开始纯跳链: (this: void, 参数: any) => any;
};
const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

function 触发雷锤跳链(this: void, ctx: 伤害事件上下文, 伤害值: number): void {
  const 冷却键 = "雷锤权杖:" + String(GetHandleId(ctx.attacker));
  if (单位冷却中(冷却键)) return;
  if (!装备触发概率通过(0.8, ctx.attacker)) return;
  设置单位冷却(冷却键, 2);
  开始纯跳链({
    起始目标: ctx.target,
    来源单位: ctx.attacker,
    模式: "伤害",
    影响目标: "敌方",
    最大跳数: 5,
    每跳最大距离: 600,
    初始数值: 伤害值,
    每跳衰减系数: 1,
    闪电效果代码: "CLPB",
    闪电持续时间: 1.0,
  });
}

export function 处理魔力雷锤造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.魔力雷锤)) return;
  if (ctx.snapshot == null || ctx.snapshot.isMagicDamage !== true) return;
  触发雷锤跳链(ctx, 100);
}

export {};
