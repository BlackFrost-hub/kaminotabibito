/** @noSelfInFile */

export type 英雄Rawcode = string;
export type 技能Rawcode = string;

export type 升级额外属性配置 = {
  level: number;
  repeatEveryLevel?: boolean;
  attackBonus?: number;
  manaRegenBonus?: number;
  maxLifeBonus?: number;
  maxManaBonus?: number;
  onlyMelee?: boolean;
  onlyRanged?: boolean;
  note?: string;
};

export type 英雄领悟技能配置 = {
  level: number;
  abilityId: 技能Rawcode;
  note?: string;
};

export type 提升等级学习技能配置 = {
  level: number;
  abilityId: 技能Rawcode;
  targetLevel?: number;
  note?: string;
};

export type 英雄升级配置 = {
  heroId: 英雄Rawcode;
  heroName: string;
  properName?: string;
  extraAttrs?: readonly 升级额外属性配置[];
  awakeningSkills?: readonly 英雄领悟技能配置[];
  learnedSkills?: readonly 提升等级学习技能配置[];
  pendingNotes?: readonly string[];
};

export {};
