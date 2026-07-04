/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加单目标周期效果, type 单目标周期效果事件 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制";
import { 装备冷却中, 进入装备冷却 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const 熔灵大剑全队冷却键 = "伤害事件装备:熔灵大剑全队";

function 熔灵大剑周期(this: void, event: 单目标周期效果事件): void {
  执行物品治疗(event.来源, event.来源, 0, "", event.数值, "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl");
}

export function 处理熔灵大剑造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (ctx.applied <= 10) return;
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.熔灵大剑)) return;
  if (装备冷却中(熔灵大剑全队冷却键)) return;
  进入装备冷却(熔灵大剑全队冷却键, 5);
  添加单目标周期效果({
    名称: "熔灵大剑",
    来源: ctx.attacker,
    目标: ctx.attacker,
    数值: ctx.applied * 0.05 * 0.2,
    持续毫秒: 5000,
    间隔毫秒: 1000,
    on周期: 熔灵大剑周期,
  });
}

export {};
