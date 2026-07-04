/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};
const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};
export function 处理安恶之鞋造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.安恶之鞋)) return;
  if (ctx.applied < 取最大生命(ctx.target) * 0.05) return;
  const 冷却键 = 取装备冷却键(ctx.attacker, "安恶之鞋", "伤害事件装备");
  if (装备冷却中(冷却键)) return;
  if (!装备触发概率通过(0.5, ctx.attacker)) return;
  进入装备冷却并显示(冷却键, 10, ctx.attacker, "安恶之鞋");
  施加恐惧(ctx.attacker, ctx.target, { 持续时间: 1, 模式: "逃离施法者" });
}

export {};
