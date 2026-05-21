/** @noSelfInFile */
export * from "./00．类型定义";
export * from "./01．升级配置表";
export * from "./02．升级额外属性";
export * from "./03．英雄领悟技能";
export * from "./04．提升等级学习技能";
const heroLevelEventCenter = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心");
const { 应用升级额外属性 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.02．升级额外属性");
const { 应用英雄领悟技能 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.03．英雄领悟技能");
const { 应用提升等级学习技能 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.04．提升等级学习技能");
let 已初始化 = false;
function on英雄升级(whichHero) {
    if (!whichHero || whichHero === 0)
        return;
    应用升级额外属性(whichHero);
    应用英雄领悟技能(whichHero);
    应用提升等级学习技能(whichHero);
}
export function init() {
    if (已初始化)
        return;
    已初始化 = true;
    heroLevelEventCenter.registerHeroLevelListener(on英雄升级);
}
init();
