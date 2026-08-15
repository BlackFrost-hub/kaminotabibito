/** @noSelfInFile */

import { 英雄技能成长配置表 } from "./00．配置表";

const jass = require("jass.common") as any;
const { registerSkillLearnListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSkillLearnListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { 调整玩家属性, 调整单位属性, 临时调整护甲 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
  调整单位属性: (this: void, unit: any, attrName: string, delta: number) => void;
  临时调整护甲: (this: void, 单位: any, 数值: number) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

let 已初始化 = false;
const 已处理技能等级: Record<string, number> = {};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetHeroInt = jass.GetHeroInt as (hero: any, includeBonuses: boolean) => number;
const SetHeroInt = jass.SetHeroInt as (hero: any, value: number, permanent: boolean) => void;

function 取技能处理键(this: void, unit: any, abilityId: number): string {
  return `${GetHandleId(unit)}#${abilityId}`;
}

function 应用成长属性(this: void, unit: any, attr: (typeof 英雄技能成长配置表)[number]["属性"][number], 等级增量: number, 是否首次: boolean): void {
  const amount = attr.每级增量 * 等级增量 + (是否首次 ? (attr.初始增量 ?? 0) : 0);
  if (amount === 0) return;

  switch (attr.处理方式 ?? "玩家属性") {
    case "英雄智力":
      SetHeroInt(unit, GetHeroInt(unit, false) + amount, true);
      return;
    case "来源治疗率":
      调整单位属性(unit, attr.属性名 || "治疗率", amount);
      return;
    case "护甲":
      临时调整护甲(unit, amount);
      return;
    case "单位属性":
      调整单位属性(unit, attr.属性名, amount);
      return;
    case "玩家属性":
    default:
      调整玩家属性(unit, attr.属性名, amount);
      return;
  }
}

function on英雄学习技能(this: void, unit: any, abilityId: number): void {
  if (unit == null || unit === 0) return;
  const heroId = jass.GetUnitTypeId(unit) as number;
  for (let i = 0; i < 英雄技能成长配置表.length; i++) {
    const config = 英雄技能成长配置表[i];
    if (heroId !== stringToFourCCSafe(config.英雄ID)) continue;
    if (abilityId !== stringToFourCCSafe(config.技能ID)) continue;
    const key = 取技能处理键(unit, abilityId);
    const currentLevel = GetUnitAbilityLevel(unit, abilityId);
    const previousLevel = 已处理技能等级[key] ?? 0;
    const levelDelta = currentLevel - previousLevel;
    if (levelDelta <= 0) return;
    const firstLearn = previousLevel === 0;
    for (let j = 0; j < config.属性.length; j++) {
      const attr = config.属性[j];
      应用成长属性(unit, attr, levelDelta, firstLearn);
    }
    已处理技能等级[key] = currentLevel;
  }
}

export function 初始化英雄技能成长系统(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerSkillLearnListener(on英雄学习技能);
}

初始化英雄技能成长系统();

export {};
