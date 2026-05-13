/** @noSelfInFile */
/**
 * 特殊技能冷却处理
 */

const YD安全模块 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEGetUnitAbilityDataStringSafe: (
    this: void,
    unit: any,
    abilityId: number,
    level: number,
    dataType: number
  ) => string;
  YDWESetUnitAbilityStateSafe: (
    this: void,
    unit: any,
    abilityId: number,
    stateType: number,
    value: number
  ) => boolean;
};
const 通用工具模块 = require("lib.扩展函数.封装函数.01．通用工具.index") as any;
const 转四字节 = 通用工具模块.stringToFourCC as (this: void, raw: string) => number;
const YD设置技能状态 = YD安全模块.YDWESetUnitAbilityStateSafe as (
  this: void,
  unit: any,
  abilityId: number,
  stateType: number,
  value: number
) => boolean;
const YD读取技能字符串 = YD安全模块.YDWEGetUnitAbilityDataStringSafe as (
  this: void,
  unit: any,
  abilityId: number,
  level: number,
  dataType: number
) => string;
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
  if (!配置键名) return "";
  const 片段列表 = 配置键名.split("|");
  return 片段列表[片段列表.length - 1] ?? "";
}

/**
 * 检查是否为风暴之刃技能
 */
export function isStormBladeSkill(abilityId: number): boolean {
  return STORM_BLADE_SKILLS.some(配置键名 => 转四字节(提取内部ID(配置键名)) === abilityId);
}

/**
 * 处理风暴之刃冷却
 */
export function handleStormBladeCooldown(unit: any, reduction: number): void {
  const cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction;
  YD设置技能状态(unit, 转四字节(提取内部ID(STORM_BLADE_LINKED_ABILITY)), 1, cd);
}

/**
 * 检查是否为三连斩技能
 */
export function isTripleSlashSkill(unit: any, abilityId: number): boolean {
  const skillString = YD读取技能字符串(unit, abilityId, 1, 216);
  return TRIPLE_SLASH_SKILL_MARKERS.some(配置键名 => 提取内部ID(配置键名) === skillString);
}

/**
 * 处理三连斩冷却
 */
export function handleTripleSlashCooldown(unit: any, reduction: number): void {
  const cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction;
  YD设置技能状态(unit, 转四字节(提取内部ID(TRIPLE_SLASH_LINKED_ABILITY)), 1, cd);
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
