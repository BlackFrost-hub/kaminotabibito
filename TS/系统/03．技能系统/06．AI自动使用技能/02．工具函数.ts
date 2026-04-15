/**
 * AI自动使用技能系统 - 工具函数
 */

const jass = require("jass.common") as any;

// 导入YDWE函数
const {
  EXGetUnitAbility,
  EXGetAbilityState,
  ABILITY_STATE_COOLDOWN,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXGetUnitAbility: (u: any, abilcode: number) => any;
  EXGetAbilityState: (abil: any, state_type: number) => number;
  ABILITY_STATE_COOLDOWN: number;
};

// ==========================================================================================
// 单位工具函数
// ==========================================================================================

/**
 * 获取单位句柄ID
 */
export function getHandleId(unit: any): number {
  return typeof jass.GetHandleId === "function" ? (jass.GetHandleId(unit) || 0) : 0;
}

/**
 * 获取当前游戏时间（秒）
 */
export function getGameTime(): number {
  return typeof jass.GetGameTime === "function" ? jass.GetGameTime() : 0;
}

/**
 * 获取单位魔法值
 */
export function getUnitMana(unit: any): number {
  return typeof jass.GetUnitState === "function"
    ? (jass.GetUnitState(unit, jass.UNIT_STATE_MANA) || 0)
    : 0;
}

/**
 * 获取单位等级
 */
export function getUnitLevel(unit: any): number {
  return typeof jass.GetHeroLevel === "function" ? (jass.GetHeroLevel(unit) || 0) : 0;
}

/**
 * 获取技能当前冷却时间
 */
export function getSkillCooldown(unit: any, abilityId: number): number {
  const abil = EXGetUnitAbility(unit, abilityId);
  if (!abil) return 0;
  return EXGetAbilityState(abil, ABILITY_STATE_COOLDOWN) || 0;
}

/**
 * 获取两点距离
 */
export function getDistance(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return Math.sqrt(dx * dx + dy * dy);
}

/**
 * 获取单位坐标
 */
export function getUnitPos(unit: any): { x: number; y: number } {
  return {
    x: typeof jass.GetUnitX === "function" ? jass.GetUnitX(unit) : 0,
    y: typeof jass.GetUnitY === "function" ? jass.GetUnitY(unit) : 0,
  };
}

/**
 * 检查单位是否有效
 */
export function isValidUnit(unit: any): boolean {
  if (!unit) return false;
  return typeof jass.GetUnitTypeId === "function" && jass.GetUnitTypeId(unit) !== 0;
}

/**
 * 检查单位是否死亡
 */
export function isUnitDead(unit: any): boolean {
  if (!unit) return true;
  if (typeof jass.IsUnitType === "function") {
    return jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD);
  }
  return false;
}

export {};
