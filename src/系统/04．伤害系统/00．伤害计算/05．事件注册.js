/**
 * 伤害计算事件注册
 *
 * 功能：注册伤害事件回调，启动伤害计算系统
 */
const jass = require("jass.common");
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件");
const { onDamageEvent } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
//=============================================================================
// 一、系统状态
//=============================================================================
/** 伤害计算系统是否已初始化 */
let isInitialized = false;
/** 伤害计算系统是否启用 */
let isEnabled = true;
//=============================================================================
// 二、伤害回调
//=============================================================================
/**
 * 伤害事件回调函数
 */
function damageCallback(target, damage, damageType, fromDotTickBatch, source, isNormalAttack) {
    // 系统未启用，跳过
    if (!isEnabled)
        return;
    // DOT伤害跳过（DOT有独立处理）
    if (fromDotTickBatch)
        return;
    // 执行伤害计算
    onDamageEvent(target, source, damage);
}
export const 伤害计算回调 = damageCallback;
//=============================================================================
// 三、系统控制
//=============================================================================
/**
 * 初始化伤害计算系统
 *
 * @param intervalSeconds 重建触发间隔（秒），默认60秒
 */
export function initDamageCalculation(intervalSeconds = 60) {
    if (isInitialized)
        return;
    registerDamageCallback(damageCallback, intervalSeconds);
    isInitialized = true;
}
/**
 * 启用伤害计算系统
 */
export function enableDamageCalculation() {
    isEnabled = true;
}
/**
 * 禁用伤害计算系统
 */
export function disableDamageCalculation() {
    isEnabled = false;
}
/**
 * 检查系统是否已初始化
 */
export function isDamageCalculationInitialized() {
    return isInitialized;
}
/**
 * 检查系统是否启用
 */
export function isDamageCalculationEnabled() {
    return isEnabled;
}
//=============================================================================
// 四、自动初始化
//=============================================================================
// 模块加载时自动初始化
initDamageCalculation(60);
