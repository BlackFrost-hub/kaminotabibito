/** @noSelfInFile */
const { 注册物品技能事件监听 } = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心");
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调");
const jass = require("jass.common");
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
const 狱妖魔盾 = require("系统.02．物品系统.15．装备技能.00．物品.49．狱妖魔盾");
const 商人之书 = require("系统.02．物品系统.15．装备技能.00．物品.50．商人之书");
const 狂暴树枝 = require("系统.02．物品系统.15．装备技能.00．物品.51．狂暴树枝");
const 首领号角 = require("系统.02．物品系统.15．装备技能.00．物品.52．首领号角");
const 精灵号角 = require("系统.02．物品系统.15．装备技能.00．物品.53．精灵号角");
const 守卫大剑 = require("系统.02．物品系统.15．装备技能.00．物品.54．守卫大剑");
const 斯尔能量之心 = require("系统.02．物品系统.15．装备技能.00．物品.55．斯尔能量之心");
const 熔岩地狱之敲钟 = require("系统.02．物品系统.15．装备技能.00．物品.56．熔岩地狱之敲钟");
const 阴暗之敲钟 = require("系统.02．物品系统.15．装备技能.00．物品.57．阴暗之敲钟");
const 地狱火卡牌攻击 = require("系统.02．物品系统.15．装备技能.00．物品.58．地狱火卡牌攻击");
const 焰混能量体 = require("系统.02．物品系统.15．装备技能.00．物品.59．焰混能量体");
const 恶斯胸甲 = require("系统.02．物品系统.15．装备技能.00．物品.60．恶斯胸甲");
const 亡灵魔鞋 = require("系统.02．物品系统.15．装备技能.00．物品.61．亡灵魔鞋");
const 恶魔铃铛 = require("系统.02．物品系统.15．装备技能.00．物品.62．恶魔铃铛");
const 魔古战刃 = require("系统.02．物品系统.15．装备技能.00．物品.63．魔古战刃");
const 女妖魔甲 = require("系统.02．物品系统.15．装备技能.00．物品.64．女妖魔甲");
const 熔灵宝石之戒 = require("系统.02．物品系统.15．装备技能.00．物品.65．熔灵宝石之戒");
const 浴血药剂 = require("系统.02．物品系统.15．装备技能.00．物品.66．浴血药剂");
const 浴魔药剂 = require("系统.02．物品系统.15．装备技能.00．物品.67．浴魔药剂");
const 浴灵药剂 = require("系统.02．物品系统.15．装备技能.00．物品.68．浴灵药剂");
const 嗜狱恶剑 = require("系统.02．物品系统.15．装备技能.00．物品.69．嗜狱恶剑");
const 盗贼神符魔抗 = require("系统.02．物品系统.15．装备技能.00．物品.70．盗贼神符魔抗");
const 火把 = require("系统.02．物品系统.15．装备技能.00．物品.71．火把");
const 抗毒药水 = require("系统.02．物品系统.15．装备技能.00．物品.114．抗毒药水");
let 已初始化 = false;
function 物品使用单位是英雄(ctx) {
    const unit = ctx.施法单位;
    return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}
function on物品使用链路(ctx) {
    if (!物品使用单位是英雄(ctx))
        return;
    狱妖魔盾.处理狱妖魔盾使用(ctx);
    商人之书.处理商人之书使用(ctx);
    狂暴树枝.处理狂暴树枝使用(ctx);
    首领号角.处理首领号角使用(ctx);
    精灵号角.处理精灵号角使用(ctx);
    守卫大剑.处理守卫大剑使用(ctx);
    斯尔能量之心.处理斯尔能量之心使用(ctx);
    熔岩地狱之敲钟.处理熔岩地狱之敲钟使用(ctx);
    阴暗之敲钟.处理阴暗之敲钟使用(ctx);
    地狱火卡牌攻击.处理地狱火卡牌攻击使用(ctx);
    焰混能量体.处理焰混能量体使用(ctx);
    恶斯胸甲.处理恶斯胸甲使用(ctx);
    亡灵魔鞋.处理亡灵魔鞋使用(ctx);
    恶魔铃铛.处理恶魔铃铛使用(ctx);
    魔古战刃.处理魔古战刃使用(ctx);
    女妖魔甲.处理女妖魔甲使用(ctx);
    熔灵宝石之戒.处理熔灵宝石之戒使用(ctx);
    浴血药剂.处理浴血药剂使用(ctx);
    浴魔药剂.处理浴魔药剂使用(ctx);
    浴灵药剂.处理浴灵药剂使用(ctx);
    嗜狱恶剑.处理嗜狱恶剑使用(ctx);
    盗贼神符魔抗.处理盗贼神符魔抗使用(ctx);
    火把.处理火把使用(ctx);
    抗毒药水.处理抗毒药水使用(ctx);
}
function on物品使用死亡事件(dyingUnit, killingUnit) {
    斯尔能量之心.处理斯尔能量之心击杀(dyingUnit, killingUnit);
}
function on物品使用最终伤害(target, attacker, applied, snapshot) {
    if (!(applied >= 1))
        return;
    if (snapshot != null && snapshot.isTrueDamage === true)
        return;
    焰混能量体.处理焰混能量体伤害(target, attacker, applied, snapshot);
    魔古战刃.处理魔古战刃伤害(target, attacker, applied, snapshot);
}
function on物品使用伤害修正(context) {
    if (!(context.currentDamage >= 1))
        return context.currentDamage;
    if (context.isTrueDamage === true)
        return context.currentDamage;
    return 恶斯胸甲.处理恶斯胸甲伤害修正(context);
}
export function 初始化装备物品使用链() {
    if (已初始化)
        return;
    已初始化 = true;
    狱妖魔盾.初始化狱妖魔盾持有充能();
    注册物品技能事件监听(on物品使用链路);
    registerDeathListener(on物品使用死亡事件);
    registerAppliedFinalDamageListener(on物品使用最终伤害);
    registerDamageModifier(on物品使用伤害修正, 30);
}
初始化装备物品使用链();
