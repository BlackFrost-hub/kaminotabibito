/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 滚轮函数
 *
 * 约定：
 * - `DzTriggerRegisterMouseWheelEventByCode(..., true, ...)` 直接同步注册
 * - `DzTriggerRegisterMouseWheelEventByCode(..., false, ...)` 必须经过
 *   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
 */
const japi = require("jass.japi");
import { createTriggerOrNull, runFalseLocalRegistration } from "./02．内部工具";
export function getWheelDelta() {
    return japi.DzGetWheelDelta();
}
export function registerMouseWheel(sync, action, playerId) {
    const trig = createTriggerOrNull();
    if (!trig)
        return null;
    if (sync) {
        japi.DzTriggerRegisterMouseWheelEventByCode(trig, true, action);
    }
    else {
        runFalseLocalRegistration(() => {
            japi.DzTriggerRegisterMouseWheelEventByCode(trig, false, action);
        }, playerId);
    }
    return trig;
}
