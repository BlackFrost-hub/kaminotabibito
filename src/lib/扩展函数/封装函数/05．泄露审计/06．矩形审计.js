/**
 * 泄露审计 - 矩形
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
export function trackRect(tag, rect) {
    track("rect", rect, tag);
}
export function removeRect(rect) {
    if (!rect)
        return;
    untrack("rect", rect);
    jass.RemoveRect(rect);
}
