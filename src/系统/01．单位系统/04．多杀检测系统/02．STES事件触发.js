/**
 * 多杀检测系统 - STES事件触发
 *
 * 功能：触发JASS端监听的STES事件
 *
 * 后续接手者注意：
 * 1. 此文件专门用于触发JASS端的STES事件
 * 2. 参数名须与JASS端监听器一致
 */
import { MULTI_KILL_EFFECT_EVENT } from "./00．常量定义";
const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件");
// ==========================================================================================
// STES事件触发函数
// ==========================================================================================
/**
 * 触发 OnMultiKillEffectID 事件
 * JASS端监听器会读取以下参数：
 * - EffectID (integer): 效果ID
 * - HealAmount (real): 治疗量
 * - HealTarget (unit): 治疗目标
 * - HealSource (unit): 治疗来源
 */
export function fireMultiKillEffectEvent(params) {
    const stesParams = [
        { type: "integer", name: "EffectID", value: params.effectID },
        { type: "real", name: "HealAmount", value: params.healAmount },
        { type: "unit", name: "HealTarget", value: params.healTarget },
        { type: "unit", name: "HealSource", value: params.healSource },
    ];
    STES_FireWithParams(MULTI_KILL_EFFECT_EVENT, stesParams);
    if (params.diyEvent && params.diyEventString) {
        STES_FireWithParams(params.diyEventString, stesParams);
    }
}
