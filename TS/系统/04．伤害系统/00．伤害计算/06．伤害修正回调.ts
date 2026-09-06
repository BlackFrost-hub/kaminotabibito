/** @noSelfInFile */
/**
 * 伤害修正回调层
 *
 * 职责：
 * - 在最终伤害真正写回事件前，给各系统一个统一的"改伤害"入口
 * - 适合护盾、减伤、易伤、特殊免疫这类需要修改最终伤害的系统
 * - 不适合普通显示/日志/统计；那类仍应走伤害后回调
 */

export interface DamageModifierContext {
  target: any;
  attacker: any;
  originalAttacker?: any;
  baseDamage: number;
  currentDamage: number;
  rawAttackType?: any;
  rawDamageType?: any;
  rawWeaponType?: any;
  effectiveAttackType?: any;
  effectiveDamageType?: any;
  effectiveWeaponType?: any;
  isPhysicalDamage: boolean;
  isMagicDamage: boolean;
  isEnhancedDamage: boolean;
  isTrueDamage: boolean;
  isMetalDamage?: boolean;
  isWoodDamage?: boolean;
  isWaterDamage?: boolean;
  isFireDamage?: boolean;
  isThunderDamage?: boolean;
  isLightDamage?: boolean;
  isDarkDamage?: boolean;
  isNormalAttack: boolean;
  isRangedAttack?: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
  isWrappedSkillDamage?: boolean;
  isEquipmentSkillDamage?: boolean;
  isNonEquipmentSkillDamage?: boolean;
  skillDamageSourceKind?: string;
  equipmentSkillDamageKind?: string;
  itemTypeId?: number;
  itemHandle?: any;
  abilityId?: number;
  skillInstanceId?: number;
  skillDamageTag?: string;
  skillDamageShape?: string;
  isIndependentSkillDamage?: boolean;
  isSingleTargetSkillDamage?: boolean;
  isAoeSkillDamage?: boolean;
  忽略魔法抗性?: boolean;
  isDamageTransfer?: boolean;
}

export type DamageModifier = (this: void, context: DamageModifierContext) => number;

/**
 * 基础伤害修正发生在免疫判定之后、护甲/魔抗计算之前。
 * 适合会改变伤害类型计算基数的附加伤害，不应在这里修改最终乘区。
 */
export interface DamageBaseModifierContext extends DamageModifierContext {}

export type DamageBaseModifier = (this: void, context: DamageBaseModifierContext) => number;

const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; effect2?: number; remaining: number } | null;
};

interface DamageModifierEntry {
  id: number;
  priority: number;
  callback: DamageModifier;
}

const damageModifiers: DamageModifierEntry[] = [];
let nextModifierId = 1;
let vulnerableModifierRegistered = false;

interface DamageBaseModifierEntry {
  id: number;
  priority: number;
  callback: DamageBaseModifier;
}

const damageBaseModifiers: DamageBaseModifierEntry[] = [];
let nextBaseModifierId = 1;

const VULNERABLE_BUFF_ID = "C026";

function sortDamageModifiers(): void {
  damageModifiers.sort((a, b) => {
    if (a.priority !== b.priority) return b.priority - a.priority;
    return a.id - b.id;
  });
}

export function registerDamageModifier(callback: DamageModifier, priority: number = 0): number {
  if (callback == null) return 0;
  const id = nextModifierId;
  nextModifierId = nextModifierId + 1;
  damageModifiers.push({
    id,
    priority,
    callback,
  });
  sortDamageModifiers();
  return id;
}

export function unregisterDamageModifier(id: number): boolean {
  for (let i = 0; i < damageModifiers.length; i++) {
    if (damageModifiers[i].id !== id) continue;
    damageModifiers.splice(i, 1);
    return true;
  }
  return false;
}

/** 护盾吸收修改器（物理/魔法护盾池）的结算优先级，修改器按优先级降序执行。 */
export const 护盾吸收修改器优先级 = 100;

/**
 * 护盾前一次性拦截修改器的默认优先级。
 * 偏折/招架/解析/化解这类"首次攻击防御"必须高于护盾吸收：
 * 否则伤害先被护盾吃满，currentDamage 归零，拦截分支永不触发。
 */
export const 护盾前拦截修改器优先级 = 110;

/**
 * 注册护盾前一次性拦截修改器（偏折/招架/解析/化解这类"首次攻击防御"）。
 * 固定使用护盾前拦截优先级，保证先于任何护盾吸收结算。
 */
export function register护盾前拦截修改器(callback: DamageModifier): number {
  return registerDamageModifier(callback, 护盾前拦截修改器优先级);
}

export function applyDamageModifiers(context: DamageModifierContext): number {
  let currentDamage = context.currentDamage;
  for (let i = 0; i < damageModifiers.length; i++) {
    const entry = damageModifiers[i];
    if (entry == null || entry.callback == null) continue;
    context.currentDamage = currentDamage;
    const nextDamage = entry.callback(context);
    if (typeof nextDamage === "number") {
      currentDamage = nextDamage;
    }
  }
  return currentDamage;
}

function sortDamageBaseModifiers(): void {
  damageBaseModifiers.sort(function sortDamageBaseModifierEntries(a: DamageBaseModifierEntry, b: DamageBaseModifierEntry): number {
    if (a.priority !== b.priority) return b.priority - a.priority;
    return a.id - b.id;
  });
}

export function registerDamageBaseModifier(callback: DamageBaseModifier, priority: number = 0): number {
  if (callback == null) return 0;
  const id = nextBaseModifierId;
  nextBaseModifierId = nextBaseModifierId + 1;
  damageBaseModifiers.push({ id, priority, callback });
  sortDamageBaseModifiers();
  return id;
}

export function unregisterDamageBaseModifier(id: number): boolean {
  for (let i = 0; i < damageBaseModifiers.length; i++) {
    if (damageBaseModifiers[i].id !== id) continue;
    damageBaseModifiers.splice(i, 1);
    return true;
  }
  return false;
}

export function applyDamageBaseModifiers(context: DamageBaseModifierContext): number {
  let currentDamage = context.currentDamage;
  for (let i = 0; i < damageBaseModifiers.length; i++) {
    const entry = damageBaseModifiers[i];
    if (entry == null || entry.callback == null) continue;
    context.currentDamage = currentDamage;
    const nextDamage = entry.callback(context);
    if (typeof nextDamage === "number") currentDamage = nextDamage;
  }
  return currentDamage;
}

export function getDamageBaseModifierCount(): number {
  return damageBaseModifiers.length;
}

export function getDamageModifierCount(): number {
  return damageModifiers.length;
}

function getVulnerableMultiplier(value: number): number {
  if (typeof value !== "number" || !isFinite(value) || value === 0) return 0;
  if (value > -1 && value < 1) return value;
  return value / 100;
}

function onVulnerableDamageModifier(context: DamageModifierContext): number {
  const buffRuntime = getBuffRuntime(context.target, VULNERABLE_BUFF_ID);
  if (buffRuntime == null) return context.currentDamage;
  const bonus = getVulnerableMultiplier(buffRuntime.effect);
  if (bonus <= 0) return context.currentDamage;
  return context.currentDamage * (1 + bonus);
}

function ensureVulnerableModifierRegistered(): void {
  if (vulnerableModifierRegistered) return;
  vulnerableModifierRegistered = true;
  registerDamageModifier(onVulnerableDamageModifier, 20);
}

ensureVulnerableModifierRegistered();

export {};
