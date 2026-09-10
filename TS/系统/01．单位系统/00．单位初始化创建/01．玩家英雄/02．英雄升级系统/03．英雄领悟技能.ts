/** @noSelfInFile */

const jass = require("jass.common") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { 获取单位英雄Rawcode } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位英雄Rawcode: (this: void, unit: any) => string;
};
const { YDWEGetUnitAbilityDataString } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};
const { 获取英雄升级配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表") as {
  获取英雄升级配置: (this: void, heroRawcode: string) => import("./00．类型定义").英雄升级配置 | null;
};

function 显示领悟提示(this: void, whichHero: any, abilityId: number): void {
  const owner = jass.GetOwningPlayer(whichHero);
  if (!owner || owner === 0) return;

  const heroName = jass.GetUnitName(whichHero) as string;
  const abilityName = YDWEGetUnitAbilityDataString(whichHero, abilityId, 1, 215) || "未知技能";
  jass.DisplayTimedTextToPlayer(
    owner,
    0,
    0,
    20,
    "|cffffff00【系统提示】：|r|cffffffcc【" + heroName + "】|r领悟了技能|cffff99cc【" + abilityName + "】|r"
  );
}

export function 应用英雄领悟技能(this: void, whichHero: any): void {
  if (!whichHero || whichHero === 0) return;

  const level = (jass.GetHeroLevel(whichHero) as number) || 0;
  const heroRawcode = 获取单位英雄Rawcode(whichHero);
  const heroConfig = 获取英雄升级配置(heroRawcode);
  const rules = heroConfig?.awakeningSkills;
  if (rules == null) return;

  for (let i = 0; i < rules.length; i++) {
    const rule = rules[i];
    if (rule.level !== level) continue;

    const abilityId = stringToFourCC(rule.abilityId);
    if (abilityId === 0) continue;
    if ((jass.GetUnitAbilityLevel(whichHero, abilityId) as number) > 0) continue;

    jass.UnitAddAbility(whichHero, abilityId);
    显示领悟提示(whichHero, abilityId);
  }
}

export {};
