/** @noSelfInFile */
const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readBoolean5, ydlStes_readInteger5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const { 启动周期范围效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.04．周期AOE核心");
const { 施加禁锢, 施加寄生 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.03．禁锢寄生");
const { 应用腐败层数 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.02．腐败层数");
export const 周期范围效果STES事件名 = "PeriodicAoe_Event";
export const 禁锢STES事件名 = "禁锢";
export const 寄生STES事件名 = "寄生";
export const 腐败层数STES事件名 = "DebuffStacks";
function 读取持续原生效果参数() {
    return {
        BuffSource: ydlStes_readUnit5(undefined, "BuffSource"),
        BuffTarget: ydlStes_readUnit5(undefined, "BuffTarget"),
        HitDamage: ydlStes_readReal5(undefined, "HitDamage"),
        DamageInterval: ydlStes_readReal5(undefined, "DamageInterval"),
        time: ydlStes_readReal5(undefined, "time"),
    };
}
export function 根据Stes启动周期范围效果() {
    try {
        ydlStes_syncTriggerStep(undefined);
        启动周期范围效果({
            AoeEffectFileID: ydlStes_readString5(undefined, "AoeEffectFileID"),
            EffectID: ydlStes_readInteger5(undefined, "EffectID"),
            EffectInterval: ydlStes_readReal5(undefined, "EffectInterval"),
            EffectSourceUnit: ydlStes_readUnit5(undefined, "EffectSourceUnit"),
            EffectTime: ydlStes_readReal5(undefined, "EffectTime"),
            r: ydlStes_readReal5(undefined, "r"),
            x: ydlStes_readReal5(undefined, "x"),
            y: ydlStes_readReal5(undefined, "y"),
        });
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
export function 根据Stes施加禁锢() {
    try {
        ydlStes_syncTriggerStep(undefined);
        施加禁锢(读取持续原生效果参数());
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
export function 根据Stes施加寄生() {
    try {
        ydlStes_syncTriggerStep(undefined);
        施加寄生(读取持续原生效果参数());
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
export function 根据Stes应用腐败层数() {
    try {
        ydlStes_syncTriggerStep(undefined);
        应用腐败层数({
            TargetUnit: ydlStes_readUnit5(undefined, "TargetUnit"),
            Stacks: ydlStes_readReal5(undefined, "Stacks"),
            腐败值: ydlStes_readBoolean5(undefined, "腐败值"),
        });
    }
    finally {
        ydlStes_finishChildCleanup(undefined);
    }
}
function on周期范围效果Stes() {
    根据Stes启动周期范围效果();
}
function on禁锢Stes() {
    根据Stes施加禁锢();
}
function on寄生Stes() {
    根据Stes施加寄生();
}
function on腐败层数Stes() {
    根据Stes应用腐败层数();
}
export function 注册周期范围效果Stes桥接() {
    registerStesListener(周期范围效果STES事件名, on周期范围效果Stes);
    registerStesListener(禁锢STES事件名, on禁锢Stes);
    registerStesListener(寄生STES事件名, on寄生Stes);
    registerStesListener(腐败层数STES事件名, on腐败层数Stes);
}
注册周期范围效果Stes桥接();
