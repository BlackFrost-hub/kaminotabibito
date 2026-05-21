/** @noSelfInFile */
/**
 * 伤害修正回调层
 *
 * 职责：
 * - 在最终伤害真正写回事件前，给各系统一个统一的"改伤害"入口
 * - 适合护盾、减伤、易伤、特殊免疫这类需要修改最终伤害的系统
 * - 不适合普通显示/日志/统计；那类仍应走伤害后回调
 */
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统");
const damageModifiers = [];
let nextModifierId = 1;
let vulnerableModifierRegistered = false;
const VULNERABLE_BUFF_ID = "C026";
function sortDamageModifiers() {
    damageModifiers.sort((a, b) => {
        if (a.priority !== b.priority)
            return b.priority - a.priority;
        return a.id - b.id;
    });
}
export function registerDamageModifier(callback, priority = 0) {
    if (callback == null)
        return 0;
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
export function unregisterDamageModifier(id) {
    for (let i = 0; i < damageModifiers.length; i++) {
        if (damageModifiers[i].id !== id)
            continue;
        damageModifiers.splice(i, 1);
        return true;
    }
    return false;
}
export function applyDamageModifiers(context) {
    let currentDamage = context.currentDamage;
    for (let i = 0; i < damageModifiers.length; i++) {
        const entry = damageModifiers[i];
        if (entry == null || entry.callback == null)
            continue;
        context.currentDamage = currentDamage;
        const nextDamage = entry.callback(context);
        if (typeof nextDamage === "number") {
            currentDamage = nextDamage;
        }
    }
    return currentDamage;
}
export function getDamageModifierCount() {
    return damageModifiers.length;
}
function getVulnerableMultiplier(value) {
    if (typeof value !== "number" || !isFinite(value) || value === 0)
        return 0;
    if (value > -1 && value < 1)
        return value;
    return value / 100;
}
function onVulnerableDamageModifier(context) {
    const buffRuntime = getBuffRuntime(context.target, VULNERABLE_BUFF_ID);
    if (buffRuntime == null)
        return context.currentDamage;
    const bonus = getVulnerableMultiplier(buffRuntime.effect);
    if (bonus <= 0)
        return context.currentDamage;
    return context.currentDamage * (1 + bonus);
}
function ensureVulnerableModifierRegistered() {
    if (vulnerableModifierRegistered)
        return;
    vulnerableModifierRegistered = true;
    registerDamageModifier(onVulnerableDamageModifier, 20);
}
ensureVulnerableModifierRegistered();
