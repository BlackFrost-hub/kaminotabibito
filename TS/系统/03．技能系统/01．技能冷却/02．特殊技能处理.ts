/**
 * 特殊技能冷却处理
 *
 * 处理通魔类技能的独立冷却设置
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

//=============================================================================
// 一、风暴之刃系列技能
//=============================================================================

/** 风暴之刃技能ID */
const STORM_BLADE_SKILLS = [
  0x41304A4A, // A0JJ
  0x41304A49, // A0JI
  0x41304A4B, // A0JK
];

/** 风暴之刃基础冷却 */
const STORM_BLADE_BASE_CD = 12.0;

/** 风暴之刃关联技能ID */
const STORM_BLADE_LINKED_ABILITY = 0x41304A48; // A0JH

/**
 * 检查是否为风暴之刃技能
 */
export function isStormBladeSkill(abilityId: number): boolean {
  return STORM_BLADE_SKILLS.includes(abilityId);
}

/**
 * 处理风暴之刃冷却
 */
export function handleStormBladeCooldown(unit: any, reduction: number): void {
  const cd = STORM_BLADE_BASE_CD - STORM_BLADE_BASE_CD * reduction;
  japi.YDWESetUnitAbilityState(unit, STORM_BLADE_LINKED_ABILITY, 1, cd);
}

//=============================================================================
// 二、三连斩系列技能
//=============================================================================

/**
 * 检查是否为三连斩技能（通过技能数据字符串判断）
 */
export function isTripleSlashSkill(unit: any, abilityId: number): boolean {
  const skillString = japi.YDWEGetUnitAbilityDataString(unit, abilityId, 1, 216);
  return (
    skillString === "SLSQW" ||
    skillString === "SLSQE" ||
    skillString === "SLSQR"
  );
}

/** 三连斩基础冷却 */
const TRIPLE_SLASH_BASE_CD = 9.0;

/** 三连斩关联技能ID */
const TRIPLE_SLASH_LINKED_ABILITY = 0x41304A54; // A0JT

/**
 * 处理三连斩冷却
 */
export function handleTripleSlashCooldown(unit: any, reduction: number): void {
  const cd = TRIPLE_SLASH_BASE_CD - TRIPLE_SLASH_BASE_CD * reduction;
  japi.YDWESetUnitAbilityState(unit, TRIPLE_SLASH_LINKED_ABILITY, 1, cd);
}

//=============================================================================
// 三、统一特殊技能处理入口
//=============================================================================

/**
 * 处理特殊技能冷却
 *
 * @param unit 施法单位
 * @param abilityId 技能ID
 * @param reduction 冷却缩减比例
 * @returns 是否为特殊技能
 */
export function handleSpecialSkillCooldown(
  unit: any,
  abilityId: number,
  reduction: number
): boolean {
  // 风暴之刃
  if (isStormBladeSkill(abilityId)) {
    handleStormBladeCooldown(unit, reduction);
    return true;
  }

  // 三连斩
  if (isTripleSlashSkill(unit, abilityId)) {
    handleTripleSlashCooldown(unit, reduction);
    return true;
  }

  return false;
}

export {};
