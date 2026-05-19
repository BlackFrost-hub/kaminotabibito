/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, 是指定伤害类型, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

export function 处理沙漠蜥蜴之魂受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.沙漠蜥蜴之魂)) return;
  const 倍率 = 是指定伤害类型(ctx.snapshot, 伤害事件伤害类型.暗影突袭) ? 0.4 : 0.2;
  执行物品治疗(ctx.target, ctx.target, ctx.applied * 倍率, undefined);
}

export {};

