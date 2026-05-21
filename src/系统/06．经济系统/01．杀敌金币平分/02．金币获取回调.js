/** @noSelfInFile */
/**
 * 杀敌金币平分系统 - 金币获取回调
 *
 * 功能：
 * 1. 处理金币获取率加成
 * 2. 直接显示金币数值漂浮文字
 */
const jass = require("jass.common");
const { GOLD_RATE_THRESHOLD, DEFAULT_BLUE, DEFAULT_TEXT_SIZE, } = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义");
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容");
const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { 显示单位数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字");
const { registerGoldGainCallback } = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能");
// ==========================================================================================
// 工具函数
// ==========================================================================================
/** 获取玩家金币获取率 */
function getPlayerGoldRate(player) {
    const rate = YDUserDataGet("player", player, "金币获取率", "real");
    return typeof rate === "number" ? rate : 0;
}
// ==========================================================================================
// 数值显示
// ==========================================================================================
function fireStesEvent(unit, gold) {
    显示单位数值漂浮文字(unit, gold, {
        后缀: "金币",
        大小: DEFAULT_TEXT_SIZE,
        红: 255,
        绿: 215,
        蓝: DEFAULT_BLUE,
        持续时间: 1.25,
    });
}
// ==========================================================================================
// 金币获取回调
// ==========================================================================================
/**
 * 处理金币获取率加成并给予金币
 */
function goldGainCallback(params) {
    const { unit, player, baseGold } = params;
    // 计算金币获取率加成
    const goldRate = getPlayerGoldRate(player);
    let finalGold = baseGold;
    if (goldRate >= GOLD_RATE_THRESHOLD) {
        finalGold = jass.R2I(baseGold * (1 + goldRate));
    }
    // 给予金币
    AdjustPlayerStateBJ(finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD);
    // 直接显示数值，不再绕 STES（STES 只保留给 JASS 调用）
    fireStesEvent(unit, finalGold);
    return finalGold;
}
// ==========================================================================================
// 自动注册
// ==========================================================================================
registerGoldGainCallback(goldGainCallback);
export {};
