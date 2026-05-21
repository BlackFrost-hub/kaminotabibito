/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加周期效果, 注册周期效果处理, 取当前毫秒, 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";
let 已注册 = false;
function 熔灵大剑周期(记录) {
    执行物品治疗(记录.来源, 记录.来源, 0, "", 记录.数值, "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl");
}
function 确保注册() {
    if (已注册)
        return;
    已注册 = true;
    注册周期效果处理("熔灵大剑", 熔灵大剑周期);
}
export function 处理熔灵大剑造成伤害(ctx) {
    if (ctx.applied <= 10)
        return;
    if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.熔灵大剑))
        return;
    if (单位冷却中("熔灵大剑全队"))
        return;
    设置单位冷却("熔灵大剑全队", 5);
    确保注册();
    const 当前 = 取当前毫秒();
    添加周期效果({
        类型: "熔灵大剑",
        来源: ctx.attacker,
        目标: ctx.attacker,
        数值: ctx.applied * 0.05 * 0.2,
        结束时间: 当前 + 5000,
        下次时间: 当前 + 1000,
        间隔毫秒: 1000,
    });
}
