/**
 * 动态技能说明系统 - 核心功能
 *
 * 功能：注册动态技能说明、公式解析、自动刷新
 * 后续接手者：开关 DYNAMIC_SKILL_TIP_ENABLED 在常量文件
 */

const jass = require("jass.common") as any;
const heroLevelEventCenter = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心") as {
  registerHeroLevelListener: (this: void, callback: (heroUnit: any) => void) => void;
};
const { registerHeroLevelListener } = heroLevelEventCenter;

import {
  DYNAMIC_SKILL_TIP_ENABLED,
  EVENT_ID_UNIT_DEATH,
  PLAYER_NEUTRAL_AGGRESSIVE,
  PLAYER_NEUTRAL_PASSIVE,
  UNIT_STATE_ATTACK1_BASE,
  UNIT_STATE_ATTACK1_BONUS,
  UNIT_STATE_ARMOR,
  BRACKET_LEFT_EN,
  BRACKET_RIGHT_EN,
  BRACKET_LEFT_CN,
  BRACKET_RIGHT_CN,
  ATTR_SKILL_LEVEL,
  ATTR_STR, ATTR_AGI, ATTR_INT,
  ATTR_STR_WHITE, ATTR_AGI_WHITE, ATTR_INT_WHITE,
  ATTR_HP, ATTR_HP_MAX, ATTR_MP, ATTR_MP_MAX,
  ATTR_ATTACK, ATTR_ARMOR, ATTR_MOVE_SPEED,
  ATTR_LEVEL, ATTR_HERO_LEVEL, ATTR_XP,
} from "./00．常量定义";

// 导入公式解析器
import {
  safeEval,
  replaceAll,
  indexOfChar,
  formatNumber,
  isDigit,
} from "./02．公式解析器";

// 导入YDWE函数
const {
  EXGetUnitAbility,
  EXSetAbilityDataString,
  ABILITY_DATA_TIP,
  ABILITY_DATA_UBERTIP,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXGetUnitAbility: (u: any, abilcode: number) => any;
  EXSetAbilityDataString: (abil: any, level: number, data_type: number, value: string) => boolean;
  ABILITY_DATA_TIP: number;
  ABILITY_DATA_UBERTIP: number;
};

// 导出常量供外部使用
export { ABILITY_DATA_TIP, ABILITY_DATA_UBERTIP };

// ==========================================================================================
// 类型定义
// ==========================================================================================

type AttributeGetter = (u: any) => number;

interface RegisteredSkill {
  unit: any;
  abilityId: number;
  level: number;
  template: string;
  tipType: number;
}

type UnitSkillRegistry = Map<number, Map<number, RegisteredSkill[]>>;

// ==========================================================================================
// 属性获取函数映射
// ==========================================================================================

const attributeGetters: Record<string, AttributeGetter> = {
  [ATTR_STR]: (u) => jass.GetHeroStr(u, true) || 0,
  [ATTR_AGI]: (u) => jass.GetHeroAgi(u, true) || 0,
  [ATTR_INT]: (u) => jass.GetHeroInt(u, true) || 0,
  [ATTR_STR_WHITE]: (u) => jass.GetHeroStr(u, false) || 0,
  [ATTR_AGI_WHITE]: (u) => jass.GetHeroAgi(u, false) || 0,
  [ATTR_INT_WHITE]: (u) => jass.GetHeroInt(u, false) || 0,
  [ATTR_HP]: (u) => jass.GetUnitState(u, jass.UNIT_STATE_LIFE) || 0,
  [ATTR_HP_MAX]: (u) => jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) || 0,
  [ATTR_MP]: (u) => jass.GetUnitState(u, jass.UNIT_STATE_MANA) || 0,
  [ATTR_MP_MAX]: (u) => jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) || 0,
  [ATTR_ATTACK]: (u) => (jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE)) || 0) +
                         (jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS)) || 0),
  [ATTR_ARMOR]: (u) => jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ARMOR)) || 0,
  [ATTR_MOVE_SPEED]: (u) => jass.GetUnitMoveSpeed(u) || 0,
  [ATTR_LEVEL]: (u) => jass.GetHeroLevel(u) || 0,
  [ATTR_HERO_LEVEL]: (u) => jass.GetHeroLevel(u) || 0,
  [ATTR_XP]: (u) => jass.GetHeroXP(u) || 0,
};

// ==========================================================================================
// 全局注册表
// ==========================================================================================

const skillRegistry: UnitSkillRegistry = new Map();
const unitHandleMap: Map<number, any> = new Map();

// ==========================================================================================
// 公式计算
// ==========================================================================================

function evaluateFormula(formula: string, unit: any, skillLevel: number): number {
  if (!formula) return 0;

  let expr = formula.trim();
  if (expr === "") return 0;

  expr = replaceAll(expr, ATTR_SKILL_LEVEL, skillLevel.toString());

  const sortedAttrs = Object.keys(attributeGetters).sort((a, b) => b.length - a.length);
  for (const attrName of sortedAttrs) {
    const getter = attributeGetters[attrName];
    const value = getter(unit);
    expr = replaceAll(expr, attrName, value.toString());
  }

  try {
    const result = safeEval(expr);
    return isFinite(result) ? result : 0;
  } catch (_e) {
    return 0;
  }
}

function processTemplate(template: string, unit: any, skillLevel: number): string {
  let result = "";
  let i = 0;

  while (i < template.length) {
    if (template[i] === BRACKET_LEFT_EN || template[i] === BRACKET_LEFT_CN) {
      const isOpenBracket = template[i] === BRACKET_LEFT_EN;
      const closeBracket = isOpenBracket ? BRACKET_RIGHT_EN : BRACKET_RIGHT_CN;
      const endIdx = indexOfChar(template, closeBracket, i + 1);
      if (endIdx > i + 1) {
        const formula = template.slice(i + 1, endIdx);
        const value = evaluateFormula(formula, unit, skillLevel);
        result += formatNumber(value);
        i = endIdx + 1;
        continue;
      }
    }
    result += template[i];
    i++;
  }

  return result;
}

// ==========================================================================================
// 核心API
// ==========================================================================================

export function registerDynamicSkillTip(
  unit: any,
  abilityId: number,
  template: string,
  level: number = 1,
  tipType: number = ABILITY_DATA_TIP
): boolean {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return false;
  if (!unit || !abilityId || !template) return false;

  const handleId = jass.GetHandleId(unit);
  if (!handleId) return false;

  const abil = EXGetUnitAbility(unit, abilityId);
  if (!abil) return false;

  const skillInfo: RegisteredSkill = { unit, abilityId, level, template, tipType };

  if (!skillRegistry.has(handleId)) {
    skillRegistry.set(handleId, new Map());
    unitHandleMap.set(handleId, unit);
  }

  const unitSkills = skillRegistry.get(handleId)!;
  if (!unitSkills.has(abilityId)) {
    unitSkills.set(abilityId, []);
  }

  unitSkills.get(abilityId)!.push(skillInfo);
  updateSkillTip(skillInfo);

  return true;
}

export function unregisterDynamicSkillTip(unit: any, abilityId?: number): boolean {
  if (!unit) return false;

  const handleId = jass.GetHandleId(unit);
  if (!handleId || !skillRegistry.has(handleId)) return false;

  const unitSkills = skillRegistry.get(handleId)!;

  if (abilityId === undefined) {
    skillRegistry.delete(handleId);
    unitHandleMap.delete(handleId);
    return true;
  }

  if (unitSkills.has(abilityId)) {
    unitSkills.delete(abilityId);
    if (unitSkills.size === 0) {
      skillRegistry.delete(handleId);
      unitHandleMap.delete(handleId);
    }
    return true;
  }

  return false;
}

function updateSkillTip(skillInfo: RegisteredSkill): void {
  const { unit, abilityId, level, template, tipType } = skillInfo;
  const abil = EXGetUnitAbility(unit, abilityId);
  if (!abil) return;

  const tipText = processTemplate(template, unit, level);
  EXSetAbilityDataString(abil, level, tipType, tipText);
}

export function refreshUnitSkillTips(unit: any): void {
  if (!unit) return;

  const handleId = jass.GetHandleId(unit);
  if (!handleId || !skillRegistry.has(handleId)) return;

  const unitSkills = skillRegistry.get(handleId)!;
  for (const skillList of unitSkills.values()) {
    for (const skillInfo of skillList) {
      updateSkillTip(skillInfo);
    }
  }
}

export function refreshAllSkillTips(): void {
  for (const [handleId, unitSkills] of skillRegistry) {
    const unit = unitHandleMap.get(handleId);
    if (!unit) continue;

    for (const skillList of unitSkills.values()) {
      for (const skillInfo of skillList) {
        updateSkillTip(skillInfo);
      }
    }
  }
}

// ==========================================================================================
// 便捷API
// ==========================================================================================

export function registerSkillTip(
  unit: any,
  abilityId: number,
  template: string,
  level: number = 1
): boolean {
  return registerDynamicSkillTip(unit, abilityId, template, level, ABILITY_DATA_TIP);
}

export function registerSkillUbertip(
  unit: any,
  abilityId: number,
  template: string,
  level: number = 1
): boolean {
  return registerDynamicSkillTip(unit, abilityId, template, level, ABILITY_DATA_UBERTIP);
}

export function registerSkillTips(
  unit: any,
  abilityId: number,
  tipTemplate: string,
  ubertipTemplate: string,
  level: number = 1
): boolean {
  const success1 = registerSkillTip(unit, abilityId, tipTemplate, level);
  const success2 = registerSkillUbertip(unit, abilityId, ubertipTemplate, level);
  return success1 || success2;
}

// ==========================================================================================
// 事件处理
// ==========================================================================================

const { registerDeathListener } = require("系统.01．单位系统.03．单位死亡事件.01．核心功能") as {
  registerDeathListener: (cb: (dyingUnit: any, killingUnit: any) => void) => void;
};

let _heroLevelListenerBound = false;
let _deathListenerBound = false;

export function initDynamicSkillTipSystem(): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;

  if (!_heroLevelListenerBound) {
    _heroLevelListenerBound = true;
    registerHeroLevelListener((unit) => {
      refreshUnitSkillTips(unit);
    });
  }

  if (!_deathListenerBound) {
    _deathListenerBound = true;
    registerDeathListener((dyingUnit) => {
      unregisterDynamicSkillTip(dyingUnit);
    });
  }
}

// ==========================================================================================
// 扩展API
// ==========================================================================================

export function registerAttributeGetter(attrName: string, getter: AttributeGetter): void {
  attributeGetters[attrName] = getter;
}

export function unregisterAttributeGetter(attrName: string): boolean {
  if (attributeGetters.hasOwnProperty(attrName)) {
    delete attributeGetters[attrName];
    return true;
  }
  return false;
}

export function getSupportedAttributes(): string[] {
  return Object.keys(attributeGetters);
}

// ==========================================================================================
// 调试工具
// ==========================================================================================

export function getRegisteredSkillCount(unit: any): number {
  if (!unit) return 0;

  const handleId = jass.GetHandleId(unit);
  if (!handleId || !skillRegistry.has(handleId)) return 0;

  const unitSkills = skillRegistry.get(handleId)!;
  let count = 0;
  for (const skillList of unitSkills.values()) {
    count += skillList.length;
  }
  return count;
}

export function getTotalRegisteredCount(): number {
  let count = 0;
  for (const unitSkills of skillRegistry.values()) {
    for (const skillList of unitSkills.values()) {
      count += skillList.length;
    }
  }
  return count;
}

export {};
