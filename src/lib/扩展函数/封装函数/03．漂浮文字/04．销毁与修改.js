/** @noSelfInFile */
/**
 * 漂浮文字 - 销毁与修改
 */
const jass = require("jass.common");
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index");
const leakDestroyTextTag = LeakWatcher && typeof LeakWatcher.destroyTextTag === "function"
    ? LeakWatcher.destroyTextTag
    : null;
/**
 * 销毁漂浮文字
 */
export function DestroyFloatText(textTag) {
    if (!textTag)
        return;
    // 对 permanent=true / lifespan=0 的文字，先强制改成可回收状态，再销毁。
    jass.SetTextTagPermanent(textTag, false);
    jass.SetTextTagVisibility(textTag, false);
    jass.SetTextTagFadepoint(textTag, 0);
    jass.SetTextTagLifespan(textTag, 0.01);
    if (leakDestroyTextTag != null) {
        leakDestroyTextTag(textTag);
    }
    else {
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
