/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加单目标周期效果, type 单目标周期效果事件 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制";

function 湖之龙枪周期(this: void, event: 单目标周期效果事件): void {
  造成伤害事件伤害(event.来源, event.目标, event.数值, 伤害事件伤害类型.冰冷);
}

export function 处理湖之龙枪造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.湖之龙枪)) return;
  if (ctx.snapshot != null && ctx.snapshot.rawDamageType === 伤害事件伤害类型.冰冷) return;
  添加单目标周期效果({
    名称: "湖之龙枪",
    来源: ctx.attacker,
    目标: ctx.target,
    数值: ctx.applied * 0.02,
    持续毫秒: 5000,
    间隔毫秒: 1000,
    on周期: 湖之龙枪周期,
  });
}

export {};

