/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 随机实数 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";
const { 开始纯跳链 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.纯跳链系统");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
export function 处理闪电权杖造成伤害(ctx) {
    if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.闪电权杖))
        return;
    if (ctx.snapshot == null || ctx.snapshot.isMagicDamage !== true)
        return;
    const 冷却键 = "雷锤权杖:" + String(GetHandleId(ctx.attacker));
    if (单位冷却中(冷却键))
        return;
    if (随机实数(0, 1) < 0.2)
        return;
    设置单位冷却(冷却键, 2);
    开始纯跳链({
        起始目标: ctx.target,
        来源单位: ctx.attacker,
        模式: "伤害",
        影响目标: "敌方",
        最大跳数: 5,
        每跳最大距离: 600,
        初始数值: 400,
        每跳衰减系数: 1,
        闪电效果代码: "CLPB",
        闪电持续时间: 1.0,
    });
}
