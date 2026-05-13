/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 获取单位英雄Rawcode } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位英雄Rawcode: (this: void, unit: any) => string;
};

const { 通用升级额外属性配置, 获取英雄升级配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表") as {
  通用升级额外属性配置: readonly import("./00．类型定义").升级额外属性配置[];
  获取英雄升级配置: (this: void, heroRawcode: string) => import("./00．类型定义").英雄升级配置 | null;
};

const UNIT_STATE_ATTACK1_BASE = 0x12;
const UNIT_STATE_MANA_REGEN = 0x20;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as number;

function 匹配额外属性规则(this: void, unit: any, rule: import("./00．类型定义").升级额外属性配置): boolean {
  if (rule.onlyMelee === true && jass.IsUnitType(unit, jass.UNIT_TYPE_MELEE_ATTACKER) !== true) return false;
  if (rule.onlyRanged === true && jass.IsUnitType(unit, jass.UNIT_TYPE_MELEE_ATTACKER) === true) return false;
  return true;
}

function 增加单位状态(this: void, unit: any, state: any, delta: number): void {
  const current = (jass.GetUnitState(unit, state) as number) || 0;
  jass.SetUnitState(unit, state, current + delta);
}

function 应用单条额外属性规则(this: void, unit: any, level: number, rule: import("./00．类型定义").升级额外属性配置): void {
  if (rule.repeatEveryLevel === true) {
    if (level < rule.level) return;
  } else if (rule.level !== level) {
    return;
  }
  if (!匹配额外属性规则(unit, rule)) return;

  if (rule.attackBonus != null && rule.attackBonus !== 0) {
    增加单位状态(unit, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE), rule.attackBonus);
  }
  if (rule.manaRegenBonus != null && rule.manaRegenBonus !== 0) {
    增加单位状态(unit, jass.ConvertUnitState(UNIT_STATE_MANA_REGEN), rule.manaRegenBonus);
  }
  if (rule.maxLifeBonus != null && rule.maxLifeBonus !== 0) {
    增加单位状态(unit, UNIT_STATE_MAX_LIFE, rule.maxLifeBonus);
  }
  if (rule.maxManaBonus != null && rule.maxManaBonus !== 0) {
    增加单位状态(unit, UNIT_STATE_MAX_MANA, rule.maxManaBonus);
  }
}

export function 应用升级额外属性(this: void, whichHero: any): void {
  if (!whichHero || whichHero === 0) return;

  const level = (jass.GetHeroLevel(whichHero) as number) || 0;
  const heroRawcode = 获取单位英雄Rawcode(whichHero);
  const heroConfig = 获取英雄升级配置(heroRawcode);

  for (let i = 0; i < 通用升级额外属性配置.length; i++) {
    应用单条额外属性规则(whichHero, level, 通用升级额外属性配置[i]);
  }

  const rules = heroConfig?.extraAttrs;
  if (rules == null) return;
  for (let i = 0; i < rules.length; i++) {
    应用单条额外属性规则(whichHero, level, rules[i]);
  }
}

export {};
