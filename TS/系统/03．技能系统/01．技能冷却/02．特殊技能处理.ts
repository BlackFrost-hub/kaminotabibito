/**
 * 特殊技能冷却处理
 */

const { YDWESetUnitAbilityState, YDWEGetUnitAbilityDataString } = require("lib.扩展函数.YDWE函数.index") as {
  YDWESetUnitAbilityState: (u: any, abilcode: number, state_type: number, value: number) => boolean;
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, data_type: number) => string;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const {
  STORM_BLADE_SKILLS,
  STORM_BLADE_BASE_CD,
  STORM_BLADE_LINKED_ABILITY,
  TRIPLE_SLASH_SKILL_MARKERS,
  TRIPLE_SLASH_BASE_CD,
  TRIPLE_SLASH_LINKED_ABILITY,
} = require("系统.03．技能系统.01．技能冷却.00．冷却常量") as {
  STORM_BLADE_SKILLS: string[];
  STORM_BLADE_BASE_CD: number;
  STORM_BLADE_LINKED_ABILITY: string;
  TRIPLE_SLASH_SKILL_MARKERS: string[];
  TRIPLE_SLASH_BASE_CD: number;
  TRIPLE_SLASH_LINKED_ABILITY: string;
};

function 提取内部ID(配置键名: string): string {
  const 片段列表 = 配置键名.split("|");
  return 片段列表[片段列表.length - 1] ?? 配置键名;
}

/**
 * 检查是否为风暴之刃技能
 */
export function isStormBladeSkill(abilityId: number): boolean {
  return STORM_BLADE_SKILLS.some(配置键名 => stringToFourCC(提取内部ID(配置键名)) === abilityId);
}

/**
 * 处理风暴之刃冷却
 */
export function handleStormBladeCooldown(unit: any, reduction: number): void {
  const cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction;
  YDWESetUnitAbilityState(unit, stringToFourCC(提取内部ID(STORM_BLADE_LINKED_ABILITY)), 1, cd);
}

/**
 * 检查是否为三连斩技能
 */
export function isTripleSlashSkill(unit: any, abilityId: number): boolean {
  const skillString = YDWEGetUnitAbilityDataString(unit, abilityId, 1, 216);
  return TRIPLE_SLASH_SKILL_MARKERS.some(配置键名 => 提取内部ID(配置键名) === skillString);
}

/**
 * 处理三连斩冷却
 */
export function handleTripleSlashCooldown(unit: any, reduction: number): void {
  const cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction;
  YDWESetUnitAbilityState(unit, stringToFourCC(提取内部ID(TRIPLE_SLASH_LINKED_ABILITY)), 1, cd);
}

/**
 * 处理特殊技能冷却
 */
export function handleSpecialSkillCooldown(
  unit: any,
  abilityId: number,
  reduction: number
): boolean {
  if (isStormBladeSkill(abilityId)) {
    handleStormBladeCooldown(unit, reduction);
    return true;
  }

  if (isTripleSlashSkill(unit, abilityId)) {
    handleTripleSlashCooldown(unit, reduction);
    return true;
  }

  return false;
}

export {};
