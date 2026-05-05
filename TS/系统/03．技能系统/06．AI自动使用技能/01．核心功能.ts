/**
 * AI自动使用技能系统 - 核心功能
 */

const jass = require("jass.common") as any;
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEvent: (this: void, trig: any, player: any, eventId: any, filter?: any) => void;
  registerPlayerUnitEventById: (this: void, trig: any, playerId: number, eventId: any, filter?: any) => void;
};
const { addPeriodicCallback } = globalThis as unknown as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};

// 导入常量
import {
  AI_SKILL_SYSTEM_ENABLED,
  AI_CHECK_INTERVAL,
  AI_EVENT_ID_UNIT_DEATH,
  AI_PLAYER_COUNT,
  AI_PLAYER_NEUTRAL_AGGRESSIVE,
  AI_PLAYER_NEUTRAL_PASSIVE,
  TARGET_TYPE_NONE,
  TARGET_TYPE_POINT,
  TARGET_TYPE_UNIT,
} from "./00．常量定义";

// 导入工具函数
import {
  getHandleId,
  getGameTime,
  getUnitMana,
  getUnitLevel,
  getSkillCooldown,
  isValidUnit,
  isUnitDead,
} from "./02．工具函数";

// ==========================================================================================
// 类型定义
// ==========================================================================================

type SkillTargetType = typeof TARGET_TYPE_NONE | typeof TARGET_TYPE_POINT | typeof TARGET_TYPE_UNIT;
type TargetFilter = (caster: any, target: any) => boolean;

export interface AISkillConfig {
  abilityId: number;
  orderId: number;
  targetType: SkillTargetType;
  priority: number;
  castRange: number;
  manaCost: number;
  cooldown: number;
  minLevel: number;
  targetFilter?: TargetFilter;
  pointCondition?: (caster: any) => { x: number; y: number } | null;
}

interface RegisteredAISkill {
  config: AISkillConfig;
  lastCastTime: number;
}

interface UnitAIInfo {
  unit: any;
  skills: Map<number, RegisteredAISkill>;
}

type AIUnitRegistry = Map<number, UnitAIInfo>;

// ==========================================================================================
// 全局注册表
// ==========================================================================================

const aiUnitRegistry: AIUnitRegistry = new Map();
let aiCheckRegistered = false;
let unitCreatedTrigger: any = null;

function clampMinInt(value: number, minValue: number): number {
  const intValue = jass.R2I(value);
  return intValue < minValue ? minValue : intValue;
}

// ==========================================================================================
// 注册与注销API
// ==========================================================================================

export function registerAISkill(unit: any, config: AISkillConfig): boolean {
  if (!unit || !config.abilityId) return false;

  const handleId = getHandleId(unit);
  if (!handleId) return false;

  if (!aiUnitRegistry.has(handleId)) {
    aiUnitRegistry.set(handleId, { unit, skills: new Map() });
  }

  aiUnitRegistry.get(handleId)!.skills.set(config.abilityId, { config, lastCastTime: 0 });
  return true;
}

export function registerAISkills(unit: any, configs: AISkillConfig[]): number {
  let count = 0;
  for (const config of configs) {
    if (registerAISkill(unit, config)) count++;
  }
  return count;
}

export function unregisterAISkill(unit: any, abilityId?: number): boolean {
  if (!unit) return false;

  const handleId = getHandleId(unit);
  if (!handleId || !aiUnitRegistry.has(handleId)) return false;

  const unitInfo = aiUnitRegistry.get(handleId)!;

  if (abilityId === undefined) {
    aiUnitRegistry.delete(handleId);
    return true;
  }

  if (unitInfo.skills.has(abilityId)) {
    unitInfo.skills.delete(abilityId);
    if (unitInfo.skills.size === 0) aiUnitRegistry.delete(handleId);
    return true;
  }

  return false;
}

export function registerAIUnit(unit: any): boolean {
  if (!unit) return false;

  const handleId = getHandleId(unit);
  if (!handleId) return false;

  if (!aiUnitRegistry.has(handleId)) {
    aiUnitRegistry.set(handleId, { unit, skills: new Map() });
  }

  return true;
}

export function unregisterAIUnit(unit: any): boolean {
  if (!unit) return false;

  const handleId = getHandleId(unit);
  if (!handleId || !aiUnitRegistry.has(handleId)) return false;

  aiUnitRegistry.delete(handleId);
  return true;
}

// ==========================================================================================
// 技能施放逻辑
// ==========================================================================================

function canCastSkill(unit: any, skillInfo: RegisteredAISkill): boolean {
  const { config } = skillInfo;

  if (!isValidUnit(unit) || isUnitDead(unit)) return false;
  if (getUnitLevel(unit) < config.minLevel) return false;
  if (getUnitMana(unit) < (config.manaCost || 0)) return false;

  const currentTime = getGameTime();
  if (currentTime - skillInfo.lastCastTime < (config.cooldown || 0)) return false;
  if (getSkillCooldown(unit, config.abilityId) > 0) return false;

  return true;
}

function findBestTarget(unit: any, skillInfo: RegisteredAISkill): any | null {
  const { config } = skillInfo;

  if (config.targetType === TARGET_TYPE_NONE) return true;
  if (config.targetType === TARGET_TYPE_POINT && config.pointCondition) {
    return config.pointCondition(unit);
  }
  // TODO: 单位目标技能的目标搜索
  return null;
}

function castSkill(unit: any, skillInfo: RegisteredAISkill, target: any): boolean {
  const { config } = skillInfo;

  try {
    if (config.targetType === TARGET_TYPE_NONE) {
      if (config.orderId !== 0) {
        jass.IssueImmediateOrderById(unit, config.orderId);
      }
    } else if (config.targetType === TARGET_TYPE_POINT) {
      const point = target as { x: number; y: number };
      if (point !== null && point !== undefined && config.orderId !== 0) {
        jass.IssuePointOrderById(unit, config.orderId, point.x, point.y);
      }
    } else if (config.targetType === TARGET_TYPE_UNIT) {
      if (target !== null && target !== undefined && isValidUnit(target) && config.orderId !== 0) {
        jass.IssueTargetOrderById(unit, config.orderId, target);
      }
    }

    skillInfo.lastCastTime = getGameTime();
    return true;
  } catch (_e) {
    return false;
  }
}

function updateAIUnit(unitInfo: UnitAIInfo): void {
  const { unit, skills } = unitInfo;

  if (!isValidUnit(unit) || isUnitDead(unit)) return;

  const sortedSkills = Array.from(skills.values())
    .sort((a, b) => b.config.priority - a.config.priority);

  for (const skillInfo of sortedSkills) {
    if (!canCastSkill(unit, skillInfo)) continue;
    const target = findBestTarget(unit, skillInfo);
    if (target) {
      castSkill(unit, skillInfo, target);
      break;
    }
  }
}

function onAICheck(): void {
  for (const unitInfo of aiUnitRegistry.values()) {
    updateAIUnit(unitInfo);
  }
}

// ==========================================================================================
// 系统初始化
// ==========================================================================================

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (cb: (dyingUnit: any, killingUnit: any) => void) => void;
};

export function initAISkillSystem(): void {
  if (!AI_SKILL_SYSTEM_ENABLED) return;

  if (!aiCheckRegistered) {
    aiCheckRegistered = true;
    addPeriodicCallback(clampMinInt(AI_CHECK_INTERVAL * 1000, 1), onAICheck);
  }

  registerDeathListener((dyingUnit) => {
    unregisterAIUnit(dyingUnit);
  });

  initAutoRegister();
}

export function autoRegisterNeutralAggressive(unit: any): void {
  if (!unit) return;

  const owner = jass.GetOwningPlayer(unit);
  const neutralAggressive = (jass as any).Player(AI_PLAYER_NEUTRAL_AGGRESSIVE);

  if (owner === neutralAggressive) {
    const isHero = jass.IsUnitType(unit, jass.UNIT_TYPE_HERO);
    if (!isHero) registerAIUnit(unit);
  }
}

function onAutoRegisterNeutralAggressive(): void {
  autoRegisterNeutralAggressive(jass.GetTriggerUnit());
}

function initAutoRegister(): void {
  if (!unitCreatedTrigger) {
    unitCreatedTrigger = jass.CreateTrigger();
    const enterRegionEvent = jass.EVENT_PLAYER_UNIT_SUMMON;

    for (let i = 0; i < AI_PLAYER_COUNT; i++) {
      playerUnitEvent.registerPlayerUnitEventById(unitCreatedTrigger, i, enterRegionEvent);
    }

    const neutralAggressive = (jass as any).Player(AI_PLAYER_NEUTRAL_AGGRESSIVE);
    playerUnitEvent.registerPlayerUnitEvent(unitCreatedTrigger, neutralAggressive, enterRegionEvent);

    jass.TriggerAddAction(unitCreatedTrigger, onAutoRegisterNeutralAggressive);
  }
}

// ==========================================================================================
// 调试工具
// ==========================================================================================

export function getAIUnitCount(): number {
  return aiUnitRegistry.size;
}

export function getAISkillCount(unit: any): number {
  if (!unit) return 0;
  const handleId = getHandleId(unit);
  if (!handleId || !aiUnitRegistry.has(handleId)) return 0;
  return aiUnitRegistry.get(handleId)!.skills.size;
}

export function isSystemEnabled(): boolean {
  return AI_SKILL_SYSTEM_ENABLED;
}

export {};
