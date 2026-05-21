/** @noSelfInFile */
const jass = require("jass.common");
const GetUnitStateJass = jass.GetUnitState;
const SetUnitStateJass = jass.SetUnitState;
const IsUnitType = jass.IsUnitType;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const { HEAL_SYSTEM_ENABLED } = require("系统.04．伤害系统.02．治疗系统.00．常量定义");
const { fireShowDamageEvent } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
const 默认生命减少特效路径 = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl";
const 默认魔法恢复特效路径 = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl";
const 默认魔法减少特效路径 = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl";
function 取绝对值(value) {
    return value < 0 ? -value : value;
}
function 获取当前值(target, resourceType) {
    if (resourceType === "life") {
        return GetUnitStateJass(target, UNIT_STATE_LIFE);
    }
    return GetUnitStateJass(target, UNIT_STATE_MANA);
}
function 获取最大值(target, resourceType) {
    if (resourceType === "life") {
        return GetUnitStateJass(target, UNIT_STATE_MAX_LIFE);
    }
    return GetUnitStateJass(target, UNIT_STATE_MAX_MANA);
}
function 设置当前值(target, resourceType, value) {
    if (resourceType === "life") {
        SetUnitStateJass(target, UNIT_STATE_LIFE, value);
        return;
    }
    SetUnitStateJass(target, UNIT_STATE_MANA, value);
}
function 播放特效(target, resourceType, amount, effectPath, showEffect = false) {
    if (!showEffect || target == null || target === 0) {
        return;
    }
    const path = effectPath != null && effectPath !== ""
        ? effectPath
        : resourceType === "mana"
            ? amount >= 0
                ? 默认魔法恢复特效路径
                : 默认魔法减少特效路径
            : amount < 0
                ? 默认生命减少特效路径
                : "";
    if (path == null || path === "") {
        return;
    }
    const effect = AddSpecialEffectTarget(path, target, "origin");
    if (effect != null && effect !== 0) {
        DestroyEffect(effect);
    }
}
function 显示数值(target, amount, resourceType, showText = true) {
    if (!showText || target == null || target === 0 || amount === 0) {
        return;
    }
    if (resourceType === "life") {
        if (amount >= 0) {
            fireShowDamageEvent(target, amount, 0, 255, 0);
            return;
        }
        fireShowDamageEvent(target, amount, 255, 0, 0);
        return;
    }
    if (amount >= 0) {
        fireShowDamageEvent(target, amount, 0, 100, 255);
        return;
    }
    fireShowDamageEvent(target, amount, 150, 50, 255);
}
export function 变更资源值(target, amount, resourceType, showText = true, showEffect = false, effectPath, lowestValue = 0) {
    if (!HEAL_SYSTEM_ENABLED)
        return 0;
    if (target == null || target === 0)
        return 0;
    if (amount === 0)
        return 0;
    if (IsUnitType(target, UNIT_TYPE_DEAD) === true)
        return 0;
    const currentValue = 获取当前值(target, resourceType);
    const maxValue = 获取最大值(target, resourceType);
    const safeMinValue = lowestValue > 0 ? lowestValue : 0;
    let actualDelta = 0;
    if (amount > 0) {
        const missingValue = maxValue - currentValue;
        actualDelta = amount < missingValue ? amount : missingValue;
    }
    else {
        const maxReduce = currentValue - safeMinValue;
        const reduceAmount = -amount;
        const actualReduce = reduceAmount < maxReduce ? reduceAmount : maxReduce;
        actualDelta = -actualReduce;
    }
    if (actualDelta === 0) {
        return 0;
    }
    设置当前值(target, resourceType, currentValue + actualDelta);
    播放特效(target, resourceType, actualDelta, effectPath, showEffect);
    显示数值(target, actualDelta, resourceType, showText);
    return actualDelta;
}
export function 减少生命值(target, amount, showText = true, showEffect = false, effectPath, 最低保留生命 = 1) {
    return 变更资源值(target, -取绝对值(amount), "life", showText, showEffect, effectPath, 最低保留生命);
}
export function 减少魔法值(target, amount, showText = true, showEffect = false, effectPath) {
    return 变更资源值(target, -取绝对值(amount), "mana", showText, showEffect, effectPath, 0);
}
export function 增加生命值(target, amount, showText = true, showEffect = false, effectPath) {
    return 变更资源值(target, 取绝对值(amount), "life", showText, showEffect, effectPath, 0);
}
export function 增加魔法值(target, amount, showText = true, showEffect = false, effectPath) {
    return 变更资源值(target, 取绝对值(amount), "mana", showText, showEffect, effectPath, 0);
}
