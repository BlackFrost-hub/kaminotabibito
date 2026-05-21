/** @noSelfInFile */
const jass = require("jass.common");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { 获取单位英雄Rawcode } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具");
const { 获取英雄升级配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表");
export function 应用提升等级学习技能(whichHero) {
    if (!whichHero || whichHero === 0)
        return;
    const level = jass.GetHeroLevel(whichHero) || 0;
    const heroRawcode = 获取单位英雄Rawcode(whichHero);
    const heroConfig = 获取英雄升级配置(heroRawcode);
    const rules = heroConfig?.learnedSkills;
    if (rules == null)
        return;
    for (let i = 0; i < rules.length; i++) {
        const rule = rules[i];
        if (rule.level !== level)
            continue;
        const abilityId = stringToFourCC(rule.abilityId);
        if (abilityId === 0)
            continue;
        if (jass.GetUnitAbilityLevel(whichHero, abilityId) <= 0) {
            jass.UnitAddAbility(whichHero, abilityId);
        }
        if (rule.targetLevel != null && rule.targetLevel > 0) {
            jass.SetUnitAbilityLevel(whichHero, abilityId, rule.targetLevel);
        }
    }
}
