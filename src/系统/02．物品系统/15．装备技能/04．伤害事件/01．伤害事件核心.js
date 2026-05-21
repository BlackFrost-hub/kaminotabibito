/** @noSelfInFile */
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { 施加易伤 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.02．易伤");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const 豺狼皮甲 = require("系统.02．物品系统.15．装备技能.00．物品.27．豺狼皮甲");
const 灵石 = require("系统.02．物品系统.15．装备技能.00．物品.28．灵石");
const 傀岩杖 = require("系统.02．物品系统.15．装备技能.00．物品.29．傀岩杖");
const 沙漠蜥蜴之魂 = require("系统.02．物品系统.15．装备技能.00．物品.30．沙漠蜥蜴之魂");
const 湖之袍 = require("系统.02．物品系统.15．装备技能.00．物品.31．湖之袍");
const 龙虾硬甲 = require("系统.02．物品系统.15．装备技能.00．物品.32．龙虾硬甲");
const 湖之龙枪 = require("系统.02．物品系统.15．装备技能.00．物品.33．湖之龙枪");
const 银魔手套 = require("系统.02．物品系统.15．装备技能.00．物品.34．银魔手套");
const 异雷法袍 = require("系统.02．物品系统.15．装备技能.00．物品.35．异雷法袍");
const 毒囊道具 = require("系统.02．物品系统.15．装备技能.00．物品.36．毒囊道具");
const 地狱火卡牌魔法 = require("系统.02．物品系统.15．装备技能.00．物品.37．地狱火卡牌魔法");
const 熔灵大剑 = require("系统.02．物品系统.15．装备技能.00．物品.38．熔灵大剑");
const 安恶之鞋 = require("系统.02．物品系统.15．装备技能.00．物品.39．安恶之鞋");
const 灵墓之戒 = require("系统.02．物品系统.15．装备技能.00．物品.40．灵墓之戒");
const 瑞冥戒指 = require("系统.02．物品系统.15．装备技能.00．物品.41．瑞冥戒指");
const 史诗远古魔刃 = require("系统.02．物品系统.15．装备技能.00．物品.42．史诗远古魔刃伤害");
const 魔力雷锤 = require("系统.02．物品系统.15．装备技能.00．物品.43．魔力雷锤");
const 闪电权杖 = require("系统.02．物品系统.15．装备技能.00．物品.44．闪电权杖");
const 斯尔法袍 = require("系统.02．物品系统.15．装备技能.00．物品.45．斯尔法袍");
const 锋利巨魔爪 = require("系统.02．物品系统.15．装备技能.00．物品.46．锋利巨魔爪");
const 巨魔战剑 = require("系统.02．物品系统.15．装备技能.00．物品.47．巨魔战剑");
const 精粹法刺 = require("系统.02．物品系统.15．装备技能.00．物品.48．精粹法刺");
const 嗜狱恶剑 = require("系统.02．物品系统.15．装备技能.00．物品.69．嗜狱恶剑");
const 精沙战斧 = require("系统.02．物品系统.15．装备技能.00．物品.83．精沙战斧");
import { 伤害事件伤害类型, 是指定伤害类型, 取当前生命 } from "./00．公共/01．伤害事件工具";
const B00H指挥BuffID = stringToFourCCSafe("B00H");
const B00V暗黑侵蚀BuffID = stringToFourCCSafe("B00V");
const 暗黑侵蚀复活单位ID = stringToFourCCSafe("e00D");
const 暗黑侵蚀复活技能ID = stringToFourCCSafe("A0AB");
let 已初始化 = false;
const 暗黑侵蚀复活队列 = [];
const jass = require("jass.common");
const CreateUnit = jass.CreateUnit;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel;
const UnitAddAbility = jass.UnitAddAbility;
const IssueImmediateOrder = jass.IssueImmediateOrder;
function 单位拥有Buff(unit, buffId) {
    if (unit == null || unit === 0)
        return false;
    if (!(buffId > 0))
        return false;
    return GetUnitAbilityLevel(unit, buffId) > 0;
}
function 处理指挥易伤(ctx) {
    if (B00H指挥BuffID === 0)
        return;
    if (ctx.attacker == null || ctx.attacker === 0 || ctx.target == null || ctx.target === 0)
        return;
    if (!单位拥有Buff(ctx.attacker, B00H指挥BuffID))
        return;
    施加易伤(ctx.attacker, ctx.target, { 持续时间: 5, 伤害增加百分比: 0.15 });
}
function 执行暗黑侵蚀复活() {
    while (暗黑侵蚀复活队列.length > 0) {
        const 记录 = 暗黑侵蚀复活队列.shift();
        if (记录 == null || 记录.来源 == null || 记录.目标 == null)
            continue;
        if (暗黑侵蚀复活单位ID === 0 || 暗黑侵蚀复活技能ID === 0)
            continue;
        const 马甲 = CreateUnit(GetOwningPlayer(记录.来源), 暗黑侵蚀复活单位ID, GetUnitX(记录.目标), GetUnitY(记录.目标), 0);
        if (马甲 == null || 马甲 === 0)
            continue;
        UnitAddAbility(马甲, 暗黑侵蚀复活技能ID);
        IssueImmediateOrder(马甲, "animatedead");
    }
}
function 安排暗黑侵蚀复活(来源, 目标) {
    暗黑侵蚀复活队列.push({ 来源, 目标 });
    addDelayedCallback(1200, 执行暗黑侵蚀复活);
}
function 处理最终伤害(target, attacker, applied, snapshot) {
    if (!(applied >= 1))
        return;
    if (是指定伤害类型(snapshot, 伤害事件伤害类型.精神))
        return;
    const ctx = { target, attacker, applied, snapshot };
    豺狼皮甲.处理豺狼皮甲受伤(ctx);
    灵石.处理灵石受伤(ctx);
    傀岩杖.处理傀岩杖受伤(ctx);
    沙漠蜥蜴之魂.处理沙漠蜥蜴之魂受伤(ctx);
    湖之袍.处理湖之袍受伤(ctx);
    龙虾硬甲.处理龙虾硬甲受伤(ctx);
    异雷法袍.处理异雷法袍受伤(ctx);
    湖之龙枪.处理湖之龙枪造成伤害(ctx);
    银魔手套.处理银魔手套造成伤害(ctx);
    毒囊道具.处理毒囊道具造成伤害(ctx);
    地狱火卡牌魔法.处理地狱火卡牌魔法造成伤害(ctx);
    熔灵大剑.处理熔灵大剑造成伤害(ctx);
    安恶之鞋.处理安恶之鞋造成伤害(ctx);
    灵墓之戒.处理灵墓之戒造成伤害(ctx);
    瑞冥戒指.处理瑞冥戒指造成伤害(ctx);
    史诗远古魔刃.处理史诗远古魔刃伤害触发(ctx);
    魔力雷锤.处理魔力雷锤造成伤害(ctx);
    闪电权杖.处理闪电权杖造成伤害(ctx);
    锋利巨魔爪.处理锋利巨魔爪物理触发(ctx);
    巨魔战剑.处理巨魔战剑强化触发(ctx);
    精粹法刺.处理精粹法刺魔法触发(ctx);
    沙漠蜥蜴之魂.处理沙漠蜥蜴之魂造成伤害(ctx);
    嗜狱恶剑.处理嗜狱恶剑造成伤害?.(ctx);
    处理指挥易伤(ctx);
}
function 伤害事件修正(context) {
    if (!(context.currentDamage >= 1))
        return context.currentDamage;
    if (context.isTrueDamage === true)
        return context.currentDamage;
    let 结果 = 斯尔法袍.处理斯尔法袍伤害修正(context);
    结果 = 嗜狱恶剑.处理嗜狱恶剑伤害修正?.(context) ?? 结果;
    结果 = 精沙战斧.处理精沙战斧伤害修正?.(context) ?? 结果;
    if (B00V暗黑侵蚀BuffID !== 0 && context.target != null && 单位拥有Buff(context.target, B00V暗黑侵蚀BuffID)) {
        if (context.currentDamage >= 结果 && 结果 >= 取当前生命(context.target)) {
            安排暗黑侵蚀复活(context.attacker, context.target);
        }
    }
    return 结果;
}
export function init装备伤害事件() {
    if (已初始化)
        return;
    已初始化 = true;
    registerAppliedFinalDamageListener(处理最终伤害);
    registerDamageModifier(伤害事件修正, 40);
}
init装备伤害事件();
