/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";
export function 处理毒囊道具造成伤害(ctx) {
    if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.毒囊道具))
        return;
    if (ctx.snapshot == null || ctx.snapshot.isNormalAttack === true || ctx.snapshot.isEnhancedDamage === true)
        return;
    if (ctx.applied < 取最大生命(ctx.target) * 0.01 + 100)
        return;
    造成伤害事件伤害(ctx.attacker, ctx.target, ctx.applied * 0.2, 伤害事件伤害类型.毒素);
}
