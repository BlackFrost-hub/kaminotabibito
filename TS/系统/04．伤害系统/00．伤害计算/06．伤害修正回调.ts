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
  baseDamage: number;
  currentDamage: number;
  isPhysicalDamage: boolean;
  isMagicDamage: boolean;
  isEnhancedDamage: boolean;
  isTrueDamage: boolean;
  isNormalAttack: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
}

export type DamageModifier = (this: void, context: DamageModifierContext) => number;

interface DamageModifierEntry {
  id: number;
  priority: number;
  callback: DamageModifier;
}

const damageModifiers: DamageModifierEntry[] = [];
let nextModifierId = 1;

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

export function getDamageModifierCount(): number {
  return damageModifiers.length;
}

export {};
