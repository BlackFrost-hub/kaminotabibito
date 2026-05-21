/** @noSelfInFile */
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
import { 攻击效果是否在冷却中, 攻击效果进入冷却, 攻击效果开始执行, 攻击效果结束执行, } from "./01．攻击效果状态";
const 普攻监听列表 = [];
const 最终伤害监听列表 = [];
let 最终伤害监听已注册 = false;
function 确保最终伤害监听已注册() {
    if (最终伤害监听已注册)
        return;
    最终伤害监听已注册 = true;
    registerAppliedFinalDamageListener(on最终伤害攻击效果事件);
}
function on最终伤害攻击效果事件(target, attacker, applied, snapshot) {
    if (target == null || target === 0)
        return;
    if (!(applied > 0))
        return;
    const 普攻上下文 = {
        source: attacker ?? null,
        target,
        damage: applied,
        damageType: snapshot != null && snapshot.rawDamageType != null ? snapshot.rawDamageType : 0,
        fromDotTickBatch: false,
        isNormalAttack: snapshot != null && snapshot.isNormalAttack === true,
        snapshot,
    };
    dispatch普攻攻击效果监听器(普攻上下文);
    const ctx = {
        source: attacker ?? null,
        target,
        applied,
        snapshot,
    };
    dispatch最终伤害监听器(ctx);
}
function dispatch普攻攻击效果监听器(ctx) {
    for (let i = 0; i < 普攻监听列表.length; i++) {
        const 实例 = 普攻监听列表[i];
        if (实例 == null)
            continue;
        if (实例.条件 != null && 实例.条件(ctx) === false)
            continue;
        if (ctx.isNormalAttack !== true)
            continue;
        if (攻击效果是否在冷却中(实例.名称, ctx.source, 实例.冷却毫秒 ?? 0))
            continue;
        if (!攻击效果开始执行(实例.名称, ctx.source))
            continue;
        try {
            攻击效果进入冷却(实例.名称, ctx.source);
            实例.命中后(ctx);
        }
        finally {
            攻击效果结束执行(实例.名称, ctx.source);
        }
    }
}
function dispatch最终伤害监听器(ctx) {
    for (let i = 0; i < 最终伤害监听列表.length; i++) {
        const 实例 = 最终伤害监听列表[i];
        if (实例 == null)
            continue;
        if (实例.条件 != null && 实例.条件(ctx) === false)
            continue;
        if (攻击效果是否在冷却中(实例.名称, ctx.source, 实例.冷却毫秒 ?? 0))
            continue;
        if (!攻击效果开始执行(实例.名称, ctx.source))
            continue;
        try {
            攻击效果进入冷却(实例.名称, ctx.source);
            实例.命中后(ctx);
        }
        finally {
            攻击效果结束执行(实例.名称, ctx.source);
        }
    }
}
export function 注册普攻攻击效果监听(参数) {
    if (参数 == null || !参数.名称 || 参数.命中后 == null)
        return;
    普攻监听列表.push(参数);
    确保最终伤害监听已注册();
}
export function 注册最终伤害攻击效果监听(参数) {
    if (参数 == null || !参数.名称 || 参数.命中后 == null)
        return;
    最终伤害监听列表.push(参数);
    确保最终伤害监听已注册();
}
