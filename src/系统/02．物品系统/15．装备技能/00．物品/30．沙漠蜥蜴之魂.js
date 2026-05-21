/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, 是指定伤害类型, 伤害事件伤害类型, 造成伤害事件伤害 } from "../04．伤害事件/00．公共/01．伤害事件工具";
const { 是否普通敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index");
const jass = require("jass.common");
const GetUnitLevel = jass.GetUnitLevel;
export function 处理沙漠蜥蜴之魂受伤(ctx) {
    if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.沙漠蜥蜴之魂))
        return;
    const 倍率 = 是指定伤害类型(ctx.snapshot, 伤害事件伤害类型.暗影突袭) ? 0.4 : 0.2;
    执行物品治疗(ctx.target, ctx.target, ctx.applied * 倍率, undefined);
}
/**
 * 威压效果：对等级低于25的普通敌人额外造成20%暗属性魔法伤害
 */
export function 处理沙漠蜥蜴之魂造成伤害(ctx) {
    if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.沙漠蜥蜴之魂))
        return;
    const 等级 = GetUnitLevel(ctx.target);
    if (等级 >= 25)
        return;
    if (!是否普通敌人(ctx.target))
        return;
    const 额外伤害 = ctx.applied * 0.2;
    造成伤害事件伤害(ctx.attacker, ctx.target, 额外伤害, 伤害事件伤害类型.暗影突袭);
}
