/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, 是指定伤害类型, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";
export function 处理湖之袍受伤(ctx) {
    if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.湖之袍))
        return;
    const 倍率 = 是指定伤害类型(ctx.snapshot, 伤害事件伤害类型.冰冷) ? 0.25 : 0.1;
    执行物品治疗(ctx.target, ctx.target, ctx.applied * 倍率, undefined);
}
