/**
 * 漂浮文字系统 - 创建各种浮动文字效果
 *
 * 功能：
 * - 可附着单位（自动跟随）
 * - 可固定坐标
 * - 自定义颜色、透明度、大小
 * - 自定义移动速度
 * - 自动销毁（存在时间）
 */
const jass = require("jass.common");
const { LeakWatcher } = require("系统.00．核心系统.05．泄露审计");
const floatTextQueue = [];
let floatTextRecycleTimer = null;
const RECYCLE_TICK = 0.05; // 20Hz 足够平滑且开销低
function ensureFloatTextRecycleTimer() {
    if (floatTextRecycleTimer != null)
        return;
    if (typeof jass.TimerStart !== "function")
        return;
    floatTextRecycleTimer =
        LeakWatcher && typeof LeakWatcher.createTimer === "function"
            ? LeakWatcher.createTimer("float_text_recycle")
            : jass.CreateTimer?.();
    if (floatTextRecycleTimer == null)
        return;
    jass.TimerStart(floatTextRecycleTimer, RECYCLE_TICK, true, () => {
        // 倒序遍历，便于删除
        for (let i = floatTextQueue.length - 1; i >= 0; i--) {
            const it = floatTextQueue[i];
            it.ticksLeft--;
            if (it.ticksLeft <= 0) {
                const tt = it.tt;
                if (tt) {
                    if (LeakWatcher && typeof LeakWatcher.destroyTextTag === "function")
                        LeakWatcher.destroyTextTag(tt);
                    else if (typeof jass.DestroyTextTag === "function")
                        jass.DestroyTextTag(tt);
                }
                floatTextQueue.splice(i, 1);
            }
        }
        if (floatTextQueue.length === 0) {
            // 停掉并销毁回收 timer
            const t = floatTextRecycleTimer;
            floatTextRecycleTimer = null;
            if (LeakWatcher && typeof LeakWatcher.destroyTimer === "function")
                LeakWatcher.destroyTimer(t);
            else if (typeof jass.DestroyTimer === "function")
                jass.DestroyTimer(t);
        }
    });
}
// 存储最后创建的漂浮文字（替代 bj_lastCreatedTextTag）
export let lastCreatedTextTag = null;
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
        : typeof jass.CreateTextTag === "function"
            ? jass.CreateTextTag()
            : null;
    if (!textTag)
        return null;
    const sizeToHeight = size * 0.0023; // 约等于 TextTagSize2Height(size)，10 -> 0.023
    if (typeof jass.SetTextTagText === "function") {
        jass.SetTextTagText(textTag, text, sizeToHeight);
    }
    if (typeof jass.SetTextTagColor === "function") {
        jass.SetTextTagColor(textTag, red, green, blue, alpha);
    }
    if (targetUnit && typeof jass.SetTextTagPosUnit === "function") {
        jass.SetTextTagPosUnit(textTag, targetUnit, height);
    }
    else if (typeof jass.SetTextTagPos === "function") {
        jass.SetTextTagPos(textTag, x, y, height);
    }
    if (typeof jass.SetTextTagVisibility === "function") {
        jass.SetTextTagVisibility(textTag, true);
    }
    if ((speedX !== 0 || speedY !== 0) && typeof jass.SetTextTagVelocity === "function") {
        jass.SetTextTagVelocity(textTag, speedX, speedY);
    }
    if (!permanent && duration > 0) {
        if (typeof jass.SetTextTagLifespan === "function")
            jass.SetTextTagLifespan(textTag, duration);
        if (typeof jass.SetTextTagFadepoint === "function")
            jass.SetTextTagFadepoint(textTag, duration - 0.5);
        // 统一进入回收队列（避免高频创建时 timer 回调丢失）
        const ticks = Math.max(1, Math.floor(duration / RECYCLE_TICK + 0.999)); // ceil
        floatTextQueue.push({ tt: textTag, ticksLeft: ticks });
        ensureFloatTextRecycleTimer();
    }
    // 记录最后创建的漂浮文字
    lastCreatedTextTag = textTag;
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
/**
 * 销毁漂浮文字
 */
export function DestroyFloatText(textTag) {
    if (!textTag)
        return;
    if (LeakWatcher && typeof LeakWatcher.destroyTextTag === "function") {
        LeakWatcher.destroyTextTag(textTag);
    }
    else if (typeof jass.DestroyTextTag === "function") {
        jass.DestroyTextTag(textTag);
    }
}
/**
 * 设置漂浮文字文字内容
 */
export function SetFloatTextText(textTag, text) {
    if (textTag) {
        jass.SetTextTagText(textTag, text, 0);
    }
}
/**
 * 设置漂浮文字颜色
 */
export function SetFloatTextColor(textTag, red, green, blue, alpha) {
    if (textTag) {
        jass.SetTextTagColor(textTag, red, green, blue, alpha);
    }
}
/**
 * 设置漂浮文字位置（固定坐标）
 */
export function SetFloatTextPosition(textTag, x, y, height) {
    if (textTag) {
        jass.SetTextTagPos(textTag, x, y, height);
    }
}
/**
 * 设置漂浮文字速度
 */
export function SetFloatTextVelocity(textTag, speedX, speedY) {
    if (textTag) {
        jass.SetTextTagVelocity(textTag, speedX, speedY);
    }
}
