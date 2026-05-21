/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取单位护甲, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};

export function 处理史诗远古魔刃伤害触发(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.史诗远古魔刃)) return;
  if (ctx.snapshot != null && ctx.snapshot.isEnhancedDamage === true) return;
  const 暴击 = ctx.snapshot != null && ctx.snapshot.isNormalAttack === true && 装备触发概率通过(0.5, ctx.attacker);
  造成伤害事件伤害(ctx.attacker, ctx.target, 取单位护甲(ctx.target) * (暴击 ? 1.5 : 1), 伤害事件伤害类型.强化);
}

export {};
