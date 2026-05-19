/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 随机实数, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

export function 处理安恶之鞋造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.安恶之鞋)) return;
  if (ctx.applied < 取最大生命(ctx.target) * 0.05) return;
  const 冷却键 = "安恶之鞋:" + String(GetHandleId(ctx.attacker));
  if (单位冷却中(冷却键)) return;
  if (随机实数(0, 1) > 0.5) return;
  设置单位冷却(冷却键, 10);
  施加恐惧(ctx.attacker, ctx.target, { 持续时间: 1, 模式: "逃离施法者" });
}

export {};

