/**
 * 动态技能说明系统 - 核心功能
 *
 * 功能：注册动态技能说明、公式解析、自动刷新
 * 后续接手者：开关 DYNAMIC_SKILL_TIP_ENABLED 在常量文件
 */
/** @noSelfInFile */

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
  OPERATOR_MULTIPLY_CN,
  OPERATOR_DIVIDE_CN,
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
  ABILITY_DATA_TIP,
  ABILITY_DATA_UBERTIP,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXGetUnitAbility: (u: any, abilcode: number) => any;
  ABILITY_DATA_TIP: number;
  ABILITY_DATA_UBERTIP: number;
};

// 导出常量供外部使用
export { ABILITY_DATA_TIP, ABILITY_DATA_UBERTIP };

// ==========================================================================================
// 类型定义
// ==========================================================================================

type AttributeGetter = (u: any) => number;
type FormulaAlias = { source: string; token: string };

interface RegisteredSkill {
  unit: any;
  abilityId: number;
  level: number;
  template: string;
  tipType: number;
  renderedText: string;
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

const FORMULA_TOKEN_SKILL_LEVEL = "__SKILL_LEVEL__";
const FORMULA_TOKEN_STR = "__STR__";
const FORMULA_TOKEN_AGI = "__AGI__";
const FORMULA_TOKEN_INT = "__INT__";
const FORMULA_TOKEN_STR_WHITE = "__STR_WHITE__";
const FORMULA_TOKEN_AGI_WHITE = "__AGI_WHITE__";
const FORMULA_TOKEN_INT_WHITE = "__INT_WHITE__";
const FORMULA_TOKEN_HP = "__HP__";
const FORMULA_TOKEN_HP_MAX = "__HP_MAX__";
const FORMULA_TOKEN_MP = "__MP__";
const FORMULA_TOKEN_MP_MAX = "__MP_MAX__";
const FORMULA_TOKEN_ATTACK = "__ATTACK__";
const FORMULA_TOKEN_ARMOR = "__ARMOR__";
const FORMULA_TOKEN_MOVE_SPEED = "__MOVE_SPEED__";
const FORMULA_TOKEN_LEVEL = "__LEVEL__";
const FORMULA_TOKEN_HERO_LEVEL = "__HERO_LEVEL__";
const FORMULA_TOKEN_XP = "__XP__";

const formulaAliases: FormulaAlias[] = [
  { source: ATTR_SKILL_LEVEL, token: FORMULA_TOKEN_SKILL_LEVEL },
  { source: ATTR_STR_WHITE, token: FORMULA_TOKEN_STR_WHITE },
  { source: ATTR_AGI_WHITE, token: FORMULA_TOKEN_AGI_WHITE },
  { source: ATTR_INT_WHITE, token: FORMULA_TOKEN_INT_WHITE },
  { source: ATTR_HP_MAX, token: FORMULA_TOKEN_HP_MAX },
  { source: ATTR_MP_MAX, token: FORMULA_TOKEN_MP_MAX },
  { source: ATTR_MOVE_SPEED, token: FORMULA_TOKEN_MOVE_SPEED },
  { source: ATTR_HERO_LEVEL, token: FORMULA_TOKEN_HERO_LEVEL },
  { source: ATTR_ATTACK, token: FORMULA_TOKEN_ATTACK },
  { source: ATTR_ARMOR, token: FORMULA_TOKEN_ARMOR },
  { source: ATTR_LEVEL, token: FORMULA_TOKEN_LEVEL },
  { source: ATTR_STR, token: FORMULA_TOKEN_STR },
  { source: ATTR_AGI, token: FORMULA_TOKEN_AGI },
  { source: ATTR_INT, token: FORMULA_TOKEN_INT },
  { source: ATTR_HP, token: FORMULA_TOKEN_HP },
  { source: ATTR_MP, token: FORMULA_TOKEN_MP },
  { source: ATTR_XP, token: FORMULA_TOKEN_XP },
];

const aliasedAttributeGetters: Record<string, AttributeGetter> = {
  [FORMULA_TOKEN_STR]: attributeGetters[ATTR_STR],
  [FORMULA_TOKEN_AGI]: attributeGetters[ATTR_AGI],
  [FORMULA_TOKEN_INT]: attributeGetters[ATTR_INT],
  [FORMULA_TOKEN_STR_WHITE]: attributeGetters[ATTR_STR_WHITE],
  [FORMULA_TOKEN_AGI_WHITE]: attributeGetters[ATTR_AGI_WHITE],
  [FORMULA_TOKEN_INT_WHITE]: attributeGetters[ATTR_INT_WHITE],
  [FORMULA_TOKEN_HP]: attributeGetters[ATTR_HP],
  [FORMULA_TOKEN_HP_MAX]: attributeGetters[ATTR_HP_MAX],
  [FORMULA_TOKEN_MP]: attributeGetters[ATTR_MP],
  [FORMULA_TOKEN_MP_MAX]: attributeGetters[ATTR_MP_MAX],
  [FORMULA_TOKEN_ATTACK]: attributeGetters[ATTR_ATTACK],
  [FORMULA_TOKEN_ARMOR]: attributeGetters[ATTR_ARMOR],
  [FORMULA_TOKEN_MOVE_SPEED]: attributeGetters[ATTR_MOVE_SPEED],
  [FORMULA_TOKEN_LEVEL]: attributeGetters[ATTR_LEVEL],
  [FORMULA_TOKEN_HERO_LEVEL]: attributeGetters[ATTR_HERO_LEVEL],
  [FORMULA_TOKEN_XP]: attributeGetters[ATTR_XP],
};

// ==========================================================================================
// 全局注册表
// ==========================================================================================

const skillRegistry: UnitSkillRegistry = new Map();
const unitHandleMap: Map<number, any> = new Map();
const formulaTokenNames = [FORMULA_TOKEN_SKILL_LEVEL, ...Object.keys(aliasedAttributeGetters)].sort((a, b) => b.length - a.length);

function normalizeFormulaTemplate(template: string): string {
  let result = template;
  for (const alias of formulaAliases) {
    result = replaceAll(result, alias.source, alias.token);
  }
  return result;
}

function denormalizeFormulaTemplate(template: string): string {
  let result = template;
  for (const alias of formulaAliases) {
    result = replaceAll(result, alias.token, alias.source);
  }
  return result;
}

// ==========================================================================================
// 公式计算
// ==========================================================================================

function evaluateFormula(formula: string, unit: any, skillLevel: number): number {
  if (!formula) return 0;

  let expr = normalizeFormulaTemplate(formula).trim();
  if (expr === "") return 0;

  expr = replaceAll(expr, FORMULA_TOKEN_SKILL_LEVEL, skillLevel.toString());

  const sortedAttrs = Object.keys(aliasedAttributeGetters).sort((a, b) => b.length - a.length);
  for (const attrName of sortedAttrs) {
    const getter = aliasedAttributeGetters[attrName];
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
  template = normalizeFormulaTemplate(template);
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

  return denormalizeFormulaTemplate(processInlineFormulas(result, unit, skillLevel));
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

  const skillInfo: RegisteredSkill = { unit, abilityId, level, template, tipType, renderedText: "" };

  if (!skillRegistry.has(handleId)) {
    skillRegistry.set(handleId, new Map());
    unitHandleMap.set(handleId, unit);
  }

  const unitSkills = skillRegistry.get(handleId)!;
  if (!unitSkills.has(abilityId)) {
    unitSkills.set(abilityId, []);
  }

  const skillList = unitSkills.get(abilityId)!;
  let replaced = false;
  for (let i = 0; i < skillList.length; i++) {
    if (skillList[i].tipType !== tipType) continue;
    skillList[i].level = level;
    skillList[i].template = template;
    skillList[i].unit = unit;
    updateSkillTip(skillList[i]);
    replaced = true;
    break;
  }
  if (!replaced) {
    skillList.push(skillInfo);
    updateSkillTip(skillInfo);
  }

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
  const { unit, abilityId, template } = skillInfo;
  const abil = EXGetUnitAbility(unit, abilityId);
  if (!abil) return;

  const currentLevel = jass.GetUnitAbilityLevel(unit, abilityId) || skillInfo.level || 1;
  skillInfo.level = currentLevel;
  skillInfo.renderedText = processTemplate(template, unit, currentLevel);
}

export function getDynamicSkillTipText(unit: any, abilityId: number, tipType: number): string | null {
  if (!unit || !abilityId) return null;

  const handleId = jass.GetHandleId(unit);
  if (!handleId || !skillRegistry.has(handleId)) return null;

  const unitSkills = skillRegistry.get(handleId)!;
  const skillList = unitSkills.get(abilityId);
  if (skillList == null) return null;

  for (let i = 0; i < skillList.length; i++) {
    const skillInfo = skillList[i];
    if (skillInfo.tipType !== tipType) continue;
    if (skillInfo.renderedText === "") {
      updateSkillTip(skillInfo);
    }
    return skillInfo.renderedText || null;
  }

  return null;
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

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, cb: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

let _heroLevelListenerBound = false;
let _deathListenerBound = false;

function onDynamicSkillTipDeath(this: void, dyingUnit: any): void {
  unregisterDynamicSkillTip(dyingUnit);
}

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
    registerDeathListener(onDynamicSkillTipDeath);
  }
}

function matchFormulaToken(text: string, start: number): string | null {
  for (const token of formulaTokenNames) {
    if (text.slice(start, start + token.length) === token) {
      return token;
    }
  }
  return null;
}

function isInlineFormulaChar(c: string): boolean {
  return isDigit(c) || c === "." || c === "+" || c === "-" ||
         c === "*" || c === "/" || c === "×" || c === "÷" ||
         c === OPERATOR_MULTIPLY_CN || c === OPERATOR_DIVIDE_CN ||
         c === "脳" || c === "梅" || c === "(" || c === ")";
}

function hasFormulaOperatorOrDigit(formula: string): boolean {
  for (let i = 0; i < formula.length; i++) {
    const c = formula[i];
    if (isDigit(c) || c === "+" || c === "-" ||
        c === "*" || c === "/" || c === "×" || c === "÷" ||
        c === OPERATOR_MULTIPLY_CN || c === OPERATOR_DIVIDE_CN ||
        c === "脳" || c === "梅") {
      return true;
    }
  }
  return false;
}

export function renderDynamicSkillTemplate(template: string, unit: any, skillLevel: number): string {
  if (!template) return "";
  return processTemplate(template, unit, skillLevel);
}

function processInlineFormulas(template: string, unit: any, skillLevel: number): string {
  let result = "";
  let i = 0;

  while (i < template.length) {
    const startToken = matchFormulaToken(template, i);
    if (startToken == null) {
      result += template[i];
      i++;
      continue;
    }

    let end = i + startToken.length;
    while (end < template.length) {
      const nextToken = matchFormulaToken(template, end);
      if (nextToken != null) {
        end += nextToken.length;
        continue;
      }
      if (!isInlineFormulaChar(template[end])) break;
      end++;
    }

    const formula = template.slice(i, end);
    if (!hasFormulaOperatorOrDigit(formula)) {
      result += template[i];
      i++;
      continue;
    }

    result += formatNumber(evaluateFormula(formula, unit, skillLevel));
    i = end;
  }

  return result;
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
