/**
 * ==========================================================================================
 * 多杀检测系统 - 成功回调
 * ==========================================================================================
 *
 * 【功能】
 * 处理多杀成功后的回调逻辑：
 * 1. 构建效果事件参数
 * 2. 触发治疗效果事件（OnMultiKillEffectID）
 * 3. 显示 effectSource（如果 finish 为 true）
 *
 * 【使用方式】
 * 在 killAllInGroup 成功后调用 onMultiKillSuccess(instance)
 *
 * ==========================================================================================
 */
import { fireMultiKillEffectEvent } from "./02．STES事件触发";
const jass = require("jass.common");
// ==========================================================================================
// 辅助函数
// ==========================================================================================
/**
 * 构建效果事件参数
 */
function buildEffectParams(instance) {
    return {
        effectID: instance.effectID,
        healAmount: instance.healAmount,
        healTarget: instance.healTarget,
        healSource: instance.healSource,
        diyEvent: instance.diyEvent,
        diyEventString: instance.diyEventString,
    };
}
// ==========================================================================================
// 成功回调函数
// ==========================================================================================
/**
 * 多杀成功后的回调处理
 * @param instance 监控实例
 */
export function onMultiKillSuccess(instance) {
    // 触发治疗效果事件
    fireMultiKillEffectEvent(buildEffectParams(instance));
    // 如果 Finish 为 true，显示 effectSource（让隐藏的母体单位重新出现）
    if (instance.finish && instance.effectSource != null) {
        jass.ShowUnit(instance.effectSource, true);
    }
}
