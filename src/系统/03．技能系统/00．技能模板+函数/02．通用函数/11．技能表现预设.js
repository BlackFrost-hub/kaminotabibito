/** @noSelfInFile */
/**
 * 通用函数 - 技能表现预设
 *
 * 说明：
 * 1. 这里只提供高频可复用的技能表现预设，不承担技能逻辑。
 * 2. 预设分两类：区域预警预设、结果反馈预设。
 * 3. 目标是减少后续技能里反复手写“常见提示圈 + 常见命中/成功/中断特效”。
 */
const jass = require("jass.common");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const { createTimedEffect, createUnitEffect, } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { 创建薄圆形提示圈, 创建白色圆形提示圈, 创建渐变圆形提示圈, 创建双环提示圈, } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效");
const 命中反馈特效 = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl";
const 成功反馈特效 = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl";
const 中断反馈特效 = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl";
const 失败反馈特效 = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl";
export function 创建敌方危险圆圈预设(x, y, 半径, 持续时间, speed) {
    创建薄圆形提示圈(x, y, 半径, 持续时间, speed);
}
export function 创建友方安全圆圈预设(x, y, 半径, 持续时间, speed) {
    创建白色圆形提示圈(x, y, 半径, 持续时间, speed);
}
export function 创建敌方渐变圆圈预设(x, y, 半径, 持续时间, speed) {
    return 创建渐变圆形提示圈(x, y, 半径, 持续时间, speed);
}
export function 创建双环区域预设(x, y, 外圈半径, 持续时间, speed) {
    return 创建双环提示圈(x, y, 外圈半径, 持续时间, speed);
}
export function 播放命中反馈预设(x, y, 持续时间 = 1.0) {
    return createTimedEffect(命中反馈特效, x, y, 0, 持续时间);
}
export function 播放单位命中反馈预设(单位, 持续时间 = 0.8, 挂点 = "origin") {
    if (单位 == null || 单位 === 0)
        return null;
    return createUnitEffect(单位, 挂点, 命中反馈特效, 持续时间, "skill_hit_feedback");
}
export function 播放成功反馈预设(单位, 持续时间 = 1.0, 挂点 = "origin") {
    if (单位 == null || 单位 === 0)
        return null;
    return createUnitEffect(单位, 挂点, 成功反馈特效, 持续时间, "skill_success_feedback");
}
export function 播放中断反馈预设(单位, 持续时间 = 0.8, 挂点 = "origin") {
    if (单位 == null || 单位 === 0)
        return null;
    return createUnitEffect(单位, 挂点, 中断反馈特效, 持续时间, "skill_interrupt_feedback");
}
export function 播放失败反馈预设(单位, 持续时间 = 1.0, 挂点 = "overhead") {
    if (单位 == null || 单位 === 0)
        return null;
    return createUnitEffect(单位, 挂点, 失败反馈特效, 持续时间, "skill_fail_feedback");
}
export function 播放坐标命中反馈预设(X, Y, 持续时间 = 1.0) {
    return 播放命中反馈预设(X, Y, 持续时间);
}
export function 播放单位脚下命中反馈预设(单位, 持续时间 = 1.0) {
    if (单位 == null || 单位 === 0)
        return null;
    return 播放命中反馈预设(GetUnitX(单位), GetUnitY(单位), 持续时间);
}
