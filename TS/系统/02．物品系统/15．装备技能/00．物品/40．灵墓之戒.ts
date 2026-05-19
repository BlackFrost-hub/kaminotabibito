/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取当前魔法, 取最大魔法, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

export function 处理灵墓之戒造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.灵墓之戒)) return;
  const 冷却键 = "灵墓之戒:" + String(GetHandleId(ctx.attacker));
  if (单位冷却中(冷却键)) return;
  设置单位冷却(冷却键, 1);
  const 伤害 = (取最大魔法(ctx.attacker) - 取当前魔法(ctx.attacker)) * 0.2;
  造成伤害事件伤害(ctx.attacker, ctx.target, 伤害, 伤害事件伤害类型.暗影突袭);
  创建单位绑定闪电({
    效果代码: "LEAS",
    起点单位: ctx.target,
    终点单位: ctx.attacker,
    持续时间: 1,
    起点高度偏移: 60,
    终点高度偏移: 60,
  });
}

export {};

