/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 添加周期效果, 注册周期效果处理, 取当前毫秒 } from "../04．伤害事件/00．公共/02．伤害事件状态";
let 已注册 = false;
function 湖之龙枪周期(记录) {
    造成伤害事件伤害(记录.来源, 记录.目标, 记录.数值, 伤害事件伤害类型.冰冷);
}
function 确保注册() {
    if (已注册)
        return;
    已注册 = true;
    注册周期效果处理("湖之龙枪", 湖之龙枪周期);
}
export function 处理湖之龙枪造成伤害(ctx) {
    if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.湖之龙枪))
        return;
    if (ctx.snapshot != null && ctx.snapshot.rawDamageType === 伤害事件伤害类型.冰冷)
        return;
    确保注册();
    const 当前 = 取当前毫秒();
    添加周期效果({
        类型: "湖之龙枪",
        来源: ctx.attacker,
        目标: ctx.target,
        数值: ctx.applied * 0.02,
        结束时间: 当前 + 5000,
        下次时间: 当前 + 1000,
        间隔毫秒: 1000,
    });
}
