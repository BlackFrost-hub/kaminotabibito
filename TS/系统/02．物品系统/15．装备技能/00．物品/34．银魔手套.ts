/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 执行物品治疗, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加周期效果, 注册周期效果处理, 取当前毫秒, type 周期效果记录 } from "../04．伤害事件/00．公共/02．伤害事件状态";

let 已注册 = false;

function 银魔手套周期(this: void, 记录: 周期效果记录): void {
  造成伤害事件伤害(记录.来源, 记录.目标, 记录.数值, 伤害事件伤害类型.暗影突袭);
  执行物品治疗(记录.来源, 记录.来源, 记录.数值, undefined);
}

function 确保注册(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册周期效果处理("银魔手套", 银魔手套周期);
}

export function 处理银魔手套造成伤害(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.银魔手套)) return;
  if (ctx.snapshot != null && ctx.snapshot.rawDamageType === 伤害事件伤害类型.暗影突袭) return;
  确保注册();
  const 当前 = 取当前毫秒();
  添加周期效果({
    类型: "银魔手套",
    来源: ctx.attacker,
    目标: ctx.target,
    数值: 20,
    结束时间: 当前 + 3000,
    下次时间: 当前 + 1000,
    间隔毫秒: 1000,
  });
}

export {};

