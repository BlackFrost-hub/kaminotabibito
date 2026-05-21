/** @noSelfInFile */
/**
 * 漂浮文字 - 创建漂浮文字
 */
const jass = require("jass.common");
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index");
const { RMaxBJ } = require("lib.扩展函数.BJ函数.12．数学函数");
import { floatTextQueue, ensureFloatTextRecycleTimer, RECYCLE_TICK } from "./01．回收机制";
/**
 * 创建漂浮文字
 * @param targetUnit 目标单位（指定则忽略坐标）
 * @param x X坐标（当targetUnit为null时使用）
 * @param y Y坐标（当targetUnit为null时使用）
 * @param options 文字配置选项
 * @returns 创建的漂浮文字句柄
 */
export function CreateFloatText(targetUnit, x, y, options) {
    const { text, size = 10, red = 255, green = 255, blue = 255, alpha = 0, duration = 1, speedX = 0, speedY = 0.07, height = 0, permanent = false } = options;
    // 使用 common.j 原生 API（CreateTextTagUnitBJ/CreateTextTagLocBJ 在 1.27 Lua 中可能为 nil）
    const textTag = LeakWatcher && typeof LeakWatcher.createTextTag === "function"
        ? LeakWatcher.createTextTag("float_text")
        : jass.CreateTextTag();
    if (!textTag)
        return null;
    const sizeToHeight = size * 0.0023; // 约等于 TextTagSize2Height(size)，10 -> 0.023
    jass.SetTextTagText(textTag, text, sizeToHeight);
    jass.SetTextTagColor(textTag, red, green, blue, alpha);
    if (targetUnit) {
        jass.SetTextTagPosUnit(textTag, targetUnit, height);
    }
    else {
        jass.SetTextTagPos(textTag, x, y, height);
    }
    jass.SetTextTagVisibility(textTag, true);
    if (speedX !== 0 || speedY !== 0) {
        jass.SetTextTagVelocity(textTag, speedX, speedY);
    }
    if (!permanent && duration > 0) {
        jass.SetTextTagLifespan(textTag, duration);
        jass.SetTextTagFadepoint(textTag, duration - 0.5);
        // 统一进入回收队列（避免高频创建时 timer 回调丢失）
        const ticks = RMaxBJ(1, jass.R2I(duration / RECYCLE_TICK + 0.999)); // ceil
        floatTextQueue.push({ tt: textTag, ticksLeft: ticks });
        ensureFloatTextRecycleTimer();
    }
    // 记录最后创建的漂浮文字
    globalThis.lastCreatedTextTag = textTag;
    return textTag;
}
/**
 * 创建漂浮文字（简化版，仅单位）
 */
export function CreateFloatTextOnUnit(unit, text, options) {
    return CreateFloatText(unit, 0, 0, {
        text,
        ...options
    });
}
/**
 * 创建漂浮文字（简化版，仅坐标）
 */
export function CreateFloatTextAtPoint(x, y, text, options) {
    return CreateFloatText(null, x, y, {
        text,
        ...options
    });
}
