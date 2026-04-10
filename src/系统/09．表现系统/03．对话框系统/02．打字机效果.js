const jass = require("jass.common");
// ========== 虚拟分区：常量 ==========
export const STEP_LEN = 2;
export const TICK = 0.03;
// ========== 虚拟分区：进度推进 ==========
export function nextTypingProgress(current, step = STEP_LEN) {
    return current + step;
}
// ========== 虚拟分区：兼容工具 ==========
export function substringCompat(text, start, end) {
    if (typeof jass.SubString === "function")
        return jass.SubString(text, start, end);
    return text.sub(start + 1, end);
}
export function stringLengthCompat(text) {
    if (typeof jass.StringLength === "function")
        return jass.StringLength(text);
    return text.length;
}
