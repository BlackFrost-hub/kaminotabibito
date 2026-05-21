/**
 * 泄露审计 - 计时器
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
/** 创建计时器（记得用 destroyTimer 回收），tag 代表来源模块 */
export function createTimer(tag) {
    const t = jass.CreateTimer();
    track("timer", t, tag);
    return t;
}
export function destroyTimer(t) {
    if (!t)
        return;
    untrack("timer", t);
    jass.DestroyTimer(t);
}
